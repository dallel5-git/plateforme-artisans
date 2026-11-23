// BE-41 : Routes d'export et de suppression des données personnelles (US-C-13 / INPDP 2004-63).
//
// Endpoints :
// - `GET    /v1/users/me/export` : export JSON complet de toutes les données personnelles (portabilité INPDP)
// - `DELETE /v1/users/me`        : suppression et anonymisation irréversible du compte (droit à l'oubli)
import { UNAUTHORIZED } from '@repo/constants';
import {
  DomainError,
  buildUserDataExport,
  deleteUserAccount,
} from '@repo/core';
import {
  deleteAccountRequestSchema,
  deleteAccountResponseSchema,
  userExportDataResponseSchema,
} from '@repo/validators';
import type { FastifyInstance } from 'fastify';
import type { ZodTypeProvider } from 'fastify-type-provider-zod';

export async function accountRoutes(app: FastifyInstance): Promise<void> {
  const typedApp = app.withTypeProvider<ZodTypeProvider>();

  // 1. Export des données personnelles (Droit d'accès et à la portabilité)
  typedApp.get(
    '/users/me/export',
    {
      preHandler: [app.requireAuth],
      schema: {
        tags: ['account'],
        description:
          'Exporte l ensemble des données personnelles associées au compte utilisateur ' +
          'au format JSON conformément à la loi tunisienne n° 2004-63 (INPDP) et à l US-C-13.',
        response: { 200: userExportDataResponseSchema },
      },
    },
    async (request, reply) => {
      if (!request.user) {
        throw new DomainError(UNAUTHORIZED, 'Non authentifié');
      }

      reply.header(
        'content-disposition',
        `attachment; filename="donnees-personnelles-${request.user.sub}.json"`,
      );

      return buildUserDataExport(request.user.sub);
    },
  );

  // 2. Suppression de compte (Droit à l'effacement / anonymisation)
  typedApp.delete(
    '/users/me',
    {
      preHandler: [app.requireAuth],
      schema: {
        tags: ['account'],
        description:
          'Supprime et anonymise le compte utilisateur conformément aux exigences INPDP (US-C-13 / CLAUDE.md §3.2). ' +
          'Exige une confirmation explicite ("SUPPRIMER" ou "DELETE"). Révoque immédiatement toutes les sessions actives.',
        body: deleteAccountRequestSchema,
        response: { 200: deleteAccountResponseSchema },
      },
    },
    async (request) => {
      if (!request.user) {
        throw new DomainError(UNAUTHORIZED, 'Non authentifié');
      }

      return deleteUserAccount({
        userId: request.user.sub,
        confirmation: request.body.confirmation,
        reason: request.body.reason,
      });
    },
  );
}
