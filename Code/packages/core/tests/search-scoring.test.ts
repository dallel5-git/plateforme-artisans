/**
 * BE-16 — `packages/core/src/search/scoring.ts`
 *
 * Pure : dérive `geoMatch`/`responsivenessScore` à partir de données déjà chargées, puis
 * appelle `computeRankingScore` (BE-15) par candidat. Aucun accès base ni réseau.
 */
import { describe, expect, it } from 'vitest';
import {
  deriveGeoMatch,
  deriveResponsivenessScore,
  scoreCandidates,
  DEFAULT_PENALTY_SCORE,
  DEFAULT_PLAN_BOOST_FACTOR,
  type CandidateForScoring,
} from '../src/search/scoring.js';
import type { RankingWeights } from '../src/search/ranking.js';

describe('BE-16 — deriveGeoMatch', () => {
  it("'delegation' si une CoverageArea couvre exactement la délégation demandée", () => {
    const areas = [{ governorateId: 'g1', delegationId: 'd1' }];
    expect(deriveGeoMatch(areas, 'g1', 'd1')).toBe('delegation');
  });

  it("'governorate' si seule une couverture « tout le gouvernorat » (delegationId null) existe", () => {
    const areas = [{ governorateId: 'g1', delegationId: null }];
    expect(deriveGeoMatch(areas, 'g1', 'd1')).toBe('governorate');
  });

  it("'governorate' si la recherche ne précise pas de délégation", () => {
    const areas = [{ governorateId: 'g1', delegationId: 'd2' }];
    expect(deriveGeoMatch(areas, 'g1', undefined)).toBe('governorate');
  });

  it("ne renvoie jamais 'adjacent' — aucune source de donnée d'adjacence dans ce ticket", () => {
    const areas = [{ governorateId: 'g1', delegationId: 'd9' }]; // délégation différente
    expect(deriveGeoMatch(areas, 'g1', 'd1')).not.toBe('adjacent');
  });
});

describe('BE-16 — deriveResponsivenessScore', () => {
  const now = new Date('2026-08-21T12:00:00Z');

  it('ON_HOLIDAY donne toujours 0, quelle que soit la dernière activité', () => {
    expect(deriveResponsivenessScore(now, 'ON_HOLIDAY', now)).toBe(0);
  });

  it('jamais actif (lastActiveAt null) donne 0', () => {
    expect(deriveResponsivenessScore(null, 'AVAILABLE', now)).toBe(0);
  });

  it('actif à l’instant et AVAILABLE → 1', () => {
    expect(deriveResponsivenessScore(now, 'AVAILABLE', now)).toBe(1);
  });

  it('BUSY plafonne à 0.6 même en cas d’activité très récente', () => {
    expect(deriveResponsivenessScore(now, 'BUSY', now)).toBeCloseTo(0.6, 5);
  });

  it('décroît avec l’ancienneté et atteint 0 à 30 jours d’inactivité', () => {
    const old = new Date(now.getTime() - 30 * 86_400_000);
    expect(deriveResponsivenessScore(old, 'AVAILABLE', now)).toBe(0);
  });

  it('reste à 0 au-delà de 30 jours (pas de valeur négative)', () => {
    const veryOld = new Date(now.getTime() - 90 * 86_400_000);
    expect(deriveResponsivenessScore(veryOld, 'AVAILABLE', now)).toBe(0);
  });

  it('valeur intermédiaire strictement entre 0 et 1 pour une activité de quelques jours', () => {
    const someDaysAgo = new Date(now.getTime() - 10 * 86_400_000);
    const score = deriveResponsivenessScore(someDaysAgo, 'AVAILABLE', now);
    expect(score).toBeGreaterThan(0);
    expect(score).toBeLessThan(1);
  });
});

describe('BE-16 — scoreCandidates', () => {
  const weights: RankingWeights = {
    w1Geo: 0.3,
    w2Rating: 0.25,
    w3Trust: 0.15,
    w4Completion: 0.1,
    w5Responsiveness: 0.1,
    w6Plan: 0.1,
    w7Penalty: 0.2,
  };

  function candidate(
    o: Partial<CandidateForScoring> & Pick<CandidateForScoring, 'id'>,
  ): CandidateForScoring {
    return {
      isVerified: false,
      ratingAvg: 0,
      ratingCount: 0,
      completionScore: 0,
      availabilityStatus: 'AVAILABLE',
      lastActiveAt: null,
      coverageAreas: [{ governorateId: 'g1', delegationId: null }],
      ...o,
    };
  }

  const geoQuery = { governorateId: 'g1' };
  const now = new Date('2026-08-21T12:00:00Z');

  it('trie par score décroissant puis id croissant à score égal', () => {
    const results = scoreCandidates(
      [
        candidate({ id: 'b', isVerified: true }),
        candidate({ id: 'a', isVerified: true }),
        candidate({ id: 'c', isVerified: false }),
      ],
      weights,
      geoQuery,
      1,
      now,
    );
    // 'a' et 'b' sont vérifiés (score identique), 'c' ne l'est pas (score plus bas).
    expect(results.map((r) => r.id)).toEqual(['a', 'b', 'c']);
  });

  it('planBoostFactor et penaltyScore par défaut ne varient jamais (pas de source S1)', () => {
    const [result] = scoreCandidates([candidate({ id: 'a' })], weights, geoQuery, 1, now);
    expect(result!.breakdown.plan).toBeCloseTo(weights.w6Plan * DEFAULT_PLAN_BOOST_FACTOR, 10);
    expect(result!.breakdown.penalty).toBeCloseTo(weights.w7Penalty * DEFAULT_PENALTY_SCORE, 10);
  });

  it('chaque résultat conserve une référence au candidat original', () => {
    const original = candidate({ id: 'a' });
    const [result] = scoreCandidates([original], weights, geoQuery, 1, now);
    expect(result!.candidate).toBe(original);
  });
});
