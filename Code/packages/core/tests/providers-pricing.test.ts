/**
 * BE-17 — `packages/core/src/providers/pricing.ts`
 *
 * Pure : formate un `ServiceOffering.priceMin/priceMax/priceUnit` (Decimal TND, pas millimes —
 * écart hérité de BE-02/05) en `displayPrice` FR. Aucun accès base ni réseau.
 */
import { describe, expect, it } from 'vitest';
import { formatDisplayPrice } from '../src/providers/pricing.js';

describe('BE-17 — formatDisplayPrice', () => {
  it('« Sur devis » si priceUnit === ON_QUOTE, même avec des montants renseignés', () => {
    expect(formatDisplayPrice({ priceMin: 50, priceMax: 100, priceUnit: 'ON_QUOTE' })).toBe(
      'Sur devis',
    );
  });

  it('« Sur devis » si priceMin et priceMax sont tous les deux null', () => {
    expect(formatDisplayPrice({ priceMin: null, priceMax: null, priceUnit: 'FIXED' })).toBe(
      'Sur devis',
    );
  });

  it('un montant unique si priceMin === priceMax', () => {
    expect(formatDisplayPrice({ priceMin: 50, priceMax: 50, priceUnit: 'FIXED' })).toBe('50 DT');
  });

  it('une plage si priceMin !== priceMax', () => {
    expect(formatDisplayPrice({ priceMin: 50, priceMax: 80, priceUnit: 'FIXED' })).toBe(
      '50 - 80 DT',
    );
  });

  it.each([
    ['FIXED', ''],
    ['HOUR', '/heure'],
    ['DAY', '/jour'],
    ['SQUARE_METER', '/m²'],
    ['LINEAR_METER', '/ml'],
  ] as const)('suffixe correct pour l’unité %s', (priceUnit, suffix) => {
    expect(formatDisplayPrice({ priceMin: 10, priceMax: 10, priceUnit })).toBe(`10 DT${suffix}`);
  });

  it('un seul montant renseigné (priceMax null) est traité comme un montant unique', () => {
    expect(formatDisplayPrice({ priceMin: 30, priceMax: null, priceUnit: 'FIXED' })).toBe('30 DT');
  });

  it('retire les zéros de fin et utilise la virgule française', () => {
    expect(formatDisplayPrice({ priceMin: 12.5, priceMax: 12.5, priceUnit: 'FIXED' })).toBe(
      '12,5 DT',
    );
  });
});
