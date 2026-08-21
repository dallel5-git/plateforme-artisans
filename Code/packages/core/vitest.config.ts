import { defineConfig, configDefaults } from 'vitest/config';

export default defineConfig({
  test: {
    // contacts.test.ts (BE-21) est une spec ADR-006 pré-écrite pour un module pas encore
    // implémenté — elle échoue au chargement (module introuvable), pas au niveau d'une
    // assertion. `@repo/core` n'avait aucun script `test` avant BE-07 ; l'exclure ici évite
    // qu'un chantier sans rapport avec BE-07 se retrouve rouge en CI. À retirer de cette
    // liste par BE-21 au fur et à mesure de son implémentation (ranking.test.ts, BE-15,
    // en a été retiré : `computeRankingScore` existe désormais).
    //
    // On repart des exclusions par défaut de Vitest (dont node_modules) — les
    // écraser plutôt que les étendre ferait exécuter les tests des paquets liés en
    // workspace (ex. @repo/db/tests/*.test.ts, symlinké par pnpm).
    exclude: [...configDefaults.exclude, 'tests/contacts.test.ts'],
  },
});
