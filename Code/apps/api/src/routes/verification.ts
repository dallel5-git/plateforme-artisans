// BE-30b : Routes de vérification d'identité artisan (KYC / ADR-002 / INPDP 2004-63).
//
// Endpoints :
// - `POST /v1/providers/me/verification/presign` : création MediaAsset privé + URL PUT signée R2
// - `POST /v1/providers/me/verification/submit`  : validation CIN, hash salé, chiffrement AES-256-GCM, transaction DB
// - `POST /v1/providers/me/verification`         : alias de soumission directe
// - `GET  /v1/providers/me/verification`         : lecture du statut KYC courant pour l'artisan
import { randomUUID } from 'node:crypto';

import {
  KYC_ALREADY_VERIFIED,
  KYC_DOCUMENT_NOT_FOUND,
  KYC_INVALID_CIN,
  KYC_REQUEST_ALREADY_PENDING,
  PROVIDER_PROFILE_NOT_FOUND,
  UNAUTHORIZED,
} from '@repo/constants';
import { DomainError, encryptCin, hashCin, isValidCin } from '@repo/core';
import {
  addVerificationDocument,
  createMediaAsset,
  createVerificationRequest,
  findLatestVerificationRequestByProviderId,
  findMediaAssetById,
  findPendingVerificationRequestByProviderId,
  findProviderProfileByUserId,
  updateProviderVerificationStatus,
  withTransaction,
} from '@repo/db';
import { buildKycStorageKey, presignKycUpload, requireKycBucketName } from '@repo/storage';
import {
  kycStatusResponseSchema,
  presignKycResponseSchema,
  presignKycSchema,
  submitKycResponseSchema,
  submitKycSchema,
  type SubmitKycInput,
} from '@repo/validators';
import type { FastifyInstance } from 'fastify';
import type { ZodTypeProvider } from 'fastify-type-provider-zod';

export async function verificationRoutes(app: FastifyInstance): Promise<void> {
  const typedApp = app.withTypeProvider<ZodTypeProvider>();

  // 1. Pré-signature d'upload pour un document d'identité (bucket privé private-kyc)
  typedApp.post(
    '/providers/me/verification/presign',
    {
      preHandler: [app.requireRole('PROVIDER')],
      schema: {
        description:
          'Génère une URL PUT pré-signée (~10 min) vers le bucket hermétique `private-kyc` ' +
          'avec chiffrement au repos forcé SSE-S3 AES-256 pour téléverser une pièce d’identité.',
        body: presignKycSchema,
        response: { 200: presignKycResponseSchema },
      },
    },
    async (request) => {
      if (!request.user) {
        throw new DomainError(UNAUTHORIZED, 'Non authentifié');
      }

      const provider = await findProviderProfileByUserId(request.user.sub);
      if (!provider) {
        throw new DomainError(PROVIDER_PROFILE_NOT_FOUND, 'Profil artisan introuvable');
      }

      if (provider.verificationStatus === 'APPROVED') {
        throw new DomainError(KYC_ALREADY_VERIFIED, 'Votre profil artisan est déjà vérifié.');
      }

      const pendingRequest = await findPendingVerificationRequestByProviderId(provider.id);
      if (pendingRequest) {
        throw new DomainError(
          KYC_REQUEST_ALREADY_PENDING,
          'Une demande de vérification est déjà en cours d’examen.',
        );
      }

      const { documentType, mimeType, sizeBytes } = request.body;
      const side =
        documentType === 'CIN_FRONT'
          ? 'recto'
          : documentType === 'CIN_BACK'
            ? 'verso'
            : documentType.toLowerCase();

      const tempRequestId = randomUUID();
      const storageKey = buildKycStorageKey(provider.id, tempRequestId, side);

      const media = await createMediaAsset({
        uploadedById: request.user.sub,
        bucket: requireKycBucketName(),
        storageKey,
        type: 'IMAGE',
        mimeType,
        sizeBytes,
        isPrivate: true,
        purgeAfter: new Date(Date.now() + 365 * 24 * 60 * 60 * 1000), // Rétention légale 1 an
      });

      const { uploadUrl, expiresAt } = await presignKycUpload(storageKey, mimeType);

      return {
        mediaId: media.id,
        uploadUrl,
        expiresAt,
      };
    },
  );

  // Helper de soumission partagé entre /submit et la racine /verification
  const handleSubmitKyc = async (request: { user?: { sub: string }; body: SubmitKycInput }) => {
    if (!request.user) {
      throw new DomainError(UNAUTHORIZED, 'Non authentifié');
    }

    const provider = await findProviderProfileByUserId(request.user.sub);
    if (!provider) {
      throw new DomainError(PROVIDER_PROFILE_NOT_FOUND, 'Profil artisan introuvable');
    }

    if (provider.verificationStatus === 'APPROVED') {
      throw new DomainError(KYC_ALREADY_VERIFIED, 'Votre profil artisan est déjà vérifié.');
    }

    const pendingRequest = await findPendingVerificationRequestByProviderId(provider.id);
    if (pendingRequest) {
      throw new DomainError(
        KYC_REQUEST_ALREADY_PENDING,
        'Une demande de vérification est déjà en cours d’examen.',
      );
    }

    const { cinNumber, fullNameOnId, cinFrontMediaId, cinBackMediaId } = request.body;

    if (!isValidCin(cinNumber)) {
      throw new DomainError(
        KYC_INVALID_CIN,
        'Le numéro de carte d’identité (CIN) doit comporter exactement 8 chiffres.',
      );
    }

    // Vérification des pièces jointes
    const [frontMedia, backMedia] = await Promise.all([
      findMediaAssetById(cinFrontMediaId),
      findMediaAssetById(cinBackMediaId),
    ]);

    if (!frontMedia || frontMedia.uploadedById !== request.user.sub || !frontMedia.isPrivate) {
      throw new DomainError(KYC_DOCUMENT_NOT_FOUND, 'Document CIN recto introuvable ou invalide');
    }

    if (!backMedia || backMedia.uploadedById !== request.user.sub || !backMedia.isPrivate) {
      throw new DomainError(KYC_DOCUMENT_NOT_FOUND, 'Document CIN verso introuvable ou invalide');
    }

    // Hachage salé SHA-256 et chiffrement réversible AES-256-GCM
    const cinNumberHash = hashCin(cinNumber);
    const cinNumberCipher = encryptCin(cinNumber);

    // Transaction atomique
    const requestRecord = await withTransaction(async (tx) => {
      const verificationRequest = await createVerificationRequest(
        {
          providerId: provider.id,
          cinNumberHash,
          cinNumberCipher,
          fullNameOnId: fullNameOnId.trim(),
          status: 'PENDING',
        },
        tx,
      );

      await addVerificationDocument(
        {
          requestId: verificationRequest.id,
          mediaId: frontMedia.id,
          type: 'CIN_FRONT',
        },
        tx,
      );

      await addVerificationDocument(
        {
          requestId: verificationRequest.id,
          mediaId: backMedia.id,
          type: 'CIN_BACK',
        },
        tx,
      );

      await updateProviderVerificationStatus(provider.id, 'PENDING', tx);

      return verificationRequest;
    });

    return {
      requestId: requestRecord.id,
      status: requestRecord.status,
      submittedAt: requestRecord.submittedAt,
    };
  };

  // 2. Soumission de la demande de vérification
  typedApp.post(
    '/providers/me/verification/submit',
    {
      preHandler: [app.requireRole('PROVIDER')],
      schema: {
        description:
          'Soumet une demande de vérification d’identité. Hache la CIN en SHA-256 salé ' +
          'et la chiffre en AES-256-GCM avant enregistrement (INPDP). Passe le profil à `PENDING`.',
        body: submitKycSchema,
        response: { 200: submitKycResponseSchema },
      },
    },
    handleSubmitKyc,
  );

  // Alias POST direct sur /providers/me/verification
  typedApp.post(
    '/providers/me/verification',
    {
      preHandler: [app.requireRole('PROVIDER')],
      schema: {
        description: 'Alias de soumission KYC sur `/providers/me/verification`.',
        body: submitKycSchema,
        response: { 200: submitKycResponseSchema },
      },
    },
    handleSubmitKyc,
  );

  // 3. Consultation du statut de vérification pour l'artisan connecté
  typedApp.get(
    '/providers/me/verification',
    {
      preHandler: [app.requireRole('PROVIDER')],
      schema: {
        description:
          'Récupère l’état de vérification actuel du profil artisan et les métadonnées de ' +
          'la dernière demande (sans révéler le numéro CIN ni les URL privées).',
        response: { 200: kycStatusResponseSchema },
      },
    },
    async (request) => {
      if (!request.user) {
        throw new DomainError(UNAUTHORIZED, 'Non authentifié');
      }

      const provider = await findProviderProfileByUserId(request.user.sub);
      if (!provider) {
        throw new DomainError(PROVIDER_PROFILE_NOT_FOUND, 'Profil artisan introuvable');
      }

      const latestRequest = await findLatestVerificationRequestByProviderId(provider.id);

      return {
        verificationStatus: provider.verificationStatus,
        isVerified: provider.isVerified,
        currentRequest: latestRequest
          ? {
              id: latestRequest.id,
              status: latestRequest.status,
              fullNameOnId: latestRequest.fullNameOnId,
              submittedAt: latestRequest.submittedAt,
              reviewedAt: latestRequest.reviewedAt,
              rejectionReason: latestRequest.rejectionReason,
              documents: latestRequest.documents.map((d) => ({
                id: d.id,
                mediaId: d.mediaId,
                type: d.type,
                createdAt: d.createdAt,
              })),
            }
          : null,
      };
    },
  );
}
