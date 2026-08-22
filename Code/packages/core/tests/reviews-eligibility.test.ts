/**
 * BE-22 — fenêtre d'éligibilité d'un avis (US-C-06) : un ContactEvent ne compte que s'il date de
 * plus de 12h et de moins de 60j. Aucune spec pré-écrite ici (contrairement à contacts.test.ts,
 * BE-21) — ce fichier est la spec, écrite avant l'implémentation.
 */
import { describe, expect, it } from 'vitest';
import {
  buildReviewEligibilityWindow,
  isContactEventEligibleForReview,
  REVIEW_MAX_CONTACT_AGE_DAYS,
  REVIEW_MIN_CONTACT_AGE_HOURS,
} from '../src/reviews/eligibility.js';

const NOW = new Date('2026-08-22T12:00:00.000Z');
const hours = (n: number) => new Date(NOW.getTime() - n * 60 * 60 * 1000);
const days = (n: number) => new Date(NOW.getTime() - n * 24 * 60 * 60 * 1000);

describe('BE-22 — constantes', () => {
  it('12h minimum, 60 jours maximum', () => {
    expect(REVIEW_MIN_CONTACT_AGE_HOURS).toBe(12);
    expect(REVIEW_MAX_CONTACT_AGE_DAYS).toBe(60);
  });
});

describe('BE-22 — isContactEventEligibleForReview', () => {
  it('un contact de 30 jours est éligible', () => {
    expect(isContactEventEligibleForReview(days(30), NOW)).toBe(true);
  });

  it('un contact d’1h (trop récent) est refusé', () => {
    expect(isContactEventEligibleForReview(hours(1), NOW)).toBe(false);
  });

  it('un contact de 90 jours (trop ancien) est refusé', () => {
    expect(isContactEventEligibleForReview(days(90), NOW)).toBe(false);
  });

  it('exactement 12h — pas encore « plus de » 12h, refusé (borne stricte)', () => {
    expect(isContactEventEligibleForReview(hours(12), NOW)).toBe(false);
  });

  it('12h + 1ms — éligible', () => {
    const contact = new Date(hours(12).getTime() - 1);
    expect(isContactEventEligibleForReview(contact, NOW)).toBe(true);
  });

  it('exactement 60 jours — plus « moins de » 60j, refusé (borne stricte)', () => {
    expect(isContactEventEligibleForReview(days(60), NOW)).toBe(false);
  });

  it('60 jours - 1ms — éligible', () => {
    const contact = new Date(days(60).getTime() + 1);
    expect(isContactEventEligibleForReview(contact, NOW)).toBe(true);
  });
});

describe('BE-22 — buildReviewEligibilityWindow', () => {
  it('calcule les bornes exactes pour un `now` injecté', () => {
    const window = buildReviewEligibilityWindow(NOW);

    expect(window.latestEligible).toEqual(hours(REVIEW_MIN_CONTACT_AGE_HOURS));
    expect(window.earliestEligible).toEqual(days(REVIEW_MAX_CONTACT_AGE_DAYS));
  });
});
