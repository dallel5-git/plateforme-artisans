/**
 * BE-21d — `POST /v1/contact-events`. Comme `providers-search.test.ts` : seul le rejet de
 * format (avant tout accès Postgres/Redis) est couvert ici. Le comportement réel — révélation
 * du numéro, dédup, agrégat transactionnel — est vérifié manuellement en local (CI ne joue
 * aucune migration sur son Postgres, gap préexistant BE-02b), voir la description de la PR.
 *
 * BE-45 — `GET /v1/contact-events`. Même limite : seuls les rejets qui n'ont pas besoin de
 * Postgres sont couverts ici (401, 400 de format) — le comportement réel (isolation par
 * client, pagination) est dans `contact-events-history.integration.test.ts`.
 */
import { signAccessToken } from '@repo/core';
import Fastify from 'fastify';
import {
  serializerCompiler,
  validatorCompiler,
  type ZodTypeProvider,
} from 'fastify-type-provider-zod';
import { afterEach, describe, expect, it, vi } from 'vitest';
import { registerErrorHandler } from '../src/plugins/error-handler.js';
import { registerRequireAuth } from '../src/plugins/require-auth.js';
import { contactsRoutes } from '../src/routes/contacts.js';

// `contactsRoutes` utilise `app.tryAuth` (preHandler) — décoré par `registerRequireAuth`
// (BE-21c), qui doit donc être enregistré même si ce fichier ne teste que le rejet de format.
async function buildTestApp() {
  const app = Fastify().withTypeProvider<ZodTypeProvider>();
  app.setValidatorCompiler(validatorCompiler);
  app.setSerializerCompiler(serializerCompiler);
  registerErrorHandler(app);
  registerRequireAuth(app);
  await app.register(contactsRoutes, { prefix: '/v1' });
  return app;
}

describe('BE-21d — POST /v1/contact-events', () => {
  it('rejette un `providerId` qui n’est pas un UUID (400 VALIDATION_ERROR)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'POST',
      url: '/v1/contact-events',
      payload: { providerId: 'pas-un-uuid', channel: 'PHONE' },
    });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
  });

  it('rejette un `channel` hors PHONE/WHATSAPP — y compris IN_APP_MESSAGE (400 VALIDATION_ERROR)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'POST',
      url: '/v1/contact-events',
      payload: {
        providerId: '3c884497-1e37-45d3-95c2-beb49592844e',
        channel: 'IN_APP_MESSAGE',
      },
    });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
  });

  it('rejette un `categoryId` qui n’est pas un UUID (400 VALIDATION_ERROR)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'POST',
      url: '/v1/contact-events',
      payload: {
        providerId: '3c884497-1e37-45d3-95c2-beb49592844e',
        channel: 'PHONE',
        categoryId: 'pas-un-uuid',
      },
    });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
  });

  it('rejette une requête sans corps (400 VALIDATION_ERROR)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({ method: 'POST', url: '/v1/contact-events' });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
  });
});

describe('BE-45 — GET /v1/contact-events', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('refuse une requête sans token (401 ACCESS_TOKEN_INVALID)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({ method: 'GET', url: '/v1/contact-events' });

    expect(response.statusCode).toBe(401);
    expect(response.json().error.code).toBe('ACCESS_TOKEN_INVALID');
  });

  it('rejette un `limit` hors bornes (400 VALIDATION_ERROR)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const token = await signAccessToken({ sub: 'u1', role: 'CLIENT' });
    const response = await app.inject({
      method: 'GET',
      url: '/v1/contact-events?limit=500',
      headers: { authorization: `Bearer ${token}` },
    });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
  });
});
