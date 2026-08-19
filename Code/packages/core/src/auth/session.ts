import { randomUUID } from 'node:crypto';

export const ACCESS_TTL_MINUTES = 15;
export const REFRESH_TTL_DAYS = 30;

export function isSessionExpired(input: { expiresAt: Date; now: Date }): boolean {
  return input.now.getTime() > input.expiresAt.getTime();
}

export function rotateRefreshToken(input: {
  currentTokenId: string;
  familyId: string;
  now: Date;
}): { newTokenId: string; previousTokenId: string; familyId: string } {
  return {
    newTokenId: randomUUID(),
    previousTokenId: input.currentTokenId,
    familyId: input.familyId,
  };
}

type RefreshReplayVerdict = {
  isReplay: boolean;
  action: 'ROTATE' | 'REVOKE_FAMILY' | 'REJECT';
  familyId: string;
};

export function detectRefreshReplay(input: {
  presentedTokenId: string;
  familyId: string;
  currentTokenId: string;
  familyRevokedAt: Date | null;
}): RefreshReplayVerdict {
  if (input.familyRevokedAt !== null) {
    return { isReplay: true, action: 'REJECT', familyId: input.familyId };
  }

  if (input.presentedTokenId !== input.currentTokenId) {
    return { isReplay: true, action: 'REVOKE_FAMILY', familyId: input.familyId };
  }

  return { isReplay: false, action: 'ROTATE', familyId: input.familyId };
}
