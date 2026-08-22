/**
 * BE-23 — Vues de profil · `packages/core/src/analytics/profile-view.ts`
 *
 * `resolveViewDate` fixe la clé de déduplication journalière (24 h) utilisée par
 * `ProfileView.viewDate` — critère d'acceptation BE-23 : « une vue est comptée une seule fois
 * par session et par jour ». Toujours en UTC, jamais Africa/Tunis (CLAUDE.md §4.1).
 */
import { describe, it, expect } from 'vitest';
import { resolveViewDate } from '../src/analytics/profile-view.js';

describe('BE-23 — resolveViewDate', () => {
  it('tronque une heure quelconque à minuit UTC du même jour', () => {
    const result = resolveViewDate(new Date('2026-08-22T14:37:52.123Z'));

    expect(result.toISOString()).toBe('2026-08-22T00:00:00.000Z');
  });

  it('23:59:59.999Z reste le même jour calendaire', () => {
    const result = resolveViewDate(new Date('2026-08-22T23:59:59.999Z'));

    expect(result.toISOString()).toBe('2026-08-22T00:00:00.000Z');
  });

  it('00:00:00.000Z bascule déjà sur le nouveau jour', () => {
    const result = resolveViewDate(new Date('2026-08-23T00:00:00.000Z'));

    expect(result.toISOString()).toBe('2026-08-23T00:00:00.000Z');
  });

  it('est idempotente sur une date déjà tronquée', () => {
    const truncated = resolveViewDate(new Date('2026-08-22T00:00:00.000Z'));

    expect(resolveViewDate(truncated).toISOString()).toBe(truncated.toISOString());
  });

  it('deux vues le même jour calendaire UTC produisent la même clé, même à des heures très différentes', () => {
    const morning = resolveViewDate(new Date('2026-08-22T01:00:00.000Z'));
    const evening = resolveViewDate(new Date('2026-08-22T22:00:00.000Z'));

    expect(morning.toISOString()).toBe(evening.toISOString());
  });
});
