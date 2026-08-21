/**
 * BE-15 — Validation des poids de ranking · `packages/core/src/search/ranking.ts`
 *
 * Additif au TDD initial de ranking.test.ts : couvre `parseRankingWeights`, qui valide la
 * forme d'un `AppSetting.value` avant `computeRankingScore` (voir
 * packages/db/src/repositories/app-setting.repository.ts — « packages/core validera la forme
 * des poids de ranking »).
 */
import { describe, it, expect } from 'vitest';
import { parseRankingWeights } from '../src/search/ranking.js';

describe('BE-15 — parseRankingWeights', () => {
  const poidsValides = {
    w1Geo: 0.35,
    w2Rating: 0.25,
    w3Trust: 0.15,
    w4Completion: 0.1,
    w5Responsiveness: 0.05,
    w6Plan: 0.1,
    w7Penalty: 0.2,
  };

  it('accepte un objet aux 7 champs numériques attendus', () => {
    expect(parseRankingWeights(poidsValides)).toEqual(poidsValides);
  });

  it('rejette un objet avec un champ manquant ou non numérique', () => {
    const champManquant: Record<string, number> = {
      w1Geo: 0.35,
      w2Rating: 0.25,
      w3Trust: 0.15,
      w4Completion: 0.1,
      w5Responsiveness: 0.05,
      w6Plan: 0.1,
      // w7Penalty volontairement absent
    };

    expect(parseRankingWeights(champManquant)).toBeNull();
    expect(parseRankingWeights({ ...poidsValides, w3Trust: '0.15' })).toBeNull();
  });

  it('rejette une valeur qui n’est pas un objet (null, tableau, primitif)', () => {
    expect(parseRankingWeights(null)).toBeNull();
    expect(parseRankingWeights([poidsValides])).toBeNull();
    expect(parseRankingWeights('poids')).toBeNull();
  });
});
