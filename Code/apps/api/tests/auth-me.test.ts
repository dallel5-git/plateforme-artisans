/**
 * BE-10a — `GET /v1/auth/me` + preHandler `requireAuth` (BE-12, renommé depuis `authenticate`).
 *
 * App de test minimale (pas `buildServer()`) : évite toute dépendance à Postgres/Redis
 * (`env.ts`, `checkPostgres`/`checkRedis`) pour un test qui ne porte que sur le routage
 * auth ⇄ erreurs. Le chemin heureux (200, utilisateur réel) est vérifié manuellement en
 * `curl` une fois `otp/verify` (BE-10c) fournit de vrais tokens — voir description de PR.
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

describe('BE-10a — GET /v1/auth/me', () => {
  it('refuse une requête sans token (401 ACCESS_TOKEN_INVALID)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({ method: 'GET', url: '/v1/auth/me' });

    expect(response.statusCode).toBe(401);
    const body = response.json();
    expect(body.error.code).toBe('ACCESS_TOKEN_INVALID');
    expect(body.requestId).toBeTruthy();
  });

  it('refuse un token qui ne vérifie pas (401 ACCESS_TOKEN_INVALID)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'GET',
      url: '/v1/auth/me',
      headers: { authorization: 'Bearer ceci-n-est-pas-un-jwt' },
    });

    expect(response.statusCode).toBe(401);
    expect(response.json().error.code).toBe('ACCESS_TOKEN_INVALID');
  });

  it("l'enveloppe d'erreur ne contient jamais le token présenté", async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'GET',
      url: '/v1/auth/me',
      headers: { authorization: 'Bearer secret-a-ne-jamais-repeter' },
    });

    expect(response.body).not.toContain('secret-a-ne-jamais-repeter');
  });
});
