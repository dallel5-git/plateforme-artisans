// BE-05 : agrégat OtpCode. `codeHash` n'est jamais renvoyé (P8 : un OTP ne se stocke ni ne
// circule en clair). Rate limiting (3 tentatives max) porté par `attempts`/`maxAttempts` — la
// politique elle-même (quand bloquer) reste dans packages/core (BE-07), pas ici.
import { prisma } from '../client.js';
import type { DbClient, OtpPurpose } from '../types.js';

const publicSelect = {
  id: true,
  userId: true,
  phone: true,
  purpose: true,
  attempts: true,
  maxAttempts: true,
  expiresAt: true,
  consumedAt: true,
  createdAt: true,
} as const;

export interface PublicOtpCode {
  id: string;
  userId: string | null;
  phone: string;
  purpose: OtpPurpose;
  attempts: number;
  maxAttempts: number;
  expiresAt: Date;
  consumedAt: Date | null;
  createdAt: Date;
}

export interface CreateOtpCodeInput {
  userId?: string;
  phone: string;
  codeHash: string;
  purpose: OtpPurpose;
  expiresAt: Date;
  ipHash?: string;
}

export async function createOtpCode(
  input: CreateOtpCodeInput,
  db: DbClient = prisma,
): Promise<PublicOtpCode> {
  return db.otpCode.create({ data: input, select: publicSelect });
}

/** Le dernier code actif (non consommé, non expiré) pour ce téléphone/motif — inclut le hash,
 *  nécessaire pour que l'appelant (BE-07) vérifie le code saisi. Usage interne uniquement. */
export async function findActiveOtpForVerification(
  phone: string,
  purpose: OtpPurpose,
  db: DbClient = prisma,
): Promise<(PublicOtpCode & { codeHash: string }) | null> {
  return db.otpCode.findFirst({
    where: { phone, purpose, consumedAt: null, expiresAt: { gt: new Date() } },
    select: { ...publicSelect, codeHash: true },
    orderBy: { createdAt: 'desc' },
  });
}

export async function incrementOtpAttempts(
  id: string,
  db: DbClient = prisma,
): Promise<PublicOtpCode> {
  return db.otpCode.update({
    where: { id },
    data: { attempts: { increment: 1 } },
    select: publicSelect,
  });
}

export async function consumeOtpCode(id: string, db: DbClient = prisma): Promise<void> {
  await db.otpCode.update({
    where: { id },
    data: { consumedAt: new Date() },
    select: { id: true },
  });
}
