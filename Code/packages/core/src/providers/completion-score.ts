// BE-19a : complétude du profil artisan — fonction pure (P3), aucune dépendance Prisma/HTTP.
// L'appelant (apps/api) fournit déjà les comptages (catégories, zones) et l'état du téléphone ;
// cette fonction se contente de noter et de lister ce qu'il manque.
//
// Pondération (somme = 100) — décision de conception prise en BE-19, aucune valeur n'est écrite
// dans le cadrage ou le PLAN-MVP (seul le seuil de publication de 60 % l'est) :
//   téléphone vérifié (18) · bio ≥ 50 caractères (18) · ≥1 catégorie (18) · ≥1 zone (18)
//   · titre (10) · expérience (10) · téléphone de contact (8)
// Les 4 champs majeurs pèsent 18 chacun (72 au total) : sur le profil minimal décrit par
// `US-P-01` (cadrage) — seulement ces 4 champs, aucun champ optionnel — ils franchissent le
// seuil de publication (72 ≥ 60), et en retirer un seul repasse sous 60 (3×18 = 54). Les champs
// optionnels (titre, expérience, téléphone de contact) peuvent en revanche compenser un champ
// majeur manquant sur un profil par ailleurs très rempli — c'est voulu : le score reste un
// indicateur continu, pas un simple ET logique sur les 4 champs.

export const MIN_BIO_LENGTH = 50;
export const MIN_PUBLICATION_COMPLETION_SCORE = 60;

export interface CompletionScoreInput {
  phoneVerified: boolean;
  bio: string | null;
  headline: string | null;
  yearsExperience: number | null;
  hasContactPhone: boolean;
  categoryCount: number;
  coverageAreaCount: number;
}

export interface CompletionScoreResult {
  score: number;
  missingFields: string[];
}

interface Criterion {
  field: string;
  weight: number;
  satisfied: (input: CompletionScoreInput) => boolean;
}

const CRITERIA: readonly Criterion[] = [
  { field: 'phoneVerified', weight: 18, satisfied: (i) => i.phoneVerified },
  { field: 'bio', weight: 18, satisfied: (i) => (i.bio?.length ?? 0) >= MIN_BIO_LENGTH },
  { field: 'categories', weight: 18, satisfied: (i) => i.categoryCount >= 1 },
  { field: 'coverageAreas', weight: 18, satisfied: (i) => i.coverageAreaCount >= 1 },
  { field: 'headline', weight: 10, satisfied: (i) => i.headline !== null && i.headline.length > 0 },
  { field: 'yearsExperience', weight: 10, satisfied: (i) => i.yearsExperience !== null },
  { field: 'contactPhone', weight: 8, satisfied: (i) => i.hasContactPhone },
];

export function calculateCompletionScore(input: CompletionScoreInput): CompletionScoreResult {
  let score = 0;
  const missingFields: string[] = [];

  for (const criterion of CRITERIA) {
    if (criterion.satisfied(input)) {
      score += criterion.weight;
    } else {
      missingFields.push(criterion.field);
    }
  }

  return { score, missingFields };
}
