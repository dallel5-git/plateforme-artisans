export {
  hashOtp,
  verifyOtp,
  canAttemptOtp,
  isOtpExpired,
  buildOtpRequestResponse,
  generateOtp,
  OTP_TTL_MINUTES,
  OTP_MAX_ATTEMPTS,
} from './auth/otp.js';

export {
  isSessionExpired,
  rotateRefreshToken,
  detectRefreshReplay,
  hashRefreshToken,
  ACCESS_TTL_MINUTES,
  REFRESH_TTL_DAYS,
} from './auth/session.js';

export { signAccessToken, verifyAccessToken } from './auth/jwt.js';
export type { AccessTokenClaims, VerifyAccessTokenResult } from './auth/jwt.js';

export { DomainError } from './errors/domain-error.js';
export { ERROR_HTTP_STATUS } from './errors/codes.js';
export type { ErrorCode } from './errors/codes.js';

export {
  evaluateRateLimit,
  OTP_REQUEST_LIMIT,
  OTP_REQUEST_WINDOW_SECONDS,
  CONTACT_EVENT_LIMIT,
  CONTACT_EVENT_WINDOW_SECONDS,
  REVIEW_LIMIT,
  REVIEW_WINDOW_SECONDS,
  FAVORITE_LIMIT,
  FAVORITE_WINDOW_SECONDS,
  PROFILE_VIEW_LIMIT,
  PROFILE_VIEW_WINDOW_SECONDS,
} from './policies/quotas.js';
export type { RateLimitVerdict } from './policies/quotas.js';

export { can } from './policies/rbac.js';
export type { Action, OwnedResource } from './policies/rbac.js';

export { buildCategoryTree } from './catalog/category-tree.js';
export type { CategoryTreeNode } from './catalog/category-tree.js';
export { CATALOG_CACHE_TTL_SECONDS } from './catalog/constants.js';

export {
  calculateCompletionScore,
  MIN_BIO_LENGTH,
  MIN_PUBLICATION_COMPLETION_SCORE,
} from './providers/completion-score.js';
export type { CompletionScoreInput, CompletionScoreResult } from './providers/completion-score.js';

export {
  FREE_PLAN_MAX_CATEGORIES,
  FREE_PLAN_MAX_GOVERNORATES,
  FREE_PLAN_MAX_PORTFOLIO_ITEMS,
} from './billing/plan-limits.js';

export { computeRankingScore, fnv1aHash, parseRankingWeights } from './search/ranking.js';
export type {
  GeoMatch,
  RankingBreakdown,
  RankingInput,
  RankingRotation,
  RankingScoreResult,
  RankingWeights,
} from './search/ranking.js';

export {
  deriveGeoMatch,
  deriveResponsivenessScore,
  scoreCandidates,
  DEFAULT_PENALTY_SCORE,
  DEFAULT_PLAN_BOOST_FACTOR,
} from './search/scoring.js';
export type { CandidateForScoring, ScoredCandidate } from './search/scoring.js';

export {
  buildSearchSeed,
  paginateScoredResults,
  InvalidSearchCursorError,
} from './search/query-builder.js';
export type { NormalizedSearchFilters, PaginatedResult } from './search/query-builder.js';

export { requirePublishedProfile, buildPublicProviderProfile } from './providers/public-profile.js';
export type {
  NameRef,
  PublicProviderCategory,
  PublicServiceOffering,
  PublicCoverageArea,
  PublicGalleryItem,
  PublicProviderProfile,
  PublicProviderProfileInput,
} from './providers/public-profile.js';

export { formatDisplayPrice } from './providers/pricing.js';
export type { OfferingPriceInput } from './providers/pricing.js';

export { validateOfferingInput } from './providers/offerings.js';
export type { OfferingWriteInput } from './providers/offerings.js';

export { parseReviewCountByStar, buildReviewAggregate } from './reviews/aggregate.js';
export type { ReviewStarBreakdown, ReviewAggregate } from './reviews/aggregate.js';

export {
  buildReviewAuthorDisplayName,
  DEFAULT_REVIEW_AUTHOR_NAME,
} from './reviews/display-name.js';
export type { ReviewAuthorNameInput } from './reviews/display-name.js';

export {
  buildReviewEligibilityWindow,
  isContactEventEligibleForReview,
  REVIEW_MIN_CONTACT_AGE_HOURS,
  REVIEW_MAX_CONTACT_AGE_DAYS,
} from './reviews/eligibility.js';
export type { ReviewEligibilityWindow } from './reviews/eligibility.js';

export {
  shouldDeduplicate,
  DEDUP_WINDOW_MINUTES,
  buildSessionFingerprint,
  hashIp,
  buildWhatsAppMessage,
  buildContactEventLog,
  buildContactHistoryListItem,
} from './contacts/index.js';
export type {
  ContactChannel as CoreContactChannel,
  ShouldDeduplicateInput,
  BuildSessionFingerprintInput,
  BuildWhatsAppMessageInput,
  BuildContactEventLogInput,
  ContactHistoryRecord,
  ContactHistoryProviderSummary,
  ContactHistoryListItem,
} from './contacts/index.js';

export { buildFavoriteListItem } from './favorites/list-item.js';
export type {
  FavoriteRecord,
  FavoriteProviderSummary,
  FavoriteListItem,
} from './favorites/list-item.js';

export {
  resolveViewDate,
  buildProviderStats,
  PROVIDER_STATS_WINDOW_DAYS,
  resolveProviderStatsRange,
} from './analytics/index.js';
export type {
  ProviderStats,
  ProviderStatsDailyInput,
  ProviderStatsDayPoint,
  ProviderStatsRange,
  ProviderStatsTotals,
} from './analytics/index.js';

export { decryptCin, encryptCin, hashCin, isValidCin } from './security/kyc-crypto.js';
