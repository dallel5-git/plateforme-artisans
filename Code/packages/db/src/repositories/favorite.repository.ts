// BE-05 : agrégat Favorite. Clé composite (userId, providerId) — pas de curseur nécessaire ici,
// la liste de favoris d'un utilisateur est bornée par construction (un humain ne favorise pas
// des milliers d'artisans).
import { prisma } from '../client.js';
import type { DbClient } from '../types.js';

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
  db: DbClient = prisma,
): Promise<Favorite[]> {
  return db.favorite.findMany({ where: { userId }, select, orderBy: { createdAt: 'desc' } });
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
