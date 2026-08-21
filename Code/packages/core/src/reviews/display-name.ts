// BE-18 : nom d'affichage de l'auteur d'un avis. `softDeleteUser` (packages/db,
// user.repository.ts) écrase déjà firstName/lastName en 'Utilisateur'/'supprimé' à la
// suppression du compte — un simple assemblage des deux champs tels quels donne donc
// naturellement "Utilisateur supprimé", sans cas spécial ici. Le seul cas qui a besoin d'une
// vraie règle : un compte actif qui n'a jamais renseigné de nom (les deux champs sont nullable
// même hors suppression, ex. un compte qui n'a fait que l'OTP) — on ne peut pas laisser une
// chaîne vide dans une réponse publique.
export const DEFAULT_REVIEW_AUTHOR_NAME = 'Client Sanaya';

export interface ReviewAuthorNameInput {
  firstName: string | null;
  lastName: string | null;
}

export function buildReviewAuthorDisplayName(author: ReviewAuthorNameInput): string {
  const combined = [author.firstName, author.lastName]
    .map((part) => part?.trim())
    .filter((part): part is string => Boolean(part && part.length > 0))
    .join(' ');

  return combined.length > 0 ? combined : DEFAULT_REVIEW_AUTHOR_NAME;
}
