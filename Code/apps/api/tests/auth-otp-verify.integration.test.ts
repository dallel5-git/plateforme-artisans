/**
 * QA-01b — `POST /v1/auth/otp/verify`, chemin réel (Postgres). Complète
 * `auth-otp-verify.test.ts` (BE-10c), qui ne couvre que le rejet de format sans base. `code`
 * n'est jamais lisible depuis la réponse de `POST /auth/otp/request` (anti-énumération, P8) —
 * `createTestOtpCode` (@repo/testing) sème directement le hash pour pouvoir présenter le code
 * en clair ici, exactement comme le ferait un utilisateur qui l'a reçu par SMS.
 */
import { findUserByPhone } from '@repo/db';
import {
  createTestClient,
  createTestOtpCode,
  randomTestPhoneTn,
} from '@repo/testing/db-test-utils';
import Fastify from 'fastify';
import {
  serializerCompiler,
  validatorCompiler,
  type ZodTypeProvider,
} from 'fastify-type-provider-zod';
import { describe, expect, it, vi } from 'vitest';
import { registerErrorHandler } from '../src/plugins/error-handler.js';
import { registerRequireAuth } from '../src/plugins/require-auth.js';
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

describe('QA-01b — POST /v1/auth/otp/verify (Postgres réel)', () => {
  it('crée le compte (SIGNUP), émet les tokens, et consomme le code (200)', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const phone = randomTestPhoneTn();
    const { code } = await createTestOtpCode(phone, { purpose: 'SIGNUP' });

    const response = await app.inject({
      method: 'POST',
      url: '/v1/auth/otp/verify',
      payload: { phone, code },
    });

    expect(response.statusCode).toBe(200);
    const body = response.json();
    expect(body.accessToken).toBeTruthy();
    expect(body.refreshToken).toContain('.');
    expect(body.user.phone).toBe(phone);
    expect(body.user.roles).toEqual(['CLIENT']);

    const created = await findUserByPhone(phone);
    expect(created).not.toBeNull();
    expect(created!.status).toBe('ACTIVE');
    expect(created!.phoneVerifiedAt).not.toBeNull();

    vi.unstubAllEnvs();
  });

  it('réutilise le compte existant pour un code LOGIN, sans en recréer un second', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const client = await createTestClient();
    const { code } = await createTestOtpCode(client.phone, {
      purpose: 'LOGIN',
      userId: client.id,
    });

    const response = await app.inject({
      method: 'POST',
      url: '/v1/auth/otp/verify',
      payload: { phone: client.phone, code },
    });

    expect(response.statusCode).toBe(200);
    expect(response.json().user.id).toBe(client.id);

    vi.unstubAllEnvs();
  });

  it('rejette un code correct mais déjà consommé (401 OTP_EXPIRED — plus aucun OTP actif)', async () => {
    const app = await buildTestApp();
    const phone = randomTestPhoneTn();
    const { code } = await createTestOtpCode(phone);

    // Premier essai : consomme le code (le statut de cette réponse n'est pas l'objet du test).
    await app.inject({ method: 'POST', url: '/v1/auth/otp/verify', payload: { phone, code } });

    const replay = await app.inject({
      method: 'POST',
      url: '/v1/auth/otp/verify',
      payload: { phone, code },
    });

    expect(replay.statusCode).toBe(401);
    expect(replay.json().error.code).toBe('OTP_EXPIRED');
  });

  it('rejette un code faux et incrémente les tentatives (401 OTP_INVALID)', async () => {
    const app = await buildTestApp();
    const phone = randomTestPhoneTn();
    await createTestOtpCode(phone, { code: '111111' });

    const response = await app.inject({
      method: 'POST',
      url: '/v1/auth/otp/verify',
      payload: { phone, code: '999999' },
    });

    expect(response.statusCode).toBe(401);
    expect(response.json().error.code).toBe('OTP_INVALID');
  });

  it('bloque après 3 tentatives fausses (429 OTP_TOO_MANY_ATTEMPTS, maxAttempts par défaut)', async () => {
    const app = await buildTestApp();
    const phone = randomTestPhoneTn();
    await createTestOtpCode(phone, { code: '111111' });

    for (let i = 0; i < 3; i++) {
      const attempt = await app.inject({
        method: 'POST',
        url: '/v1/auth/otp/verify',
        payload: { phone, code: '999999' },
      });
      expect(attempt.json().error.code).toBe('OTP_INVALID');
    }

    const blocked = await app.inject({
      method: 'POST',
      url: '/v1/auth/otp/verify',
      payload: { phone, code: '999999' },
    });

    expect(blocked.statusCode).toBe(429);
    expect(blocked.json().error.code).toBe('OTP_TOO_MANY_ATTEMPTS');
  });

  it('rejette un code expiré (401 OTP_EXPIRED)', async () => {
    const app = await buildTestApp();
    const phone = randomTestPhoneTn();
    const { code } = await createTestOtpCode(phone, { expiresAt: new Date(Date.now() - 1000) });

    const response = await app.inject({
      method: 'POST',
      url: '/v1/auth/otp/verify',
      payload: { phone, code },
    });

    expect(response.statusCode).toBe(401);
    expect(response.json().error.code).toBe('OTP_EXPIRED');
  });
});
