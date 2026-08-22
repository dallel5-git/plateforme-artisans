/**
 * BE-23c — `POST /v1/profile-views`. Comme `contact-events.test.ts` (BE-21d) : seul le rejet de
 * format (avant tout accès Postgres/Redis) est couvert ici. Le comportement réel — dédup 24h,
 * agrégat DailyProviderStat, incrément totalProfileViews — est vérifié manuellement en local (CI
 * ne joue aucune migration sur son Postgres, gap préexistant BE-02b), voir la description de la PR.
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
import { profileViewsRoutes } from '../src/routes/profile-views.js';

// `profileViewsRoutes` utilise `app.tryAuth` (preHandler) — décoré par `registerRequireAuth`
// (BE-21c), qui doit donc être enregistré même si ce fichier ne teste que le rejet de format.
async function buildTestApp() {
  const app = Fastify().withTypeProvider<ZodTypeProvider>();
  app.setValidatorCompiler(validatorCompiler);
  app.setSerializerCompiler(serializerCompiler);
  registerErrorHandler(app);
  registerRequireAuth(app);
  await app.register(profileViewsRoutes, { prefix: '/v1' });
  return app;
}

describe('BE-23c — POST /v1/profile-views', () => {
  it('rejette un `providerId` qui n’est pas un UUID (400 VALIDATION_ERROR)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'POST',
      url: '/v1/profile-views',
      payload: { providerId: 'pas-un-uuid' },
    });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
  });

  it('rejette un `source` hors énumération (400 VALIDATION_ERROR)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'POST',
      url: '/v1/profile-views',
      payload: {
        providerId: '3c884497-1e37-45d3-95c2-beb49592844e',
        source: 'not-a-valid-source',
      },
    });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
  });

  it('rejette une requête sans corps (400 VALIDATION_ERROR)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({ method: 'POST', url: '/v1/profile-views' });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
  });
});
