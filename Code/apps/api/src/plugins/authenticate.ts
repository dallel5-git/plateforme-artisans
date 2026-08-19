import { ACCESS_TOKEN_EXPIRED, ACCESS_TOKEN_INVALID } from '@repo/constants';
import { DomainError, verifyAccessToken, type AccessTokenClaims } from '@repo/core';
import type { FastifyInstance, FastifyRequest } from 'fastify';

declare module 'fastify' {
  interface FastifyRequest {
    user?: AccessTokenClaims;
  }
  interface FastifyInstance {
    authenticate: (request: FastifyRequest, reply: FastifyReply) => Promise<void>;
  }
}

function extractBearerToken(header: string | undefined): string | null {
  if (!header?.startsWith('Bearer ')) {
    return null;
  }
  return header.slice('Bearer '.length).trim() || null;
}

// preHandler d'auth — à passer explicitement sur chaque route protégée (pas de hook global :
// une route publique doit rester lisible sans avoir à chercher une exception ailleurs).
export function registerAuthenticate(app: FastifyInstance): void {
  app.decorate('authenticate', async (request: FastifyRequest) => {
    const token = extractBearerToken(request.headers.authorization);
    if (!token) {
      throw new DomainError(ACCESS_TOKEN_INVALID, "Token d'accès manquant");
    }

    const result = await verifyAccessToken(token);
    if (!result.ok) {
      const code = result.reason === 'EXPIRED' ? ACCESS_TOKEN_EXPIRED : ACCESS_TOKEN_INVALID;
      throw new DomainError(code, "Token d'accès invalide");
    }

    request.user = result.claims;
  });
}
