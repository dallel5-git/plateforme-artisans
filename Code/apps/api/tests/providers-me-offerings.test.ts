/**
 * BE-47c — `POST`/`PATCH`/`DELETE /v1/providers/me/offerings`.
 *
 * Comme `providers-me-portfolio.test.ts` (BE-20d) : `requireOwnProfile`/`requireOwnCategory`/
 * `requireOwnOffering` lisent d'abord la base, donc seuls les rejets évaluables avant tout accès
 * Prisma (auth, rôle, schéma Zod) sont couverts ici sans Postgres réel. Le chemin heureux et le
 * cas d'erreur métier (prix négatif) sont dans `providers-me-offerings.integration.test.ts`.
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

const CATEGORY_ID = '11111111-1111-4111-8111-111111111111';
const OFFERING_ID = '22222222-2222-4222-8222-222222222222';

describe('BE-47c — POST /v1/providers/me/offerings', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('refuse une requête sans token (401 ACCESS_TOKEN_INVALID)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'POST',
      url: '/v1/providers/me/offerings',
      payload: { categoryId: CATEGORY_ID, titleFr: 'Peinture' },
    });

    expect(response.statusCode).toBe(401);
    expect(response.json().error.code).toBe('ACCESS_TOKEN_INVALID');
  });

  it('refuse un rôle CLIENT (403 FORBIDDEN)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'CLIENT' });
    const response = await app.inject({
      method: 'POST',
      url: '/v1/providers/me/offerings',
      headers: { authorization: `Bearer ${token}` },
      payload: { categoryId: CATEGORY_ID, titleFr: 'Peinture' },
    });

    expect(response.statusCode).toBe(403);
    expect(response.json().error.code).toBe('FORBIDDEN');
  });

  it('rejette un titre vide (400, schéma Zod)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'PROVIDER' });
    const response = await app.inject({
      method: 'POST',
      url: '/v1/providers/me/offerings',
      headers: { authorization: `Bearer ${token}` },
      payload: { categoryId: CATEGORY_ID, titleFr: '' },
    });

    expect(response.statusCode).toBe(400);
  });

  it('rejette un prix négatif (400, schéma Zod)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'PROVIDER' });
    const response = await app.inject({
      method: 'POST',
      url: '/v1/providers/me/offerings',
      headers: { authorization: `Bearer ${token}` },
      payload: { categoryId: CATEGORY_ID, titleFr: 'Peinture', priceMin: -10 },
    });

    expect(response.statusCode).toBe(400);
  });
});

describe('BE-47c — PATCH /v1/providers/me/offerings/:id', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('refuse une requête sans token (401 ACCESS_TOKEN_INVALID)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'PATCH',
      url: `/v1/providers/me/offerings/${OFFERING_ID}`,
      payload: { titleFr: 'Peinture' },
    });

    expect(response.statusCode).toBe(401);
    expect(response.json().error.code).toBe('ACCESS_TOKEN_INVALID');
  });

  it('rejette un id mal formé (400, schéma Zod)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'PROVIDER' });
    const response = await app.inject({
      method: 'PATCH',
      url: '/v1/providers/me/offerings/not-a-uuid',
      headers: { authorization: `Bearer ${token}` },
      payload: { titleFr: 'Peinture' },
    });

    expect(response.statusCode).toBe(400);
  });
});

describe('BE-47c — DELETE /v1/providers/me/offerings/:id', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('refuse une requête sans token (401 ACCESS_TOKEN_INVALID)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'DELETE',
      url: `/v1/providers/me/offerings/${OFFERING_ID}`,
    });

    expect(response.statusCode).toBe(401);
    expect(response.json().error.code).toBe('ACCESS_TOKEN_INVALID');
  });

  it('refuse un rôle CLIENT (403 FORBIDDEN)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'CLIENT' });
    const response = await app.inject({
      method: 'DELETE',
      url: `/v1/providers/me/offerings/${OFFERING_ID}`,
      headers: { authorization: `Bearer ${token}` },
    });

    expect(response.statusCode).toBe(403);
    expect(response.json().error.code).toBe('FORBIDDEN');
  });
});

describe('BE-47c — GET /v1/providers/me/offerings', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('refuse une requête sans token (401 ACCESS_TOKEN_INVALID)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'GET',
      url: '/v1/providers/me/offerings',
    });

    expect(response.statusCode).toBe(401);
    expect(response.json().error.code).toBe('ACCESS_TOKEN_INVALID');
  });

  it('refuse un rôle CLIENT (403 FORBIDDEN)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'CLIENT' });
    const response = await app.inject({
      method: 'GET',
      url: '/v1/providers/me/offerings',
      headers: { authorization: `Bearer ${token}` },
    });

    expect(response.statusCode).toBe(403);
    expect(response.json().error.code).toBe('FORBIDDEN');
  });
});
