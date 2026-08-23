// QA-01a : vide la base pointée par DATABASE_URL — usage local uniquement, avant de relancer
// `pnpm test` après plusieurs exécutions ayant accumulé des fixtures. `resetTestDatabase` refuse
// de s'exécuter si NODE_ENV=production (P8) ; ce script ne fait rien de plus qu'appeler cette
// garde puis quitter.
import { resetTestDatabase } from '../src/testing.js';

await resetTestDatabase();
console.log('Base de test vidée (TRUNCATE ... RESTART IDENTITY CASCADE).');
