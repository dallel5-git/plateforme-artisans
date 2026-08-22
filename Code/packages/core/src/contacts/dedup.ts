export const DEDUP_WINDOW_MINUTES = 30;

export type ContactChannel = 'PHONE' | 'WHATSAPP';

export interface ShouldDeduplicateInput {
  lastEventAt: Date | null;
  now: Date;
  providerId: string;
  fingerprint: string;
  lastFingerprint: string | null;
  channel: ContactChannel;
  lastChannel: ContactChannel | null;
  lastProviderId?: string;
}

// P9/P10 : deux clics de la même session sur le même artisan, même canal, en moins de
// DEDUP_WINDOW_MINUTES ne comptent qu'une fois. Une régression ici est silencieuse — voir
// packages/core/tests/contacts.test.ts (🔒 non-régression, ADR-006 §4).
export function shouldDeduplicate(input: ShouldDeduplicateInput): boolean {
  if (!input.lastEventAt) return false;
  if (input.lastProviderId !== undefined && input.lastProviderId !== input.providerId) {
    return false;
  }
  if (input.fingerprint !== input.lastFingerprint) return false;
  if (input.channel !== input.lastChannel) return false;

  const elapsedMs = input.now.getTime() - input.lastEventAt.getTime();
  return elapsedMs <= DEDUP_WINDOW_MINUTES * 60_000;
}
