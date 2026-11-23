/**
 * BE-30a — Tests unitaires du coffre-fort numérique Cloudflare R2 privé (kyc-vault.ts).
 *
 * Vérifie :
 * 1. La construction normalisée des clés de stockage KYC (`kyc/${providerId}/${requestId}/${side}.jpg`).
 * 2. La résolution du nom de bucket hermétique (`private-kyc` par défaut ou override variable d'env).
 * 3. La pré-signature PUT pour upload direct client avec TTL strict 10 min et chiffrement SSE-S3 AES-256.
 * 4. La pré-signature GET pour consultation admin éphémère avec TTL strict 5 min maximum.
 * 5. La lecture et suppression sécurisées d'objets binaires dans le bucket privé.
 */
import {
  DeleteObjectCommand,
  GetObjectCommand,
  PutObjectCommand,
  type S3Client,
} from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';

import * as r2ClientModule from '../src/client.js';
import {
  buildKycStorageKey,
  deleteKycObject,
  getKycObjectBuffer,
  KYC_READ_TTL_SECONDS,
  KYC_UPLOAD_TTL_SECONDS,
  presignKycRead,
  presignKycUpload,
  PRIVATE_KYC_BUCKET,
  requireKycBucketName,
} from '../src/kyc-vault.js';

vi.mock('@aws-sdk/s3-request-presigner', () => ({
  getSignedUrl: vi.fn(),
}));


describe('BE-30a — Coffre-fort numérique Cloudflare R2 privé (kyc-vault)', () => {
  const originalEnv = { ...process.env };
  const mockSend = vi.fn();
  const mockS3Client = { send: mockSend } as unknown as S3Client;

  beforeEach(() => {
    vi.clearAllMocks();
    vi.spyOn(r2ClientModule, 'getR2Client').mockReturnValue(mockS3Client);
  });

  afterEach(() => {
    process.env = { ...originalEnv };
    vi.restoreAllMocks();
  });

  describe('Constantes et configuration', () => {
    it('définit le bucket privé par défaut à private-kyc', () => {
      delete process.env.R2_KYC_BUCKET;
      expect(PRIVATE_KYC_BUCKET).toBe('private-kyc');
      expect(requireKycBucketName()).toBe('private-kyc');
    });

    it('respecte la surcharge via la variable R2_KYC_BUCKET', () => {
      process.env.R2_KYC_BUCKET = 'custom-private-kyc';
      expect(requireKycBucketName()).toBe('custom-private-kyc');
    });

    it('le TTL upload est strictement de 10 minutes (600s)', () => {
      expect(KYC_UPLOAD_TTL_SECONDS).toBe(600);
    });

    it('le TTL lecture admin est strictement de 5 minutes max (300s)', () => {
      expect(KYC_READ_TTL_SECONDS).toBe(300);
    });
  });

  describe('buildKycStorageKey', () => {
    it('construit la clé avec le format standardisé kyc/providerId/requestId/side.jpg', () => {
      const keyRecto = buildKycStorageKey('prov-123', 'req-456', 'recto');
      expect(keyRecto).toBe('kyc/prov-123/req-456/recto.jpg');

      const keyVerso = buildKycStorageKey('prov-123', 'req-456', 'verso');
      expect(keyVerso).toBe('kyc/prov-123/req-456/verso.jpg');
    });

    it('normalise front vers recto et back vers verso', () => {
      const keyFront = buildKycStorageKey('prov-123', 'req-456', 'front');
      expect(keyFront).toBe('kyc/prov-123/req-456/recto.jpg');

      const keyBack = buildKycStorageKey('prov-123', 'req-456', 'back');
      expect(keyBack).toBe('kyc/prov-123/req-456/verso.jpg');
    });

    it('accepte un type de document spécifique comme side personnalisé', () => {
      const keySelfie = buildKycStorageKey('prov-123', 'req-456', 'selfie');
      expect(keySelfie).toBe('kyc/prov-123/req-456/selfie.jpg');
    });
  });

  describe('presignKycUpload', () => {
    it('génère une URL PUT pré-signée avec chiffrement SSE-S3 AES-256 et TTL 600s', async () => {
      const fakeSignedUrl = 'https://r2.cloudflarestorage.com/private-kyc/upload-url?sig=abc';
      const mockedGetSignedUrl = vi.mocked(getSignedUrl).mockResolvedValue(fakeSignedUrl);

      const before = Date.now();
      const result = await presignKycUpload('kyc/prov-1/req-1/recto.jpg', 'image/jpeg');
      const after = Date.now();

      expect(mockedGetSignedUrl).toHaveBeenCalledTimes(1);
      const call = mockedGetSignedUrl.mock.calls[0];
      expect(call).toBeDefined();
      const [clientPassed, commandPassed, optionsPassed] = call!;

      expect(clientPassed).toBe(mockS3Client);
      expect(commandPassed).toBeInstanceOf(PutObjectCommand);
      expect((commandPassed as PutObjectCommand).input).toMatchObject({
        Bucket: 'private-kyc',
        Key: 'kyc/prov-1/req-1/recto.jpg',
        ContentType: 'image/jpeg',
        ServerSideEncryption: 'AES256',
      });
      expect(optionsPassed).toEqual({ expiresIn: 600 });

      expect(result.uploadUrl).toBe(fakeSignedUrl);
      expect(result.expiresAt.getTime()).toBeGreaterThanOrEqual(before + 600 * 1000);
      expect(result.expiresAt.getTime()).toBeLessThanOrEqual(after + 600 * 1000);
    });
  });

  describe('presignKycRead', () => {
    it('génère une URL GET pré-signée avec TTL strict 300s (5 min) pour le modérateur', async () => {
      const fakeReadUrl = 'https://r2.cloudflarestorage.com/private-kyc/read-url?sig=xyz';
      const mockedGetSignedUrl = vi.mocked(getSignedUrl).mockResolvedValue(fakeReadUrl);

      const before = Date.now();
      const result = await presignKycRead('kyc/prov-1/req-1/recto.jpg');
      const after = Date.now();

      expect(mockedGetSignedUrl).toHaveBeenCalledTimes(1);
      const call = mockedGetSignedUrl.mock.calls[0];
      expect(call).toBeDefined();
      const [clientPassed, commandPassed, optionsPassed] = call!;

      expect(clientPassed).toBe(mockS3Client);
      expect(commandPassed).toBeInstanceOf(GetObjectCommand);
      expect((commandPassed as GetObjectCommand).input).toMatchObject({
        Bucket: 'private-kyc',
        Key: 'kyc/prov-1/req-1/recto.jpg',
      });
      expect(optionsPassed).toEqual({ expiresIn: 300 });

      expect(result.downloadUrl).toBe(fakeReadUrl);
      expect(result.expiresAt.getTime()).toBeGreaterThanOrEqual(before + 300 * 1000);
      expect(result.expiresAt.getTime()).toBeLessThanOrEqual(after + 300 * 1000);
    });
  });

  describe('getKycObjectBuffer', () => {
    it('récupère et retourne le Buffer des octets de la pièce d’identité', async () => {
      const rawBytes = new Uint8Array([0xff, 0xd8, 0xff, 0xe0, 0x12, 0x34]);
      mockSend.mockResolvedValueOnce({
        Body: {
          transformToByteArray: vi.fn().mockResolvedValue(rawBytes),
        },
      });

      const buffer = await getKycObjectBuffer('kyc/prov-1/req-1/recto.jpg');

      expect(mockSend).toHaveBeenCalledTimes(1);
      const call = mockSend.mock.calls[0];
      expect(call).toBeDefined();
      const command = call![0] as GetObjectCommand;
      expect(command).toBeInstanceOf(GetObjectCommand);
      expect(command.input).toMatchObject({
        Bucket: 'private-kyc',
        Key: 'kyc/prov-1/req-1/recto.jpg',
      });
      expect(buffer).toEqual(Buffer.from(rawBytes));
    });

    it('lève une erreur descriptive si le corps de l’objet est vide ou manquant', async () => {
      mockSend.mockResolvedValueOnce({ Body: null });

      await expect(getKycObjectBuffer('kyc/prov-1/req-1/missing.jpg')).rejects.toThrow(
        /Objet KYC vide ou introuvable/,
      );
    });
  });

  describe('deleteKycObject', () => {
    it('envoie la commande DeleteObjectCommand avec le bucket privé et la clé', async () => {
      mockSend.mockResolvedValueOnce({});

      await deleteKycObject('kyc/prov-1/req-1/recto.jpg');

      expect(mockSend).toHaveBeenCalledTimes(1);
      const call = mockSend.mock.calls[0];
      expect(call).toBeDefined();
      const command = call![0] as DeleteObjectCommand;
      expect(command).toBeInstanceOf(DeleteObjectCommand);
      expect(command.input).toMatchObject({
        Bucket: 'private-kyc',
        Key: 'kyc/prov-1/req-1/recto.jpg',
      });
    });
  });
});
