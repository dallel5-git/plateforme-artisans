// BE-04 : point d'entrée DÉDIÉ au développement local — rejoue le référentiel (BE-03) puis
// charge les 30 artisans de démonstration (BE-04). Ne JAMAIS appeler depuis un pipeline
// pointé vers une base partagée : `index.ts` (référentiel seul, `prisma db seed`) reste le
// seul point d'entrée safe pour tout environnement.
import { PrismaClient } from '@prisma/client';
import { seedGovernorates } from './governorates.js';
import { seedDelegations } from './delegations.js';
import { seedCategories } from './categories.js';
import { seedPlans } from './plans.js';
import { seedAppSettings } from './app-settings.js';
import { seedDevFixtures } from './dev-fixtures.js';

const prisma = new PrismaClient();

async function main() {
  const governorateIdByCode = await seedGovernorates(prisma);
  console.log(`✓ ${governorateIdByCode.size} gouvernorats`);

  await seedDelegations(prisma, governorateIdByCode);
  console.log(`✓ ${await prisma.delegation.count()} délégations (Sahel)`);

  await seedCategories(prisma);
  console.log(`✓ ${await prisma.category.count()} catégories`);

  await seedPlans(prisma);
  console.log('✓ plan FREE');

  await seedAppSettings(prisma);
  console.log('✓ poids de ranking (AppSetting)');

  await seedDevFixtures(prisma, governorateIdByCode);
  console.log(`✓ ${await prisma.providerProfile.count()} artisans de démonstration`);
}

main()
  .catch((error: unknown) => {
    console.error(error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
