import { INTERNAL_ERROR, NOT_FOUND, VALIDATION_ERROR } from '@repo/constants';
import {
  buildSearchSeed,
  DomainError,
  InvalidSearchCursorError,
  paginateScoredResults,
  parseRankingWeights,
  scoreCandidates,
  type NormalizedSearchFilters,
  type RankingWeights,
  type ScoredCandidate,
} from '@repo/core';
import {
  findAppSetting,
  findCategoryBySlug,
  findDelegationBySlug,
  findGovernorateBySlug,
  searchProviderProfiles,
  type SearchCandidate,
} from '@repo/db';
import {
  providerSearchQuerySchema,
  providerSearchResponseSchema,
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
}
