import { FORBIDDEN } from '@repo/constants';
import { DomainError } from '@repo/core';
import type { UserRole } from '@repo/db';
import type { FastifyInstance, FastifyRequest } from 'fastify';

import { verifyRequest } from './require-auth.js';

declare module 'fastify' {
  interface FastifyInstance {
    requireRole: (
      ...roles: UserRole[]
    ) => (request: FastifyRequest, reply: FastifyReply) => Promise<void>;
  }
}

// Ré-exécute `verifyRequest` (pas seulement une lecture de `request.user` déjà posé) : utilisé
// seul sur une route, `requireRole(...)` couvre à la fois le 401 (sans en-tête / token invalide)
// et le 403 (rôle insuffisant) — pas besoin de chaîner `[app.requireAuth, app.requireRole(...)]`.
export function registerRequireRole(app: FastifyInstance): void {
  app.decorate('requireRole', (...roles: UserRole[]) => {
    return async (request: FastifyRequest) => {
      request.user = await verifyRequest(request);

      if (!roles.includes(request.user.role)) {
        throw new DomainError(FORBIDDEN, 'Rôle insuffisant pour cette action', {
          required: roles,
        });
      }
    };
  });
}
