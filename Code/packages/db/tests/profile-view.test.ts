// BE-23 : test pur (aucune base) sur `isSessionHashConflict` — même esprit que
// `pagination.test.ts`/`favorites.test.ts` dans ce paquet : le harnais Vitest+Postgres est
// différé (BE-02b). Construit directement une `Prisma.PrismaClientKnownRequestError`, aucune I/O.
// Le comportement réel de `createProfileView` (dédup effective contre une vraie contrainte
// unique) est vérifié manuellement (voir la description de la PR).
import { Prisma } from '@prisma/client';
import { describe, expect, it } from 'vitest';
import { isSessionHashConflict } from '../src/repositories/profile-view.repository.js';

function buildP2002(target: string[]): Prisma.PrismaClientKnownRequestError {
  return new Prisma.PrismaClientKnownRequestError('Unique constraint failed', {
    code: 'P2002',
    clientVersion: '6.19.3',
    meta: { target },
  });
}

describe('isSessionHashConflict', () => {
  it('reconnaît une violation de la contrainte unique (providerId, sessionHash, viewDate) — critère d’acceptation BE-23', () => {
    const error = buildP2002(['providerId', 'sessionHash', 'viewDate']);

    expect(isSessionHashConflict(error)).toBe(true);
  });

  it('ignore un P2002 sur une contrainte différente (ne masque pas une autre erreur)', () => {
    const error = buildP2002(['storageKey']);

    expect(isSessionHashConflict(error)).toBe(false);
  });

  it('ignore un code Prisma différent de P2002', () => {
    const error = new Prisma.PrismaClientKnownRequestError('Record not found', {
      code: 'P2025',
      clientVersion: '6.19.3',
    });

    expect(isSessionHashConflict(error)).toBe(false);
  });

  it('ignore une erreur qui n’est pas une PrismaClientKnownRequestError', () => {
    expect(isSessionHashConflict(new Error('boom'))).toBe(false);
  });
});
