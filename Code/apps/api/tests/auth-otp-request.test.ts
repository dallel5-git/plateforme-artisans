/**
 * BE-10b — `POST /v1/auth/otp/request`.
 *
 * Seul le chemin de rejet (format de téléphone invalide) est couvert ici : il ne touche ni
 * Postgres ni Redis (rejeté par `normalizePhoneTn` avant tout accès `@repo/db`). Le chemin
 * heureux (OTP réellement créé + envoyé) est vérifié manuellement en `curl` en local — voir
 * description de PR, cohérent avec `auth-me.test.ts` (BE-10a).
 */
import Fastify from 'fastify';
import {
  serializerCompiler,
  validatorCompiler,
  type ZodTypeProvider,
} from 'fastify-type-provider-zod';
import { describe, expect, it } from 'vitest';
import { registerAuthenticate } from '../src/plugins/authenticate.js';
import { registerErrorHandler } from '../src/plugins/error-handler.js';
import { authRoutes } from '../src/routes/auth.js';

async function buildTestApp() {
  const app = Fastify().withTypeProvider<ZodTypeProvider>();
  app.setValidatorCompiler(validatorCompiler);
  app.setSerializerCompiler(serializerCompiler);
  registerErrorHandler(app);
  registerAuthenticate(app);
  await app.register(authRoutes, { prefix: '/v1' });
  return app;
}

describe('BE-10b — POST /v1/auth/otp/request', () => {
  it('rejette un numéro qui ne normalise pas en +216 (400 VALIDATION_ERROR)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'POST',
      url: '/v1/auth/otp/request',
      payload: { phone: 'abcdefgh' },
    });

    expect(response.statusCode).toBe(400);
    const body = response.json();
    expect(body.error.code).toBe('VALIDATION_ERROR');
    expect(body.requestId).toBeTruthy();
  });

  it('rejette un corps sans `phone` (400, schéma Zod)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'POST',
      url: '/v1/auth/otp/request',
      payload: {},
    });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
  });
});
