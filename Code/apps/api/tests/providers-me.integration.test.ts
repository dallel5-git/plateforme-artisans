/**
 * QA-01e — `POST`/`PATCH /v1/providers/me`, chemin réel (Postgres). BE-44 — `GET /v1/providers/me`.
 * Complète `providers-me.test.ts` (BE-19b), qui ne couvre que le rejet de format et les limites
 * `requireAuth`/`requireRole` sans base — création de profil, promotion de rôle et garde de
 * publication à 60 % étaient vérifiées manuellement en `curl` faute de harnais (BE-02b, absorbé
 * par QA-01a).
 */
import { signAccessToken } from '@repo/core';
import { findUserById } from '@repo/db';
import {
  createTestClient,
  createTestGovernorate,
  createTestProvider,
} from '@repo/testing/db-test-utils';
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

async function authHeaderFor(userId: string, role: 'CLIENT' | 'PROVIDER' = 'CLIENT') {
  const accessToken = await signAccessToken({ sub: userId, role });
  return { authorization: `Bearer ${accessToken}` };
}

describe('BE-44 — GET /v1/providers/me (Postgres réel)', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('renvoie le profil propriétaire, champs privés inclus (200)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const provider = await createTestProvider();

    const response = await app.inject({
      method: 'GET',
      url: '/v1/providers/me',
      headers: await authHeaderFor(provider.userId, 'PROVIDER'),
    });

    expect(response.statusCode).toBe(200);
    const body = response.json();
    expect(body.id).toBe(provider.providerId);
    // Champs privés absents de la fiche publique (BE-17) — présents ici uniquement (P8).
    expect(body).toHaveProperty('publicationStatus');
    expect(body).toHaveProperty('availabilityStatus');
    expect(body).toHaveProperty('availableAgainAt');
    expect(body).toHaveProperty('acceptsEmergency');
    expect(body).toHaveProperty('workingHours');
    expect(body).toHaveProperty('completionScore');
    // BE-44b : relations nécessaires à la reprise d'onboarding sans perte
    expect(body).toHaveProperty('categories');
    expect(Array.isArray(body.categories)).toBe(true);
    expect(body).toHaveProperty('coverageAreas');
    expect(Array.isArray(body.coverageAreas)).toBe(true);
    expect(body).toHaveProperty('portfolio');
    expect(Array.isArray(body.portfolio)).toBe(true);
  });

  it('404 explicite (pas un 500) quand aucun profil artisan n’existe pour ce compte', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    // Compte sans profil artisan — jeton PROVIDER délibérément désynchronisé de l'état réel
    // (mêmes limites que les tests "sans Postgres" de providers-me.test.ts) pour exercer le
    // 404 de `requireOwnProfile` plutôt que le 403 de `requireRole`, déjà couvert ailleurs.
    const client = await createTestClient();

    const response = await app.inject({
      method: 'GET',
      url: '/v1/providers/me',
      headers: await authHeaderFor(client.id, 'PROVIDER'),
    });

    expect(response.statusCode).toBe(404);
    expect(response.json().error.code).toBe('PROVIDER_PROFILE_NOT_FOUND');
  });
});

describe('QA-01e — POST /v1/providers/me (Postgres réel)', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it("crée le profil, promeut l'utilisateur PROVIDER (US-P-01) et renvoie de nouveaux tokens (200)", async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const client = await createTestClient();
    const governorate = await createTestGovernorate();

    const response = await app.inject({
      method: 'POST',
      url: '/v1/providers/me',
      headers: await authHeaderFor(client.id),
      payload: { businessName: 'Plomberie Test', baseGovernorateId: governorate.id },
    });

    expect(response.statusCode).toBe(200);
    const body = response.json();
    expect(body.provider.businessName).toBe('Plomberie Test');
    expect(body.provider.publicationStatus).toBe('DRAFT');
    expect(body.accessToken).toBeTruthy();
    expect(body.refreshToken).toBeTruthy();

    const updatedUser = await findUserById(client.id);
    expect(updatedUser!.roles).toContain('PROVIDER');
  });

  it('rejette un deuxième profil pour le même utilisateur (409 PROVIDER_PROFILE_ALREADY_EXISTS)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const provider = await createTestProvider();
    const governorate = await createTestGovernorate();

    const response = await app.inject({
      method: 'POST',
      url: '/v1/providers/me',
      headers: await authHeaderFor(provider.userId, 'PROVIDER'),
      payload: { businessName: 'Deuxième profil', baseGovernorateId: governorate.id },
    });

    expect(response.statusCode).toBe(409);
    expect(response.json().error.code).toBe('PROVIDER_PROFILE_ALREADY_EXISTS');
  });
});

describe('QA-01e — PATCH /v1/providers/me (Postgres réel)', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('met à jour le profil et recalcule completionScore (200)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const provider = await createTestProvider();

    const response = await app.inject({
      method: 'PATCH',
      url: '/v1/providers/me',
      headers: await authHeaderFor(provider.userId, 'PROVIDER'),
      payload: {
        headline: 'Plombier certifié',
        bio: 'a'.repeat(60),
      },
    });

    expect(response.statusCode).toBe(200);
    const body = response.json();
    expect(body.headline).toBe('Plombier certifié');
    // bio (18, ≥50 caractères) + headline (10) — aucun autre critère satisfait sur un profil de
    // test par ailleurs vierge (packages/core/src/providers/completion-score.ts).
    expect(body.completionScore).toBe(28);
  });

  it('refuse de publier sous 60 % de complétude (403 PROVIDER_PROFILE_INCOMPLETE, missingFields listés)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    // Profil délibérément vierge (createTestProvider ne pose ni bio, ni catégorie, ni zone) :
    // completionScore = 0, largement sous le seuil de 60.
    const provider = await createTestProvider();

    const response = await app.inject({
      method: 'PATCH',
      url: '/v1/providers/me',
      headers: await authHeaderFor(provider.userId, 'PROVIDER'),
      payload: { publicationStatus: 'PUBLISHED' },
    });

    expect(response.statusCode).toBe(403);
    const body = response.json();
    expect(body.error.code).toBe('PROVIDER_PROFILE_INCOMPLETE');
    expect(body.error.details.missingFields).toContain('bio');
  });
});
