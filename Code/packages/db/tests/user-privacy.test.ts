import { describe, expect, it, vi } from 'vitest';
import type { DbClient } from '../src/types.js';
import {
  getUserCompleteDataForExport,
  isLastAdmin,
  executeUserAccountDeletion,
} from '../src/repositories/user.repository.js';

describe('User Privacy & Account Deletion in @repo/db (BE-41)', () => {
  describe('getUserCompleteDataForExport', () => {
    it('renvoie null si utilisateur introuvable ou déjà supprimé', async () => {
      const mockDb = {
        user: {
          findFirst: vi.fn().mockResolvedValue(null),
        },
      } as unknown as DbClient;

      const result = await getUserCompleteDataForExport('non-existent', mockDb);
      expect(result).toBeNull();
    });

    it('renvoie les données complètes d un client', async () => {
      const mockUser = {
        id: 'user-client-1',
        phone: '+21620123456',
        phoneVerifiedAt: new Date('2026-01-01'),
        email: 'client@example.tn',
        emailVerifiedAt: new Date('2026-01-01'),
        firstName: 'Ahmed',
        lastName: 'Ben Ali',
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
        providerProfile: null,
        reviewsWritten: [
          {
            id: 'rev-1',
            providerId: 'pro-1',
            rating: 5,
            ratingPunctuality: 5,
            ratingQuality: 5,
            ratingValue: 5,
            comment: 'Excellent travail',
            status: 'PUBLISHED',
            isVerifiedContact: true,
            createdAt: new Date('2026-02-10'),
            provider: { businessName: 'Plomberie Express' },
          },
        ],
        favorites: [
          {
            providerId: 'pro-1',
            createdAt: new Date('2026-02-05'),
            provider: { businessName: 'Plomberie Express' },
          },
        ],
        contactEvents: [
          {
            id: 'contact-1',
            providerId: 'pro-1',
            channel: 'PHONE_CALL',
            createdAt: new Date('2026-02-05'),
            provider: { businessName: 'Plomberie Express' },
          },
        ],
      };

      const mockDb = {
        user: {
          findFirst: vi.fn().mockResolvedValue(mockUser),
        },
      } as unknown as DbClient;

      const result = await getUserCompleteDataForExport('user-client-1', mockDb);
      expect(result).not.toBeNull();
      expect(result?.user.id).toBe('user-client-1');
      expect(result?.user.firstName).toBe('Ahmed');
      expect(result?.providerProfile).toBeNull();
      expect(result?.reviewsWritten).toHaveLength(1);
      expect(result?.reviewsWritten[0]?.providerBusinessName).toBe('Plomberie Express');
      expect(result?.favorites).toHaveLength(1);
      expect(result?.contactEvents).toHaveLength(1);
      expect(result?.verificationRequests).toHaveLength(0);
    });

    it('renvoie les données complètes d un artisan avec son profil et ses vérifications', async () => {
      const mockProUser = {
        id: 'user-pro-1',
        phone: '+21698123456',
        phoneVerifiedAt: new Date('2026-01-01'),
        email: 'artisan@example.tn',
        emailVerifiedAt: new Date('2026-01-01'),
        firstName: 'Karim',
        lastName: 'Trabelsi',
        avatarMediaId: 'media-avatar',
        roles: ['CLIENT', 'PROVIDER'],
        status: 'ACTIVE',
        locale: 'AR',
        lastLoginAt: new Date('2026-02-15'),
        marketingOptIn: true,
        acceptedTermsVersion: 'v1.0',
        acceptedTermsAt: new Date('2026-01-01'),
        createdAt: new Date('2026-01-01'),
        updatedAt: new Date('2026-02-15'),
        providerProfile: {
          id: 'pro-1',
          slug: 'karim-electricite',
          businessName: 'Karim Électricité',
          headline: 'Électricien qualifié',
          bio: '10 ans d expérience',
          yearsExperience: 10,
          whatsappPhone: '+21698123456',
          publicPhone: '+21698123456',
          spokenLanguages: ['FR', 'AR'],
          baseGovernorate: { nameFr: 'Tunis' },
          baseDelegation: { nameFr: 'La Marsa' },
          publicationStatus: 'PUBLISHED',
          availabilityStatus: 'AVAILABLE',
          isVerified: true,
          verifiedAt: new Date('2026-01-10'),
          ratingAvg: 4.8,
          ratingCount: 15,
          categories: [
            {
              isPrimary: true,
              category: { id: 'cat-1', nameFr: 'Électricité', nameAr: 'كهرباء' },
            },
          ],
          offerings: [
            {
              id: 'off-1',
              titleFr: 'Dépannage',
              titleAr: 'إصلاح',
              priceMin: 30,
              priceMax: 80,
              priceUnit: 'HOUR',
            },
          ],
          coverageAreas: [
            {
              id: 'area-1',
              governorate: { nameFr: 'Tunis', nameAr: 'تونس' },
              delegation: { nameFr: 'La Marsa', nameAr: 'المرسى' },
            },
          ],
          _count: { portfolio: 4 },
          verifications: [
            {
              id: 'req-1',
              status: 'APPROVED',
              submittedAt: new Date('2026-01-05'),
              reviewedAt: new Date('2026-01-10'),
              rejectionReason: null,
              documents: [{ type: 'CIN_FRONT' }, { type: 'CIN_BACK' }],
            },
          ],
        },
        reviewsWritten: [],
        favorites: [],
        contactEvents: [],
      };

      const mockDb = {
        user: {
          findFirst: vi.fn().mockResolvedValue(mockProUser),
        },
      } as unknown as DbClient;

      const result = await getUserCompleteDataForExport('user-pro-1', mockDb);
      expect(result).not.toBeNull();
      expect(result?.providerProfile).not.toBeNull();
      expect(result?.providerProfile?.businessName).toBe('Karim Électricité');
      expect(result?.providerProfile?.categories).toHaveLength(1);
      expect(result?.providerProfile?.offerings).toHaveLength(1);
      expect(result?.providerProfile?.coverageAreas).toHaveLength(1);
      expect(result?.providerProfile?.portfolioCount).toBe(4);
      expect(result?.verificationRequests).toHaveLength(1);
      expect(result?.verificationRequests[0]?.documentTypes).toEqual(['CIN_FRONT', 'CIN_BACK']);
    });
  });

  describe('isLastAdmin', () => {
    it('renvoie false si l utilisateur n a pas de rôle admin', async () => {
      const mockDb = {
        user: {
          findUnique: vi.fn().mockResolvedValue({
            roles: ['CLIENT'],
            status: 'ACTIVE',
            deletedAt: null,
          }),
        },
      } as unknown as DbClient;

      const result = await isLastAdmin('user-client', mockDb);
      expect(result).toBe(false);
    });

    it('renvoie true si l admin est le seul admin actif restant', async () => {
      const mockDb = {
        user: {
          findUnique: vi.fn().mockResolvedValue({
            roles: ['ADMIN'],
            status: 'ACTIVE',
            deletedAt: null,
          }),
          count: vi.fn().mockResolvedValue(0),
        },
      } as unknown as DbClient;

      const result = await isLastAdmin('admin-1', mockDb);
      expect(result).toBe(true);
      expect(mockDb.user.count).toHaveBeenCalledWith({
        where: {
          id: { not: 'admin-1' },
          deletedAt: null,
          status: 'ACTIVE',
          roles: { hasSome: ['ADMIN', 'SUPER_ADMIN'] },
        },
      });
    });

    it('renvoie false s il existe d autres admins actifs', async () => {
      const mockDb = {
        user: {
          findUnique: vi.fn().mockResolvedValue({
            roles: ['SUPER_ADMIN'],
            status: 'ACTIVE',
            deletedAt: null,
          }),
          count: vi.fn().mockResolvedValue(2),
        },
      } as unknown as DbClient;

      const result = await isLastAdmin('admin-1', mockDb);
      expect(result).toBe(false);
    });
  });

  describe('executeUserAccountDeletion', () => {
    it('anonymise le user, suspend le profil pro, révoque sessions et consigne audit log', async () => {
      const mockUser = {
        id: 'user-to-delete',
        phone: '+21622999888',
        status: 'ACTIVE',
        roles: ['CLIENT', 'PROVIDER'],
        deletedAt: null,
        providerProfile: { id: 'pro-to-delete' },
      };

      const mockTx = {
        user: {
          findUniqueOrThrow: vi.fn().mockResolvedValue(mockUser),
          update: vi.fn().mockResolvedValue({ id: 'user-to-delete' }),
        },
        providerProfile: {
          update: vi.fn().mockResolvedValue({ id: 'pro-to-delete' }),
        },
        session: {
          updateMany: vi.fn().mockResolvedValue({ count: 3 }),
        },
        otpCode: {
          deleteMany: vi.fn().mockResolvedValue({ count: 1 }),
        },
        favorite: {
          deleteMany: vi.fn().mockResolvedValue({ count: 2 }),
        },
        auditLog: {
          create: vi.fn().mockResolvedValue({ id: 'audit-log-1' }),
        },
      };

      const mockDb = {
        $transaction: vi.fn().mockImplementation((cb) => cb(mockTx)),
      } as unknown as DbClient;

      const deletedAt = await executeUserAccountDeletion(
        'user-to-delete',
        { reason: 'Changement de métier' },
        mockDb,
      );

      expect(deletedAt).toBeInstanceOf(Date);
      expect(mockTx.user.update).toHaveBeenCalledWith({
        where: { id: 'user-to-delete' },
        data: expect.objectContaining({
          status: 'DELETED',
          firstName: 'Utilisateur',
          lastName: 'supprimé',
          email: null,
          avatarMediaId: null,
          marketingOptIn: false,
        }),
        select: { id: true },
      });
      // Téléphone haché avec préfixe d_
      const updateCall = mockTx.user.update.mock.calls[0]?.[0];
      expect(updateCall?.data.phone).toMatch(/^d_[a-f0-9]{18}$/);

      expect(mockTx.providerProfile.update).toHaveBeenCalledWith({
        where: { id: 'pro-to-delete' },
        data: expect.objectContaining({
          publicationStatus: 'SUSPENDED',
          isVerified: false,
          businessName: 'Prestataire désactivé',
        }),
        select: { id: true },
      });

      expect(mockTx.session.updateMany).toHaveBeenCalledWith({
        where: { userId: 'user-to-delete', revokedAt: null },
        data: { revokedAt: expect.any(Date) },
      });

      expect(mockTx.otpCode.deleteMany).toHaveBeenCalledWith({
        where: { userId: 'user-to-delete' },
      });

      expect(mockTx.favorite.deleteMany).toHaveBeenCalledWith({
        where: { userId: 'user-to-delete' },
      });

      expect(mockTx.auditLog.create).toHaveBeenCalledWith({
        data: expect.objectContaining({
          actorId: 'user-to-delete',
          action: 'user.account.delete',
          entityType: 'User',
          entityId: 'user-to-delete',
        }),
      });
    });
  });
});
