/**
 * QA-01b — `POST /v1/auth/otp/request`, chemin réel (Postgres + Redis). Complète
 * `auth-otp-request.test.ts` (BE-10b), qui ne couvre que le rejet de format sans base — le
 * harnais nécessaire (QA-01a) n'existait pas encore à l'époque. Chaque cas utilise un numéro ET
 * une IP uniques (compteurs Redis 5/h indépendants par numéro et par IP, BE-11) pour rester
 * isolé des autres tests de ce fichier et de ceux qui tournent en parallèle (voir turbo.json,
 * QA-01a, pour l'ordonnancement qui rend ça sûr).
 */
import { randomUUID } from 'node:crypto';
import { findActiveOtpForVerification } from '@repo/db';
import { createTestClient, randomTestPhoneTn } from '@repo/testing/db-test-utils';
import Fastify from 'fastify';
import {
  serializerCompiler,
  validatorCompiler,
  type ZodTypeProvider,
} from 'fastify-type-provider-zod';
import { describe, expect, it } from 'vitest';
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

describe('QA-01b — POST /v1/auth/otp/request (Postgres + Redis réels)', () => {
  it('sème un OtpCode purpose=SIGNUP pour un numéro inconnu (200 { status: "sent" })', async () => {
    const app = await buildTestApp();
    const phone = randomTestPhoneTn();

    const response = await app.inject({
      method: 'POST',
      url: '/v1/auth/otp/request',
      payload: { phone },
      remoteAddress: randomUUID(),
    });

    expect(response.statusCode).toBe(200);
    expect(response.json()).toEqual({ status: 'sent' });

    const otp = await findActiveOtpForVerification(phone, 'SIGNUP');
    expect(otp).not.toBeNull();
    expect(otp!.userId).toBeNull();
  });

  it('sème un OtpCode purpose=LOGIN pour un numéro déjà lié à un compte', async () => {
    const app = await buildTestApp();
    const client = await createTestClient();

    const response = await app.inject({
      method: 'POST',
      url: '/v1/auth/otp/request',
      payload: { phone: client.phone },
      remoteAddress: randomUUID(),
    });

    expect(response.statusCode).toBe(200);
    const otp = await findActiveOtpForVerification(client.phone, 'LOGIN');
    expect(otp).not.toBeNull();
    expect(otp!.userId).toBe(client.id);
  });

  it('bloque après 5 demandes pour le même numéro (429 RATE_LIMIT_EXCEEDED, OTP_REQUEST_LIMIT)', async () => {
    const app = await buildTestApp();
    const phone = randomTestPhoneTn();

    for (let i = 0; i < 5; i++) {
      const ok = await app.inject({
        method: 'POST',
        url: '/v1/auth/otp/request',
        payload: { phone },
        remoteAddress: randomUUID(),
      });
      expect(ok.statusCode).toBe(200);
    }

    const blocked = await app.inject({
      method: 'POST',
      url: '/v1/auth/otp/request',
      // IP différente de chacune des 5 précédentes : seul le compteur "par numéro" doit bloquer,
      // preuve que les deux compteurs (BE-11) sont bien indépendants.
      payload: { phone },
      remoteAddress: randomUUID(),
    });

    expect(blocked.statusCode).toBe(429);
    expect(blocked.json().error.code).toBe('RATE_LIMIT_EXCEEDED');
    expect(blocked.headers['retry-after']).toBeTruthy();
  });

  it('bloque après 5 demandes depuis la même IP, même avec des numéros différents', async () => {
    const app = await buildTestApp();
    const ip = randomUUID();

    for (let i = 0; i < 5; i++) {
      const ok = await app.inject({
        method: 'POST',
        url: '/v1/auth/otp/request',
        payload: { phone: randomTestPhoneTn() },
        remoteAddress: ip,
      });
      expect(ok.statusCode).toBe(200);
    }

    const blocked = await app.inject({
      method: 'POST',
      url: '/v1/auth/otp/request',
      payload: { phone: randomTestPhoneTn() },
      remoteAddress: ip,
    });

    expect(blocked.statusCode).toBe(429);
    expect(blocked.json().error.code).toBe('RATE_LIMIT_EXCEEDED');
  });
});
