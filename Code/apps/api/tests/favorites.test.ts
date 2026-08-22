/**
 * BE-25c — `PUT`/`DELETE /v1/favorites/:providerId`, `GET /v1/favorites`. Comme
 * `providers-reviews-create.test.ts` (BE-22d) et `contact-events.test.ts` (BE-21d) : seuls les
 * rejets qui n'ont pas besoin de Postgres sont couverts ici — la CI ne migre pas le schéma sur
 * son Postgres de service (gap BE-02b). Le comportement réel (idempotence de l'ajout, hydratation
 * de la liste, pagination) est vérifié manuellement en local, voir la description de PR.
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
import { favoritesRoutes } from '../src/routes/favorites.js';

// `favoritesRoutes` utilise `app.requireAuth` (preHandler) sur les 3 routes — décoré par
// `registerRequireAuth`, même patron que `providers-reviews-create.test.ts`.
async function buildTestApp() {
  const app = Fastify().withTypeProvider<ZodTypeProvider>();
  app.setValidatorCompiler(validatorCompiler);
  app.setSerializerCompiler(serializerCompiler);
  registerErrorHandler(app);
  registerRequireAuth(app);
  await app.register(favoritesRoutes, { prefix: '/v1' });
  return app;
}

const PROVIDER_ID = '3c884497-1e37-45d3-95c2-beb49592844e';

describe('BE-25c — PUT /v1/favorites/:providerId', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('refuse une requête sans token (401 ACCESS_TOKEN_INVALID)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({ method: 'PUT', url: `/v1/favorites/${PROVIDER_ID}` });

    expect(response.statusCode).toBe(401);
    expect(response.json().error.code).toBe('ACCESS_TOKEN_INVALID');
  });

  it('rejette un `:providerId` qui n’est pas un UUID (400 VALIDATION_ERROR)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'CLIENT' });
    const response = await app.inject({
      method: 'PUT',
      url: '/v1/favorites/pas-un-uuid',
      headers: { authorization: `Bearer ${token}` },
    });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
  });
});

describe('BE-25c — DELETE /v1/favorites/:providerId', () => {
  it('refuse une requête sans token (401 ACCESS_TOKEN_INVALID)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({ method: 'DELETE', url: `/v1/favorites/${PROVIDER_ID}` });

    expect(response.statusCode).toBe(401);
    expect(response.json().error.code).toBe('ACCESS_TOKEN_INVALID');
  });

  it('rejette un `:providerId` qui n’est pas un UUID (400 VALIDATION_ERROR)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'CLIENT' });
    const response = await app.inject({
      method: 'DELETE',
      url: '/v1/favorites/pas-un-uuid',
      headers: { authorization: `Bearer ${token}` },
    });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
  });
});

describe('BE-25c — GET /v1/favorites', () => {
  it('refuse une requête sans token (401 ACCESS_TOKEN_INVALID)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({ method: 'GET', url: '/v1/favorites' });

    expect(response.statusCode).toBe(401);
    expect(response.json().error.code).toBe('ACCESS_TOKEN_INVALID');
  });

  it('rejette une `limit` hors bornes (400 VALIDATION_ERROR)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'CLIENT' });
    const response = await app.inject({
      method: 'GET',
      url: '/v1/favorites?limit=0',
      headers: { authorization: `Bearer ${token}` },
    });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
  });
});
