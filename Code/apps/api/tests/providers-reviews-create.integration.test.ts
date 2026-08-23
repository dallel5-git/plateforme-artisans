/**
 * QA-01d — `POST /v1/providers/:id/reviews`, chemin réel (Postgres + Redis). Complète
 * `providers-reviews-create.test.ts` (BE-22d), qui ne couvre que le rejet de format sans base —
 * dédup, agrégat transactionnel et exactitude sous concurrence étaient vérifiés manuellement en
 * local faute de harnais (BE-02b, absorbé par QA-01a). Couvre aussi les deux exigences
 * spécifiques de QA-01 : le trigger SQL `prevent_self_review` testé au niveau base, et un test
 * de concurrence réel sur le recalcul de `ratingAvg` (packages/db/src/repositories/
 * provider-profile.repository.ts, `recomputeRatingAggregate` + `lockProviderProfileForReviewWrite`).
 */
import { createReview, findProviderProfileById } from '@repo/db';
import { signAccessToken } from '@repo/core';
import {
  createTestClient,
  createTestContactEventRow,
  createTestProvider,
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
import { registerRequireRole } from '../src/plugins/require-role.js';
import { providersRoutes } from '../src/routes/providers.js';

async function buildTestApp() {
  const app = Fastify().withTypeProvider<ZodTypeProvider>();
  app.setValidatorCompiler(validatorCompiler);
  app.setSerializerCompiler(serializerCompiler);
  registerErrorHandler(app);
  registerRequireAuth(app);
  registerRequireRole(app);
  await app.register(providersRoutes, { prefix: '/v1' });
  return app;
}

// US-C-06 : fenêtre d'éligibilité (12h, 60j) exclusive — 13h est confortablement à l'intérieur
// sans dépendre d'une horloge de test figée.
const ELIGIBLE_CONTACT_AGE_MS = 13 * 60 * 60 * 1000;

async function createEligibleContact(providerId: string, clientId: string) {
  return createTestContactEventRow({
    providerId,
    clientId,
    createdAt: new Date(Date.now() - ELIGIBLE_CONTACT_AGE_MS),
  });
}

async function authHeaderFor(userId: string) {
  const accessToken = await signAccessToken({ sub: userId, role: 'CLIENT' });
  return { authorization: `Bearer ${accessToken}` };
}

describe('QA-01d — POST /v1/providers/:id/reviews (Postgres + Redis réels)', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('dépose un avis, recalcule ratingAvg/ratingCount (200)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const provider = await createTestProvider();
    const client = await createTestClient();
    await createEligibleContact(provider.providerId, client.id);

    const response = await app.inject({
      method: 'POST',
      url: `/v1/providers/${provider.providerId}/reviews`,
      headers: await authHeaderFor(client.id),
      payload: { rating: 4, comment: 'Ponctuel et soigné.' },
    });

    expect(response.statusCode).toBe(200);
    const body = response.json();
    expect(body.rating).toBe(4);
    expect(body.isVerifiedContact).toBe(true);

    const updated = await findProviderProfileById(provider.providerId);
    expect(updated!.ratingCount).toBe(1);
    expect(updated!.ratingAvg).toBe(4);
  });

  it('rejette un client sans contact éligible (403 REVIEW_REQUIRES_CONTACT)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const provider = await createTestProvider();
    const client = await createTestClient();
    // Contact bien réel, mais trop récent (< 12h) — US-C-06 rejette avant même une fenêtre large.
    await createTestContactEventRow({ providerId: provider.providerId, clientId: client.id });

    const response = await app.inject({
      method: 'POST',
      url: `/v1/providers/${provider.providerId}/reviews`,
      headers: await authHeaderFor(client.id),
      payload: { rating: 5 },
    });

    expect(response.statusCode).toBe(403);
    expect(response.json().error.code).toBe('REVIEW_REQUIRES_CONTACT');
  });

  it("rejette l'auto-évaluation — garde-fou applicatif (403 FORBIDDEN)", async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const provider = await createTestProvider();
    // Le garde-fou applicatif (handleCreateProviderReview) rejette avant même de chercher un
    // contact éligible — aucun contact n'est créé ici, volontairement.

    const response = await app.inject({
      method: 'POST',
      url: `/v1/providers/${provider.providerId}/reviews`,
      headers: await authHeaderFor(provider.userId),
      payload: { rating: 1 },
    });

    expect(response.statusCode).toBe(403);
    expect(response.json().error.code).toBe('FORBIDDEN');
  });

  it('🔒 le trigger SQL prevent_self_review rejette l’auto-évaluation même hors application', async () => {
    // Contourne délibérément handleCreateProviderReview (donc son garde-fou applicatif) pour
    // prouver que le filet de sécurité — le trigger Postgres lui-même — tient seul. C'est
    // l'exigence explicite de QA-01 : « le trigger anti-auto-avis est testé au niveau base ».
    const provider = await createTestProvider();
    const contact = await createEligibleContact(provider.providerId, provider.userId);

    await expect(
      createReview({
        providerId: provider.providerId,
        clientId: provider.userId,
        contactEventId: contact.id,
        rating: 5,
      }),
    ).rejects.toThrow(/propre profil/);

    const updated = await findProviderProfileById(provider.providerId);
    expect(updated!.ratingCount).toBe(0);
  });

  it('concurrence : deux avis simultanés sur le même artisan recalculent un agrégat exact (pas de perte d’écriture)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const provider = await createTestProvider();
    const [clientA, clientB] = await Promise.all([createTestClient(), createTestClient()]);
    await Promise.all([
      createEligibleContact(provider.providerId, clientA.id),
      createEligibleContact(provider.providerId, clientB.id),
    ]);

    const [responseA, responseB] = await Promise.all([
      app.inject({
        method: 'POST',
        url: `/v1/providers/${provider.providerId}/reviews`,
        headers: await authHeaderFor(clientA.id),
        payload: { rating: 5 },
      }),
      app.inject({
        method: 'POST',
        url: `/v1/providers/${provider.providerId}/reviews`,
        headers: await authHeaderFor(clientB.id),
        payload: { rating: 3 },
      }),
    ]);

    expect(responseA.statusCode).toBe(200);
    expect(responseB.statusCode).toBe(200);

    // Sans `lockProviderProfileForReviewWrite` (SELECT ... FOR UPDATE), les deux transactions
    // pourraient recalculer l'agrégat sur un instantané de `reviews` antérieur à l'INSERT de
    // l'autre — l'une des deux notes serait silencieusement perdue du calcul. Moyenne exacte de
    // 5 et 3 (=4, sans arrondi) : toute perte d'écriture ferait dévier ce nombre.
    const updated = await findProviderProfileById(provider.providerId);
    expect(updated!.ratingCount).toBe(2);
    expect(updated!.ratingAvg).toBe(4);
  });

  it('concurrence : deux dépôts simultanés sur le même contact n’en acceptent qu’un seul', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const provider = await createTestProvider();
    const client = await createTestClient();
    await createEligibleContact(provider.providerId, client.id);
    const headers = await authHeaderFor(client.id);

    const [first, second] = await Promise.all([
      app.inject({
        method: 'POST',
        url: `/v1/providers/${provider.providerId}/reviews`,
        headers,
        payload: { rating: 5 },
      }),
      app.inject({
        method: 'POST',
        url: `/v1/providers/${provider.providerId}/reviews`,
        headers,
        payload: { rating: 1 },
      }),
    ]);

    const statuses = [first.statusCode, second.statusCode].sort();
    expect(statuses).toEqual([200, 403]);
    const rejected = first.statusCode === 403 ? first : second;
    expect(rejected.json().error.code).toBe('REVIEW_REQUIRES_CONTACT');

    const updated = await findProviderProfileById(provider.providerId);
    expect(updated!.ratingCount).toBe(1);
  });
});
