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

export async function findReviewById(id: string, db: DbClient = prisma): Promise<PublicReview | null> {
  return db.review.findUnique({ where: { id }, select: publicSelect });
}

export async function listPublishedReviewsForProvider(
  providerId: string,
  options: { cursor?: string; limit?: number } = {},
  db: DbClient = prisma,
): Promise<PaginatedResult<PublicReview>> {
  const limit = resolveLimit(options.limit);
  const keysetWhere = buildKeysetWhere('createdAt', 'desc', options.cursor);
  const baseWhere = { providerId, status: 'PUBLISHED' as const };

  const rows = await db.review.findMany({
    where: keysetWhere ? { ...baseWhere, ...keysetWhere } : baseWhere,
    select: publicSelect,
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
