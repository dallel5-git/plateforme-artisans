import { describe, it, expect } from 'vitest';
import { hashRefreshToken } from '../src/auth/session.js';

describe('BE-09 — hashRefreshToken', () => {
  it('est déterministe : même entrée, même sortie', () => {
    const tokenId = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890';
    expect(hashRefreshToken(tokenId)).toBe(hashRefreshToken(tokenId));
  });

  it('produit des sorties différentes pour des entrées différentes', () => {
    expect(hashRefreshToken('token-a')).not.toBe(hashRefreshToken('token-b'));
  });

  it('produit un hex SHA-256 (64 caractères)', () => {
    expect(hashRefreshToken('token-quelconque')).toMatch(/^[0-9a-f]{64}$/);
  });
});
