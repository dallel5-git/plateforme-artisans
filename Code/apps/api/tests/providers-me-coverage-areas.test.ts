/**
 * BE-19d — `PUT /v1/providers/me/coverage-areas`.
 *
 * Même convention que `providers-me-categories.test.ts` (BE-19c) : seuls les rejets qui n'ont pas
 * besoin de Postgres sont couverts ici. Le chemin heureux (remplacement du set,
 * `delegationId` absent = tout le gouvernorat, `completionScore` recalculé) est vérifié
 * manuellement en `curl` en local — voir description de PR.
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
import { providerRoutes } from '../src/routes/providers.js';

async function buildTestApp() {
  const app = Fastify().withTypeProvider<ZodTypeProvider>();
  app.setValidatorCompiler(validatorCompiler);
  app.setSerializerCompiler(serializerCompiler);
  registerErrorHandler(app);
  registerRequireAuth(app);
  registerRequireRole(app);
  await app.register(providerRoutes, { prefix: '/v1' });
  return app;
}

const GOVERNORATE_A = '11111111-1111-4111-8111-111111111111';
const GOVERNORATE_B = '22222222-2222-4222-8222-222222222222';
const DELEGATION_A1 = '33333333-3333-4333-8333-333333333333';
const DELEGATION_A2 = '44444444-4444-4444-8444-444444444444';

describe('BE-19d — PUT /v1/providers/me/coverage-areas', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('refuse une requête sans token (401 ACCESS_TOKEN_INVALID)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'PUT',
      url: '/v1/providers/me/coverage-areas',
      payload: { coverageAreas: [{ governorateId: GOVERNORATE_A }] },
    });

    expect(response.statusCode).toBe(401);
    expect(response.json().error.code).toBe('ACCESS_TOKEN_INVALID');
  });

  it('refuse un rôle CLIENT (403 FORBIDDEN)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'CLIENT' });
    const response = await app.inject({
      method: 'PUT',
      url: '/v1/providers/me/coverage-areas',
      headers: { authorization: `Bearer ${token}` },
      payload: { coverageAreas: [{ governorateId: GOVERNORATE_A }] },
    });

    expect(response.statusCode).toBe(403);
    expect(response.json().error.code).toBe('FORBIDDEN');
  });

  it(
    'autorise plusieurs délégations du même gouvernorat sans dépasser le quota FREE ' +
      '(1 seul gouvernorat distinct) — passe la validation de quota, échoue ensuite sans DB',
    async () => {
      vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
      const app = await buildTestApp();
      const token = await signAccessToken({ sub: 'u1', role: 'PROVIDER' });
      const response = await app.inject({
        method: 'PUT',
        url: '/v1/providers/me/coverage-areas',
        headers: { authorization: `Bearer ${token}` },
        payload: {
          coverageAreas: [
            { governorateId: GOVERNORATE_A, delegationId: DELEGATION_A1 },
            { governorateId: GOVERNORATE_A, delegationId: DELEGATION_A2 },
          ],
        },
      });

      // Le quota (1 gouvernorat distinct) est respecté ici — la requête passe le contrôle de
      // quota et échoue seulement plus loin, faute de Postgres dans cet environnement de test
      // (pas de profil réel à trouver). Ce qui compte : ce n'est PAS un 400 de quota.
      expect(response.statusCode).not.toBe(400);
    },
  );

  it('refuse 2 gouvernorats distincts en offre gratuite (400 VALIDATION_ERROR, avant tout accès DB) — critère US-P-03', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'PROVIDER' });
    const response = await app.inject({
      method: 'PUT',
      url: '/v1/providers/me/coverage-areas',
      headers: { authorization: `Bearer ${token}` },
      payload: {
        coverageAreas: [{ governorateId: GOVERNORATE_A }, { governorateId: GOVERNORATE_B }],
      },
    });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
    expect(response.json().error.details.limit).toBe(1);
  });

  it('rejette un governorateId qui n’est pas un UUID (400, schéma Zod)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'PROVIDER' });
    const response = await app.inject({
      method: 'PUT',
      url: '/v1/providers/me/coverage-areas',
      headers: { authorization: `Bearer ${token}` },
      payload: { coverageAreas: [{ governorateId: 'pas-un-uuid' }] },
    });

    expect(response.statusCode).toBe(400);
  });
});
