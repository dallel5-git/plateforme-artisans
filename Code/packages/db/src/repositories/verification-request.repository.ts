// BE-30b : Référentiel pour les demandes de vérification d'identité (KYC).
// Gère la persistance de `VerificationRequest` et `VerificationDocument` sous Prisma.
import { prisma } from '../client.js';
import type { DbClient, VerificationDocumentType, VerificationStatus } from '../types.js';

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
