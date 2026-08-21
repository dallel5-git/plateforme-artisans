/**
 * BE-13 — Erreurs normalisées · `packages/core/src/errors/`
 */
import { describe, it, expect } from 'vitest';
import {
  OTP_EXPIRED,
  VALIDATION_ERROR,
  INTERNAL_ERROR,
  RATE_LIMIT_EXCEEDED,
} from '@repo/constants';
import { DomainError } from '../src/errors/domain-error.js';
import { ERROR_HTTP_STATUS } from '../src/errors/codes.js';

describe('BE-13 — DomainError', () => {
  it('dérive le statut HTTP du code, jamais choisi par l’appelant', () => {
    const error = new DomainError(OTP_EXPIRED, 'Le code a expiré');

    expect(error.code).toBe(OTP_EXPIRED);
    expect(error.httpStatus).toBe(ERROR_HTTP_STATUS[OTP_EXPIRED]);
    expect(error.httpStatus).toBe(401);
  });

  it('porte des détails optionnels, jamais de donnée sensible par défaut', () => {
    const error = new DomainError(VALIDATION_ERROR, 'Requête invalide', { field: 'phone' });

    expect(error.details).toEqual({ field: 'phone' });
  });

  it('est une Error standard (stack, instanceof) pour rester catchable partout', () => {
    const error = new DomainError(INTERNAL_ERROR, 'Erreur interne');

    expect(error).toBeInstanceOf(Error);
    expect(error).toBeInstanceOf(DomainError);
    expect(error.name).toBe('DomainError');
  });

  it('chaque code a un statut HTTP défini — aucun trou dans la table', () => {
    const codes = [OTP_EXPIRED, VALIDATION_ERROR, INTERNAL_ERROR] as const;
    for (const code of codes) {
      expect(ERROR_HTTP_STATUS[code]).toBeGreaterThanOrEqual(400);
    }
  });

  it('porte des en-têtes optionnels (BE-11 : `Retry-After` sur un 429)', () => {
    const error = new DomainError(RATE_LIMIT_EXCEEDED, 'Trop de demandes', undefined, {
      'Retry-After': '42',
    });

    expect(error.headers).toEqual({ 'Retry-After': '42' });
    expect(error.httpStatus).toBe(429);
  });

  it('les en-têtes restent `undefined` par défaut', () => {
    const error = new DomainError(OTP_EXPIRED, 'Le code a expiré');

    expect(error.headers).toBeUndefined();
  });
});
