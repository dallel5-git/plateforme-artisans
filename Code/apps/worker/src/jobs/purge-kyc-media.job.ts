// BE-30c : Job de purge automatique des pièces d'identité expirées (norme INPDP).
import { purgeExpiredKycMedia } from '@repo/core';
import type { PurgeKycResult } from '@repo/core';
import { deleteKycObject } from '@repo/storage';

export interface RunKycPurgeJobOptions {
  batchSize?: number;
  now?: Date;
}

/**
 * Exécute le job de purge des médias KYC expirés en branchant la suppression R2 sur le service core.
 */
export async function runPurgeKycMediaJob(
  options: RunKycPurgeJobOptions = {},
): Promise<PurgeKycResult> {
  const { batchSize = 100, now = new Date() } = options;

  return purgeExpiredKycMedia({
    now,
    limit: batchSize,
    deleteFromStorage: (storageKey: string) => deleteKycObject(storageKey),
  });
}
