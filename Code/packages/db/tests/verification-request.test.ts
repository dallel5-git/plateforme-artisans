import { describe, expect, it, vi } from 'vitest';
import type { DbClient } from '../src/types.js';
import {
  InvalidStatusTransitionError,
  countPendingVerificationRequests,
  findVerificationRequestDetailsForAdmin,
  listVerificationRequestsForAdmin,
  logVerificationView,
  reviewVerificationRequest,
} from '../src/repositories/verification-request.repository.js';

describe('verification-request.repository (BE-31)', () => {
  it('countPendingVerificationRequests compte les demandes au statut PENDING', async () => {
    const mockDb = {
      verificationRequest: {
        count: vi.fn().mockResolvedValue(5),
      },
    } as unknown as DbClient;

    const count = await countPendingVerificationRequests(mockDb);
    expect(count).toBe(5);
    expect(mockDb.verificationRequest.count).toHaveBeenCalledWith({
      where: { status: 'PENDING' },
    });
  });

  it('listVerificationRequestsForAdmin retourne les items avec documentsCount et pagination', async () => {
    const date1 = new Date('2026-11-20T10:00:00Z');
    const mockRows = [
      {
        id: '11111111-1111-1111-1111-111111111111',
        providerId: '22222222-2222-2222-2222-222222222222',
        fullNameOnId: 'Ali Ben Salah',
        status: 'PENDING',
        submittedAt: date1,
        reviewedAt: null,
        provider: {
          id: '22222222-2222-2222-2222-222222222222',
          businessName: 'Plomberie Ali',
          slug: 'plomberie-ali',
          baseGovernorateId: 'tunis-gov-id',
          isVerified: false,
        },
        reviewedBy: null,
        documents: [
          { id: 'doc-1', type: 'CIN_FRONT' },
          { id: 'doc-2', type: 'CIN_BACK' },
        ],
      },
    ];

    const mockDb = {
      verificationRequest: {
        findMany: vi.fn().mockResolvedValue(mockRows),
      },
    } as unknown as DbClient;

    const result = await listVerificationRequestsForAdmin({ status: 'PENDING', limit: 10 }, mockDb);

    expect(result.items).toHaveLength(1);
    expect(result.items[0]).toEqual({
      ...mockRows[0],
      documentsCount: 2,
    });
    expect(result.nextCursor).toBeNull();
    expect(mockDb.verificationRequest.findMany).toHaveBeenCalledWith(
      expect.objectContaining({
        where: { status: 'PENDING' },
        take: 11,
      }),
    );
  });

  it('findVerificationRequestDetailsForAdmin retourne le détail complet avec documents', async () => {
    const mockDetail = {
      id: 'req-1',
      providerId: 'prov-1',
      fullNameOnId: 'Ali Ben Salah',
      status: 'PENDING',
      submittedAt: new Date('2026-11-20T10:00:00Z'),
      reviewedAt: null,
      rejectionReason: null,
      internalNote: null,
      provider: {
        id: 'prov-1',
        businessName: 'Plomberie Ali',
        slug: 'plomberie-ali',
        headline: 'Plombier certifié',
        baseGovernorateId: 'tunis-id',
        isVerified: false,
        verificationStatus: 'PENDING',
        user: {
          id: 'user-1',
          phone: '+21698000001',
        },
      },
      reviewedBy: null,
      documents: [
        {
          id: 'doc-1',
          type: 'CIN_FRONT',
          mediaId: 'media-1',
          media: { storageKey: 'kyc/prov-1/doc-1.jpg' },
        },
      ],
    };

    const mockDb = {
      verificationRequest: {
        findUnique: vi.fn().mockResolvedValue(mockDetail),
      },
    } as unknown as DbClient;

    const result = await findVerificationRequestDetailsForAdmin('req-1', mockDb);
    expect(result).toEqual(mockDetail);
    expect(mockDb.verificationRequest.findUnique).toHaveBeenCalledWith(
      expect.objectContaining({
        where: { id: 'req-1' },
      }),
    );
  });

  describe('reviewVerificationRequest', () => {
    it('renvoie null si la requête n’existe pas', async () => {
      const mockDb = {
        verificationRequest: {
          findUnique: vi.fn().mockResolvedValue(null),
        },
      } as unknown as DbClient;

      const result = await reviewVerificationRequest(
        {
          requestId: 'not-found',
          reviewerId: 'admin-1',
          status: 'APPROVED',
        },
        mockDb,
      );

      expect(result).toBeNull();
    });

    it('rejette avec InvalidStatusTransitionError si le statut n’est pas PENDING', async () => {
      const mockDb = {
        verificationRequest: {
          findUnique: vi.fn().mockResolvedValue({
            id: 'req-1',
            status: 'APPROVED',
            provider: { id: 'prov-1' },
          }),
        },
      } as unknown as DbClient;

      await expect(
        reviewVerificationRequest(
          {
            requestId: 'req-1',
            reviewerId: 'admin-1',
            status: 'REJECTED',
            rejectionReason: 'Document flou',
          },
          mockDb,
        ),
      ).rejects.toThrow(InvalidStatusTransitionError);
    });

    it('applique la transition APPROVED : met à jour le profil et journalise l’audit', async () => {
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
      };

      const mockDb = {
        verificationRequest: {
          findUnique: vi.fn().mockResolvedValue(mockCurrent),
          update: vi.fn().mockResolvedValue({
            id: 'req-1',
            status: 'APPROVED',
            rejectionReason: null,
            internalNote: 'Approuvé conforme',
          }),
        },
        providerProfile: {
          update: vi.fn().mockResolvedValue({}),
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
          internalNote: 'Approuvé conforme',
          actorIpHash: 'ip-hash',
          actorUserAgent: 'agent-1',
        },
        mockDb,
      );

      expect(result).toMatchObject({
        id: 'req-1',
        status: 'APPROVED',
        reviewedById: 'admin-1',
        isVerified: true,
        internalNote: 'Approuvé conforme',
      });

      expect(mockDb.providerProfile.update).toHaveBeenCalledWith({
        where: { id: 'prov-1' },
        data: expect.objectContaining({
          verificationStatus: 'APPROVED',
          isVerified: true,
        }),
      });

      expect(mockDb.auditLog.create).toHaveBeenCalledWith(
        expect.objectContaining({
          data: expect.objectContaining({
            actorId: 'admin-1',
            action: 'provider.verify.approve',
            entityType: 'VerificationRequest',
            entityId: 'req-1',
          }),
        }),
      );
    });

    it('applique la transition REJECTED : met à jour le profil et journalise provider.verify.reject', async () => {
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
      };

      const mockDb = {
        verificationRequest: {
          findUnique: vi.fn().mockResolvedValue(mockCurrent),
          update: vi.fn().mockResolvedValue({
            id: 'req-1',
            status: 'REJECTED',
            rejectionReason: 'CIN illisible et périmée',
            internalNote: 'Rejet',
          }),
        },
        providerProfile: {
          update: vi.fn().mockResolvedValue({}),
        },
        auditLog: {
          create: vi.fn().mockResolvedValue({ id: 'audit-2' }),
        },
      } as unknown as DbClient;

      const result = await reviewVerificationRequest(
        {
          requestId: 'req-1',
          reviewerId: 'admin-1',
          status: 'REJECTED',
          rejectionReason: 'CIN illisible et périmée',
          internalNote: 'Rejet',
        },
        mockDb,
      );

      expect(result).toMatchObject({
        id: 'req-1',
        status: 'REJECTED',
        reviewedById: 'admin-1',
        isVerified: false,
        rejectionReason: 'CIN illisible et périmée',
      });

      expect(mockDb.providerProfile.update).toHaveBeenCalledWith({
        where: { id: 'prov-1' },
        data: expect.objectContaining({
          verificationStatus: 'REJECTED',
          isVerified: false,
        }),
      });

      expect(mockDb.auditLog.create).toHaveBeenCalledWith(
        expect.objectContaining({
          data: expect.objectContaining({
            action: 'provider.verify.reject',
          }),
        }),
      );
    });
  });

  it('logVerificationView journalise l’accès aux documents KYC dans AuditLog', async () => {
    const mockDb = {
      auditLog: {
        create: vi.fn().mockResolvedValue({ id: 'audit-view-1' }),
      },
    } as unknown as DbClient;

    await logVerificationView(
      {
        requestId: 'req-1',
        actorId: 'admin-1',
        documentTypes: ['CIN_FRONT', 'CIN_BACK'],
        ipHash: 'ip-hash',
        userAgent: 'Firefox',
      },
      mockDb,
    );

    expect(mockDb.auditLog.create).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({
          actorId: 'admin-1',
          action: 'provider.verify.view',
          entityType: 'VerificationRequest',
          entityId: 'req-1',
          after: { documentTypes: ['CIN_FRONT', 'CIN_BACK'] },
          ipHash: 'ip-hash',
          userAgent: 'Firefox',
        }),
      }),
    );
  });
});
