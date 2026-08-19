// BE-05 : agrégat Plan. Lecture seule côté MVP (un seul plan FREE en S1, écrit par le seed
// BE-03) — les écritures (création de plans payants) arrivent avec BE-32, S2+.
import type { Prisma } from '@prisma/client';
import { prisma } from '../client.js';
import type { DbClient } from '../types.js';

const select = {
  id: true,
  code: true,
  nameFr: true,
  nameAr: true,
  descriptionFr: true,
  price: true,
  billingPeriodDays: true,
  maxCategories: true,
  maxCoverageAreas: true,
  maxPortfolioItems: true,
  grantsVerifiedBadge: true,
  rankingBoostFactor: true,
  instantLeadAccess: true,
  advancedStats: true,
  welcomeCredits: true,
  isActive: true,
  sortOrder: true,
} as const;

type RawPlan = Prisma.PlanGetPayload<{ select: typeof select }>;

export interface Plan {
  id: string;
  code: string;
  nameFr: string;
  nameAr: string;
  descriptionFr: string | null;
  price: number;
  billingPeriodDays: number;
  maxCategories: number;
  maxCoverageAreas: number;
  maxPortfolioItems: number;
  grantsVerifiedBadge: boolean;
  rankingBoostFactor: number;
  instantLeadAccess: boolean;
  advancedStats: boolean;
  welcomeCredits: number;
  isActive: boolean;
  sortOrder: number;
}

function toPlan(row: RawPlan): Plan {
  return {
    ...row,
    price: row.price.toNumber(),
    rankingBoostFactor: row.rankingBoostFactor.toNumber(),
  };
}

export async function listActivePlans(db: DbClient = prisma): Promise<Plan[]> {
  const rows = await db.plan.findMany({
    where: { isActive: true },
    select,
    orderBy: { sortOrder: 'asc' },
  });
  return rows.map(toPlan);
}

export async function findPlanByCode(code: string, db: DbClient = prisma): Promise<Plan | null> {
  const row = await db.plan.findFirst({ where: { code, isActive: true }, select });
  return row ? toPlan(row) : null;
}
