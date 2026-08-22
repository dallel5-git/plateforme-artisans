/**
 * BE-19a — Complétude du profil artisan · `packages/core/src/providers/completion-score.ts`
 *
 * Logique pure : aucune dépendance Prisma/HTTP. L'appelant (apps/api) fournit déjà les
 * comptages (catégories, zones) et l'état du téléphone — cette fonction ne fait que noter.
 *
 * Pondération (somme = 100) : téléphone vérifié (25) + bio ≥ 50 caractères (20) + ≥1 catégorie
 * (20) + ≥1 zone (20) + titre (5) + expérience (5) + téléphone de contact (5). Décision de
 * conception documentée dans le fichier source — aucune pondération n'est écrite dans le
 * cadrage ou le PLAN-MVP, seul le seuil de publication de 60 % l'est.
 */
import { describe, it, expect } from 'vitest';
import {
  calculateCompletionScore,
  MIN_BIO_LENGTH,
  MIN_PUBLICATION_COMPLETION_SCORE,
  type CompletionScoreInput,
} from '../src/providers/completion-score.js';

const emptyInput: CompletionScoreInput = {
  phoneVerified: false,
  bio: null,
  headline: null,
  yearsExperience: null,
  hasContactPhone: false,
  categoryCount: 0,
  coverageAreaCount: 0,
};

const fullInput: CompletionScoreInput = {
  phoneVerified: true,
  bio: 'A'.repeat(MIN_BIO_LENGTH),
  headline: 'Plombier certifié',
  yearsExperience: 5,
  hasContactPhone: true,
  categoryCount: 1,
  coverageAreaCount: 1,
};

describe('BE-19a — constantes', () => {
  it('le seuil de publication est 60 %', () => {
    expect(MIN_PUBLICATION_COMPLETION_SCORE).toBe(60);
  });

  it('la bio minimale est de 50 caractères', () => {
    expect(MIN_BIO_LENGTH).toBe(50);
  });
});

describe('BE-19a — calculateCompletionScore', () => {
  it('un profil vide obtient un score de 0 et liste tous les champs manquants', () => {
    const result = calculateCompletionScore(emptyInput);

    expect(result.score).toBe(0);
    expect(result.missingFields).toEqual(
      expect.arrayContaining([
        'phoneVerified',
        'bio',
        'categories',
        'coverageAreas',
        'headline',
        'yearsExperience',
        'contactPhone',
      ]),
    );
  });

  it('un profil complet obtient un score de 100 et aucun champ manquant', () => {
    const result = calculateCompletionScore(fullInput);

    expect(result.score).toBe(100);
    expect(result.missingFields).toEqual([]);
  });

  it('une bio de 49 caractères ne compte pas, 50 compte', () => {
    const tooShort = calculateCompletionScore({ ...fullInput, bio: 'A'.repeat(49) });
    const justRight = calculateCompletionScore({ ...fullInput, bio: 'A'.repeat(50) });

    expect(tooShort.missingFields).toContain('bio');
    expect(justRight.missingFields).not.toContain('bio');
    expect(justRight.score).toBeGreaterThan(tooShort.score);
  });

  // Profil minimal décrit par `US-P-01` (cadrage, ligne 237) : uniquement les 4 champs majeurs,
  // aucun champ optionnel — c'est le scénario où leur poids individuel compte vraiment (les
  // champs optionnels peuvent compenser un champ majeur manquant sur un profil par ailleurs très
  // rempli, voir le commentaire dans `completion-score.ts`).
  const criticalOnlyInput: CompletionScoreInput = {
    phoneVerified: true,
    bio: 'A'.repeat(MIN_BIO_LENGTH),
    headline: null,
    yearsExperience: null,
    hasContactPhone: false,
    categoryCount: 1,
    coverageAreaCount: 1,
  };

  it('les 4 champs majeurs seuls (téléphone + bio + 1 catégorie + 1 zone) franchissent le seuil de 60 %', () => {
    const result = calculateCompletionScore(criticalOnlyInput);

    expect(result.score).toBeGreaterThanOrEqual(MIN_PUBLICATION_COMPLETION_SCORE);
  });

  it.each(['phoneVerified', 'bio', 'categoryCount', 'coverageAreaCount'] as const)(
    'sur un profil minimal, retirer le champ majeur %s repasse sous le seuil de 60 %%',
    (field) => {
      const degraded: CompletionScoreInput = {
        ...criticalOnlyInput,
        ...(field === 'phoneVerified' ? { phoneVerified: false } : {}),
        ...(field === 'bio' ? { bio: null } : {}),
        ...(field === 'categoryCount' ? { categoryCount: 0 } : {}),
        ...(field === 'coverageAreaCount' ? { coverageAreaCount: 0 } : {}),
      };

      const result = calculateCompletionScore(degraded);

      expect(result.score).toBeLessThan(MIN_PUBLICATION_COMPLETION_SCORE);
    },
  );

  it('le score ne descend jamais sous 0 ni ne dépasse 100', () => {
    const zero = calculateCompletionScore(emptyInput);
    const hundred = calculateCompletionScore({
      ...fullInput,
      categoryCount: 8,
      coverageAreaCount: 24,
    });

    expect(zero.score).toBeGreaterThanOrEqual(0);
    expect(hundred.score).toBeLessThanOrEqual(100);
  });
});
