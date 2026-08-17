import type { Locale } from './config.js';

const TIME_ZONE = 'Africa/Tunis';

const INTL_TAG: Record<Locale, string> = {
  fr: 'fr-TN',
  ar: 'ar-TN',
};

function toIntlLocale(locale: Locale): string {
  return INTL_TAG[locale];
}

export function formatDate(
  date: Date | string,
  locale: Locale,
  options?: Intl.DateTimeFormatOptions,
): string {
  const value = typeof date === 'string' ? new Date(date) : date;
  return new Intl.DateTimeFormat(toIntlLocale(locale), {
    timeZone: TIME_ZONE,
    dateStyle: 'medium',
    ...options,
  }).format(value);
}

export function formatNumber(
  value: number,
  locale: Locale,
  options?: Intl.NumberFormatOptions,
): string {
  return new Intl.NumberFormat(toIntlLocale(locale), options).format(value);
}

/**
 * `amountInMillimes` : montant entier en millimes (1 TND = 1000 millimes), jamais un float
 * (convention CLAUDE.md §4.1). Cette fonction est le seul endroit où la conversion vers une
 * unité affichable a lieu.
 */
export function formatCurrency(amountInMillimes: number, locale: Locale): string {
  const amountInDinars = amountInMillimes / 1000;
  return new Intl.NumberFormat(toIntlLocale(locale), {
    style: 'currency',
    currency: 'TND',
  }).format(amountInDinars);
}
