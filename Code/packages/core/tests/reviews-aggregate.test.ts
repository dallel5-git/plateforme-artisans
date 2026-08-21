/**
 * BE-17 — `packages/core/src/reviews/aggregate.ts`
 *
 * Pure : parse le `reviewCountByStar` (Json? Prisma, `unknown`) déjà dénormalisé sur
 * ProviderProfile. Ne renvoie jamais `null` — une valeur absente/malformée retombe sur un
 * breakdown à zéro plutôt que de faire échouer la lecture d'une fiche publique.
 */
import { describe, expect, it } from 'vitest';
import { buildReviewAggregate, parseReviewCountByStar } from '../src/reviews/aggregate.js';

describe('BE-17 — parseReviewCountByStar', () => {
  it('renvoie un breakdown à zéro pour `null`', () => {
    expect(parseReviewCountByStar(null)).toEqual({ '1': 0, '2': 0, '3': 0, '4': 0, '5': 0 });
  });

  it('renvoie un breakdown à zéro pour `undefined`', () => {
    expect(parseReviewCountByStar(undefined)).toEqual({ '1': 0, '2': 0, '3': 0, '4': 0, '5': 0 });
  });

  it('renvoie un breakdown à zéro pour une chaîne (forme invalide)', () => {
    expect(parseReviewCountByStar('oops')).toEqual({ '1': 0, '2': 0, '3': 0, '4': 0, '5': 0 });
  });

  it('renvoie un breakdown à zéro pour un tableau (forme invalide)', () => {
    expect(parseReviewCountByStar([1, 2, 3])).toEqual({ '1': 0, '2': 0, '3': 0, '4': 0, '5': 0 });
  });

  it('passe telles quelles les valeurs bien formées', () => {
    expect(parseReviewCountByStar({ '1': 0, '2': 1, '3': 2, '4': 5, '5': 10 })).toEqual({
      '1': 0,
      '2': 1,
      '3': 2,
      '4': 5,
      '5': 10,
    });
  });

  it('défaut à 0 pour une clé manquante', () => {
    expect(parseReviewCountByStar({ '5': 3 })).toEqual({ '1': 0, '2': 0, '3': 0, '4': 0, '5': 3 });
  });

  it('défaut à 0 pour une valeur négative ou non numérique', () => {
    expect(parseReviewCountByStar({ '1': -5, '2': 'deux', '3': NaN })).toEqual({
      '1': 0,
      '2': 0,
      '3': 0,
      '4': 0,
      '5': 0,
    });
  });
});

describe('BE-17 — buildReviewAggregate', () => {
  it('assemble average/count/breakdown', () => {
    expect(buildReviewAggregate(4.5, 12, { '4': 4, '5': 8 })).toEqual({
      average: 4.5,
      count: 12,
      breakdown: { '1': 0, '2': 0, '3': 0, '4': 4, '5': 8 },
    });
  });
});
