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

export interface RecentContactEventByFingerprint {
  id: string;
  providerId: string;
  channel: ContactChannel;
  createdAt: Date;
}

/** Dernier ContactEvent pour cette empreinte de session, tous prestataires confondus — c'est
 *  `shouldDeduplicate` (@repo/core) qui tranche si le `providerId` retourné correspond à la
 *  requête en cours. Seule voie de dédup pour un visiteur anonyme (pas de `clientId`, BE-21). */
export async function findRecentContactEventByFingerprint(
  sessionHash: string,
  since: Date,
  db: DbClient = prisma,
): Promise<RecentContactEventByFingerprint | null> {
  return db.contactEvent.findFirst({
    where: { sessionHash, createdAt: { gte: since } },
    select: { id: true, providerId: true, channel: true, createdAt: true },
    orderBy: { createdAt: 'desc' },
  });
}

export interface EligibleContactEventForReview {
  id: string;
  createdAt: Date;
}

/** BE-22 : le seul ContactEvent qu'un avis peut cibler pour ce (provider, client) — pas encore
 *  lié à un Review (`review: null`), et dans la fenêtre d'éligibilité (US-C-06, calculée par
 *  `@repo/core`, jamais ici). La fenêtre est appliquée dans le `WHERE`, pas après coup : sinon le
 *  contact le plus récent mais inéligible masquerait un contact plus ancien réellement éligible. */
export async function findEligibleContactEventForReview(
  providerId: string,
  clientId: string,
  window: { earliestEligible: Date; latestEligible: Date },
  db: DbClient = prisma,
): Promise<EligibleContactEventForReview | null> {
  return db.contactEvent.findFirst({
    where: {
      providerId,
      clientId,
      review: null,
      createdAt: { gt: window.earliestEligible, lt: window.latestEligible },
    },
    select: { id: true, createdAt: true },
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

export interface ContactEventTimestamp {
  createdAt: Date;
}

// BE-24 : lecture brute pour `GET /providers/me/stats`. Le regroupement par jour calendaire UTC
// (même convention que `resolveViewDate`, BE-23) est fait côté `@repo/core` — DailyProviderStat
// n'a jamais écrit phoneClicks/whatsappClicks (BE-21 n'incrémente que
// ProviderProfile.totalContacts), donc les contacts de la série 30 j sont agrégés ici en lecture
// seule, sans toucher au code d'écriture déjà mergé.
export async function listContactEventTimestampsForProvider(
  providerId: string,
  range: { from: Date; to: Date },
  db: DbClient = prisma,
): Promise<ContactEventTimestamp[]> {
  return db.contactEvent.findMany({
    where: { providerId, createdAt: { gte: range.from, lte: range.to } },
    select: { createdAt: true },
    orderBy: { createdAt: 'asc' },
  });
}

const clientHistorySelect = {
  id: true,
  providerId: true,
  categoryId: true,
  channel: true,
  createdAt: true,
  review: { select: { id: true } },
} as const;

export interface ClientContactEvent {
  id: string;
  providerId: string;
  categoryId: string | null;
  channel: ContactChannel;
  createdAt: Date;
  hasReview: boolean;
}

// BE-45 : historique de lecture du client authentifié (US-C-09) — `select` dédié plutôt
// qu'élargissement du `select` module-level ci-dessus (BE-16, celui-ci a des appelants réels :
// createContactEvent/findRecentContactEvent/listContactEventsForProvider). `clientId` est
// indexé (schema.prisma, `@@index([clientId, createdAt(sort: Desc)])`) : même stratégie de
// pagination par curseur que `listContactEventsForProvider` ci-dessus.
export async function listContactEventsForClient(
  clientId: string,
  options: { cursor?: string; limit?: number } = {},
  db: DbClient = prisma,
): Promise<PaginatedResult<ClientContactEvent>> {
  const limit = resolveLimit(options.limit);
  const keysetWhere = buildKeysetWhere('createdAt', 'desc', options.cursor);
  const baseWhere = { clientId };

  const rows = await db.contactEvent.findMany({
    where: keysetWhere ? { ...baseWhere, ...keysetWhere } : baseWhere,
    select: clientHistorySelect,
    orderBy: buildKeysetOrderBy('createdAt', 'desc'),
    take: limit + 1,
  });

  const page = buildPage(rows, limit, (row) => row.createdAt.toISOString());
  return {
    items: page.items.map((row) => ({
      id: row.id,
      providerId: row.providerId,
      categoryId: row.categoryId,
      channel: row.channel,
      createdAt: row.createdAt,
      hasReview: row.review !== null,
    })),
    nextCursor: page.nextCursor,
  };
}
