// BE-05 : agrégat MediaAsset. Le bucket `private-kyc` n'a pas d'URL publique persistée
// (CLAUDE.md §3.1 : URL signée 5 min, générée à la demande par packages/storage — hors
// périmètre BE-05) ; ce repository ne fait que stocker/lire les métadonnées.
import { prisma } from '../client.js';
import type { DbClient, MediaType, ModerationStatus } from '../types.js';

const select = {
  id: true,
  uploadedById: true,
  bucket: true,
  storageKey: true,
  publicUrl: true,
  type: true,
  mimeType: true,
  sizeBytes: true,
  width: true,
  height: true,
  blurhash: true,
  isPrivate: true,
  moderationStatus: true,
  createdAt: true,
} as const;

export interface MediaAsset {
  id: string;
  uploadedById: string | null;
  bucket: string;
  storageKey: string;
  publicUrl: string | null;
  type: MediaType;
  mimeType: string;
  sizeBytes: number;
  width: number | null;
  height: number | null;
  blurhash: string | null;
  isPrivate: boolean;
  moderationStatus: ModerationStatus;
  createdAt: Date;
}

export interface CreateMediaAssetInput {
  uploadedById?: string;
  bucket: string;
  storageKey: string;
  publicUrl?: string;
  type: MediaType;
  mimeType: string;
  sizeBytes: number;
  width?: number;
  height?: number;
  blurhash?: string;
  checksumSha256?: string;
  isPrivate?: boolean;
  purgeAfter?: Date;
}

export async function createMediaAsset(
  input: CreateMediaAssetInput,
  db: DbClient = prisma,
): Promise<MediaAsset> {
  return db.mediaAsset.create({ data: input, select });
}

export async function findMediaAssetById(id: string, db: DbClient = prisma): Promise<MediaAsset | null> {
  return db.mediaAsset.findUnique({ where: { id }, select });
}

export async function approveMediaAsset(id: string, db: DbClient = prisma): Promise<void> {
  await db.mediaAsset.update({
    where: { id },
    data: { moderationStatus: 'APPROVED' },
    select: { id: true },
  });
}
