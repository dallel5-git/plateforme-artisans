import { randomUUID } from 'node:crypto';

import {
  OTP_EXPIRED,
  OTP_INVALID,
  OTP_TOO_MANY_ATTEMPTS,
  REFRESH_TOKEN_INVALID,
  REFRESH_TOKEN_REUSED,
  UNAUTHORIZED,
  VALIDATION_ERROR,
} from '@repo/constants';
import {
  buildOtpRequestResponse,
  canAttemptOtp,
  detectRefreshReplay,
  DomainError,
  generateOtp,
  hashOtp,
  hashRefreshToken,
  isSessionExpired,
  OTP_TTL_MINUTES,
  REFRESH_TTL_DAYS,
  rotateRefreshToken,
  signAccessToken,
  verifyOtp,
} from '@repo/core';
import {
  consumeOtpCode,
  createOtpCode,
  createSession,
  createUser,
  findActiveOtpForVerification,
  findSessionById,
  findUserById,
  findUserByPhone,
  incrementOtpAttempts,
  revokeAllSessionsForUser,
  revokeSession,
  rotateSessionToken,
  touchLastLogin,
  type OtpPurpose,
  type PublicUser,
  type SessionWithHash,
} from '@repo/db';
import { createSmsProvider } from '@repo/notifications';
import { normalizePhoneTn } from '@repo/utils';

import { enforceOtpRequestRateLimit } from '../plugins/rate-limit.js';
import {
  logoutRequestSchema,
  logoutResponseSchema,
  meResponseSchema,
  otpRequestResponseSchema,
  otpRequestSchema,
  otpVerifyResponseSchema,
  otpVerifySchema,
  refreshRequestSchema,
  refreshResponseSchema,
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

// Le refresh token est opaque côté client : `${session.id}.${tokenId}`. `session.id` sert de
// `familyId` (BE-09 `detectRefreshReplay`) — toujours résolvable même après rotation, sans JWT
// ni migration Prisma supplémentaire (décision de conception BE-10).
function parseRefreshToken(token: string): { sessionId: string; tokenId: string } {
  const separatorIndex = token.indexOf('.');
  if (separatorIndex === -1) {
    throw new DomainError(REFRESH_TOKEN_INVALID, 'Refresh token malformé');
  }
  return {
    sessionId: token.slice(0, separatorIndex),
    tokenId: token.slice(separatorIndex + 1),
  };
}

/** Décide ROTATE/REVOKE_FAMILY/REJECT (BE-09) et applique la rotation en base. */
async function rotateSession(session: SessionWithHash, presentedTokenId: string): Promise<string> {
  const verdict = detectRefreshReplay({
    presentedTokenId: hashRefreshToken(presentedTokenId),
    familyId: session.id,
    currentTokenId: session.refreshTokenHash,
    familyRevokedAt: session.revokedAt,
  });

  if (verdict.action !== 'ROTATE') {
    if (verdict.action === 'REVOKE_FAMILY') {
      await revokeAllSessionsForUser(session.userId);
    }
    throw new DomainError(REFRESH_TOKEN_REUSED, 'Refresh token déjà utilisé ou session révoquée');
  }

  const { newTokenId } = rotateRefreshToken({
    currentTokenId: presentedTokenId,
    familyId: session.id,
    now: new Date(),
  });
  await rotateSessionToken(session.id, {
    refreshTokenHash: hashRefreshToken(newTokenId),
    expiresAt: new Date(Date.now() + REFRESH_TTL_DAYS * 24 * 60 * 60_000),
  });
  return newTokenId;
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
      preHandler: [app.requireAuth],
      schema: {
        tags: ['auth'],
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

  typedApp.post(
    '/auth/otp/request',
    {
      schema: {
        tags: ['auth'],
        description:
          'Demande un code OTP par SMS. Réponse identique, que le numéro existe déjà ou non (anti-énumération). Rate-limit : 5/h par numéro et par IP.',
        body: otpRequestSchema,
        response: { 200: otpRequestResponseSchema },
      },
    },
    async (request) => {
      const phone = requireNormalizedPhone(request.body.phone);
      await enforceOtpRequestRateLimit(phone, request.ip);
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
        tags: ['auth'],
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
        throw new DomainError(OTP_INVALID, 'Code invalide', {
          attemptsRemaining: otp.maxAttempts - (otp.attempts + 1),
        });
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

  typedApp.post(
    '/auth/refresh',
    {
      schema: {
        tags: ['auth'],
        description:
          'Fait tourner le refresh token. Un rejeu révoque toute la famille de sessions.',
        body: refreshRequestSchema,
        response: { 200: refreshResponseSchema },
      },
    },
    async (request) => {
      const { sessionId, tokenId } = parseRefreshToken(request.body.refreshToken);
      const session = await findSessionById(sessionId);
      if (!session || isSessionExpired({ expiresAt: session.expiresAt, now: new Date() })) {
        throw new DomainError(REFRESH_TOKEN_INVALID, 'Refresh token invalide ou expiré');
      }

      const newTokenId = await rotateSession(session, tokenId);
      const user = await findUserById(session.userId);
      if (!user) {
        throw new DomainError(REFRESH_TOKEN_INVALID, 'Utilisateur introuvable');
      }

      return {
        accessToken: await signAccessToken({ sub: user.id, role: user.roles[0] ?? 'CLIENT' }),
        refreshToken: `${session.id}.${newTokenId}`,
      };
    },
  );

  typedApp.post(
    '/auth/logout',
    {
      schema: {
        tags: ['auth'],
        description: 'Révoque la session associée au refresh token présenté. Idempotent.',
        body: logoutRequestSchema,
        response: { 200: logoutResponseSchema },
      },
    },
    async (request) => {
      const { sessionId } = parseRefreshToken(request.body.refreshToken);
      const session = await findSessionById(sessionId);
      if (session) {
        await revokeSession(sessionId);
      }
      return { status: 'ok' as const };
    },
  );
}
