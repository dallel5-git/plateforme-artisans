/**
 * BE-12 — preHandler `requireRole`.
 *
 * Aucune route métier ne le consomme encore (BE-19/BE-20/BE-21/BE-25 pas commencés — même
 * situation que le primitif `enforceRateLimit` de BE-11) : testé via une route jetable, comme
 * `apps/api/tests/rate-limit.test.ts`, mais ici via le vrai mécanisme Fastify (`app.inject()`),
 * pas seulement la fonction sous-jacente.
 */
import { signAccessToken } from '@repo/core';
import Fastify from 'fastify';
import { afterEach, describe, expect, it, vi } from 'vitest';
import { registerErrorHandler } from '../src/plugins/error-handler.js';
import { registerRequireRole } from '../src/plugins/require-role.js';

async function buildTestApp() {
  const app = Fastify();
  registerErrorHandler(app);
  registerRequireRole(app);
  app.get('/admin-only', { preHandler: [app.requireRole('ADMIN')] }, async () => ({ ok: true }));
  return app;
}

describe('BE-12 — requireRole', () => {
  // `signAccessToken`/`verifyAccessToken` lisent `process.env.JWT_ACCESS_SECRET` directement
  // (hors du `env.ts` Zod-validé) — la CI ne le fournit pas globalement (voir `jwt.test.ts`,
  // BE-09, même convention `vi.stubEnv`).
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('refuse une requête sans token (401 ACCESS_TOKEN_INVALID)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({ method: 'GET', url: '/admin-only' });

    expect(response.statusCode).toBe(401);
    expect(response.json().error.code).toBe('ACCESS_TOKEN_INVALID');
  });

  it('refuse un rôle insuffisant (403 FORBIDDEN) — critère d’acceptation BE-12', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'CLIENT' });
    const response = await app.inject({
      method: 'GET',
      url: '/admin-only',
      headers: { authorization: `Bearer ${token}` },
    });

    expect(response.statusCode).toBe(403);
    expect(response.json().error.code).toBe('FORBIDDEN');
  });

  it('autorise un rôle suffisant', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'admin-1', role: 'ADMIN' });
    const response = await app.inject({
      method: 'GET',
      url: '/admin-only',
      headers: { authorization: `Bearer ${token}` },
    });

    expect(response.statusCode).toBe(200);
    expect(response.json()).toEqual({ ok: true });
  });
});
