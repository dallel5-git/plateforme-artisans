/**
 * BE-19c — `PUT /v1/providers/me/categories`.
 *
 * Même convention que `providers-me.test.ts` (BE-19b) : seuls les rejets qui n'ont pas besoin de
 * Postgres sont couverts ici (validation Zod / quota FREE, tous deux avant tout accès `@repo/db`,
 * et les limites `requireAuth`/`requireRole`). Le chemin heureux (remplacement du set, index
 * partiel unique `isPrimary` respecté, `completionScore` recalculé) est vérifié manuellement en
 * `curl` en local — voir description de PR.
 */
import { signAccessToken } from '@repo/core';
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
import { providerRoutes } from '../src/routes/providers.js';

async function buildTestApp() {
  const app = Fastify().withTypeProvider<ZodTypeProvider>();
  app.setValidatorCompiler(validatorCompiler);
  app.setSerializerCompiler(serializerCompiler);
  registerErrorHandler(app);
  registerRequireAuth(app);
  registerRequireRole(app);
  await app.register(providerRoutes, { prefix: '/v1' });
  return app;
}

const CATEGORY_A = '11111111-1111-4111-8111-111111111111';
const CATEGORY_B = '22222222-2222-4222-8222-222222222222';
const CATEGORY_C = '33333333-3333-4333-8333-333333333333';
const CATEGORY_D = '44444444-4444-4444-8444-444444444444';

describe('BE-19c — PUT /v1/providers/me/categories', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('refuse une requête sans token (401 ACCESS_TOKEN_INVALID)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'PUT',
      url: '/v1/providers/me/categories',
      payload: { categories: [{ categoryId: CATEGORY_A, isPrimary: true }] },
    });

    expect(response.statusCode).toBe(401);
    expect(response.json().error.code).toBe('ACCESS_TOKEN_INVALID');
  });

  it('refuse un rôle CLIENT (403 FORBIDDEN)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'CLIENT' });
    const response = await app.inject({
      method: 'PUT',
      url: '/v1/providers/me/categories',
      headers: { authorization: `Bearer ${token}` },
      payload: { categories: [{ categoryId: CATEGORY_A, isPrimary: true }] },
    });

    expect(response.statusCode).toBe(403);
    expect(response.json().error.code).toBe('FORBIDDEN');
  });

  it('rejette 0 catégorie principale (400, schéma Zod) — critère US-P-02', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'PROVIDER' });
    const response = await app.inject({
      method: 'PUT',
      url: '/v1/providers/me/categories',
      headers: { authorization: `Bearer ${token}` },
      payload: { categories: [{ categoryId: CATEGORY_A, isPrimary: false }] },
    });

    expect(response.statusCode).toBe(400);
  });

  it('rejette 2 catégories principales (400, schéma Zod)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'PROVIDER' });
    const response = await app.inject({
      method: 'PUT',
      url: '/v1/providers/me/categories',
      headers: { authorization: `Bearer ${token}` },
      payload: {
        categories: [
          { categoryId: CATEGORY_A, isPrimary: true },
          { categoryId: CATEGORY_B, isPrimary: true },
        ],
      },
    });

    expect(response.statusCode).toBe(400);
  });

  it('refuse plus de 3 catégories en offre gratuite (400 VALIDATION_ERROR, avant tout accès DB) — critère US-P-02', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'PROVIDER' });
    const response = await app.inject({
      method: 'PUT',
      url: '/v1/providers/me/categories',
      headers: { authorization: `Bearer ${token}` },
      payload: {
        categories: [
          { categoryId: CATEGORY_A, isPrimary: true },
          { categoryId: CATEGORY_B, isPrimary: false },
          { categoryId: CATEGORY_C, isPrimary: false },
          { categoryId: CATEGORY_D, isPrimary: false },
        ],
      },
    });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
    expect(response.json().error.details.limit).toBe(3);
  });
});
