import { buildSessionFingerprint, requirePublishedProfile, resolveViewDate } from '@repo/core';
import {
  createProfileView,
  findProviderProfileById,
  incrementDailyProviderStat,
  incrementProviderStats,
  withTransaction,
} from '@repo/db';
import { createProfileViewSchema } from '@repo/validators';
import type { FastifyInstance } from 'fastify';
import type { ZodTypeProvider } from 'fastify-type-provider-zod';

import { enforceProfileViewRateLimit } from '../plugins/rate-limit.js';

export async function profileViewsRoutes(app: FastifyInstance): Promise<void> {
  const typedApp = app.withTypeProvider<ZodTypeProvider>();

  typedApp.post(
    '/profile-views',
    {
      // BE-23 : accepte authentifié ET anonyme (empreinte de session) — tryAuth, même geste que
      // POST /contact-events (BE-21) : un visiteur non connecté doit pouvoir déclencher une vue.
      preHandler: [app.tryAuth],
      schema: {
        description:
          "Trace la vue d'un profil artisan (P9). Déduplique par empreinte de session sur un " +
          'jour calendaire UTC (une vue = une ligne par session et par jour) et met à jour ' +
          "l'agrégat journalier DailyProviderStat. Rate-limit 200/j par identité et par IP.",
        body: createProfileViewSchema,
      },
    },
    async (request, reply) => {
      const deviceIdHeader = request.headers['x-device-id'];
      const identityKey = request.user?.sub ?? '';
      const fingerprint = buildSessionFingerprint({
        userId: identityKey,
        deviceId: typeof deviceIdHeader === 'string' ? deviceIdHeader : '',
        ip: request.ip,
      });

      await enforceProfileViewRateLimit({
        identityKey: identityKey || fingerprint,
        ip: request.ip,
      });

      const provider = requirePublishedProfile(
        await findProviderProfileById(request.body.providerId),
      );
      const viewDate = resolveViewDate(new Date());

      await withTransaction(async (tx) => {
        const { isNew } = await createProfileView(
          {
            providerId: provider.id,
            viewerId: request.user?.sub,
            sessionHash: fingerprint,
            viewDate,
            source: request.body.source,
          },
          tx,
        );

        await incrementDailyProviderStat(
          {
            providerId: provider.id,
            date: viewDate,
            profileViewsDelta: 1,
            uniqueProfileViewsDelta: isNew ? 1 : 0,
          },
          tx,
        );

        if (isNew) {
          await incrementProviderStats(provider.id, { profileViews: 1 }, tx);
        }
      });

      reply.code(204);
    },
  );
}
