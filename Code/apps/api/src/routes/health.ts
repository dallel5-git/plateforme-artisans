import type { FastifyInstance } from 'fastify';
import type { ZodTypeProvider } from 'fastify-type-provider-zod';
import { z } from 'zod';

import { checkPostgres } from '../infra/postgres.js';
import { checkRedis } from '../infra/redis.js';

const healthResponseSchema = z.object({
  status: z.enum(['ok', 'degraded']),
  db: z.enum(['up', 'down']),
  redis: z.enum(['up', 'down']),
});

export async function healthRoutes(app: FastifyInstance): Promise<void> {
  app.withTypeProvider<ZodTypeProvider>().get(
    '/health',
    {
      schema: {
        description:
          'Vérifie la disponibilité réelle de PostgreSQL et Redis (pas un {ok:true} de façade).',
        response: {
          200: healthResponseSchema,
          503: healthResponseSchema,
        },
      },
    },
    async (_request, reply) => {
      const [dbUp, redisUp] = await Promise.all([checkPostgres(), checkRedis()]);
      const allUp = dbUp && redisUp;

      reply.code(allUp ? 200 : 503);

      return {
        status: allUp ? ('ok' as const) : ('degraded' as const),
        db: dbUp ? ('up' as const) : ('down' as const),
        redis: redisUp ? ('up' as const) : ('down' as const),
      };
    },
  );
}
