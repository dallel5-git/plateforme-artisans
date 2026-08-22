/**
 * BE-11 — Rate limiting (P10) · `packages/core/src/policies/quotas.ts`
 *
 * Logique pure : ne touche pas Redis. L'appelant (apps/api) fournit le compte déjà incrémenté
 * et le TTL restant de la fenêtre.
 */
import { describe, it, expect } from 'vitest';
import {
  evaluateRateLimit,
  OTP_REQUEST_LIMIT,
  OTP_REQUEST_WINDOW_SECONDS,
  CONTACT_EVENT_LIMIT,
  CONTACT_EVENT_WINDOW_SECONDS,
  PROFILE_VIEW_LIMIT,
  PROFILE_VIEW_WINDOW_SECONDS,
} from '../src/policies/quotas.js';

describe('BE-11 — constantes', () => {
  it('OTP : 5 par heure', () => {
    expect(OTP_REQUEST_LIMIT).toBe(5);
    expect(OTP_REQUEST_WINDOW_SECONDS).toBe(3600);
  });

  it('contacts : 30 par jour (primitif prêt pour BE-21)', () => {
    expect(CONTACT_EVENT_LIMIT).toBe(30);
    expect(CONTACT_EVENT_WINDOW_SECONDS).toBe(86_400);
  });

  it('vues de profil : 200 par jour (primitif prêt pour BE-23)', () => {
    expect(PROFILE_VIEW_LIMIT).toBe(200);
    expect(PROFILE_VIEW_WINDOW_SECONDS).toBe(86_400);
  });
});

describe('BE-11 — evaluateRateLimit', () => {
  it('autorise tant que le compte ne dépasse pas la limite', () => {
    for (let count = 1; count <= 5; count++) {
      const verdict = evaluateRateLimit({ count, limit: 5, ttlSeconds: 1800 });
      expect(verdict.allowed).toBe(true);
    }
  });

  it('bloque la 6ᵉ demande (limite = 5) — critère d’acceptation BE-11', () => {
    const verdict = evaluateRateLimit({ count: 6, limit: 5, ttlSeconds: 1800 });

    expect(verdict.allowed).toBe(false);
  });

  it('le délai d’attente reflète le TTL restant de la fenêtre', () => {
    const verdict = evaluateRateLimit({ count: 6, limit: 5, ttlSeconds: 900 });

    expect(verdict.retryAfterSeconds).toBe(900);
  });

  it('ne renvoie jamais un délai négatif', () => {
    const verdict = evaluateRateLimit({ count: 6, limit: 5, ttlSeconds: -1 });

    expect(verdict.retryAfterSeconds).toBe(0);
  });
});
