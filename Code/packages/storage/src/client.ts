// BE-20 : S3Client pointé sur Cloudflare R2 (compatible S3). Lit `process.env.R2_*` directement,
// hors du `env.ts` Zod-validé d'`apps/api` — même précédent que `packages/core/src/auth/jwt.ts`
// (JWT_ACCESS_SECRET) : la valeur traverse une frontière de package.
//
// Construction paresseuse (contrairement au singleton `prisma` de `packages/db/src/client.ts`,
// construit eagerly) : importer ce fichier ne doit pas exiger que les variables R2 soient posées
// — sinon un test qui n'a besoin que d'`image-pipeline.ts` (aucun accès réseau, voir
// `tests/image-pipeline.test.ts`) planterait au chargement du module dès qu'il traverse le
// barrel `index.ts`.
import { GetObjectCommand, PutObjectCommand, S3Client } from '@aws-sdk/client-s3';

function requireEnv(name: string): string {
  const value = process.env[name];
  if (!value) {
    throw new Error(`Variable d'environnement manquante : ${name}`);
  }
  return value;
}

const globalForR2 = globalThis as unknown as { r2Client?: S3Client };

export function getR2Client(): S3Client {
  if (globalForR2.r2Client) {
    return globalForR2.r2Client;
  }

  const client = new S3Client({
    region: 'auto',
    endpoint: `https://${requireEnv('R2_ACCOUNT_ID')}.r2.cloudflarestorage.com`,
    credentials: {
      accessKeyId: requireEnv('R2_ACCESS_KEY_ID'),
      secretAccessKey: requireEnv('R2_SECRET_ACCESS_KEY'),
    },
  });

  if (process.env.NODE_ENV !== 'production') {
    globalForR2.r2Client = client;
  }

  return client;
}

export const PUBLIC_BUCKET = 'public-media';

export function requirePublicBucketName(): string {
  return process.env.R2_PUBLIC_BUCKET ?? PUBLIC_BUCKET;
}

/** Utilisé par BE-20c pour récupérer l'original uploadé avant de générer les variantes. */
export async function getObjectBuffer(bucket: string, key: string): Promise<Buffer> {
  const response = await getR2Client().send(new GetObjectCommand({ Bucket: bucket, Key: key }));
  if (!response.Body) {
    throw new Error(`Objet vide ou introuvable : ${bucket}/${key}`);
  }
  const bytes = await response.Body.transformToByteArray();
  return Buffer.from(bytes);
}

/** Utilisé par BE-20c pour téléverser chaque variante WebP générée. */
export async function putObjectBuffer(
  bucket: string,
  key: string,
  body: Buffer,
  contentType: string,
): Promise<void> {
  await getR2Client().send(
    new PutObjectCommand({ Bucket: bucket, Key: key, Body: body, ContentType: contentType }),
  );
}
