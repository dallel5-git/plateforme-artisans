import { defineConfig, configDefaults } from 'vitest/config';

export default defineConfig({
  test: {
    // On repart des exclusions par défaut de Vitest (dont node_modules) — les
    // écraser plutôt que les étendre ferait exécuter les tests des paquets liés en
    // workspace (ex. @repo/db/tests/*.test.ts, symlinké par pnpm).
    exclude: [...configDefaults.exclude],
  },
});
