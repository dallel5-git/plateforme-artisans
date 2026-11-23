import { describe, it, expect } from 'vitest';
import { adminApi, setAdminToken, getAdminToken } from '../src/lib/api';
import { hasAdminPermission } from '../src/lib/rbac';

describe('FW-20a & FW-20b — Tests Unitaires Back-Office Admin KYC', () => {
  it('doit persister et restituer le token administrateur', () => {
    setAdminToken('test-secret-token');
    expect(getAdminToken()).toBe('test-secret-token');
  });

  describe('FW-20a : File de vérification (adminApi.getVerifications)', () => {
    it('doit retourner la liste des demandes triées par défaut en FIFO (anciennes d’abord)', async () => {
      const res = await adminApi.getVerifications({ orderBy: 'asc' });

      expect(res.items).toBeDefined();
      expect(res.items.length).toBeGreaterThan(0);
      expect(res.totalPending).toBeGreaterThan(0);

      // Vérifier le tri ascendant (FIFO)
      for (let i = 1; i < res.items.length; i++) {
        const prev = new Date(res.items[i - 1]!.submittedAt).getTime();
        const curr = new Date(res.items[i]!.submittedAt).getTime();
        expect(curr).toBeGreaterThanOrEqual(prev);
      }
    });

    it('doit filtrer correctement par statut PENDING', async () => {
      const res = await adminApi.getVerifications({ status: 'PENDING' });

      expect(res.items.length).toBeGreaterThan(0);
      res.items.forEach((item) => {
        expect(item.status).toBe('PENDING');
      });
    });

    it('doit filtrer correctement par statut MORE_INFO_REQUIRED', async () => {
      const res = await adminApi.getVerifications({ status: 'MORE_INFO_REQUIRED' });

      expect(res.items.length).toBeGreaterThan(0);
      res.items.forEach((item) => {
        expect(item.status).toBe('MORE_INFO_REQUIRED');
      });
    });
  });

  describe('FW-20b : Détails et consultation sécurisée (adminApi.getVerificationDetails)', () => {
    it('doit retourner les détails complets de la demande avec les documents recto et verso', async () => {
      const list = await adminApi.getVerifications();
      const firstId = list.items[0]!.id;

      const details = await adminApi.getVerificationDetails(firstId);

      expect(details).not.toBeNull();
      expect(details!.id).toBe(firstId);
      expect(details!.provider).toBeDefined();
      expect(details!.provider.businessName).toBeDefined();
      expect(details!.documents.length).toBe(2);

      const front = details!.documents.find((d) => d.type === 'CIN_FRONT');
      const back = details!.documents.find((d) => d.type === 'CIN_BACK');

      expect(front).toBeDefined();
      expect(back).toBeDefined();
      expect(front!.downloadUrl).toBeDefined();
      expect(back!.downloadUrl).toBeDefined();
      expect(front!.expiresAt).toBeDefined();
    });
  });

  describe('FW-20b : Décision modérateur (adminApi.submitReview)', () => {
    it('doit approuver une demande et passer isVerified à true', async () => {
      const list = await adminApi.getVerifications({ status: 'PENDING' });
      const targetId = list.items[0]!.id;

      const reviewRes = await adminApi.submitReview(targetId, {
        status: 'APPROVED',
        internalNote: 'Validation unitaire automatisée',
      });

      expect(reviewRes.success).toBe(true);
      expect(reviewRes.status).toBe('APPROVED');

      // Vérification que le profil est désormais vérifié
      const updatedDetails = await adminApi.getVerificationDetails(targetId);
      expect(updatedDetails!.status).toBe('APPROVED');
      expect(updatedDetails!.provider.isVerified).toBe(true);
    });

    it('doit pouvoir demander un complément avec motif explicite', async () => {
      const list = await adminApi.getVerifications();
      const targetId = list.items[0]!.id;

      const reviewRes = await adminApi.submitReview(targetId, {
        status: 'MORE_INFO_REQUIRED',
        rejectionReason: 'La photo du verso est coupée, veuillez reprendre un cliché net.',
      });

      expect(reviewRes.success).toBe(true);
      expect(reviewRes.status).toBe('MORE_INFO_REQUIRED');
    });

    it('doit pouvoir rejeter une demande avec motif obligatoire', async () => {
      const list = await adminApi.getVerifications();
      const targetId = list.items[0]!.id;

      const reviewRes = await adminApi.submitReview(targetId, {
        status: 'REJECTED',
        rejectionReason: 'Document manifestement falsifié et non conforme.',
      });

      expect(reviewRes.success).toBe(true);
      expect(reviewRes.status).toBe('REJECTED');
    });
  });

  describe('RBAC : Permissions hiérarchiques modérateur', () => {
    it('doit respecter la hiérarchie SUPER_ADMIN > ADMIN > MODERATOR', () => {
      expect(hasAdminPermission('SUPER_ADMIN', 'ADMIN')).toBe(true);
      expect(hasAdminPermission('ADMIN', 'MODERATOR')).toBe(true);
      expect(hasAdminPermission('MODERATOR', 'ADMIN')).toBe(false);
      expect(hasAdminPermission('MODERATOR', 'SUPER_ADMIN')).toBe(false);
    });
  });
});
