import { ACCESS_TOKEN_EXPIRED, ACCESS_TOKEN_INVALID } from '@repo/constants';
import { DomainError, verifyAccessToken, type AccessTokenClaims } from '@repo/core';
import type { FastifyInstance, FastifyRequest } from 'fastify';

declare module 'fastify' {
  interface FastifyRequest {
    user?: AccessTokenClaims;
  }
  interface FastifyInstance {
    requireAuth: (request: FastifyRequest, reply: FastifyReply) => Promise<void>;
    tryAuth: (request: FastifyRequest, reply: FastifyReply) => Promise<void>;
  }
}

function extractBearerToken(header: string | undefined): string | null {
  if (!header?.startsWith('Bearer ')) {
    return null;
  }
  return header.slice('Bearer '.length).trim() || null;
}

// Extrait la vérification pour que `requireRole` (BE-12) la réutilise sans dupliquer
// l'extraction Bearer + `verifyAccessToken` — un seul endroit qui sait produire un 401.
export async function verifyRequest(request: FastifyRequest): Promise<AccessTokenClaims> {
  const token = extractBearerToken(request.headers.authorization);
  if (!token) {
    throw new DomainError(ACCESS_TOKEN_INVALID, "Token d'accès manquant");
  }

  const result = await verifyAccessToken(token);
  if (!result.ok) {
    const code = result.reason === 'EXPIRED' ? ACCESS_TOKEN_EXPIRED : ACCESS_TOKEN_INVALID;
    throw new DomainError(code, "Token d'accès invalide");
  }

  return result.claims;
}

// preHandler d'auth — à passer explicitement sur chaque route protégée (pas de hook global :
// une route publique doit rester lisible sans avoir à chercher une exception ailleurs).
export function registerRequireAuth(app: FastifyInstance): void {
  app.decorate('requireAuth', async (request: FastifyRequest) => {
    request.user = await verifyRequest(request);
  });

  // BE-21 : première route à accepter authentifié ET anonyme (contact-events). En-tête absent
  // → anonyme, on continue sans lever d'erreur. En-tête présent mais invalide/expiré → on lève
  // quand même (comme requireAuth) : un client qui a tenté de s'authentifier a probablement un
  // bug (token périmé) — le dégrader silencieusement en anonyme fragmenterait son historique de
  // contacts entre son compte et une empreinte de session jetable, sans jamais le signaler.
  app.decorate('tryAuth', async (request: FastifyRequest) => {
    if (!request.headers.authorization) {
      return;
    }
    request.user = await verifyRequest(request);
  });
}
