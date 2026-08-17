import { mkdir, writeFile } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { buildServer } from './server.js';

async function main(): Promise<void> {
  const app = await buildServer();
  await app.ready();

  const document = app.swagger();
  const outputPath = path.resolve(
    path.dirname(fileURLToPath(import.meta.url)),
    '../../../contracts/openapi.json',
  );

  await mkdir(path.dirname(outputPath), { recursive: true });
  await writeFile(outputPath, `${JSON.stringify(document, null, 2)}\n`, 'utf8');
  await app.close();

  console.log(`contrat OpenAPI écrit : ${outputPath}`);
}

main().catch((err: unknown) => {
  console.error(err);
  process.exitCode = 1;
});
