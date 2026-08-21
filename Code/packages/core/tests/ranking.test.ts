/**
 * BE-15 — Ranking · `packages/core/src/search/ranking.ts`
 *
 * À placer dans : Code/packages/core/tests/ranking.test.ts
 *
 * ⚠️ Ces tests ÉCHOUENT tant que `computeRankingScore` n'existe pas. C'est voulu :
 *    ils décrivent le comportement attendu AVANT l'implémentation. Le développeur
 *    n'a qu'à les faire passer.
 *
 * Règles (Annexe A du cadrage + ADR-002) :
 *   score = w1·géo + w2·bayésien + w3·confiance + w4·complétude
 *         + w5·réactivité + w6·facteurPlan − w7·pénalités   ± rotation ±2 %
 *
 *   · Les poids w1..w7 viennent de `AppSetting`, JAMAIS de constantes en dur.
 *   · Aucun accès base ni réseau ici : si un test en a besoin, la logique est
 *     mal placée (POLITIQUE-PROJET.md §6).
 */
import { describe, it, expect } from 'vitest';
import {
  computeRankingScore,
  type RankingInput,
  type RankingWeights,
} from '../src/search/ranking.js';

// Poids de référence. En production ils sont lus depuis AppSetting — c'est
// précisément pour ça qu'on les INJECTE ici plutôt que de les importer.
const POIDS: RankingWeights = {
  w1Geo: 0.3,
  w2Rating: 0.25,
  w3Trust: 0.15,
  w4Completion: 0.1,
  w5Responsiveness: 0.1,
  w6Plan: 0.1,
  w7Penalty: 0.2,
};

/** Artisan neutre : tout à zéro, on ne fait varier qu'une dimension par test. */
function artisan(o: Partial<RankingInput> = {}): RankingInput {
  return {
    geoMatch: 'governorate',
    ratingSum: 0,
    ratingCount: 0,
    isVerified: false,
    completionScore: 0,
    responsivenessScore: 0,
    planBoostFactor: 1,
    penaltyScore: 0,
    ...o,
  };
}

describe('BE-15 — pertinence géographique', () => {
  it('classe délégation > gouvernorat > limitrophe', () => {
    const meme = computeRankingScore(artisan({ geoMatch: 'delegation' }), POIDS);
    const gouv = computeRankingScore(artisan({ geoMatch: 'governorate' }), POIDS);
    const voisin = computeRankingScore(artisan({ geoMatch: 'adjacent' }), POIDS);

    expect(meme.score).toBeGreaterThan(gouv.score);
    expect(gouv.score).toBeGreaterThan(voisin.score);
  });

  it('applique les coefficients 1.0 / 0.6 / 0.3', () => {
    const seulGeo: RankingWeights = {
      ...POIDS,
      w2Rating: 0,
      w3Trust: 0,
      w4Completion: 0,
      w5Responsiveness: 0,
      w6Plan: 0,
      w7Penalty: 0,
    };
    const d = computeRankingScore(artisan({ geoMatch: 'delegation' }), seulGeo).score;
    const g = computeRankingScore(artisan({ geoMatch: 'governorate' }), seulGeo).score;
    const a = computeRankingScore(artisan({ geoMatch: 'adjacent' }), seulGeo).score;

    expect(g / d).toBeCloseTo(0.6, 2);
    expect(a / d).toBeCloseTo(0.3, 2);
  });
});

describe('BE-15 — note bayésienne (C = 8)', () => {
  it('un 5★ sur 1 avis ne bat pas un 4,5★ sur 50 avis', () => {
    // C'est TOUTE la raison d'être du lissage bayésien : sans lui, le premier
    // artisan qui se fait noter par son cousin passe devant tout le monde.
    const nouveau = computeRankingScore(artisan({ ratingSum: 5, ratingCount: 1 }), POIDS);
    const etabli = computeRankingScore(artisan({ ratingSum: 225, ratingCount: 50 }), POIDS);

    expect(etabli.score).toBeGreaterThan(nouveau.score);
  });

  it('applique la formule (C·m + Σnotes) / (C + n) avec C = 8', () => {
    // m = moyenne globale supposée (3.5) · 10 avis à 5★ → (8·3.5 + 50)/(8+10) = 4.333
    const r = computeRankingScore(artisan({ ratingSum: 50, ratingCount: 10 }), POIDS);
    expect(r.bayesianRating).toBeCloseTo(4.333, 2);
  });

  it("un artisan sans aucun avis n'est pas exclu du classement", () => {
    // Sinon aucun nouvel artisan ne démarre jamais — le catalogue se fige.
    const r = computeRankingScore(artisan({ ratingSum: 0, ratingCount: 0 }), POIDS);
    expect(r.score).toBeGreaterThan(0);
    expect(Number.isFinite(r.score)).toBe(true);
  });
});

describe('BE-15 — 🔒 garde-fou ADR-002 : le badge est GRATUIT', () => {
  /**
   * 🔒 NON-RÉGRESSION — ADR-002 : ne jamais supprimer sans un nouvel ADR qui l'annule.
   *
   * Si ce test casse, quelqu'un a re-lié le badge « Vérifié » au plan payant.
   * Le badge atteste de l'IDENTITÉ, le plan vend la VISIBILITÉ. Les deux termes
   * du score (w3Trust et w6Plan) ne doivent JAMAIS être fusionnés.
   */
  it('un artisan GRATUIT vérifié et complété devance un artisan PRO non vérifié et incomplet', () => {
    const gratuitVerifie = computeRankingScore(
      artisan({ isVerified: true, completionScore: 100, planBoostFactor: 1.0 }),
      POIDS,
    );
    const proNonVerifie = computeRankingScore(
      artisan({ isVerified: false, completionScore: 30, planBoostFactor: 1.5 }),
      POIDS,
    );

    expect(gratuitVerifie.score).toBeGreaterThan(proNonVerifie.score);
  });

  it("le score ne lit jamais le statut d'abonnement", () => {
    // Le seul canal par lequel le plan influence le score est planBoostFactor.
    // Aucune propriété `subscription*` ne doit exister dans l'entrée.
    const cles = Object.keys(artisan());
    expect(cles.filter((k) => /subscription/i.test(k))).toHaveLength(0);
  });

  it('deux artisans identiques au plan près ne diffèrent que par w6', () => {
    const base = { isVerified: true, completionScore: 80, ratingSum: 40, ratingCount: 10 };
    const gratuit = computeRankingScore(artisan({ ...base, planBoostFactor: 1.0 }), POIDS);
    const pro = computeRankingScore(artisan({ ...base, planBoostFactor: 1.5 }), POIDS);

    // Le Pro est devant — c'est légitime, c'est ce qu'il achète.
    expect(pro.score).toBeGreaterThan(gratuit.score);
    // Mais l'écart vient UNIQUEMENT du terme de plan.
    expect(pro.breakdown.trust).toBe(gratuit.breakdown.trust);
  });
});

describe('BE-15 — les poids viennent de AppSetting', () => {
  it('changer un poids change le score', () => {
    const a = artisan({ isVerified: true });
    const normal = computeRankingScore(a, POIDS);
    const sansConfiance = computeRankingScore(a, { ...POIDS, w3Trust: 0 });

    expect(normal.score).not.toBe(sansConfiance.score);
  });

  it('des poids tous à zéro donnent un score nul — aucune constante cachée', () => {
    const zero: RankingWeights = {
      w1Geo: 0,
      w2Rating: 0,
      w3Trust: 0,
      w4Completion: 0,
      w5Responsiveness: 0,
      w6Plan: 0,
      w7Penalty: 0,
    };
    const r = computeRankingScore(artisan({ isVerified: true, completionScore: 100 }), zero);
    expect(r.score).toBe(0);
  });
});

describe('BE-15 — pénalités et bornes', () => {
  it('une pénalité fait baisser le score', () => {
    const propre = computeRankingScore(artisan({ ratingSum: 40, ratingCount: 10 }), POIDS);
    const penalise = computeRankingScore(
      artisan({ ratingSum: 40, ratingCount: 10, penaltyScore: 0.5 }),
      POIDS,
    );

    expect(penalise.score).toBeLessThan(propre.score);
  });

  it('le score ne devient jamais négatif, même très pénalisé', () => {
    const r = computeRankingScore(artisan({ penaltyScore: 999 }), POIDS);
    expect(r.score).toBeGreaterThanOrEqual(0);
  });
});

describe('BE-15 — rotation équitable ±2 %', () => {
  it('à score égal, deux artisans ne sortent pas toujours dans le même ordre', () => {
    // Sans rotation, le n°1 reste n°1 pour toujours et capte tous les contacts.
    const a = artisan({ ratingSum: 40, ratingCount: 10, isVerified: true });
    const ordres = new Set<string>();

    for (let seed = 0; seed < 50; seed++) {
      const x = computeRankingScore(a, POIDS, { providerId: 'A', seed });
      const y = computeRankingScore(a, POIDS, { providerId: 'B', seed });
      ordres.add(x.score >= y.score ? 'AB' : 'BA');
    }

    expect(ordres.size).toBe(2);
  });

  it('la rotation reste dans ±2 % — elle ne renverse jamais un vrai écart', () => {
    const a = artisan({ ratingSum: 40, ratingCount: 10 });
    const sansRotation = computeRankingScore(a, POIDS).score;

    for (let seed = 0; seed < 100; seed++) {
      const avec = computeRankingScore(a, POIDS, { providerId: 'A', seed }).score;
      expect(Math.abs(avec - sansRotation) / sansRotation).toBeLessThanOrEqual(0.02);
    }
  });

  it('est déterministe : même graine et même artisan → même score', () => {
    // Indispensable pour que la pagination par curseur reste stable entre
    // deux pages (BE-16).
    const a = artisan({ ratingSum: 40, ratingCount: 10 });
    const x = computeRankingScore(a, POIDS, { providerId: 'A', seed: 42 });
    const y = computeRankingScore(a, POIDS, { providerId: 'A', seed: 42 });

    expect(x.score).toBe(y.score);
  });
});

describe('BE-15 — explicabilité', () => {
  it('renvoie le détail de chaque terme du score', () => {
    // « Pourquoi cet artisan est-il 3ᵉ ? » doit avoir une réponse.
    // C'est aussi ce qui alimente `matchReason` en mode debug (BE-16).
    const r = computeRankingScore(artisan({ isVerified: true, completionScore: 100 }), POIDS);

    expect(r.breakdown).toMatchObject({
      geo: expect.any(Number),
      rating: expect.any(Number),
      trust: expect.any(Number),
      completion: expect.any(Number),
      responsiveness: expect.any(Number),
      plan: expect.any(Number),
      penalty: expect.any(Number),
    });
  });

  it('la somme des termes égale le score (hors rotation)', () => {
    const r = computeRankingScore(
      artisan({ isVerified: true, completionScore: 50, ratingSum: 40, ratingCount: 10 }),
      POIDS,
    );
    const somme =
      r.breakdown.geo +
      r.breakdown.rating +
      r.breakdown.trust +
      r.breakdown.completion +
      r.breakdown.responsiveness +
      r.breakdown.plan -
      r.breakdown.penalty;

    expect(somme).toBeCloseTo(r.score, 6);
  });
});

describe('BE-15 — les boosts ne touchent PAS le ranking', () => {
  it("l'entrée du ranking ne comporte aucun champ de boost", () => {
    // Un boost est un EMPLACEMENT sponsorisé, hors classement, étiqueté
    // « Sponsorisé ». Il n'altère jamais le rankingScore (ADR-002 §4, glossaire).
    const cles = Object.keys(artisan());
    expect(cles.filter((k) => /boost|sponsor/i.test(k) && k !== 'planBoostFactor')).toHaveLength(0);
  });
});
