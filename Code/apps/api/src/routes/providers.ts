import { randomUUID } from 'node:crypto';

import {
  PROVIDER_PROFILE_ALREADY_EXISTS,
  PROVIDER_PROFILE_INCOMPLETE,
  PROVIDER_PROFILE_NOT_FOUND,
  UNAUTHORIZED,
  VALIDATION_ERROR,
} from '@repo/constants';
import {
  calculateCompletionScore,
  DomainError,
  hashRefreshToken,
  MIN_PUBLICATION_COMPLETION_SCORE,
  REFRESH_TTL_DAYS,
  signAccessToken,
} from '@repo/core';
import {
  addUserRole,
  createProviderProfile,
  createSession,
  findProviderProfileBySlug,
  findProviderProfileByUserId,
  findUserById,
  listCoverageAreas,
  listProviderCategories,
  updateProviderProfile,
  type ProviderProfileOwnerView,
} from '@repo/db';
import { normalizePhoneTn, slugify } from '@repo/utils';
import {
  createProviderMeResponseSchema,
  createProviderMeSchema,
  updateProviderMeResponseSchema,
  updateProviderMeSchema,
} from '@repo/validators';
import type { FastifyInstance, FastifyRequest } from 'fastify';
import type { ZodTypeProvider } from 'fastify-type-provider-zod';

function requireNormalizedPhone(phone: string): string {
  const normalized = normalizePhoneTn(phone);
  if (!normalized) {
    throw new DomainError(VALIDATION_ERROR, 'Numéro de téléphone invalide', { field: 'phone' });
  }
  return normalized;
}

// Boucle de disponibilité, pas une règle métier (P3) : `slug`, `slug-2`, `slug-3`… jusqu'à
// trouver un slug libre. Reste dans `apps/api` plutôt que `packages/db` pour ne pas ajouter
// `@repo/utils` (slugify) comme dépendance de `@repo/db` — `apps/api` dépend déjà des deux.
async function generateUniqueProviderSlug(base: string): Promise<string> {
  const slugBase = slugify(base);
  let candidate = slugBase;
  let attempt = 1;

  while (await findProviderProfileBySlug(candidate)) {
    attempt += 1;
    candidate = `${slugBase}-${attempt}`;
  }

  return candidate;
}

async function issueProviderSession(userId: string, request: FastifyRequest) {
  const tokenId = randomUUID();
  const userAgent = request.headers['user-agent'];
  const session = await createSession({
    userId,
    refreshTokenHash: hashRefreshToken(tokenId),
    expiresAt: new Date(Date.now() + REFRESH_TTL_DAYS * 24 * 60 * 60_000),
    userAgent: typeof userAgent === 'string' ? userAgent : undefined,
  });

  return {
    accessToken: await signAccessToken({ sub: userId, role: 'PROVIDER' }),
    refreshToken: `${session.id}.${tokenId}`,
  };
}

async function requireOwnProfile(userId: string): Promise<ProviderProfileOwnerView> {
  const profile = await findProviderProfileByUserId(userId);
  if (!profile) {
    throw new DomainError(PROVIDER_PROFILE_NOT_FOUND, 'Profil artisan introuvable');
  }
  return profile;
}

export async function providerRoutes(app: FastifyInstance): Promise<void> {
  const typedApp = app.withTypeProvider<ZodTypeProvider>();

  typedApp.post(
    '/providers/me',
    {
      preHandler: [app.requireAuth],
      schema: {
        description:
          "Crée le profil artisan de l'utilisateur authentifié. Le promeut PROVIDER s'il ne " +
          "l'est pas déjà (US-P-01 : devenir prestataire sans créer un second compte) et émet " +
          'un nouveau couple de tokens reflétant ce rôle.',
        body: createProviderMeSchema,
        response: { 200: createProviderMeResponseSchema },
      },
    },
    async (request) => {
      if (!request.user) {
        throw new DomainError(UNAUTHORIZED, 'Non authentifié');
      }

      const user = await findUserById(request.user.sub);
      if (!user) {
        throw new DomainError(UNAUTHORIZED, 'Utilisateur introuvable');
      }

      const existingProfile = await findProviderProfileByUserId(user.id);
      if (existingProfile) {
        throw new DomainError(
          PROVIDER_PROFILE_ALREADY_EXISTS,
          'Un profil artisan existe déjà pour cet utilisateur',
        );
      }

      const body = request.body;
      const whatsappPhone = body.whatsappPhone ? requireNormalizedPhone(body.whatsappPhone) : undefined;
      const publicPhone = body.publicPhone ? requireNormalizedPhone(body.publicPhone) : undefined;
      const slug = await generateUniqueProviderSlug(body.businessName);

      const { score } = calculateCompletionScore({
        phoneVerified: user.phoneVerifiedAt !== null,
        bio: body.bio ?? null,
        headline: body.headline ?? null,
        yearsExperience: body.yearsExperience ?? null,
        hasContactPhone: Boolean(whatsappPhone ?? publicPhone),
        categoryCount: 0,
        coverageAreaCount: 0,
      });

      await createProviderProfile({
        userId: user.id,
        slug,
        businessName: body.businessName,
        headline: body.headline,
        bio: body.bio,
        yearsExperience: body.yearsExperience,
        whatsappPhone,
        publicPhone,
        spokenLanguages: body.spokenLanguages,
        baseGovernorateId: body.baseGovernorateId,
        baseDelegationId: body.baseDelegationId,
        completionScore: score,
      });

      if (!user.roles.includes('PROVIDER')) {
        await addUserRole(user.id, 'PROVIDER');
      }

      const tokens = await issueProviderSession(user.id, request);
      const provider = await requireOwnProfile(user.id);

      return { ...tokens, provider };
    },
  );

  typedApp.patch(
    '/providers/me',
    {
      preHandler: [app.requireRole('PROVIDER')],
      schema: {
        description:
          "Met à jour le profil artisan de l'utilisateur authentifié. `completionScore` est " +
          'recalculé à chaque appel ; publier (`publicationStatus: PUBLISHED`) est refusé sous ' +
          '60 % de complétude, avec la liste des champs manquants.',
        body: updateProviderMeSchema,
        response: { 200: updateProviderMeResponseSchema },
      },
    },
    async (request) => {
      if (!request.user) {
        throw new DomainError(UNAUTHORIZED, 'Non authentifié');
      }

      const current = await requireOwnProfile(request.user.sub);
      const user = await findUserById(request.user.sub);
      if (!user) {
        throw new DomainError(UNAUTHORIZED, 'Utilisateur introuvable');
      }

      const body = request.body;
      const whatsappPhone =
        body.whatsappPhone !== undefined ? requireNormalizedPhone(body.whatsappPhone) : undefined;
      const publicPhone =
        body.publicPhone !== undefined ? requireNormalizedPhone(body.publicPhone) : undefined;

      const mergedBio = body.bio ?? current.bio;
      const mergedHeadline = body.headline ?? current.headline;
      const mergedYearsExperience = body.yearsExperience ?? current.yearsExperience;
      const mergedHasContactPhone = Boolean(
        (whatsappPhone ?? current.whatsappPhone) || (publicPhone ?? current.publicPhone),
      );

      const [categories, coverageAreas] = await Promise.all([
        listProviderCategories(current.id),
        listCoverageAreas(current.id),
      ]);

      const { score, missingFields } = calculateCompletionScore({
        phoneVerified: user.phoneVerifiedAt !== null,
        bio: mergedBio,
        headline: mergedHeadline,
        yearsExperience: mergedYearsExperience,
        hasContactPhone: mergedHasContactPhone,
        categoryCount: categories.length,
        coverageAreaCount: coverageAreas.length,
      });

      if (body.publicationStatus === 'PUBLISHED' && score < MIN_PUBLICATION_COMPLETION_SCORE) {
        throw new DomainError(
          PROVIDER_PROFILE_INCOMPLETE,
          `Complétude insuffisante pour publier le profil (${score} % < ${MIN_PUBLICATION_COMPLETION_SCORE} %)`,
          { completionScore: score, missingFields },
        );
      }

      await updateProviderProfile(current.id, {
        businessName: body.businessName,
        headline: body.headline,
        bio: body.bio,
        yearsExperience: body.yearsExperience,
        whatsappPhone,
        publicPhone,
        availabilityStatus: body.availabilityStatus,
        availableAgainAt: body.availableAgainAt,
        acceptsEmergency: body.acceptsEmergency,
        workingHours: body.workingHours,
        publicationStatus: body.publicationStatus,
        completionScore: score,
      });

      return requireOwnProfile(request.user.sub);
    },
  );
}
