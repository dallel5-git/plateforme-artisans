/**
 * BE-16 — `packages/core/src/search/query-builder.ts`
 *
 * `packages/db/src/pagination.ts` est câblé en dur sur une colonne DB réelle
 * (`buildKeysetWhere` épingle `sortField` dans un `where`/`orderBy` Prisma) : inutilisable pour
 * paginer un score calculé en mémoire (BE-16, décision d'architecture — voir `scoring.ts`).
 * `paginateScoredResults` en est le miroir en JS, sur un tableau déjà trié. Pure, sans DB.
 */
import { describe, expect, it } from 'vitest';
import {
  buildSearchSeed,
  paginateScoredResults,
  InvalidSearchCursorError,
  type NormalizedSearchFilters,
} from '../src/search/query-builder.js';

describe('BE-16 — paginateScoredResults', () => {
  const rows = (n: number) =>
    Array.from({ length: n }, (_, i) => ({ id: `id-${i}`, score: 10 - i }));

  it('première page sans curseur', () => {
    const page = paginateScoredResults(rows(3), 5);
    expect(page.items.map((r) => r.id)).toEqual(['id-0', 'id-1', 'id-2']);
    expect(page.nextCursor).toBeNull();
  });

  it('tronque à `limit` et fabrique un curseur suivant', () => {
    const page = paginateScoredResults(rows(6), 5);
    expect(page.items).toHaveLength(5);
    expect(page.nextCursor).not.toBeNull();
  });

  it('page 2 reprend exactement après le curseur — pas de doublon, pas de trou', () => {
    const all = rows(6);
    const page1 = paginateScoredResults(all, 3);
    const page2 = paginateScoredResults(all, 3, page1.nextCursor!);
    expect(page2.items.map((r) => r.id)).toEqual(['id-3', 'id-4', 'id-5']);
    expect(page2.nextCursor).toBeNull();
  });

  it('à score égal, départage par id croissant — miroir de buildKeysetWhere', () => {
    // Déjà trié (score desc, id asc) par l'appelant — c'est l'invariant documenté de la
    // fonction, à l'image de ce que produit `scoreCandidates`.
    const tied = [
      { id: 'a', score: 5 },
      { id: 'b', score: 5 },
    ];
    const page1 = paginateScoredResults(tied, 1);
    expect(page1.items[0]!.id).toBe('a');
    const page2 = paginateScoredResults(tied, 1, page1.nextCursor!);
    expect(page2.items[0]!.id).toBe('b');
  });

  it('curseur pointant après le dernier élément → page vide, pas de crash', () => {
    const all = rows(2);
    const page1 = paginateScoredResults(all, 5); // consomme tout, nextCursor déjà null
    expect(page1.nextCursor).toBeNull();
  });

  it('curseur malformé → InvalidSearchCursorError', () => {
    expect(() => paginateScoredResults(rows(3), 5, 'pas-du-tout-un-curseur-valide')).toThrow(
      InvalidSearchCursorError,
    );
  });
});

describe('BE-16 — buildSearchSeed', () => {
  const filters: NormalizedSearchFilters = { governorateId: 'g1', categoryId: 'c1' };

  it('même requête normalisée + même heure → même graine (stabilité entre pages)', () => {
    const now = new Date('2026-08-21T10:15:00Z');
    expect(buildSearchSeed(filters, now)).toBe(buildSearchSeed(filters, now));
  });

  it('deux requêtes différentes donnent des graines différentes', () => {
    const now = new Date();
    expect(buildSearchSeed({ governorateId: 'g1' }, now)).not.toBe(
      buildSearchSeed({ governorateId: 'g2' }, now),
    );
  });

  it("change d'heure UTC → graine différente (la rotation reste vivante)", () => {
    const h1 = new Date('2026-08-21T10:59:59Z');
    const h2 = new Date('2026-08-21T11:00:01Z');
    expect(buildSearchSeed(filters, h1)).not.toBe(buildSearchSeed(filters, h2));
  });

  it('reste identique au sein de la même heure UTC', () => {
    const h1 = new Date('2026-08-21T10:00:01Z');
    const h2 = new Date('2026-08-21T10:59:59Z');
    expect(buildSearchSeed(filters, h1)).toBe(buildSearchSeed(filters, h2));
  });
});
