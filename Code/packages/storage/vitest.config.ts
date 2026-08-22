import { defineConfig } from 'vitest/config';

// Le test du critère d'acceptation BE-20 génère une image de test à haute résolution (sharp,
// bruit + flou) avant de la faire passer dans `generateWebpVariants` — largement sous les 5 s
// par défaut en local, mais un runner CI partagé peut être sensiblement plus lent.
export default defineConfig({
  test: {
    testTimeout: 20_000,
  },
});
