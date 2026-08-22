/**
 * BE-20c — `POST /v1/media/:id/process`.
 *
 * Contrairement à `media-presign.test.ts` (BE-20b), cette route lit d'abord le `MediaAsset` en
 * base (`findMediaAssetById`) avant même de vérifier la propriété — impossible ici de tester le
 * 404 ou le 403 de propriété sans Postgres réel (pas de mock de repository dans ce repo, voir
 * CLAUDE.md/convention établie). Seules les limites `requireRole` (401/403 rôle) sont couvertes
 * ici. Le reste (404 média inconnu, 403 média d'un autre utilisateur, chemin heureux avec de
 * vraies clés R2) est vérifié manuellement en `curl` en local — voir description de PR.
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
import { mediaRoutes } from '../src/routes/media.js';

async function buildTestApp() {
  const app = Fastify().withTypeProvider<ZodTypeProvider>();
  app.setValidatorCompiler(validatorCompiler);
  app.setSerializerCompiler(serializerCompiler);
  registerErrorHandler(app);
  registerRequireAuth(app);
  registerRequireRole(app);
  await app.register(mediaRoutes, { prefix: '/v1' });
  return app;
}

const MEDIA_ID = '11111111-1111-4111-8111-111111111111';

describe('BE-20c — POST /v1/media/:id/process', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('refuse une requête sans token (401 ACCESS_TOKEN_INVALID)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'POST',
      url: `/v1/media/${MEDIA_ID}/process`,
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
      url: `/v1/media/${MEDIA_ID}/process`,
      headers: { authorization: `Bearer ${token}` },
    });

    expect(response.statusCode).toBe(403);
    expect(response.json().error.code).toBe('FORBIDDEN');
  });

  it('rejette un id de média mal formé (400, schéma Zod)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'PROVIDER' });
    const response = await app.inject({
      method: 'POST',
      url: '/v1/media/not-a-uuid/process',
      headers: { authorization: `Bearer ${token}` },
    });

    expect(response.statusCode).toBe(400);
  });
});
