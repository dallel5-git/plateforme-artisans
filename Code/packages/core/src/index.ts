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
