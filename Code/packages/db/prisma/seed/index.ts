// BE-03 : seed du référentiel (géographie, catégories, plan FREE, poids de ranking).
// Idempotent — chaque étape upsert sur une clé naturelle, rejouable sans doublon.
// Référentiel-only, safe pour tout environnement (y compris production). Les fixtures de
// démo (`dev-fixtures.ts`, BE-04) ne sont JAMAIS chargées ici — voir `seed-dev.ts`.
import { PrismaClient } from '@prisma/client';
import { seedGovernorates } from './governorates.js';
import { seedDelegations } from './delegations.js';
import { seedCategories } from './categories.js';
import { seedPlans } from './plans.js';
import { seedAppSettings } from './app-settings.js';

const prisma = new PrismaClient();

async function main() {
  const governorateIdByCode = await seedGovernorates(prisma);
  console.log(`✓ ${governorateIdByCode.size} gouvernorats`);

  await seedDelegations(prisma, governorateIdByCode);
  const delegationCount = await prisma.delegation.count();
  console.log(`✓ ${delegationCount} délégations (Sahel)`);

  await seedCategories(prisma);
  const categoryCount = await prisma.category.count();
  console.log(`✓ ${categoryCount} catégories`);

  await seedPlans(prisma);
  console.log('✓ plan FREE');

  await seedAppSettings(prisma);
  console.log('✓ poids de ranking (AppSetting)');
}

main()
  .catch((error: unknown) => {
    console.error(error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
