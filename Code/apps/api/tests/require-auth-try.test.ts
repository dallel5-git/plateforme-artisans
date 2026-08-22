/**
 * BE-21 — preHandler `tryAuth`.
 *
 * Première route à accepter authentifié ET anonyme (contact-events) : testé via une route
 * jetable et le vrai mécanisme Fastify (`app.inject()`), même patron que
 * `apps/api/tests/require-role.test.ts`.
 */
import { signAccessToken } from '@repo/core';
import Fastify from 'fastify';
import { afterEach, describe, expect, it, vi } from 'vitest';
import { registerErrorHandler } from '../src/plugins/error-handler.js';
import { registerRequireAuth } from '../src/plugins/require-auth.js';

async function buildTestApp() {
  const app = Fastify();
  registerErrorHandler(app);
  registerRequireAuth(app);
  app.get('/maybe-auth', { preHandler: [app.tryAuth] }, async (request) => ({
    authenticated: request.user !== undefined,
  }));
  return app;
}

describe('BE-21 — tryAuth', () => {
  // Même convention que `require-role.test.ts` (BE-12) : `signAccessToken`/`verifyAccessToken`
  // lisent `process.env.JWT_ACCESS_SECRET` directement, hors du `env.ts` Zod-validé.
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('en-tête absent → anonyme, aucune erreur levée', async () => {
    const app = await buildTestApp();
    const response = await app.inject({ method: 'GET', url: '/maybe-auth' });

    expect(response.statusCode).toBe(200);
    expect(response.json()).toEqual({ authenticated: false });
  });

  it('token valide → request.user peuplé', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'CLIENT' });
    const response = await app.inject({
      method: 'GET',
      url: '/maybe-auth',
      headers: { authorization: `Bearer ${token}` },
    });

    expect(response.statusCode).toBe(200);
    expect(response.json()).toEqual({ authenticated: true });
  });

  it('en-tête présent mais token invalide → 401 (rejette, ne dégrade pas en anonyme)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'GET',
      url: '/maybe-auth',
      headers: { authorization: 'Bearer un-token-invalide' },
    });

    expect(response.statusCode).toBe(401);
    expect(response.json().error.code).toBe('ACCESS_TOKEN_INVALID');
  });
});
