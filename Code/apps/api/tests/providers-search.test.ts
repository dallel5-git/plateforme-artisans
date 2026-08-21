/**
 * BE-16 — `GET /v1/providers/search`. Comme `catalog-governorates.test.ts` : seul le rejet de
 * format (avant tout accès Redis/DB) est couvert ici, sans Postgres. Le happy path (GATE 1,
 * §6.4 : ≥5 items triés, nextCursor, <200ms) est vérifié manuellement en `curl` en local, voir
 * description de PR.
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

describe('BE-16 — GET /v1/providers/search', () => {
  it('rejette une requête sans `governorate` (400 VALIDATION_ERROR)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({ method: 'GET', url: '/v1/providers/search' });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
  });

  it('rejette `limit` > 50 (400 VALIDATION_ERROR)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'GET',
      url: '/v1/providers/search?governorate=sousse&limit=51',
    });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
  });

  it('rejette `minRating` hors [0,5] (400 VALIDATION_ERROR)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'GET',
      url: '/v1/providers/search?governorate=sousse&minRating=6',
    });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
  });

  it('rejette une `availability` hors énumération (400 VALIDATION_ERROR)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'GET',
      url: '/v1/providers/search?governorate=sousse&availability=SIESTE',
    });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
  });
});
