import { SignJWT, jwtVerify, errors as joseErrors } from 'jose';
import type { UserRole } from '@repo/db';
import { ACCESS_TTL_MINUTES } from './session.js';

const encoder = new TextEncoder();

function requireSecret(): Uint8Array {
  const secret = process.env.JWT_ACCESS_SECRET;
  if (!secret) {
    throw new Error('JWT_ACCESS_SECRET est requis pour signer/vérifier les access tokens');
  }
  return encoder.encode(secret);
}

export interface AccessTokenClaims {
  sub: string;
  role: UserRole;
}

export async function signAccessToken(claims: AccessTokenClaims): Promise<string> {
  return new SignJWT({ role: claims.role })
    .setProtectedHeader({ alg: 'HS256' })
    .setSubject(claims.sub)
    .setIssuedAt()
    .setExpirationTime(`${ACCESS_TTL_MINUTES}m`)
    .sign(requireSecret());
}

export type VerifyAccessTokenResult =
  { ok: true; claims: AccessTokenClaims } | { ok: false; reason: 'EXPIRED' | 'INVALID' };

export async function verifyAccessToken(token: string): Promise<VerifyAccessTokenResult> {
  try {
    const { payload } = await jwtVerify(token, requireSecret());
    return {
      ok: true,
      claims: { sub: payload.sub as string, role: payload.role as UserRole },
    };
  } catch (error) {
    if (error instanceof joseErrors.JWTExpired) {
      return { ok: false, reason: 'EXPIRED' };
    }
    return { ok: false, reason: 'INVALID' };
  }
}
