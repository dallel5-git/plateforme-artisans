/**
 * BE-22d — `POST /v1/providers/:id/reviews`. Comme `providers-me.test.ts` (BE-19b) et
 * `contact-events.test.ts` (BE-21d) : seuls les rejets qui n'ont pas besoin de Postgres sont
 * couverts ici — la CI ne migre pas le schéma sur son Postgres de service (gap BE-02b). Le
 * comportement réel (dédup, agrégat, exactitude sous concurrence) est vérifié manuellement en
 * local, voir la description de PR.
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

// `providersRoutes` contient aussi `/providers/me*` (gardées par `app.requireRole`) — ce
// décorateur doit exister avant l'enregistrement des routes, même si ce fichier ne teste que le
// volet avis, même patron que `providers-me.test.ts` (BE-19b).
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

const PROVIDER_ID = '3c884497-1e37-45d3-95c2-beb49592844e';

describe('BE-22d — POST /v1/providers/:id/reviews', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('refuse une requête sans token (401 ACCESS_TOKEN_INVALID)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'POST',
      url: `/v1/providers/${PROVIDER_ID}/reviews`,
      payload: { rating: 5 },
    });

    expect(response.statusCode).toBe(401);
    expect(response.json().error.code).toBe('ACCESS_TOKEN_INVALID');
  });

  it('rejette un `:id` qui n’est pas un UUID (400 VALIDATION_ERROR)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'CLIENT' });
    const response = await app.inject({
      method: 'POST',
      url: '/v1/providers/pas-un-uuid/reviews',
      headers: { authorization: `Bearer ${token}` },
      payload: { rating: 5 },
    });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
  });

  it('rejette une `rating` hors 1-5 (400 VALIDATION_ERROR)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'CLIENT' });
    const response = await app.inject({
      method: 'POST',
      url: `/v1/providers/${PROVIDER_ID}/reviews`,
      headers: { authorization: `Bearer ${token}` },
      payload: { rating: 6 },
    });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
  });

  it('rejette un `comment` de plus de 1000 caractères (400 VALIDATION_ERROR)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'CLIENT' });
    const response = await app.inject({
      method: 'POST',
      url: `/v1/providers/${PROVIDER_ID}/reviews`,
      headers: { authorization: `Bearer ${token}` },
      payload: { rating: 5, comment: 'a'.repeat(1001) },
    });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
  });

  it('rejette une requête sans corps (400 VALIDATION_ERROR)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'CLIENT' });
    const response = await app.inject({
      method: 'POST',
      url: `/v1/providers/${PROVIDER_ID}/reviews`,
      headers: { authorization: `Bearer ${token}` },
    });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
  });
});
