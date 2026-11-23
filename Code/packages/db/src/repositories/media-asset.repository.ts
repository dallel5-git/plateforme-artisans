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
  purgeAfter: true,
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
  purgeAfter?: Date | null;
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

export async function findMediaAssetById(
  id: string,
  db: DbClient = prisma,
): Promise<MediaAsset | null> {
  return db.mediaAsset.findUnique({ where: { id }, select });
}

/**
 * BE-17 : hydratation par lots pour la galerie de la fiche publique (évite le N+1 de
 * `findMediaAssetById` par `PortfolioItem`). Filtre `moderationStatus: 'APPROVED'` — distinct de
 * `PortfolioItem.status` (déjà filtré côté `listPortfolioItems`) : un média déclassé après coup
 * ne doit pas fuiter dans la galerie même si son `PortfolioItem` reste `APPROVED`.
 */
export async function findMediaAssetsByIds(
  ids: string[],
  db: DbClient = prisma,
): Promise<MediaAsset[]> {
  if (ids.length === 0) return [];
  return db.mediaAsset.findMany({
    where: { id: { in: ids }, moderationStatus: 'APPROVED' },
    select,
  });
}

export async function approveMediaAsset(id: string, db: DbClient = prisma): Promise<void> {
  await db.mediaAsset.update({
    where: { id },
    data: { moderationStatus: 'APPROVED' },
    select: { id: true },
  });
}

export interface FinalizeMediaAssetInput {
  publicUrl: string;
  width: number;
  height: number;
}

// BE-20c : la variante `full` téléversée sur R2 remplace l'original comme représentation
// publique du `MediaAsset` (voir plan BE-20 : un seul `storageKey`/`publicUrl` par ligne, pas de
// colonnes de variantes). `moderationStatus: 'APPROVED'` direct — aucune file de modération
// n'existe encore (BE-31/BE-40, hors périmètre S1) ; `PENDING` par défaut rendrait la photo
// invisible pour toujours (`findMediaAssetsByIds` filtre `APPROVED`).
export async function finalizeMediaAsset(
  id: string,
  input: FinalizeMediaAssetInput,
  db: DbClient = prisma,
): Promise<void> {
  await db.mediaAsset.update({
    where: { id },
    data: { ...input, moderationStatus: 'APPROVED' },
    select: { id: true },
  });
}

// =====================================================================
// BE-30c : Purge automatique des pièces d'identité (INPDP)
// =====================================================================

/**
 * Recherche les médias du bucket privé `private-kyc` dont la date de rétention `purgeAfter` est dépassée.
 */
export async function findKycMediaAssetsDueForPurge(
  options: { now?: Date; limit?: number } = {},
  db: DbClient = prisma,
): Promise<MediaAsset[]> {
  const cutoff = options.now ?? new Date();
  const limit = options.limit ?? 50;

  return db.mediaAsset.findMany({
    where: {
      bucket: 'private-kyc',
      purgeAfter: { lte: cutoff },
      NOT: {
        storageKey: { startsWith: 'purged:' },
      },
    },
    select,
    take: limit,
    orderBy: { purgeAfter: 'asc' },
  });
}

/**
 * Marque un MediaAsset comme purgé en base :
 * Réinitialise `storageKey` avec un identifiant de purge, passe la taille à 0 et vide `purgeAfter`.
 */
export async function markMediaAssetAsPurged(id: string, db: DbClient = prisma): Promise<void> {
  await db.mediaAsset.update({
    where: { id },
    data: {
      storageKey: `purged:${id}`,
      sizeBytes: 0,
      purgeAfter: null,
    },
    select: { id: true },
  });
}

/**
 * Met à jour la date de rétention `purgeAfter` pour un ensemble de médias.
 */
export async function scheduleMediaAssetsPurge(
  mediaIds: string[],
  purgeAfter: Date,
  db: DbClient = prisma,
): Promise<void> {
  if (mediaIds.length === 0) return;
  await db.mediaAsset.updateMany({
    where: { id: { in: mediaIds } },
    data: { purgeAfter },
  });
}
