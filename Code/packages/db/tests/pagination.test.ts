// BE-05 : tests purs (aucune base) sur la pagination par curseur — la construction du curseur
// et du where keyset est une pure fonction, testable indépendamment du harnais Vitest+Postgres
// différé (BE-02b). La stabilité à l'insertion contre une vraie base est vérifiée manuellement
// (voir la PR) faute de ce harnais.
import { describe, expect, it } from 'vitest';
import {
  DEFAULT_PAGE_SIZE,
  InvalidCursorError,
  MAX_PAGE_SIZE,
  buildKeysetOrderBy,
  buildKeysetWhere,
  buildPage,
  decodeCursor,
  encodeCursor,
  resolveLimit,
} from '../src/pagination.js';

describe('encodeCursor / decodeCursor', () => {
  it('fait un aller-retour fidèle pour une valeur string', () => {
    const cursor = encodeCursor('2026-08-18T12:00:00.000Z', 'abc-123');
    expect(decodeCursor(cursor)).toEqual({ v: '2026-08-18T12:00:00.000Z', id: 'abc-123' });
  });

  it('fait un aller-retour fidèle pour une valeur numérique', () => {
    const cursor = encodeCursor(4.6667, 'xyz-789');
    expect(decodeCursor(cursor)).toEqual({ v: 4.6667, id: 'xyz-789' });
  });

  it("l'encodage n'est pas une simple chaîne lisible (opaque)", () => {
    const cursor = encodeCursor('secret-ish-value', 'id-1');
    expect(cursor).not.toContain('secret-ish-value');
  });

  it('rejette un curseur non base64', () => {
    expect(() => decodeCursor('!!!pas-du-base64!!!')).toThrow(InvalidCursorError);
  });

  it('rejette un curseur base64 valide mais dont le contenu JSON est incomplet', () => {
    const malformed = Buffer.from(JSON.stringify({ onlyV: 'x' }), 'utf8').toString('base64url');
    expect(() => decodeCursor(malformed)).toThrow(InvalidCursorError);
  });

  it("rejette un curseur dont l'id n'est pas une chaîne", () => {
    const malformed = Buffer.from(JSON.stringify({ v: 'x', id: 42 }), 'utf8').toString('base64url');
    expect(() => decodeCursor(malformed)).toThrow(InvalidCursorError);
  });
});

describe('resolveLimit', () => {
  it('renvoie la valeur par défaut si absente', () => {
    expect(resolveLimit(undefined)).toBe(DEFAULT_PAGE_SIZE);
  });

  it('plafonne à MAX_PAGE_SIZE', () => {
    expect(resolveLimit(5000)).toBe(MAX_PAGE_SIZE);
  });

  it('plancher à 1 (jamais 0 ni négatif)', () => {
    expect(resolveLimit(0)).toBe(1);
    expect(resolveLimit(-10)).toBe(1);
  });

  it('tronque les valeurs non entières', () => {
    expect(resolveLimit(15.9)).toBe(15);
  });
});

describe('buildKeysetWhere', () => {
  it('renvoie undefined sans curseur (première page)', () => {
    expect(buildKeysetWhere('rankingScore', 'desc')).toBeUndefined();
  });

  it('construit un OR (gt strict, égalité + id gt) en tri ascendant', () => {
    const cursor = encodeCursor(10, 'id-5');
    expect(buildKeysetWhere('createdAt', 'asc', cursor)).toEqual({
      OR: [{ createdAt: { gt: 10 } }, { createdAt: 10, id: { gt: 'id-5' } }],
    });
  });

  it('utilise lt (pas gt) en tri descendant', () => {
    const cursor = encodeCursor(10, 'id-5');
    expect(buildKeysetWhere('rankingScore', 'desc', cursor)).toEqual({
      OR: [{ rankingScore: { lt: 10 } }, { rankingScore: 10, id: { gt: 'id-5' } }],
    });
  });
});

describe('buildKeysetOrderBy', () => {
  it('trie toujours par le champ demandé puis par id (id est le départage stable)', () => {
    expect(buildKeysetOrderBy('rankingScore', 'desc')).toEqual([{ rankingScore: 'desc' }, { id: 'asc' }]);
  });
});

describe('buildPage', () => {
  const rows = (n: number) =>
    Array.from({ length: n }, (_, i) => ({ id: `id-${i}`, sort: i }));

  it("ne renvoie pas de curseur suivant s'il n'y a pas de page suivante", () => {
    const page = buildPage(rows(3), 5, (r) => r.sort);
    expect(page.items).toHaveLength(3);
    expect(page.nextCursor).toBeNull();
  });

  it("tronque à `limit` et fabrique un curseur suivant s'il y a une ligne en trop", () => {
    const page = buildPage(rows(6), 5, (r) => r.sort);
    expect(page.items).toHaveLength(5);
    expect(page.items.at(-1)?.id).toBe('id-4');
    expect(page.nextCursor).toBe(encodeCursor(4, 'id-4'));
  });

  it('page vide -> aucun curseur', () => {
    const page = buildPage(rows(0), 5, (r) => r.sort);
    expect(page.items).toHaveLength(0);
    expect(page.nextCursor).toBeNull();
  });
});
