import { describe, it, expect } from 'vitest';
import { generateOtp } from '../src/auth/otp.js';

describe('BE-07 — génération OTP', () => {
  it('génère toujours exactement 6 chiffres', () => {
    for (let i = 0; i < 200; i++) {
      const otp = generateOtp();
      expect(otp).toMatch(/^\d{6}$/);
    }
  });

  it('conserve les zéros de tête (pas de troncature vers un nombre)', () => {
    // Sur 2000 tirages, la probabilité de ne jamais tomber sous 100000 est
    // négligeable (~1.6e-92) si la génération repose bien sur toute la plage
    // [0, 1_000_000) plutôt que sur un format qui exclurait les petits nombres.
    const otps = Array.from({ length: 2000 }, () => generateOtp());
    expect(otps.some((otp) => otp.startsWith('0'))).toBe(true);
  });

  it("n'est pas constant d'un appel à l'autre", () => {
    const otps = new Set(Array.from({ length: 50 }, () => generateOtp()));
    expect(otps.size).toBeGreaterThan(1);
  });
});
