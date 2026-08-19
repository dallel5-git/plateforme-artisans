import { ConsoleSmsProvider } from './console.js';
import type { SmsProvider } from './types.js';

export type { SmsProvider } from './types.js';

export function createSmsProvider(
  providerName: string = process.env.SMS_PROVIDER ?? 'console',
): SmsProvider {
  switch (providerName) {
    case 'console':
      return new ConsoleSmsProvider();
    case 'twilio':
      throw new Error('SMS_PROVIDER=twilio pas encore implémenté (S2, hors périmètre BE-08)');
    default:
      throw new Error(`SMS_PROVIDER inconnu : "${providerName}"`);
  }
}
