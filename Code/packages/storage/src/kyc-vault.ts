// BE-30a : Coffre-fort numérique Cloudflare R2 privé pour documents KYC (ADR-002 / INPDP 2004-63).
//
// Règles de sécurité fondamentales :
// 1. Bucket hermétique 'private-kyc' : aucun sous-domaine ni CDN public ne doit pointer dessus.
// 2. Chiffrement systématique au repos SSE-S3 ('AES256') sur les téléversements.
// 3. Upload direct client -> R2 par URL PUT signée (TTL strict 10 min) évitant de saturer l'API (P5).
// 4. Consultation d'examen par les modérateurs via URL GET signée éphémère (TTL strict 5 min max).
import {
  DeleteObjectCommand,
  GetObjectCommand,
  PutObjectCommand,
  ServerSideEncryption,
} from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';

import { getR2Client } from './client.js';
import type { PresignedUpload } from './presign.js';

export const PRIVATE_KYC_BUCKET = 'private-kyc';

/** TTL pour l'upload d'un document d'identité : 10 minutes */
export const KYC_UPLOAD_TTL_SECONDS = 10 * 60;

/** TTL pour l'accès en lecture modérateur/admin : 5 minutes maximum */
export const KYC_READ_TTL_SECONDS = 5 * 60;

/** Durée de rétention des images CIN après approbation : 30 jours (INPDP) */
export const KYC_RETENTION_DAYS_APPROVED = 30;

/** Durée de rétention des images CIN après rejet : 14 jours (délai de contestation) */
export const KYC_RETENTION_DAYS_REJECTED = 14;

/** Rétention par défaut à la soumission (si non traitée) : 365 jours */
export const KYC_RETENTION_DAYS_DEFAULT = 365;

export interface PresignedDownload {
  downloadUrl: string;
  expiresAt: Date;
}

/**
 * Calcule la date limite de conservation (purgeAfter) en fonction de la décision modérateur.
 */
export function calculateKycPurgeDate(
  status: 'APPROVED' | 'REJECTED' | 'MORE_INFO_REQUIRED' | string,
  fromDate: Date = new Date(),
): Date | null {
  const days =
    status === 'APPROVED'
      ? KYC_RETENTION_DAYS_APPROVED
      : status === 'REJECTED'
        ? KYC_RETENTION_DAYS_REJECTED
        : status === 'MORE_INFO_REQUIRED'
          ? KYC_RETENTION_DAYS_APPROVED
          : null;

  if (days === null) return null;
  return new Date(fromDate.getTime() + days * 24 * 60 * 60 * 1000);
}

export function requireKycBucketName(): string {
  return process.env.R2_KYC_BUCKET ?? PRIVATE_KYC_BUCKET;
}

/**
 * Construit la clé de stockage standardisée pour une pièce d'identité.
 * Format : `kyc/${providerId}/${requestId}/${side}.jpg`
 */
export function buildKycStorageKey(
  providerId: string,
  requestId: string,
  side: 'recto' | 'verso' | 'front' | 'back' | string,
): string {
  const normalizedSide = side === 'front' ? 'recto' : side === 'back' ? 'verso' : side;
  return `kyc/${providerId}/${requestId}/${normalizedSide}.jpg`;
}

/**
 * Génère une URL PUT pré-signée vers le bucket privé `private-kyc` avec chiffrement SSE-S3 AES-256.
 * Validité : 10 minutes.
 */
export async function presignKycUpload(
  storageKey: string,
  contentType: string,
): Promise<PresignedUpload> {
  const command = new PutObjectCommand({
    Bucket: requireKycBucketName(),
    Key: storageKey,
    ContentType: contentType,
    ServerSideEncryption: ServerSideEncryption.AES256,
  });

  const uploadUrl = await getSignedUrl(getR2Client(), command, {
    expiresIn: KYC_UPLOAD_TTL_SECONDS,
  });

  return {
    uploadUrl,
    expiresAt: new Date(Date.now() + KYC_UPLOAD_TTL_SECONDS * 1000),
  };
}

/**
 * Génère une URL GET pré-signée éphémère vers le bucket privé pour la revue d'identité en modération.
 * Validité : 5 minutes maximum.
 */
export async function presignKycRead(storageKey: string): Promise<PresignedDownload> {
  const command = new GetObjectCommand({
    Bucket: requireKycBucketName(),
    Key: storageKey,
  });

  const downloadUrl = await getSignedUrl(getR2Client(), command, {
    expiresIn: KYC_READ_TTL_SECONDS,
  });

  return {
    downloadUrl,
    expiresAt: new Date(Date.now() + KYC_READ_TTL_SECONDS * 1000),
  };
}

/**
 * Récupère le tampon binaire d'un document KYC depuis le bucket privé (utilisé pour les contrôles internes).
 */
export async function getKycObjectBuffer(storageKey: string): Promise<Buffer> {
  const response = await getR2Client().send(
    new GetObjectCommand({
      Bucket: requireKycBucketName(),
      Key: storageKey,
    }),
  );

  if (!response.Body) {
    throw new Error(`Objet KYC vide ou introuvable : ${storageKey}`);
  }

  const bytes = await response.Body.transformToByteArray();
  return Buffer.from(bytes);
}

/**
 * Supprime définitivement un document KYC du bucket privé (purge après expiration ou refus).
 */
export async function deleteKycObject(storageKey: string): Promise<void> {
  await getR2Client().send(
    new DeleteObjectCommand({
      Bucket: requireKycBucketName(),
      Key: storageKey,
    }),
  );
}
