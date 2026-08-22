// BE-24 : fusionne les vues (`DailyProviderStat`, déjà agrégées au jour par BE-23) et les
// contacts (timestamps bruts `ContactEvent`, agrégés ici — `BE-21` n'écrit jamais
// phoneClicks/whatsappClicks dans `DailyProviderStat`, voir `BE-43`) sur une série continue :
// chaque jour de `range` apparaît, à zéro s'il n'a aucun événement. Sans ce zero-fill un graphe
// mobile afficherait des trous trompeurs — critère d'acceptation explicite de l'issue BE-24.
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

export interface ProviderStatsDayPoint {
  date: Date;
  profileViews: number;
  uniqueProfileViews: number;
  contacts: number;
}

export interface ProviderStatsTotals {
  profileViews: number;
  uniqueProfileViews: number;
  contacts: number;
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
  contactTimestamps: Date[],
  range: ProviderStatsRange,
): ProviderStats {
  const viewsByDay = new Map<string, { profileViews: number; uniqueProfileViews: number }>();
  for (const stat of dailyStats) {
    viewsByDay.set(dayKey(stat.date), {
      profileViews: stat.profileViews,
      uniqueProfileViews: stat.uniqueProfileViews,
    });
  }

  const contactsByDay = new Map<string, number>();
  for (const timestamp of contactTimestamps) {
    const key = dayKey(timestamp);
    contactsByDay.set(key, (contactsByDay.get(key) ?? 0) + 1);
  }

  const series: ProviderStatsDayPoint[] = [];
  const start = resolveViewDate(range.from);
  const end = resolveViewDate(range.to);

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

  return { totals: { ...totals, viewToContactRatio }, series };
}
