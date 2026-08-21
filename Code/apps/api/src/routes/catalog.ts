import { buildCategoryTree, CATALOG_CACHE_TTL_SECONDS } from '@repo/core';
import { listAllActiveCategories } from '@repo/db';
import { categoriesResponseSchema } from '@repo/validators';
import type { FastifyInstance } from 'fastify';
import type { ZodTypeProvider } from 'fastify-type-provider-zod';

import { getOrSetCache } from '../infra/cache.js';

export async function catalogRoutes(app: FastifyInstance): Promise<void> {
  const typedApp = app.withTypeProvider<ZodTypeProvider>();

  typedApp.get(
    '/categories',
    {
      // public: référentiel figé (P5 exception documentée BE-14 — pas de curseur, borné,
      // écrit uniquement au seed), lu au démarrage de chaque session mobile avant authentification.
      schema: {
        description: 'Arbre complet des catégories, libellés FR et AR. Cache Redis 1h.',
        response: { 200: categoriesResponseSchema },
      },
    },
    async () => {
      const categories = await getOrSetCache(
        'catalog:categories:tree',
        CATALOG_CACHE_TTL_SECONDS,
        async () => buildCategoryTree(await listAllActiveCategories()),
      );
      return { categories };
    },
  );
}
