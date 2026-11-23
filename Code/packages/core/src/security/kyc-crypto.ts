// BE-30b : Cryptographie & protection des données d'identité (CIN tunisienne).
// Conformité INPDP (loi n° 2004-63) et ADR-002 :
// - Le numéro de CIN ne doit JAMAIS transiter ni être persisté en clair.
// - `hashCin` : hachage SHA-256 salé déterministe pour recherche d'existence / anti-doublon.
// - `encryptCin` : chiffrement réversible AES-256-GCM (IV 96-bit + Auth Tag 128-bit) pour conservation légale.
import { createCipheriv, createDecipheriv, createHash, randomBytes } from 'node:crypto';

const DEFAULT_SALT = 'dallel-kyc-salt-fallback-v1-dev';
const DEFAULT_SECRET = 'dallel-kyc-encryption-key-fallback-32-bytes!';

/**
 * Valide le format strict d'une carte d'identité nationale (CIN) tunisienne : exactement 8 chiffres.
 */
export function isValidCin(cin: string): boolean {
  if (!cin || typeof cin !== 'string') {
    return false;
  }
  return /^\d{8}$/.test(cin.trim());
}

/**
 * Produit une empreinte SHA-256 salée pour le numéro de CIN.
 * Déterministe : permet la détection d'unicité et la recherche d'existence sans révéler le numéro.
 */
export function hashCin(cin: string): string {
  if (!isValidCin(cin)) {
    throw new Error('Numéro de CIN invalide (doit comporter 8 chiffres)');
  }
  const salt = process.env.KYC_HASH_SALT ?? DEFAULT_SALT;
  return createHash('sha256').update(`${salt}:${cin.trim()}`).digest('hex');
}

function getEncryptionKey(): Buffer {
  const secret = process.env.KYC_ENCRYPTION_KEY ?? DEFAULT_SECRET;
  // Dérive une clé de 256 bits (32 octets) via SHA-256
  return createHash('sha256').update(secret).digest();
}

/**
 * Chiffre le numéro de CIN en AES-256-GCM avec IV aléatoire de 96 bits.
 * Format de sortie sérialisé : `ivHex:authTagHex:encryptedHex`.
 */
export function encryptCin(cin: string): string {
  if (!isValidCin(cin)) {
    throw new Error('Numéro de CIN invalide (doit comporter 8 chiffres)');
  }
  const key = getEncryptionKey();
  const iv = randomBytes(12); // IV standard 96 bits pour AES-GCM
  const cipher = createCipheriv('aes-256-gcm', key, iv);

  const encrypted = Buffer.concat([cipher.update(cin.trim(), 'utf8'), cipher.final()]);
  const authTag = cipher.getAuthTag();

  return `${iv.toString('hex')}:${authTag.toString('hex')}:${encrypted.toString('hex')}`;
}

/**
 * Déchiffre une CIN chiffrée en AES-256-GCM et valide l'intégrité via le tag d'authentification.
 */
export function decryptCin(cipherText: string): string {
  if (!cipherText || typeof cipherText !== 'string') {
    throw new Error('Données chiffrées invalides');
  }

  const parts = cipherText.split(':');
  if (parts.length !== 3) {
    throw new Error('Format de CIN chiffrée invalide (attendu: iv:tag:cipher)');
  }

  const [ivHex, tagHex, encryptedHex] = parts;
  const iv = Buffer.from(ivHex!, 'hex');
  const tag = Buffer.from(tagHex!, 'hex');
  const encrypted = Buffer.from(encryptedHex!, 'hex');

  const key = getEncryptionKey();
  const decipher = createDecipheriv('aes-256-gcm', key, iv);
  decipher.setAuthTag(tag);

  const decrypted = Buffer.concat([decipher.update(encrypted), decipher.final()]);

  return decrypted.toString('utf8');
}
