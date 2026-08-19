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
