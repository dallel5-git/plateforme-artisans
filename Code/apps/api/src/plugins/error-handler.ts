import { INTERNAL_ERROR, VALIDATION_ERROR } from '@repo/constants';
import { DomainError } from '@repo/core';
import type { FastifyInstance } from 'fastify';
import { hasZodFastifySchemaValidationErrors } from 'fastify-type-provider-zod';

// Enveloppe unique pour toute erreur d'API (CLAUDE.md §4.3) : { error: {code, message, details},
// requestId }. `message` est destiné au développeur ; le client traduit localement à partir de `code`.
export function registerErrorHandler(app: FastifyInstance): void {
  app.setErrorHandler((error, request, reply) => {
    if (error instanceof DomainError) {
      for (const [name, value] of Object.entries(error.headers ?? {})) {
        reply.header(name, value);
      }
      reply.code(error.httpStatus).send({
        error: { code: error.code, message: error.message, details: error.details ?? {} },
        requestId: request.id,
      });
      return;
    }

    if (hasZodFastifySchemaValidationErrors(error)) {
      reply.code(400).send({
        error: {
          code: VALIDATION_ERROR,
          message: 'Requête invalide',
          details: { issues: error.validation },
        },
        requestId: request.id,
      });
      return;
    }

    // Jamais de stack trace en réponse — même en développement (P8 : uniformité, pas de fuite
    // d'implémentation). Le détail complet reste dans le log serveur.
    request.log.error({ err: error }, 'Erreur non gérée');
    reply.code(500).send({
      error: { code: INTERNAL_ERROR, message: 'Erreur interne', details: {} },
      requestId: request.id,
    });
  });
}
