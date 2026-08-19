import { describe, it, expect, vi, afterEach } from 'vitest';
import { createSmsProvider } from '../src/channels/sms/index.js';
import { ConsoleSmsProvider } from '../src/channels/sms/console.js';

describe('BE-08 — createSmsProvider', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it("retourne un ConsoleSmsProvider pour 'console'", () => {
    expect(createSmsProvider('console')).toBeInstanceOf(ConsoleSmsProvider);
  });

  it("lève une erreur explicite pour 'twilio' (pas encore implémenté, S2)", () => {
    expect(() => createSmsProvider('twilio')).toThrow(/twilio/i);
  });

  it('lève une erreur explicite pour un provider inconnu', () => {
    expect(() => createSmsProvider('inexistant')).toThrow(/inexistant/);
  });

  it('lit SMS_PROVIDER par défaut — le code appelant ne change pas', () => {
    vi.stubEnv('SMS_PROVIDER', 'console');
    expect(createSmsProvider()).toBeInstanceOf(ConsoleSmsProvider);
  });
});

describe('BE-08 — ConsoleSmsProvider (P8, P10)', () => {
  afterEach(() => {
    vi.unstubAllEnvs();
    vi.restoreAllMocks();
  });

  it("affiche l'OTP dans le log serveur en développement", async () => {
    vi.stubEnv('NODE_ENV', 'development');
    const spy = vi.spyOn(console, 'log').mockImplementation(() => {});

    await new ConsoleSmsProvider().send('+21622123456', 'Votre code Sanaya : 123456');

    expect(spy).toHaveBeenCalledTimes(1);
    expect(spy.mock.calls[0]?.[0]).toContain('123456');
    expect(spy.mock.calls[0]?.[0]).toContain('+21622123456');
  });

  it("🔒 n'affiche jamais rien si NODE_ENV=production, même mal configuré", async () => {
    vi.stubEnv('NODE_ENV', 'production');
    const spy = vi.spyOn(console, 'log').mockImplementation(() => {});

    await new ConsoleSmsProvider().send('+21622123456', 'Votre code Sanaya : 123456');

    expect(spy).not.toHaveBeenCalled();
  });
});
