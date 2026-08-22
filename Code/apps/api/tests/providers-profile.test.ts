/**
 * BE-17 — `GET /v1/providers/:slug`. Comme `providers-search.test.ts` : sans `slug` de format
 * contraint (juste non-vide) et sans accès DB possible ici, la seule preuve DB-free est que les
 * schémas Zod (params + réponse) se compilent au démarrage de l'app. Les 3 critères
 * d'acceptation bout-en-bout (aucun téléphone dans la réponse, 404 sur profil non publié,
 * `displayPrice` formaté) sont vérifiés manuellement contre le seed local (voir description de
 * PR) — le 404 « non publié » est déjà couvert côté `packages/core`
 * (`providers-public-profile.test.ts`, `requirePublishedProfile`).
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

// `providersRoutes` (BE-16/17 + BE-19) contient aussi les routes `/providers/me*`, gardées par
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

describe('BE-17 — GET /v1/providers/:slug', () => {
  it('enregistre la route et compile les schémas Zod (params + réponse) sans erreur', async () => {
    const app = await buildTestApp();
    await expect(app.ready()).resolves.not.toThrow();
  });

  it('404 sur une route inexistante hors du préfixe `/v1/providers`', async () => {
    const app = await buildTestApp();
    const response = await app.inject({ method: 'GET', url: '/v1/providers' });

    expect(response.statusCode).toBe(404);
  });
});
