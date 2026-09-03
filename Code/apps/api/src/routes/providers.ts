import { randomUUID } from 'node:crypto';

import {
  FORBIDDEN,
  INTERNAL_ERROR,
  MEDIA_NOT_FOUND,
  NOT_FOUND,
  PROVIDER_PROFILE_ALREADY_EXISTS,
  PROVIDER_PROFILE_INCOMPLETE,
  PROVIDER_PROFILE_NOT_FOUND,
  REVIEW_REQUIRES_CONTACT,
  UNAUTHORIZED,
  VALIDATION_ERROR,
} from '@repo/constants';
import {
  buildProviderStats,
  buildPublicProviderProfile,
  buildReviewAuthorDisplayName,
  buildReviewEligibilityWindow,
  buildSearchSeed,
  calculateCompletionScore,
  can,
  DomainError,
  FREE_PLAN_MAX_CATEGORIES,
  FREE_PLAN_MAX_GOVERNORATES,
  FREE_PLAN_MAX_PORTFOLIO_ITEMS,
  hashRefreshToken,
  InvalidSearchCursorError,
  MIN_PUBLICATION_COMPLETION_SCORE,
  paginateScoredResults,
  parseRankingWeights,
  REFRESH_TTL_DAYS,
  requirePublishedProfile,
  resolveProviderStatsRange,
  scoreCandidates,
  signAccessToken,
  type NormalizedSearchFilters,
  type RankingWeights,
  type ScoredCandidate,
} from '@repo/core';
import {
  addPortfolioItem,
  addUserRole,
  createProviderProfile,
  createReview,
  createSession,
  DuplicateReviewError,
  findAppSetting,
  findCategoriesByIds,
  findCategoryBySlug,
  findDelegationBySlug,
  findDelegationsByIds,
  findEligibleContactEventForReview,
  findGovernorateBySlug,
  findGovernoratesByIds,
  findMediaAssetById,
  findMediaAssetsByIds,
  findProviderProfileById,
  findProviderProfileBySlug,
  findProviderProfileByUserId,
  findUserById,
  InvalidCursorError,
  listContactEventTimestampsForProvider,
  listCoverageAreas,
  listDailyProviderStats,
  listPortfolioItems,
  listProviderCategories,
  listPublishedReviewsForProvider,
  listServiceOfferings,
  lockProviderProfileForReviewWrite,
  recomputeRatingAggregate,
  removePortfolioItem,
  replaceCoverageAreas,
  replaceProviderCategories,
  searchProviderProfiles,
  updateProviderProfile,
  withTransaction,
  type ProviderProfileOwnerView,
  type PublicReviewListItem,
  type SearchCandidate,
} from '@repo/db';
import { normalizePhoneTn, slugify } from '@repo/utils';
import {
  attachPortfolioItemSchema,
  createProviderMeResponseSchema,
  createProviderMeSchema,
  createProviderReviewBodySchema,
  portfolioItemIdParamsSchema,
  portfolioItemResponseSchema,
  providerIdParamsSchema,
  providerMeSchema,
  providerPublicProfileSchema,
  providerReviewCreateResponseSchema,
  providerReviewListResponseSchema,
  providerReviewsQuerySchema,
  providerSearchQuerySchema,
  providerSearchResponseSchema,
  providerSlugParamsSchema,
  providerStatsResponseSchema,
  putProviderCategoriesResponseSchema,
  putProviderCategoriesSchema,
  putProviderCoverageAreasResponseSchema,
  putProviderCoverageAreasSchema,
  updateProviderMeResponseSchema,
  updateProviderMeSchema,
  type CreateProviderReviewBody,
  type ProviderReviewsQuery,
  type ProviderSearchQuery,
} from '@repo/validators';
import type { FastifyInstance, FastifyRequest } from 'fastify';
import type { ZodTypeProvider } from 'fastify-type-provider-zod';

import { enforceReviewRateLimit } from '../plugins/rate-limit.js';

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

const RANKING_WEIGHTS_KEY = 'ranking.weights';

async function requireOrNotFound<T>(
  promise: Promise<T | null>,
  field: string,
  message: string,
): Promise<T> {
  const result = await promise;
  if (!result) {
    throw new DomainError(NOT_FOUND, message, { field });
  }
  return result;
}

async function resolveSearchFilters(query: ProviderSearchQuery): Promise<NormalizedSearchFilters> {
  const governorate = await requireOrNotFound(
    findGovernorateBySlug(query.governorate),
    'governorate',
    'Gouvernorat introuvable',
  );

  const [category, delegation] = await Promise.all([
    query.category
      ? requireOrNotFound(findCategoryBySlug(query.category), 'category', 'Catégorie introuvable')
      : undefined,
    query.delegation
      ? requireOrNotFound(
          findDelegationBySlug(governorate.id, query.delegation),
          'delegation',
          'Délégation introuvable',
        )
      : undefined,
  ]);

  return {
    categoryId: category?.id,
    governorateId: governorate.id,
    delegationId: delegation?.id,
    verified: query.verified,
    minRating: query.minRating,
    availabilityStatus: query.availability,
  };
}

// Poids JAMAIS en dur (CLAUDE.md, BE-15) : un AppSetting absent ou malformé est un incident de
// config à surfacer bruyamment (500), pas un repli silencieux vers des valeurs codées en dur.
async function loadRankingWeights() {
  const setting = await findAppSetting(RANKING_WEIGHTS_KEY);
  const weights = setting ? parseRankingWeights(setting.value) : null;
  if (!weights) {
    throw new DomainError(INTERNAL_ERROR, 'AppSetting "ranking.weights" absent ou invalide');
  }
  return weights;
}

function paginateOrThrow<T extends { id: string; score: number }>(
  sorted: T[],
  limit: number,
  cursor: string | undefined,
) {
  try {
    return paginateScoredResults(sorted, limit, cursor);
  } catch (error) {
    if (error instanceof InvalidSearchCursorError) {
      throw new DomainError(VALIDATION_ERROR, 'Curseur de pagination invalide', {
        field: 'cursor',
      });
    }
    throw error;
  }
}

async function buildSearchPage(
  query: ProviderSearchQuery,
  filters: NormalizedSearchFilters,
  weights: RankingWeights,
) {
  const candidates = await searchProviderProfiles(filters);
  const now = new Date();
  const scored = scoreCandidates(candidates, weights, filters, buildSearchSeed(filters, now), now);
  return paginateOrThrow(scored, query.limit, query.cursor);
}

function toResultItem(scored: ScoredCandidate<SearchCandidate>, debug: boolean) {
  const { candidate, score, breakdown } = scored;
  return {
    id: candidate.id,
    slug: candidate.slug,
    businessName: candidate.businessName,
    headline: candidate.headline,
    isVerified: candidate.isVerified,
    ratingAvg: candidate.ratingAvg,
    ratingCount: candidate.ratingCount,
    completionScore: candidate.completionScore,
    availabilityStatus: candidate.availabilityStatus,
    categories: candidate.categories,
    ...(debug ? { score, matchReason: breakdown } : {}),
  };
}

// BE-17 : assemblage de la fiche publique. `requirePublishedProfile` (@repo/core) garantit le
// 404 (jamais 403) sur un profil non PUBLISHED — pas de `if` métier ici. Les hydratations par
// lots (BE-17b) évitent le N+1 sur catégories/gouvernorats/délégations/médias.
async function loadPublicProfile(slug: string) {
  const profile = requirePublishedProfile(await findProviderProfileBySlug(slug));

  const [categoryLinks, offerings, coverageAreas, portfolioItems] = await Promise.all([
    listProviderCategories(profile.id),
    listServiceOfferings(profile.id),
    listCoverageAreas(profile.id),
    listPortfolioItems(profile.id),
  ]);

  const categoryIds = [
    ...new Set([
      ...categoryLinks.map((c) => c.categoryId),
      ...offerings.map((o) => o.categoryId),
      ...portfolioItems.flatMap((p) => (p.categoryId ? [p.categoryId] : [])),
    ]),
  ];
  const governorateIds = [
    ...new Set([profile.baseGovernorateId, ...coverageAreas.map((a) => a.governorateId)]),
  ];
  const delegationIds = [
    ...new Set(
      [profile.baseDelegationId, ...coverageAreas.map((a) => a.delegationId)].flatMap((id) =>
        id ? [id] : [],
      ),
    ),
  ];
  const mediaIds = portfolioItems.map((p) => p.mediaId);

  const [categories, governorates, delegations, media] = await Promise.all([
    findCategoriesByIds(categoryIds),
    findGovernoratesByIds(governorateIds),
    findDelegationsByIds(delegationIds),
    findMediaAssetsByIds(mediaIds),
  ]);

  return buildPublicProviderProfile({
    profile,
    categoryLinks,
    categoriesById: new Map(categories.map((c) => [c.id, c])),
    offerings,
    coverageAreas,
    governoratesById: new Map(governorates.map((g) => [g.id, g])),
    delegationsById: new Map(delegations.map((d) => [d.id, d])),
    portfolioItems,
    mediaById: new Map(media.map((m) => [m.id, m])),
    reviewCountByStarRaw: profile.reviewCountByStar,
  });
}

function toReviewListItem(review: PublicReviewListItem) {
  return {
    id: review.id,
    rating: review.rating,
    comment: review.comment,
    isVerifiedContact: review.isVerifiedContact,
    createdAt: review.createdAt,
    authorDisplayName: buildReviewAuthorDisplayName(review.client),
  };
}

// BE-18 : liste des avis publiés d'un artisan. Même garde `requirePublishedProfile` que
// `loadPublicProfile` (BE-17) : un slug inexistant et un profil non publié doivent rester
// indistinguables (404 dans les deux cas) — sinon cette page fuiterait l'existence d'un profil
// non publié (200 vide) alors que la fiche elle-même 404. `InvalidCursorError` (@repo/db) est
// mappé en VALIDATION_ERROR, même geste que `paginateOrThrow` pour `InvalidSearchCursorError`
// côté recherche — deux mécanismes de curseur distincts.
async function loadReviewsPage(slug: string, query: ProviderReviewsQuery) {
  const profile = requirePublishedProfile(await findProviderProfileBySlug(slug));
  try {
    const page = await listPublishedReviewsForProvider(profile.id, query);
    return { items: page.items.map(toReviewListItem), nextCursor: page.nextCursor };
  } catch (error) {
    if (error instanceof InvalidCursorError) {
      throw new DomainError(VALIDATION_ERROR, 'Curseur de pagination invalide', {
        field: 'cursor',
      });
    }
    throw error;
  }
}

function toPortfolioItemResponse(item: {
  id: string;
  mediaId: string;
  categoryId: string | null;
  caption: string | null;
  sortOrder: number;
}) {
  return {
    id: item.id,
    mediaId: item.mediaId,
    categoryId: item.categoryId,
    caption: item.caption,
    sortOrder: item.sortOrder,
  };
}

// BE-22 : dépôt d'avis rattaché à un contact réel. Sélection automatique du ContactEvent côté
// serveur (jamais de contactEventId côté client) : le plus récent, non encore avisé, dans la
// fenêtre d'éligibilité US-C-06 (>12h et <60j). Garde-fou anti-auto-avis applicatif ici — le
// trigger SQL prevent_self_review (BE-02) reste le filet de dernier recours, celui-ci évite un
// aller-retour DB inutile pour le cas courant (l'issue #26 précise « pas seulement par
// l'application », donc les deux mécanismes coexistent délibérément).
async function handleCreateProviderReview(
  providerId: string,
  clientId: string,
  body: CreateProviderReviewBody,
) {
  await enforceReviewRateLimit(clientId);

  const provider = requirePublishedProfile(await findProviderProfileById(providerId));
  if (provider.userId === clientId) {
    throw new DomainError(FORBIDDEN, 'Un prestataire ne peut pas évaluer son propre profil');
  }

  const window = buildReviewEligibilityWindow();
  const contact = await findEligibleContactEventForReview(provider.id, clientId, window);
  if (!contact) {
    throw new DomainError(REVIEW_REQUIRES_CONTACT, 'Aucun contact éligible pour un avis');
  }

  try {
    return await withTransaction(async (tx) => {
      await lockProviderProfileForReviewWrite(provider.id, tx);
      const review = await createReview(
        {
          providerId: provider.id,
          clientId,
          contactEventId: contact.id,
          rating: body.rating,
          comment: body.comment,
        },
        tx,
      );
      await recomputeRatingAggregate(provider.id, tx);
      return review;
    });
  } catch (error) {
    if (error instanceof DuplicateReviewError) {
      throw new DomainError(REVIEW_REQUIRES_CONTACT, 'Ce contact a déjà un avis');
    }
    throw error;
  }
}

export async function providersRoutes(app: FastifyInstance): Promise<void> {
  const typedApp = app.withTypeProvider<ZodTypeProvider>();

  typedApp.get(
    '/providers/search',
    {
      // public : recherche ouverte, aucune authentification requise.
      schema: {
        description:
          'Recherche d’artisans : catégorie/gouvernorat/délégation/vérifié/note/disponibilité, tri par score de ranking calculé, pagination par curseur. Mode debug via ?debug=true.',
        querystring: providerSearchQuerySchema,
        response: { 200: providerSearchResponseSchema },
      },
    },
    async (request) => {
      const query = request.query;
      const [filters, weights] = await Promise.all([
        resolveSearchFilters(query),
        loadRankingWeights(),
      ]);
      const page = await buildSearchPage(query, filters, weights);

      return {
        items: page.items.map((s) => toResultItem(s, query.debug ?? false)),
        nextCursor: page.nextCursor,
      };
    },
  );

  typedApp.get(
    '/providers/:slug',
    {
      // public : fiche artisan publique, aucune authentification requise (BE-17).
      schema: {
        description:
          'Fiche artisan publique — profil, catégories, offres tarifées, zones de couverture, galerie, agrégat d’avis. Jamais de numéro de téléphone (voir POST /contact-events, BE-21).',
        params: providerSlugParamsSchema,
        response: { 200: providerPublicProfileSchema },
      },
    },
    async (request) => loadPublicProfile(request.params.slug),
  );

  typedApp.get(
    '/providers/:slug/reviews',
    {
      // public : liste d'avis publiée, aucune authentification requise (BE-18).
      schema: {
        description:
          'Avis PUBLISHED d’un artisan, triés par date décroissante, pagination par curseur. ' +
          'Nom de l’auteur anonymisé ("Utilisateur supprimé") si le compte a été supprimé. ' +
          'Sous-notes et réponse de l’artisan hors périmètre (voir backlog).',
        params: providerSlugParamsSchema,
        querystring: providerReviewsQuerySchema,
        response: { 200: providerReviewListResponseSchema },
      },
    },
    async (request) => loadReviewsPage(request.params.slug, request.query),
  );

  typedApp.post(
    '/providers/:id/reviews',
    {
      preHandler: [app.requireAuth],
      schema: {
        description:
          'Dépose un avis rattaché à un ContactEvent réel (BE-22, P9/P10). Sélection automatique ' +
          'du contact éligible (>12h, <60j, pas déjà avisé) — 403 REVIEW_REQUIRES_CONTACT sinon. ' +
          "Auto-évaluation rejetée. Publié immédiatement (pas de filtrage anti-spam pour l'instant).",
        params: providerIdParamsSchema,
        body: createProviderReviewBodySchema,
        response: { 200: providerReviewCreateResponseSchema },
      },
    },
    async (request) =>
      handleCreateProviderReview(request.params.id, request.user!.sub, request.body),
  );

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
      const whatsappPhone = body.whatsappPhone
        ? requireNormalizedPhone(body.whatsappPhone)
        : undefined;
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

  typedApp.get(
    '/providers/me',
    {
      preHandler: [app.requireRole('PROVIDER')],
      schema: {
        description:
          "Profil artisan complet de l'utilisateur authentifié (vue propriétaire : mêmes " +
          'champs que la fiche publique, plus les champs privés utiles à l’édition — ' +
          'availabilityStatus, availableAgainAt, acceptsEmergency, workingHours, ' +
          'publicationStatus, completionScore). BE-44.',
        response: { 200: providerMeSchema },
      },
    },
    async (request) => {
      if (!request.user) {
        throw new DomainError(UNAUTHORIZED, 'Non authentifié');
      }

      return requireOwnProfile(request.user.sub);
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

  typedApp.put(
    '/providers/me/categories',
    {
      preHandler: [app.requireRole('PROVIDER')],
      schema: {
        description:
          'Remplace tout le set de catégories de l’artisan authentifié (une seule ' +
          `catégorie principale, exactement un \`isPrimary: true\`). Limite du plan FREE : ` +
          `${FREE_PLAN_MAX_CATEGORIES} catégories. \`completionScore\` recalculé.`,
        body: putProviderCategoriesSchema,
        response: { 200: putProviderCategoriesResponseSchema },
      },
    },
    async (request) => {
      if (!request.user) {
        throw new DomainError(UNAUTHORIZED, 'Non authentifié');
      }

      const { categories } = request.body;
      if (categories.length > FREE_PLAN_MAX_CATEGORIES) {
        throw new DomainError(
          VALIDATION_ERROR,
          `Maximum ${FREE_PLAN_MAX_CATEGORIES} catégories en offre gratuite`,
          { limit: FREE_PLAN_MAX_CATEGORIES, field: 'categories' },
        );
      }

      const current = await requireOwnProfile(request.user.sub);
      const user = await findUserById(request.user.sub);
      if (!user) {
        throw new DomainError(UNAUTHORIZED, 'Utilisateur introuvable');
      }

      const coverageAreas = await listCoverageAreas(current.id);

      const { score } = calculateCompletionScore({
        phoneVerified: user.phoneVerifiedAt !== null,
        bio: current.bio,
        headline: current.headline,
        yearsExperience: current.yearsExperience,
        hasContactPhone: Boolean(current.whatsappPhone || current.publicPhone),
        categoryCount: categories.length,
        coverageAreaCount: coverageAreas.length,
      });

      const updatedCategories = await withTransaction(async (tx) => {
        const links = await replaceProviderCategories(current.id, categories, tx);
        await updateProviderProfile(current.id, { completionScore: score }, tx);
        return links;
      });

      return { categories: updatedCategories, completionScore: score };
    },
  );

  typedApp.put(
    '/providers/me/coverage-areas',
    {
      preHandler: [app.requireRole('PROVIDER')],
      schema: {
        description:
          "Remplace tout le set de zones d'intervention de l'artisan authentifié. " +
          `\`delegationId\` absent = tout le gouvernorat. Limite du plan FREE : ` +
          `${FREE_PLAN_MAX_GOVERNORATES} gouvernorat distinct (plusieurs délégations du même ` +
          "gouvernorat ne comptent qu'une fois). `completionScore` recalculé.",
        body: putProviderCoverageAreasSchema,
        response: { 200: putProviderCoverageAreasResponseSchema },
      },
    },
    async (request) => {
      if (!request.user) {
        throw new DomainError(UNAUTHORIZED, 'Non authentifié');
      }

      const { coverageAreas } = request.body;
      const distinctGovernorates = new Set(coverageAreas.map((area) => area.governorateId)).size;
      if (distinctGovernorates > FREE_PLAN_MAX_GOVERNORATES) {
        throw new DomainError(
          VALIDATION_ERROR,
          `Maximum ${FREE_PLAN_MAX_GOVERNORATES} gouvernorat en offre gratuite`,
          { limit: FREE_PLAN_MAX_GOVERNORATES, field: 'coverageAreas' },
        );
      }

      const current = await requireOwnProfile(request.user.sub);
      const user = await findUserById(request.user.sub);
      if (!user) {
        throw new DomainError(UNAUTHORIZED, 'Utilisateur introuvable');
      }

      const categories = await listProviderCategories(current.id);

      const { score } = calculateCompletionScore({
        phoneVerified: user.phoneVerifiedAt !== null,
        bio: current.bio,
        headline: current.headline,
        yearsExperience: current.yearsExperience,
        hasContactPhone: Boolean(current.whatsappPhone || current.publicPhone),
        categoryCount: categories.length,
        coverageAreaCount: coverageAreas.length,
      });

      const updatedCoverageAreas = await withTransaction(async (tx) => {
        const areas = await replaceCoverageAreas(current.id, coverageAreas, tx);
        await updateProviderProfile(current.id, { completionScore: score }, tx);
        return areas;
      });

      return { coverageAreas: updatedCoverageAreas, completionScore: score };
    },
  );

  typedApp.post(
    '/providers/me/portfolio',
    {
      preHandler: [app.requireRole('PROVIDER')],
      schema: {
        description:
          'Rattache au profil artisan un `MediaAsset` déjà traité (`POST /v1/media/:id/process`, ' +
          `BE-20c) — le média doit appartenir à l'appelant et être \`APPROVED\`. Limite du plan ` +
          `FREE : ${FREE_PLAN_MAX_PORTFOLIO_ITEMS} photos (US-P-04).`,
        body: attachPortfolioItemSchema,
        response: { 200: portfolioItemResponseSchema },
      },
    },
    async (request) => {
      if (!request.user) {
        throw new DomainError(UNAUTHORIZED, 'Non authentifié');
      }

      const current = await requireOwnProfile(request.user.sub);
      const existingItems = await listPortfolioItems(current.id);
      if (existingItems.length >= FREE_PLAN_MAX_PORTFOLIO_ITEMS) {
        throw new DomainError(
          VALIDATION_ERROR,
          `Maximum ${FREE_PLAN_MAX_PORTFOLIO_ITEMS} photos en offre gratuite`,
          { limit: FREE_PLAN_MAX_PORTFOLIO_ITEMS, field: 'mediaId' },
        );
      }

      const media = await findMediaAssetById(request.body.mediaId);
      if (!media) {
        throw new DomainError(MEDIA_NOT_FOUND, 'Média introuvable');
      }
      if (!media.uploadedById || !can(request.user, 'update', { ownerId: media.uploadedById })) {
        throw new DomainError(FORBIDDEN, "Ce média n'appartient pas à l'utilisateur authentifié");
      }
      if (media.moderationStatus !== 'APPROVED') {
        throw new DomainError(
          VALIDATION_ERROR,
          "Le média doit être traité (POST /v1/media/:id/process) avant d'être rattaché au portfolio",
          { field: 'mediaId' },
        );
      }

      const item = await addPortfolioItem(
        current.id,
        media.id,
        request.body.categoryId,
        request.body.caption,
        existingItems.length,
      );

      return toPortfolioItemResponse(item);
    },
  );

  typedApp.delete(
    '/providers/me/portfolio/:id',
    {
      preHandler: [app.requireRole('PROVIDER')],
      schema: {
        description: "Détache un élément de la galerie de l'artisan authentifié.",
        params: portfolioItemIdParamsSchema,
      },
    },
    async (request, reply) => {
      if (!request.user) {
        throw new DomainError(UNAUTHORIZED, 'Non authentifié');
      }

      const current = await requireOwnProfile(request.user.sub);
      const items = await listPortfolioItems(current.id);
      const item = items.find((candidate) => candidate.id === request.params.id);
      if (!item) {
        throw new DomainError(NOT_FOUND, 'Élément de portfolio introuvable', { field: 'id' });
      }

      await removePortfolioItem(item.id);
      reply.code(204);
    },
  );

  typedApp.get(
    '/providers/me/stats',
    {
      preHandler: [app.requireRole('PROVIDER')],
      schema: {
        description:
          "Tableau de bord de l'artisan authentifié (US-P-07/US-P-08) : totaux et série " +
          'journalière sur 30 jours (vues, vues dédupliquées, contacts, ratio vue→contact), ' +
          'jours à zéro inclus. `searchImpressions`/`avgSearchPosition` sont absents : aucun ' +
          "module `search` n'existe encore pour les alimenter (BE-43).",
        response: { 200: providerStatsResponseSchema },
      },
    },
    async (request) => {
      if (!request.user) {
        throw new DomainError(UNAUTHORIZED, 'Non authentifié');
      }

      const current = await requireOwnProfile(request.user.sub);
      const range = resolveProviderStatsRange(new Date());

      const [dailyStats, contactEvents] = await Promise.all([
        listDailyProviderStats(current.id, range),
        listContactEventTimestampsForProvider(current.id, range),
      ]);

      return buildProviderStats(
        dailyStats,
        contactEvents.map((event) => ({ createdAt: event.createdAt, channel: event.channel })),
        range,
      );
    },
  );
}
