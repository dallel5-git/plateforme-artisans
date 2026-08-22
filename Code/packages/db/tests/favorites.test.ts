// BE-25b : test pur (aucune base) sur `findProviderProfilesByIds` — même esprit que
// `provider-search.test.ts` dans ce paquet : le harnais Vitest+Postgres est différé (BE-02b).
// Seule la branche testable sans base est couverte ici (tableau vide en entrée = tableau vide en
// sortie, avant toute requête Prisma) ; le comportement réel de la requête (hydratation par lots,
// jointure avec `Favorite`) est vérifié manuellement contre le seed de démo (voir la description
// de la PR de la route, BE-25c).
import { describe, expect, it } from 'vitest';
import { findProviderProfilesByIds } from '../src/repositories/provider-profile.repository.js';

describe('findProviderProfilesByIds', () => {
  it('renvoie un tableau vide sans toucher la base pour une liste vide', async () => {
    await expect(findProviderProfilesByIds([])).resolves.toEqual([]);
  });
});
