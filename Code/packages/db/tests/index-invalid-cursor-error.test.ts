// BE-18 : `InvalidCursorError` était défini dans pagination.ts mais jamais réexporté par le
// point d'entrée public `@repo/db` (packages/db/src/index.ts) — aucune route ne pouvait donc la
// capturer (`error instanceof InvalidCursorError` échoue silencieusement si l'import vient d'un
// module différent de celui qui a levé l'erreur). Ce test échoue si l'export est retiré ou
// pointe vers une classe différente de celle réellement levée par `decodeCursor`.
import { describe, expect, it } from 'vitest';
import { InvalidCursorError as InvalidCursorErrorFromIndex } from '../src/index.js';
import { decodeCursor, InvalidCursorError } from '../src/pagination.js';

describe('BE-18 — export public de InvalidCursorError', () => {
  it('@repo/db réexporte la même classe que celle levée par decodeCursor', () => {
    expect(InvalidCursorErrorFromIndex).toBe(InvalidCursorError);
  });

  it('un curseur malformé, décodé via le module public, est bien une instance de cet export', () => {
    expect(() => decodeCursor('!!!invalide!!!')).toThrow(InvalidCursorErrorFromIndex);
  });
});
