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
} from './policies/quotas.js';
export type { RateLimitVerdict } from './policies/quotas.js';

export { can } from './policies/rbac.js';
export type { Action, OwnedResource } from './policies/rbac.js';

export { buildCategoryTree } from './catalog/category-tree.js';
export type { CategoryTreeNode } from './catalog/category-tree.js';
export { CATALOG_CACHE_TTL_SECONDS } from './catalog/constants.js';

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

export { parseReviewCountByStar, buildReviewAggregate } from './reviews/aggregate.js';
export type { ReviewStarBreakdown, ReviewAggregate } from './reviews/aggregate.js';
