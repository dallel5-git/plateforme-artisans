// BE-05 : point d'entrée public de @repo/db. N'exporte JAMAIS le client Prisma brut ni
// `@prisma/client` — seulement les repositories, le helper de transaction, et les types
// nécessaires (P1/P4). Un consommateur qui a besoin d'appeler Prisma directement s'est trompé
// de couche.
export { withTransaction } from './transaction.js';
export type { DbClient, PaginatedResult } from './types.js';
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
} from './types.js';

export * from './repositories/user.repository.js';
export * from './repositories/session.repository.js';
export * from './repositories/otp-code.repository.js';
export * from './repositories/geo.repository.js';
export * from './repositories/category.repository.js';
export * from './repositories/provider-profile.repository.js';
export * from './repositories/contact-event.repository.js';
export * from './repositories/review.repository.js';
export * from './repositories/favorite.repository.js';
export * from './repositories/plan.repository.js';
export * from './repositories/app-setting.repository.js';
export * from './repositories/audit-log.repository.js';
export * from './repositories/media-asset.repository.js';
