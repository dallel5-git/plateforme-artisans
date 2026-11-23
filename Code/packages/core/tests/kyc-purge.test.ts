import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { DbClient, MediaAsset } from '@repo/db';
import * as dbModule from '@repo/db';
import { purgeExpiredKycMedia } from '../src/security/kyc-purge.js';

vi.mock('@repo/db', async (importOriginal) => {
  const actual = await importOriginal<typeof import('@repo/db')>();
  return {
    ...actual,
    findKycMediaAssetsDueForPurge: vi.fn(),
    markMediaAssetAsPurged: vi.fn(),
    createAuditLog: vi.fn(),
  };
});

describe('purgeExpiredKycMedia (@repo/core BE-30c)', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });
  it('purge les médias expirés avec succès : R2 delete, DB mark purged, AuditLog', async () => {
    const cutoff = new Date('2026-11-23T12:00:00Z');
    const mockAssets: MediaAsset[] = [
      {
        id: '11111111-1111-4111-8111-111111111111',
        uploadedById: 'user-1',
        bucket: 'private-kyc',
        storageKey: 'kyc/p1/cin-front.jpg',
        publicUrl: null,
        type: 'IMAGE',
        mimeType: 'image/jpeg',
        sizeBytes: 204800,
        width: 1200,
        height: 800,
        blurhash: null,
        isPrivate: true,
        moderationStatus: 'APPROVED',
        purgeAfter: new Date('2026-11-20T12:00:00Z'),
        createdAt: new Date('2026-10-20T12:00:00Z'),
      },
      {
        id: '22222222-2222-4222-8222-222222222222',
        uploadedById: 'user-1',
        bucket: 'private-kyc',
        storageKey: 'kyc/p1/cin-back.jpg',
        publicUrl: null,
        type: 'IMAGE',
        mimeType: 'image/jpeg',
        sizeBytes: 198000,
        width: 1200,
        height: 800,
        blurhash: null,
        isPrivate: true,
        moderationStatus: 'APPROVED',
        purgeAfter: new Date('2026-11-20T12:00:00Z'),
        createdAt: new Date('2026-10-20T12:00:00Z'),
      },
    ];

    vi.mocked(dbModule.findKycMediaAssetsDueForPurge).mockResolvedValue(mockAssets);
    vi.mocked(dbModule.markMediaAssetAsPurged).mockResolvedValue(undefined);
    vi.mocked(dbModule.createAuditLog).mockResolvedValue(undefined);

    const deleteFromStorage = vi.fn().mockResolvedValue(undefined);
    const mockDb = {} as DbClient;

    const result = await purgeExpiredKycMedia({
      now: cutoff,
      limit: 10,
      deleteFromStorage,
      db: mockDb,
    });

    expect(result).toEqual({
      totalProcessed: 2,
      purgedCount: 2,
      skippedCount: 0,
      errors: [],
    });

    expect(dbModule.findKycMediaAssetsDueForPurge).toHaveBeenCalledWith(
      { now: cutoff, limit: 10 },
      mockDb,
    );

    // Vérification appel deleteFromStorage pour chaque clé
    expect(deleteFromStorage).toHaveBeenCalledTimes(2);
    expect(deleteFromStorage).toHaveBeenNthCalledWith(1, 'kyc/p1/cin-front.jpg');
    expect(deleteFromStorage).toHaveBeenNthCalledWith(2, 'kyc/p1/cin-back.jpg');

    // Vérification markMediaAssetAsPurged
    expect(dbModule.markMediaAssetAsPurged).toHaveBeenCalledTimes(2);
    expect(dbModule.markMediaAssetAsPurged).toHaveBeenNthCalledWith(
      1,
      '11111111-1111-4111-8111-111111111111',
      mockDb,
    );
    expect(dbModule.markMediaAssetAsPurged).toHaveBeenNthCalledWith(
      2,
      '22222222-2222-4222-8222-222222222222',
      mockDb,
    );

    // Vérification AuditLog
    expect(dbModule.createAuditLog).toHaveBeenCalledTimes(2);
    expect(dbModule.createAuditLog).toHaveBeenCalledWith(
      expect.objectContaining({
        action: 'kyc.media.purge',
        entityType: 'MediaAsset',
        entityId: '11111111-1111-4111-8111-111111111111',
        before: expect.objectContaining({
          storageKey: 'kyc/p1/cin-front.jpg',
          sizeBytes: 204800,
        }),
        after: expect.objectContaining({
          storageKey: 'purged:11111111-1111-4111-8111-111111111111',
          sizeBytes: 0,
          purgeAfter: null,
        }),
      }),
      mockDb,
    );
  });

  it('ignore les médias dont la storageKey est déjà préfixée par purged:', async () => {
    const mockAssets: MediaAsset[] = [
      {
        id: '33333333-3333-4333-8333-333333333333',
        uploadedById: 'user-1',
        bucket: 'private-kyc',
        storageKey: 'purged:33333333-3333-4333-8333-333333333333',
        publicUrl: null,
        type: 'IMAGE',
        mimeType: 'image/jpeg',
        sizeBytes: 0,
        width: null,
        height: null,
        blurhash: null,
        isPrivate: true,
        moderationStatus: 'APPROVED',
        purgeAfter: null,
        createdAt: new Date('2026-10-20T12:00:00Z'),
      },
    ];

    vi.mocked(dbModule.findKycMediaAssetsDueForPurge).mockResolvedValue(mockAssets);
    const deleteFromStorage = vi.fn();

    const result = await purgeExpiredKycMedia({
      deleteFromStorage,
    });

    expect(result).toEqual({
      totalProcessed: 1,
      purgedCount: 0,
      skippedCount: 1,
      errors: [],
    });

    expect(deleteFromStorage).not.toHaveBeenCalled();
    expect(dbModule.markMediaAssetAsPurged).not.toHaveBeenCalled();
  });

  it('capture les erreurs de suppression physique sans neutraliser en base', async () => {
    const mockAssets: MediaAsset[] = [
      {
        id: '44444444-4444-4444-8444-444444444444',
        uploadedById: 'user-1',
        bucket: 'private-kyc',
        storageKey: 'kyc/p1/failed.jpg',
        publicUrl: null,
        type: 'IMAGE',
        mimeType: 'image/jpeg',
        sizeBytes: 150000,
        width: 1000,
        height: 600,
        blurhash: null,
        isPrivate: true,
        moderationStatus: 'REJECTED',
        purgeAfter: new Date('2026-11-20T12:00:00Z'),
        createdAt: new Date('2026-10-20T12:00:00Z'),
      },
      {
        id: '55555555-5555-4555-8555-555555555555',
        uploadedById: 'user-1',
        bucket: 'private-kyc',
        storageKey: 'kyc/p1/succeeded.jpg',
        publicUrl: null,
        type: 'IMAGE',
        mimeType: 'image/jpeg',
        sizeBytes: 160000,
        width: 1000,
        height: 600,
        blurhash: null,
        isPrivate: true,
        moderationStatus: 'REJECTED',
        purgeAfter: new Date('2026-11-20T12:00:00Z'),
        createdAt: new Date('2026-10-20T12:00:00Z'),
      },
    ];

    vi.mocked(dbModule.findKycMediaAssetsDueForPurge).mockResolvedValue(mockAssets);
    vi.mocked(dbModule.markMediaAssetAsPurged).mockResolvedValue(undefined);
    vi.mocked(dbModule.createAuditLog).mockResolvedValue(undefined);

    const deleteFromStorage = vi.fn().mockImplementation((key: string) => {
      if (key === 'kyc/p1/failed.jpg') {
        return Promise.reject(new Error('R2 S3 connection timeout'));
      }
      return Promise.resolve();
    });

    const result = await purgeExpiredKycMedia({
      deleteFromStorage,
    });

    expect(result.totalProcessed).toBe(2);
    expect(result.purgedCount).toBe(1);
    expect(result.skippedCount).toBe(0);
    expect(result.errors).toHaveLength(1);
    expect(result.errors[0]).toEqual({
      mediaId: '44444444-4444-4444-8444-444444444444',
      storageKey: 'kyc/p1/failed.jpg',
      error: 'R2 S3 connection timeout',
    });

    // markMediaAssetAsPurged ne doit PAS avoir été appelé pour le média en erreur
    expect(dbModule.markMediaAssetAsPurged).not.toHaveBeenCalledWith(
      '44444444-4444-4444-8444-444444444444',
      expect.anything(),
    );
    // Mais doit avoir été appelé pour le média réussi
    expect(dbModule.markMediaAssetAsPurged).toHaveBeenCalledWith(
      '55555555-5555-4555-8555-555555555555',
      undefined,
    );
  });
});
