// BE-05 : agrégat Favorite. Clé composite (userId, providerId).
// BE-25b : `listFavoritesForUser` pagine par curseur (P5, AC explicite du ticket) — `providerId`
// sert de départage-tri (`idField`, pagination.ts) puisque `Favorite` n'a pas de colonne `id`,
// mais reste unique une fois le `where` scopé par `userId`.
import { prisma } from '../client.js';
import type { DbClient } from '../types.js';
import { buildKeysetOrderBy, buildKeysetWhere, buildPage, resolveLimit } from '../pagination.js';
import type { PaginatedResult } from '../pagination.js';

const select = {
  userId: true,
  providerId: true,
  createdAt: true,
} as const;

export interface Favorite {
  userId: string;
  providerId: string;
  createdAt: Date;
}

export async function addFavorite(
  userId: string,
  providerId: string,
  db: DbClient = prisma,
): Promise<Favorite> {
  return db.favorite.upsert({
    where: { userId_providerId: { userId, providerId } },
    create: { userId, providerId },
    update: {},
    select,
  });
}

export async function removeFavorite(
  userId: string,
  providerId: string,
  db: DbClient = prisma,
): Promise<void> {
  await db.favorite.deleteMany({ where: { userId, providerId } });
}

export async function listFavoritesForUser(
  userId: string,
  options: { cursor?: string; limit?: number } = {},
  db: DbClient = prisma,
): Promise<PaginatedResult<Favorite>> {
  const limit = resolveLimit(options.limit);
  const keysetWhere = buildKeysetWhere('createdAt', 'desc', options.cursor, 'providerId');
  const baseWhere = { userId };

  const rows = await db.favorite.findMany({
    where: keysetWhere ? { ...baseWhere, ...keysetWhere } : baseWhere,
    select,
    orderBy: buildKeysetOrderBy('createdAt', 'desc', 'providerId'),
    take: limit + 1,
  });

  return buildPage(
    rows,
    limit,
    (row) => row.createdAt.toISOString(),
    (row) => row.providerId,
  );
}

export async function isFavorite(
  userId: string,
  providerId: string,
  db: DbClient = prisma,
): Promise<boolean> {
  const row = await db.favorite.findUnique({
    where: { userId_providerId: { userId, providerId } },
    select: { userId: true },
  });
  return row !== null;
}
