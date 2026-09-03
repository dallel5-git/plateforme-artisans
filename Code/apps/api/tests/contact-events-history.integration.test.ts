/**
 * BE-45 — `GET /v1/contact-events`, chemin réel (Postgres). Complète `contact-events.test.ts`,
 * qui ne couvre que le rejet de format sans base — l'isolation par client et la pagination par
 * curseur (critères d'acceptation explicites de l'issue #242) n'ont pas d'équivalent testable
 * sans Postgres.
 */
import { signAccessToken } from '@repo/core';
import {
  createTestCategory,
  createTestClient,
  createTestContactEventRow,
  createTestProvider,
  createTestReviewRow,
} from '@repo/testing/db-test-utils';
import Fastify from 'fastify';
import {
  serializerCompiler,
  validatorCompiler,
  type ZodTypeProvider,
} from 'fastify-type-provider-zod';
import { afterEach, describe, expect, it, vi } from 'vitest';
import { registerErrorHandler } from '../src/plugins/error-handler.js';
import { registerRequireAuth } from '../src/plugins/require-auth.js';
import { contactsRoutes } from '../src/routes/contacts.js';

async function buildTestApp() {
  const app = Fastify().withTypeProvider<ZodTypeProvider>();
  app.setValidatorCompiler(validatorCompiler);
  app.setSerializerCompiler(serializerCompiler);
  registerErrorHandler(app);
  registerRequireAuth(app);
  await app.register(contactsRoutes, { prefix: '/v1' });
  return app;
}

async function authHeaderFor(userId: string) {
  const accessToken = await signAccessToken({ sub: userId, role: 'CLIENT' });
  return { authorization: `Bearer ${accessToken}` };
}

describe('BE-45 — GET /v1/contact-events (Postgres réel)', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('ne renvoie que les contacts du client authentifié, jamais ceux d’un autre compte', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const [clientA, clientB] = await Promise.all([createTestClient(), createTestClient()]);
    const provider = await createTestProvider();

    await createTestContactEventRow({ providerId: provider.providerId, clientId: clientA.id });
    await createTestContactEventRow({ providerId: provider.providerId, clientId: clientB.id });

    const response = await app.inject({
      method: 'GET',
      url: '/v1/contact-events',
      headers: await authHeaderFor(clientA.id),
    });

    expect(response.statusCode).toBe(200);
    const body = response.json();
    expect(body.items).toHaveLength(1);
    expect(body.items[0].providerId).toBe(provider.providerId);
  });

  it('pagine par curseur sur plus d’une page, triée par date décroissante', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const client = await createTestClient();
    const providerOld = await createTestProvider();
    const providerMid = await createTestProvider();
    const providerNew = await createTestProvider();

    const now = Date.now();
    await createTestContactEventRow({
      providerId: providerOld.providerId,
      clientId: client.id,
      createdAt: new Date(now - 3 * 60_000),
    });
    await createTestContactEventRow({
      providerId: providerMid.providerId,
      clientId: client.id,
      createdAt: new Date(now - 2 * 60_000),
    });
    await createTestContactEventRow({
      providerId: providerNew.providerId,
      clientId: client.id,
      createdAt: new Date(now - 1 * 60_000),
    });

    const firstPage = await app.inject({
      method: 'GET',
      url: '/v1/contact-events?limit=2',
      headers: await authHeaderFor(client.id),
    });
    expect(firstPage.statusCode).toBe(200);
    const firstBody = firstPage.json();
    expect(firstBody.items).toHaveLength(2);
    expect(firstBody.items[0].providerId).toBe(providerNew.providerId);
    expect(firstBody.items[1].providerId).toBe(providerMid.providerId);
    expect(firstBody.nextCursor).not.toBeNull();

    const secondPage = await app.inject({
      method: 'GET',
      url: `/v1/contact-events?limit=2&cursor=${encodeURIComponent(firstBody.nextCursor)}`,
      headers: await authHeaderFor(client.id),
    });
    expect(secondPage.statusCode).toBe(200);
    const secondBody = secondPage.json();
    expect(secondBody.items).toHaveLength(1);
    expect(secondBody.items[0].providerId).toBe(providerOld.providerId);
    expect(secondBody.nextCursor).toBeNull();
  });

  it('résout le nom de catégorie et `hasReview` (CTA conditionnel FM-31)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const client = await createTestClient();
    const providerReviewed = await createTestProvider();
    const providerPending = await createTestProvider();
    const category = await createTestCategory({ nameFr: 'Plomberie', nameAr: 'سباكة' });

    const reviewedEvent = await createTestContactEventRow({
      providerId: providerReviewed.providerId,
      clientId: client.id,
      categoryId: category.id,
      createdAt: new Date(Date.now() - 60_000),
    });
    await createTestReviewRow({
      providerId: providerReviewed.providerId,
      clientId: client.id,
      contactEventId: reviewedEvent.id,
    });
    await createTestContactEventRow({
      providerId: providerPending.providerId,
      clientId: client.id,
      channel: 'WHATSAPP',
    });

    const response = await app.inject({
      method: 'GET',
      url: '/v1/contact-events',
      headers: await authHeaderFor(client.id),
    });

    expect(response.statusCode).toBe(200);
    const items = response.json().items as Array<{
      providerId: string;
      categoryName: string | null;
      channel: string;
      hasReview: boolean;
    }>;

    const pending = items.find((item) => item.providerId === providerPending.providerId);
    expect(pending?.hasReview).toBe(false);
    expect(pending?.categoryName).toBeNull();
    expect(pending?.channel).toBe('WHATSAPP');

    const reviewed = items.find((item) => item.providerId === providerReviewed.providerId);
    expect(reviewed?.hasReview).toBe(true);
    expect(reviewed?.categoryName).toBe('Plomberie');
  });
});
