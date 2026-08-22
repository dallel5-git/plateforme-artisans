import { randomUUID } from 'node:crypto';

import { MEDIA_TOO_LARGE, MEDIA_UNSUPPORTED_TYPE, UNAUTHORIZED } from '@repo/constants';
import { DomainError } from '@repo/core';
import { createMediaAsset } from '@repo/db';
import {
  ACCEPTED_MIME_TYPES,
  MAX_UPLOAD_SIZE_BYTES,
  presignPublicUpload,
  requirePublicBucketName,
} from '@repo/storage';
import { presignMediaResponseSchema, presignMediaSchema } from '@repo/validators';
import type { FastifyInstance } from 'fastify';
import type { ZodTypeProvider } from 'fastify-type-provider-zod';

const EXTENSION_BY_MIME_TYPE: Record<string, string> = {
  'image/jpeg': 'jpg',
  'image/png': 'png',
  'image/webp': 'webp',
};

function requireAcceptedMimeType(mimeType: string): string {
  const extension = EXTENSION_BY_MIME_TYPE[mimeType];
  if (!extension) {
    throw new DomainError(
      MEDIA_UNSUPPORTED_TYPE,
      `Type de fichier non supporté. Formats acceptés : ${ACCEPTED_MIME_TYPES.join(', ')}`,
      { mimeType, accepted: ACCEPTED_MIME_TYPES },
    );
  }
  return extension;
}

function requireAcceptableSize(sizeBytes: number): void {
  if (sizeBytes > MAX_UPLOAD_SIZE_BYTES) {
    throw new DomainError(
      MEDIA_TOO_LARGE,
      `Fichier trop volumineux (${sizeBytes} octets, maximum ${MAX_UPLOAD_SIZE_BYTES})`,
      { sizeBytes, maxSizeBytes: MAX_UPLOAD_SIZE_BYTES },
    );
  }
}

export async function mediaRoutes(app: FastifyInstance): Promise<void> {
  const typedApp = app.withTypeProvider<ZodTypeProvider>();

  typedApp.post(
    '/media/presign',
    {
      preHandler: [app.requireRole('PROVIDER')],
      schema: {
        description:
          'Crée un `MediaAsset` (bucket public) et renvoie une URL PUT pré-signée (~10 min) ' +
          "pour un téléversement direct vers R2, sans transiter par l'API (P5). Le traitement " +
          '(variantes WebP) se fait ensuite via `POST /v1/media/:id/process`.',
        body: presignMediaSchema,
        response: { 200: presignMediaResponseSchema },
      },
    },
    async (request) => {
      if (!request.user) {
        throw new DomainError(UNAUTHORIZED, 'Non authentifié');
      }

      const { mimeType, sizeBytes } = request.body;
      const extension = requireAcceptedMimeType(mimeType);
      requireAcceptableSize(sizeBytes);

      const mediaId = randomUUID();
      const storageKey = `media/${mediaId}/original.${extension}`;

      const media = await createMediaAsset({
        uploadedById: request.user.sub,
        bucket: requirePublicBucketName(),
        storageKey,
        type: 'IMAGE',
        mimeType,
        sizeBytes,
        isPrivate: false,
      });

      const { uploadUrl, expiresAt } = await presignPublicUpload(storageKey, mimeType);

      return { mediaId: media.id, uploadUrl, expiresAt };
    },
  );
}
