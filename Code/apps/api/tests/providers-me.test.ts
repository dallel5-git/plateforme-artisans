/**
 * BE-19b — `POST`/`PATCH /v1/providers/me`. BE-44 — `GET /v1/providers/me`.
 *
 * Comme `auth-otp-verify.test.ts` (BE-10c) et `require-role.test.ts` (BE-12) : seuls les rejets
 * qui n'ont pas besoin de Postgres sont couverts ici (validation Zod avant tout accès `@repo/db`,
 * et les limites `requireAuth`/`requireRole`) — la CI ne migre pas le schéma sur le Postgres de
 * service. Le chemin heureux (création de profil, promotion de rôle, garde de publication à
 * 60 %, lecture du profil propriétaire) est vérifié dans `providers-me.integration.test.ts`.
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

const validCreateBody = {
  businessName: 'Sami Plomberie',
  baseGovernorateId: '11111111-1111-4111-8111-111111111111',
};

describe('BE-19b — POST /v1/providers/me', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('refuse une requête sans token (401 ACCESS_TOKEN_INVALID)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'POST',
      url: '/v1/providers/me',
      payload: validCreateBody,
    });

    expect(response.statusCode).toBe(401);
    expect(response.json().error.code).toBe('ACCESS_TOKEN_INVALID');
  });

  it('rejette un businessName trop court (400 VALIDATION_ERROR, avant tout accès DB)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'CLIENT' });
    const response = await app.inject({
      method: 'POST',
      url: '/v1/providers/me',
      headers: { authorization: `Bearer ${token}` },
      payload: { ...validCreateBody, businessName: 'A' },
    });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
  });

  it('rejette un baseGovernorateId qui n’est pas un UUID (400)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'CLIENT' });
    const response = await app.inject({
      method: 'POST',
      url: '/v1/providers/me',
      headers: { authorization: `Bearer ${token}` },
      payload: { ...validCreateBody, baseGovernorateId: 'pas-un-uuid' },
    });

    expect(response.statusCode).toBe(400);
  });
});

describe('BE-44 — GET /v1/providers/me', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('refuse une requête sans token (401 ACCESS_TOKEN_INVALID)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'GET',
      url: '/v1/providers/me',
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
      url: '/v1/providers/me',
      headers: { authorization: `Bearer ${token}` },
    });

    expect(response.statusCode).toBe(403);
    expect(response.json().error.code).toBe('FORBIDDEN');
  });
});

describe('BE-19b — PATCH /v1/providers/me', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('refuse une requête sans token (401 ACCESS_TOKEN_INVALID)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'PATCH',
      url: '/v1/providers/me',
      payload: {},
    });

    expect(response.statusCode).toBe(401);
    expect(response.json().error.code).toBe('ACCESS_TOKEN_INVALID');
  });

  it('refuse un rôle CLIENT (403 FORBIDDEN) — critère d’acceptation BE-19', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'CLIENT' });
    const response = await app.inject({
      method: 'PATCH',
      url: '/v1/providers/me',
      headers: { authorization: `Bearer ${token}` },
      payload: {},
    });

    expect(response.statusCode).toBe(403);
    expect(response.json().error.code).toBe('FORBIDDEN');
  });

  it('rejette un publicationStatus de modération (HIDDEN) — pas une route artisan (400)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'PROVIDER' });
    const response = await app.inject({
      method: 'PATCH',
      url: '/v1/providers/me',
      headers: { authorization: `Bearer ${token}` },
      payload: { publicationStatus: 'HIDDEN' },
    });

    expect(response.statusCode).toBe(400);
  });
});
