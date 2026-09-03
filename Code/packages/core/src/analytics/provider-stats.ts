// BE-24 : fusionne les vues (`DailyProviderStat`, déjà agrégées au jour par BE-23) et les
// contacts (timestamps bruts `ContactEvent`, agrégés ici — `BE-21` n'écrit jamais
// phoneClicks/whatsappClicks dans `DailyProviderStat`, voir `BE-43`) sur une série continue :
// chaque jour de `range` apparaît, à zéro s'il n'a aucun événement. Sans ce zero-fill un graphe
// mobile afficherait des trous trompeurs — critère d'acceptation explicite de l'issue BE-24.
import type { ContactChannel } from '@repo/db';

import { resolveViewDate } from './profile-view.js';

export interface ProviderStatsDailyInput {
  date: Date;
  profileViews: number;
  uniqueProfileViews: number;
}

export interface ProviderStatsRange {
  from: Date;
  to: Date;
}

export interface ProviderStatsContactInput {
  createdAt: Date;
  channel: ContactChannel;
}

export interface ProviderStatsDayPoint {
  date: Date;
  profileViews: number;
  uniqueProfileViews: number;
  contacts: number;
}

export interface ProviderStatsContactsByChannel {
  phone: number;
  whatsapp: number;
}

export interface ProviderStatsTotals {
  profileViews: number;
  uniqueProfileViews: number;
  contacts: number;
  contactsByChannel: ProviderStatsContactsByChannel;
  viewToContactRatio: number;
}

export interface ProviderStats {
  totals: ProviderStatsTotals;
  series: ProviderStatsDayPoint[];
}

const ONE_DAY_MS = 24 * 60 * 60 * 1000;

function dayKey(date: Date): string {
  return resolveViewDate(date).toISOString();
}

export function buildProviderStats(
  dailyStats: ProviderStatsDailyInput[],
  contactEvents: ProviderStatsContactInput[],
  range: ProviderStatsRange,
): ProviderStats {
  const viewsByDay = new Map<string, { profileViews: number; uniqueProfileViews: number }>();
  for (const stat of dailyStats) {
    viewsByDay.set(dayKey(stat.date), {
      profileViews: stat.profileViews,
      uniqueProfileViews: stat.uniqueProfileViews,
    });
  }

  const start = resolveViewDate(range.from);
  const end = resolveViewDate(range.to);

  const contactsByDay = new Map<string, number>();
  // BE-46 : `IN_APP_MESSAGE` n'incrémente ni `phone` ni `whatsapp` (canal jamais émis en pratique —
  // rejeté en 400 par `POST /contact-events` depuis BE-21) mais reste compté ici, comme avant, dans
  // le total `contacts` journalier. Un événement hors de `range` est ignoré ici comme il l'est déjà
  // implicitement pour `contacts` (jamais lu par la boucle `series` ci-dessous).
  const contactsByChannel: ProviderStatsContactsByChannel = { phone: 0, whatsapp: 0 };
  for (const event of contactEvents) {
    const eventDay = resolveViewDate(event.createdAt).getTime();
    const key = dayKey(event.createdAt);
    contactsByDay.set(key, (contactsByDay.get(key) ?? 0) + 1);
    if (eventDay < start.getTime() || eventDay > end.getTime()) continue;
    if (event.channel === 'PHONE_CALL') contactsByChannel.phone += 1;
    else if (event.channel === 'WHATSAPP') contactsByChannel.whatsapp += 1;
  }

  const series: ProviderStatsDayPoint[] = [];

  for (let cursorMs = start.getTime(); cursorMs <= end.getTime(); cursorMs += ONE_DAY_MS) {
    const cursor = new Date(cursorMs);
    const key = cursor.toISOString();
    const views = viewsByDay.get(key);
    series.push({
      date: cursor,
      profileViews: views?.profileViews ?? 0,
      uniqueProfileViews: views?.uniqueProfileViews ?? 0,
      contacts: contactsByDay.get(key) ?? 0,
    });
  }

  const totals = series.reduce(
    (acc, point) => {
      acc.profileViews += point.profileViews;
      acc.uniqueProfileViews += point.uniqueProfileViews;
      acc.contacts += point.contacts;
      return acc;
    },
    { profileViews: 0, uniqueProfileViews: 0, contacts: 0 },
  );

  const viewToContactRatio =
    totals.uniqueProfileViews > 0 ? totals.contacts / totals.uniqueProfileViews : 0;

  return { totals: { ...totals, contactsByChannel, viewToContactRatio }, series };
}

// AC BE-24 : « série journalière sur 30 jours ». `to` reste l'instant réel (pas tronqué à
// minuit) pour que les repositories capturent les événements du jour courant jusqu'à maintenant ;
// `buildProviderStats` se charge lui-même de tronquer aux bornes de jour calendaire UTC.
export const PROVIDER_STATS_WINDOW_DAYS = 30;

export function resolveProviderStatsRange(now: Date): ProviderStatsRange {
  const from = new Date(
    resolveViewDate(now).getTime() - (PROVIDER_STATS_WINDOW_DAYS - 1) * ONE_DAY_MS,
  );
  return { from, to: now };
}
