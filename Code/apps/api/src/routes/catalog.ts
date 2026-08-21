import { NOT_FOUND } from '@repo/constants';
import { buildCategoryTree, CATALOG_CACHE_TTL_SECONDS, DomainError } from '@repo/core';
import {
  findGovernorateById,
  listActiveDelegationsByGovernorate,
  listActiveGovernorates,
  listAllActiveCategories,
} from '@repo/db';
import {
  categoriesResponseSchema,
  delegationsResponseSchema,
  governorateIdParamsSchema,
  governoratesResponseSchema,
} from '@repo/validators';
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

  typedApp.get(
    '/governorates',
    {
      // public: référentiel figé (P5 exception documentée BE-14), lu au démarrage de session.
      schema: {
        description: '24 gouvernorats, libellés FR et AR. Cache Redis 1h.',
        response: { 200: governoratesResponseSchema },
      },
    },
    async () => {
      const governorates = await getOrSetCache(
        'catalog:governorates:list',
        CATALOG_CACHE_TTL_SECONDS,
        listActiveGovernorates,
      );
      return { governorates };
    },
  );

  typedApp.get(
    '/governorates/:id/delegations',
    {
      // public: référentiel figé (P5 exception documentée BE-14).
      schema: {
        description: 'Délégations actives d’un gouvernorat, libellés FR et AR. Cache Redis 1h.',
        params: governorateIdParamsSchema,
        response: { 200: delegationsResponseSchema },
      },
    },
    async (request) => {
      const { id } = request.params;
      // La vérification d'existence vit à l'intérieur du fetcher : un hit de cache ne doit
      // jamais payer une requête DB supplémentaire. Une réponse 404 n'est jamais mise en cache
      // (le throw a lieu avant l'écriture Redis).
      const delegations = await getOrSetCache(
        `catalog:governorates:${id}:delegations`,
        CATALOG_CACHE_TTL_SECONDS,
        async () => {
          const governorate = await findGovernorateById(id);
          if (!governorate) {
            throw new DomainError(NOT_FOUND, 'Gouvernorat introuvable');
          }
          return listActiveDelegationsByGovernorate(id);
        },
      );
      return { delegations };
    },
  );
}
