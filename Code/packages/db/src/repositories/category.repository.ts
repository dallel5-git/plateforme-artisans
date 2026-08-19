// BE-05 : agrégat Category (arbre parent/enfants). Référentiel figé, écrit uniquement par le
// seed (BE-03) — lecture seule ici.
import { prisma } from '../client.js';
import type { DbClient } from '../types.js';

const select = {
  id: true,
  parentId: true,
  slug: true,
  nameFr: true,
  nameAr: true,
  descriptionFr: true,
  descriptionAr: true,
  iconKey: true,
  colorHex: true,
  isActive: true,
  sortOrder: true,
} as const;

export interface Category {
  id: string;
  parentId: string | null;
  slug: string;
  nameFr: string;
  nameAr: string;
  descriptionFr: string | null;
  descriptionAr: string | null;
  iconKey: string | null;
  colorHex: string | null;
  isActive: boolean;
  sortOrder: number;
}

export async function listRootCategories(db: DbClient = prisma): Promise<Category[]> {
  return db.category.findMany({
    where: { parentId: null, isActive: true },
    select,
    orderBy: { sortOrder: 'asc' },
  });
}

export async function listChildCategories(
  parentId: string,
  db: DbClient = prisma,
): Promise<Category[]> {
  return db.category.findMany({
    where: { parentId, isActive: true },
    select,
    orderBy: { sortOrder: 'asc' },
  });
}

export async function findCategoryBySlug(
  slug: string,
  db: DbClient = prisma,
): Promise<Category | null> {
  return db.category.findFirst({ where: { slug, isActive: true }, select });
}

export async function findCategoriesByIds(
  ids: string[],
  db: DbClient = prisma,
): Promise<Category[]> {
  if (ids.length === 0) return [];
  return db.category.findMany({ where: { id: { in: ids }, isActive: true }, select });
}
