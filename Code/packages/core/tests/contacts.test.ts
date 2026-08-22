/**
 * BE-21 — ContactEvent · `packages/core/src/contacts/`
 *
 * À placer dans : Code/packages/core/tests/contacts.test.ts
 *
 * ⚠️ Ces tests ÉCHOUENT tant que le module n'existe pas. C'est voulu.
 *
 * `ContactEvent` est L'UNITÉ DE VALEUR VENDUE (principe P9). Si la déduplication
 * ou la transaction cassent, on présente des chiffres faux à un artisan qui paie.
 * Une régression ici n'a AUCUN symptôme visible — d'où le test 🔒.
 *
 * Les règles pures sont testées ici, sans base. L'écriture transactionnelle
 * elle-même est couverte par les tests d'intégration (QA-01), sur une vraie
 * PostgreSQL : une transaction ne se teste pas contre un mock.
 */
import { describe, it, expect } from 'vitest';
import {
  shouldDeduplicate,
  buildSessionFingerprint,
  buildWhatsAppMessage,
  DEDUP_WINDOW_MINUTES,
} from '../src/contacts/index.js';

const T0 = new Date('2026-08-20T10:00:00.000Z');
const minutes = (n: number) => new Date(T0.getTime() + n * 60_000);

describe('BE-21 — 🔒 déduplication 30 minutes', () => {
  /**
   * 🔒 NON-RÉGRESSION — P9 / ADR-006 §4 : ne jamais supprimer.
   *
   * Si ce test casse, les statistiques vendues aux artisans deviennent fausses
   * et personne ne s'en aperçoit avant qu'un artisan conteste sa facture.
   */
  it('deux clics en 5 minutes = UN SEUL ContactEvent', () => {
    const dedup = shouldDeduplicate({
      lastEventAt: T0,
      now: minutes(5),
      providerId: 'p1',
      fingerprint: 'fp-abc',
      lastFingerprint: 'fp-abc',
      channel: 'PHONE',
      lastChannel: 'PHONE',
    });

    expect(dedup).toBe(true);
  });

  it('la fenêtre est bien de 30 minutes', () => {
    expect(DEDUP_WINDOW_MINUTES).toBe(30);
  });

  it('à 29 minutes on déduplique encore, à 31 minutes non', () => {
    const base = {
      lastEventAt: T0,
      providerId: 'p1',
      fingerprint: 'fp-abc',
      lastFingerprint: 'fp-abc',
      channel: 'PHONE' as const,
      lastChannel: 'PHONE' as const,
    };

    expect(shouldDeduplicate({ ...base, now: minutes(29) })).toBe(true);
    expect(shouldDeduplicate({ ...base, now: minutes(31) })).toBe(false);
  });

  it('un rappel légitime le lendemain compte pour un nouveau contact', () => {
    // Le client rappelle parce que l'artisan n'a pas répondu : c'est un vrai
    // second lead, pas un double-clic.
    const dedup = shouldDeduplicate({
      lastEventAt: T0,
      now: minutes(60 * 24),
      providerId: 'p1',
      fingerprint: 'fp-abc',
      lastFingerprint: 'fp-abc',
      channel: 'PHONE',
      lastChannel: 'PHONE',
    });

    expect(dedup).toBe(false);
  });

  it('deux artisans différents ne se dédupliquent jamais entre eux', () => {
    const dedup = shouldDeduplicate({
      lastEventAt: T0,
      now: minutes(2),
      providerId: 'p2',
      fingerprint: 'fp-abc',
      lastFingerprint: 'fp-abc',
      channel: 'PHONE',
      lastChannel: 'PHONE',
      lastProviderId: 'p1',
    });

    expect(dedup).toBe(false);
  });

  it('téléphone puis WhatsApp sur le même artisan = deux événements', () => {
    // Deux canaux = deux intentions de contact distinctes, et l'artisan doit
    // voir les deux dans ses statistiques.
    const dedup = shouldDeduplicate({
      lastEventAt: T0,
      now: minutes(2),
      providerId: 'p1',
      fingerprint: 'fp-abc',
      lastFingerprint: 'fp-abc',
      channel: 'WHATSAPP',
      lastChannel: 'PHONE',
    });

    expect(dedup).toBe(false);
  });

  it('deux sessions différentes = deux contacts, même en 2 minutes', () => {
    // Deux personnes du même foyer peuvent appeler le même plombier.
    const dedup = shouldDeduplicate({
      lastEventAt: T0,
      now: minutes(2),
      providerId: 'p1',
      fingerprint: 'fp-XYZ',
      lastFingerprint: 'fp-abc',
      channel: 'PHONE',
      lastChannel: 'PHONE',
    });

    expect(dedup).toBe(false);
  });

  it('aucun événement antérieur → jamais de déduplication', () => {
    const dedup = shouldDeduplicate({
      lastEventAt: null,
      now: T0,
      providerId: 'p1',
      fingerprint: 'fp-abc',
      lastFingerprint: null,
      channel: 'PHONE',
      lastChannel: null,
    });

    expect(dedup).toBe(false);
  });
});

describe('BE-21 — empreinte de session (P10, anti-fraude)', () => {
  it('est stable pour une même session', () => {
    const a = buildSessionFingerprint({ userId: 'u1', deviceId: 'd1', ip: '41.226.11.5' });
    const b = buildSessionFingerprint({ userId: 'u1', deviceId: 'd1', ip: '41.226.11.5' });

    expect(a).toBe(b);
  });

  it('diffère si le device change', () => {
    const a = buildSessionFingerprint({ userId: 'u1', deviceId: 'd1', ip: '41.226.11.5' });
    const b = buildSessionFingerprint({ userId: 'u1', deviceId: 'd2', ip: '41.226.11.5' });

    expect(a).not.toBe(b);
  });

  it("ne contient JAMAIS l'IP ni l'identifiant en clair (P8)", () => {
    // L'empreinte finit en base et dans les logs. Une IP en clair est une
    // donnée personnelle.
    const fp = buildSessionFingerprint({ userId: 'u1', deviceId: 'd1', ip: '41.226.11.5' });

    expect(fp).not.toContain('41.226.11.5');
    expect(fp).not.toContain('u1');
    expect(fp).not.toContain('d1');
    expect(fp).toMatch(/^[a-f0-9]{32,}$/);
  });
});

describe('BE-21 — message WhatsApp pré-rempli', () => {
  it('est rédigé en français quand la locale est fr', () => {
    const msg = buildWhatsAppMessage({
      locale: 'fr',
      providerName: 'Sami',
      categoryName: 'Plomberie',
    });

    expect(msg).toContain('Sami');
    expect(msg).toMatch(/bonjour/i);
  });

  it('est rédigé en arabe quand la locale est ar', () => {
    // Un message français envoyé à un artisan arabophone tue la conversion.
    const msg = buildWhatsAppMessage({
      locale: 'ar',
      providerName: 'سامي',
      categoryName: 'السباكة',
    });

    expect(msg).toMatch(/[؀-ۿ]/);
  });

  it('est encodé pour une URL wa.me', () => {
    const msg = buildWhatsAppMessage({
      locale: 'fr',
      providerName: 'Sami',
      categoryName: 'Plomberie',
    });
    const url = `https://wa.me/21622123456?text=${encodeURIComponent(msg)}`;

    expect(() => new URL(url)).not.toThrow();
    expect(url).not.toMatch(/\s/);
  });
});

describe('BE-21 — révélation du numéro (P8)', () => {
  it("le numéro n'est jamais présent dans une entrée de journal", async () => {
    const { buildContactEventLog } = await import('../src/contacts/index.js');
    const log = buildContactEventLog({
      providerId: 'p1',
      channel: 'PHONE',
      revealedPhone: '+21622123456',
      fingerprint: 'fp-abc',
    });

    expect(JSON.stringify(log)).not.toContain('+21622123456');
    expect(JSON.stringify(log)).not.toContain('22123456');
  });
});
