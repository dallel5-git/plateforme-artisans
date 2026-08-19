// BE-03 : plan FREE uniquement en S1 (les plans Pro payants arrivent avec BE-32, S2+ —
// bloqué par ADR-004 sur les moyens de paiement, question 2 du cadrage).
import type { PrismaClient } from '@prisma/client';

// Le badge « Vérifié » (grantsVerifiedBadge) reste `false` ici par construction :
// ADR-002 l'établit sur l'identité (CIN), jamais sur le plan payant.
const FREE_PLAN = {
  code: 'FREE',
  nameFr: 'Gratuit',
  nameAr: 'مجاني',
  descriptionFr: 'Offre de base : profil, catégories et zone de couverture limitées.',
  price: 0,
  // Pas de cycle de facturation réel sur un plan gratuit — valeur "sans expiration" (~100 ans).
  billingPeriodDays: 36500,
  maxCategories: 3,
  maxCoverageAreas: 1,
  maxPortfolioItems: 5,
  grantsVerifiedBadge: false,
  rankingBoostFactor: 1.0,
  instantLeadAccess: false,
  advancedStats: false,
  welcomeCredits: 0,
  isActive: true,
  sortOrder: 1,
};

export async function seedPlans(prisma: PrismaClient): Promise<void> {
  await prisma.plan.upsert({
    where: { code: FREE_PLAN.code },
    create: FREE_PLAN,
    update: FREE_PLAN,
  });
}
