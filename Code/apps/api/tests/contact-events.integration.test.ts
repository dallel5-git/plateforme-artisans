/**
 * QA-01c — `POST /v1/contact-events`, chemin réel (Postgres + Redis). Complète
 * `contact-events.test.ts` (BE-21d), qui ne couvre que le rejet de format sans base — le
 * comportement réel (révélation du numéro, dédup, agrégat transactionnel) était vérifié
 * manuellement en local faute de harnais (BE-02b, absorbé par QA-01a).
 */
import { signAccessToken } from '@repo/core';
import { findProviderProfileById } from '@repo/db';
import { createTestClient, createTestProvider } from '@repo/testing/db-test-utils';
import Fastify from 'fastify';
import {
  serializerCompiler,
  validatorCompiler,
  type ZodTypeProvider,
} from 'fastify-type-provider-zod';
import { describe, expect, it, vi } from 'vitest';
import { registerErrorHandler } from '../src/plugins/error-handler.js';
import { registerRequireAuth } from '../src/plugins/require-auth.js';
import { contactsRoutes } from '../src/routes/contacts.js';

async function buildTestApp() {
  const app = Fastify().withTypeProvider<ZodTypeProvider>();
  app.setValidatorCompiler(validatorCompiler);
  app.setSerializerCompiler(serializerCompiler);
  registerErrorHandler(app);
  registerRequireAuth(app);
  await app.register(contactsRoutes, { prefix: '/v1' });
  return app;
}

describe('QA-01c — POST /v1/contact-events (Postgres + Redis réels)', () => {
  it('révèle le numéro, trace le contact et incrémente totalContacts — visiteur anonyme, PHONE', async () => {
    const app = await buildTestApp();
    const provider = await createTestProvider({ publicPhone: '+21620123456' });

    const response = await app.inject({
      method: 'POST',
      url: '/v1/contact-events',
      payload: { providerId: provider.providerId, channel: 'PHONE' },
      headers: { 'x-device-id': 'device-anonyme-1' },
      remoteAddress: '10.0.0.1',
    });

    expect(response.statusCode).toBe(200);
    const body = response.json();
    expect(body.phone).toBe('+21620123456');
    expect(body.deduplicated).toBe(false);
    expect(body.whatsappMessage).toBeUndefined();

    const updated = await findProviderProfileById(provider.providerId);
    expect(updated!.totalContacts).toBe(1);
  });

  it('révèle le numéro WhatsApp et construit le message — client authentifié', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const app = await buildTestApp();
    const provider = await createTestProvider({ whatsappPhone: '+21698765432' });
    const client = await createTestClient();
    const accessToken = await signAccessToken({ sub: client.id, role: 'CLIENT' });

    const response = await app.inject({
      method: 'POST',
      url: '/v1/contact-events',
      payload: { providerId: provider.providerId, channel: 'WHATSAPP' },
      headers: {
        authorization: `Bearer ${accessToken}`,
        'x-device-id': 'device-client-1',
      },
      remoteAddress: '10.0.0.2',
    });

    expect(response.statusCode).toBe(200);
    const body = response.json();
    expect(body.phone).toBe('+21698765432');
    expect(body.whatsappMessage).toBeTruthy();

    vi.unstubAllEnvs();
  });

  it('déduplique deux clics identiques (même session, même canal) sous 30 min — même contactEventId', async () => {
    const app = await buildTestApp();
    const provider = await createTestProvider({ publicPhone: '+21620123457' });
    const headers = { 'x-device-id': 'device-dedup-1' };
    const remoteAddress = '10.0.0.3';

    const first = await app.inject({
      method: 'POST',
      url: '/v1/contact-events',
      payload: { providerId: provider.providerId, channel: 'PHONE' },
      headers,
      remoteAddress,
    });
    expect(first.json().deduplicated).toBe(false);

    const second = await app.inject({
      method: 'POST',
      url: '/v1/contact-events',
      payload: { providerId: provider.providerId, channel: 'PHONE' },
      headers,
      remoteAddress,
    });

    expect(second.statusCode).toBe(200);
    expect(second.json().deduplicated).toBe(true);
    expect(second.json().contactEventId).toBe(first.json().contactEventId);

    // Le deuxième clic ne recompte pas un deuxième contact — sinon les statistiques vendues à
    // l'artisan seraient gonflées par un simple double-clic (voir CLAUDE.md §7, "Lead / Contact").
    const updated = await findProviderProfileById(provider.providerId);
    expect(updated!.totalContacts).toBe(1);
  });

  it('ne déduplique pas deux canaux différents sur la même session (deux ContactEvent distincts)', async () => {
    const app = await buildTestApp();
    const provider = await createTestProvider({
      publicPhone: '+21620123458',
      whatsappPhone: '+21698765433',
    });
    const headers = { 'x-device-id': 'device-dedup-2' };
    const remoteAddress = '10.0.0.4';

    const phoneCall = await app.inject({
      method: 'POST',
      url: '/v1/contact-events',
      payload: { providerId: provider.providerId, channel: 'PHONE' },
      headers,
      remoteAddress,
    });
    const whatsapp = await app.inject({
      method: 'POST',
      url: '/v1/contact-events',
      payload: { providerId: provider.providerId, channel: 'WHATSAPP' },
      headers,
      remoteAddress,
    });

    expect(whatsapp.json().deduplicated).toBe(false);
    expect(whatsapp.json().contactEventId).not.toBe(phoneCall.json().contactEventId);
  });

  it('rejette un artisan non publié (404 NOT_FOUND)', async () => {
    const app = await buildTestApp();
    const provider = await createTestProvider({
      publicationStatus: 'DRAFT',
      publicPhone: '+21620123459',
    });

    const response = await app.inject({
      method: 'POST',
      url: '/v1/contact-events',
      payload: { providerId: provider.providerId, channel: 'PHONE' },
      headers: { 'x-device-id': 'device-draft-1' },
    });

    expect(response.statusCode).toBe(404);
    expect(response.json().error.code).toBe('NOT_FOUND');
  });

  it('rejette un canal sans numéro renseigné (422 PROVIDER_CONTACT_CHANNEL_UNAVAILABLE)', async () => {
    const app = await buildTestApp();
    const provider = await createTestProvider({ publicPhone: '+21620123460' });

    const response = await app.inject({
      method: 'POST',
      url: '/v1/contact-events',
      payload: { providerId: provider.providerId, channel: 'WHATSAPP' },
      headers: { 'x-device-id': 'device-no-whatsapp-1' },
    });

    expect(response.statusCode).toBe(422);
    expect(response.json().error.code).toBe('PROVIDER_CONTACT_CHANNEL_UNAVAILABLE');
  });
});
