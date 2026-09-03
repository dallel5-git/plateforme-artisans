// BE-24 : logique pure de fusion des agrégats du tableau de bord artisan — écrite avant
// `provider-stats.ts` (CLAUDE.md §6, POLITIQUE-PROJET.md §6). Zéro I/O : `dailyStats` et
// `contactEvents` sont déjà résolus par l'appelant (repositories `@repo/db`, BE-24a/BE-46).
import type { ContactChannel } from '@repo/db';
import { describe, expect, it } from 'vitest';
import {
  buildProviderStats,
  PROVIDER_STATS_WINDOW_DAYS,
  resolveProviderStatsRange,
} from '../../src/analytics/provider-stats.js';

const RANGE = {
  from: new Date('2026-08-01T00:00:00.000Z'),
  to: new Date('2026-08-03T00:00:00.000Z'),
};

// Canal arbitraire par défaut : la plupart des cas ci-dessous testent le regroupement par jour,
// pas la ventilation par canal (BE-46, testée séparément plus bas).
function contactEvent(createdAt: Date, channel: ContactChannel = 'PHONE_CALL') {
  return { createdAt, channel };
}

describe('buildProviderStats', () => {
  it("renvoie un point par jour de la plage, sans trou — critère d'acceptation BE-24", () => {
    const result = buildProviderStats([], [], RANGE);

    expect(result.series).toHaveLength(3);
    expect(result.series.map((point) => point.date.toISOString().slice(0, 10))).toEqual([
      '2026-08-01',
      '2026-08-02',
      '2026-08-03',
    ]);
    expect(result.series.every((point) => point.profileViews === 0)).toBe(true);
    expect(result.series.every((point) => point.contacts === 0)).toBe(true);
  });

  it('place chaque agrégat DailyProviderStat sur son jour, sans affecter les autres jours', () => {
    const result = buildProviderStats(
      [{ date: new Date('2026-08-02T00:00:00.000Z'), profileViews: 5, uniqueProfileViews: 3 }],
      [],
      RANGE,
    );

    const [day1, day2, day3] = result.series;
    expect(day1!.profileViews).toBe(0);
    expect(day2!.profileViews).toBe(5);
    expect(day2!.uniqueProfileViews).toBe(3);
    expect(day3!.profileViews).toBe(0);
  });

  it('regroupe les timestamps ContactEvent bruts par jour calendaire UTC', () => {
    const result = buildProviderStats(
      [],
      [
        contactEvent(new Date('2026-08-01T08:00:00.000Z')),
        contactEvent(new Date('2026-08-01T23:59:59.000Z')),
        contactEvent(new Date('2026-08-03T00:00:01.000Z')),
      ],
      RANGE,
    );

    expect(result.series[0]!.contacts).toBe(2);
    expect(result.series[1]!.contacts).toBe(0);
    expect(result.series[2]!.contacts).toBe(1);
    expect(result.totals.contacts).toBe(3);
  });

  it('ignore un ContactEvent hors de la plage demandée', () => {
    const result = buildProviderStats(
      [],
      [contactEvent(new Date('2026-07-31T23:59:59.000Z'))],
      RANGE,
    );

    expect(result.totals.contacts).toBe(0);
  });

  it('calcule le ratio vue→contact sur les totaux (vues dédupliquées)', () => {
    const result = buildProviderStats(
      [
        { date: new Date('2026-08-01T00:00:00.000Z'), profileViews: 10, uniqueProfileViews: 8 },
        { date: new Date('2026-08-02T00:00:00.000Z'), profileViews: 2, uniqueProfileViews: 2 },
      ],
      [
        contactEvent(new Date('2026-08-01T10:00:00.000Z')),
        contactEvent(new Date('2026-08-02T10:00:00.000Z')),
      ],
      RANGE,
    );

    expect(result.totals.profileViews).toBe(12);
    expect(result.totals.uniqueProfileViews).toBe(10);
    expect(result.totals.contacts).toBe(2);
    expect(result.totals.viewToContactRatio).toBe(0.2);
  });

  it('ne divise jamais par zéro : ratio à 0 quand il n’y a aucune vue dédupliquée', () => {
    const result = buildProviderStats([], [], RANGE);

    expect(result.totals.viewToContactRatio).toBe(0);
  });

  it('ventile les contacts par canal dans les totaux — BE-46', () => {
    const result = buildProviderStats(
      [],
      [
        contactEvent(new Date('2026-08-01T08:00:00.000Z'), 'PHONE_CALL'),
        contactEvent(new Date('2026-08-01T09:00:00.000Z'), 'PHONE_CALL'),
        contactEvent(new Date('2026-08-02T08:00:00.000Z'), 'WHATSAPP'),
        contactEvent(new Date('2026-08-02T09:00:00.000Z'), 'IN_APP_MESSAGE'),
      ],
      RANGE,
    );

    expect(result.totals.contactsByChannel).toEqual({ phone: 2, whatsapp: 1 });
    // `IN_APP_MESSAGE` ne compte dans aucun des deux buckets, mais reste dans le total agrégé
    // (comportement pré-existant, non-régression).
    expect(result.totals.contacts).toBe(4);
  });

  it('ignore un contact hors plage dans la ventilation par canal comme dans le total — BE-46', () => {
    const result = buildProviderStats(
      [],
      [contactEvent(new Date('2026-07-31T23:59:59.000Z'), 'WHATSAPP')],
      RANGE,
    );

    expect(result.totals.contactsByChannel).toEqual({ phone: 0, whatsapp: 0 });
  });
});

describe('resolveProviderStatsRange', () => {
  it("couvre exactement les 30 derniers jours, aujourd'hui inclus (AC BE-24 : « série sur 30 jours »)", () => {
    const now = new Date('2026-08-22T14:32:00.000Z');

    const range = resolveProviderStatsRange(now);

    expect(range.to).toBe(now);
    expect(range.from.toISOString()).toBe('2026-07-24T00:00:00.000Z');
    expect(buildProviderStats([], [], range).series).toHaveLength(PROVIDER_STATS_WINDOW_DAYS);
  });

  it('`from` reste calé sur minuit UTC même si `now` a une heure quelconque', () => {
    const range = resolveProviderStatsRange(new Date('2026-08-22T23:59:59.999Z'));

    expect(range.from.toISOString().endsWith('T00:00:00.000Z')).toBe(true);
  });
});
