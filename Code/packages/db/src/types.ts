// BE-05 : seul point du monorepo où `@prisma/client` est importé pour être RÉEXPORTÉ — jamais
// pour être consommé directement ici. Tout ce dont un consommateur (`apps/api`, `packages/core`)
// a besoin pour typer ses entrées/sorties passe par `@repo/db`, jamais par `@prisma/client`
// (règle ESLint dans `packages/eslint-config/base.js`).
import type { Prisma, PrismaClient } from '@prisma/client';

/** Client Prisma ou client de transaction interactive — accepté par tous les repositories. */
export type DbClient = PrismaClient | Prisma.TransactionClient;

export type {
  UserRole,
  UserStatus,
  Locale,
  ProviderPublicationStatus,
  AvailabilityStatus,
  VerificationStatus,
  PriceUnit,
  MediaType,
  ModerationStatus,
  ContactChannel,
  ReviewStatus,
  OtpPurpose,
} from '@prisma/client';

export type { PaginatedResult } from './pagination.js';
