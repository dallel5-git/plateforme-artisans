// QA-01a (absorbe BE-02b) : harnais Vitest + Postgres jetable, jusqu'ici un stub vide — 5 fichiers
// de tests existants (apps/api/tests/{favorites,contact-events,profile-views,providers-me-stats,
// providers-reviews-create}.test.ts) documentent le trou qu'il comble. Composition ergonomique
// au-dessus des primitives bas niveau de @repo/db (repositories publics) et de @repo/db/testing
// (accès Prisma brut, réservé aux tests — P1/P4 interdit ce chemin ailleurs). Pas de reset
// automatique entre chaque test : les fixtures ci-dessous utilisent des valeurs uniques
// aléatoires pour rester isolées même si plusieurs paquets tournent en parallèle sous Turborepo
// sur la même base jetable (voir resetTestDatabase, @repo/db/testing, pour le nettoyage global).
import { randomUUID } from 'node:crypto';
import { hashOtp, hashRefreshToken, REFRESH_TTL_DAYS } from '@repo/core';
import { createContactEvent, createOtpCode, createSession, createUser } from '@repo/db';
import type { ContactEvent, OtpPurpose, PublicUser } from '@repo/db';
import {
  createTestContactEventRow,
  createTestProviderProfileRow,
  createTestUserRow,
  randomTestPhoneTn,
  resetTestDatabase,
} from '@repo/db/testing';

export { resetTestDatabase as resetDatabase };
export { createTestGovernorate, createTestCategory, randomTestPhoneTn } from '@repo/db/testing';

export interface TestClientOverrides {
  phone?: string;
  firstName?: string;
  lastName?: string;
}

/** Utilisateur `CLIENT` type — celui qui appelle, dépose un avis ou consulte un profil. */
export async function createTestClient(overrides: TestClientOverrides = {}): Promise<PublicUser> {
  return createUser({
    phone: overrides.phone ?? randomTestPhoneTn(),
    firstName: overrides.firstName,
    lastName: overrides.lastName,
    roles: ['CLIENT'],
  });
}

export interface TestProviderOverrides {
  publicationStatus?: 'DRAFT' | 'PUBLISHED' | 'HIDDEN' | 'SUSPENDED';
  isVerified?: boolean;
  baseGovernorateId?: string;
  /** Omis par défaut (comme la base) : QA-01c a besoin d'un artisan SANS ce canal pour tester
   *  PROVIDER_CONTACT_CHANNEL_UNAVAILABLE — un défaut ici masquerait ce cas d'erreur. */
  whatsappPhone?: string;
  publicPhone?: string;
}

export interface TestProvider {
  userId: string;
  providerId: string;
}

/**
 * Le fixture le plus réutilisé des quatre suites de QA-01 : un artisan complet (User rôle
 * PROVIDER + ProviderProfile) prêt à recevoir un contact, un avis, ou à répondre à ses propres
 * routes `providers/me*`. `publicationStatus` par défaut à `PUBLISHED` (contrairement au défaut
 * `DRAFT` de la base) — la plupart des tests d'intégration ciblent un artisan déjà visible.
 */
export async function createTestProvider(
  overrides: TestProviderOverrides = {},
): Promise<TestProvider> {
  const user = await createTestUserRow({ roles: ['PROVIDER'] });
  const profile = await createTestProviderProfileRow({
    userId: user.id,
    baseGovernorateId: overrides.baseGovernorateId,
    publicationStatus: overrides.publicationStatus ?? 'PUBLISHED',
    isVerified: overrides.isVerified,
    whatsappPhone: overrides.whatsappPhone,
    publicPhone: overrides.publicPhone,
  });
  return { userId: user.id, providerId: profile.id };
}

export interface TestContactEventOverrides {
  clientId?: string;
  channel?: 'PHONE_CALL' | 'WHATSAPP' | 'IN_APP_MESSAGE';
  createdAt?: Date;
}

/**
 * Contact « normal » (créé maintenant, via le repository public @repo/db — même chemin qu'une
 * vraie route). Pour un contact vieux de X heures/jours (fenêtre d'éligibilité à un avis, QA-01d),
 * utiliser `createTestContactEventRow` (@repo/db/testing) directement.
 */
export async function createTestContactEvent(
  providerId: string,
  overrides: TestContactEventOverrides = {},
): Promise<ContactEvent> {
  return createContactEvent({
    providerId,
    clientId: overrides.clientId,
    channel: overrides.channel ?? 'PHONE_CALL',
  });
}

export { createTestContactEventRow };

export interface TestOtpCodeOverrides {
  userId?: string;
  purpose?: OtpPurpose;
  code?: string;
  expiresAt?: Date;
}

export interface TestOtpCode {
  otpId: string;
  phone: string;
  /** Code en clair — jamais lisible depuis `createOtpCode` (@repo/db, ne renvoie que le hash). */
  code: string;
}

/**
 * Sème un code OTP directement en base (même hachage que la route, `hashOtp` @repo/core) : le
 * seul moyen de tester `POST /auth/otp/verify` sans passer par SMS, qui n'existe qu'en
 * `console.log` (@repo/notifications) — le code n'est jamais renvoyé dans la réponse HTTP de
 * `POST /auth/otp/request` (anti-énumération, P8).
 */
export async function createTestOtpCode(
  phone: string,
  overrides: TestOtpCodeOverrides = {},
): Promise<TestOtpCode> {
  const code = overrides.code ?? '123456';
  const otp = await createOtpCode({
    phone,
    userId: overrides.userId,
    purpose: overrides.purpose ?? 'SIGNUP',
    codeHash: await hashOtp(code),
    expiresAt: overrides.expiresAt ?? new Date(Date.now() + 5 * 60_000),
  });
  return { otpId: otp.id, phone, code };
}

export interface TestSessionOverrides {
  expiresAt?: Date;
  userAgent?: string;
}

export interface TestSession {
  sessionId: string;
  userId: string;
  /** `${sessionId}.${tokenId}` en clair — le format opaque attendu par `/auth/refresh|logout`. */
  refreshToken: string;
}

/**
 * Sème une session avec un refresh token connu en clair, même hachage que la route
 * (`hashRefreshToken`, @repo/core) : `createSession` (@repo/db) ne renvoie jamais le hash — sans
 * ce fixture, impossible de fabriquer un refresh token que `/auth/refresh` accepterait.
 */
export async function createTestSession(
  userId: string,
  overrides: TestSessionOverrides = {},
): Promise<TestSession> {
  const tokenId = randomUUID();
  const session = await createSession({
    userId,
    refreshTokenHash: hashRefreshToken(tokenId),
    expiresAt: overrides.expiresAt ?? new Date(Date.now() + REFRESH_TTL_DAYS * 24 * 60 * 60_000),
    userAgent: overrides.userAgent,
  });
  return { sessionId: session.id, userId, refreshToken: `${session.id}.${tokenId}` };
}
