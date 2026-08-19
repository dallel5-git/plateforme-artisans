import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    // ranking.test.ts (BE-15) et contacts.test.ts (BE-21) sont des specs ADR-006
    // pré-écrites pour des modules pas encore implémentés — elles échouent au
    // chargement (module introuvable), pas au niveau d'une assertion. `@repo/core`
    // n'avait aucun script `test` avant BE-07 ; les exclure ici évite qu'un chantier
    // sans rapport avec BE-07 se retrouve rouge en CI. À retirer de cette liste par
    // BE-15/BE-21 au fur et à mesure de leur implémentation.
    exclude: ['tests/ranking.test.ts', 'tests/contacts.test.ts'],
  },
});
