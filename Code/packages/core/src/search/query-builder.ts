import type { AvailabilityStatus } from '@repo/db';

import { fnv1aHash } from './ranking.js';

export interface NormalizedSearchFilters {
  categoryId?: string;
  governorateId: string;
  delegationId?: string;
  verified?: boolean;
  minRating?: number;
  availabilityStatus?: AvailabilityStatus;
}

export interface PaginatedResult<T> {
  items: T[];
  nextCursor: string | null;
}

export class InvalidSearchCursorError extends Error {
  constructor(cursor: string) {
    super(`Curseur de recherche invalide: "${cursor}"`);
    this.name = 'InvalidSearchCursorError';
  }
}

interface CursorPayload {
  v: number;
  id: string;
}

// Codec de curseur dupliqué (volontairement) plutôt qu'importé de `packages/db/src/pagination.ts` :
// `packages/core` n'importe jamais de code RUNTIME de `@repo/db` (seulement des types — voir
// `import type` dans `scoring.ts`, `policies/rbac.ts`, `auth/jwt.ts`), pour rester libre de toute
// dépendance à Prisma/DB, même indirecte (P3). Même format base64url JSON que `pagination.ts`,
// par cohérence, mais `v` est ici toujours un `number` (le score), jamais une colonne DB.
function encodeCursor(value: number, id: string): string {
  return Buffer.from(JSON.stringify({ v: value, id } satisfies CursorPayload), 'utf8').toString(
    'base64url',
  );
}

function decodeCursor(cursor: string): CursorPayload {
  let parsed: unknown;
  try {
    parsed = JSON.parse(Buffer.from(cursor, 'base64url').toString('utf8'));
  } catch {
    throw new InvalidSearchCursorError(cursor);
  }

  if (
    typeof parsed !== 'object' ||
    parsed === null ||
    typeof (parsed as CursorPayload).v !== 'number' ||
    typeof (parsed as CursorPayload).id !== 'string'
  ) {
    throw new InvalidSearchCursorError(cursor);
  }

  return parsed as CursorPayload;
}

const SEED_BUCKET_MS = 60 * 60_000; // 1h — voir justification ci-dessous

/**
 * Graine de rotation stable pour une « recherche logique » (mêmes filtres normalisés, même
 * fenêtre d'une heure) — BE-15 exige explicitement que cette graine reste identique entre deux
 * pages d'un même curseur (`ranking.ts`, doc de `RankingRotation`). Bucket HORAIRE, pas
 * quotidien : cet écran est le plus utilisé du produit — un bucket journalier figerait l'ordre
 * à égalité de score pendant 24h pour une combinaison de filtres populaire (ex. plomberie ×
 * Sousse), contraire au but même de la rotation ±2 % (Annexe A : « à score égal, l'ordre
 * tourne »). Une heure reste largement assez longue pour qu'une session de pagination d'un même
 * utilisateur (quelques minutes) ne saute jamais entre deux graines.
 */
export function buildSearchSeed(filters: NormalizedSearchFilters, now: Date): number {
  const bucket = Math.floor(now.getTime() / SEED_BUCKET_MS);
  const key = [
    filters.categoryId ?? '',
    filters.governorateId,
    filters.delegationId ?? '',
    filters.verified ? '1' : '0',
    filters.minRating ?? '',
    filters.availabilityStatus ?? '',
    bucket,
  ].join('|');
  return fnv1aHash(key);
}

/**
 * Pagination en mémoire d'un tableau DÉJÀ TRIÉ (score décroissant, id croissant — responsabilité
 * de l'appelant, cf. `scoreCandidates`). Miroir en JS de `buildKeysetWhere`/`buildPage`
 * (packages/db/src/pagination.ts), mais ce codepath ne touche jamais Prisma : le tri est
 * calculé en mémoire (BE-16, décision d'architecture — `rankingScore` en base n'est jamais
 * peuplé, et `geoMatch` dépend de la requête, pas d'une colonne fixe).
 */
export function paginateScoredResults<T extends { id: string; score: number }>(
  sorted: T[],
  limit: number,
  cursor?: string,
): PaginatedResult<T> {
  const startIndex = cursor ? findFirstIndexAfterCursor(sorted, cursor) : 0;
  const page = sorted.slice(startIndex, startIndex + limit);
  const hasMore = startIndex + limit < sorted.length;
  const last = page.at(-1);

  return {
    items: page,
    nextCursor: hasMore && last ? encodeCursor(last.score, last.id) : null,
  };
}

function findFirstIndexAfterCursor<T extends { id: string; score: number }>(
  sorted: T[],
  cursor: string,
): number {
  const { v: cursorScore, id } = decodeCursor(cursor);

  // « Strictement après » en ordre (score décroissant, id croissant) : score plus bas, OU même
  // score et id plus grand — même forme que `buildKeysetWhere`'s `OR: [{gt}, {eq, id gt}]`,
  // évaluée en JS. Égalité de flottant volontaire (pas de tolérance epsilon) : le score est
  // recalculé de façon déterministe (mêmes poids, même graine, mêmes entrées) à chaque page
  // d'une même recherche — exactement la même suite d'opérations IEEE754, pas une
  // ré-accumulation divergente.
  const index = sorted.findIndex(
    (row) => row.score < cursorScore || (row.score === cursorScore && row.id > id),
  );
  return index === -1 ? sorted.length : index;
}
