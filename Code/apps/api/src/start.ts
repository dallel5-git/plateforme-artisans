import { env } from './env.js';
import { closePostgres } from './infra/postgres.js';
import { closeRedis } from './infra/redis.js';
import { buildServer } from './server.js';

async function start(): Promise<void> {
  const app = await buildServer();

  try {
    await app.listen({ host: env.API_HOST, port: env.API_PORT });
  } catch (err) {
    app.log.error(err);
    process.exit(1);
  }

  const shutdown = async (signal: NodeJS.Signals): Promise<void> => {
    app.log.info({ signal }, 'Arrêt en cours...');
    await app.close();
    closeRedis();
    await closePostgres();
    process.exit(0);
  };

  process.on('SIGINT', () => void shutdown('SIGINT'));
  process.on('SIGTERM', () => void shutdown('SIGTERM'));
}

void start();
