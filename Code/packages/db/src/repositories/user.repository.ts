// BE-05 : agrégat User. `select` explicite partout — ne renvoie jamais `passwordHash` ni
// `twoFactorSecret`. Toute lecture publique filtre `deletedAt: null` (CLAUDE.md §3.2 : soft
// delete uniquement, jamais de suppression physique).
import { createHash } from 'node:crypto';
import { prisma } from '../client.js';
import type { DbClient, Locale, UserRole, UserStatus } from '../types.js';

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
