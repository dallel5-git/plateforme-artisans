// BE-47b : CRUD `ServiceOffering` (addServiceOffering/updateServiceOffering/removeServiceOffering)
// sur une vraie PostgreSQL — harnais QA-01a (`../src/testing.js`), comme `testing.integration.test.ts`.
import { afterAll, describe, expect, it } from 'vitest';
import {
  addServiceOffering,
  listServiceOfferings,
  removeServiceOffering,
  updateServiceOffering,
} from '../src/repositories/provider-profile.repository.js';
import {
  createTestCategory,
  createTestProviderProfileRow,
  createTestUserRow,
  resetTestDatabase,
} from '../src/testing.js';

async function createOfferingFixture() {
  const user = await createTestUserRow({ roles: ['PROVIDER'] });
  const provider = await createTestProviderProfileRow({ userId: user.id });
  const category = await createTestCategory();
  return { provider, category };
}

describe('addServiceOffering / updateServiceOffering / removeServiceOffering', () => {
  it('crée une offre puis la retrouve via listServiceOfferings', async () => {
    const { provider, category } = await createOfferingFixture();

    const created = await addServiceOffering({
      providerId: provider.id,
      categoryId: category.id,
      titleFr: 'Débouchage évier',
      priceMin: 30,
      priceMax: 60,
    });

    expect(created.priceMin).toBe(30);
    expect(created.priceMax).toBe(60);
    expect(created.isActive).toBe(true);

    const offerings = await listServiceOfferings(provider.id);
    expect(offerings.map((o) => o.id)).toContain(created.id);
  });

  it('met à jour le prix sans changer le titre non modifié', async () => {
    const { provider, category } = await createOfferingFixture();
    const created = await addServiceOffering({
      providerId: provider.id,
      categoryId: category.id,
      titleFr: 'Peinture façade',
      priceMin: 100,
      priceMax: 100,
    });

    const updated = await updateServiceOffering(created.id, { priceMin: 150, priceMax: 200 });

    expect(updated.priceMin).toBe(150);
    expect(updated.priceMax).toBe(200);
    expect(updated.titleFr).toBe('Peinture façade');
  });

  it('removeServiceOffering désactive (soft-delete) — disparaît de listServiceOfferings', async () => {
    const { provider, category } = await createOfferingFixture();
    const created = await addServiceOffering({
      providerId: provider.id,
      categoryId: category.id,
      titleFr: 'Installation climatisation',
    });

    await removeServiceOffering(created.id);

    const offerings = await listServiceOfferings(provider.id);
    expect(offerings.map((o) => o.id)).not.toContain(created.id);
  });
});

afterAll(async () => {
  await resetTestDatabase();
});
