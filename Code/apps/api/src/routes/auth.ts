import { UNAUTHORIZED } from '@repo/constants';
import { DomainError } from '@repo/core';
import { findUserById } from '@repo/db';
import { meResponseSchema } from '@repo/validators';
import type { FastifyInstance } from 'fastify';
import type { ZodTypeProvider } from 'fastify-type-provider-zod';

export async function authRoutes(app: FastifyInstance): Promise<void> {
  app.withTypeProvider<ZodTypeProvider>().get(
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
}
