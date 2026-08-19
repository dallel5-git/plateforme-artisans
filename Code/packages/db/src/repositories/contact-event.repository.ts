// BE-05 : agrégat ContactEvent — l'unité de valeur vendue (CLAUDE.md §7). La fenêtre de
// déduplication (30 min, BE-21) est une décision métier : ce repository expose une requête
// générique par fenêtre temporelle, l'appelant décide du seuil.
import { prisma } from '../client.js';
import type { ContactChannel, DbClient } from '../types.js';
import { buildKeysetOrderBy, buildKeysetWhere, buildPage, resolveLimit } from '../pagination.js';
import type { PaginatedResult } from '../pagination.js';

const select = {
  id: true,
  providerId: true,
  clientId: true,
  categoryId: true,
  channel: true,
  sourceScreen: true,
  isSuspicious: true,
  createdAt: true,
} as const;

export interface ContactEvent {
  id: string;
  providerId: string;
  clientId: string | null;
  categoryId: string | null;
  channel: ContactChannel;
  sourceScreen: string | null;
  isSuspicious: boolean;
  createdAt: Date;
}

export interface CreateContactEventInput {
  providerId: string;
  clientId?: string;
  categoryId?: string;
  channel: ContactChannel;
  sourceScreen?: string;
  sessionHash?: string;
  ipHash?: string;
  isSuspicious?: boolean;
}

export async function createContactEvent(
  input: CreateContactEventInput,
  db: DbClient = prisma,
): Promise<ContactEvent> {
  return db.contactEvent.create({ data: input, select });
}

/** Dernier ContactEvent pour ce (provider, client) depuis `since` — support de la déduplication
 *  BE-21, le seuil (30 min) reste décidé par l'appelant. */
export async function findRecentContactEvent(
  providerId: string,
  clientId: string,
  since: Date,
  db: DbClient = prisma,
): Promise<ContactEvent | null> {
  return db.contactEvent.findFirst({
    where: { providerId, clientId, createdAt: { gte: since } },
    select,
    orderBy: { createdAt: 'desc' },
  });
}

export async function listContactEventsForProvider(
  providerId: string,
  options: { cursor?: string; limit?: number } = {},
  db: DbClient = prisma,
): Promise<PaginatedResult<ContactEvent>> {
  const limit = resolveLimit(options.limit);
  const keysetWhere = buildKeysetWhere('createdAt', 'desc', options.cursor);

  const rows = await db.contactEvent.findMany({
    where: keysetWhere ? { providerId, ...keysetWhere } : { providerId },
    select,
    orderBy: buildKeysetOrderBy('createdAt', 'desc'),
    take: limit + 1,
  });

  return buildPage(rows, limit, (row) => row.createdAt.toISOString());
}

export async function countContactEventsForProvider(
  providerId: string,
  db: DbClient = prisma,
): Promise<number> {
  return db.contactEvent.count({ where: { providerId } });
}
