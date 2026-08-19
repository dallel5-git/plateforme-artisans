import { UNAUTHORIZED, VALIDATION_ERROR } from '@repo/constants';
import {
  buildOtpRequestResponse,
  DomainError,
  generateOtp,
  hashOtp,
  OTP_TTL_MINUTES,
} from '@repo/core';
import { createOtpCode, findUserById, findUserByPhone, type OtpPurpose } from '@repo/db';
import { createSmsProvider } from '@repo/notifications';
import { normalizePhoneTn } from '@repo/utils';
import { meResponseSchema, otpRequestResponseSchema, otpRequestSchema } from '@repo/validators';
import type { FastifyInstance } from 'fastify';
import type { ZodTypeProvider } from 'fastify-type-provider-zod';

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
          "Demande un code OTP par SMS. Réponse identique, que le numéro existe déjà ou non (anti-énumération).",
        body: otpRequestSchema,
        response: { 200: otpRequestResponseSchema },
      },
    },
    async (request) => {
      const phone = normalizePhoneTn(request.body.phone);
      if (!phone) {
        throw new DomainError(VALIDATION_ERROR, 'Numéro de téléphone invalide', {
          field: 'phone',
        });
      }

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
}
