/**
 * BE-30b — Tests des routes de vérification d'identité KYC (/v1/providers/me/verification/*).
 *
 * Vérifie :
 * 1. La protection RBAC : 401 si non authentifié, 403 si rôle non-PROVIDER.
 * 2. La validation des entrées Zod (format CIN 8 chiffres, UUID des médias, types de documents).
 * 3. La logique métier : rejet si profil déjà approuvé ou demande déjà PENDING.
 * 4. La génération d'URL PUT pré-signée R2 privée.
 * 5. La lecture de statut KYC pour l'artisan connecté.
 */
import { signAccessToken } from '@repo/core';
import * as dbModule from '@repo/db';
import * as storageModule from '@repo/storage';
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
import { verificationRoutes } from '../src/routes/verification.js';

vi.mock('@repo/db', async (importOriginal) => {
  const actual = await importOriginal<typeof import('@repo/db')>();
  return {
    ...actual,
    findProviderProfileByUserId: vi.fn(),
    findPendingVerificationRequestByProviderId: vi.fn(),
    findLatestVerificationRequestByProviderId: vi.fn(),
    createMediaAsset: vi.fn(),
    createVerificationRequest: vi.fn(),
    addVerificationDocument: vi.fn(),
    findMediaAssetById: vi.fn(),
    updateProviderVerificationStatus: vi.fn(),
    withTransaction: vi.fn(async (cb: (tx: unknown) => Promise<unknown>) => cb({})),
  };
});

vi.mock('@repo/storage', async (importOriginal) => {
  const actual = await importOriginal<typeof import('@repo/storage')>();
  return {
    ...actual,
    presignKycUpload: vi.fn(),
    requireKycBucketName: vi.fn(() => 'private-kyc'),
    buildKycStorageKey: vi.fn((p: string, r: string, s: string) => `kyc/${p}/${r}/${s}.jpg`),
  };
});

const TEST_SECRET = 'secret-de-test-suffisamment-long-pour-jwt-32-chars';
const VALID_UUID_MEDIA_1 = '11111111-1111-4111-8111-111111111111';
const VALID_UUID_MEDIA_2 = '22222222-2222-4222-8222-222222222222';
const VALID_UUID_REQ = '33333333-3333-4333-8333-333333333333';
const VALID_UUID_DOC = '44444444-4444-4444-8444-444444444444';

async function buildTestApp() {
  const app = Fastify().withTypeProvider<ZodTypeProvider>();
  app.setValidatorCompiler(validatorCompiler);
  app.setSerializerCompiler(serializerCompiler);
  registerErrorHandler(app);
  registerRequireAuth(app);
  registerRequireRole(app);
  await app.register(verificationRoutes, { prefix: '/v1' });
  return app;
}

describe('BE-30b — Routes de vérification KYC (/v1/providers/me/verification/*)', () => {
  beforeEach(() => {
    vi.stubEnv('JWT_ACCESS_SECRET', TEST_SECRET);
  });

  afterEach(() => {
    vi.unstubAllEnvs();
    vi.restoreAllMocks();
  });

  describe('Sécurité et RBAC', () => {
    it('refuse les requêtes sans authentification (401 ACCESS_TOKEN_INVALID)', async () => {
      const app = await buildTestApp();

      const presignRes = await app.inject({
        method: 'POST',
        url: '/v1/providers/me/verification/presign',
        payload: {
          documentType: 'CIN_FRONT',
          mimeType: 'image/jpeg',
          sizeBytes: 1024,
        },
      });
      expect(presignRes.statusCode).toBe(401);

      const statusRes = await app.inject({
        method: 'GET',
        url: '/v1/providers/me/verification',
      });
      expect(statusRes.statusCode).toBe(401);
    });

    it('refuse un utilisateur avec rôle CLIENT (403 FORBIDDEN)', async () => {
      const app = await buildTestApp();
      const clientToken = await signAccessToken({ sub: 'user-client-1', role: 'CLIENT' });

      const response = await app.inject({
        method: 'GET',
        url: '/v1/providers/me/verification',
        headers: { authorization: `Bearer ${clientToken}` },
      });

      expect(response.statusCode).toBe(403);
      expect(response.json().error.code).toBe('FORBIDDEN');
    });
  });

  describe('Validation des formats d’entrée (Zod)', () => {
    it('rejette un numéro de CIN ne comportant pas exactement 8 chiffres', async () => {
      const app = await buildTestApp();
      const token = await signAccessToken({ sub: 'user-pro-1', role: 'PROVIDER' });

      // CIN avec 7 chiffres
      const resShort = await app.inject({
        method: 'POST',
        url: '/v1/providers/me/verification/submit',
        headers: { authorization: `Bearer ${token}` },
        payload: {
          cinNumber: '1234567',
          fullNameOnId: 'Ahmed Ben Salah',
          cinFrontMediaId: '3c884497-1e37-45d3-95c2-beb49592844e',
          cinBackMediaId: '4c884497-1e37-45d3-95c2-beb49592844e',
        },
      });
      expect(resShort.statusCode).toBe(400);
      expect(resShort.json().error.code).toBe('VALIDATION_ERROR');

      // CIN avec des lettres
      const resAlpha = await app.inject({
        method: 'POST',
        url: '/v1/providers/me/verification/submit',
        headers: { authorization: `Bearer ${token}` },
        payload: {
          cinNumber: '1234567a',
          fullNameOnId: 'Ahmed Ben Salah',
          cinFrontMediaId: '3c884497-1e37-45d3-95c2-beb49592844e',
          cinBackMediaId: '4c884497-1e37-45d3-95c2-beb49592844e',
        },
      });
      expect(resAlpha.statusCode).toBe(400);
      expect(resAlpha.json().error.code).toBe('VALIDATION_ERROR');
    });

    it('rejette un documentType inconnu sur presign (400 VALIDATION_ERROR)', async () => {
      const app = await buildTestApp();
      const token = await signAccessToken({ sub: 'user-pro-1', role: 'PROVIDER' });

      const response = await app.inject({
        method: 'POST',
        url: '/v1/providers/me/verification/presign',
        headers: { authorization: `Bearer ${token}` },
        payload: {
          documentType: 'FAUX_DOCUMENT',
          mimeType: 'image/jpeg',
          sizeBytes: 1024,
        },
      });

      expect(response.statusCode).toBe(400);
      expect(response.json().error.code).toBe('VALIDATION_ERROR');
    });

    it('rejette un type MIME non supporté sur presign (400 VALIDATION_ERROR)', async () => {
      const app = await buildTestApp();
      const token = await signAccessToken({ sub: 'user-pro-1', role: 'PROVIDER' });

      const response = await app.inject({
        method: 'POST',
        url: '/v1/providers/me/verification/presign',
        headers: { authorization: `Bearer ${token}` },
        payload: {
          documentType: 'CIN_FRONT',
          mimeType: 'application/pdf',
          sizeBytes: 1024,
        },
      });

      expect(response.statusCode).toBe(400);
      expect(response.json().error.code).toBe('VALIDATION_ERROR');
    });
  });

  describe('Logique métier & endpoints', () => {
    it('refuse presign si le profil artisan est introuvable (404 PROVIDER_PROFILE_NOT_FOUND)', async () => {
      vi.mocked(dbModule.findProviderProfileByUserId).mockResolvedValue(null);

      const app = await buildTestApp();
      const token = await signAccessToken({ sub: 'user-pro-without-profile', role: 'PROVIDER' });

      const response = await app.inject({
        method: 'POST',
        url: '/v1/providers/me/verification/presign',
        headers: { authorization: `Bearer ${token}` },
        payload: {
          documentType: 'CIN_FRONT',
          mimeType: 'image/jpeg',
          sizeBytes: 1024,
        },
      });

      expect(response.statusCode).toBe(404);
      expect(response.json().error.code).toBe('PROVIDER_PROFILE_NOT_FOUND');
    });

    it('refuse presign si le profil est déjà vérifié APPROVED (400 KYC_ALREADY_VERIFIED)', async () => {
      vi.mocked(dbModule.findProviderProfileByUserId).mockResolvedValue({
        id: 'prov-1',
        verificationStatus: 'APPROVED',
      } as unknown as dbModule.ProviderProfileOwnerView);

      const app = await buildTestApp();
      const token = await signAccessToken({ sub: 'user-pro-verified', role: 'PROVIDER' });

      const response = await app.inject({
        method: 'POST',
        url: '/v1/providers/me/verification/presign',
        headers: { authorization: `Bearer ${token}` },
        payload: {
          documentType: 'CIN_FRONT',
          mimeType: 'image/jpeg',
          sizeBytes: 1024,
        },
      });

      expect(response.statusCode).toBe(400);
      expect(response.json().error.code).toBe('KYC_ALREADY_VERIFIED');
    });

    it('refuse presign si une demande est déjà en cours PENDING (409 KYC_REQUEST_ALREADY_PENDING)', async () => {
      vi.mocked(dbModule.findProviderProfileByUserId).mockResolvedValue({
        id: 'prov-1',
        verificationStatus: 'PENDING',
      } as unknown as dbModule.ProviderProfileOwnerView);

      vi.mocked(dbModule.findPendingVerificationRequestByProviderId).mockResolvedValue({
        id: 'req-active-1',
        status: 'PENDING',
      } as unknown as dbModule.VerificationRequestRecord);

      const app = await buildTestApp();
      const token = await signAccessToken({ sub: 'user-pro-pending', role: 'PROVIDER' });

      const response = await app.inject({
        method: 'POST',
        url: '/v1/providers/me/verification/presign',
        headers: { authorization: `Bearer ${token}` },
        payload: {
          documentType: 'CIN_FRONT',
          mimeType: 'image/jpeg',
          sizeBytes: 1024,
        },
      });

      expect(response.statusCode).toBe(409);
      expect(response.json().error.code).toBe('KYC_REQUEST_ALREADY_PENDING');
    });

    it('génère avec succès une URL PUT pré-signée pour le bucket R2 privé', async () => {
      vi.mocked(dbModule.findProviderProfileByUserId).mockResolvedValue({
        id: 'prov-1',
        verificationStatus: 'NOT_SUBMITTED',
      } as unknown as dbModule.ProviderProfileOwnerView);
      vi.mocked(dbModule.findPendingVerificationRequestByProviderId).mockResolvedValue(null);

      vi.mocked(dbModule.createMediaAsset).mockResolvedValue({
        id: VALID_UUID_MEDIA_1,
      } as unknown as dbModule.MediaAsset);

      const fakeExpiresAt = new Date(Date.now() + 600 * 1000);
      vi.mocked(storageModule.presignKycUpload).mockResolvedValue({
        uploadUrl: 'https://r2.test/private-kyc/upload?sig=123',
        expiresAt: fakeExpiresAt,
      });

      const app = await buildTestApp();
      const token = await signAccessToken({ sub: 'user-pro-ok', role: 'PROVIDER' });

      const response = await app.inject({
        method: 'POST',
        url: '/v1/providers/me/verification/presign',
        headers: { authorization: `Bearer ${token}` },
        payload: {
          documentType: 'CIN_FRONT',
          mimeType: 'image/jpeg',
          sizeBytes: 2048,
        },
      });

      expect(response.statusCode).toBe(200);
      const data = response.json();
      expect(data.mediaId).toBe(VALID_UUID_MEDIA_1);
      expect(data.uploadUrl).toBe('https://r2.test/private-kyc/upload?sig=123');
      expect(data.expiresAt).toBeDefined();
    });

    it('refuse la soumission si les médias de pièces d’identité sont introuvables (404 KYC_DOCUMENT_NOT_FOUND)', async () => {
      vi.mocked(dbModule.findProviderProfileByUserId).mockResolvedValue({
        id: 'prov-1',
        verificationStatus: 'NOT_SUBMITTED',
      } as unknown as dbModule.ProviderProfileOwnerView);
      vi.mocked(dbModule.findPendingVerificationRequestByProviderId).mockResolvedValue(null);
      vi.mocked(dbModule.findMediaAssetById).mockResolvedValue(null);

      const app = await buildTestApp();
      const token = await signAccessToken({ sub: 'user-pro-ok', role: 'PROVIDER' });

      const response = await app.inject({
        method: 'POST',
        url: '/v1/providers/me/verification/submit',
        headers: { authorization: `Bearer ${token}` },
        payload: {
          cinNumber: '12345678',
          fullNameOnId: 'Sami Mansour',
          cinFrontMediaId: '3c884497-1e37-45d3-95c2-beb49592844e',
          cinBackMediaId: '4c884497-1e37-45d3-95c2-beb49592844e',
        },
      });

      expect(response.statusCode).toBe(404);
      expect(response.json().error.code).toBe('KYC_DOCUMENT_NOT_FOUND');
    });

    it('enregistre la demande de vérification avec succès et passe le profil à PENDING', async () => {
      const userId = 'user-pro-ok';
      vi.mocked(dbModule.findProviderProfileByUserId).mockResolvedValue({
        id: 'prov-1',
        verificationStatus: 'NOT_SUBMITTED',
      } as unknown as dbModule.ProviderProfileOwnerView);
      vi.mocked(dbModule.findPendingVerificationRequestByProviderId).mockResolvedValue(null);

      vi.mocked(dbModule.findMediaAssetById).mockImplementation(async (id: string) => {
        return {
          id,
          uploadedById: userId,
          isPrivate: true,
        } as unknown as dbModule.MediaAsset;
      });

      const submittedAt = new Date();
      vi.mocked(dbModule.createVerificationRequest).mockResolvedValue({
        id: VALID_UUID_REQ,
        providerId: 'prov-1',
        status: 'PENDING',
        cinNumberHash: 'hash-abc',
        cinNumberCipher: 'cipher-xyz',
        fullNameOnId: 'Sami Mansour',
        submittedAt,
        reviewedAt: null,
        reviewedById: null,
        rejectionReason: null,
        internalNote: null,
        expiresAt: null,
      });

      const app = await buildTestApp();
      const token = await signAccessToken({ sub: userId, role: 'PROVIDER' });

      const response = await app.inject({
        method: 'POST',
        url: '/v1/providers/me/verification/submit',
        headers: { authorization: `Bearer ${token}` },
        payload: {
          cinNumber: '12345678',
          fullNameOnId: 'Sami Mansour',
          cinFrontMediaId: VALID_UUID_MEDIA_1,
          cinBackMediaId: VALID_UUID_MEDIA_2,
        },
      });

      expect(response.statusCode).toBe(200);
      const data = response.json();
      expect(data.requestId).toBe(VALID_UUID_REQ);
      expect(data.status).toBe('PENDING');
      expect(data.submittedAt).toBeDefined();

      expect(dbModule.createVerificationRequest).toHaveBeenCalledWith(
        expect.objectContaining({
          providerId: 'prov-1',
          fullNameOnId: 'Sami Mansour',
          status: 'PENDING',
        }),
        expect.anything(),
      );
    });

    it('renvoie le statut de vérification courant et la dernière demande', async () => {
      vi.mocked(dbModule.findProviderProfileByUserId).mockResolvedValue({
        id: 'prov-1',
        verificationStatus: 'PENDING',
        isVerified: false,
      } as unknown as dbModule.ProviderProfileOwnerView);

      const submittedDate = new Date();
      vi.mocked(dbModule.findLatestVerificationRequestByProviderId).mockResolvedValue({
        id: VALID_UUID_REQ,
        providerId: 'prov-1',
        status: 'PENDING',
        cinNumberHash: 'hash-secret',
        cinNumberCipher: 'cipher-secret',
        fullNameOnId: 'Sami Mansour',
        submittedAt: submittedDate,
        reviewedAt: null,
        reviewedById: null,
        rejectionReason: null,
        internalNote: null,
        expiresAt: null,
        documents: [
          {
            id: VALID_UUID_DOC,
            requestId: VALID_UUID_REQ,
            mediaId: VALID_UUID_MEDIA_1,
            type: 'CIN_FRONT',
            createdAt: submittedDate,
          },
        ],
      });

      const app = await buildTestApp();
      const token = await signAccessToken({ sub: 'user-pro-status', role: 'PROVIDER' });

      const response = await app.inject({
        method: 'GET',
        url: '/v1/providers/me/verification',
        headers: { authorization: `Bearer ${token}` },
      });

      expect(response.statusCode).toBe(200);
      const data = response.json();
      expect(data.verificationStatus).toBe('PENDING');
      expect(data.isVerified).toBe(false);
      expect(data.currentRequest).toMatchObject({
        id: VALID_UUID_REQ,
        status: 'PENDING',
        fullNameOnId: 'Sami Mansour',
        rejectionReason: null,
      });
      // Le hash et le chiffré ne doivent jamais être exposés
      expect(data.currentRequest.cinNumberHash).toBeUndefined();
      expect(data.currentRequest.cinNumberCipher).toBeUndefined();
    });
  });
});

