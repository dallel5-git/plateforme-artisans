import type { AvailabilityStatus } from '@repo/db';

import {
  computeRankingScore,
  type GeoMatch,
  type RankingBreakdown,
  type RankingWeights,
} from './ranking.js';

export interface CandidateForScoring {
  id: string;
  isVerified: boolean;
  ratingAvg: number;
  ratingCount: number;
  completionScore: number;
  availabilityStatus: AvailabilityStatus;
  lastActiveAt: Date | null;
  coverageAreas: Array<{ governorateId: string; delegationId: string | null }>;
}

export interface ScoredCandidate<T> {
  id: string;
  candidate: T;
  score: number;
  breakdown: RankingBreakdown;
}

// BE-16 : aucune source de donnée en S1 pour ces deux termes — pas de modèle Subscription/plan
// payant assigné à ProviderProfile (arrive avec BE-32, S2+), aucun modèle de pénalité/
// signalement dans le schéma. Constantes nommées plutôt que des littéraux épars, pour qu'un
// futur BE-32 (ou équivalent) les retrouve d'un `grep`.
export const DEFAULT_PLAN_BOOST_FACTOR = 1.0;
export const DEFAULT_PENALTY_SCORE = 0;

/**
 * `geoMatch` (BE-15) n'est pas une propriété fixe d'un artisan : elle dépend de quel
 * gouvernorat/délégation le client recherche, comparé à ses `CoverageArea`. 'adjacent' n'est
 * jamais renvoyé ici : aucune source de donnée d'adjacence entre gouvernorats dans ce schéma
 * (ni relation, ni heuristique de distance) — décision de périmètre BE-16, documentée.
 */
export function deriveGeoMatch(
  coverageAreas: Array<{ governorateId: string; delegationId: string | null }>,
  governorateId: string,
  delegationId?: string,
): GeoMatch {
  const exactDelegation =
    delegationId !== undefined &&
    coverageAreas.some((a) => a.governorateId === governorateId && a.delegationId === delegationId);
  return exactDelegation ? 'delegation' : 'governorate';
}

const AVAILABILITY_FACTOR: Record<AvailabilityStatus, number> = {
  AVAILABLE: 1,
  BUSY: 0.6,
  ON_HOLIDAY: 0,
};

const RECENCY_FULL_SCORE_DAYS = 1;
const RECENCY_ZERO_SCORE_DAYS = 30;

/**
 * ⚠️ Formule non spécifiée ailleurs dans le dépôt (Annexe A ne donne pas de formule de
 * réactivité) — assumée ici : décroissance linéaire de 1 à 0 entre J+1 et J+30 d'inactivité,
 * multipliée par un facteur de disponibilité déclarée. À valider avec le produit/tech-lead ;
 * documentée comme hypothèse, pas comme spec figée.
 */
export function deriveResponsivenessScore(
  lastActiveAt: Date | null,
  availabilityStatus: AvailabilityStatus,
  now: Date,
): number {
  if (!lastActiveAt) return 0;

  const daysSince = (now.getTime() - lastActiveAt.getTime()) / 86_400_000;
  const recency =
    daysSince <= RECENCY_FULL_SCORE_DAYS
      ? 1
      : daysSince >= RECENCY_ZERO_SCORE_DAYS
        ? 0
        : 1 -
          (daysSince - RECENCY_FULL_SCORE_DAYS) /
            (RECENCY_ZERO_SCORE_DAYS - RECENCY_FULL_SCORE_DAYS);

  return recency * AVAILABILITY_FACTOR[availabilityStatus];
}

/**
 * Score chaque candidat via `computeRankingScore` (BE-15) et trie décroissant par score, id
 * croissant en cas d'égalité — même convention que `buildKeysetOrderBy` (packages/db), pour
 * que la pagination (query-builder.ts) reste prévisible.
 */
export function scoreCandidates<T extends CandidateForScoring>(
  candidates: T[],
  weights: RankingWeights,
  geoQuery: { governorateId: string; delegationId?: string },
  seed: number,
  now: Date,
): ScoredCandidate<T>[] {
  return candidates
    .map((candidate) => {
      const { score, breakdown } = computeRankingScore(
        {
          geoMatch: deriveGeoMatch(
            candidate.coverageAreas,
            geoQuery.governorateId,
            geoQuery.delegationId,
          ),
          // ratingAvg (Decimal(3,2)) × ratingCount approxime ratingSum, qui n'est pas une
          // colonne stockée — écart maximal négligeable (≤ ratingCount × 0.005) sur un lissage
          // bayésien C=8 ; ajouter une colonne ratingSum dédiée est hors périmètre BE-16.
          ratingSum: Math.round(candidate.ratingAvg * candidate.ratingCount),
          ratingCount: candidate.ratingCount,
          isVerified: candidate.isVerified,
          completionScore: candidate.completionScore,
          responsivenessScore: deriveResponsivenessScore(
            candidate.lastActiveAt,
            candidate.availabilityStatus,
            now,
          ),
          planBoostFactor: DEFAULT_PLAN_BOOST_FACTOR,
          penaltyScore: DEFAULT_PENALTY_SCORE,
        },
        weights,
        { providerId: candidate.id, seed },
      );
      return { id: candidate.id, candidate, score, breakdown };
    })
    .sort((a, b) => (b.score !== a.score ? b.score - a.score : a.id.localeCompare(b.id)));
}
