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

const ownerProfileSelect = { ...profileSelect, whatsappPhone: true, publicPhone: true } as const;

type RawOwnerProfile = Prisma.ProviderProfileGetPayload<{ select: typeof ownerProfileSelect }>;

export interface ProviderProfileOwnerView extends ProviderProfile {
  whatsappPhone: string | null;
  publicPhone: string | null;
}

function toOwnerProfile(row: RawOwnerProfile): ProviderProfileOwnerView {
  return { ...toProfile(row), whatsappPhone: row.whatsappPhone, publicPhone: row.publicPhone };
}

/**
 * BE-19 : vue privée du propriétaire sur son propre profil — inclut `whatsappPhone`/
 * `publicPhone`, contrairement à `findProviderProfileById`/`findProviderProfileBySlug` (P8).
 * Distincte de `revealProviderContactPhone` (réservée au flux `ContactEvent` tracé, BE-21) :
 * ici l'appelant est toujours le propriétaire (`request.user.sub === userId`), jamais un tiers.
 */
export async function findProviderProfileByUserId(
  userId: string,
  db: DbClient = prisma,
): Promise<ProviderProfileOwnerView | null> {
  const row = await db.providerProfile.findUnique({
    where: { userId },
    select: ownerProfileSelect,
  });
  return row ? toOwnerProfile(row) : null;
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
  completionScore?: number;
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
  // BE-19 : forme libre par artisan, non validée ici — `unknown` côté API publique, comme
  // `AppSetting.value` (voir `app-setting.repository.ts`). Prisma exige `InputJsonValue` en
  // écriture, casté au point d'appel juste en dessous.
  workingHours?: unknown;
  completionScore?: number;
}

export async function updateProviderProfile(
  id: string,
  input: UpdateProviderProfileInput,
  db: DbClient = prisma,
): Promise<ProviderProfile> {
  const { workingHours, ...rest } = input;
  const row = await db.providerProfile.update({
    where: { id },
    data: {
      ...rest,
      ...(workingHours !== undefined
        ? { workingHours: workingHours as Prisma.InputJsonValue }
        : {}),
    },
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

export interface ProviderCategoryReplaceInput {
  categoryId: string;
  isPrimary: boolean;
  yearsExperience?: number;
}

/**
 * BE-19c : remplace tout le set de catégories d'un coup (`PUT`, sémantique de remplacement) —
 * supprime puis recrée, plutôt qu'un upsert incrémental, pour ne jamais heurter l'index partiel
 * unique `isPrimary` (BE-02) en cours de route (voir le commentaire sur `setProviderCategory`).
 * Transaction-agnostique comme le reste du repository : à appeler avec le `tx` de
 * `withTransaction` (@repo/db) depuis la route, avec `updateProviderProfile` pour le
 * `completionScore`, dans la même transaction.
 */
export async function replaceProviderCategories(
  providerId: string,
  categories: ProviderCategoryReplaceInput[],
  db: DbClient = prisma,
): Promise<ProviderCategoryLink[]> {
  await db.providerCategory.deleteMany({ where: { providerId } });
  if (categories.length > 0) {
    await db.providerCategory.createMany({
      data: categories.map((category) => ({ providerId, ...category })),
    });
  }
  return listProviderCategories(providerId, db);
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

export interface CoverageAreaReplaceInput {
  governorateId: string;
  delegationId?: string;
  travelFee?: number;
}

/**
 * BE-19d : remplace tout le set de zones d'un coup (`PUT`), même logique que
 * `replaceProviderCategories` (BE-19c) — supprime puis recrée, transaction-agnostique (à
 * appeler avec le `tx` de `withTransaction` depuis la route, avec `updateProviderProfile` pour
 * le `completionScore`, dans la même transaction).
 */
export async function replaceCoverageAreas(
  providerId: string,
  areas: CoverageAreaReplaceInput[],
  db: DbClient = prisma,
): Promise<CoverageArea[]> {
  await db.coverageArea.deleteMany({ where: { providerId } });
  if (areas.length > 0) {
    await db.coverageArea.createMany({
      data: areas.map((area) => ({ providerId, ...area })),
    });
  }
  return listCoverageAreas(providerId, db);
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
