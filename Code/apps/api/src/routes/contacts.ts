import { NOT_FOUND, PROVIDER_CONTACT_CHANNEL_UNAVAILABLE, VALIDATION_ERROR } from '@repo/constants';
import {
  buildContactEventLog,
  buildContactHistoryListItem,
  buildSessionFingerprint,
  buildWhatsAppMessage,
  DEDUP_WINDOW_MINUTES,
  DomainError,
  requirePublishedProfile,
  shouldDeduplicate,
  type CoreContactChannel,
} from '@repo/core';
import {
  createContactEvent,
  findCategoriesByIds,
  findProviderProfileById,
  findProviderProfilesByIds,
  findRecentContactEventByFingerprint,
  incrementProviderStats,
  InvalidCursorError,
  listContactEventsForClient,
  revealProviderContactPhone,
  withTransaction,
  type ContactChannel as PrismaContactChannel,
} from '@repo/db';
import {
  contactEventHistoryListResponseSchema,
  contactEventResponseSchema,
  contactEventsQuerySchema,
  createContactEventSchema,
  type ContactEventHistoryListResponse,
  type ContactEventResponse,
  type ContactEventsQuery,
  type CreateContactEventBody,
} from '@repo/validators';
import type { FastifyBaseLogger, FastifyInstance, FastifyRequest } from 'fastify';
import type { ZodTypeProvider } from 'fastify-type-provider-zod';

import { enforceContactEventRateLimit } from '../plugins/rate-limit.js';

const CORE_TO_PRISMA_CHANNEL: Record<CoreContactChannel, PrismaContactChannel> = {
  PHONE: 'PHONE_CALL',
  WHATSAPP: 'WHATSAPP',
};

// IN_APP_MESSAGE est hors périmètre BE-21 : un événement existant sur ce canal ne dédupliquera
// donc jamais contre une nouvelle requête PHONE/WHATSAPP (shouldDeduplicate compare les canaux).
function toCoreChannel(channel: PrismaContactChannel): CoreContactChannel | null {
  if (channel === 'PHONE_CALL') return 'PHONE';
  if (channel === 'WHATSAPP') return 'WHATSAPP';
  return null;
}

function resolveLocale(request: FastifyRequest): 'fr' | 'ar' {
  const header = request.headers['accept-language'];
  return typeof header === 'string' && header.toLowerCase().startsWith('ar') ? 'ar' : 'fr';
}

function resolvePhone(
  phones: { whatsappPhone: string | null; publicPhone: string | null },
  channel: CoreContactChannel,
): string {
  const phone = channel === 'WHATSAPP' ? phones.whatsappPhone : phones.publicPhone;
  if (!phone) {
    throw new DomainError(
      PROVIDER_CONTACT_CHANNEL_UNAVAILABLE,
      "Ce prestataire n'a pas renseigné de numéro pour ce canal",
      { channel },
    );
  }
  return phone;
}

async function resolveCategoryName(
  categoryId: string | undefined,
  locale: 'fr' | 'ar',
): Promise<string> {
  if (!categoryId) {
    return locale === 'ar' ? 'خدمة' : 'un service';
  }
  const [category] = await findCategoriesByIds([categoryId]);
  if (!category) {
    throw new DomainError(NOT_FOUND, 'Catégorie introuvable', { field: 'categoryId' });
  }
  return locale === 'ar' ? category.nameAr : category.nameFr;
}

interface ContactEventContext {
  userId?: string;
  deviceId: string;
  ip: string;
  locale: 'fr' | 'ar';
  log: FastifyBaseLogger;
}

async function handleCreateContactEvent(
  body: CreateContactEventBody,
  context: ContactEventContext,
): Promise<ContactEventResponse> {
  const identityKey = context.userId ?? '';
  const fingerprint = buildSessionFingerprint({
    userId: identityKey,
    deviceId: context.deviceId,
    ip: context.ip,
  });

  await enforceContactEventRateLimit({
    identityKey: identityKey || fingerprint,
    ip: context.ip,
  });

  const provider = requirePublishedProfile(await findProviderProfileById(body.providerId));
  const phones = await revealProviderContactPhone(provider.id);
  const phone = resolvePhone(phones ?? { whatsappPhone: null, publicPhone: null }, body.channel);
  const categoryName = await resolveCategoryName(body.categoryId, context.locale);

  const since = new Date(Date.now() - DEDUP_WINDOW_MINUTES * 60_000);
  const last = await findRecentContactEventByFingerprint(fingerprint, since);
  const dedup = shouldDeduplicate({
    lastEventAt: last?.createdAt ?? null,
    now: new Date(),
    providerId: provider.id,
    fingerprint,
    lastFingerprint: last ? fingerprint : null,
    channel: body.channel,
    lastChannel: last ? toCoreChannel(last.channel) : null,
    lastProviderId: last?.providerId,
  });

  const contactEventId =
    dedup && last
      ? last.id
      : await withTransaction(async (tx) => {
          const created = await createContactEvent(
            {
              providerId: provider.id,
              clientId: context.userId,
              categoryId: body.categoryId,
              channel: CORE_TO_PRISMA_CHANNEL[body.channel],
              sourceScreen: body.sourceScreen,
              sessionHash: fingerprint,
              isSuspicious: false,
            },
            tx,
          );
          await incrementProviderStats(provider.id, { contacts: 1 }, tx);
          return created.id;
        });

  context.log.info(
    buildContactEventLog({
      providerId: provider.id,
      channel: body.channel,
      revealedPhone: phone,
      fingerprint,
    }),
  );

  return {
    contactEventId,
    providerId: provider.id,
    channel: body.channel,
    phone,
    whatsappMessage:
      body.channel === 'WHATSAPP'
        ? buildWhatsAppMessage({
            locale: context.locale,
            providerName: provider.businessName,
            categoryName,
          })
        : undefined,
    deduplicated: dedup,
  };
}

// BE-45 : historique de lecture (US-C-09). Même patron que `loadFavoritesPage`
// (apps/api/src/routes/favorites.ts, BE-25c) — hydratation par lots (providers + catégories)
// pour éviter le N+1, un item dont le prestataire aurait disparu entre-temps (cascade FK, ne
// devrait jamais arriver) est silencieusement omis plutôt que de faire échouer toute la page.
async function loadContactHistoryPage(
  clientId: string,
  query: ContactEventsQuery,
  locale: 'fr' | 'ar',
): Promise<ContactEventHistoryListResponse> {
  try {
    const page = await listContactEventsForClient(clientId, query);
    const providerIds = [...new Set(page.items.map((event) => event.providerId))];
    const categoryIds = [
      ...new Set(page.items.flatMap((event) => (event.categoryId ? [event.categoryId] : []))),
    ];

    const [providers, categories] = await Promise.all([
      findProviderProfilesByIds(providerIds),
      findCategoriesByIds(categoryIds),
    ]);
    const providersById = new Map(providers.map((provider) => [provider.id, provider]));
    const categoryNameById = new Map(
      categories.map((category) => [
        category.id,
        locale === 'ar' ? category.nameAr : category.nameFr,
      ]),
    );

    const items = page.items.flatMap((event) => {
      const provider = providersById.get(event.providerId);
      const channel = toCoreChannel(event.channel);
      if (!provider || !channel) return [];
      const categoryName = event.categoryId
        ? (categoryNameById.get(event.categoryId) ?? null)
        : null;
      return [buildContactHistoryListItem(event, provider, categoryName, channel)];
    });

    return { items, nextCursor: page.nextCursor };
  } catch (error) {
    if (error instanceof InvalidCursorError) {
      throw new DomainError(VALIDATION_ERROR, 'Curseur de pagination invalide', {
        field: 'cursor',
      });
    }
    throw error;
  }
}

export async function contactsRoutes(app: FastifyInstance): Promise<void> {
  const typedApp = app.withTypeProvider<ZodTypeProvider>();

  typedApp.post(
    '/contact-events',
    {
      // BE-21 : accepte authentifié ET anonyme (empreinte de session) — tryAuth, pas requireAuth.
      preHandler: [app.tryAuth],
      schema: {
        tags: ['contact-events'],
        description:
          "Révèle le numéro d'un prestataire et trace l'événement (P9). Canal PHONE ou WHATSAPP " +
          'uniquement. Déduplique deux clics de la même session sur le même artisan/canal en ' +
          '30 min. Rate-limit 30/j par identité et par IP.',
        body: createContactEventSchema,
        response: { 200: contactEventResponseSchema },
      },
    },
    async (request) => {
      const deviceIdHeader = request.headers['x-device-id'];
      return handleCreateContactEvent(request.body, {
        userId: request.user?.sub,
        deviceId: typeof deviceIdHeader === 'string' ? deviceIdHeader : '',
        ip: request.ip,
        locale: resolveLocale(request),
        log: request.log,
      });
    },
  );

  typedApp.get(
    '/contact-events',
    {
      preHandler: [app.requireAuth],
      schema: {
        tags: ['contact-events'],
        description:
          'Historique des contacts du client authentifié (US-C-09), trié par date décroissante, ' +
          "pagination par curseur. Chaque item porte déjà les libellés d'affichage (P3, pas de " +
          'second appel GET /providers/:slug côté mobile) et `hasReview` pour le CTA de dépôt ' +
          "d'avis (FM-31).",
        querystring: contactEventsQuerySchema,
        response: { 200: contactEventHistoryListResponseSchema },
      },
    },
    async (request) =>
      loadContactHistoryPage(request.user!.sub, request.query, resolveLocale(request)),
  );
}
