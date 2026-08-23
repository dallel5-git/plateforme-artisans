// BE-27a : test pur (aucune base) sur `computeGate1RecetteContactCreatedAt` — même esprit que
// `favorites.test.ts` dans ce paquet (harnais Vitest+Postgres différé, BE-02b). La fixture
// GATE 1 n'a de raison d'être que si son contact reste éligible à un avis (US-C-06,
// `buildReviewEligibilityWindow` dans `@repo/core` : seuil strict de 12h) ; ce test rougit si
// quelqu'un réduit `GATE1_RECETTE_CONTACT_AGE_HOURS` en dessous — ou au niveau — de ce seuil.
import { describe, expect, it } from 'vitest';
import {
  computeGate1RecetteContactCreatedAt,
  GATE1_RECETTE_CONTACT_AGE_HOURS,
} from '../prisma/seed/dev-fixtures.js';

describe('computeGate1RecetteContactCreatedAt', () => {
  it('produit un ContactEvent vieux exactement de GATE1_RECETTE_CONTACT_AGE_HOURS', () => {
    const now = new Date('2026-08-23T12:00:00.000Z');

    const createdAt = computeGate1RecetteContactCreatedAt(now);

    expect(now.getTime() - createdAt.getTime()).toBe(
      GATE1_RECETTE_CONTACT_AGE_HOURS * 60 * 60 * 1000,
    );
  });

  it('dépasse strictement le seuil de 12h exigé par US-C-06 pour éligibilité à un avis', () => {
    const now = new Date('2026-08-23T12:00:00.000Z');

    const createdAt = computeGate1RecetteContactCreatedAt(now);
    const ageHours = (now.getTime() - createdAt.getTime()) / (60 * 60 * 1000);

    expect(ageHours).toBeGreaterThan(12);
  });

  it('retombe sur Date.now() quand aucune référence temporelle n’est fournie', () => {
    const before = Date.now();

    const createdAt = computeGate1RecetteContactCreatedAt();

    const after = Date.now();
    const expectedOffsetMs = GATE1_RECETTE_CONTACT_AGE_HOURS * 60 * 60 * 1000;
    expect(createdAt.getTime()).toBeGreaterThanOrEqual(before - expectedOffsetMs);
    expect(createdAt.getTime()).toBeLessThanOrEqual(after - expectedOffsetMs);
  });
});
