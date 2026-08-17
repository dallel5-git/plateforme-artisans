import type { Locale } from './config.js';

const RTL_LOCALES: ReadonlySet<Locale> = new Set(['ar']);

export function isRtl(locale: Locale): boolean {
  return RTL_LOCALES.has(locale);
}

export function getDirection(locale: Locale): 'ltr' | 'rtl' {
  return isRtl(locale) ? 'rtl' : 'ltr';
}
