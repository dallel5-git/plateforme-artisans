// BE-30c : Purge automatique des pièces d'identité KYC à échéance de rétention (norme INPDP).
import { createAuditLog, findKycMediaAssetsDueForPurge, markMediaAssetAsPurged } from '@repo/db';
import type { DbClient } from '@repo/db';

export interface PurgeExpiredKycMediaOptions {
  /** Date pivot pour évaluer l'expiration (par défaut : now) */
  now?: Date;
  /** Nombre maximum de fichiers à traiter par lot (défaut : 50) */
  limit?: number;
  /** Fonction de suppression du fichier physique dans le stockage objet (ex: deleteKycObject R2) */
  deleteFromStorage: (storageKey: string) => Promise<void>;
  /** Client de base de données injectable (ex: pour tests) */
  db?: DbClient;
}

export interface PurgeKycErrorItem {
  mediaId: string;
  storageKey: string;
  error: string;
}

export interface PurgeKycResult {
  totalProcessed: number;
  purgedCount: number;
  skippedCount: number;
  errors: PurgeKycErrorItem[];
}

/**
 * Exécute la purge des images de pièces d'identité (CIN) dont la date limite de rétention est atteinte.
 *
 * Pour chaque média éligible :
 * 1. Supprime l'objet binaire dans le stockage Cloudflare R2 (via `deleteFromStorage`).
 * 2. Neutralise la ligne DB via `markMediaAssetAsPurged` (storageKey='purged:<id>', sizeBytes=0, purgeAfter=null).
 * 3. Journalise l'action légale dans `AuditLog` (action='kyc.media.purge').
 *
 * En cas d'erreur de suppression physique, la ligne DB n'est PAS neutralisée afin de permettre
 * une reprise lors de la prochaine exécution du cron/job.
 */
export async function purgeExpiredKycMedia(
  options: PurgeExpiredKycMediaOptions,
): Promise<PurgeKycResult> {
  const { now = new Date(), limit = 50, deleteFromStorage, db } = options;

  const dueAssets = await findKycMediaAssetsDueForPurge({ now, limit }, db);

  let purgedCount = 0;
  let skippedCount = 0;
  const errors: PurgeKycErrorItem[] = [];

  for (const asset of dueAssets) {
    // Si déjà marqué purgé, sauter
    if (asset.storageKey.startsWith('purged:')) {
      skippedCount++;
      continue;
    }

    try {
      // 1. Suppression physique de l'objet dans le bucket privé
      await deleteFromStorage(asset.storageKey);

      // 2. Neutralisation en base de données
      await markMediaAssetAsPurged(asset.id, db);

      // 3. Journalisation de conformité INPDP dans l'AuditLog
      await createAuditLog(
        {
          action: 'kyc.media.purge',
          entityType: 'MediaAsset',
          entityId: asset.id,
          before: {
            storageKey: asset.storageKey,
            sizeBytes: asset.sizeBytes,
            purgeAfter: asset.purgeAfter,
          },
          after: {
            storageKey: `purged:${asset.id}`,
            sizeBytes: 0,
            purgeAfter: null,
          },
        },
        db,
      );

      purgedCount++;
    } catch (err: unknown) {
      const errorMessage = err instanceof Error ? err.message : String(err);
      errors.push({
        mediaId: asset.id,
        storageKey: asset.storageKey,
        error: errorMessage,
      });
    }
  }

  return {
    totalProcessed: dueAssets.length,
    purgedCount,
    skippedCount,
    errors,
  };
}
