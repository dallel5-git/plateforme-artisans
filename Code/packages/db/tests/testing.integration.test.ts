// QA-01a (absorbe BE-02b) : premier test de ce paquet qui touche une vraie PostgreSQL — le
// harnais que tous les autres tests d'intégration de QA-01b/c/d/e vont réutiliser. Suffixe
// `.integration.test.ts` (comme les futurs fichiers de QA-01) pour le distinguer d'un coup d'œil
// des tests purs déjà en place (pagination.test.ts, favorites.test.ts, ...).
import { afterAll, describe, expect, it } from 'vitest';
import {
  ProductionDatabaseGuardError,
  createTestCategory,
  createTestContactEventRow,
  createTestGovernorate,
  createTestProviderProfileRow,
  createTestUserRow,
  randomTestPhoneTn,
  resetTestDatabase,
  testDbClient,
} from '../src/testing.js';

describe('createTestUserRow / createTestGovernorate / createTestCategory', () => {
  it('crée des lignes valides, isolées par des valeurs uniques à chaque appel', async () => {
    const [userA, userB] = await Promise.all([createTestUserRow(), createTestUserRow()]);
    expect(userA.phone).not.toBe(userB.phone);
    expect(userA.id).not.toBe(userB.id);

    const [govA, govB] = await Promise.all([createTestGovernorate(), createTestGovernorate()]);
    expect(govA.slug).not.toBe(govB.slug);
    expect(govA.code).not.toBe(govB.code);

    const [catA, catB] = await Promise.all([createTestCategory(), createTestCategory()]);
    expect(catA.slug).not.toBe(catB.slug);
  });

  it('respecte les surcharges explicites (téléphone, rôle, gouvernorat)', async () => {
    const phone = randomTestPhoneTn();
    const user = await createTestUserRow({ phone, roles: ['PROVIDER'] });
    expect(user.phone).toBe(phone);
    expect(user.roles).toEqual(['PROVIDER']);
  });
});

describe('createTestProviderProfileRow', () => {
  it("crée un gouvernorat de test à la volée quand baseGovernorateId n'est pas fourni", async () => {
    const user = await createTestUserRow({ roles: ['PROVIDER'] });
    const profile = await createTestProviderProfileRow({ userId: user.id });

    expect(profile.userId).toBe(user.id);
    expect(profile.publicationStatus).toBe('DRAFT');
    const governorate = await testDbClient.governorate.findUnique({
      where: { id: profile.baseGovernorateId },
    });
    expect(governorate).not.toBeNull();
  });

  it('applique les surcharges (publicationStatus, isVerified)', async () => {
    const user = await createTestUserRow({ roles: ['PROVIDER'] });
    const profile = await createTestProviderProfileRow({
      userId: user.id,
      publicationStatus: 'PUBLISHED',
      isVerified: true,
    });

    expect(profile.publicationStatus).toBe('PUBLISHED');
    expect(profile.isVerified).toBe(true);
  });
});

describe('createTestContactEventRow', () => {
  it('accepte un `createdAt` dans le passé, hors de portée de `createContactEvent` (@repo/db)', async () => {
    const provider = await createTestProviderProfileRow({
      userId: (await createTestUserRow({ roles: ['PROVIDER'] })).id,
    });
    const client = await createTestUserRow();
    const twentyFourHoursAgo = new Date(Date.now() - 24 * 60 * 60 * 1000);

    const contact = await createTestContactEventRow({
      providerId: provider.id,
      clientId: client.id,
      createdAt: twentyFourHoursAgo,
    });

    expect(contact.createdAt.getTime()).toBe(twentyFourHoursAgo.getTime());
    expect(contact.channel).toBe('PHONE_CALL');
  });
});

describe('resetTestDatabase', () => {
  it('refuse de s’exécuter quand NODE_ENV=production (P8)', async () => {
    const original = process.env.NODE_ENV;
    process.env.NODE_ENV = 'production';
    try {
      await expect(resetTestDatabase()).rejects.toThrow(ProductionDatabaseGuardError);
    } finally {
      process.env.NODE_ENV = original;
    }
  });

  it('vide toutes les tables applicatives sans toucher `_prisma_migrations`', async () => {
    // Vérifie la disparition des lignes créées ICI, jamais un compte global de table : ce fichier
    // tourne sous `turbo run test` en même temps que packages/testing (QA-01a fait dépendre son
    // test de celui-ci, voir turbo.json, précisément pour que ce TRUNCATE global n'écrase jamais
    // les fixtures d'un autre paquet en cours d'exécution) — mais rien n'empêche un lecteur futur
    // de retirer cette dépendance sans remarquer pourquoi `toBe(0)` serait redevenu dangereux.
    const user = await createTestUserRow();
    const governorate = await createTestGovernorate();

    const migrationsBefore = await testDbClient.$queryRaw<{ count: bigint }[]>`
      SELECT COUNT(*)::bigint AS count FROM "_prisma_migrations"
    `;
    expect(Number(migrationsBefore[0]!.count)).toBeGreaterThan(0);

    await resetTestDatabase();

    const [userAfter, governorateAfter, migrationsAfter] = await Promise.all([
      testDbClient.user.findUnique({ where: { id: user.id } }),
      testDbClient.governorate.findUnique({ where: { id: governorate.id } }),
      testDbClient.$queryRaw<{ count: bigint }[]>`
        SELECT COUNT(*)::bigint AS count FROM "_prisma_migrations"
      `,
    ]);

    expect(userAfter).toBeNull();
    expect(governorateAfter).toBeNull();
    expect(Number(migrationsAfter[0]!.count)).toBe(Number(migrationsBefore[0]!.count));
  });
});

// QA-01d s'appuiera sur la même primitive ($queryRaw) pour prouver que le trigger SQL
// `prevent_self_review` (BE-02) rejette bien une auto-évaluation au niveau base — vérifié ici
// juste pour la connexion brute, la couverture applicative complète arrive avec ce ticket.
describe('accès Prisma brut exposé par ce module', () => {
  it('exécute une requête arbitraire sur la base de test', async () => {
    const result = await testDbClient.$queryRaw<{ value: number }[]>`SELECT 1 AS value`;
    expect(result[0]!.value).toBe(1);
  });
});

afterAll(async () => {
  await resetTestDatabase();
});
