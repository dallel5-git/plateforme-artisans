import { z } from 'zod';
import { publicUserSchema } from './auth.js';

// BE-41 : Droit d'accès, d'export et à l'effacement (US-C-13 / Loi INPDP 2004-63).

export const exportedReviewSchema = z.object({
  id: z.uuid(),
  providerId: z.uuid(),
  providerBusinessName: z.string(),
  rating: z.number().int().min(1).max(5),
  ratingPunctuality: z.number().int().nullable(),
  ratingQuality: z.number().int().nullable(),
  ratingValue: z.number().int().nullable(),
  comment: z.string().nullable(),
  status: z.string(),
  isVerifiedContact: z.boolean(),
  createdAt: z.date(),
});
export type ExportedReview = z.infer<typeof exportedReviewSchema>;

export const exportedFavoriteSchema = z.object({
  providerId: z.uuid(),
  providerBusinessName: z.string(),
  createdAt: z.date(),
});
export type ExportedFavorite = z.infer<typeof exportedFavoriteSchema>;

export const exportedContactEventSchema = z.object({
  id: z.uuid(),
  providerId: z.uuid(),
  providerBusinessName: z.string(),
  channel: z.string(),
  createdAt: z.date(),
});
export type ExportedContactEvent = z.infer<typeof exportedContactEventSchema>;

export const exportedVerificationRequestSchema = z.object({
  id: z.uuid(),
  status: z.string(),
  submittedAt: z.date(),
  reviewedAt: z.date().nullable(),
  rejectionReason: z.string().nullable(),
  documentTypes: z.array(z.string()),
});
export type ExportedVerificationRequest = z.infer<typeof exportedVerificationRequestSchema>;

export const exportedProviderProfileSchema = z.object({
  id: z.uuid(),
  slug: z.string(),
  businessName: z.string(),
  headline: z.string().nullable(),
  bio: z.string().nullable(),
  yearsExperience: z.number().int().nullable(),
  whatsappPhone: z.string().nullable(),
  publicPhone: z.string().nullable(),
  spokenLanguages: z.array(z.string()),
  baseGovernorate: z.string(),
  baseDelegation: z.string().nullable(),
  publicationStatus: z.string(),
  availabilityStatus: z.string(),
  isVerified: z.boolean(),
  verifiedAt: z.date().nullable(),
  ratingAvg: z.number(),
  ratingCount: z.number().int(),
  categories: z.array(
    z.object({
      id: z.uuid(),
      nameFr: z.string(),
      nameAr: z.string(),
      isPrimary: z.boolean(),
    }),
  ),
  offerings: z.array(
    z.object({
      id: z.uuid(),
      titleFr: z.string(),
      titleAr: z.string().nullable(),
      priceMin: z.number().nullable(),
      priceMax: z.number().nullable(),
      priceUnit: z.string(),
    }),
  ),
  coverageAreas: z.array(
    z.object({
      id: z.uuid(),
      governorateNameFr: z.string(),
      governorateNameAr: z.string(),
      delegationNameFr: z.string().nullable(),
      delegationNameAr: z.string().nullable(),
    }),
  ),
  portfolioCount: z.number().int(),
});
export type ExportedProviderProfile = z.infer<typeof exportedProviderProfileSchema>;

export const userExportDataResponseSchema = z.object({
  legalNotice: z.string(),
  exportedAt: z.date(),
  user: publicUserSchema.extend({
    acceptedTermsVersion: z.string().nullable(),
    acceptedTermsAt: z.date().nullable(),
  }),
  providerProfile: exportedProviderProfileSchema.nullable(),
  reviewsWritten: z.array(exportedReviewSchema),
  favorites: z.array(exportedFavoriteSchema),
  contactEvents: z.array(exportedContactEventSchema),
  verificationRequests: z.array(exportedVerificationRequestSchema),
});
export type UserExportData = z.infer<typeof userExportDataResponseSchema>;

export const deleteAccountRequestSchema = z.object({
  confirmation: z.enum(['SUPPRIMER', 'DELETE']),
  reason: z.string().max(500).optional(),
});
export type DeleteAccountInput = z.infer<typeof deleteAccountRequestSchema>;

export const deleteAccountResponseSchema = z.object({
  success: z.boolean(),
  status: z.literal('DELETED'),
  message: z.string(),
  deletedAt: z.date(),
});
export type DeleteAccountResponse = z.infer<typeof deleteAccountResponseSchema>;
