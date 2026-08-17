import { mkdir, readFile, writeFile } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { buildServer } from './server.js';

const CHECK = process.argv.includes('--check');

async function main(): Promise<void> {
  const app = await buildServer();
  await app.ready();

  const document = app.swagger();
  const content = `${JSON.stringify(document, null, 2)}\n`;
  const outputPath = path.resolve(
    path.dirname(fileURLToPath(import.meta.url)),
    '../../../contracts/openapi.json',
  );

  await app.close();

  if (CHECK) {
    const current = await readFile(outputPath, 'utf8').catch(() => null);
    if (current !== content) {
      console.error(
        `✗ contrat OpenAPI périmé : ${outputPath} diffère des schémas Zod actuels.\n` +
          'Lancer `pnpm api:contract` et commiter le résultat.',
      );
      process.exitCode = 1;
      return;
    }
    console.log('✓ contrat OpenAPI à jour');
    return;
  }

  await mkdir(path.dirname(outputPath), { recursive: true });
  await writeFile(outputPath, content, 'utf8');

  console.log(`contrat OpenAPI écrit : ${outputPath}`);
}

main().catch((err: unknown) => {
  console.error(err);
  process.exitCode = 1;
});
