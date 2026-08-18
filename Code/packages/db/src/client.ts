// BE-05 : singleton PrismaClient — seul point de construction du client dans tout le
// monorepo (P1/P4). Garde anti-hot-reload : en dev (`tsx watch`), le module peut être ré-évalué
// sans redémarrer le process ; sans cette garde, chaque rechargement ouvrirait un nouveau pool
// de connexions Postgres.
import { PrismaClient } from '@prisma/client';

const globalForPrisma = globalThis as unknown as { prisma?: PrismaClient };

export const prisma: PrismaClient = globalForPrisma.prisma ?? new PrismaClient();

if (process.env.NODE_ENV !== 'production') {
  globalForPrisma.prisma = prisma;
}
