// BE-05 : agrégat Review. « Avis certifié » = `contactEventId` renseigné (unique, garde-fou
// anti-faux-avis P10) ; le trigger `prevent_self_review` (BE-02) est le dernier filet, ce
// repository ne duplique pas ce contrôle.
import { prisma } from '../client.js';
import type { DbClient, ReviewStatus } from '../types.js';
import { buildKeysetOrderBy, buildKeysetWhere, buildPage, resolveLimit } from '../pagination.js';
import type { PaginatedResult } from '../pagination.js';

const publicSelect = {
  id: true,
  providerId: true,
  clientId: true,
  contactEventId: true,
  rating: true,
  ratingPunctuality: true,
  ratingQuality: true,
  ratingValue: true,
  comment: true,
  status: true,
  isVerifiedContact: true,
  createdAt: true,
} as const;

export interface PublicReview {
  id: string;
  providerId: string;
  clientId: string;
  contactEventId: string | null;
  rating: number;
  ratingPunctuality: number | null;
  ratingQuality: number | null;
  ratingValue: number | null;
  comment: string | null;
  status: ReviewStatus;
  isVerifiedContact: boolean;
  createdAt: Date;
}

export interface CreateReviewInput {
  providerId: string;
  clientId: string;
  contactEventId?: string;
  rating: number;
  ratingPunctuality?: number;
  ratingQuality?: number;
  ratingValue?: number;
  comment?: string;
  isVerifiedContact?: boolean;
}

export async function createReview(
  input: CreateReviewInput,
  db: DbClient = prisma,
): Promise<PublicReview> {
  return db.review.create({ data: { ...input, status: 'PENDING' }, select: publicSelect });
}

export async function findReviewById(
  id: string,
  db: DbClient = prisma,
): Promise<PublicReview | null> {
  return db.review.findUnique({ where: { id }, select: publicSelect });
}

// BE-18 : sélection dédiée à la liste publique d'avis d'un artisan — distincte de `publicSelect`
// (partagé par `createReview`/`findReviewById`, non modifié ici). Inclut le nom du client : lu
// tel quel, `softDeleteUser` (user.repository.ts) l'a déjà anonymisé en 'Utilisateur'/'supprimé'
// à la suppression du compte — aucune logique de lecture supplémentaire n'est nécessaire ici,
// voir `buildReviewAuthorDisplayName` (packages/core, BE-18a) pour l'assemblage en chaîne
// affichable. Omet volontairement les sous-notes (ratingPunctuality/Quality/Value — différées,
// 🟠 P1) et tout identifiant interne (providerId/clientId/contactEventId/status), qui n'ont pas
// leur place dans une réponse publique.
const reviewListSelect = {
  id: true,
  rating: true,
  comment: true,
  isVerifiedContact: true,
  createdAt: true,
  client: { select: { firstName: true, lastName: true } },
} as const;

export interface PublicReviewListItem {
  id: string;
  rating: number;
  comment: string | null;
  isVerifiedContact: boolean;
  createdAt: Date;
  client: { firstName: string | null; lastName: string | null };
}

/**
 * BE-18 : avis PUBLISHED d'un artisan, triés par date de création décroissante, pagination par
 * curseur — stable à l'insertion entre deux pages lues (buildKeysetWhere/buildKeysetOrderBy,
 * pagination.ts, non modifiés ici). Aucun appelant avant BE-18 (stub posé par BE-05) : le
 * `select` est élargi ici même plutôt que dupliqué dans une seconde fonction.
 */
export async function listPublishedReviewsForProvider(
  providerId: string,
  options: { cursor?: string; limit?: number } = {},
  db: DbClient = prisma,
): Promise<PaginatedResult<PublicReviewListItem>> {
  const limit = resolveLimit(options.limit);
  const keysetWhere = buildKeysetWhere('createdAt', 'desc', options.cursor);
  const baseWhere = { providerId, status: 'PUBLISHED' as const };

  const rows = await db.review.findMany({
    where: keysetWhere ? { ...baseWhere, ...keysetWhere } : baseWhere,
    select: reviewListSelect,
    orderBy: buildKeysetOrderBy('createdAt', 'desc'),
    take: limit + 1,
  });

  return buildPage(rows, limit, (row) => row.createdAt.toISOString());
}

export interface ModerateReviewInput {
  status: ReviewStatus;
  moderatedById?: string;
  moderationReason?: string;
}

export async function moderateReview(
  id: string,
  input: ModerateReviewInput,
  db: DbClient = prisma,
): Promise<void> {
  await db.review.update({
    where: { id },
    data: { ...input, moderatedAt: new Date() },
    select: { id: true },
  });
}
