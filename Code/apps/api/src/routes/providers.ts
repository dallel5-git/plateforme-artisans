import { INTERNAL_ERROR, NOT_FOUND, VALIDATION_ERROR } from '@repo/constants';
import {
  buildPublicProviderProfile,
  buildSearchSeed,
  DomainError,
  InvalidSearchCursorError,
  paginateScoredResults,
  parseRankingWeights,
  requirePublishedProfile,
  scoreCandidates,
  type NormalizedSearchFilters,
  type RankingWeights,
  type ScoredCandidate,
} from '@repo/core';
import {
  findAppSetting,
  findCategoriesByIds,
  findCategoryBySlug,
  findDelegationBySlug,
  findDelegationsByIds,
  findGovernorateBySlug,
  findGovernoratesByIds,
  findMediaAssetsByIds,
  findProviderProfileBySlug,
  listCoverageAreas,
  listPortfolioItems,
  listProviderCategories,
  listServiceOfferings,
  searchProviderProfiles,
  type SearchCandidate,
} from '@repo/db';
import {
  providerPublicProfileSchema,
  providerSearchQuerySchema,
  providerSearchResponseSchema,
  providerSlugParamsSchema,
  type ProviderSearchQuery,
} from '@repo/validators';
import type { FastifyInstance } from 'fastify';
import type { ZodTypeProvider } from 'fastify-type-provider-zod';

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
}
