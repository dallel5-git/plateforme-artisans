// BE-17 : lecture de l'agrégat d'avis déjà dénormalisé sur ProviderProfile (ratingAvg/ratingCount/
// reviewCountByStar), pour la fiche publique — pas le recalcul transactionnel à l'écriture d'un
// avis (BE-22, qui posera ici sa propre fonction de calcul à partir des lignes Review).
export interface ReviewStarBreakdown {
  '1': number;
  '2': number;
  '3': number;
  '4': number;
  '5': number;
}

const STAR_KEYS = ['1', '2', '3', '4', '5'] as const;

/**
 * `reviewCountByStar` est un `Json?` Prisma (`unknown` côté repository) — miroir de
 * `parseRankingWeights` (packages/core/src/search/ranking.ts) mais déviation assumée : celui-ci
 * ne renvoie jamais `null`. Un `AppSetting` cassé est un incident de config à faire remonter
 * bruyamment (500) ; `reviewCountByStar` est un agrégat de DONNÉES (pas encore peuplé avant
 * BE-22) — une valeur absente ou malformée ne doit jamais faire échouer la lecture d'une fiche
 * publique, on retombe silencieusement sur un breakdown à zéro.
 */
export function parseReviewCountByStar(raw: unknown): ReviewStarBreakdown {
  const result: ReviewStarBreakdown = { '1': 0, '2': 0, '3': 0, '4': 0, '5': 0 };
  if (typeof raw !== 'object' || raw === null || Array.isArray(raw)) {
    return result;
  }

  const source = raw as Record<string, unknown>;
  for (const key of STAR_KEYS) {
    const value = source[key];
    if (typeof value === 'number' && Number.isFinite(value) && value >= 0) {
      result[key] = value;
    }
  }
  return result;
}

export interface ReviewAggregate {
  average: number;
  count: number;
  breakdown: ReviewStarBreakdown;
}

export function buildReviewAggregate(
  ratingAvg: number,
  ratingCount: number,
  reviewCountByStarRaw: unknown,
): ReviewAggregate {
  return {
    average: ratingAvg,
    count: ratingCount,
    breakdown: parseReviewCountByStar(reviewCountByStarRaw),
  };
}
