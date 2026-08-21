/**
 * BE-12 — RBAC (P3) · `packages/core/src/policies/rbac.ts`
 *
 * Logique pure : ne connaît ni Fastify ni Prisma. `resource` est une forme minimale
 * `{ ownerId }` — l'appelant extrait la clé de propriété réelle (`clientId`, `userId`...)
 * avant d'appeler `can()`.
 */
import { describe, it, expect } from 'vitest';
import { can } from '../src/policies/rbac.js';
import type { AccessTokenClaims } from '../src/auth/jwt.js';

const client = (id: string): AccessTokenClaims => ({ sub: id, role: 'CLIENT' });
const provider = (id: string): AccessTokenClaims => ({ sub: id, role: 'PROVIDER' });
const admin = (id: string): AccessTokenClaims => ({ sub: id, role: 'ADMIN' });
const superAdmin = (id: string): AccessTokenClaims => ({ sub: id, role: 'SUPER_ADMIN' });

describe('BE-12 — can()', () => {
  it('un client modifie son propre avis', () => {
    expect(can(client('u1'), 'update', { ownerId: 'u1' })).toBe(true);
  });

  it("un client ne modifie pas l'avis d'un autre", () => {
    expect(can(client('u1'), 'update', { ownerId: 'u2' })).toBe(false);
  });

  it('un artisan modifie son propre profil', () => {
    expect(can(provider('u1'), 'update', { ownerId: 'u1' })).toBe(true);
  });

  it("un artisan ne modifie pas le profil d'un autre artisan", () => {
    expect(can(provider('u1'), 'update', { ownerId: 'u2' })).toBe(false);
  });

  it('un admin modifie une ressource qui ne lui appartient pas — "un admin tout"', () => {
    expect(can(admin('admin-1'), 'update', { ownerId: 'u2' })).toBe(true);
    expect(can(admin('admin-1'), 'delete', { ownerId: 'u2' })).toBe(true);
  });

  it('un super_admin modifie une ressource qui ne lui appartient pas', () => {
    expect(can(superAdmin('root'), 'delete', { ownerId: 'u2' })).toBe(true);
  });

  it("un rôle sans règle spécifique (MODERATOR) n'a pas de bypass — deny par défaut", () => {
    const moderator: AccessTokenClaims = { sub: 'm1', role: 'MODERATOR' };
    expect(can(moderator, 'update', { ownerId: 'u2' })).toBe(false);
  });
});
