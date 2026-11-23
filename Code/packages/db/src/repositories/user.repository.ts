// BE-05 : agrégat User. `select` explicite partout — ne renvoie jamais `passwordHash` ni
// `twoFactorSecret`. Toute lecture publique filtre `deletedAt: null` (CLAUDE.md §3.2 : soft
// delete uniquement, jamais de suppression physique).
import { createHash } from 'node:crypto';
import { prisma } from '../client.js';
import type {
  AvailabilityStatus,
  ContactChannel,
  DbClient,
  Locale,
  PriceUnit,
  ProviderPublicationStatus,
  ReviewStatus,
  UserRole,
  UserStatus,
  VerificationDocumentType,
  VerificationStatus,
} from '../types.js';

const publicSelect = {
  id: true,
  phone: true,
  phoneVerifiedAt: true,
  email: true,
  emailVerifiedAt: true,
  firstName: true,
  lastName: true,
  avatarMediaId: true,
  roles: true,
  status: true,
  locale: true,
  lastLoginAt: true,
  marketingOptIn: true,
  createdAt: true,
  updatedAt: true,
} as const;

export interface PublicUser {
  id: string;
  phone: string;
  phoneVerifiedAt: Date | null;
  email: string | null;
  emailVerifiedAt: Date | null;
  firstName: string | null;
  lastName: string | null;
  avatarMediaId: string | null;
  roles: UserRole[];
  status: UserStatus;
  locale: Locale;
  lastLoginAt: Date | null;
  marketingOptIn: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export async function findUserById(id: string, db: DbClient = prisma): Promise<PublicUser | null> {
  return db.user.findFirst({ where: { id, deletedAt: null }, select: publicSelect });
}

export async function findUserByPhone(
  phone: string,
  db: DbClient = prisma,
): Promise<PublicUser | null> {
  return db.user.findFirst({ where: { phone, deletedAt: null }, select: publicSelect });
}

export interface CreateUserInput {
  phone: string;
  firstName?: string;
  lastName?: string;
  email?: string;
  roles?: UserRole[];
  locale?: Locale;
  phoneVerifiedAt?: Date;
  status?: UserStatus;
}

export async function createUser(
  input: CreateUserInput,
  db: DbClient = prisma,
): Promise<PublicUser> {
  return db.user.create({ data: input, select: publicSelect });
}

export interface UpdateUserInput {
  firstName?: string;
  lastName?: string;
  email?: string;
  locale?: Locale;
  avatarMediaId?: string | null;
  marketingOptIn?: boolean;
}

export async function updateUser(
  id: string,
  input: UpdateUserInput,
  db: DbClient = prisma,
): Promise<PublicUser> {
  return db.user.update({ where: { id }, data: input, select: publicSelect });
}

export async function touchLastLogin(id: string, db: DbClient = prisma): Promise<void> {
  await db.user.update({ where: { id }, data: { lastLoginAt: new Date() }, select: { id: true } });
}

/**
 * BE-19 : promotion CLIENT → PROVIDER (`POST /v1/providers/me`), sans créer de second compte
 * (`US-P-01`). L'appelant vérifie déjà que le rôle est absent avant d'appeler cette fonction —
 * `push` ne déduplique pas, la réappeler pour un rôle déjà présent créerait un doublon.
 */
export async function addUserRole(
  id: string,
  role: UserRole,
  db: DbClient = prisma,
): Promise<PublicUser> {
  return db.user.update({
    where: { id },
    data: { roles: { push: role } },
    select: publicSelect,
  });
}

/**
 * Soft delete + anonymisation (CLAUDE.md §3.2) : le téléphone est haché (jamais réutilisable
 * tel quel), le nom devient « Utilisateur supprimé ». Les avis restent publiés anonymement
 * (aucune cascade sur `Review.clientId`, cf. politique de suppression §2.5 du cadrage).
 */
export async function softDeleteUser(id: string, db: DbClient = prisma): Promise<void> {
  const user = await db.user.findUniqueOrThrow({ where: { id }, select: { phone: true } });
  // `phone` est @db.VarChar(20) : "d_" (2) + 18 caractères de hash = 20 exactement.
  const hashedPhone = `d_${createHash('sha256').update(user.phone).digest('hex').slice(0, 18)}`;

  await db.user.update({
    where: { id },
    data: {
      deletedAt: new Date(),
      phone: hashedPhone,
      firstName: 'Utilisateur',
      lastName: 'supprimé',
      email: null,
      status: 'DELETED',
    },
    select: { id: true },
  });
}

// =====================================================================
// BE-41 : DROIT D'ACCÈS, EXPORT & SUPPRESSION (US-C-13 / INPDP 2004-63)
// =====================================================================

export interface UserExportDataRaw {
  user: {
    id: string;
    phone: string;
    phoneVerifiedAt: Date | null;
    email: string | null;
    emailVerifiedAt: Date | null;
    firstName: string | null;
    lastName: string | null;
    avatarMediaId: string | null;
    roles: UserRole[];
    status: UserStatus;
    locale: Locale;
    lastLoginAt: Date | null;
    marketingOptIn: boolean;
    acceptedTermsVersion: string | null;
    acceptedTermsAt: Date | null;
    createdAt: Date;
    updatedAt: Date;
  };
  providerProfile: {
    id: string;
    slug: string;
    businessName: string;
    headline: string | null;
    bio: string | null;
    yearsExperience: number | null;
    whatsappPhone: string | null;
    publicPhone: string | null;
    spokenLanguages: Locale[];
    baseGovernorate: string;
    baseDelegation: string | null;
    publicationStatus: ProviderPublicationStatus;
    availabilityStatus: AvailabilityStatus;
    isVerified: boolean;
    verifiedAt: Date | null;
    ratingAvg: number;
    ratingCount: number;
    categories: Array<{
      id: string;
      nameFr: string;
      nameAr: string;
      isPrimary: boolean;
    }>;
    offerings: Array<{
      id: string;
      titleFr: string;
      titleAr: string | null;
      priceMin: number | null;
      priceMax: number | null;
      priceUnit: PriceUnit;
    }>;
    coverageAreas: Array<{
      id: string;
      governorateNameFr: string;
      governorateNameAr: string;
      delegationNameFr: string | null;
      delegationNameAr: string | null;
    }>;
    portfolioCount: number;
  } | null;
  reviewsWritten: Array<{
    id: string;
    providerId: string;
    providerBusinessName: string;
    rating: number;
    ratingPunctuality: number | null;
    ratingQuality: number | null;
    ratingValue: number | null;
    comment: string | null;
    status: ReviewStatus;
    isVerifiedContact: boolean;
    createdAt: Date;
  }>;
  favorites: Array<{
    providerId: string;
    providerBusinessName: string;
    createdAt: Date;
  }>;
  contactEvents: Array<{
    id: string;
    providerId: string;
    providerBusinessName: string;
    channel: ContactChannel;
    createdAt: Date;
  }>;
  verificationRequests: Array<{
    id: string;
    status: VerificationStatus;
    submittedAt: Date;
    reviewedAt: Date | null;
    rejectionReason: string | null;
    documentTypes: VerificationDocumentType[];
  }>;
}

/**
 * Récupère l'intégralité des données personnelles d'un utilisateur pour l'export JSON légal INPDP.
 */
export async function getUserCompleteDataForExport(
  userId: string,
  db: DbClient = prisma,
): Promise<UserExportDataRaw | null> {
  const user = await db.user.findFirst({
    where: { id: userId, deletedAt: null },
    select: {
      id: true,
      phone: true,
      phoneVerifiedAt: true,
      email: true,
      emailVerifiedAt: true,
      firstName: true,
      lastName: true,
      avatarMediaId: true,
      roles: true,
      status: true,
      locale: true,
      lastLoginAt: true,
      marketingOptIn: true,
      acceptedTermsVersion: true,
      acceptedTermsAt: true,
      createdAt: true,
      updatedAt: true,
      providerProfile: {
        select: {
          id: true,
          slug: true,
          businessName: true,
          headline: true,
          bio: true,
          yearsExperience: true,
          whatsappPhone: true,
          publicPhone: true,
          spokenLanguages: true,
          publicationStatus: true,
          availabilityStatus: true,
          isVerified: true,
          verifiedAt: true,
          ratingAvg: true,
          ratingCount: true,
          baseGovernorate: { select: { nameFr: true } },
          baseDelegation: { select: { nameFr: true } },
          categories: {
            select: {
              isPrimary: true,
              category: { select: { id: true, nameFr: true, nameAr: true } },
            },
          },
          offerings: {
            select: {
              id: true,
              titleFr: true,
              titleAr: true,
              priceMin: true,
              priceMax: true,
              priceUnit: true,
            },
          },
          coverageAreas: {
            select: {
              id: true,
              governorate: { select: { nameFr: true, nameAr: true } },
              delegation: { select: { nameFr: true, nameAr: true } },
            },
          },
          _count: {
            select: { portfolio: true },
          },
          verifications: {
            select: {
              id: true,
              status: true,
              submittedAt: true,
              reviewedAt: true,
              rejectionReason: true,
              documents: { select: { type: true } },
            },
            orderBy: { submittedAt: 'desc' },
          },
        },
      },
      reviewsWritten: {
        select: {
          id: true,
          providerId: true,
          rating: true,
          ratingPunctuality: true,
          ratingQuality: true,
          ratingValue: true,
          comment: true,
          status: true,
          isVerifiedContact: true,
          createdAt: true,
          provider: { select: { businessName: true } },
        },
        orderBy: { createdAt: 'desc' },
      },
      favorites: {
        select: {
          providerId: true,
          createdAt: true,
          provider: { select: { businessName: true } },
        },
        orderBy: { createdAt: 'desc' },
      },
      contactEvents: {
        select: {
          id: true,
          providerId: true,
          channel: true,
          createdAt: true,
          provider: { select: { businessName: true } },
        },
        orderBy: { createdAt: 'desc' },
      },
    },
  });

  if (!user) {
    return null;
  }

  const { providerProfile, reviewsWritten, favorites, contactEvents, ...userData } = user;

  let formattedProfile: UserExportDataRaw['providerProfile'] = null;
  let verificationRequests: UserExportDataRaw['verificationRequests'] = [];

  if (providerProfile) {
    formattedProfile = {
      id: providerProfile.id,
      slug: providerProfile.slug,
      businessName: providerProfile.businessName,
      headline: providerProfile.headline,
      bio: providerProfile.bio,
      yearsExperience: providerProfile.yearsExperience,
      whatsappPhone: providerProfile.whatsappPhone,
      publicPhone: providerProfile.publicPhone,
      spokenLanguages: providerProfile.spokenLanguages,
      baseGovernorate: providerProfile.baseGovernorate.nameFr,
      baseDelegation: providerProfile.baseDelegation?.nameFr ?? null,
      publicationStatus: providerProfile.publicationStatus,
      availabilityStatus: providerProfile.availabilityStatus,
      isVerified: providerProfile.isVerified,
      verifiedAt: providerProfile.verifiedAt,
      ratingAvg: Number(providerProfile.ratingAvg),
      ratingCount: providerProfile.ratingCount,
      categories: providerProfile.categories.map((c) => ({
        id: c.category.id,
        nameFr: c.category.nameFr,
        nameAr: c.category.nameAr,
        isPrimary: c.isPrimary,
      })),
      offerings: providerProfile.offerings.map((o) => ({
        id: o.id,
        titleFr: o.titleFr,
        titleAr: o.titleAr,
        priceMin: o.priceMin ? Number(o.priceMin) : null,
        priceMax: o.priceMax ? Number(o.priceMax) : null,
        priceUnit: o.priceUnit,
      })),
      coverageAreas: providerProfile.coverageAreas.map((ca) => ({
        id: ca.id,
        governorateNameFr: ca.governorate.nameFr,
        governorateNameAr: ca.governorate.nameAr,
        delegationNameFr: ca.delegation?.nameFr ?? null,
        delegationNameAr: ca.delegation?.nameAr ?? null,
      })),
      portfolioCount: providerProfile._count.portfolio,
    };

    verificationRequests = providerProfile.verifications.map((v) => ({
      id: v.id,
      status: v.status,
      submittedAt: v.submittedAt,
      reviewedAt: v.reviewedAt,
      rejectionReason: v.rejectionReason,
      documentTypes: v.documents.map((d) => d.type),
    }));
  }

  return {
    user: userData,
    providerProfile: formattedProfile,
    reviewsWritten: reviewsWritten.map((r) => ({
      id: r.id,
      providerId: r.providerId,
      providerBusinessName: r.provider.businessName,
      rating: r.rating,
      ratingPunctuality: r.ratingPunctuality,
      ratingQuality: r.ratingQuality,
      ratingValue: r.ratingValue,
      comment: r.comment,
      status: r.status,
      isVerifiedContact: r.isVerifiedContact,
      createdAt: r.createdAt,
    })),
    favorites: favorites.map((f) => ({
      providerId: f.providerId,
      providerBusinessName: f.provider.businessName,
      createdAt: f.createdAt,
    })),
    contactEvents: contactEvents.map((ce) => ({
      id: ce.id,
      providerId: ce.providerId,
      providerBusinessName: ce.provider.businessName,
      channel: ce.channel,
      createdAt: ce.createdAt,
    })),
    verificationRequests,
  };
}

/**
 * Vérifie si l'utilisateur est le dernier compte administrateur actif sur la plateforme.
 */
export async function isLastAdmin(userId: string, db: DbClient = prisma): Promise<boolean> {
  const user = await db.user.findUnique({
    where: { id: userId },
    select: { roles: true, status: true, deletedAt: true },
  });
  if (!user || user.deletedAt || user.status === 'DELETED') {
    return false;
  }
  const isAdmin = user.roles.some((r) => r === 'ADMIN' || r === 'SUPER_ADMIN');
  if (!isAdmin) {
    return false;
  }
  const otherAdminsCount = await db.user.count({
    where: {
      id: { not: userId },
      deletedAt: null,
      status: 'ACTIVE',
      roles: { hasSome: ['ADMIN', 'SUPER_ADMIN'] },
    },
  });
  return otherAdminsCount === 0;
}

async function doExecuteUserAccountDeletion(
  userId: string,
  options: { reason?: string } = {},
  tx: DbClient,
): Promise<Date> {
  const user = await tx.user.findUniqueOrThrow({
    where: { id: userId },
    select: {
      id: true,
      phone: true,
      status: true,
      roles: true,
      deletedAt: true,
      providerProfile: { select: { id: true } },
    },
  });

  const deletedAt = new Date();
  const hashedPhone = `d_${createHash('sha256').update(user.phone).digest('hex').slice(0, 18)}`;

  // 1. Anonymiser l'utilisateur
  await tx.user.update({
    where: { id: userId },
    data: {
      deletedAt,
      phone: hashedPhone,
      firstName: 'Utilisateur',
      lastName: 'supprimé',
      email: null,
      avatarMediaId: null,
      status: 'DELETED',
      marketingOptIn: false,
      passwordHash: null,
      twoFactorSecret: null,
    },
    select: { id: true },
  });

  // 2. Si profil artisan, suspendre et masquer
  if (user.providerProfile) {
    await tx.providerProfile.update({
      where: { id: user.providerProfile.id },
      data: {
        publicationStatus: 'SUSPENDED',
        availabilityStatus: 'ON_HOLIDAY',
        businessName: 'Prestataire désactivé',
        headline: null,
        bio: null,
        whatsappPhone: null,
        publicPhone: null,
        isVerified: false,
      },
      select: { id: true },
    });
  }

  // 3. Révoquer toutes les sessions
  await tx.session.updateMany({
    where: { userId, revokedAt: null },
    data: { revokedAt: deletedAt },
  });

  // 4. Supprimer les codes OTP
  await tx.otpCode.deleteMany({
    where: { userId },
  });

  // 5. Supprimer les favoris
  await tx.favorite.deleteMany({
    where: { userId },
  });

  // 6. Inscrire l'audit log légal
  await tx.auditLog.create({
    data: {
      actorId: userId,
      action: 'user.account.delete',
      entityType: 'User',
      entityId: userId,
      before: {
        status: user.status,
        roles: user.roles,
      },
      after: {
        status: 'DELETED',
        deletedAt: deletedAt.toISOString(),
      },
      userAgent: options.reason ? `Reason: ${options.reason.slice(0, 300)}` : undefined,
    },
  });

  return deletedAt;
}

/**
 * Exécute la suppression complète d'un compte utilisateur de manière atomique.
 */
export async function executeUserAccountDeletion(
  userId: string,
  options: { reason?: string } = {},
  db: DbClient = prisma,
): Promise<Date> {
  if ('$transaction' in db && typeof db.$transaction === 'function') {
    return (db as typeof prisma).$transaction((tx) =>
      doExecuteUserAccountDeletion(userId, options, tx),
    );
  }
  return doExecuteUserAccountDeletion(userId, options, db);
}
