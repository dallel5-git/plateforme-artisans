import { describe, expect, it, vi } from 'vitest';
import type { DbClient } from '../src/types.js';
import {
  findKycMediaAssetsDueForPurge,
  markMediaAssetAsPurged,
  scheduleMediaAssetsPurge,
} from '../src/repositories/media-asset.repository.js';
import {
  calculateKycRetentionDate,
  KYC_RETENTION_DAYS_APPROVED,
  KYC_RETENTION_DAYS_REJECTED,
  reviewVerificationRequest,
} from '../src/repositories/verification-request.repository.js';

describe('KYC purge and retention in @repo/db (BE-30c)', () => {
  describe('calculateKycRetentionDate', () => {
    it('calcule 30 jours pour APPROVED et MORE_INFO_REQUIRED', () => {
      const base = new Date('2026-06-01T12:00:00Z');
      const approvedDate = calculateKycRetentionDate('APPROVED', base);
      expect(approvedDate?.toISOString()).toBe(
        new Date(base.getTime() + KYC_RETENTION_DAYS_APPROVED * 24 * 3600 * 1000).toISOString(),
      );

      const moreInfoDate = calculateKycRetentionDate('MORE_INFO_REQUIRED', base);
      expect(moreInfoDate?.toISOString()).toBe(
        new Date(base.getTime() + KYC_RETENTION_DAYS_APPROVED * 24 * 3600 * 1000).toISOString(),
      );
    });

    it('calcule 14 jours pour REJECTED', () => {
      const base = new Date('2026-06-01T12:00:00Z');
      const rejectedDate = calculateKycRetentionDate('REJECTED', base);
      expect(rejectedDate?.toISOString()).toBe(
        new Date(base.getTime() + KYC_RETENTION_DAYS_REJECTED * 24 * 3600 * 1000).toISOString(),
      );
    });

    it('retourne null pour un statut inconnu', () => {
      expect(calculateKycRetentionDate('UNKNOWN')).toBeNull();
    });
  });

  describe('findKycMediaAssetsDueForPurge', () => {
    it('interroge les médias private-kyc expirés non encore purgés', async () => {
      const cutoff = new Date('2026-11-23T12:00:00Z');
      const mockDb = {
        mediaAsset: {
          findMany: vi.fn().mockResolvedValue([{ id: 'media-1', storageKey: 'kyc/p1/front.jpg' }]),
        },
      } as unknown as DbClient;

      const results = await findKycMediaAssetsDueForPurge({ now: cutoff, limit: 20 }, mockDb);

      expect(results).toHaveLength(1);
      expect(mockDb.mediaAsset.findMany).toHaveBeenCalledWith(
        expect.objectContaining({
          where: {
            bucket: 'private-kyc',
            purgeAfter: { lte: cutoff },
            NOT: {
              storageKey: { startsWith: 'purged:' },
            },
          },
          take: 20,
          orderBy: { purgeAfter: 'asc' },
        }),
      );
    });
  });

  describe('markMediaAssetAsPurged', () => {
    it('met à jour storageKey avec prefix purged:, sizeBytes à 0 et vide purgeAfter', async () => {
      const mockDb = {
        mediaAsset: {
          update: vi.fn().mockResolvedValue({ id: 'media-1' }),
        },
      } as unknown as DbClient;

      await markMediaAssetAsPurged('media-1', mockDb);

      expect(mockDb.mediaAsset.update).toHaveBeenCalledWith({
        where: { id: 'media-1' },
        data: {
          storageKey: 'purged:media-1',
          sizeBytes: 0,
          purgeAfter: null,
        },
        select: { id: true },
      });
    });
  });

  describe('scheduleMediaAssetsPurge', () => {
    it('met à jour purgeAfter sur les ids donnés', async () => {
      const purgeDate = new Date('2026-12-23T12:00:00Z');
      const mockDb = {
        mediaAsset: {
          updateMany: vi.fn().mockResolvedValue({ count: 2 }),
        },
      } as unknown as DbClient;

      await scheduleMediaAssetsPurge(['m-1', 'm-2'], purgeDate, mockDb);

      expect(mockDb.mediaAsset.updateMany).toHaveBeenCalledWith({
        where: { id: { in: ['m-1', 'm-2'] } },
        data: { purgeAfter: purgeDate },
      });
    });

    it('ne fait rien si mediaIds est vide', async () => {
      const mockDb = {
        mediaAsset: {
          updateMany: vi.fn(),
        },
      } as unknown as DbClient;

      await scheduleMediaAssetsPurge([], new Date(), mockDb);
      expect(mockDb.mediaAsset.updateMany).not.toHaveBeenCalled();
    });
  });

  describe('reviewVerificationRequest retention scheduling', () => {
    it('programme la purge des documents et définit expiresAt lors de l’approbation', async () => {
      const mockCurrent = {
        id: 'req-1',
        status: 'PENDING',
        providerId: 'prov-1',
        provider: {
          id: 'prov-1',
          verificationStatus: 'PENDING',
          isVerified: false,
          verifiedAt: null,
        },
        documents: [{ mediaId: 'media-front' }, { mediaId: 'media-back' }],
      };

      const mockDb = {
        verificationRequest: {
          findUnique: vi.fn().mockResolvedValue(mockCurrent),
          update: vi.fn().mockImplementation(({ data }) =>
            Promise.resolve({
              id: 'req-1',
              status: data.status,
              rejectionReason: null,
              internalNote: null,
              expiresAt: data.expiresAt,
            }),
          ),
        },
        providerProfile: {
          update: vi.fn().mockResolvedValue({}),
        },
        mediaAsset: {
          updateMany: vi.fn().mockResolvedValue({ count: 2 }),
        },
        auditLog: {
          create: vi.fn().mockResolvedValue({ id: 'audit-1' }),
        },
      } as unknown as DbClient;

      const result = await reviewVerificationRequest(
        {
          requestId: 'req-1',
          reviewerId: 'admin-1',
          status: 'APPROVED',
        },
        mockDb,
      );

      expect(result).not.toBeNull();
      expect(result?.expiresAt).toBeInstanceOf(Date);
      expect(mockDb.verificationRequest.update).toHaveBeenCalledWith(
        expect.objectContaining({
          data: expect.objectContaining({
            expiresAt: expect.any(Date),
          }),
        }),
      );

      expect(mockDb.mediaAsset.updateMany).toHaveBeenCalledWith({
        where: { id: { in: ['media-front', 'media-back'] } },
        data: { purgeAfter: expect.any(Date) },
      });
    });
  });
});
