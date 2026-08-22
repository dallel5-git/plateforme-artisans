import { VALIDATION_ERROR } from '@repo/constants';
import {
  buildFavoriteListItem,
  DomainError,
  requirePublishedProfile,
  type FavoriteListItem,
} from '@repo/core';
import {
  addFavorite,
  findProviderProfileById,
  findProviderProfilesByIds,
  InvalidCursorError,
  listFavoritesForUser,
  removeFavorite,
} from '@repo/db';
import {
  favoriteListResponseSchema,
  favoriteParamsSchema,
  favoriteResponseSchema,
  favoritesQuerySchema,
  type FavoritesQuery,
} from '@repo/validators';
import type { FastifyInstance } from 'fastify';
import type { ZodTypeProvider } from 'fastify-type-provider-zod';

import { enforceFavoriteRateLimit } from '../plugins/rate-limit.js';

// BE-25 : même garde `requirePublishedProfile` que `handleCreateProviderReview` (BE-22) — un
// providerId inexistant et un profil non publié restent indistinguables (404 dans les deux cas).
async function handleAddFavorite(userId: string, providerId: string) {
  await enforceFavoriteRateLimit(userId);
  const provider = requirePublishedProfile(await findProviderProfileById(providerId));
  return addFavorite(userId, provider.id);
}

// Pas de vérification d'existence du prestataire côté DELETE : suppression idempotente
// (removeFavorite est un deleteMany silencieux), pas de fuite d'information à protéger ici.
async function handleRemoveFavorite(userId: string, providerId: string): Promise<void> {
  await removeFavorite(userId, providerId);
}

// Même geste que `loadReviewsPage` (BE-18c) pour `InvalidCursorError` -> VALIDATION_ERROR.
// Hydratation par lots (findProviderProfilesByIds, BE-25b) pour éviter le N+1 ; un favori dont
// le prestataire aurait disparu entre-temps (cascade FK, ne devrait jamais arriver) est
// silencieusement omis plutôt que de faire échouer toute la page.
async function loadFavoritesPage(
  userId: string,
  query: FavoritesQuery,
): Promise<{ items: FavoriteListItem[]; nextCursor: string | null }> {
  try {
    const page = await listFavoritesForUser(userId, query);
    const providers = await findProviderProfilesByIds(page.items.map((f) => f.providerId));
    const providersById = new Map(providers.map((provider) => [provider.id, provider]));

    const items = page.items.flatMap((favorite) => {
      const provider = providersById.get(favorite.providerId);
      return provider ? [buildFavoriteListItem(favorite, provider)] : [];
    });

    return { items, nextCursor: page.nextCursor };
  } catch (error) {
    if (error instanceof InvalidCursorError) {
      throw new DomainError(VALIDATION_ERROR, 'Curseur de pagination invalide', {
        field: 'cursor',
      });
    }
    throw error;
  }
}

export async function favoritesRoutes(app: FastifyInstance): Promise<void> {
  const typedApp = app.withTypeProvider<ZodTypeProvider>();

  typedApp.put(
    '/favorites/:providerId',
    {
      preHandler: [app.requireAuth],
      schema: {
        description:
          'Ajoute un prestataire aux favoris du client authentifié — idempotent (clé composite ' +
          '(userId, providerId), deux appels successifs ne créent jamais de doublon). 404 si le ' +
          "prestataire n'existe pas ou n'est pas publié.",
        params: favoriteParamsSchema,
        response: { 200: favoriteResponseSchema },
      },
    },
    async (request) => handleAddFavorite(request.user!.sub, request.params.providerId),
  );

  typedApp.delete(
    '/favorites/:providerId',
    {
      preHandler: [app.requireAuth],
      schema: {
        description:
          'Retire un prestataire des favoris du client authentifié — idempotent, 204 même si le ' +
          "favori n'existait pas.",
        params: favoriteParamsSchema,
      },
    },
    async (request, reply) => {
      await handleRemoveFavorite(request.user!.sub, request.params.providerId);
      reply.code(204);
    },
  );

  typedApp.get(
    '/favorites',
    {
      preHandler: [app.requireAuth],
      schema: {
        description:
          "Favoris du client authentifié, triés par date d'ajout décroissante, pagination par " +
          'curseur.',
        querystring: favoritesQuerySchema,
        response: { 200: favoriteListResponseSchema },
      },
    },
    async (request) => loadFavoritesPage(request.user!.sub, request.query),
  );
}
