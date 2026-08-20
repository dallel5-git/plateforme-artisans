import { randomUUID } from 'node:crypto';

import {
  OTP_EXPIRED,
  OTP_INVALID,
  OTP_TOO_MANY_ATTEMPTS,
  UNAUTHORIZED,
  VALIDATION_ERROR,
} from '@repo/constants';
import {
  buildOtpRequestResponse,
  canAttemptOtp,
  DomainError,
  generateOtp,
  hashOtp,
  hashRefreshToken,
  OTP_TTL_MINUTES,
  REFRESH_TTL_DAYS,
  signAccessToken,
  verifyOtp,
} from '@repo/core';
import {
  consumeOtpCode,
  createOtpCode,
  createSession,
  createUser,
  findActiveOtpForVerification,
  findUserById,
  findUserByPhone,
  incrementOtpAttempts,
  touchLastLogin,
  type OtpPurpose,
  type PublicUser,
} from '@repo/db';
import { createSmsProvider } from '@repo/notifications';
import { normalizePhoneTn } from '@repo/utils';
import {
  meResponseSchema,
  otpRequestResponseSchema,
  otpRequestSchema,
  otpVerifyResponseSchema,
  otpVerifySchema,
} from '@repo/validators';
import type { FastifyInstance, FastifyRequest } from 'fastify';
import type { ZodTypeProvider } from 'fastify-type-provider-zod';

function requireNormalizedPhone(phone: string): string {
  const normalized = normalizePhoneTn(phone);
  if (!normalized) {
    throw new DomainError(VALIDATION_ERROR, 'Numéro de téléphone invalide', { field: 'phone' });
  }
  return normalized;
}

async function issueSession(user: PublicUser, request: FastifyRequest) {
  const tokenId = randomUUID();
  const userAgent = request.headers['user-agent'];
  const session = await createSession({
    userId: user.id,
    refreshTokenHash: hashRefreshToken(tokenId),
    expiresAt: new Date(Date.now() + REFRESH_TTL_DAYS * 24 * 60 * 60_000),
    userAgent: typeof userAgent === 'string' ? userAgent : undefined,
  });

  return {
    accessToken: await signAccessToken({ sub: user.id, role: user.roles[0] ?? 'CLIENT' }),
    refreshToken: `${session.id}.${tokenId}`,
    user,
  };
}

export async function authRoutes(app: FastifyInstance): Promise<void> {
  const typedApp = app.withTypeProvider<ZodTypeProvider>();

  typedApp.get(
    '/auth/me',
    {
      preHandler: [app.authenticate],
      schema: {
        description: "Profil de l'utilisateur authentifié, rôles inclus.",
        response: { 200: meResponseSchema },
      },
    },
    async (request) => {
      if (!request.user) {
        throw new DomainError(UNAUTHORIZED, 'Non authentifié');
      }

      const user = await findUserById(request.user.sub);
      if (!user) {
        throw new DomainError(UNAUTHORIZED, 'Utilisateur introuvable');
      }

      return user;
    },
  );

  // Pas de rate-limit ici (périmètre dédié de BE-11, pas une dépendance déclarée de BE-10).
  typedApp.post(
    '/auth/otp/request',
    {
      schema: {
        description:
          'Demande un code OTP par SMS. Réponse identique, que le numéro existe déjà ou non (anti-énumération).',
        body: otpRequestSchema,
        response: { 200: otpRequestResponseSchema },
      },
    },
    async (request) => {
      const phone = requireNormalizedPhone(request.body.phone);
      const existingUser = await findUserByPhone(phone);
      const purpose: OtpPurpose = existingUser ? 'LOGIN' : 'SIGNUP';
      const code = generateOtp();
      const codeHash = await hashOtp(code);
      const expiresAt = new Date(Date.now() + OTP_TTL_MINUTES * 60_000);

      await createOtpCode({ phone, userId: existingUser?.id, purpose, codeHash, expiresAt });
      await createSmsProvider().send(phone, `Sanaya : votre code de vérification est ${code}`);

      return buildOtpRequestResponse({ userExists: existingUser !== null });
    },
  );

  typedApp.post(
    '/auth/otp/verify',
    {
      schema: {
        description: 'Vérifie le code OTP, crée le compte au besoin, émet les tokens de session.',
        body: otpVerifySchema,
        response: { 200: otpVerifyResponseSchema },
      },
    },
    async (request) => {
      const phone = requireNormalizedPhone(request.body.phone);
      const existingUser = await findUserByPhone(phone);
      const purpose: OtpPurpose = existingUser ? 'LOGIN' : 'SIGNUP';

      const otp = await findActiveOtpForVerification(phone, purpose);
      if (!otp) {
        throw new DomainError(OTP_EXPIRED, 'Code expiré ou introuvable');
      }
      if (!canAttemptOtp({ attempts: otp.attempts, maxAttempts: otp.maxAttempts })) {
        throw new DomainError(OTP_TOO_MANY_ATTEMPTS, 'Trop de tentatives');
      }
      if (!(await verifyOtp(request.body.code, otp.codeHash))) {
        await incrementOtpAttempts(otp.id);
        throw new DomainError(OTP_INVALID, 'Code invalide');
      }
      await consumeOtpCode(otp.id);

      const user =
        existingUser ??
        (await createUser({
          phone,
          roles: ['CLIENT'],
          status: 'ACTIVE',
          phoneVerifiedAt: new Date(),
        }));
      await touchLastLogin(user.id);

      // `touchLastLogin` ne renvoie rien (BE-05) — on reflète la mise à jour sans requête
      // supplémentaire plutôt que de répondre un `lastLoginAt` déjà périmé.
      return issueSession({ ...user, lastLoginAt: new Date() }, request);
    },
  );
}
