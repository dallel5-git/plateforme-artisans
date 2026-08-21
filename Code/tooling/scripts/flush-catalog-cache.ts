// BE-14d : invalidation du cache Redis du catalogue (catégories/gouvernorats/délégations) après
// un seed. Script autonome, hors `packages/db`, qui reste volontairement sans dépendance Redis
// (référentiel figé, écrit uniquement par le seed — cf. commentaires en tête des repositories).
// Chaîné après `prisma db seed` dans le script pnpm `db:seed` à la racine, jamais dans
// `db:seed:dev` (fixtures démo BE-04, ne touche pas categories/governorates/delegations).
//
// Fail-open : REDIS_URL absent ou Redis injoignable → avertissement, sortie 0. Un seed local
// sans Redis démarré (ou une CI qui seed sans service Redis) ne doit jamais échouer pour ça.
import { Redis } from 'ioredis';

const CATALOG_KEY_PATTERN = 'catalog:*';
const SCAN_BATCH_SIZE = 100;

async function flushCatalogCache(redis: Redis): Promise<number> {
  let cursor = '0';
  let deleted = 0;
  do {
    const [nextCursor, keys] = await redis.scan(
      cursor,
      'MATCH',
      CATALOG_KEY_PATTERN,
      'COUNT',
      SCAN_BATCH_SIZE,
    );
    cursor = nextCursor;
    if (keys.length > 0) {
      deleted += await redis.unlink(...keys);
    }
  } while (cursor !== '0');
  return deleted;
}

async function main(): Promise<void> {
  const url = process.env.REDIS_URL;
  if (!url) {
    console.warn('REDIS_URL absent — cache catalogue non invalidé (pas bloquant).');
    return;
  }

  const redis = new Redis(url, {
    maxRetriesPerRequest: 1,
    connectTimeout: 2000,
    lazyConnect: true,
  });
  try {
    await redis.connect();
    const deleted = await flushCatalogCache(redis);
    console.log(`Cache catalogue invalidé : ${deleted} clé(s) supprimée(s).`);
  } catch (err) {
    console.warn('Échec invalidation cache catalogue (non bloquant) :', err);
  } finally {
    redis.disconnect();
  }
}

main();
