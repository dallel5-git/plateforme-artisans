/**
 * BE-47 — `packages/core/src/providers/offerings.ts`
 *
 * Pure : valide un `ServiceOffering` avant écriture (titre non vide, prix positif). Aucun accès
 * base ni réseau — la relation `providerId`/`categoryId` reste vérifiée côté route (P3).
 */
import { describe, expect, it } from 'vitest';
import { validateOfferingInput } from '../src/providers/offerings.js';

describe('BE-47 — validateOfferingInput', () => {
  it('accepte un titre non vide et des prix positifs', () => {
    expect(() =>
      validateOfferingInput({ titleFr: 'Débouchage évier', priceMin: 30, priceMax: 60 }),
    ).not.toThrow();
  });

  it("accepte l'absence de prix (sur devis)", () => {
    expect(() =>
      validateOfferingInput({ titleFr: 'Devis climatisation', priceMin: null, priceMax: null }),
    ).not.toThrow();
  });

  it('rejette un titre vide', () => {
    expect(() => validateOfferingInput({ titleFr: '   ' })).toThrow(/titre/i);
  });

  it('rejette un prix minimum négatif ou nul', () => {
    expect(() => validateOfferingInput({ titleFr: 'Peinture', priceMin: 0 })).toThrow(/positif/i);
    expect(() => validateOfferingInput({ titleFr: 'Peinture', priceMin: -10 })).toThrow(/positif/i);
  });

  it('rejette un prix maximum négatif ou nul', () => {
    expect(() => validateOfferingInput({ titleFr: 'Peinture', priceMax: -5 })).toThrow(/positif/i);
  });

  it('rejette priceMin > priceMax', () => {
    expect(() =>
      validateOfferingInput({ titleFr: 'Plomberie', priceMin: 100, priceMax: 50 }),
    ).toThrow(/maximum/i);
  });
});
