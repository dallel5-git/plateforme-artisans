/**
 * QA-01e — `PUT /v1/providers/me/categories`, chemin réel (Postgres). Complète
 * `providers-me-categories.test.ts` (BE-19c), qui ne couvre que le rejet de format et le quota
 * FREE — tous deux évalués avant tout accès à `@repo/db`, donc déjà testables sans base ; le cas
 * d'erreur reste couvert là-bas, cette PR n'ajoute que le chemin heureux. Le remplacement du set,
 * le respect de l'index partiel unique `isPrimary`, et le recalcul de `completionScore` étaient
 * vérifiés manuellement en `curl` faute de harnais (BE-02b, absorbé par QA-01a).
 */
import { signAccessToken } from '@repo/core';
import { createTestCategory, createTestProvider } from '@repo/testing/db-test-utils';
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

describe('QA-01e — PUT /v1/providers/me/categories (Postgres réel)', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('remplace le set de catégories, une seule isPrimary, completionScore recalculé (200)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const provider = await createTestProvider();
    const [plomberie, electricite] = await Promise.all([
      createTestCategory(),
      createTestCategory(),
    ]);
    const accessToken = await signAccessToken({ sub: provider.userId, role: 'PROVIDER' });

    const response = await app.inject({
      method: 'PUT',
      url: '/v1/providers/me/categories',
      headers: { authorization: `Bearer ${accessToken}` },
      payload: {
        categories: [
          { categoryId: plomberie.id, isPrimary: true },
          { categoryId: electricite.id, isPrimary: false, yearsExperience: 3 },
        ],
      },
    });

    expect(response.statusCode).toBe(200);
    const body = response.json();
    expect(body.categories).toHaveLength(2);
    expect(body.categories.filter((c: { isPrimary: boolean }) => c.isPrimary)).toHaveLength(1);
    // ≥1 catégorie (18) — seul critère satisfait sur un profil de test par ailleurs vierge.
    expect(body.completionScore).toBe(18);
  });

  it('remplace un ancien set par un nouveau — aucune catégorie de l’ancien set ne survit', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const provider = await createTestProvider();
    const [oldCategory, newCategory] = await Promise.all([
      createTestCategory(),
      createTestCategory(),
    ]);
    const accessToken = await signAccessToken({ sub: provider.userId, role: 'PROVIDER' });
    const headers = { authorization: `Bearer ${accessToken}` };

    await app.inject({
      method: 'PUT',
      url: '/v1/providers/me/categories',
      headers,
      payload: { categories: [{ categoryId: oldCategory.id, isPrimary: true }] },
    });
    const response = await app.inject({
      method: 'PUT',
      url: '/v1/providers/me/categories',
      headers,
      payload: { categories: [{ categoryId: newCategory.id, isPrimary: true }] },
    });

    expect(response.statusCode).toBe(200);
    const categoryIds = response.json().categories.map((c: { categoryId: string }) => c.categoryId);
    expect(categoryIds).toEqual([newCategory.id]);
  });
});
