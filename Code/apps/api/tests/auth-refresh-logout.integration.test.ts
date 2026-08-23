/**
 * QA-01b — `POST /v1/auth/refresh` et `POST /v1/auth/logout`, chemin réel (Postgres). Complète
 * `auth-refresh-logout.test.ts` (BE-10d), qui ne couvre que le rejet de format sans base. Le
 * scénario de rejeu ci-dessous est le pendant intégration du test 🔒 NON-RÉGRESSION unitaire
 * `packages/core/tests/auth-session.test.ts` (`detectRefreshReplay`, ADR-006 §4) : celui-là
 * prouve la règle en isolation, celui-ci prouve que la route l'applique réellement de bout en
 * bout (session Postgres, rotation, révocation de la famille).
 */
import { findSessionById } from '@repo/db';
import { createTestClient, createTestSession } from '@repo/testing/db-test-utils';
import Fastify from 'fastify';
import {
  serializerCompiler,
  validatorCompiler,
  type ZodTypeProvider,
} from 'fastify-type-provider-zod';
import { describe, expect, it, vi } from 'vitest';
import { registerErrorHandler } from '../src/plugins/error-handler.js';
import { registerRequireAuth } from '../src/plugins/require-auth.js';
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

describe('QA-01b — POST /v1/auth/refresh (Postgres réel)', () => {
  it('fait tourner le token et met à jour le hash en base (200)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const client = await createTestClient();
    const session = await createTestSession(client.id);

    const response = await app.inject({
      method: 'POST',
      url: '/v1/auth/refresh',
      payload: { refreshToken: session.refreshToken },
    });

    expect(response.statusCode).toBe(200);
    const body = response.json();
    expect(body.accessToken).toBeTruthy();
    expect(body.refreshToken).not.toBe(session.refreshToken);
    expect(body.refreshToken.startsWith(session.sessionId)).toBe(true);

    const row = await findSessionById(session.sessionId);
    expect(row!.revokedAt).toBeNull();

    vi.unstubAllEnvs();
  });

  it('🔒 rejoue un refresh token déjà tourné → révoque toute la famille (401 REFRESH_TOKEN_REUSED)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const client = await createTestClient();
    const session = await createTestSession(client.id);

    // Premier /refresh : légitime, tourne le token (ROTATE).
    const first = await app.inject({
      method: 'POST',
      url: '/v1/auth/refresh',
      payload: { refreshToken: session.refreshToken },
    });
    expect(first.statusCode).toBe(200);

    // Rejeu de l'ANCIEN token — un attaquant qui aurait intercepté le premier refreshToken.
    const replay = await app.inject({
      method: 'POST',
      url: '/v1/auth/refresh',
      payload: { refreshToken: session.refreshToken },
    });

    expect(replay.statusCode).toBe(401);
    expect(replay.json().error.code).toBe('REFRESH_TOKEN_REUSED');

    // La famille entière est révoquée — même le token légitime issu du premier /refresh ne
    // fonctionne plus : c'est la garantie que teste ce fichier, au-delà du seul rejeu.
    const row = await findSessionById(session.sessionId);
    expect(row!.revokedAt).not.toBeNull();

    const afterRevocation = await app.inject({
      method: 'POST',
      url: '/v1/auth/refresh',
      payload: { refreshToken: first.json().refreshToken },
    });
    expect(afterRevocation.statusCode).toBe(401);
    expect(afterRevocation.json().error.code).toBe('REFRESH_TOKEN_REUSED');

    vi.unstubAllEnvs();
  });

  it('rejette une session expirée (401 REFRESH_TOKEN_INVALID)', async () => {
    const app = await buildTestApp();
    const client = await createTestClient();
    const session = await createTestSession(client.id, {
      expiresAt: new Date(Date.now() - 1000),
    });

    const response = await app.inject({
      method: 'POST',
      url: '/v1/auth/refresh',
      payload: { refreshToken: session.refreshToken },
    });

    expect(response.statusCode).toBe(401);
    expect(response.json().error.code).toBe('REFRESH_TOKEN_INVALID');
  });

  it('rejette un `sessionId` inconnu (401 REFRESH_TOKEN_INVALID)', async () => {
    const app = await buildTestApp();

    const response = await app.inject({
      method: 'POST',
      url: '/v1/auth/refresh',
      payload: { refreshToken: '00000000-0000-0000-0000-000000000000.un-token-quelconque' },
    });

    expect(response.statusCode).toBe(401);
    expect(response.json().error.code).toBe('REFRESH_TOKEN_INVALID');
  });
});

describe('QA-01b — POST /v1/auth/logout (Postgres réel)', () => {
  it('révoque la session associée (200, revokedAt renseigné en base)', async () => {
    const app = await buildTestApp();
    const client = await createTestClient();
    const session = await createTestSession(client.id);

    const response = await app.inject({
      method: 'POST',
      url: '/v1/auth/logout',
      payload: { refreshToken: session.refreshToken },
    });

    expect(response.statusCode).toBe(200);
    expect(response.json()).toEqual({ status: 'ok' });

    const row = await findSessionById(session.sessionId);
    expect(row!.revokedAt).not.toBeNull();
  });

  it('reste idempotent sur une session déjà révoquée (200, pas d’erreur)', async () => {
    const app = await buildTestApp();
    const client = await createTestClient();
    const session = await createTestSession(client.id);

    await app.inject({
      method: 'POST',
      url: '/v1/auth/logout',
      payload: { refreshToken: session.refreshToken },
    });
    const second = await app.inject({
      method: 'POST',
      url: '/v1/auth/logout',
      payload: { refreshToken: session.refreshToken },
    });

    expect(second.statusCode).toBe(200);
    expect(second.json()).toEqual({ status: 'ok' });
  });

  it('reste idempotent sur un `sessionId` qui n’a jamais existé (200, pas d’erreur)', async () => {
    const app = await buildTestApp();

    const response = await app.inject({
      method: 'POST',
      url: '/v1/auth/logout',
      payload: { refreshToken: '00000000-0000-0000-0000-000000000000.un-token-quelconque' },
    });

    expect(response.statusCode).toBe(200);
    expect(response.json()).toEqual({ status: 'ok' });
  });
});
