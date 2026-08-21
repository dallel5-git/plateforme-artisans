/**
 * BE-18 — `GET /v1/providers/:slug/reviews`. Comme `providers-profile.test.ts` : sans `slug` de
 * format contraint et sans accès DB possible ici, la preuve DB-free se limite à (1) la
 * compilation des schémas Zod au démarrage et (2) au rejet de `limit` hors bornes, qui se
 * produit avant tout accès DB (validation Fastify/Zod pré-handler). Le rejet d'un `cursor`
 * malformé (`InvalidCursorError` → 400 VALIDATION_ERROR) ne peut PAS être prouvé ici : il ne se
 * déclenche qu'après un premier appel DB réussi (`requirePublishedProfile`) — vérifié
 * manuellement contre le seed (voir description de PR), même limite déjà acceptée pour le
 * `cursor` de `providers-search.test.ts`. Les AC BE-18 (tri décroissant, stabilité à
 * l'insertion, anonymisation d'un avis d'un compte supprimé) sont vérifiées manuellement contre
 * le seed local — la stabilité de la pagination est déjà couverte génériquement par
 * `packages/db/tests/pagination.test.ts` (BE-05, non modifié), et l'anonymisation par
 * `buildReviewAuthorDisplayName` (packages/core/tests/reviews-display-name.test.ts, BE-18a).
 */
import Fastify from 'fastify';
import {
  serializerCompiler,
  validatorCompiler,
  type ZodTypeProvider,
} from 'fastify-type-provider-zod';
import { describe, expect, it } from 'vitest';
import { registerErrorHandler } from '../src/plugins/error-handler.js';
import { registerRequireAuth } from '../src/plugins/require-auth.js';
import { registerRequireRole } from '../src/plugins/require-role.js';
import { providersRoutes } from '../src/routes/providers.js';

// `providersRoutes` contient aussi les routes `/providers/me*` (BE-19), gardées par
// `app.requireAuth`/`app.requireRole` — ces décorateurs doivent exister avant l'enregistrement
// des routes, même si ce fichier ne teste que le volet public.
async function buildTestApp() {
  const app = Fastify().withTypeProvider<ZodTypeProvider>();
  app.setValidatorCompiler(validatorCompiler);
  app.setSerializerCompiler(serializerCompiler);
  registerErrorHandler(app);
  registerRequireAuth(app);
  registerRequireRole(app);
  await app.register(providersRoutes, { prefix: '/v1' });
  return app;
}

describe('BE-18 — GET /v1/providers/:slug/reviews', () => {
  it('enregistre la route et compile les schémas Zod (params + query + réponse) sans erreur', async () => {
    const app = await buildTestApp();
    await expect(app.ready()).resolves.not.toThrow();
  });

  it('rejette `limit` > 50 (400 VALIDATION_ERROR)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'GET',
      url: '/v1/providers/some-slug/reviews?limit=51',
    });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
  });

  it('rejette `limit` < 1 (400 VALIDATION_ERROR)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'GET',
      url: '/v1/providers/some-slug/reviews?limit=0',
    });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
  });
});
