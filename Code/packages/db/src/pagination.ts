// BE-05 : pagination par curseur générique (P5, CLAUDE.md §2). Keyset pagination — jamais
// `skip`/`OFFSET`, qui se décale si une ligne est insérée entre deux pages lues. Le curseur
// encode (valeur du champ de tri, id) : la page suivante se lit par `WHERE (sortField, id) >
// (curVal, curId)`, stable quel que soit ce qui a été inséré ailleurs entre-temps.
export const DEFAULT_PAGE_SIZE = 20;
export const MAX_PAGE_SIZE = 100;

export type SortDirection = 'asc' | 'desc';

export interface PaginatedResult<T> {
  items: T[];
  nextCursor: string | null;
}

interface CursorPayload {
  v: string | number;
  id: string;
}

export class InvalidCursorError extends Error {
  constructor(cursor: string) {
    super(`Curseur de pagination invalide: "${cursor}"`);
    this.name = 'InvalidCursorError';
  }
}

export function encodeCursor(value: string | number, id: string): string {
  return Buffer.from(JSON.stringify({ v: value, id } satisfies CursorPayload), 'utf8').toString(
    'base64url',
  );
}

export function decodeCursor(cursor: string): CursorPayload {
  let parsed: unknown;
  try {
    parsed = JSON.parse(Buffer.from(cursor, 'base64url').toString('utf8'));
  } catch {
    throw new InvalidCursorError(cursor);
  }

  if (
    typeof parsed !== 'object' ||
    parsed === null ||
    !('v' in parsed) ||
    !('id' in parsed) ||
    typeof (parsed as CursorPayload).id !== 'string' ||
    !['string', 'number'].includes(typeof (parsed as CursorPayload).v)
  ) {
    throw new InvalidCursorError(cursor);
  }

  return parsed as CursorPayload;
}

export function resolveLimit(limit?: number): number {
  if (limit === undefined || Number.isNaN(limit)) return DEFAULT_PAGE_SIZE;
  return Math.min(Math.max(Math.trunc(limit), 1), MAX_PAGE_SIZE);
}

/**
 * Fragment `where` keyset pour "l'élément suivant après ce curseur", à fusionner avec les
 * filtres propres à chaque repository. `sortField` est un nom de champ scalaire du modèle
 * Prisma ciblé (le repository appelant est responsable du typage exact du `where` final).
 * `idField` est le champ départage-tri (par défaut `id`) — surchargeable pour un modèle sans
 * colonne `id`, ex. `Favorite` dont la clé est composite `(userId, providerId)` : `providerId`
 * y joue le même rôle de tie-breaker unique une fois le `where` scopé par `userId` (BE-25b).
 */
export function buildKeysetWhere(
  sortField: string,
  sortDir: SortDirection,
  cursor?: string,
  idField: string = 'id',
): Record<string, unknown> | undefined {
  if (!cursor) return undefined;

  const { v, id } = decodeCursor(cursor);
  const op = sortDir === 'asc' ? 'gt' : 'lt';

  return {
    OR: [{ [sortField]: { [op]: v } }, { [sortField]: v, [idField]: { gt: id } }],
  };
}

export function buildKeysetOrderBy(
  sortField: string,
  sortDir: SortDirection,
  idField: string = 'id',
): Array<Record<string, SortDirection>> {
  return [{ [sortField]: sortDir }, { [idField]: 'asc' }];
}

/**
 * À partir d'une page de `limit + 1` lignes déjà triées par `(sortField, idField)`, découpe la
 * page réelle et calcule le curseur suivant. `getSortValue` extrait la valeur du champ de tri sur
 * une ligne (le type exact dépend du modèle, laissé au repository appelant). `getId` extrait le
 * départage-tri de la ligne — par défaut `row.id`, surchargeable comme `buildKeysetWhere`/
 * `buildKeysetOrderBy` ci-dessus pour un modèle sans colonne `id`.
 */
export function buildPage<T>(
  rows: T[],
  limit: number,
  getSortValue: (row: T) => string | number,
  getId: (row: T) => string = (row) => (row as { id: string }).id,
): PaginatedResult<T> {
  const hasMore = rows.length > limit;
  const items = hasMore ? rows.slice(0, limit) : rows;
  const last = items.at(-1);

  return {
    items,
    nextCursor: hasMore && last ? encodeCursor(getSortValue(last), getId(last)) : null,
  };
}
