// BE-11 : logique pure de rate limiting (P10) — ne connaît pas Redis. L'appelant (apps/api)
// fournit le compte déjà incrémenté et le TTL restant de la fenêtre ; cette fonction ne fait que
// décider si c'est encore permis et, sinon, combien de temps attendre.

export const OTP_REQUEST_LIMIT = 5;
export const OTP_REQUEST_WINDOW_SECONDS = 60 * 60; // 1 h

export const CONTACT_EVENT_LIMIT = 30;
export const CONTACT_EVENT_WINDOW_SECONDS = 24 * 60 * 60; // 1 j — primitif prêt pour BE-21.

export interface RateLimitVerdict {
  allowed: boolean;
  retryAfterSeconds: number;
}

export function evaluateRateLimit(input: {
  count: number;
  limit: number;
  ttlSeconds: number;
}): RateLimitVerdict {
  return {
    allowed: input.count <= input.limit,
    retryAfterSeconds: Math.max(input.ttlSeconds, 0),
  };
}
