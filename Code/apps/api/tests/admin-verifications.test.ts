/**
 * BE-31 — Tests des routes d'administration KYC (/v1/admin/verifications/*).
 *
 * Vérifie :
 * 1. Protection RBAC stricte : 401 si non authentifié, 403 si rôle non-admin (CLIENT, PROVIDER), 200 pour ADMIN/MODERATOR/SUPER_ADMIN.
 * 2. File de vérification (GET /v1/admin/verifications) : tri ancienneté, filtre statut, pagination curseur, totalPending.
 * 3. Détails & consultation sécurisée (GET /v1/admin/verifications/:id) : 404 si introuvable, génération d'URLs de lecture R2 <= 5 min, traçage AuditLog.
 * 4. Décision de modération (POST /v1/admin/verifications/:id/review) : validation motif obligatoire si refus/complément, 400 si transition invalide, succès APPROVED / REJECTED / MORE_INFO_REQUIRED.
 */
import * as coreModule from '@repo/core';
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
import { adminVerificationRoutes } from '../src/routes/admin-verifications.js';

vi.mock('@repo/core', async (importOriginal) => {
  const actual = await importOriginal<typeof import('@repo/core')>();
  return {
    ...actual,
    purgeExpiredKycMedia: vi.fn(),
  };
});

vi.mock('@repo/db', async (importOriginal) => {
  const actual = await importOriginal<typeof import('@repo/db')>();
  return {
    ...actual,
    countPendingVerificationRequests: vi.fn(),
    listVerificationRequestsForAdmin: vi.fn(),
    findVerificationRequestDetailsForAdmin: vi.fn(),
    reviewVerificationRequest: vi.fn(),
    logVerificationView: vi.fn(),
  };
});

vi.mock('@repo/storage', async (importOriginal) => {
  const actual = await importOriginal<typeof import('@repo/storage')>();
  return {
    ...actual,
    presignKycRead: vi.fn(),
    deleteKycObject: vi.fn(),
  };
});

const TEST_SECRET = 'secret-de-test-suffisamment-long-pour-jwt-32-chars';
const VALID_UUID_REQ = '33333333-3333-4333-8333-333333333333';
const VALID_UUID_PROV = '22222222-2222-4222-8222-222222222222';
const VALID_UUID_ADMIN = '99999999-9999-4999-8999-999999999999';

async function buildTestApp() {
  const app = Fastify().withTypeProvider<ZodTypeProvider>();
  app.setValidatorCompiler(validatorCompiler);
  app.setSerializerCompiler(serializerCompiler);
  registerErrorHandler(app);
  registerRequireAuth(app);
  registerRequireRole(app);
  await app.register(adminVerificationRoutes, { prefix: '/v1' });
  return app;
}

describe('BE-31 — Administration KYC (/v1/admin/verifications)', () => {
  beforeEach(() => {
    vi.stubEnv('JWT_ACCESS_SECRET', TEST_SECRET);
    vi.clearAllMocks();
  });

  afterEach(() => {
    vi.unstubAllEnvs();
  });

  describe('1. Contrôle d’accès RBAC (401 / 403 / 200)', () => {
    it('refuse une requête sans token (401 ACCESS_TOKEN_INVALID)', async () => {
      const app = await buildTestApp();
      const response = await app.inject({
        method: 'GET',
        url: '/v1/admin/verifications',
      });

      expect(response.statusCode).toBe(401);
      expect(response.json().error.code).toBe('ACCESS_TOKEN_INVALID');
    });

    it('refuse un token avec rôle CLIENT (403 FORBIDDEN)', async () => {
      const app = await buildTestApp();
      const token = await signAccessToken({ sub: 'user-client', role: 'CLIENT' });

      const response = await app.inject({
        method: 'GET',
        url: '/v1/admin/verifications',
        headers: { authorization: `Bearer ${token}` },
      });

      expect(response.statusCode).toBe(403);
      expect(response.json().error.code).toBe('FORBIDDEN');
    });

    it('refuse un token avec rôle PROVIDER (403 FORBIDDEN)', async () => {
      const app = await buildTestApp();
      const token = await signAccessToken({ sub: 'user-provider', role: 'PROVIDER' });

      const response = await app.inject({
        method: 'GET',
        url: '/v1/admin/verifications',
        headers: { authorization: `Bearer ${token}` },
      });

      expect(response.statusCode).toBe(403);
      expect(response.json().error.code).toBe('FORBIDDEN');
    });

    it('autorise les rôles MODERATOR et SUPER_ADMIN', async () => {
      const app = await buildTestApp();
      vi.mocked(dbModule.listVerificationRequestsForAdmin).mockResolvedValue({
        items: [],
        nextCursor: null,
      });
      vi.mocked(dbModule.countPendingVerificationRequests).mockResolvedValue(0);

      const modToken = await signAccessToken({ sub: 'user-mod', role: 'MODERATOR' });
      const modRes = await app.inject({
        method: 'GET',
        url: '/v1/admin/verifications',
        headers: { authorization: `Bearer ${modToken}` },
      });
      expect(modRes.statusCode).toBe(200);

      const superToken = await signAccessToken({ sub: 'user-super', role: 'SUPER_ADMIN' });
      const superRes = await app.inject({
        method: 'GET',
        url: '/v1/admin/verifications',
        headers: { authorization: `Bearer ${superToken}` },
      });
      expect(superRes.statusCode).toBe(200);
    });
  });

  describe('2. GET /v1/admin/verifications (File KYC)', () => {
    it('renvoie la liste des demandes et le total pending', async () => {
      const app = await buildTestApp();
      const adminToken = await signAccessToken({ sub: VALID_UUID_ADMIN, role: 'ADMIN' });

      const itemDate = new Date('2026-11-20T10:00:00Z');
      vi.mocked(dbModule.listVerificationRequestsForAdmin).mockResolvedValue({
        items: [
          {
            id: VALID_UUID_REQ,
            providerId: VALID_UUID_PROV,
            provider: {
              id: VALID_UUID_PROV,
              businessName: 'Électricité Express',
              slug: 'electricite-express',
              baseGovernorateId: 'tunis-id',
              isVerified: false,
            },
            fullNameOnId: 'Mourad Trabelsi',
            status: 'PENDING',
            submittedAt: itemDate,
            reviewedAt: null,
            reviewedBy: null,
            documentsCount: 2,
            documents: [
              { id: '11111111-1111-4111-8111-111111111111', type: 'CIN_FRONT' },
              { id: '22222222-2222-4222-8222-222222222222', type: 'CIN_BACK' },
            ],
          },
        ],
        nextCursor: 'next-cursor-str',
      });
      vi.mocked(dbModule.countPendingVerificationRequests).mockResolvedValue(1);

      const response = await app.inject({
        method: 'GET',
        url: '/v1/admin/verifications?status=PENDING&limit=10',
        headers: { authorization: `Bearer ${adminToken}` },
      });

      expect(response.statusCode).toBe(200);
      const body = response.json();
      expect(body.totalPending).toBe(1);
      expect(body.nextCursor).toBe('next-cursor-str');
      expect(body.items).toHaveLength(1);
      expect(body.items[0].fullNameOnId).toBe('Mourad Trabelsi');
      expect(body.items[0].documentsCount).toBe(2);
    });

    it('renvoie 400 VALIDATION_ERROR si le curseur est invalide', async () => {
      const app = await buildTestApp();
      const adminToken = await signAccessToken({ sub: VALID_UUID_ADMIN, role: 'ADMIN' });

      vi.mocked(dbModule.listVerificationRequestsForAdmin).mockRejectedValue(
        new dbModule.InvalidCursorError('bad-cursor'),
      );

      const response = await app.inject({
        method: 'GET',
        url: '/v1/admin/verifications?cursor=bad-cursor',
        headers: { authorization: `Bearer ${adminToken}` },
      });

      expect(response.statusCode).toBe(400);
      expect(response.json().error.code).toBe('VALIDATION_ERROR');
    });
  });

  describe('3. GET /v1/admin/verifications/:id (Détails & URLs R2)', () => {
    it('renvoie 400 si l’ID n’est pas un UUID valide', async () => {
      const app = await buildTestApp();
      const adminToken = await signAccessToken({ sub: VALID_UUID_ADMIN, role: 'ADMIN' });

      const response = await app.inject({
        method: 'GET',
        url: '/v1/admin/verifications/not-a-uuid',
        headers: { authorization: `Bearer ${adminToken}` },
      });

      expect(response.statusCode).toBe(400);
      expect(response.json().error.code).toBe('VALIDATION_ERROR');
    });

    it('renvoie 404 KYC_REQUEST_NOT_FOUND si la demande n’existe pas', async () => {
      const app = await buildTestApp();
      const adminToken = await signAccessToken({ sub: VALID_UUID_ADMIN, role: 'ADMIN' });

      vi.mocked(dbModule.findVerificationRequestDetailsForAdmin).mockResolvedValue(null);

      const response = await app.inject({
        method: 'GET',
        url: `/v1/admin/verifications/${VALID_UUID_REQ}`,
        headers: { authorization: `Bearer ${adminToken}` },
      });

      expect(response.statusCode).toBe(404);
      expect(response.json().error.code).toBe('KYC_REQUEST_NOT_FOUND');
    });

    it('génère des URL signées éphémères et trace l’accès dans AuditLog', async () => {
      const app = await buildTestApp();
      const adminToken = await signAccessToken({ sub: VALID_UUID_ADMIN, role: 'ADMIN' });

      const subDate = new Date('2026-11-20T10:00:00Z');
      const expiresAt = new Date(Date.now() + 300 * 1000);

      vi.mocked(dbModule.findVerificationRequestDetailsForAdmin).mockResolvedValue({
        id: VALID_UUID_REQ,
        providerId: VALID_UUID_PROV,
        provider: {
          id: VALID_UUID_PROV,
          businessName: 'Électricité Express',
          slug: 'electricite-express',
          headline: 'Électricien qualifié',
          baseGovernorateId: 'tunis-id',
          isVerified: false,
          verificationStatus: 'PENDING',
          user: {
            id: '44444444-4444-4444-8444-444444444444',
            phone: '+21698123456',
          },
        },
        fullNameOnId: 'Mourad Trabelsi',
        status: 'PENDING',
        submittedAt: subDate,
        reviewedAt: null,
        reviewedBy: null,
        rejectionReason: null,
        internalNote: null,
        documents: [
          {
            id: '11111111-1111-4111-8111-111111111111',
            type: 'CIN_FRONT',
            mediaId: '55555555-5555-4555-8555-555555555555',
            media: { storageKey: 'kyc/p1/r1/recto.jpg' },
          },
          {
            id: '22222222-2222-4222-8222-222222222222',
            type: 'CIN_BACK',
            mediaId: '66666666-6666-4666-8666-666666666666',
            media: { storageKey: 'kyc/p1/r1/verso.jpg' },
          },
        ],
      });

      vi.mocked(storageModule.presignKycRead)
        .mockResolvedValueOnce({
          downloadUrl: 'https://r2.example.com/kyc/p1/r1/recto.jpg?signed=1',
          expiresAt,
        })
        .mockResolvedValueOnce({
          downloadUrl: 'https://r2.example.com/kyc/p1/r1/verso.jpg?signed=2',
          expiresAt,
        });

      vi.mocked(dbModule.logVerificationView).mockResolvedValue();

      const response = await app.inject({
        method: 'GET',
        url: `/v1/admin/verifications/${VALID_UUID_REQ}`,
        headers: { authorization: `Bearer ${adminToken}` },
      });

      expect(response.statusCode).toBe(200);
      const body = response.json();
      expect(body.documents).toHaveLength(2);
      expect(body.documents[0].downloadUrl).toContain('https://r2.example.com');
      expect(body.documents[1].downloadUrl).toContain('https://r2.example.com');

      // Vérifie l'appel au traçage AuditLog
      expect(dbModule.logVerificationView).toHaveBeenCalledWith(
        expect.objectContaining({
          requestId: VALID_UUID_REQ,
          actorId: VALID_UUID_ADMIN,
          documentTypes: ['CIN_FRONT', 'CIN_BACK'],
        }),
      );
    });

    it('renvoie isPurged: true et downloadUrl: null pour les documents dont le storageKey commence par purged:', async () => {
      const app = await buildTestApp();
      const adminToken = await signAccessToken({ sub: VALID_UUID_ADMIN, role: 'ADMIN' });

      vi.mocked(dbModule.findVerificationRequestDetailsForAdmin).mockResolvedValue({
        id: VALID_UUID_REQ,
        providerId: VALID_UUID_PROV,
        provider: {
          id: VALID_UUID_PROV,
          businessName: 'Électricité Express',
          slug: 'electricite-express',
          headline: 'Électricien qualifié',
          baseGovernorateId: 'tunis-id',
          isVerified: true,
          verificationStatus: 'APPROVED',
          user: {
            id: '44444444-4444-4444-8444-444444444444',
            phone: '+21698123456',
          },
        },
        fullNameOnId: 'Mourad Trabelsi',
        status: 'APPROVED',
        submittedAt: new Date('2026-10-01T10:00:00Z'),
        reviewedAt: new Date('2026-10-02T10:00:00Z'),
        reviewedBy: null,
        rejectionReason: null,
        internalNote: null,
        expiresAt: new Date('2026-11-01T10:00:00Z'),
        documents: [
          {
            id: '11111111-1111-4111-8111-111111111111',
            type: 'CIN_FRONT',
            mediaId: '55555555-5555-4555-8555-555555555555',
            media: { storageKey: 'purged:55555555-5555-4555-8555-555555555555' },
          },
        ],
      });

      const response = await app.inject({
        method: 'GET',
        url: `/v1/admin/verifications/${VALID_UUID_REQ}`,
        headers: { authorization: `Bearer ${adminToken}` },
      });

      expect(response.statusCode).toBe(200);
      const body = response.json();
      expect(body.documents).toHaveLength(1);
      expect(body.documents[0]).toEqual({
        id: '11111111-1111-4111-8111-111111111111',
        type: 'CIN_FRONT',
        mediaId: '55555555-5555-4555-8555-555555555555',
        downloadUrl: null,
        expiresAt: null,
        isPurged: true,
      });

      expect(storageModule.presignKycRead).not.toHaveBeenCalled();
    });
  });

  describe('3. POST /v1/admin/verifications/:id/review (Revue modérateur)', () => {
    it('refuse un REJECTED sans rejectionReason (400 VALIDATION_ERROR)', async () => {
      const app = await buildTestApp();
      const adminToken = await signAccessToken({ sub: VALID_UUID_ADMIN, role: 'ADMIN' });

      const response = await app.inject({
        method: 'POST',
        url: `/v1/admin/verifications/${VALID_UUID_REQ}/review`,
        headers: { authorization: `Bearer ${adminToken}` },
        payload: {
          status: 'REJECTED',
        },
      });

      expect(response.statusCode).toBe(400);
      expect(response.json().error.code).toBe('VALIDATION_ERROR');
    });

    it('refuse un MORE_INFO_REQUIRED avec rejectionReason < 5 caractères (400 VALIDATION_ERROR)', async () => {
      const app = await buildTestApp();
      const adminToken = await signAccessToken({ sub: VALID_UUID_ADMIN, role: 'ADMIN' });

      const response = await app.inject({
        method: 'POST',
        url: `/v1/admin/verifications/${VALID_UUID_REQ}/review`,
        headers: { authorization: `Bearer ${adminToken}` },
        payload: {
          status: 'MORE_INFO_REQUIRED',
          rejectionReason: 'flou', // 4 caractères
        },
      });

      expect(response.statusCode).toBe(400);
      expect(response.json().error.code).toBe('VALIDATION_ERROR');
    });

    it('renvoie 404 si la demande est introuvable', async () => {
      const app = await buildTestApp();
      const adminToken = await signAccessToken({ sub: VALID_UUID_ADMIN, role: 'ADMIN' });

      vi.mocked(dbModule.reviewVerificationRequest).mockResolvedValue(null);

      const response = await app.inject({
        method: 'POST',
        url: `/v1/admin/verifications/${VALID_UUID_REQ}/review`,
        headers: { authorization: `Bearer ${adminToken}` },
        payload: {
          status: 'APPROVED',
        },
      });

      expect(response.statusCode).toBe(404);
      expect(response.json().error.code).toBe('KYC_REQUEST_NOT_FOUND');
    });

    it('renvoie 400 KYC_INVALID_STATUS_TRANSITION si la requête n’est plus PENDING', async () => {
      const app = await buildTestApp();
      const adminToken = await signAccessToken({ sub: VALID_UUID_ADMIN, role: 'ADMIN' });

      vi.mocked(dbModule.reviewVerificationRequest).mockRejectedValue(
        new dbModule.InvalidStatusTransitionError('Déjà traitée'),
      );

      const response = await app.inject({
        method: 'POST',
        url: `/v1/admin/verifications/${VALID_UUID_REQ}/review`,
        headers: { authorization: `Bearer ${adminToken}` },
        payload: {
          status: 'APPROVED',
        },
      });

      expect(response.statusCode).toBe(400);
      expect(response.json().error.code).toBe('KYC_INVALID_STATUS_TRANSITION');
    });

    it('approuve avec succès la demande (APPROVED)', async () => {
      const app = await buildTestApp();
      const adminToken = await signAccessToken({ sub: VALID_UUID_ADMIN, role: 'ADMIN' });

      const reviewedAt = new Date();
      vi.mocked(dbModule.reviewVerificationRequest).mockResolvedValue({
        id: VALID_UUID_REQ,
        status: 'APPROVED',
        reviewedAt,
        reviewedById: VALID_UUID_ADMIN,
        isVerified: true,
        rejectionReason: null,
        internalNote: 'Dossier complet et vérifié',
      });

      const response = await app.inject({
        method: 'POST',
        url: `/v1/admin/verifications/${VALID_UUID_REQ}/review`,
        headers: { authorization: `Bearer ${adminToken}` },
        payload: {
          status: 'APPROVED',
          internalNote: 'Dossier complet et vérifié',
        },
      });

      expect(response.statusCode).toBe(200);
      const body = response.json();
      expect(body.status).toBe('APPROVED');
      expect(body.isVerified).toBe(true);
      expect(body.internalNote).toBe('Dossier complet et vérifié');
    });

    it('rejette avec succès la demande avec motif (REJECTED)', async () => {
      const app = await buildTestApp();
      const adminToken = await signAccessToken({ sub: VALID_UUID_ADMIN, role: 'ADMIN' });

      const reviewedAt = new Date();
      vi.mocked(dbModule.reviewVerificationRequest).mockResolvedValue({
        id: VALID_UUID_REQ,
        status: 'REJECTED',
        reviewedAt,
        reviewedById: VALID_UUID_ADMIN,
        isVerified: false,
        rejectionReason: 'CIN illisible et photo rognée',
        internalNote: null,
      });

      const response = await app.inject({
        method: 'POST',
        url: `/v1/admin/verifications/${VALID_UUID_REQ}/review`,
        headers: { authorization: `Bearer ${adminToken}` },
        payload: {
          status: 'REJECTED',
          rejectionReason: 'CIN illisible et photo rognée',
        },
      });

      expect(response.statusCode).toBe(200);
      const body = response.json();
      expect(body.status).toBe('REJECTED');
      expect(body.isVerified).toBe(false);
      expect(body.rejectionReason).toBe('CIN illisible et photo rognée');
    });
  });

  describe('4. POST /v1/admin/verifications/purge-expired (BE-30c)', () => {
    it('refuse l’accès aux rôles non-SUPER_ADMIN (403 FORBIDDEN)', async () => {
      const app = await buildTestApp();
      const adminToken = await signAccessToken({ sub: VALID_UUID_ADMIN, role: 'ADMIN' });

      const response = await app.inject({
        method: 'POST',
        url: '/v1/admin/verifications/purge-expired',
        headers: { authorization: `Bearer ${adminToken}` },
      });

      expect(response.statusCode).toBe(403);
    });

    it('autorise SUPER_ADMIN et retourne le bilan de purge', async () => {
      const app = await buildTestApp();
      const superAdminToken = await signAccessToken({
        sub: VALID_UUID_ADMIN,
        role: 'SUPER_ADMIN',
      });

      vi.mocked(coreModule.purgeExpiredKycMedia).mockResolvedValue({
        totalProcessed: 5,
        purgedCount: 4,
        skippedCount: 1,
        errors: [],
      });

      const response = await app.inject({
        method: 'POST',
        url: '/v1/admin/verifications/purge-expired',
        headers: { authorization: `Bearer ${superAdminToken}` },
      });

      expect(response.statusCode).toBe(200);
      expect(response.json()).toEqual({
        totalProcessed: 5,
        purgedCount: 4,
        skippedCount: 1,
        errorsCount: 0,
      });
    });
  });
});
