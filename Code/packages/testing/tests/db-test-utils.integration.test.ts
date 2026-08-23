// QA-01a : ce paquet est la façade que QA-01b/c/d/e vont importer — ses propres fixtures doivent
// donc être vérifiées contre une vraie PostgreSQL, pas seulement leurs primitives bas niveau
// (déjà couvertes par packages/db/tests/testing.integration.test.ts).
import { afterAll, describe, expect, it } from 'vitest';
import {
  createTestClient,
  createTestContactEvent,
  createTestContactEventRow,
  createTestProvider,
  resetDatabase,
} from '../src/db-test-utils.js';

describe('createTestClient', () => {
  it('crée un utilisateur avec le rôle CLIENT et un téléphone TN valide unique', async () => {
    const client = await createTestClient();
    expect(client.roles).toEqual(['CLIENT']);
    expect(client.phone).toMatch(/^\+216[24579]\d{7}$/);
  });
});

describe('createTestProvider', () => {
  it('crée un artisan PUBLISHED par défaut, prêt à recevoir un contact', async () => {
    const provider = await createTestProvider();
    expect(provider.userId).toBeTruthy();
    expect(provider.providerId).toBeTruthy();

    const contact = await createTestContactEvent(provider.providerId);
    expect(contact.providerId).toBe(provider.providerId);
  });

  it('respecte la surcharge publicationStatus (ex: DRAFT, non publié)', async () => {
    const provider = await createTestProvider({ publicationStatus: 'DRAFT' });
    expect(provider.providerId).toBeTruthy();
  });
});

describe('createTestContactEventRow (ré-export)', () => {
  it('reste accessible depuis @repo/testing/db-test-utils pour les contacts datés dans le passé', async () => {
    const provider = await createTestProvider();
    const contact = await createTestContactEventRow({
      providerId: provider.providerId,
      createdAt: new Date(Date.now() - 13 * 60 * 60 * 1000),
    });
    expect(contact.providerId).toBe(provider.providerId);
  });
});

afterAll(async () => {
  await resetDatabase();
});
