// BE-30b : Référentiel pour les demandes de vérification d'identité (KYC).
// Gère la persistance de `VerificationRequest` et `VerificationDocument` sous Prisma.
import { prisma } from '../client.js';
import { buildKeysetOrderBy, buildKeysetWhere, buildPage, resolveLimit } from '../pagination.js';
import type { PaginatedResult } from '../pagination.js';
import type { DbClient, VerificationDocumentType, VerificationStatus } from '../types.js';
import { createAuditLog } from './audit-log.repository.js';

export interface VerificationDocumentRecord {
  id: string;
  requestId: string;
  mediaId: string;
  type: VerificationDocumentType;
  createdAt: Date;
}

export interface VerificationRequestRecord {
  id: string;
  providerId: string;
  status: VerificationStatus;
  cinNumberHash: string | null;
  cinNumberCipher: string | null;
  fullNameOnId: string | null;
  submittedAt: Date;
  reviewedAt: Date | null;
  reviewedById: string | null;
  rejectionReason: string | null;
  internalNote: string | null;
  expiresAt: Date | null;
}

export interface VerificationRequestWithDocuments extends VerificationRequestRecord {
  documents: VerificationDocumentRecord[];
}

export interface CreateVerificationRequestInput {
  providerId: string;
  cinNumberHash?: string;
  cinNumberCipher?: string;
  fullNameOnId?: string;
  status?: VerificationStatus;
}

export interface AddVerificationDocumentInput {
  requestId: string;
  mediaId: string;
  type: VerificationDocumentType;
}

export async function createVerificationRequest(
  input: CreateVerificationRequestInput,
  db: DbClient = prisma,
): Promise<VerificationRequestRecord> {
  return db.verificationRequest.create({
    data: {
      providerId: input.providerId,
      cinNumberHash: input.cinNumberHash,
      cinNumberCipher: input.cinNumberCipher,
      fullNameOnId: input.fullNameOnId,
      status: input.status ?? 'PENDING',
    },
  });
}

export async function addVerificationDocument(
  input: AddVerificationDocumentInput,
  db: DbClient = prisma,
): Promise<VerificationDocumentRecord> {
  return db.verificationDocument.create({
    data: {
      requestId: input.requestId,
      mediaId: input.mediaId,
      type: input.type,
    },
  });
}

export async function findVerificationRequestById(
  id: string,
  db: DbClient = prisma,
): Promise<VerificationRequestWithDocuments | null> {
  return db.verificationRequest.findUnique({
    where: { id },
    include: {
      documents: {
        orderBy: { createdAt: 'asc' },
      },
    },
  });
}

export async function findLatestVerificationRequestByProviderId(
  providerId: string,
  db: DbClient = prisma,
): Promise<VerificationRequestWithDocuments | null> {
  return db.verificationRequest.findFirst({
    where: { providerId },
    orderBy: { submittedAt: 'desc' },
    include: {
      documents: {
        orderBy: { createdAt: 'asc' },
      },
    },
  });
}

export async function findPendingVerificationRequestByProviderId(
  providerId: string,
  db: DbClient = prisma,
): Promise<VerificationRequestRecord | null> {
  return db.verificationRequest.findFirst({
    where: {
      providerId,
      status: 'PENDING',
    },
    orderBy: { submittedAt: 'desc' },
  });
}

export async function findVerificationRequestByCinHash(
  cinNumberHash: string,
  db: DbClient = prisma,
): Promise<VerificationRequestRecord | null> {
  return db.verificationRequest.findFirst({
    where: { cinNumberHash },
  });
}

export async function updateProviderVerificationStatus(
  providerId: string,
  status: VerificationStatus,
  db: DbClient = prisma,
): Promise<void> {
  await db.providerProfile.update({
    where: { id: providerId },
    data: {
      verificationStatus: status,
      isVerified: status === 'APPROVED',
      verifiedAt: status === 'APPROVED' ? new Date() : undefined,
    },
  });
}

// =====================================================================
// BE-31 : Administration KYC (file de vérification, audit, revue)
// =====================================================================

export class InvalidStatusTransitionError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'InvalidStatusTransitionError';
  }
}

export interface ListVerificationRequestsParams {
  status?: VerificationStatus;
  limit?: number;
  cursor?: string;
  orderBy?: 'asc' | 'desc';
}

export interface AdminVerificationListItem {
  id: string;
  providerId: string;
  provider: {
    id: string;
    businessName: string;
    slug: string;
    baseGovernorateId: string;
    isVerified: boolean;
  };
  fullNameOnId: string | null;
  status: VerificationStatus;
  submittedAt: Date;
  reviewedAt: Date | null;
  reviewedBy: {
    id: string;
    phone: string;
  } | null;
  documentsCount: number;
  documents: Array<{
    id: string;
    type: VerificationDocumentType;
  }>;
}

export async function countPendingVerificationRequests(db: DbClient = prisma): Promise<number> {
  return db.verificationRequest.count({
    where: { status: 'PENDING' },
  });
}

export async function listVerificationRequestsForAdmin(
  params: ListVerificationRequestsParams = {},
  db: DbClient = prisma,
): Promise<PaginatedResult<AdminVerificationListItem>> {
  const limit = resolveLimit(params.limit);
  const sortDir = params.orderBy ?? 'asc';
  const keysetWhere = buildKeysetWhere('submittedAt', sortDir, params.cursor);
  const baseWhere = params.status ? { status: params.status } : {};

  const rows = await db.verificationRequest.findMany({
    where: keysetWhere ? { ...baseWhere, ...keysetWhere } : baseWhere,
    select: {
      id: true,
      providerId: true,
      fullNameOnId: true,
      status: true,
      submittedAt: true,
      reviewedAt: true,
      provider: {
        select: {
          id: true,
          businessName: true,
          slug: true,
          baseGovernorateId: true,
          isVerified: true,
        },
      },
      reviewedBy: {
        select: {
          id: true,
          phone: true,
        },
      },
      documents: {
        select: {
          id: true,
          type: true,
        },
      },
    },
    orderBy: buildKeysetOrderBy('submittedAt', sortDir),
    take: limit + 1,
  });

  const page = buildPage(rows, limit, (row) => row.submittedAt.toISOString());

  return {
    items: page.items.map((row) => ({
      ...row,
      documentsCount: row.documents.length,
    })),
    nextCursor: page.nextCursor,
  };
}

export interface AdminVerificationDetailRecord {
  id: string;
  providerId: string;
  provider: {
    id: string;
    businessName: string;
    slug: string;
    headline: string | null;
    baseGovernorateId: string;
    isVerified: boolean;
    verificationStatus: VerificationStatus;
    user: {
      id: string;
      phone: string;
    };
  };
  fullNameOnId: string | null;
  status: VerificationStatus;
  submittedAt: Date;
  reviewedAt: Date | null;
  reviewedBy: {
    id: string;
    phone: string;
  } | null;
  rejectionReason: string | null;
  internalNote: string | null;
  documents: Array<{
    id: string;
    type: VerificationDocumentType;
    mediaId: string;
    media: {
      storageKey: string;
    };
  }>;
}

export async function findVerificationRequestDetailsForAdmin(
  id: string,
  db: DbClient = prisma,
): Promise<AdminVerificationDetailRecord | null> {
  return db.verificationRequest.findUnique({
    where: { id },
    select: {
      id: true,
      providerId: true,
      fullNameOnId: true,
      status: true,
      submittedAt: true,
      reviewedAt: true,
      rejectionReason: true,
      internalNote: true,
      provider: {
        select: {
          id: true,
          businessName: true,
          slug: true,
          headline: true,
          baseGovernorateId: true,
          isVerified: true,
          verificationStatus: true,
          user: {
            select: {
              id: true,
              phone: true,
            },
          },
        },
      },
      reviewedBy: {
        select: {
          id: true,
          phone: true,
        },
      },
      documents: {
        select: {
          id: true,
          type: true,
          mediaId: true,
          media: {
            select: {
              storageKey: true,
            },
          },
        },
      },
    },
  });
}

export interface ReviewVerificationRequestInput {
  requestId: string;
  reviewerId: string;
  status: 'APPROVED' | 'REJECTED' | 'MORE_INFO_REQUIRED';
  rejectionReason?: string | null;
  internalNote?: string | null;
  actorIpHash?: string;
  actorUserAgent?: string;
}

export interface ReviewVerificationResult {
  id: string;
  status: VerificationStatus;
  reviewedAt: Date;
  reviewedById: string;
  isVerified: boolean;
  rejectionReason: string | null;
  internalNote: string | null;
}

async function executeReviewVerificationRequest(
  input: ReviewVerificationRequestInput,
  tx: DbClient,
): Promise<ReviewVerificationResult | null> {
  const current = await tx.verificationRequest.findUnique({
    where: { id: input.requestId },
    include: { provider: true },
  });

  if (!current) {
    return null;
  }

  if (current.status !== 'PENDING') {
    throw new InvalidStatusTransitionError(
      `La demande de vérification ${input.requestId} est au statut ${current.status} et ne peut plus être modifiée.`,
    );
  }

  const reviewedAt = new Date();
  const isApproved = input.status === 'APPROVED';

  const updated = await tx.verificationRequest.update({
    where: { id: input.requestId },
    data: {
      status: input.status,
      reviewedAt,
      reviewedById: input.reviewerId,
      rejectionReason: input.rejectionReason ?? null,
      internalNote: input.internalNote ?? null,
    },
  });

  await tx.providerProfile.update({
    where: { id: current.providerId },
    data: {
      verificationStatus: input.status,
      isVerified: isApproved,
      verifiedAt: isApproved ? reviewedAt : current.provider.verifiedAt,
    },
  });

  const action =
    input.status === 'APPROVED'
      ? 'provider.verify.approve'
      : input.status === 'REJECTED'
        ? 'provider.verify.reject'
        : 'provider.verify.more_info';

  await createAuditLog(
    {
      actorId: input.reviewerId,
      action,
      entityType: 'VerificationRequest',
      entityId: input.requestId,
      before: {
        status: current.status,
        providerVerificationStatus: current.provider.verificationStatus,
        providerIsVerified: current.provider.isVerified,
      },
      after: {
        status: input.status,
        rejectionReason: input.rejectionReason ?? null,
        internalNote: input.internalNote ?? null,
        providerVerificationStatus: input.status,
        providerIsVerified: isApproved,
      },
      ipHash: input.actorIpHash,
      userAgent: input.actorUserAgent,
    },
    tx,
  );

  return {
    id: updated.id,
    status: updated.status,
    reviewedAt,
    reviewedById: input.reviewerId,
    isVerified: isApproved,
    rejectionReason: updated.rejectionReason,
    internalNote: updated.internalNote,
  };
}

export async function reviewVerificationRequest(
  input: ReviewVerificationRequestInput,
  db: DbClient = prisma,
): Promise<ReviewVerificationResult | null> {
  if ('$transaction' in db && typeof db.$transaction === 'function') {
    return (db as typeof prisma).$transaction((tx) => executeReviewVerificationRequest(input, tx));
  }
  return executeReviewVerificationRequest(input, db);
}

export interface LogVerificationViewInput {
  requestId: string;
  actorId: string;
  documentTypes?: string[];
  ipHash?: string;
  userAgent?: string;
}

export async function logVerificationView(
  input: LogVerificationViewInput,
  db: DbClient = prisma,
): Promise<void> {
  await createAuditLog(
    {
      actorId: input.actorId,
      action: 'provider.verify.view',
      entityType: 'VerificationRequest',
      entityId: input.requestId,
      after: {
        documentTypes: input.documentTypes ?? [],
      },
      ipHash: input.ipHash,
      userAgent: input.userAgent,
    },
    db,
  );
}
