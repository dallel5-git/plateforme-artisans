// BE-30c : Script de purge quotidienne des pièces d'identité KYC expirées (norme INPDP).
// Exécution autonome via cron ou CLI : pnpm db:purge-kyc
import { purgeExpiredKycMedia } from '@repo/core';
import { deleteKycObject } from '@repo/storage';

async function main(): Promise<void> {
  const batchSize = Number(process.env.PURGE_BATCH_SIZE ?? '100');
  console.log(
    `[KYC Purge] Démarrage de la purge des médias KYC expirés (batchSize: ${batchSize})...`,
  );

  try {
    const result = await purgeExpiredKycMedia({
      limit: batchSize,
      deleteFromStorage: (storageKey: string) => deleteKycObject(storageKey),
    });

    console.log(
      `[KYC Purge] Terminé avec succès : ${result.purgedCount} purgé(s), ${result.skippedCount} ignoré(s), ${result.totalProcessed} traité(s).`,
    );

    if (result.errors.length > 0) {
      console.warn(`[KYC Purge] Avertissement: ${result.errors.length} erreur(s) rencontrée(s):`);
      for (const err of result.errors) {
        console.warn(` - Media ${err.mediaId} (${err.storageKey}): ${err.error}`);
      }
    }
  } catch (err) {
    console.error('[KYC Purge] Erreur fatale lors de la purge KYC :', err);
    process.exit(1);
  }
}

main();
