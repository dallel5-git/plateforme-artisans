// QA-01a (absorbe BE-02b) : point d'entrée RÉSERVÉ AUX TESTS où @repo/db expose son client
// Prisma brut. En dehors de packages/db lui-même (P4), c'est le seul endroit du monorepo
// autorisé à le faire (exception ESLint posée dans packages/db/eslint.config.mjs) — un test
// d'intégration a légitimement besoin de vider les tables entre deux exécutions locales et de
// poser des données de référence (gouvernorats, catégories) qui n'ont aucune fonction `create*`
// en production : ce sont des référentiels seedés une fois (tooling/scripts, prisma/seed),
// jamais écrits par une route. Aucun code de apps/* ou packages/core n'importe ce module —
// seuls @repo/testing et les *.integration.test.ts le font.
import { randomUUID } from 'node:crypto';
import type { Category, Governorate, Locale } from '@prisma/client';
import { prisma } from './client.js';
import type { DbClient } from './types.js';

/** Client Prisma brut — usage test uniquement (fixtures hors périmètre des repositories, requêtes de vérification). */
export { prisma as testDbClient };

export class ProductionDatabaseGuardError extends Error {
  constructor() {
    super('resetTestDatabase() a été appelé avec NODE_ENV=production — refus par sécurité (P8).');
    this.name = 'ProductionDatabaseGuardError';
  }
}

/**
 * QA-01a : vide toutes les tables applicatives (hors `_prisma_migrations`), sans repasser par
 * `migrate reset` (trop lent pour tourner entre suites). `RESTART IDENTITY CASCADE` gère l'ordre
 * des FK sans avoir à énumérer les dépendances à la main. Les noms de table viennent du catalogue
 * `pg_tables` (jamais d'une entrée utilisateur) — l'interpolation dans le TRUNCATE ci-dessous est
 * donc sûre. N'est PAS appelé automatiquement entre chaque fichier de test (voir
 * packages/testing/src/db-test-utils.ts) : les fixtures de test utilisent des valeurs uniques
 * aléatoires pour rester isolées les unes des autres même en exécution parallèle (plusieurs
 * paquets tournent sur la même base jetable sous Turborepo) ; cette fonction sert à repartir
 * d'une base propre en local après plusieurs exécutions, et une fois en CI par défense.
 */
export async function resetTestDatabase(db: DbClient = prisma): Promise<void> {
  if (process.env.NODE_ENV === 'production') {
    throw new ProductionDatabaseGuardError();
  }

  const tables = await db.$queryRaw<{ tablename: string }[]>`
    SELECT tablename FROM pg_tables WHERE schemaname = 'public' AND tablename != '_prisma_migrations'
  `;
  if (tables.length === 0) return;

  const quotedNames = tables.map((t) => `"${t.tablename}"`).join(', ');
  await db.$executeRawUnsafe(`TRUNCATE TABLE ${quotedNames} RESTART IDENTITY CASCADE`);
}

function randomSuffix(): string {
  return randomUUID().slice(0, 8);
}

export interface CreateTestGovernorateInput {
  code?: string;
  nameFr?: string;
  nameAr?: string;
  slug?: string;
  isActive?: boolean;
}

/** Gouvernorat minimal — aucune fonction `create*` en production (référentiel seedé une fois). */
export async function createTestGovernorate(
  input: CreateTestGovernorateInput = {},
  db: DbClient = prisma,
): Promise<Governorate> {
  const suffix = randomSuffix();
  return db.governorate.create({
    data: {
      // `code` est un `VarChar(10)` (ex: "TN-11") — suffixe court dédié, distinct de celui des
      // autres colonnes (slug/nom), qui ont plus de marge.
      code: input.code ?? `TN-${suffix.slice(0, 6)}`,
      nameFr: input.nameFr ?? `Gouvernorat de test ${suffix}`,
      nameAr: input.nameAr ?? `ولاية اختبار ${suffix}`,
      slug: input.slug ?? `gouvernorat-test-${suffix}`,
      isActive: input.isActive ?? true,
    },
  });
}

export interface CreateTestCategoryInput {
  slug?: string;
  nameFr?: string;
  nameAr?: string;
  isActive?: boolean;
}

/** Catégorie minimale — même raison que `createTestGovernorate` (référentiel seedé une fois). */
export async function createTestCategory(
  input: CreateTestCategoryInput = {},
  db: DbClient = prisma,
): Promise<Category> {
  const suffix = randomSuffix();
  return db.category.create({
    data: {
      slug: input.slug ?? `categorie-test-${suffix}`,
      nameFr: input.nameFr ?? `Catégorie de test ${suffix}`,
      nameAr: input.nameAr ?? `فئة اختبار ${suffix}`,
      isActive: input.isActive ?? true,
    },
  });
}

const VALID_TN_LOCAL_PREFIXES = ['2', '4', '5', '7', '9'] as const;

/** Numéro `+216XXXXXXXX` valide (voir packages/utils/src/phone-tn.ts) et unique par appel. */
export function randomTestPhoneTn(): string {
  const prefix =
    VALID_TN_LOCAL_PREFIXES[Math.floor(Math.random() * VALID_TN_LOCAL_PREFIXES.length)];
  const rest = Array.from({ length: 7 }, () => Math.floor(Math.random() * 10)).join('');
  return `+216${prefix}${rest}`;
}

export interface CreateTestUserRowInput {
  phone?: string;
  roles?: Array<'CLIENT' | 'PROVIDER' | 'MODERATOR' | 'SUPPORT' | 'SALES' | 'FINANCE'>;
  firstName?: string;
  lastName?: string;
  locale?: Locale;
  phoneVerifiedAt?: Date | null;
  status?: 'PENDING_VERIFICATION' | 'ACTIVE' | 'SUSPENDED' | 'DELETED';
}

/**
 * Accès complet aux colonnes de `users` (contrairement à `createUser`, @repo/db, qui restreint
 * volontairement `CreateUserInput` aux champs qu'une route peut légitimement écrire). Les tests
 * ont parfois besoin de poser un état que jamais une route ne produit directement (ex.
 * `phoneVerifiedAt` déjà rempli pour tester `POST /auth/otp/verify` sur un compte existant).
 */
export async function createTestUserRow(input: CreateTestUserRowInput = {}, db: DbClient = prisma) {
  return db.user.create({
    data: {
      phone: input.phone ?? randomTestPhoneTn(),
      roles: input.roles ?? ['CLIENT'],
      firstName: input.firstName,
      lastName: input.lastName,
      locale: input.locale,
      phoneVerifiedAt: input.phoneVerifiedAt,
      status: input.status,
    },
  });
}

export interface CreateTestProviderProfileRowInput {
  userId: string;
  baseGovernorateId?: string;
  slug?: string;
  businessName?: string;
  publicationStatus?: 'DRAFT' | 'PUBLISHED' | 'HIDDEN' | 'SUSPENDED';
  isVerified?: boolean;
  verificationStatus?: 'NOT_SUBMITTED' | 'PENDING' | 'MORE_INFO_REQUIRED' | 'APPROVED' | 'REJECTED';
  ratingAvg?: number;
  ratingCount?: number;
  whatsappPhone?: string;
  publicPhone?: string;
}

/**
 * Accès complet aux colonnes de `provider_profiles` (contrairement à `createProviderProfile`,
 * @repo/db, dont `CreateProviderProfileInput` omet volontairement `publicationStatus`/
 * `isVerified` : une route d'onboarding ne les fait jamais varier à la création, cf. BE-19). Crée
 * un gouvernorat de test si `baseGovernorateId` n'est pas fourni.
 */
export async function createTestProviderProfileRow(
  input: CreateTestProviderProfileRowInput,
  db: DbClient = prisma,
) {
  const suffix = randomSuffix();
  const baseGovernorateId = input.baseGovernorateId ?? (await createTestGovernorate({}, db)).id;

  return db.providerProfile.create({
    data: {
      userId: input.userId,
      baseGovernorateId,
      slug: input.slug ?? `artisan-test-${suffix}`,
      businessName: input.businessName ?? `Artisan de test ${suffix}`,
      publicationStatus: input.publicationStatus ?? 'DRAFT',
      isVerified: input.isVerified ?? false,
      verificationStatus: input.verificationStatus ?? 'NOT_SUBMITTED',
      ratingAvg: input.ratingAvg ?? 0,
      ratingCount: input.ratingCount ?? 0,
      whatsappPhone: input.whatsappPhone,
      publicPhone: input.publicPhone,
    },
  });
}

export interface CreateTestContactEventRowInput {
  providerId: string;
  clientId?: string;
  categoryId?: string;
  channel?: 'PHONE_CALL' | 'WHATSAPP' | 'IN_APP_MESSAGE';
  createdAt?: Date;
  sessionHash?: string;
}

/**
 * Accès complet aux colonnes de `contact_events`, notamment `createdAt` — `createContactEvent`
 * (@repo/db) l'omet volontairement (une route ne peut jamais dater son propre contact dans le
 * passé), mais QA-01d en a besoin : l'éligibilité au dépôt d'avis exige un contact vieux de
 * >12h et <60j (`buildReviewEligibilityWindow`, @repo/core), même patron que
 * `computeGate1RecetteContactCreatedAt` (prisma/seed/dev-fixtures.ts, BE-27a).
 */
export async function createTestContactEventRow(
  input: CreateTestContactEventRowInput,
  db: DbClient = prisma,
) {
  return db.contactEvent.create({
    data: {
      providerId: input.providerId,
      clientId: input.clientId,
      categoryId: input.categoryId,
      channel: input.channel ?? 'PHONE_CALL',
      createdAt: input.createdAt,
      sessionHash: input.sessionHash,
    },
  });
}

export interface CreateTestReviewRowInput {
  providerId: string;
  clientId: string;
  contactEventId?: string;
  rating?: number;
}

/** Avis minimal — BE-45 en a besoin pour tester `hasReview` (`GET /v1/contact-events`) sans
 *  passer par le flux complet de dépôt d'avis (BE-22, hors périmètre ici). */
export async function createTestReviewRow(input: CreateTestReviewRowInput, db: DbClient = prisma) {
  return db.review.create({
    data: {
      providerId: input.providerId,
      clientId: input.clientId,
      contactEventId: input.contactEventId,
      rating: input.rating ?? 5,
    },
  });
}
