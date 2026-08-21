/**
 * BE-10d — `POST /v1/auth/refresh` et `POST /v1/auth/logout`.
 *
 * Comme `auth-otp-verify.test.ts` (BE-10c) : seul le rejet de format (avant tout accès `@repo/db`)
 * est couvert ici, sans Postgres — le CI ne migre pas le schéma sur le Postgres de service. Le
 * chemin heureux, la rotation, et surtout le 🔒 scénario de rejeu (ROTATE puis REVOKE_FAMILY) sont
 * vérifiés manuellement en `curl` en local sur une base migrée — voir description de PR.
 */
import Fastify from 'fastify';
import {
  serializerCompiler,
  validatorCompiler,
  type ZodTypeProvider,
} from 'fastify-type-provider-zod';
import { describe, expect, it } from 'vitest';
import { registerRequireAuth } from '../src/plugins/require-auth.js';
import { registerErrorHandler } from '../src/plugins/error-handler.js';
import { authRoutes } from '../src/routes/auth.js';

async function buildTestApp() {
  const app = Fastify().withTypeProvider<ZodTypeProvider>();
  app.setValidatorCompiler(validatorCompiler);
  app.setSerializerCompiler(serializerCompiler);
  registerErrorHandler(app);
  registerRequireAuth(app);
  await app.register(authRoutes, { prefix: '/v1' });
  return app;
}

describe('BE-10d — POST /v1/auth/refresh', () => {
  it('rejette un refresh token sans séparateur `sessionId.tokenId` (401 REFRESH_TOKEN_INVALID)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'POST',
      url: '/v1/auth/refresh',
      payload: { refreshToken: 'pas-de-point' },
    });

    expect(response.statusCode).toBe(401);
    expect(response.json().error.code).toBe('REFRESH_TOKEN_INVALID');
  });

  it('rejette un body vide (400, schéma Zod)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({ method: 'POST', url: '/v1/auth/refresh', payload: {} });

    expect(response.statusCode).toBe(400);
  });
});

describe('BE-10d — POST /v1/auth/logout', () => {
  it('rejette un refresh token sans séparateur `sessionId.tokenId` (401 REFRESH_TOKEN_INVALID)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'POST',
      url: '/v1/auth/logout',
      payload: { refreshToken: 'pas-de-point' },
    });

    expect(response.statusCode).toBe(401);
    expect(response.json().error.code).toBe('REFRESH_TOKEN_INVALID');
  });
});
