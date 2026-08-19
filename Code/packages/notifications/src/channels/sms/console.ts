import type { SmsProvider } from './types.js';

export class ConsoleSmsProvider implements SmsProvider {
  async send(to: string, message: string): Promise<void> {
    if (process.env.NODE_ENV !== 'production') {
      console.log(`[SMS→${to}] ${message}`);
    }
  }
}
