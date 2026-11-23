// BE-30b : Schémas Zod pour la vérification d'identité artisan (KYC / ADR-002).
import { z } from 'zod';

export const verificationDocumentTypeSchema = z.enum([
  'CIN_FRONT',
  'CIN_BACK',
  'SELFIE_WITH_ID',
  'PATENTE',
  'DIPLOMA',
  'INSURANCE',
  'OTHER',
]);

export const verificationStatusSchema = z.enum([
  'NOT_SUBMITTED',
  'PENDING',
  'MORE_INFO_REQUIRED',
  'APPROVED',
  'REJECTED',
]);
export type VerificationDocumentType = z.infer<typeof verificationDocumentTypeSchema>;
export type VerificationStatus = z.infer<typeof verificationStatusSchema>;

export const presignKycSchema = z.object({
  documentType: verificationDocumentTypeSchema,
  mimeType: z.enum(['image/jpeg', 'image/png']),
  sizeBytes: z
    .number()
    .int()
    .min(1)
    .max(10 * 1024 * 1024), // 10 Mo
});
export type PresignKycInput = z.infer<typeof presignKycSchema>;

export const presignKycResponseSchema = z.object({
  mediaId: z.string().uuid(),
  uploadUrl: z.string().url(),
  expiresAt: z.date(),
});
export type PresignKycResponse = z.infer<typeof presignKycResponseSchema>;

export const submitKycSchema = z.object({
  cinNumber: z
    .string()
    .regex(/^\d{8}$/, 'Le numéro de carte d’identité (CIN) doit comporter exactement 8 chiffres.'),
  fullNameOnId: z.string().min(2).max(160),
  cinFrontMediaId: z.string().uuid(),
  cinBackMediaId: z.string().uuid(),
});
export type SubmitKycInput = z.infer<typeof submitKycSchema>;

export const submitKycResponseSchema = z.object({
  requestId: z.string().uuid(),
  status: verificationStatusSchema,
  submittedAt: z.date(),
});
export type SubmitKycResponse = z.infer<typeof submitKycResponseSchema>;

export const kycStatusResponseSchema = z.object({
  verificationStatus: verificationStatusSchema,
  isVerified: z.boolean(),
  currentRequest: z
    .object({
      id: z.string().uuid(),
      status: verificationStatusSchema,
      fullNameOnId: z.string().nullable(),
      submittedAt: z.date(),
      reviewedAt: z.date().nullable(),
      rejectionReason: z.string().nullable(),
      documents: z.array(
        z.object({
          id: z.string().uuid(),
          mediaId: z.string().uuid(),
          type: verificationDocumentTypeSchema,
          createdAt: z.date(),
        }),
      ),
    })
    .nullable(),
});
export type KycStatusResponse = z.infer<typeof kycStatusResponseSchema>;

// =====================================================================
// BE-31 : Modération KYC côté Back-office (US-A-01 / ADR-002)
// =====================================================================

export const listAdminVerificationsQuerySchema = z.object({
  status: verificationStatusSchema.optional(),
  limit: z.coerce.number().int().min(1).max(50).default(20),
  cursor: z.string().optional(),
  orderBy: z.enum(['asc', 'desc']).default('asc'),
});
export type ListAdminVerificationsQuery = z.infer<typeof listAdminVerificationsQuerySchema>;

export const adminVerificationItemSchema = z.object({
  id: z.string().uuid(),
  providerId: z.string().uuid(),
  provider: z.object({
    id: z.string().uuid(),
    businessName: z.string(),
    slug: z.string(),
    baseGovernorateId: z.string(),
    isVerified: z.boolean(),
  }),
  fullNameOnId: z.string().nullable(),
  status: verificationStatusSchema,
  submittedAt: z.date(),
  reviewedAt: z.date().nullable(),
  reviewedBy: z
    .object({
      id: z.string().uuid(),
      phone: z.string(),
    })
    .nullable(),
  documentsCount: z.number().int(),
  documents: z.array(
    z.object({
      id: z.string().uuid(),
      type: verificationDocumentTypeSchema,
    }),
  ),
});
export type AdminVerificationItem = z.infer<typeof adminVerificationItemSchema>;

export const listAdminVerificationsResponseSchema = z.object({
  items: z.array(adminVerificationItemSchema),
  nextCursor: z.string().nullable(),
  totalPending: z.number().int(),
});
export type ListAdminVerificationsResponse = z.infer<typeof listAdminVerificationsResponseSchema>;

export const adminVerificationDetailDocumentSchema = z.object({
  id: z.string().uuid(),
  type: verificationDocumentTypeSchema,
  mediaId: z.string().uuid(),
  downloadUrl: z.string().url().nullable(),
  expiresAt: z.date().nullable(),
  isPurged: z.boolean().default(false),
});
export type AdminVerificationDetailDocument = z.infer<typeof adminVerificationDetailDocumentSchema>;

export const adminVerificationDetailResponseSchema = z.object({
  id: z.string().uuid(),
  providerId: z.string().uuid(),
  provider: z.object({
    id: z.string().uuid(),
    businessName: z.string(),
    slug: z.string(),
    headline: z.string().nullable(),
    baseGovernorateId: z.string(),
    isVerified: z.boolean(),
    verificationStatus: verificationStatusSchema,
    user: z.object({
      id: z.string().uuid(),
      phone: z.string(),
    }),
  }),
  fullNameOnId: z.string().nullable(),
  status: verificationStatusSchema,
  submittedAt: z.date(),
  reviewedAt: z.date().nullable(),
  reviewedBy: z
    .object({
      id: z.string().uuid(),
      phone: z.string(),
    })
    .nullable(),
  rejectionReason: z.string().nullable(),
  internalNote: z.string().nullable(),
  expiresAt: z.date().nullable().optional(),
  documents: z.array(adminVerificationDetailDocumentSchema),
});
export type AdminVerificationDetailResponse = z.infer<typeof adminVerificationDetailResponseSchema>;

export const adminKycPurgeResultSchema = z.object({
  totalProcessed: z.number().int().nonnegative(),
  purgedCount: z.number().int().nonnegative(),
  skippedCount: z.number().int().nonnegative(),
  errorsCount: z.number().int().nonnegative(),
});
export type AdminKycPurgeResult = z.infer<typeof adminKycPurgeResultSchema>;

export const reviewAdminVerificationSchema = z
  .object({
    status: z.enum(['APPROVED', 'REJECTED', 'MORE_INFO_REQUIRED']),
    rejectionReason: z.string().trim().max(400).optional(),
    internalNote: z.string().trim().max(1000).optional(),
  })
  .superRefine((data, ctx) => {
    if (data.status === 'REJECTED' || data.status === 'MORE_INFO_REQUIRED') {
      if (!data.rejectionReason || data.rejectionReason.length < 5) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          path: ['rejectionReason'],
          message:
            'Un motif explicatif d’au moins 5 caractères est obligatoire pour un refus ou une demande de complément.',
        });
      }
    }
  });
export type ReviewAdminVerificationInput = z.infer<typeof reviewAdminVerificationSchema>;

export const reviewAdminVerificationResponseSchema = z.object({
  id: z.string().uuid(),
  status: verificationStatusSchema,
  reviewedAt: z.date(),
  reviewedById: z.string().uuid(),
  isVerified: z.boolean(),
  rejectionReason: z.string().nullable(),
  internalNote: z.string().nullable(),
});
export type ReviewAdminVerificationResponse = z.infer<typeof reviewAdminVerificationResponseSchema>;
