// BE-31 : Routes d'administration pour la modération KYC (US-A-01 / ADR-002 / INPDP 2004-63).
// BE-30c : Purge automatique et manuelle des pièces d'identité KYC à J+X (norme INPDP).
//
// Endpoints :
// - `GET  /v1/admin/verifications`         : file de vérification (tri ancienneté, filtre statut, pagination curseur)
// - `GET  /v1/admin/verifications/:id`     : détails complets, URLs de lecture R2 éphémères (<= 5 min) + AuditLog (P8/P9)
// - `POST /v1/admin/verifications/:id/review` : décision de modération (APPROVED, REJECTED, MORE_INFO_REQUIRED)
// - `POST /v1/admin/verifications/purge-expired` : déclenchement manuel de la purge des médias KYC expirés (SUPER_ADMIN)
import {
  KYC_INVALID_STATUS_TRANSITION,
  KYC_REQUEST_NOT_FOUND,
  VALIDATION_ERROR,
} from '@repo/constants';
import { DomainError, hashIp, purgeExpiredKycMedia } from '@repo/core';
import {
  InvalidCursorError,
  InvalidStatusTransitionError,
  countPendingVerificationRequests,
  findVerificationRequestDetailsForAdmin,
  listVerificationRequestsForAdmin,
  logVerificationView,
  reviewVerificationRequest,
} from '@repo/db';
import { deleteKycObject, presignKycRead } from '@repo/storage';
import {
  adminKycPurgeResultSchema,
  adminVerificationDetailResponseSchema,
  listAdminVerificationsQuerySchema,
  listAdminVerificationsResponseSchema,
  reviewAdminVerificationResponseSchema,
  reviewAdminVerificationSchema,
} from '@repo/validators';
import type { FastifyInstance } from 'fastify';
import type { ZodTypeProvider } from 'fastify-type-provider-zod';
import { z } from 'zod';

const verificationParamsSchema = z.object({
  id: z.string().uuid(),
});

export async function adminVerificationRoutes(app: FastifyInstance): Promise<void> {
  const typedApp = app.withTypeProvider<ZodTypeProvider>();

  // 1. File des demandes de vérification d'identité KYC
  typedApp.get(
    '/admin/verifications',
    {
      preHandler: [app.requireRole('ADMIN', 'MODERATOR', 'SUPER_ADMIN')],
      schema: {
        tags: ['admin-verifications'],
        description:
          'File des demandes de vérification d’identité KYC pour le back-office. ' +
          'Tri par ancienneté (ascendant par défaut), filtre par statut optionnel, pagination par curseur.',
        querystring: listAdminVerificationsQuerySchema,
        response: { 200: listAdminVerificationsResponseSchema },
      },
    },
    async (request) => {
      try {
        const [page, totalPending] = await Promise.all([
          listVerificationRequestsForAdmin(request.query),
          countPendingVerificationRequests(),
        ]);

        return {
          items: page.items,
          nextCursor: page.nextCursor,
          totalPending,
        };
      } catch (error) {
        if (error instanceof InvalidCursorError) {
          throw new DomainError(VALIDATION_ERROR, 'Curseur de pagination invalide', {
            field: 'cursor',
          });
        }
        throw error;
      }
    },
  );

  // 2. Détails d'une demande KYC et génération des URL d'accès éphémères R2
  typedApp.get(
    '/admin/verifications/:id',
    {
      preHandler: [app.requireRole('ADMIN', 'MODERATOR', 'SUPER_ADMIN')],
      schema: {
        tags: ['admin-verifications'],
        description:
          'Récupère le détail complet d’une demande KYC pour examen modérateur. ' +
          'Génère des URL signées R2 temporaires (TTL <= 5 min) pour chaque document et ' +
          'consigne la consultation dans AuditLog (P8/P9).',
        params: verificationParamsSchema,
        response: { 200: adminVerificationDetailResponseSchema },
      },
    },
    async (request) => {
      const { id } = request.params;
      const details = await findVerificationRequestDetailsForAdmin(id);

      if (!details) {
        throw new DomainError(KYC_REQUEST_NOT_FOUND, 'Demande de vérification introuvable');
      }

      // Génération des URLs GET R2 éphémères (TTL 5 min)
      const presignedDocuments = await Promise.all(
        details.documents.map(async (doc) => {
          const isPurged = doc.media.storageKey.startsWith('purged:');
          if (isPurged) {
            return {
              id: doc.id,
              type: doc.type,
              mediaId: doc.mediaId,
              downloadUrl: null,
              expiresAt: null,
              isPurged: true,
            };
          }

          const presigned = await presignKycRead(doc.media.storageKey);
          return {
            id: doc.id,
            type: doc.type,
            mediaId: doc.mediaId,
            downloadUrl: presigned.downloadUrl,
            expiresAt: presigned.expiresAt,
            isPurged: false,
          };
        }),
      );

      // Traçabilité INPDP : enregistrement systématique dans AuditLog
      await logVerificationView({
        requestId: id,
        actorId: request.user!.sub,
        documentTypes: details.documents.map((d) => d.type),
        ipHash: hashIp(request.ip),
        userAgent: request.headers['user-agent'],
      });

      return {
        id: details.id,
        providerId: details.providerId,
        provider: details.provider,
        fullNameOnId: details.fullNameOnId,
        status: details.status,
        submittedAt: details.submittedAt,
        reviewedAt: details.reviewedAt,
        reviewedBy: details.reviewedBy,
        rejectionReason: details.rejectionReason,
        internalNote: details.internalNote,
        expiresAt: details.expiresAt,
        documents: presignedDocuments,
      };
    },
  );

  // 3. Décision de modération KYC
  typedApp.post(
    '/admin/verifications/:id/review',
    {
      preHandler: [app.requireRole('ADMIN', 'MODERATOR', 'SUPER_ADMIN')],
      schema: {
        tags: ['admin-verifications'],
        description:
          'Applique une décision de modération sur une demande KYC (APPROVED, REJECTED, MORE_INFO_REQUIRED). ' +
          'Enregistre le statut de vérification sur le profil artisan, met à jour le badge `isVerified` (ADR-002) ' +
          'et journalise la décision dans AuditLog.',
        params: verificationParamsSchema,
        body: reviewAdminVerificationSchema,
        response: { 200: reviewAdminVerificationResponseSchema },
      },
    },
    async (request) => {
      const { id } = request.params;

      try {
        const result = await reviewVerificationRequest({
          requestId: id,
          reviewerId: request.user!.sub,
          status: request.body.status,
          rejectionReason: request.body.rejectionReason,
          internalNote: request.body.internalNote,
          actorIpHash: hashIp(request.ip),
          actorUserAgent: request.headers['user-agent'],
        });

        if (!result) {
          throw new DomainError(KYC_REQUEST_NOT_FOUND, 'Demande de vérification introuvable');
        }

        return result;
      } catch (error) {
        if (error instanceof InvalidStatusTransitionError) {
          throw new DomainError(KYC_INVALID_STATUS_TRANSITION, error.message);
        }
        throw error;
      }
    },
  );

  // 4. BE-30c : Déclenchement manuel de la purge des médias KYC expirés (SUPER_ADMIN)
  typedApp.post(
    '/admin/verifications/purge-expired',
    {
      preHandler: [app.requireRole('SUPER_ADMIN')],
      schema: {
        tags: ['admin-verifications'],
        description:
          'Déclenche la purge des images KYC (CIN) dont la durée de rétention est échue (norme INPDP). ' +
          'Supprime physiquement les fichiers dans Cloudflare R2, neutralise les enregistrements DB ' +
          'et consigne la traçabilité dans AuditLog.',
        response: { 200: adminKycPurgeResultSchema },
      },
    },
    async () => {
      const result = await purgeExpiredKycMedia({
        deleteFromStorage: (storageKey: string) => deleteKycObject(storageKey),
      });

      return {
        totalProcessed: result.totalProcessed,
        purgedCount: result.purgedCount,
        skippedCount: result.skippedCount,
        errorsCount: result.errors.length,
      };
    },
  );
}
