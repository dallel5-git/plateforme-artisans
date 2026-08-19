// BE-03 : poids de ranking (Annexe A du cadrage) — le classement conditionne directement le
// chiffre d'affaires, donc rien n'est codé en dur : lu depuis AppSetting, ajustable via le
// back-office (US-A-09). Le cadrage ne fixe aucune valeur numérique par défaut (seulement
// C≈8 pour le lissage bayésien) : les poids ci-dessous sont un point de départ raisonnable,
// pas une décision produit figée.
import type { PrismaClient } from '@prisma/client';

export const RANKING_WEIGHTS_KEY = 'ranking.weights';

const RANKING_WEIGHTS_VALUE = {
  w1_pertinenceGeo: 0.35,
  w2_qualiteReputation: 0.25,
  w3_confiance: 0.15,
  w4_completudeProfil: 0.1,
  w5_reactivite: 0.05,
  w6_facteurPlan: 0.1,
  w7_penaliteSignalements: 0.2,
  bayesianC: 8,
};

export async function seedAppSettings(prisma: PrismaClient): Promise<void> {
  await prisma.appSetting.upsert({
    where: { key: RANKING_WEIGHTS_KEY },
    create: {
      key: RANKING_WEIGHTS_KEY,
      value: RANKING_WEIGHTS_VALUE,
      description:
        'Poids de la formule de ranking (Annexe A du cadrage) : score = w1·geo + w2·reputation ' +
        '+ w3·confiance + w4·completude + w5·reactivite + w6·facteurPlan − w7·penalites. ' +
        'Valeurs de départ, ajustables depuis le back-office (US-A-09).',
    },
    update: {
      value: RANKING_WEIGHTS_VALUE,
    },
  });
}
