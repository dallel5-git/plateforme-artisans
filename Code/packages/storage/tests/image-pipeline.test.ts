/**
 * BE-20a — `generateWebpVariants` (`packages/storage/src/image-pipeline.ts`).
 *
 * Critère d'acceptation BE-20 : "une image de 4 Mo est servie en moins de 150 ko en WebP".
 * L'image de test est générée par `sharp` lui-même (bruit gaussien, quasi-incompressible) plutôt
 * que commitée comme fixture binaire — aucun accès réseau/R2 nécessaire, entièrement vérifiable
 * en CI. Générée une seule fois (`beforeAll`) et réutilisée par les tests qui en ont besoin :
 * cette génération est la partie coûteuse (résolution ~12 Mpx) — la refaire à chaque `it()`
 * ralentit inutilement la suite et peut approcher le budget CI sur un runner partagé.
 */
import sharp from 'sharp';
import { beforeAll, describe, expect, it } from 'vitest';
import {
  generateWebpVariants,
  type GeneratedVariants,
  WEBP_QUALITY,
} from '../src/image-pipeline.js';

async function buildLargeTestImage(): Promise<Buffer> {
  // Résolution native élevée (proche d'une vraie photo de smartphone, ~12 Mpx) avec du bruit
  // gaussien modéré : lourd en JPEG à cette résolution, mais le fort ratio de réduction vers la
  // variante `full` (1600 px, soit > 2×) moyenne une grande partie du bruit haute fréquence —
  // comme le ferait le vrai détail d'une photo réelle en la redimensionnant. Une image bruitée
  // générée directement à 1600 px (peu ou pas de sous-échantillonnage) resterait artificiellement
  // incompressible et ne refléterait pas le cas réel visé par le critère d'acceptation.
  return (
    sharp({
      create: {
        width: 6000,
        height: 4500,
        channels: 3,
        background: { r: 128, g: 128, b: 128 },
        noise: { type: 'gaussian', mean: 128, sigma: 35 },
      },
    })
      // Un flou léger corrèle les pixels voisins — une vraie photo a du détail spatialement
      // cohérent (grain, texture de tissu, feuillage), pas du bruit blanc décorrélé pixel à pixel
      // sur 100 % du cadre (aucune photo réelle n'est intégralement texturée d'un bord à l'autre).
      // Sans ça, l'image de test reste artificiellement incompressible même après redimensionnement
      // et ne prouve rien sur le cas réel visé par le critère d'acceptation.
      .blur(2)
      .jpeg({ quality: 90 })
      .toBuffer()
  );
}

describe('BE-20a — generateWebpVariants', () => {
  let source: Buffer;
  let variants: GeneratedVariants;

  beforeAll(async () => {
    source = await buildLargeTestImage();
    variants = await generateWebpVariants(source);
  }, 20_000);

  it('génère une image source d’au moins 3 Mo (fidélité au critère d’acceptation "4 Mo")', () => {
    expect(source.length).toBeGreaterThan(3 * 1024 * 1024);
  });

  it('la variante `full` d’une image de ~4 Mo pèse moins de 150 ko en WebP — critère d’acceptation BE-20', () => {
    expect(variants.full.buffer.length).toBeLessThan(150 * 1024);
  });

  it('les 3 variantes respectent leurs dimensions maximales (200/600/1600 px, plus grand côté)', () => {
    const { thumb, card, full } = variants;

    expect(Math.max(thumb.width, thumb.height)).toBeLessThanOrEqual(200);
    expect(Math.max(card.width, card.height)).toBeLessThanOrEqual(600);
    expect(Math.max(full.width, full.height)).toBeLessThanOrEqual(1600);
  });

  it('produit bien du WebP (magic bytes RIFF/WEBP) pour chaque variante', () => {
    for (const variant of [variants.thumb, variants.card, variants.full]) {
      expect(variant.buffer.subarray(0, 4).toString('ascii')).toBe('RIFF');
      expect(variant.buffer.subarray(8, 12).toString('ascii')).toBe('WEBP');
    }
  });

  it('ne redimensionne jamais à la hausse une image plus petite que la cible', async () => {
    const small = await sharp({
      create: { width: 100, height: 80, channels: 3, background: { r: 200, g: 100, b: 50 } },
    })
      .jpeg()
      .toBuffer();

    const { thumb } = await generateWebpVariants(small);

    expect(thumb.width).toBeLessThanOrEqual(100);
    expect(thumb.height).toBeLessThanOrEqual(80);
  });

  it('la qualité WebP configurée est 80 (compromis taille/netteté pour la galerie)', () => {
    expect(WEBP_QUALITY).toBe(80);
  });
});
