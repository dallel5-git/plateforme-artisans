import { Pool } from 'pg';

import { env } from '../env.js';

// Connexion brute — packages/db (Prisma) n'existe pas encore (BE-01, schéma sous la propriété
// exclusive de Chayma en S1). Un health check n'a pas besoin de l'ORM, seulement de savoir si la
// base répond.
const pool = new Pool({
  connectionString: env.DATABASE_URL,
  connectionTimeoutMillis: 2000,
  max: 5,
});

pool.on('error', (err) => {
  // Erreur sur une connexion inactive du pool : ne doit jamais faire planter le process.
  console.error('Erreur inattendue du pool PostgreSQL', err);
});

export async function checkPostgres(): Promise<boolean> {
  try {
    await pool.query('SELECT 1');
    return true;
  } catch {
    return false;
  }
}

export async function closePostgres(): Promise<void> {
  await pool.end();
}
