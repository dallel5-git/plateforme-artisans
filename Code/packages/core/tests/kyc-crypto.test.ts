/**
 * BE-30b — Tests unitaires de la cryptographie KYC (CIN tunisienne).
 *
 * Vérifie :
 * 1. Validation stricte du format de CIN (8 chiffres).
 * 2. Hachage salé SHA-256 (déterministe, gestion du sel).
 * 3. Chiffrement/déchiffrement AES-256-GCM (IV aléatoire, déchiffrement exact, détection d'altération).
 */
import { afterEach, describe, expect, it } from 'vitest';

import {
  decryptCin,
  encryptCin,
  hashCin,
  isValidCin,
} from '../src/security/kyc-crypto.js';

describe('BE-30b — Cryptographie KYC (CIN tunisienne)', () => {
  const originalEnv = { ...process.env };

  afterEach(() => {
    process.env = { ...originalEnv };
  });

  describe('isValidCin', () => {
    it('accepte un numéro de CIN tunisienne valide à 8 chiffres', () => {
      expect(isValidCin('08123456')).toBe(true);
      expect(isValidCin('12345678')).toBe(true);
      expect(isValidCin('  12345678  ')).toBe(true);
    });

    it('rejette les formats invalides', () => {
      expect(isValidCin('1234567')).toBe(false); // 7 chiffres
      expect(isValidCin('123456789')).toBe(false); // 9 chiffres
      expect(isValidCin('1234567a')).toBe(false); // lettres
      expect(isValidCin('abcdefgh')).toBe(false);
      expect(isValidCin('')).toBe(false);
      expect(isValidCin(null as unknown as string)).toBe(false);
      expect(isValidCin(undefined as unknown as string)).toBe(false);
    });
  });

  describe('hashCin', () => {
    it('génère une empreinte SHA-256 déterministe de 64 caractères hexadécimaux', () => {
      const hash1 = hashCin('12345678');
      const hash2 = hashCin('12345678');
      expect(hash1).toBe(hash2);
      expect(hash1).toHaveLength(64);
      expect(/^[0-9a-f]{64}$/.test(hash1)).toBe(true);
    });

    it('génère deux empreintes distinctes pour deux CIN différentes', () => {
      const hash1 = hashCin('12345678');
      const hash2 = hashCin('87654321');
      expect(hash1).not.toBe(hash2);
    });

    it('respecte la variable d’environnement KYC_HASH_SALT', () => {
      process.env.KYC_HASH_SALT = 'sel-personnalise-1';
      const hashSel1 = hashCin('12345678');

      process.env.KYC_HASH_SALT = 'sel-personnalise-2';
      const hashSel2 = hashCin('12345678');

      expect(hashSel1).not.toBe(hashSel2);
    });

    it('lève une erreur si le format de la CIN est invalide', () => {
      expect(() => hashCin('invalide')).toThrow(/Numéro de CIN invalide/);
    });
  });

  describe('encryptCin & decryptCin', () => {
    it('chiffre et déchiffre fidèlement une CIN valide', () => {
      const cin = '09876543';
      const encrypted = encryptCin(cin);

      expect(encrypted).not.toBe(cin);
      expect(encrypted.split(':')).toHaveLength(3); // iv:tag:cipher

      const decrypted = decryptCin(encrypted);
      expect(decrypted).toBe(cin);
    });

    it('produit des chiffrés différents pour le même texte grâce à l’IV aléatoire (non-déterministe)', () => {
      const cin = '12345678';
      const enc1 = encryptCin(cin);
      const enc2 = encryptCin(cin);

      expect(enc1).not.toBe(enc2);
      expect(decryptCin(enc1)).toBe(cin);
      expect(decryptCin(enc2)).toBe(cin);
    });

    it('échoue au déchiffrement si le tag ou le chiffré est altéré', () => {
      const encrypted = encryptCin('12345678');
      const [iv, tag, cipher] = encrypted.split(':');

      // Altération du tag d'authentification
      const corruptedTag = '00' + tag!.slice(2);
      const corruptedPayload = `${iv}:${corruptedTag}:${cipher}`;

      expect(() => decryptCin(corruptedPayload)).toThrow();
    });

    it('lève une erreur si le format chiffré est malformé', () => {
      expect(() => decryptCin('format-invalide')).toThrow(/Format de CIN chiffrée invalide/);
      expect(() => decryptCin('')).toThrow(/Données chiffrées invalides/);
    });
  });
});
