import { createHash } from 'node:crypto';

import { RATE_LIMIT_EXCEEDED } from '@repo/constants';
import {
  CONTACT_EVENT_LIMIT,
  CONTACT_EVENT_WINDOW_SECONDS,
  DomainError,
  evaluateRateLimit,
  OTP_REQUEST_LIMIT,
  OTP_REQUEST_WINDOW_SECONDS,
  type RateLimitVerdict,
} from '@repo/core';

import { incrementWithExpiry } from '../infra/redis.js';

// `request.ip` suppose une connexion directe (pas de proxy devant l'API) : `trustProxy` n'est
// configuré nulle part dans `server.ts` aujourd'hui. En local/CI c'est le cas ; si l'API est un
// jour déployée derrière un reverse proxy/load balancer, `request.ip` retombera sur l'IP du proxy
// pour toutes les requêtes et ce rate-limit par IP deviendra un seul compteur global, cassé
// silencieusement. Aucun ADR de déploiement n'existe encore — à lever quand la topologie sera actée.
function hashIp(ip: string): string {
  return createHash('sha256').update(ip).digest('hex');
}

async function checkRateLimit(input: {
  key: string;
  limit: number;
  windowSeconds: number;
}): Promise<RateLimitVerdict> {
  const { count, ttlSeconds } = await incrementWithExpiry(input.key, input.windowSeconds);
  return evaluateRateLimit({ count, limit: input.limit, ttlSeconds });
}

function rejectWithRetryAfter(retryAfterSeconds: number): never {
  throw new DomainError(RATE_LIMIT_EXCEEDED, 'Trop de demandes, réessayez plus tard', undefined, {
    'Retry-After': String(retryAfterSeconds),
  });
}

/** Primitif générique — réutilisable tel quel par BE-21 (contacts, 30/j par utilisateur). */
export async function enforceRateLimit(input: {
  key: string;
  limit: number;
  windowSeconds: number;
}): Promise<void> {
  const verdict = await checkRateLimit(input);
  if (!verdict.allowed) {
    rejectWithRetryAfter(verdict.retryAfterSeconds);
  }
}

/**
 * BE-11 : 5 demandes d'OTP par heure, par numéro ET par IP indépendamment — changer de numéro
 * depuis la même IP ne contourne pas, un numéro visé depuis plusieurs IP reste bloqué. Chaque
 * compteur est incrémenté même si l'autre est déjà dépassé (une tentative rejetée compte quand
 * même) ; en cas de double dépassement, on renvoie le délai d'attente le plus long des deux.
 */
export async function enforceOtpRequestRateLimit(phone: string, ip: string): Promise<void> {
  const [phoneVerdict, ipVerdict] = await Promise.all([
    checkRateLimit({
      key: `ratelimit:otp:phone:${phone}`,
      limit: OTP_REQUEST_LIMIT,
      windowSeconds: OTP_REQUEST_WINDOW_SECONDS,
    }),
    checkRateLimit({
      key: `ratelimit:otp:ip:${hashIp(ip)}`,
      limit: OTP_REQUEST_LIMIT,
      windowSeconds: OTP_REQUEST_WINDOW_SECONDS,
    }),
  ]);

  const failing = [phoneVerdict, ipVerdict].filter((verdict) => !verdict.allowed);
  if (failing.length > 0) {
    rejectWithRetryAfter(Math.max(...failing.map((verdict) => verdict.retryAfterSeconds)));
  }
}

/**
 * BE-21 : 30 contacts par jour, par identité ET par IP indépendamment — même patron que
 * `enforceOtpRequestRateLimit`. `identityKey` est le `sub` du token pour un utilisateur
 * authentifié, sinon l'empreinte de session (déjà un hash, P8) : jamais l'IP en clair dans
 * la clé Redis.
 */
export async function enforceContactEventRateLimit(input: {
  identityKey: string;
  ip: string;
}): Promise<void> {
  const [identityVerdict, ipVerdict] = await Promise.all([
    checkRateLimit({
      key: `ratelimit:contact:identity:${input.identityKey}`,
      limit: CONTACT_EVENT_LIMIT,
      windowSeconds: CONTACT_EVENT_WINDOW_SECONDS,
    }),
    checkRateLimit({
      key: `ratelimit:contact:ip:${hashIp(input.ip)}`,
      limit: CONTACT_EVENT_LIMIT,
      windowSeconds: CONTACT_EVENT_WINDOW_SECONDS,
    }),
  ]);

  const failing = [identityVerdict, ipVerdict].filter((verdict) => !verdict.allowed);
  if (failing.length > 0) {
    rejectWithRetryAfter(Math.max(...failing.map((verdict) => verdict.retryAfterSeconds)));
  }
}
