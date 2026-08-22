// BE-20 : génère les 3 variantes WebP d'une photo de galerie (US-P-04). Fonction quasi-pure —
// aucun accès réseau/R2 ici, uniquement `sharp` (traitement CPU en mémoire) — mais elle vit dans
// `packages/storage` plutôt que `packages/core` : elle dépend d'un binding natif (P3 vise
// React/HTTP, pas les dépendances natives), et n'a pas de volet "métier" distinct de l'appel
// `sharp` lui-même qui justifierait une séparation.
import sharp, { type Sharp } from 'sharp';

export const ACCEPTED_MIME_TYPES = ['image/jpeg', 'image/png', 'image/webp'] as const;
export type AcceptedMimeType = (typeof ACCEPTED_MIME_TYPES)[number];

// US-P-04 : "compression client avant envoi (max 2 Mo par image après compression)" — marge
// serveur au-delà de ce que le client est censé envoyer, pour absorber un client qui ne
// compresse pas (ou le cas de test du critère d'acceptation : 4 Mo en entrée).
export const MAX_UPLOAD_SIZE_BYTES = 8 * 1024 * 1024;

export const WEBP_QUALITY = 80;

export type MediaVariant = 'thumb' | 'card' | 'full';

const VARIANT_MAX_EDGE: Record<MediaVariant, number> = {
  thumb: 200,
  card: 600,
  full: 1600,
};

export interface GeneratedVariant {
  variant: MediaVariant;
  buffer: Buffer;
  width: number;
  height: number;
}

async function toWebpVariant(image: Sharp, variant: MediaVariant): Promise<GeneratedVariant> {
  const maxEdge = VARIANT_MAX_EDGE[variant];
  const resized = image
    .clone()
    .resize({ width: maxEdge, height: maxEdge, fit: 'inside', withoutEnlargement: true })
    .webp({ quality: WEBP_QUALITY });

  const buffer = await resized.toBuffer();
  const metadata = await sharp(buffer).metadata();

  return {
    variant,
    buffer,
    width: metadata.width ?? maxEdge,
    height: metadata.height ?? maxEdge,
  };
}

export interface GeneratedVariants {
  thumb: GeneratedVariant;
  card: GeneratedVariant;
  full: GeneratedVariant;
}

/** Redimensionne par plus grand côté, jamais d'agrandissement — une image plus petite que la
 *  cible d'une variante est simplement conservée à sa taille d'origine, en WebP. */
export async function generateWebpVariants(original: Buffer): Promise<GeneratedVariants> {
  const source = sharp(original);
  const [thumb, card, full] = await Promise.all([
    toWebpVariant(source, 'thumb'),
    toWebpVariant(source, 'card'),
    toWebpVariant(source, 'full'),
  ]);

  return { thumb, card, full };
}
