/**
 * BE-20b — `POST /v1/media/presign`.
 *
 * Même convention que `providers-me-categories.test.ts` (BE-19c) : seuls les rejets qui n'ont pas
 * besoin de Postgres/R2 sont couverts ici (limites `requireRole`, type MIME non supporté, taille
 * excessive — tous deux avant tout accès `@repo/db`/`@repo/storage` réel). Le chemin heureux
 * (création du `MediaAsset`, URL pré-signée renvoyée) est vérifié manuellement en `curl` en local
 * avec de vraies clés R2 — voir description de PR.
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

const VALID_PAYLOAD = {
  filename: 'chantier.jpg',
  mimeType: 'image/jpeg',
  sizeBytes: 1024,
};

describe('BE-20b — POST /v1/media/presign', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('refuse une requête sans token (401 ACCESS_TOKEN_INVALID)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'POST',
      url: '/v1/media/presign',
      payload: VALID_PAYLOAD,
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
      url: '/v1/media/presign',
      headers: { authorization: `Bearer ${token}` },
      payload: VALID_PAYLOAD,
    });

    expect(response.statusCode).toBe(403);
    expect(response.json().error.code).toBe('FORBIDDEN');
  });

  it('rejette un filename vide (400, schéma Zod)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'PROVIDER' });
    const response = await app.inject({
      method: 'POST',
      url: '/v1/media/presign',
      headers: { authorization: `Bearer ${token}` },
      payload: { ...VALID_PAYLOAD, filename: '' },
    });

    expect(response.statusCode).toBe(400);
  });

  it('refuse un type MIME non supporté (400 MEDIA_UNSUPPORTED_TYPE, avant tout accès DB/R2)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'PROVIDER' });
    const response = await app.inject({
      method: 'POST',
      url: '/v1/media/presign',
      headers: { authorization: `Bearer ${token}` },
      payload: { ...VALID_PAYLOAD, mimeType: 'application/pdf' },
    });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('MEDIA_UNSUPPORTED_TYPE');
  });

  it('refuse un fichier trop volumineux (400 MEDIA_TOO_LARGE, avant tout accès DB/R2) — critère BE-20', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'PROVIDER' });
    const response = await app.inject({
      method: 'POST',
      url: '/v1/media/presign',
      headers: { authorization: `Bearer ${token}` },
      payload: { ...VALID_PAYLOAD, sizeBytes: 9 * 1024 * 1024 },
    });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('MEDIA_TOO_LARGE');
    expect(response.json().error.details.maxSizeBytes).toBe(8 * 1024 * 1024);
  });
});
