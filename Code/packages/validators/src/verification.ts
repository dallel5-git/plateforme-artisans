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

export const presignKycSchema = z.object({
  documentType: verificationDocumentTypeSchema,
  mimeType: z.enum(['image/jpeg', 'image/png']),
  sizeBytes: z.number().int().min(1).max(10 * 1024 * 1024), // 10 Mo
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
