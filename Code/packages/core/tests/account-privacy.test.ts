import { beforeEach, describe, expect, it, vi } from 'vitest';
import {
  ACCOUNT_ALREADY_DELETED,
  ACCOUNT_DELETION_CONFIRMATION_REQUIRED,
  CANNOT_DELETE_LAST_ADMIN,
  NOT_FOUND,
} from '@repo/constants';
import * as dbRepo from '@repo/db';
import {
  buildUserDataExport,
  deleteUserAccount,
  INPDP_LEGAL_NOTICE,
} from '../src/privacy/account-privacy.js';

vi.mock('@repo/db', () => ({
  getUserCompleteDataForExport: vi.fn(),
  findUserById: vi.fn(),
  isLastAdmin: vi.fn(),
  executeUserAccountDeletion: vi.fn(),
}));

describe('Privacy and Account Deletion Service (BE-41)', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  describe('buildUserDataExport', () => {
    it('lève NOT_FOUND si les données utilisateur sont introuvables', async () => {
      vi.mocked(dbRepo.getUserCompleteDataForExport).mockResolvedValue(null);

      await expect(buildUserDataExport('missing-user')).rejects.toThrowError(
        expect.objectContaining({ code: NOT_FOUND }),
      );
    });

    it('retourne les données structurées avec la mention légale INPDP et exportedAt', async () => {
      const mockRawData: dbRepo.UserExportDataRaw = {
        user: {
          id: 'user-1',
          phone: '+21620123456',
          phoneVerifiedAt: new Date('2026-01-01'),
          email: 'test@example.tn',
          emailVerifiedAt: new Date('2026-01-01'),
          firstName: 'Sami',
          lastName: 'Mabrouk',
          avatarMediaId: null,
          roles: ['CLIENT'],
          status: 'ACTIVE',
          locale: 'FR',
          lastLoginAt: new Date('2026-02-01'),
          marketingOptIn: false,
          acceptedTermsVersion: 'v1.0',
          acceptedTermsAt: new Date('2026-01-01'),
          createdAt: new Date('2026-01-01'),
          updatedAt: new Date('2026-02-01'),
        },
        providerProfile: null,
        reviewsWritten: [],
        favorites: [],
        contactEvents: [],
        verificationRequests: [],
      };

      vi.mocked(dbRepo.getUserCompleteDataForExport).mockResolvedValue(mockRawData);

      const result = await buildUserDataExport('user-1');
      expect(result.legalNotice).toBe(INPDP_LEGAL_NOTICE);
      expect(result.exportedAt).toBeInstanceOf(Date);
      expect(result.user.id).toBe('user-1');
      expect(result.user.firstName).toBe('Sami');
    });
  });

  describe('deleteUserAccount', () => {
    it('lève ACCOUNT_DELETION_CONFIRMATION_REQUIRED si confirmation invalide', async () => {
      await expect(deleteUserAccount({ userId: 'u1', confirmation: 'OUI' })).rejects.toThrowError(
        expect.objectContaining({ code: ACCOUNT_DELETION_CONFIRMATION_REQUIRED }),
      );

      await expect(deleteUserAccount({ userId: 'u1', confirmation: '' })).rejects.toThrowError(
        expect.objectContaining({ code: ACCOUNT_DELETION_CONFIRMATION_REQUIRED }),
      );
    });

    it('lève ACCOUNT_ALREADY_DELETED si l utilisateur n existe pas ou est déjà DELETED', async () => {
      vi.mocked(dbRepo.findUserById).mockResolvedValue(null);

      await expect(
        deleteUserAccount({ userId: 'u1', confirmation: 'SUPPRIMER' }),
      ).rejects.toThrowError(expect.objectContaining({ code: ACCOUNT_ALREADY_DELETED }));

      vi.mocked(dbRepo.findUserById).mockResolvedValue({
        id: 'u1',
        phone: '+21620123456',
        phoneVerifiedAt: null,
        email: null,
        emailVerifiedAt: null,
        firstName: null,
        lastName: null,
        avatarMediaId: null,
        roles: ['CLIENT'],
        status: 'DELETED',
        locale: 'FR',
        lastLoginAt: null,
        marketingOptIn: false,
        createdAt: new Date(),
        updatedAt: new Date(),
      });

      await expect(
        deleteUserAccount({ userId: 'u1', confirmation: 'DELETE' }),
      ).rejects.toThrowError(expect.objectContaining({ code: ACCOUNT_ALREADY_DELETED }));
    });

    it('lève CANNOT_DELETE_LAST_ADMIN si l utilisateur est le dernier admin', async () => {
      vi.mocked(dbRepo.findUserById).mockResolvedValue({
        id: 'admin-1',
        phone: '+21620123456',
        phoneVerifiedAt: null,
        email: null,
        emailVerifiedAt: null,
        firstName: null,
        lastName: null,
        avatarMediaId: null,
        roles: ['ADMIN'],
        status: 'ACTIVE',
        locale: 'FR',
        lastLoginAt: null,
        marketingOptIn: false,
        createdAt: new Date(),
        updatedAt: new Date(),
      });
      vi.mocked(dbRepo.isLastAdmin).mockResolvedValue(true);

      await expect(
        deleteUserAccount({ userId: 'admin-1', confirmation: 'SUPPRIMER' }),
      ).rejects.toThrowError(expect.objectContaining({ code: CANNOT_DELETE_LAST_ADMIN }));
    });

    it('exécute la suppression et renvoie la confirmation avec succès', async () => {
      const now = new Date('2026-11-23T20:00:00Z');
      vi.mocked(dbRepo.findUserById).mockResolvedValue({
        id: 'user-regular',
        phone: '+21620123456',
        phoneVerifiedAt: null,
        email: null,
        emailVerifiedAt: null,
        firstName: null,
        lastName: null,
        avatarMediaId: null,
        roles: ['CLIENT'],
        status: 'ACTIVE',
        locale: 'FR',
        lastLoginAt: null,
        marketingOptIn: false,
        createdAt: new Date(),
        updatedAt: new Date(),
      });
      vi.mocked(dbRepo.isLastAdmin).mockResolvedValue(false);
      vi.mocked(dbRepo.executeUserAccountDeletion).mockResolvedValue(now);

      const result = await deleteUserAccount({
        userId: 'user-regular',
        confirmation: '  supprimer  ',
        reason: 'Raison personnelle',
      });

      expect(result.success).toBe(true);
      expect(result.status).toBe('DELETED');
      expect(result.deletedAt).toBe(now);
      expect(dbRepo.executeUserAccountDeletion).toHaveBeenCalledWith(
        'user-regular',
        { reason: 'Raison personnelle' },
        undefined,
      );
    });
  });
});
