// BE-05 : agrégat ProviderProfile — racine + entités possédées (ProviderCategory,
// ServiceOffering, CoverageArea, PortfolioItem), pas de fichier séparé pour elles (elles n'ont
// pas d'identité hors de leur profil).
//
// Garde-rail P8/CLAUDE.md §3.1 : aucune méthode de lecture « profil » ou « liste » ne renvoie
// `whatsappPhone`/`publicPhone`. BE-17 (« GET /providers/:slug — sans téléphone ») en dépend.
// Seule `revealProviderContactPhone` les renvoie — à n'appeler que depuis le flux
// ContactEvent tracé (BE-21), jamais depuis une page de recherche ou une page SEO.
import type { Prisma } from '@prisma/client';
import { prisma } from '../client.js';
import type {
  AvailabilityStatus,
  DbClient,
  Locale,
  ModerationStatus,
  PriceUnit,
  ProviderPublicationStatus,
  VerificationStatus,
} from '../types.js';
import { buildKeysetOrderBy, buildKeysetWhere, buildPage, resolveLimit } from '../pagination.js';
import type { PaginatedResult } from '../pagination.js';

const profileSelect = {
  id: true,
  // BE-12 : nécessaire à `can()` (RBAC, "un artisan ne modifie que son profil") — un futur
  // schéma de réponse Zod (BE-17/19) doit rester explicite et ne pas le ré-exposer publiquement
  // sans le vouloir : ce type interne n'est pas la forme de la réponse HTTP.
  userId: true,
  slug: true,
  businessName: true,
  headline: true,
  bio: true,
  yearsExperience: true,
  spokenLanguages: true,
  baseGovernorateId: true,
  baseDelegationId: true,
  latitude: true,
  longitude: true,
  publicationStatus: true,
  availabilityStatus: true,
  availableAgainAt: true,
  acceptsEmergency: true,
  workingHours: true,
  isVerified: true,
  verifiedAt: true,
  ratingAvg: true,
  ratingCount: true,
  totalProfileViews: true,
  totalContacts: true,
  completionScore: true,
  rankingScore: true,
  lastActiveAt: true,
  createdAt: true,
  updatedAt: true,
} as const;

type RawProfile = Prisma.ProviderProfileGetPayload<{ select: typeof profileSelect }>;

export interface ProviderProfile {
  id: string;
  userId: string;
  slug: string;
  businessName: string;
  headline: string | null;
  bio: string | null;
  yearsExperience: number | null;
  spokenLanguages: Locale[];
  baseGovernorateId: string;
  baseDelegationId: string | null;
  latitude: number | null;
  longitude: number | null;
  publicationStatus: ProviderPublicationStatus;
  availabilityStatus: AvailabilityStatus;
  availableAgainAt: Date | null;
  acceptsEmergency: boolean;
  workingHours: unknown;
  isVerified: boolean;
  verifiedAt: Date | null;
  ratingAvg: number;
  ratingCount: number;
  totalProfileViews: number;
  totalContacts: number;
  completionScore: number;
  rankingScore: number;
  lastActiveAt: Date | null;
  createdAt: Date;
  updatedAt: Date;
}

function toProfile(row: RawProfile): ProviderProfile {
  return {
    ...row,
    latitude: row.latitude ? row.latitude.toNumber() : null,
    longitude: row.longitude ? row.longitude.toNumber() : null,
    ratingAvg: row.ratingAvg.toNumber(),
    rankingScore: row.rankingScore.toNumber(),
  };
}

export async function findProviderProfileById(
  id: string,
  db: DbClient = prisma,
): Promise<ProviderProfile | null> {
  const row = await db.providerProfile.findUnique({ where: { id }, select: profileSelect });
  return row ? toProfile(row) : null;
}

export async function findProviderProfileBySlug(
  slug: string,
  db: DbClient = prisma,
): Promise<ProviderProfile | null> {
  const row = await db.providerProfile.findUnique({ where: { slug }, select: profileSelect });
  return row ? toProfile(row) : null;
}

/** Réservé au flux ContactEvent tracé (BE-21) — jamais depuis une liste ou une page SEO. */
export async function revealProviderContactPhone(
  id: string,
  db: DbClient = prisma,
): Promise<{ whatsappPhone: string | null; publicPhone: string | null } | null> {
  return db.providerProfile.findUnique({
    where: { id },
    select: { whatsappPhone: true, publicPhone: true },
  });
}

export interface ListProviderProfilesFilters {
  governorateId?: string;
  delegationId?: string;
  categoryId?: string;
  publicationStatus?: ProviderPublicationStatus;
}

export async function listProviderProfiles(
  filters: ListProviderProfilesFilters,
  options: { cursor?: string; limit?: number } = {},
  db: DbClient = prisma,
): Promise<PaginatedResult<ProviderProfile>> {
  const limit = resolveLimit(options.limit);
  const keysetWhere = buildKeysetWhere('rankingScore', 'desc', options.cursor);

  const baseWhere: Prisma.ProviderProfileWhereInput = {
    publicationStatus: filters.publicationStatus ?? 'PUBLISHED',
    ...(filters.governorateId ? { baseGovernorateId: filters.governorateId } : {}),
    ...(filters.delegationId ? { baseDelegationId: filters.delegationId } : {}),
    ...(filters.categoryId ? { categories: { some: { categoryId: filters.categoryId } } } : {}),
  };

  const rows = await db.providerProfile.findMany({
    where: keysetWhere ? { ...baseWhere, ...keysetWhere } : baseWhere,
    select: profileSelect,
    orderBy: buildKeysetOrderBy('rankingScore', 'desc'),
    take: limit + 1,
  });

  return buildPage(rows.map(toProfile), limit, (row) => row.rankingScore);
}

// BE-16 : sélection dédiée à la recherche — distincte de `profileSelect` (relations
// nécessaires au score : couverture géo + catégories ; champs non pertinents pour une carte de
// résultat — bio, workingHours... — omis). `listProviderProfiles` (BE-05, ci-dessus) reste tel
// quel : sa stratégie de tri/pagination DB-side sur `rankingScore` (jamais peuplé, aucun worker
// ne l'écrit) est incompatible avec un tri calculé en mémoire (packages/core/src/search/scoring.ts)
// et elle n'a aucun appelant à ce jour — pas à BE-16 de la corriger.
const searchCandidateSelect = {
  id: true,
  slug: true,
  businessName: true,
  headline: true,
  isVerified: true,
  ratingAvg: true,
  ratingCount: true,
  completionScore: true,
  availabilityStatus: true,
  lastActiveAt: true,
  coverageAreas: { select: { governorateId: true, delegationId: true } },
  categories: {
    select: {
      isPrimary: true,
      category: { select: { slug: true, nameFr: true, nameAr: true } },
    },
  },
} as const;

type RawSearchCandidate = Prisma.ProviderProfileGetPayload<{
  select: typeof searchCandidateSelect;
}>;

export interface SearchCandidate {
  id: string;
  slug: string;
  businessName: string;
  headline: string | null;
  isVerified: boolean;
  ratingAvg: number;
  ratingCount: number;
  completionScore: number;
  availabilityStatus: AvailabilityStatus;
  lastActiveAt: Date | null;
  coverageAreas: Array<{ governorateId: string; delegationId: string | null }>;
  categories: Array<{ isPrimary: boolean; slug: string; nameFr: string; nameAr: string }>;
}

function toSearchCandidate(row: RawSearchCandidate): SearchCandidate {
  return {
    id: row.id,
    slug: row.slug,
    businessName: row.businessName,
    headline: row.headline,
    isVerified: row.isVerified,
    ratingAvg: row.ratingAvg.toNumber(),
    ratingCount: row.ratingCount,
    completionScore: row.completionScore,
    availabilityStatus: row.availabilityStatus,
    lastActiveAt: row.lastActiveAt,
    coverageAreas: row.coverageAreas,
    categories: row.categories.map((c) => ({
      isPrimary: c.isPrimary,
      slug: c.category.slug,
      nameFr: c.category.nameFr,
      nameAr: c.category.nameAr,
    })),
  };
}

export interface SearchProviderProfilesFilters {
  categoryId?: string;
  governorateId: string;
  delegationId?: string;
  verified?: boolean;
  minRating?: number;
  availabilityStatus?: AvailabilityStatus;
}

/**
 * BE-16 : renvoie TOUS les candidats correspondants, sans pagination DB-side — le tri par score
 * de ranking est calculé en mémoire (packages/core/src/search/scoring.ts), pas persisté ici.
 * Compromis MVP explicite et documenté : acceptable à l'échelle Sahel-launch (~30 artisans dans
 * le seed, quelques centaines par gouvernorat au réalisme). À revoir avant toute croissance à
 * grande échelle (score persistable + pagination DB-side).
 */
// Extraite en fonction pure (testable sans Postgres, même esprit que `pagination.ts`/
// `pagination.test.ts` dans ce même paquet) : construire le `where` Prisma est une pure
// transformation de données, indépendante de toute exécution de requête.
export function buildSearchWhereClause(
  filters: SearchProviderProfilesFilters,
): Prisma.ProviderProfileWhereInput {
  return {
    publicationStatus: 'PUBLISHED',
    ...(filters.categoryId ? { categories: { some: { categoryId: filters.categoryId } } } : {}),
    ...(filters.verified ? { isVerified: true } : {}),
    ...(filters.minRating !== undefined ? { ratingAvg: { gte: filters.minRating } } : {}),
    ...(filters.availabilityStatus ? { availabilityStatus: filters.availabilityStatus } : {}),
    coverageAreas: {
      some: {
        governorateId: filters.governorateId,
        ...(filters.delegationId
          ? { OR: [{ delegationId: null }, { delegationId: filters.delegationId }] }
          : {}),
      },
    },
  };
}

export async function searchProviderProfiles(
  filters: SearchProviderProfilesFilters,
  db: DbClient = prisma,
): Promise<SearchCandidate[]> {
  const rows = await db.providerProfile.findMany({
    where: buildSearchWhereClause(filters),
    select: searchCandidateSelect,
  });
  return rows.map(toSearchCandidate);
}

export interface CreateProviderProfileInput {
  userId: string;
  slug: string;
  businessName: string;
  headline?: string;
  bio?: string;
  yearsExperience?: number;
  whatsappPhone?: string;
  publicPhone?: string;
  spokenLanguages?: Locale[];
  baseGovernorateId: string;
  baseDelegationId?: string;
  latitude?: number;
  longitude?: number;
}

export async function createProviderProfile(
  input: CreateProviderProfileInput,
  db: DbClient = prisma,
): Promise<ProviderProfile> {
  const row = await db.providerProfile.create({ data: input, select: profileSelect });
  return toProfile(row);
}

export interface UpdateProviderProfileInput {
  businessName?: string;
  headline?: string;
  bio?: string;
  yearsExperience?: number;
  whatsappPhone?: string;
  publicPhone?: string;
  publicationStatus?: ProviderPublicationStatus;
  availabilityStatus?: AvailabilityStatus;
  availableAgainAt?: Date | null;
  acceptsEmergency?: boolean;
  completionScore?: number;
}

export async function updateProviderProfile(
  id: string,
  input: UpdateProviderProfileInput,
  db: DbClient = prisma,
): Promise<ProviderProfile> {
  const row = await db.providerProfile.update({
    where: { id },
    data: input,
    select: profileSelect,
  });
  return toProfile(row);
}

export async function setVerificationStatus(
  id: string,
  status: VerificationStatus,
  db: DbClient = prisma,
): Promise<void> {
  await db.providerProfile.update({
    where: { id },
    data: {
      verificationStatus: status,
      isVerified: status === 'APPROVED',
      verifiedAt: status === 'APPROVED' ? new Date() : null,
    },
    select: { id: true },
  });
}

/** Agrégats dénormalisés (BE-21/BE-22/BE-23) : à appeler dans la même transaction que
 *  l'écriture du ContactEvent/Review/ProfileView qui les justifie. */
export async function incrementProviderStats(
  id: string,
  delta: { profileViews?: number; contacts?: number },
  db: DbClient = prisma,
): Promise<void> {
  await db.providerProfile.update({
    where: { id },
    data: {
      ...(delta.profileViews ? { totalProfileViews: { increment: delta.profileViews } } : {}),
      ...(delta.contacts ? { totalContacts: { increment: delta.contacts } } : {}),
    },
    select: { id: true },
  });
}

export async function recomputeRatingAggregate(
  id: string,
  ratingAvg: number,
  ratingCount: number,
  db: DbClient = prisma,
): Promise<void> {
  await db.providerProfile.update({
    where: { id },
    data: { ratingAvg, ratingCount },
    select: { id: true },
  });
}

// =====================================================================
//  Entités possédées : catégories, prestations, zones, galerie
// =====================================================================

const categoryLinkSelect = {
  providerId: true,
  categoryId: true,
  isPrimary: true,
  yearsExperience: true,
} as const;

export interface ProviderCategoryLink {
  providerId: string;
  categoryId: string;
  isPrimary: boolean;
  yearsExperience: number | null;
}

export async function listProviderCategories(
  providerId: string,
  db: DbClient = prisma,
): Promise<ProviderCategoryLink[]> {
  return db.providerCategory.findMany({ where: { providerId }, select: categoryLinkSelect });
}

/** L'index unique partiel (BE-02) garantit une seule catégorie principale : si `isPrimary` est
 *  posé ici sur une deuxième catégorie sans retirer l'ancienne, la contrainte rejette l'écriture
 *  — c'est voulu, c'est le filet, pas une pré-validation à dupliquer ici. */
export async function setProviderCategory(
  providerId: string,
  categoryId: string,
  isPrimary: boolean,
  yearsExperience: number | undefined,
  db: DbClient = prisma,
): Promise<void> {
  await db.providerCategory.upsert({
    where: { providerId_categoryId: { providerId, categoryId } },
    create: { providerId, categoryId, isPrimary, yearsExperience },
    update: { isPrimary, yearsExperience },
  });
}

export async function removeProviderCategory(
  providerId: string,
  categoryId: string,
  db: DbClient = prisma,
): Promise<void> {
  await db.providerCategory.deleteMany({ where: { providerId, categoryId } });
}

const offeringSelect = {
  id: true,
  providerId: true,
  categoryId: true,
  titleFr: true,
  titleAr: true,
  description: true,
  priceMin: true,
  priceMax: true,
  priceUnit: true,
  isNegotiable: true,
  sortOrder: true,
  isActive: true,
} as const;

type RawOffering = Prisma.ServiceOfferingGetPayload<{ select: typeof offeringSelect }>;

export interface ServiceOffering {
  id: string;
  providerId: string;
  categoryId: string;
  titleFr: string;
  titleAr: string | null;
  description: string | null;
  priceMin: number | null;
  priceMax: number | null;
  priceUnit: PriceUnit;
  isNegotiable: boolean;
  sortOrder: number;
  isActive: boolean;
}

function toOffering(row: RawOffering): ServiceOffering {
  return {
    ...row,
    priceMin: row.priceMin ? row.priceMin.toNumber() : null,
    priceMax: row.priceMax ? row.priceMax.toNumber() : null,
  };
}

export async function listServiceOfferings(
  providerId: string,
  db: DbClient = prisma,
): Promise<ServiceOffering[]> {
  const rows = await db.serviceOffering.findMany({
    where: { providerId, isActive: true },
    select: offeringSelect,
    orderBy: { sortOrder: 'asc' },
  });
  return rows.map(toOffering);
}

export interface CreateServiceOfferingInput {
  providerId: string;
  categoryId: string;
  titleFr: string;
  titleAr?: string;
  description?: string;
  priceMin?: number;
  priceMax?: number;
  priceUnit?: PriceUnit;
  isNegotiable?: boolean;
  sortOrder?: number;
}

export async function addServiceOffering(
  input: CreateServiceOfferingInput,
  db: DbClient = prisma,
): Promise<ServiceOffering> {
  const row = await db.serviceOffering.create({ data: input, select: offeringSelect });
  return toOffering(row);
}

export async function removeServiceOffering(id: string, db: DbClient = prisma): Promise<void> {
  await db.serviceOffering.update({
    where: { id },
    data: { isActive: false },
    select: { id: true },
  });
}

const coverageAreaSelect = {
  id: true,
  providerId: true,
  governorateId: true,
  delegationId: true,
  travelFee: true,
} as const;

type RawCoverageArea = Prisma.CoverageAreaGetPayload<{ select: typeof coverageAreaSelect }>;

export interface CoverageArea {
  id: string;
  providerId: string;
  governorateId: string;
  delegationId: string | null;
  travelFee: number | null;
}

function toCoverageArea(row: RawCoverageArea): CoverageArea {
  return { ...row, travelFee: row.travelFee ? row.travelFee.toNumber() : null };
}

export async function listCoverageAreas(
  providerId: string,
  db: DbClient = prisma,
): Promise<CoverageArea[]> {
  const rows = await db.coverageArea.findMany({
    where: { providerId },
    select: coverageAreaSelect,
  });
  return rows.map(toCoverageArea);
}

export async function addCoverageArea(
  providerId: string,
  governorateId: string,
  delegationId: string | undefined,
  travelFee: number | undefined,
  db: DbClient = prisma,
): Promise<CoverageArea> {
  const row = await db.coverageArea.create({
    data: { providerId, governorateId, delegationId, travelFee },
    select: coverageAreaSelect,
  });
  return toCoverageArea(row);
}

export async function removeCoverageArea(id: string, db: DbClient = prisma): Promise<void> {
  await db.coverageArea.delete({ where: { id } });
}

const portfolioItemSelect = {
  id: true,
  providerId: true,
  mediaId: true,
  categoryId: true,
  caption: true,
  sortOrder: true,
  status: true,
} as const;

export interface PortfolioItem {
  id: string;
  providerId: string;
  mediaId: string;
  categoryId: string | null;
  caption: string | null;
  sortOrder: number;
  status: ModerationStatus;
}

export async function listPortfolioItems(
  providerId: string,
  db: DbClient = prisma,
): Promise<PortfolioItem[]> {
  return db.portfolioItem.findMany({
    where: { providerId, status: 'APPROVED' },
    select: portfolioItemSelect,
    orderBy: { sortOrder: 'asc' },
  });
}

export async function addPortfolioItem(
  providerId: string,
  mediaId: string,
  categoryId: string | undefined,
  caption: string | undefined,
  sortOrder: number,
  db: DbClient = prisma,
): Promise<PortfolioItem> {
  return db.portfolioItem.create({
    data: { providerId, mediaId, categoryId, caption, sortOrder },
    select: portfolioItemSelect,
  });
}

export async function removePortfolioItem(id: string, db: DbClient = prisma): Promise<void> {
  await db.portfolioItem.delete({ where: { id } });
}
