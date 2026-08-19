import { randomInt } from 'node:crypto';
import * as argon2 from 'argon2';

export const OTP_TTL_MINUTES = 5;
export const OTP_MAX_ATTEMPTS = 3;

export function generateOtp(): string {
  return String(randomInt(0, 1_000_000)).padStart(6, '0');
}

export function hashOtp(otp: string): Promise<string> {
  return argon2.hash(otp);
}

export function verifyOtp(otp: string, hash: string): Promise<boolean> {
  return argon2.verify(hash, otp);
}

export function canAttemptOtp(input: { attempts: number; maxAttempts: number }): boolean {
  return input.attempts < input.maxAttempts;
}

export function isOtpExpired(input: { createdAt: Date; now: Date }): boolean {
  return input.now.getTime() - input.createdAt.getTime() > OTP_TTL_MINUTES * 60_000;
}

// La réponse est volontairement identique quel que soit `userExists` — sinon
// l'endpoint devient un annuaire de comptes par énumération (P8/P10).
export function buildOtpRequestResponse(input: { userExists: boolean }): { status: 'sent' } {
  void input;
  return { status: 'sent' };
}
