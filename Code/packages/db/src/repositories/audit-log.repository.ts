// BE-05 : agrégat AuditLog — journal d'écriture seule côté applicatif (on insère, on ne met
// jamais à jour un log). `before`/`after` restent `unknown` : chaque module qui journalise sait
// quelle forme il y met.
import type { Prisma } from '@prisma/client';
import { prisma } from '../client.js';
import type { DbClient } from '../types.js';
import { buildKeysetOrderBy, buildKeysetWhere, buildPage, resolveLimit } from '../pagination.js';
import type { PaginatedResult } from '../pagination.js';

const select = {
  id: true,
  actorId: true,
  action: true,
  entityType: true,
  entityId: true,
  before: true,
  after: true,
  createdAt: true,
} as const;

export interface AuditLogEntry {
  id: string;
  actorId: string | null;
  action: string;
  entityType: string;
  entityId: string | null;
  before: unknown;
  after: unknown;
  createdAt: Date;
}

export interface CreateAuditLogInput {
  actorId?: string;
  action: string;
  entityType: string;
  entityId?: string;
  before?: unknown;
  after?: unknown;
  ipHash?: string;
  userAgent?: string;
}

export async function createAuditLog(
  input: CreateAuditLogInput,
  db: DbClient = prisma,
): Promise<void> {
  // `before`/`after` sont `unknown` côté API publique (chaque module journalise sa propre
  // forme) ; Prisma exige `InputJsonValue` en écriture — cast local justifié, pas un `any`.
  await db.auditLog.create({
    data: {
      actorId: input.actorId,
      action: input.action,
      entityType: input.entityType,
      entityId: input.entityId,
      before: input.before as Prisma.InputJsonValue | undefined,
      after: input.after as Prisma.InputJsonValue | undefined,
      ipHash: input.ipHash,
      userAgent: input.userAgent,
    },
    select: { id: true },
  });
}

/** Historique paginé pour une entité donnée — écran d'audit back-office (S2+). */
export async function listAuditLogForEntity(
  entityType: string,
  entityId: string,
  options: { cursor?: string; limit?: number } = {},
  db: DbClient = prisma,
): Promise<PaginatedResult<AuditLogEntry>> {
  const limit = resolveLimit(options.limit);
  const keysetWhere = buildKeysetWhere('createdAt', 'desc', options.cursor);

  const rows = await db.auditLog.findMany({
    where: keysetWhere ? { entityType, entityId, ...keysetWhere } : { entityType, entityId },
    select,
    orderBy: buildKeysetOrderBy('createdAt', 'desc'),
    take: limit + 1,
  });

  return buildPage(rows, limit, (row) => row.createdAt.toISOString());
}
