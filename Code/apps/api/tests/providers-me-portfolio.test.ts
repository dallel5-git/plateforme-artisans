/**
 * BE-20d — `POST`/`DELETE /v1/providers/me/portfolio`.
 *
 * Même limite que `media-process.test.ts` (BE-20c) : ces deux routes lisent d'abord le profil
 * artisan (`requireOwnProfile`) puis le quota/le média/l'élément en base avant toute vérification
 * métier — pas testable sans Postgres réel au-delà des limites `requireRole`. Le quota FREE
 * (5 photos), le rattachement d'un média `APPROVED` appartenant à l'appelant, et la suppression
 * sont vérifiés manuellement en `curl` en local — voir description de PR.
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

const MEDIA_ID = '11111111-1111-4111-8111-111111111111';
const ITEM_ID = '22222222-2222-4222-8222-222222222222';

describe('BE-20d — POST /v1/providers/me/portfolio', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('refuse une requête sans token (401 ACCESS_TOKEN_INVALID)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'POST',
      url: '/v1/providers/me/portfolio',
      payload: { mediaId: MEDIA_ID },
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
      url: '/v1/providers/me/portfolio',
      headers: { authorization: `Bearer ${token}` },
      payload: { mediaId: MEDIA_ID },
    });

    expect(response.statusCode).toBe(403);
    expect(response.json().error.code).toBe('FORBIDDEN');
  });

  it('rejette un mediaId mal formé (400, schéma Zod)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'PROVIDER' });
    const response = await app.inject({
      method: 'POST',
      url: '/v1/providers/me/portfolio',
      headers: { authorization: `Bearer ${token}` },
      payload: { mediaId: 'not-a-uuid' },
    });

    expect(response.statusCode).toBe(400);
  });
});

describe('BE-20d — DELETE /v1/providers/me/portfolio/:id', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('refuse une requête sans token (401 ACCESS_TOKEN_INVALID)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'DELETE',
      url: `/v1/providers/me/portfolio/${ITEM_ID}`,
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
      url: `/v1/providers/me/portfolio/${ITEM_ID}`,
      headers: { authorization: `Bearer ${token}` },
    });

    expect(response.statusCode).toBe(403);
    expect(response.json().error.code).toBe('FORBIDDEN');
  });

  it('rejette un id mal formé (400, schéma Zod)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'PROVIDER' });
    const response = await app.inject({
      method: 'DELETE',
      url: '/v1/providers/me/portfolio/not-a-uuid',
      headers: { authorization: `Bearer ${token}` },
    });

    expect(response.statusCode).toBe(400);
  });
});
