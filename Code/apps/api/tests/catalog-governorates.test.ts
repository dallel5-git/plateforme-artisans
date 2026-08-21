/**
 * BE-14c — `GET /v1/governorates/:id/delegations`.
 *
 * Comme `auth-otp-verify.test.ts` : seul le rejet de format (avant tout accès `@repo/db`/Redis)
 * est couvert ici, sans Postgres. Le vrai 404 (UUID bien formé mais gouvernorat inexistant) et
 * les deux happy paths (`/governorates`, `/governorates/:id/delegations`) sont vérifiés
 * manuellement en `curl` en local — voir description de PR.
 */
import Fastify from 'fastify';
import {
  serializerCompiler,
  validatorCompiler,
  type ZodTypeProvider,
} from 'fastify-type-provider-zod';
import { describe, expect, it } from 'vitest';
import { registerErrorHandler } from '../src/plugins/error-handler.js';
import { catalogRoutes } from '../src/routes/catalog.js';

async function buildTestApp() {
  const app = Fastify().withTypeProvider<ZodTypeProvider>();
  app.setValidatorCompiler(validatorCompiler);
  app.setSerializerCompiler(serializerCompiler);
  registerErrorHandler(app);
  await app.register(catalogRoutes, { prefix: '/v1' });
  return app;
}

describe('BE-14c — GET /v1/governorates/:id/delegations', () => {
  it('rejette un id de gouvernorat malformé (400 VALIDATION_ERROR, sans toucher Redis/DB)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'GET',
      url: '/v1/governorates/not-a-uuid/delegations',
    });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
  });
});
