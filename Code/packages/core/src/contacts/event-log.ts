import type { ContactChannel } from './dedup.js';

export interface BuildContactEventLogInput {
  providerId: string;
  channel: ContactChannel;
  revealedPhone: string;
  fingerprint: string;
}

// P8 : le numéro ne doit jamais atteindre un log, même tronqué — on ne transporte qu'un
// booléen, jamais un fragment de `revealedPhone`.
export function buildContactEventLog(input: BuildContactEventLogInput): unknown {
  return {
    providerId: input.providerId,
    channel: input.channel,
    fingerprint: input.fingerprint,
    phoneRevealed: true,
  };
}
