import fastifySwagger from '@fastify/swagger';
import fastifySwaggerUi from '@fastify/swagger-ui';
import type { FastifyInstance } from 'fastify';
import { jsonSchemaTransform, jsonSchemaTransformObject } from 'fastify-type-provider-zod';

export async function registerSwagger(app: FastifyInstance): Promise<void> {
  await app.register(fastifySwagger, {
    openapi: {
      openapi: '3.1.0',
      info: {
        title: 'Sanaya API',
        description:
          'API de la plateforme Sanaya — mise en relation particuliers ⇄ artisans (Tunisie).',
        version: '0.1.0',
      },
    },
    transform: jsonSchemaTransform,
    // BE-14 : requis pour que les schémas récursifs (`categoryTreeNodeSchema`, enregistrés via
    // `z.globalRegistry`) se résolvent en `$ref` vers `components.schemas` plutôt qu'un `$ref`
    // sans définition.
    transformObject: jsonSchemaTransformObject,
  });

  await app.register(fastifySwaggerUi, {
    routePrefix: '/docs',
  });
}
