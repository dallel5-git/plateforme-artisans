import { randomUUID } from 'node:crypto';

import cors from '@fastify/cors';
import helmet from '@fastify/helmet';
import Fastify from 'fastify';
import {
  serializerCompiler,
  validatorCompiler,
  type ZodTypeProvider,
} from 'fastify-type-provider-zod';

import { env } from './env.js';
import { registerAuthenticate } from './plugins/authenticate.js';
import { registerErrorHandler } from './plugins/error-handler.js';
import { registerSwagger } from './plugins/swagger.js';
import { authRoutes } from './routes/auth.js';
import { healthRoutes } from './routes/health.js';

export async function buildServer() {
  const app = Fastify({
    genReqId: () => randomUUID(),
    logger:
      env.NODE_ENV === 'development'
        ? {
            level: 'info',
            transport: {
              target: 'pino-pretty',
              options: { translateTime: 'HH:MM:ss', ignore: 'pid,hostname' },
            },
          }
        : { level: 'info' },
  }).withTypeProvider<ZodTypeProvider>();

  app.setValidatorCompiler(validatorCompiler);
  app.setSerializerCompiler(serializerCompiler);
  registerErrorHandler(app);
  registerAuthenticate(app);

  // requestId : déjà dans chaque ligne de log (pino via `logger: true`) ; ce hook l'ajoute aussi
  // à chaque réponse, pour la corrélation client ↔ logs serveur.
  app.addHook('onSend', async (request, reply, payload) => {
    reply.header('x-request-id', request.id);
    return payload;
  });

  await app.register(cors, {
    origin: env.CORS_ORIGIN === '*' ? true : env.CORS_ORIGIN.split(','),
  });

  await app.register(helmet, {
    // La CSP par défaut de helmet bloque les scripts inline de Swagger UI (/docs). API interne,
    // aucun contenu utilisateur servi : désactivée pour l'instant — à revisiter si /docs est un
    // jour exposé publiquement en production.
    contentSecurityPolicy: false,
  });

  await registerSwagger(app);
  await app.register(healthRoutes, { prefix: '/v1' });
  await app.register(authRoutes, { prefix: '/v1' });

  return app;
}
