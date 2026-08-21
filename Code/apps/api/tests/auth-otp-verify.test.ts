/**
 * BE-10c — `POST /v1/auth/otp/verify`.
 *
 * Comme `auth-otp-request.test.ts` (BE-10b) : seul le rejet de format (avant tout accès
 * `@repo/db`) est couvert ici, sans Postgres. Le CI ne migre pas le schéma sur le Postgres
 * de service (aucune étape `prisma migrate deploy` dans `.github/workflows/ci.yml`) — un test
 * qui toucherait réellement `users`/`otp_codes`/`sessions` casserait donc en CI même s'il passe
 * en local. Le chemin heureux (création de compte, émission des tokens, rotation) est vérifié
 * manuellement en `curl` en local — voir description de PR.
 */
import Fastify from 'fastify';
import {
  serializerCompiler,
  validatorCompiler,
  type ZodTypeProvider,
} from 'fastify-type-provider-zod';
import { describe, expect, it } from 'vitest';
import { registerRequireAuth } from '../src/plugins/require-auth.js';
import { registerErrorHandler } from '../src/plugins/error-handler.js';
import { authRoutes } from '../src/routes/auth.js';

async function buildTestApp() {
  const app = Fastify().withTypeProvider<ZodTypeProvider>();
  app.setValidatorCompiler(validatorCompiler);
  app.setSerializerCompiler(serializerCompiler);
  registerErrorHandler(app);
  registerRequireAuth(app);
  await app.register(authRoutes, { prefix: '/v1' });
  return app;
}

describe('BE-10c — POST /v1/auth/otp/verify', () => {
  it('rejette un numéro qui ne normalise pas en +216 (400 VALIDATION_ERROR)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'POST',
      url: '/v1/auth/otp/verify',
      payload: { phone: 'abcdefgh', code: '123456' },
    });

    expect(response.statusCode).toBe(400);
    expect(response.json().error.code).toBe('VALIDATION_ERROR');
  });

  it('rejette un code qui ne fait pas 6 chiffres (400, schéma Zod)', async () => {
    const app = await buildTestApp();
    const response = await app.inject({
      method: 'POST',
      url: '/v1/auth/otp/verify',
      payload: { phone: '22999002', code: '123' },
    });

    expect(response.statusCode).toBe(400);
  });
});
