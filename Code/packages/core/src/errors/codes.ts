import * as errorCodes from '@repo/constants';

export type ErrorCode = (typeof errorCodes)[keyof typeof errorCodes];

// Chaque code a un statut HTTP canonique unique — évite qu'une route décide au cas par cas
// et qu'un même code finisse par répondre 401 ici et 400 là.
export const ERROR_HTTP_STATUS: Record<ErrorCode, number> = {
  [errorCodes.OTP_TOO_MANY_ATTEMPTS]: 429,
  [errorCodes.OTP_EXPIRED]: 401,
  [errorCodes.OTP_INVALID]: 401,
  [errorCodes.ACCESS_TOKEN_EXPIRED]: 401,
  [errorCodes.ACCESS_TOKEN_INVALID]: 401,
  [errorCodes.REFRESH_TOKEN_REUSED]: 401,
  [errorCodes.REFRESH_TOKEN_INVALID]: 401,
  [errorCodes.VALIDATION_ERROR]: 400,
  [errorCodes.NOT_FOUND]: 404,
  [errorCodes.UNAUTHORIZED]: 401,
  [errorCodes.INTERNAL_ERROR]: 500,
};
