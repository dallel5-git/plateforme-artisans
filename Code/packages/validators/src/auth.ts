import { z } from 'zod';

// Format libre en entrée : l'utilisateur tape "22 123 456", "0022...", "+216..." — la
// normalisation E.164 (`packages/utils/phone-tn.ts`) est faite par la route, pas ici.
const phoneInputSchema = z.string().min(6).max(20);

export const otpRequestSchema = z.object({
  phone: phoneInputSchema,
});
export type OtpRequestInput = z.infer<typeof otpRequestSchema>;

export const otpRequestResponseSchema = z.object({
  status: z.literal('sent'),
});

export const otpVerifySchema = z.object({
  phone: phoneInputSchema,
  code: z.string().length(6),
});
export type OtpVerifyInput = z.infer<typeof otpVerifySchema>;

export const userRoleSchema = z.enum([
  'CLIENT',
  'PROVIDER',
  'MODERATOR',
  'SUPPORT',
  'SALES',
  'FINANCE',
  'ADMIN',
  'SUPER_ADMIN',
]);

export const userStatusSchema = z.enum(['PENDING_VERIFICATION', 'ACTIVE', 'SUSPENDED', 'DELETED']);

// Miroir de `PublicUser` (@repo/db) — jamais `passwordHash` ni `twoFactorSecret`.
export const publicUserSchema = z.object({
  id: z.uuid(),
  phone: z.string(),
  phoneVerifiedAt: z.date().nullable(),
  email: z.email().nullable(),
  emailVerifiedAt: z.date().nullable(),
  firstName: z.string().nullable(),
  lastName: z.string().nullable(),
  avatarMediaId: z.string().nullable(),
  roles: z.array(userRoleSchema),
  status: userStatusSchema,
  locale: z.string(),
  lastLoginAt: z.date().nullable(),
  marketingOptIn: z.boolean(),
  createdAt: z.date(),
  updatedAt: z.date(),
});

export const authTokensSchema = z.object({
  accessToken: z.string(),
  refreshToken: z.string(),
});

export const otpVerifyResponseSchema = authTokensSchema.extend({
  user: publicUserSchema,
});

export const refreshRequestSchema = z.object({
  refreshToken: z.string().min(1),
});

export const refreshResponseSchema = authTokensSchema;

export const logoutRequestSchema = z.object({
  refreshToken: z.string().min(1),
});

export const logoutResponseSchema = z.object({
  status: z.literal('ok'),
});

export const meResponseSchema = publicUserSchema;
