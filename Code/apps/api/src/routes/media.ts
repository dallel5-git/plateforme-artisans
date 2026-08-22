import { randomUUID } from 'node:crypto';

import {
  FORBIDDEN,
  MEDIA_NOT_FOUND,
  MEDIA_TOO_LARGE,
  MEDIA_UNSUPPORTED_TYPE,
  UNAUTHORIZED,
} from '@repo/constants';
import { can, DomainError } from '@repo/core';
import { createMediaAsset, finalizeMediaAsset, findMediaAssetById } from '@repo/db';
import {
  ACCEPTED_MIME_TYPES,
  buildPublicUrl,
  generateWebpVariants,
  getObjectBuffer,
  MAX_UPLOAD_SIZE_BYTES,
  presignPublicUpload,
  putObjectBuffer,
  requirePublicBucketName,
} from '@repo/storage';
import {
  mediaIdParamsSchema,
  presignMediaResponseSchema,
  presignMediaSchema,
  processMediaResponseSchema,
} from '@repo/validators';
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

  typedApp.post(
    '/media/:id/process',
    {
      preHandler: [app.requireRole('PROVIDER')],
      schema: {
        description:
          "Télécharge l'original téléversé par le client (voir `POST /v1/media/presign`), " +
          'génère les 3 variantes WebP (thumb/card/full — BE-20) et les téléverse sur R2. ' +
          '`MediaAsset.publicUrl`/`width`/`height` reflètent la variante `full`.',
        params: mediaIdParamsSchema,
        response: { 200: processMediaResponseSchema },
      },
    },
    async (request) => {
      if (!request.user) {
        throw new DomainError(UNAUTHORIZED, 'Non authentifié');
      }

      const media = await findMediaAssetById(request.params.id);
      if (!media) {
        throw new DomainError(MEDIA_NOT_FOUND, 'Média introuvable');
      }

      // Vérifiée avant tout accès R2/sharp (ordre délibéré) : le rejet 403 doit rester testable
      // sans clés R2 réelles, même convention que le reste du repo (validation avant I/O).
      if (!media.uploadedById || !can(request.user, 'update', { ownerId: media.uploadedById })) {
        throw new DomainError(FORBIDDEN, "Ce média n'appartient pas à l'utilisateur authentifié");
      }

      const original = await getObjectBuffer(media.bucket, media.storageKey);
      const variants = await generateWebpVariants(original);

      const mediaDir = `media/${media.id}`;
      const keys = {
        thumb: `${mediaDir}/thumb.webp`,
        card: `${mediaDir}/card.webp`,
        full: `${mediaDir}/full.webp`,
      };

      await Promise.all([
        putObjectBuffer(media.bucket, keys.thumb, variants.thumb.buffer, 'image/webp'),
        putObjectBuffer(media.bucket, keys.card, variants.card.buffer, 'image/webp'),
        putObjectBuffer(media.bucket, keys.full, variants.full.buffer, 'image/webp'),
      ]);

      const fullUrl = buildPublicUrl(keys.full);

      await finalizeMediaAsset(media.id, {
        publicUrl: fullUrl,
        width: variants.full.width,
        height: variants.full.height,
      });

      return {
        id: media.id,
        publicUrl: fullUrl,
        thumbUrl: buildPublicUrl(keys.thumb),
        cardUrl: buildPublicUrl(keys.card),
        fullUrl,
        width: variants.full.width,
        height: variants.full.height,
      };
    },
  );
}
