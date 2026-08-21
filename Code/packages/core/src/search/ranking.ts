/**
 * BE-15 — Ranking · score explicable et note bayésienne
 *
 * Logique pure : aucun accès base ni réseau (POLITIQUE-PROJET.md §6). Les poids w1..w7
 * viennent TOUJOURS de l'appelant (AppSetting en production, littéral en test) — jamais de
 * constante en dur ici. Seules les constantes de lissage bayésien (C, m) et l'amplitude de
 * rotation sont figées : Annexe A ne les rend pas paramétrables (seul C≈8 y est mentionné).
 *
 * Règles (Annexe A du cadrage + ADR-002) :
 *   score = w1·géo + w2·bayésien + w3·confiance + w4·complétude
 *         + w5·réactivité + w6·facteurPlan − w7·pénalités   ± rotation ±2 %
 *
 * 🔒 ADR-002 : w3Trust (badge « Vérifié », gratuit) et w6Plan (Plan.rankingBoostFactor,
 * payant) sont deux termes DISTINCTS, jamais fusionnés. Un artisan gratuit vérifié doit
 * pouvoir devancer un artisan Pro non vérifié — cf. packages/core/tests/ranking.test.ts,
 * describe() « garde-fou ADR-002 ».
 */

export type GeoMatch = 'delegation' | 'governorate' | 'adjacent';

export interface RankingInput {
  geoMatch: GeoMatch;
  ratingSum: number;
  ratingCount: number;
  isVerified: boolean;
  /** 0-100, brut (`ProviderProfile.completionScore`). */
  completionScore: number;
  /**
   * Déjà normalisé à [0,1] par l'appelant à partir de `lastActiveAt` + `availabilityStatus`
   * (Annexe A) — ce calcul touche l'horloge/la DB, hors périmètre de cette fonction pure.
   */
  responsivenessScore: number;
  /** `Plan.rankingBoostFactor` brut (1.0 gratuit, 1.3 Pro…) — volontairement NON normalisé,
   *  Annexe A l'utilise tel quel comme multiplicateur. */
  planBoostFactor: number;
  /** Brut, unité définie par l'appelant — volontairement NON normalisé, comme planBoostFactor. */
  penaltyScore: number;
}

export interface RankingWeights {
  w1Geo: number;
  w2Rating: number;
  w3Trust: number;
  w4Completion: number;
  w5Responsiveness: number;
  w6Plan: number;
  w7Penalty: number;
}

export interface RankingBreakdown {
  geo: number;
  rating: number;
  trust: number;
  completion: number;
  responsiveness: number;
  plan: number;
  penalty: number;
}

/** `providerId` + `seed` déterminent le décalage de rotation (BE-16 : le seed doit rester
 *  stable entre deux pages d'une même requête curseur pour ne pas briser la pagination). */
export interface RankingRotation {
  providerId: string;
  seed: number;
}

export interface RankingScoreResult {
  score: number;
  bayesianRating: number;
  breakdown: RankingBreakdown;
}

// Annexe A : 1.0 délégation exacte · 0.6 gouvernorat · 0.3 limitrophe.
const GEO_COEFFICIENTS: Record<GeoMatch, number> = {
  delegation: 1.0,
  governorate: 0.6,
  adjacent: 0.3,
};

// Lissage bayésien (Annexe A) : (C·m + Σnotes) / (C + n). C≈8 et m=3.5 (moyenne globale
// supposée) sont des constantes de lissage, pas des poids w1..w7 : elles restent figées ici
// plutôt que dans AppSetting — computeRankingScore ne les reçoit jamais en paramètre.
const BAYESIAN_C = 8;
const BAYESIAN_M = 3.5;

// Rotation équitable ±2 % (Annexe A) : à score égal, deux artisans ne doivent pas sortir
// indéfiniment dans le même ordre, mais l'écart ne doit JAMAIS renverser une vraie différence
// de score.
const ROTATION_AMPLITUDE = 0.02;

/**
 * Hash FNV-1a 32 bits — déterministe, sans dépendance externe. Sert uniquement à dériver un
 * décalage de rotation reproductible ; ce n'est PAS une fonction cryptographique.
 */
function fnv1aHash(value: string): number {
  let hash = 0x811c9dc5; // offset basis FNV-1a 32 bits
  for (let i = 0; i < value.length; i++) {
    hash ^= value.charCodeAt(i);
    hash = Math.imul(hash, 0x01000193); // prime FNV 32 bits ; overflow 32 bits volontaire
  }
  return hash >>> 0; // uint32 non signé
}

/**
 * Décalage de rotation dans [-ROTATION_AMPLITUDE, +ROTATION_AMPLITUDE], fonction pure et
 * déterministe de (providerId, seed). `providerId` et `seed` sont concaténés AVANT le hash
 * (pas hashés séparément puis combinés) : c'est ce qui garantit que deux artisans ne
 * diffèrent pas par un décalage de signe constant — sinon l'ordre ne s'inverserait jamais
 * d'une graine à l'autre.
 */
function rotationOffset(providerId: string, seed: number): number {
  const hash = fnv1aHash(`${providerId}:${seed}`);
  const unit = hash / 0xffffffff; // [0, 1]
  return (unit * 2 - 1) * ROTATION_AMPLITUDE; // [-0.02, 0.02]
}

/**
 * Calcule le score de ranking et sa décomposition terme à terme (mode debug / `matchReason`,
 * BE-16). `rotation` est optionnel : omis, le score est directement comparable/sommable avec
 * `breakdown` (somme des termes = score, hors plancher à zéro).
 */
export function computeRankingScore(
  input: RankingInput,
  weights: RankingWeights,
  rotation?: RankingRotation,
): RankingScoreResult {
  const bayesianRating =
    (BAYESIAN_C * BAYESIAN_M + input.ratingSum) / (BAYESIAN_C + input.ratingCount);

  const breakdown: RankingBreakdown = {
    geo: weights.w1Geo * GEO_COEFFICIENTS[input.geoMatch],
    // /5 : ramène le terme sur l'échelle ~0-1 commune à geo/trust/completion — un ajustement
    // de poids depuis le back-office (US-A-09) a un effet comparable entre termes.
    // `bayesianRating` brut (0-5) reste exposé séparément ci-dessous pour l'affichage.
    rating: weights.w2Rating * (bayesianRating / 5),
    trust: weights.w3Trust * (input.isVerified ? 1 : 0),
    completion: weights.w4Completion * (input.completionScore / 100),
    responsiveness: weights.w5Responsiveness * input.responsivenessScore,
    plan: weights.w6Plan * input.planBoostFactor,
    penalty: weights.w7Penalty * input.penaltyScore,
  };

  const rawTotal =
    breakdown.geo +
    breakdown.rating +
    breakdown.trust +
    breakdown.completion +
    breakdown.responsiveness +
    breakdown.plan -
    breakdown.penalty;

  // Plancher à 0 AVANT rotation : la rotation multiplie ensuite ce plancher (facteur
  // ∈ [0.98, 1.02]), elle ne peut donc jamais le faire redescendre sous 0.
  const base = Math.max(0, rawTotal);
  const score = rotation ? base * (1 + rotationOffset(rotation.providerId, rotation.seed)) : base;

  return { score, bayesianRating, breakdown };
}

// Tenu strictement synchronisé avec RankingWeights par `satisfies` : renommer/ajouter un
// champ dans l'interface sans mettre à jour cette liste casse la compilation.
const RANKING_WEIGHT_KEYS = [
  'w1Geo',
  'w2Rating',
  'w3Trust',
  'w4Completion',
  'w5Responsiveness',
  'w6Plan',
  'w7Penalty',
] as const satisfies readonly (keyof RankingWeights)[];

/**
 * Valide qu'un `AppSetting.value` (JSON générique, `unknown` côté repository — voir
 * packages/db/src/repositories/app-setting.repository.ts) contient bien les 7 champs
 * numériques de `RankingWeights`. Ne valide QUE la forme (présence + type) : aucune règle
 * métier sur les bornes (poids négatifs, etc.) — ce n'est pas son rôle.
 *
 * Retourne `null` plutôt que de lever, à l'image de `findAppSetting` (repository) : c'est à
 * l'appelant (route back-office US-A-09 en écriture, BE-16 en lecture) de décider s'il
 * répond 400, retombe sur un défaut, ou autre — ranking.ts ne connaît pas HTTP.
 */
export function parseRankingWeights(raw: unknown): RankingWeights | null {
  if (typeof raw !== 'object' || raw === null || Array.isArray(raw)) {
    return null;
  }

  const source = raw as Record<string, unknown>;
  const weights = {} as RankingWeights;

  for (const key of RANKING_WEIGHT_KEYS) {
    const value = source[key];
    if (typeof value !== 'number' || !Number.isFinite(value)) {
      return null;
    }
    weights[key] = value;
  }

  return weights;
}
