/**
 * BE-41 — Tests des routes de confidentialité et gestion des données personnelles (/v1/users/me/*).
 *
 * Vérifie :
 * 1. Export des données personnelles (GET /v1/users/me/export) :
 *    - 401 si non authentifié
 *    - 404 si utilisateur introuvable / supprimé
 *    - 200 avec structure complète conforme INPDP 2004-63 et header attachment.
 * 2. Suppression de compte (DELETE /v1/users/me) :
 *    - 401 si non authentifié
 *    - 400 si confirmation manquante ou non reconnue
 *    - 410 si compte déjà supprimé
 *    - 403 si dernier administrateur actif sur la plateforme
 *    - 200 si confirmation valide (SUPPRIMER ou DELETE).
 */
import * as coreModule from '@repo/core';
import { signAccessToken } from '@repo/core';
import Fastify from 'fastify';
import {
  serializerCompiler,
  validatorCompiler,
  type ZodTypeProvider,
} from 'fastify-type-provider-zod';
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';

import { registerErrorHandler } from '../src/plugins/error-handler.js';
import { registerRequireAuth } from '../src/plugins/require-auth.js';
import { accountRoutes } from '../src/routes/account.js';

vi.mock('@repo/core', async (importOriginal) => {
  const actual = await importOriginal<typeof import('@repo/core')>();
  return {
    ...actual,
    buildUserDataExport: vi.fn(),
    deleteUserAccount: vi.fn(),
  };
});

const TEST_SECRET = 'secret-de-test-suffisamment-long-pour-jwt-32-chars';
const VALID_USER_ID = '11111111-1111-4111-8111-111111111111';

async function buildTestApp() {
  const app = Fastify().withTypeProvider<ZodTypeProvider>();
  app.setValidatorCompiler(validatorCompiler);
  app.setSerializerCompiler(serializerCompiler);
  registerErrorHandler(app);
  registerRequireAuth(app);
  await app.register(accountRoutes, { prefix: '/v1' });
  return app;
}

describe('BE-41 — Routes de confidentialité (/v1/users/me/*)', () => {
  beforeEach(() => {
    vi.stubEnv('JWT_ACCESS_SECRET', TEST_SECRET);
    vi.clearAllMocks();
  });

  afterEach(() => {
    vi.unstubAllEnvs();
  });

  describe('GET /v1/users/me/export', () => {
    it('refuse une requête sans token (401 ACCESS_TOKEN_INVALID)', async () => {
      const app = await buildTestApp();
      const response = await app.inject({
        method: 'GET',
        url: '/v1/users/me/export',
      });

      expect(response.statusCode).toBe(401);
      expect(response.json().error.code).toBe('ACCESS_TOKEN_INVALID');
    });

    it('renvoie 404 si l utilisateur est introuvable ou supprimé', async () => {
      vi.mocked(coreModule.buildUserDataExport).mockRejectedValue(
        new coreModule.DomainError('NOT_FOUND', 'Utilisateur introuvable'),
      );

      const app = await buildTestApp();
      const token = await signAccessToken({ sub: VALID_USER_ID, role: 'CLIENT' });
      const response = await app.inject({
        method: 'GET',
        url: '/v1/users/me/export',
        headers: { authorization: `Bearer ${token}` },
      });

      expect(response.statusCode).toBe(404);
      expect(response.json().error.code).toBe('NOT_FOUND');
    });

    it('exporte les données avec le header Content-Disposition et statut 200', async () => {
      const mockExportData: coreModule.UserExportDataResult = {
        legalNotice: coreModule.INPDP_LEGAL_NOTICE,
        exportedAt: new Date('2026-11-23T20:00:00.000Z'),
        user: {
          id: VALID_USER_ID,
          phone: '+21620123456',
          phoneVerifiedAt: new Date('2026-01-01T00:00:00.000Z'),
          email: 'client@example.tn',
          emailVerifiedAt: new Date('2026-01-01T00:00:00.000Z'),
          firstName: 'Amine',
          lastName: 'Mansour',
          avatarMediaId: null,
          roles: ['CLIENT'],
          status: 'ACTIVE' as const,
          locale: 'FR',
          lastLoginAt: new Date('2026-02-01T00:00:00.000Z'),
          marketingOptIn: false,
          acceptedTermsVersion: 'v1.0',
          acceptedTermsAt: new Date('2026-01-01T00:00:00.000Z'),
          createdAt: new Date('2026-01-01T00:00:00.000Z'),
          updatedAt: new Date('2026-02-01T00:00:00.000Z'),
        },
        providerProfile: null,
        reviewsWritten: [],
        favorites: [],
        contactEvents: [],
        verificationRequests: [],
      };

      vi.mocked(coreModule.buildUserDataExport).mockResolvedValue(mockExportData);

      const app = await buildTestApp();
      const token = await signAccessToken({ sub: VALID_USER_ID, role: 'CLIENT' });
      const response = await app.inject({
        method: 'GET',
        url: '/v1/users/me/export',
        headers: { authorization: `Bearer ${token}` },
      });

      expect(response.statusCode).toBe(200);
      expect(response.headers['content-disposition']).toBe(
        `attachment; filename="donnees-personnelles-${VALID_USER_ID}.json"`,
      );
      const json = response.json();
      expect(json.user.id).toBe(VALID_USER_ID);
      expect(json.user.firstName).toBe('Amine');
      expect(json.legalNotice).toBe(coreModule.INPDP_LEGAL_NOTICE);
      expect(coreModule.buildUserDataExport).toHaveBeenCalledWith(VALID_USER_ID);
    });
  });

  describe('DELETE /v1/users/me', () => {
    it('refuse une requête sans token (401 ACCESS_TOKEN_INVALID)', async () => {
      const app = await buildTestApp();
      const response = await app.inject({
        method: 'DELETE',
        url: '/v1/users/me',
        payload: { confirmation: 'SUPPRIMER' },
      });

      expect(response.statusCode).toBe(401);
      expect(response.json().error.code).toBe('ACCESS_TOKEN_INVALID');
    });

    it('refuse une confirmation invalide (400 VALIDATION_ERROR)', async () => {
      const app = await buildTestApp();
      const token = await signAccessToken({ sub: VALID_USER_ID, role: 'CLIENT' });
      const response = await app.inject({
        method: 'DELETE',
        url: '/v1/users/me',
        headers: { authorization: `Bearer ${token}` },
        payload: { confirmation: 'OUI' },
      });

      expect(response.statusCode).toBe(400);
      expect(response.json().error.code).toBe('VALIDATION_ERROR');
    });

    it('renvoie 410 si le compte est déjà supprimé (ACCOUNT_ALREADY_DELETED)', async () => {
      vi.mocked(coreModule.deleteUserAccount).mockRejectedValue(
        new coreModule.DomainError('ACCOUNT_ALREADY_DELETED', 'Compte déjà supprimé'),
      );

      const app = await buildTestApp();
      const token = await signAccessToken({ sub: VALID_USER_ID, role: 'CLIENT' });
      const response = await app.inject({
        method: 'DELETE',
        url: '/v1/users/me',
        headers: { authorization: `Bearer ${token}` },
        payload: { confirmation: 'SUPPRIMER' },
      });

      expect(response.statusCode).toBe(410);
      expect(response.json().error.code).toBe('ACCOUNT_ALREADY_DELETED');
    });

    it('renvoie 403 si l utilisateur est le dernier admin (CANNOT_DELETE_LAST_ADMIN)', async () => {
      vi.mocked(coreModule.deleteUserAccount).mockRejectedValue(
        new coreModule.DomainError('CANNOT_DELETE_LAST_ADMIN', 'Dernier admin actif'),
      );

      const app = await buildTestApp();
      const token = await signAccessToken({ sub: VALID_USER_ID, role: 'ADMIN' });
      const response = await app.inject({
        method: 'DELETE',
        url: '/v1/users/me',
        headers: { authorization: `Bearer ${token}` },
        payload: { confirmation: 'SUPPRIMER' },
      });

      expect(response.statusCode).toBe(403);
      expect(response.json().error.code).toBe('CANNOT_DELETE_LAST_ADMIN');
    });

    it('supprime et anonymise le compte avec succès (200 OK)', async () => {
      const deletedAt = new Date('2026-11-23T20:10:00.000Z');
      vi.mocked(coreModule.deleteUserAccount).mockResolvedValue({
        success: true,
        status: 'DELETED',
        message: 'Votre compte a été supprimé avec succès.',
        deletedAt,
      });

      const app = await buildTestApp();
      const token = await signAccessToken({ sub: VALID_USER_ID, role: 'CLIENT' });
      const response = await app.inject({
        method: 'DELETE',
        url: '/v1/users/me',
        headers: { authorization: `Bearer ${token}` },
        payload: {
          confirmation: 'SUPPRIMER',
          reason: 'Je n ai plus besoin du service',
        },
      });

      expect(response.statusCode).toBe(200);
      const body = response.json();
      expect(body.success).toBe(true);
      expect(body.status).toBe('DELETED');
      expect(body.deletedAt).toBe(deletedAt.toISOString());
      expect(coreModule.deleteUserAccount).toHaveBeenCalledWith({
        userId: VALID_USER_ID,
        confirmation: 'SUPPRIMER',
        reason: 'Je n ai plus besoin du service',
      });
    });

    it('accepte aussi DELETE comme mot-clé de confirmation', async () => {
      const deletedAt = new Date('2026-11-23T20:15:00.000Z');
      vi.mocked(coreModule.deleteUserAccount).mockResolvedValue({
        success: true,
        status: 'DELETED',
        message: 'Account deleted.',
        deletedAt,
      });

      const app = await buildTestApp();
      const token = await signAccessToken({ sub: VALID_USER_ID, role: 'CLIENT' });
      const response = await app.inject({
        method: 'DELETE',
        url: '/v1/users/me',
        headers: { authorization: `Bearer ${token}` },
        payload: { confirmation: 'DELETE' },
      });

      expect(response.statusCode).toBe(200);
      expect(coreModule.deleteUserAccount).toHaveBeenCalledWith({
        userId: VALID_USER_ID,
        confirmation: 'DELETE',
        reason: undefined,
      });
    });
  });
});
