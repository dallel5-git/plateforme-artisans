import { describe, it, expect, vi, afterEach } from 'vitest';
import { SignJWT } from 'jose';
import { signAccessToken, verifyAccessToken } from '../src/auth/jwt.js';

describe('BE-09 — JWT access token', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('signe puis vérifie un token, en conservant sub et role', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');

    const token = await signAccessToken({ sub: 'user-1', role: 'PROVIDER' });
    const result = await verifyAccessToken(token);

    expect(result.ok).toBe(true);
    if (result.ok) {
      expect(result.claims.sub).toBe('user-1');
      expect(result.claims.role).toBe('PROVIDER');
    }
  });

  it("distingue un token expiré (EXPIRED) d'un token invalide (INVALID)", async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const secret = new TextEncoder().encode('secret-de-test-suffisamment-long');

    const expiredToken = await new SignJWT({ role: 'CLIENT' })
      .setProtectedHeader({ alg: 'HS256' })
      .setSubject('user-1')
      .setIssuedAt(0)
      .setExpirationTime(60)
      .sign(secret);

    const expiredResult = await verifyAccessToken(expiredToken);
    expect(expiredResult).toEqual({ ok: false, reason: 'EXPIRED' });

    const invalidResult = await verifyAccessToken('ceci-n-est-pas-un-jwt');
    expect(invalidResult).toEqual({ ok: false, reason: 'INVALID' });
  });

  it('rejette un token signé avec un autre secret', async () => {
    const autreSecret = new TextEncoder().encode('un-tout-autre-secret');
    const token = await new SignJWT({ role: 'ADMIN' })
      .setProtectedHeader({ alg: 'HS256' })
      .setSubject('user-1')
      .setIssuedAt()
      .setExpirationTime('15m')
      .sign(autreSecret);

    vi.stubEnv('JWT_ACCESS_SECRET', 'secret-de-test-suffisamment-long');
    const result = await verifyAccessToken(token);

    expect(result).toEqual({ ok: false, reason: 'INVALID' });
  });

  it('lève une erreur explicite si JWT_ACCESS_SECRET est absent', async () => {
    vi.stubEnv('JWT_ACCESS_SECRET', '');
    await expect(signAccessToken({ sub: 'user-1', role: 'CLIENT' })).rejects.toThrow(
      /JWT_ACCESS_SECRET/,
    );
  });
});
