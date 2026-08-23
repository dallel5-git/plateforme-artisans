/**
 * BE-24c — `GET /v1/providers/me/stats`. Comme `providers-me.test.ts` (BE-19b) : seuls les rejets
 * qui n'ont pas besoin de Postgres sont couverts ici (limites `requireAuth`/`requireRole`, avant
 * tout accès `@repo/db`) — la CI ne migre pas le schéma sur le Postgres de service (gap
 * préexistant BE-02b). Le chemin heureux — totaux et série 30 j sans trou à partir du seed de
 * démo — est vérifié manuellement en `curl` en local, voir la description de la PR.
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

describe('BE-24c — GET /v1/providers/me/stats', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('refuse une requête sans token (401 ACCESS_TOKEN_INVALID)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({ method: 'GET', url: '/v1/providers/me/stats' });

    expect(response.statusCode).toBe(401);
    expect(response.json().error.code).toBe('ACCESS_TOKEN_INVALID');
  });

  it('refuse un rôle CLIENT — la route est réservée aux artisans (403 FORBIDDEN)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'client-1', role: 'CLIENT' });
    const response = await app.inject({
      method: 'GET',
      url: '/v1/providers/me/stats',
      headers: { authorization: `Bearer ${token}` },
    });

    expect(response.statusCode).toBe(403);
    expect(response.json().error.code).toBe('FORBIDDEN');
  });
});
