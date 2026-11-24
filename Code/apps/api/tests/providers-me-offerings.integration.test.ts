/**
 * BE-47c — `POST`/`PATCH`/`DELETE /v1/providers/me/offerings`, chemin réel (Postgres).
 * Complète `providers-me-offerings.test.ts` (rejets évaluables sans base) : chemin heureux
 * complet (create → update → delete) et le cas d'erreur explicite du critère d'acceptation
 * (prix négatif rejeté), déjà couvert par le schéma Zod mais vérifié ici de bout en bout.
 */
import { signAccessToken } from '@repo/core';
import { createTestCategory, createTestProvider } from '@repo/testing/db-test-utils';
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

describe('BE-47c — offerings (Postgres réel)', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('crée, modifie puis supprime une offre (200 → 200 → 204)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const provider = await createTestProvider();
    const category = await createTestCategory();
    const headers = {
      authorization: `Bearer ${await signAccessToken({ sub: provider.userId, role: 'PROVIDER' })}`,
    };

    const created = await app.inject({
      method: 'POST',
      url: '/v1/providers/me/offerings',
      headers,
      payload: {
        categoryId: category.id,
        titleFr: 'Débouchage évier',
        priceMin: 30,
        priceMax: 60,
      },
    });

    expect(created.statusCode).toBe(200);
    const createdBody = created.json();
    expect(createdBody.category.slug).toBe(category.slug);
    expect(createdBody.displayPrice).toBe('30 - 60 DT');

    const listRes = await app.inject({
      method: 'GET',
      url: '/v1/providers/me/offerings',
      headers,
    });
    expect(listRes.statusCode).toBe(200);
    const listBody = listRes.json();
    expect(listBody).toHaveLength(1);
    expect(listBody[0].id).toBe(createdBody.id);
    expect(listBody[0].titleFr).toBe('Débouchage évier');
    expect(listBody[0].displayPrice).toBe('30 - 60 DT');

    const updated = await app.inject({
      method: 'PATCH',
      url: `/v1/providers/me/offerings/${createdBody.id}`,
      headers,
      payload: { priceMin: 50, priceMax: 50 },
    });

    expect(updated.statusCode).toBe(200);
    const updatedBody = updated.json();
    expect(updatedBody.displayPrice).toBe('50 DT');
    expect(updatedBody.titleFr).toBe('Débouchage évier');

    const deleted = await app.inject({
      method: 'DELETE',
      url: `/v1/providers/me/offerings/${createdBody.id}`,
      headers,
    });
    expect(deleted.statusCode).toBe(204);

    const afterDelete = await app.inject({
      method: 'PATCH',
      url: `/v1/providers/me/offerings/${createdBody.id}`,
      headers,
      payload: { priceMin: 10 },
    });
    expect(afterDelete.statusCode).toBe(404);
  });

  it('rejette un prix négatif de bout en bout (400)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const provider = await createTestProvider();
    const category = await createTestCategory();
    const headers = {
      authorization: `Bearer ${await signAccessToken({ sub: provider.userId, role: 'PROVIDER' })}`,
    };

    const response = await app.inject({
      method: 'POST',
      url: '/v1/providers/me/offerings',
      headers,
      payload: { categoryId: category.id, titleFr: 'Peinture façade', priceMin: -10 },
    });

    expect(response.statusCode).toBe(400);
  });

  it("refuse une catégorie qui n'existe pas (404 NOT_FOUND)", async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const provider = await createTestProvider();
    const headers = {
      authorization: `Bearer ${await signAccessToken({ sub: provider.userId, role: 'PROVIDER' })}`,
    };

    const response = await app.inject({
      method: 'POST',
      url: '/v1/providers/me/offerings',
      headers,
      payload: {
        categoryId: '99999999-9999-4999-8999-999999999999',
        titleFr: 'Peinture façade',
      },
    });

    expect(response.statusCode).toBe(404);
    expect(response.json().error.code).toBe('NOT_FOUND');
  });
});
