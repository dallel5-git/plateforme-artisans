// BE-03 : poids de ranking (Annexe A du cadrage) — le classement conditionne directement le
// chiffre d'affaires, donc rien n'est codé en dur : lu depuis AppSetting, ajustable via le
// back-office (US-A-09). Le cadrage ne fixe aucune valeur numérique par défaut (seulement
// C≈8 pour le lissage bayésien) : les poids ci-dessous sont un point de départ raisonnable,
// pas une décision produit figée.
//
// BE-15 : les clés correspondent 1:1 aux champs de `RankingWeights`
// (packages/core/src/search/ranking.ts), validées à la lecture par `parseRankingWeights`.
// `C` (lissage bayésien) n'est volontairement PAS stocké ici : c'est une constante interne à
// `computeRankingScore`, jamais reçue en paramètre — la garder dans ce JSON la rendrait
// « éditable » depuis le futur back-office sans jamais rien changer.
import type { PrismaClient } from '@prisma/client';

export const RANKING_WEIGHTS_KEY = 'ranking.weights';

const RANKING_WEIGHTS_VALUE = {
  w1Geo: 0.35,
  w2Rating: 0.25,
  w3Trust: 0.15,
  w4Completion: 0.1,
  w5Responsiveness: 0.05,
  w6Plan: 0.1,
  w7Penalty: 0.2,
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
