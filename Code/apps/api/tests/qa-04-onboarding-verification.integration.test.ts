/**
 * QA-04 : Recette & Tests E2E du cycle complet Onboarding & Vérification
 *
 * Scénario de test de bout en bout simulant le parcours complet sur environnement réel (PostgreSQL) :
 * 1. Création d'un compte client par OTP (+216).
 * 2. Passage à l'onboarding via "Devenir artisan" (promotion CLIENT -> PROVIDER).
 * 3. Saisie du profil, sélection de 2 métiers et 1 gouvernorat, ajout de 3 réalisations.
 * 4. Simulation d'interruption à l'étape 3 et reprise immédiate (MOB-027 sans perte de données).
 * 5. Publication du profil (score de complétude >= 60 %).
 * 6. Soumission de la CIN recto/verso avec consentement INPDP et chiffrement AES-256-GCM.
 * 7. Connexion sur apps/admin, instruction de la CIN dans la file d'attente et approbation (APPROVED).
 * 8. Vérification que l'artisan affiche le badge isVerified / VerifiedBadge et remonte dans les résultats de recherche.
 */
import { randomUUID } from 'node:crypto';
import { signAccessToken } from '@repo/core';
import { createMediaAsset, findUserByPhone } from '@repo/db';
import { testDbClient, createTestUserRow } from '@repo/db/testing';
import {
  createTestCategory,
  createTestGovernorate,
  createTestOtpCode,
  randomTestPhoneTn,
} from '@repo/testing/db-test-utils';
import Fastify from 'fastify';
import {
  serializerCompiler,
  validatorCompiler,
  type ZodTypeProvider,
} from 'fastify-type-provider-zod';
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { registerErrorHandler } from '../src/plugins/error-handler.js';
import { registerRequireAuth } from '../src/plugins/require-auth.js';
import { registerRequireRole } from '../src/plugins/require-role.js';
import { adminVerificationRoutes } from '../src/routes/admin-verifications.js';
import { authRoutes } from '../src/routes/auth.js';
import { catalogRoutes } from '../src/routes/catalog.js';
import { providersRoutes } from '../src/routes/providers.js';
import { verificationRoutes } from '../src/routes/verification.js';

vi.mock('@repo/storage', async (importOriginal) => {
  const actual = await importOriginal<typeof import('@repo/storage')>();
  return {
    ...actual,
    presignKycUpload: vi.fn(async () => ({
      uploadUrl: 'https://r2.mock/upload',
      expiresAt: new Date(Date.now() + 600000),
    })),
    presignKycRead: vi.fn(async () => ({
      downloadUrl: 'https://r2.mock/read',
      expiresAt: new Date(Date.now() + 300000),
    })),
    requireKycBucketName: vi.fn(() => 'private-kyc'),
    requirePublicBucketName: vi.fn(() => 'public-media'),
    buildKycStorageKey: vi.fn((p: string, r: string, s: string) => `kyc/${p}/${r}/${s}.jpg`),
  };
});

const TEST_SECRET = 'secret-de-test-suffisamment-long-pour-jwt-32-chars';

async function buildTestApp() {
  const app = Fastify().withTypeProvider<ZodTypeProvider>();
  app.setValidatorCompiler(validatorCompiler);
  app.setSerializerCompiler(serializerCompiler);
  registerErrorHandler(app);
  registerRequireAuth(app);
  registerRequireRole(app);
  await app.register(authRoutes, { prefix: '/v1' });
  await app.register(catalogRoutes, { prefix: '/v1' });
  await app.register(providersRoutes, { prefix: '/v1' });
  await app.register(verificationRoutes, { prefix: '/v1' });
  await app.register(adminVerificationRoutes, { prefix: '/v1' });
  return app;
}

describe('QA-04 — Recette & Tests E2E : Cycle complet Onboarding & Vérification (Postgres réel)', () => {
  beforeEach(() => {
    vi.stubEnv('JWT_ACCESS_SECRET', TEST_SECRET);
  });

  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('exécute avec succès les 8 étapes du cycle Inscription → Onboarding → KYC → Modération → Badge vérifié', async () => {
    const app = await buildTestApp();

    // 0. Préparation du référentiel (gouvernorat, délégation, catégories)
    const governorate = await createTestGovernorate();
    const delegation = await testDbClient.delegation.create({
      data: {
        governorateId: governorate.id,
        nameFr: `Délégation ${governorate.nameFr}`,
        nameAr: `معتمدية ${governorate.nameAr}`,
        slug: `delegation-${governorate.slug}`,
      },
    });
    const categoryPlomberie = await createTestCategory();
    const categoryElectricite = await createTestCategory();

    // -------------------------------------------------------------------------
    // 1. Création d'un compte client par OTP (+216)
    // -------------------------------------------------------------------------
    const clientPhone = randomTestPhoneTn();

    // Demande de code OTP
    const otpRequestRes = await app.inject({
      method: 'POST',
      url: '/v1/auth/otp/request',
      payload: { phone: clientPhone },
    });
    expect(otpRequestRes.statusCode).toBe(200);

    // Saisie et vérification du code OTP (généré directement via fixture test)
    const { code: otpCode } = await createTestOtpCode(clientPhone, { purpose: 'SIGNUP' });
    const otpVerifyRes = await app.inject({
      method: 'POST',
      url: '/v1/auth/otp/verify',
      payload: { phone: clientPhone, code: otpCode },
    });
    expect(otpVerifyRes.statusCode).toBe(200);
    const authData = otpVerifyRes.json();
    const clientToken = authData.accessToken;
    const clientUserId = authData.user.id;

    expect(clientToken).toBeTruthy();
    expect(authData.user.roles).toContain('CLIENT');
    expect(authData.user.roles).not.toContain('PROVIDER');

    // -------------------------------------------------------------------------
    // 2. Passage à l'onboarding via "Devenir artisan" (POST /v1/providers/me)
    // -------------------------------------------------------------------------
    const createProfileRes = await app.inject({
      method: 'POST',
      url: '/v1/providers/me',
      headers: { authorization: `Bearer ${clientToken}` },
      payload: {
        businessName: 'Dallel Plomberie Express',
        headline: 'Plombier chauffagiste certifié et dépannage urgent 24/7',
        bio: 'Artisan plombier expérimenté avec plus de 10 ans de pratique dans le gouvernorat de Sousse et ses environs.',
        yearsExperience: 10,
        spokenLanguages: ['ar', 'fr'],
        baseGovernorateId: governorate.id,
        baseDelegationId: delegation.id,
        whatsappPhone: clientPhone,
        publicPhone: clientPhone,
      },
    });

    expect(createProfileRes.statusCode).toBe(200);
    const createProfileData = createProfileRes.json();
    expect(createProfileData.provider).toBeTruthy();
    const providerId = createProfileData.provider.id;
    const providerSlug = createProfileData.provider.slug;

    // L'utilisateur est promu PROVIDER et a reçu de nouveaux tokens avec ce rôle
    expect(createProfileData.accessToken).toBeTruthy();
    const providerToken = createProfileData.accessToken;

    const updatedUser = await findUserByPhone(clientPhone);
    expect(updatedUser?.roles).toContain('PROVIDER');

    // Le score initial est calculé (téléphone, bio, headline, expérience, contact)
    expect(createProfileData.provider.completionScore).toBeGreaterThan(0);
    expect(createProfileData.provider.publicationStatus).toBe('DRAFT');

    // -------------------------------------------------------------------------
    // 3. Saisie du profil : sélection de 2 métiers et 1 gouvernorat, ajout de 3 photos
    // -------------------------------------------------------------------------
    // A. Sélection de 2 métiers (plomberie principale, électricité secondaire)
    const updateCategoriesRes = await app.inject({
      method: 'PUT',
      url: '/v1/providers/me/categories',
      headers: { authorization: `Bearer ${providerToken}` },
      payload: {
        categoryIds: [categoryPlomberie.id, categoryElectricite.id],
        primaryCategoryId: categoryPlomberie.id,
      },
    });
    expect(updateCategoriesRes.statusCode).toBe(200);
    expect(updateCategoriesRes.json().categories).toHaveLength(2);

    // B. Sélection de la zone de couverture
    const updateZonesRes = await app.inject({
      method: 'PUT',
      url: '/v1/providers/me/coverage-areas',
      headers: { authorization: `Bearer ${providerToken}` },
      payload: {
        governorateIds: [governorate.id],
      },
    });
    expect(updateZonesRes.statusCode).toBe(200);
    expect(updateZonesRes.json().coverageAreas).toHaveLength(1);

    // C. Ajout de 3 réalisations dans le portfolio
    const media1 = await createMediaAsset({
      uploadedById: clientUserId,
      bucket: 'public-media',
      storageKey: `portfolio/${providerId}/${randomUUID()}/photo1.webp`,
      publicUrl: 'https://cdn.sanaya.tn/photo1.webp',
      type: 'IMAGE',
      mimeType: 'image/webp',
      sizeBytes: 150000,
      isPrivate: false,
    });
    const media2 = await createMediaAsset({
      uploadedById: clientUserId,
      bucket: 'public-media',
      storageKey: `portfolio/${providerId}/${randomUUID()}/photo2.webp`,
      publicUrl: 'https://cdn.sanaya.tn/photo2.webp',
      type: 'IMAGE',
      mimeType: 'image/webp',
      sizeBytes: 200000,
      isPrivate: false,
    });
    const media3 = await createMediaAsset({
      uploadedById: clientUserId,
      bucket: 'public-media',
      storageKey: `portfolio/${providerId}/${randomUUID()}/photo3.webp`,
      publicUrl: 'https://cdn.sanaya.tn/photo3.webp',
      type: 'IMAGE',
      mimeType: 'image/webp',
      sizeBytes: 180000,
      isPrivate: false,
    });

    // Marquage APPROBATION média pour le rattachement au portfolio
    await testDbClient.mediaAsset.updateMany({
      where: { id: { in: [media1.id, media2.id, media3.id] } },
      data: { moderationStatus: 'APPROVED' },
    });

    for (const [idx, media] of [media1, media2, media3].entries()) {
      const attachRes = await app.inject({
        method: 'POST',
        url: '/v1/providers/me/portfolio',
        headers: { authorization: `Bearer ${providerToken}` },
        payload: {
          mediaId: media.id,
          caption: `Chantier réalisé n°${idx + 1}`,
        },
      });
      expect(attachRes.statusCode).toBe(200);
    }

    // -------------------------------------------------------------------------
    // 4. Simulation de fermeture d'application et reprise immédiate (MOB-027)
    // -------------------------------------------------------------------------
    const resumeRes = await app.inject({
      method: 'GET',
      url: '/v1/providers/me',
      headers: { authorization: `Bearer ${providerToken}` },
    });
    expect(resumeRes.statusCode).toBe(200);
    const resumeProfile = resumeRes.json();

    // Vérification de la persistance exhaustive sans aucune perte de données
    expect(resumeProfile.categories).toHaveLength(2);
    expect(resumeProfile.coverageAreas).toHaveLength(1);
    expect(resumeProfile.portfolio).toHaveLength(3);
    expect(resumeProfile.headline).toBe('Plombier chauffagiste certifié et dépannage urgent 24/7');
    expect(resumeProfile.yearsExperience).toBe(10);
    expect(resumeProfile.completionScore).toBeGreaterThanOrEqual(60);

    // -------------------------------------------------------------------------
    // 5. Publication du profil (score >= 60 %)
    // -------------------------------------------------------------------------
    const publishRes = await app.inject({
      method: 'PATCH',
      url: '/v1/providers/me',
      headers: { authorization: `Bearer ${providerToken}` },
      payload: {
        publicationStatus: 'PUBLISHED',
      },
    });
    expect(publishRes.statusCode).toBe(200);
    expect(publishRes.json().publicationStatus).toBe('PUBLISHED');

    // -------------------------------------------------------------------------
    // 6. Soumission de la CIN recto/verso avec consentement INPDP
    // -------------------------------------------------------------------------
    const cinFrontMedia = await createMediaAsset({
      uploadedById: clientUserId,
      bucket: 'private-kyc',
      storageKey: `kyc/${providerId}/${randomUUID()}/recto.jpg`,
      type: 'IMAGE',
      mimeType: 'image/jpeg',
      sizeBytes: 850000,
      isPrivate: true,
    });
    const cinBackMedia = await createMediaAsset({
      uploadedById: clientUserId,
      bucket: 'private-kyc',
      storageKey: `kyc/${providerId}/${randomUUID()}/verso.jpg`,
      type: 'IMAGE',
      mimeType: 'image/jpeg',
      sizeBytes: 900000,
      isPrivate: true,
    });

    const submitKycRes = await app.inject({
      method: 'POST',
      url: '/v1/providers/me/verification/submit',
      headers: { authorization: `Bearer ${providerToken}` },
      payload: {
        cinNumber: '08123456',
        fullNameOnId: 'Oussama Dallel',
        cinFrontMediaId: cinFrontMedia.id,
        cinBackMediaId: cinBackMedia.id,
      },
    });
    expect(submitKycRes.statusCode).toBe(200);
    const kycResult = submitKycRes.json();
    expect(kycResult.status).toBe('PENDING');
    const verificationRequestId = kycResult.id;

    // -------------------------------------------------------------------------
    // 7. Connexion sur apps/admin, instruction et approbation
    // -------------------------------------------------------------------------
    const adminUser = await createTestUserRow({ roles: ['MODERATOR'] });
    const adminToken = await signAccessToken({ sub: adminUser.id, role: 'MODERATOR' });

    // A. Consultation de la file d'attente
    const listVerificationsRes = await app.inject({
      method: 'GET',
      url: '/v1/admin/verifications?status=PENDING',
      headers: { authorization: `Bearer ${adminToken}` },
    });
    expect(listVerificationsRes.statusCode).toBe(200);
    const queueData = listVerificationsRes.json();
    expect(queueData.items.some((item: { id: string }) => item.id === verificationRequestId)).toBe(
      true,
    );

    // B. Examen du dossier et traçabilité
    const inspectRes = await app.inject({
      method: 'GET',
      url: `/v1/admin/verifications/${verificationRequestId}`,
      headers: { authorization: `Bearer ${adminToken}` },
    });
    expect(inspectRes.statusCode).toBe(200);
    expect(inspectRes.json().documents).toHaveLength(2);

    // C. Décision d'approbation
    const reviewRes = await app.inject({
      method: 'POST',
      url: `/v1/admin/verifications/${verificationRequestId}/review`,
      headers: { authorization: `Bearer ${adminToken}` },
      payload: {
        status: 'APPROVED',
        internalNote: 'Documents conformes CIN tunisienne',
      },
    });
    expect(reviewRes.statusCode).toBe(200);
    expect(reviewRes.json().status).toBe('APPROVED');

    // -------------------------------------------------------------------------
    // 8. Vérification que l'artisan affiche le badge isVerified et remonte dans la recherche
    // -------------------------------------------------------------------------
    // A. Sur son profil propriétaire
    const verifiedProfileMeRes = await app.inject({
      method: 'GET',
      url: '/v1/providers/me',
      headers: { authorization: `Bearer ${providerToken}` },
    });
    expect(verifiedProfileMeRes.statusCode).toBe(200);
    expect(verifiedProfileMeRes.json().isVerified).toBe(true);
    expect(verifiedProfileMeRes.json().verificationStatus).toBe('APPROVED');

    // B. Sur sa fiche publique
    const publicProfileRes = await app.inject({
      method: 'GET',
      url: `/v1/providers/${providerSlug}`,
    });
    expect(publicProfileRes.statusCode).toBe(200);
    expect(publicProfileRes.json().isVerified).toBe(true);

    // C. Dans le moteur de recherche
    const searchRes = await app.inject({
      method: 'GET',
      url: `/v1/providers/search?category=${categoryPlomberie.slug}&governorate=${governorate.slug}`,
    });
    expect(searchRes.statusCode).toBe(200);
    const searchItems = searchRes.json().items;
    const found = searchItems.find((p: { slug: string }) => p.slug === providerSlug);
    expect(found).toBeDefined();
    expect(found.isVerified).toBe(true);
  });
});
