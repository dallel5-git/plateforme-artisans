// BE-05 : agrégat Session. `refreshTokenHash` n'est jamais renvoyé par un `select` — un
// consommateur compare son propre hash au moment de la vérification, il n'a pas besoin qu'on le
// lui redonne (P8-adjacent : ne jamais faire circuler un secret plus que nécessaire).
import { prisma } from '../client.js';
import type { DbClient } from '../types.js';

const publicSelect = {
  id: true,
  userId: true,
  userAgent: true,
  deviceLabel: true,
  expiresAt: true,
  revokedAt: true,
  createdAt: true,
} as const;

export interface PublicSession {
  id: string;
  userId: string;
  userAgent: string | null;
  deviceLabel: string | null;
  expiresAt: Date;
  revokedAt: Date | null;
  createdAt: Date;
}

export interface CreateSessionInput {
  userId: string;
  refreshTokenHash: string;
  userAgent?: string;
  ipHash?: string;
  deviceLabel?: string;
  expiresAt: Date;
}

export async function createSession(
  input: CreateSessionInput,
  db: DbClient = prisma,
): Promise<PublicSession> {
  return db.session.create({ data: input, select: publicSelect });
}

export async function findSessionByRefreshTokenHash(
  refreshTokenHash: string,
  db: DbClient = prisma,
): Promise<PublicSession | null> {
  return db.session.findUnique({ where: { refreshTokenHash }, select: publicSelect });
}

export async function listActiveSessionsForUser(
  userId: string,
  db: DbClient = prisma,
): Promise<PublicSession[]> {
  return db.session.findMany({
    where: { userId, revokedAt: null, expiresAt: { gt: new Date() } },
    select: publicSelect,
    orderBy: { createdAt: 'desc' },
  });
}

export async function revokeSession(id: string, db: DbClient = prisma): Promise<void> {
  await db.session.update({ where: { id }, data: { revokedAt: new Date() }, select: { id: true } });
}

/** Détection de rejeu (BE-09) : un refresh déjà utilisé révoque toute la famille de sessions. */
export async function revokeAllSessionsForUser(userId: string, db: DbClient = prisma): Promise<void> {
  await db.session.updateMany({
    where: { userId, revokedAt: null },
    data: { revokedAt: new Date() },
  });
}
