/**
 * QA-01e — `PUT /v1/providers/me/coverage-areas`, chemin réel (Postgres). Complète
 * `providers-me-coverage-areas.test.ts` (BE-19d), qui ne couvre que le rejet de format et le
 * quota FREE — tous deux évalués avant tout accès à `@repo/db`, donc déjà testables sans base ;
 * le cas d'erreur reste couvert là-bas, cette PR n'ajoute que le chemin heureux. Le remplacement
 * du set, `delegationId` absent = tout le gouvernorat, et le recalcul de `completionScore`
 * étaient vérifiés manuellement en `curl` faute de harnais (BE-02b, absorbé par QA-01a).
 */
import { signAccessToken } from '@repo/core';
import { createTestGovernorate, createTestProvider } from '@repo/testing/db-test-utils';
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

describe('QA-01e — PUT /v1/providers/me/coverage-areas (Postgres réel)', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('remplace le set de zones, `delegationId` absent = tout le gouvernorat, completionScore recalculé (200)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const provider = await createTestProvider();
    const governorate = await createTestGovernorate();
    const accessToken = await signAccessToken({ sub: provider.userId, role: 'PROVIDER' });

    const response = await app.inject({
      method: 'PUT',
      url: '/v1/providers/me/coverage-areas',
      headers: { authorization: `Bearer ${accessToken}` },
      payload: { coverageAreas: [{ governorateId: governorate.id, travelFee: 5000 }] },
    });

    expect(response.statusCode).toBe(200);
    const body = response.json();
    expect(body.coverageAreas).toHaveLength(1);
    expect(body.coverageAreas[0].governorateId).toBe(governorate.id);
    expect(body.coverageAreas[0].delegationId).toBeNull();
    expect(body.coverageAreas[0].travelFee).toBe(5000);
    // ≥1 zone (18) — seul critère satisfait sur un profil de test par ailleurs vierge.
    expect(body.completionScore).toBe(18);
  });

  it('remplace un ancien set par un nouveau — aucune zone de l’ancien set ne survit', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const provider = await createTestProvider();
    const [oldGovernorate, newGovernorate] = await Promise.all([
      createTestGovernorate(),
      createTestGovernorate(),
    ]);
    const accessToken = await signAccessToken({ sub: provider.userId, role: 'PROVIDER' });
    const headers = { authorization: `Bearer ${accessToken}` };

    await app.inject({
      method: 'PUT',
      url: '/v1/providers/me/coverage-areas',
      headers,
      payload: { coverageAreas: [{ governorateId: oldGovernorate.id }] },
    });
    const response = await app.inject({
      method: 'PUT',
      url: '/v1/providers/me/coverage-areas',
      headers,
      payload: { coverageAreas: [{ governorateId: newGovernorate.id }] },
    });

    expect(response.statusCode).toBe(200);
    const governorateIds = response
      .json()
      .coverageAreas.map((area: { governorateId: string }) => area.governorateId);
    expect(governorateIds).toEqual([newGovernorate.id]);
  });
});
