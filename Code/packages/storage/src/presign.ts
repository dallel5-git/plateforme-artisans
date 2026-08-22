// BE-20 : URL PUT pré-signée pour que le client téléverse directement vers R2 — la bande
// passante de l'upload ne traverse jamais Fastify (P5, low-bandwidth-first). Bucket public
// uniquement : le bucket `private-kyc` (URL signée 5 min, chiffrement, journal d'accès) est
// `kyc-vault.ts`, hors périmètre BE-20.
import { PutObjectCommand } from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';

import { getR2Client, requirePublicBucketName } from './client.js';

export const PRESIGN_TTL_SECONDS = 10 * 60;

export interface PresignedUpload {
  uploadUrl: string;
  expiresAt: Date;
}

export async function presignPublicUpload(
  storageKey: string,
  contentType: string,
): Promise<PresignedUpload> {
  const command = new PutObjectCommand({
    Bucket: requirePublicBucketName(),
    Key: storageKey,
    ContentType: contentType,
  });

  const uploadUrl = await getSignedUrl(getR2Client(), command, {
    expiresIn: PRESIGN_TTL_SECONDS,
  });

  return { uploadUrl, expiresAt: new Date(Date.now() + PRESIGN_TTL_SECONDS * 1000) };
}

export function buildPublicUrl(storageKey: string): string {
  const base = process.env.R2_PUBLIC_BASE_URL;
  if (!base) {
    throw new Error("Variable d'environnement manquante : R2_PUBLIC_BASE_URL");
  }
  return `${base.replace(/\/$/, '')}/${storageKey}`;
}
