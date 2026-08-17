/**
 * BE-09 — JWT, sessions et rotation du refresh · `packages/core/src/auth/`
 *
 * À placer dans : Code/packages/core/tests/auth-session.test.ts
 *
 * ⚠️ Ces tests ÉCHOUENT tant que le module n'existe pas. C'est voulu.
 *
 * Une régression ici n'a aucun symptôme : l'app continue de fonctionner
 * parfaitement pendant qu'un token volé reste utilisable. D'où le test 🔒.
 */
import { describe, it, expect } from 'vitest'
import {
  detectRefreshReplay,
  rotateRefreshToken,
  isSessionExpired,
  ACCESS_TTL_MINUTES,
  REFRESH_TTL_DAYS,
} from '../src/auth/session'

const T0 = new Date('2026-08-20T10:00:00.000Z')
const apres = (ms: number) => new Date(T0.getTime() + ms)
const jours = (n: number) => n * 24 * 60 * 60 * 1000

describe('BE-09 — durées de vie', () => {
  it('access = 15 minutes, refresh = 30 jours', () => {
    expect(ACCESS_TTL_MINUTES).toBe(15)
    expect(REFRESH_TTL_DAYS).toBe(30)
  })

  it('une session expirée est refusée', () => {
    expect(isSessionExpired({ expiresAt: apres(-1), now: T0 })).toBe(true)
    expect(isSessionExpired({ expiresAt: apres(1000), now: T0 })).toBe(false)
  })
})

describe('BE-09 — 🔒 détection de rejeu du refresh token', () => {
  /**
   * 🔒 NON-RÉGRESSION — sécurité : ne jamais supprimer sans ADR.
   *
   * Rejouer un ancien refresh token doit révoquer TOUTE la famille de sessions.
   * C'est la seule défense contre un refresh token volé : le voleur et la
   * victime ne peuvent pas utiliser le même jeton sans que l'un des deux
   * déclenche l'alarme.
   *
   * Si ce test casse, un token volé reste utilisable indéfiniment, et rien
   * dans l'application ne le signale.
   */
  it('rejouer un refresh déjà consommé révoque toute la famille', () => {
    const famille = 'fam-1'
    const verdict = detectRefreshReplay({
      presentedTokenId: 'rt-1',
      familyId: famille,
      // rt-1 a déjà servi : il a été remplacé par rt-2.
      currentTokenId: 'rt-2',
      familyRevokedAt: null,
    })

    expect(verdict.isReplay).toBe(true)
    expect(verdict.action).toBe('REVOKE_FAMILY')
    expect(verdict.familyId).toBe(famille)
  })

  it('le token courant est accepté sans alarme', () => {
    const verdict = detectRefreshReplay({
      presentedTokenId: 'rt-2',
      familyId: 'fam-1',
      currentTokenId: 'rt-2',
      familyRevokedAt: null,
    })

    expect(verdict.isReplay).toBe(false)
    expect(verdict.action).toBe('ROTATE')
  })

  it('une famille déjà révoquée refuse tout, même le token courant', () => {
    const verdict = detectRefreshReplay({
      presentedTokenId: 'rt-2',
      familyId: 'fam-1',
      currentTokenId: 'rt-2',
      familyRevokedAt: T0,
    })

    expect(verdict.action).toBe('REJECT')
  })

  it('la rotation invalide systématiquement le jeton précédent', () => {
    // Un refresh « rotatif » qui laisserait vivre l'ancien jeton ne serait pas
    // rotatif — ce serait un refresh permanent avec des étapes en plus.
    const { newTokenId, previousTokenId, familyId } = rotateRefreshToken({
      currentTokenId: 'rt-1',
      familyId: 'fam-1',
      now: T0,
    })

    expect(newTokenId).not.toBe('rt-1')
    expect(previousTokenId).toBe('rt-1')
    expect(familyId).toBe('fam-1')

    // Et immédiatement après, présenter l'ancien est un rejeu.
    const verdict = detectRefreshReplay({
      presentedTokenId: previousTokenId,
      familyId,
      currentTokenId: newTokenId,
      familyRevokedAt: null,
    })
    expect(verdict.isReplay).toBe(true)
  })

  it('la rotation conserve la famille — elle ne la recrée pas', () => {
    // Si chaque rotation créait une nouvelle famille, la détection de rejeu
    // ne pourrait plus remonter la chaîne : elle deviendrait inopérante.
    let tokenId = 'rt-0'
    const famille = 'fam-1'

    for (let i = 0; i < 5; i++) {
      const r = rotateRefreshToken({ currentTokenId: tokenId, familyId: famille, now: T0 })
      expect(r.familyId).toBe(famille)
      tokenId = r.newTokenId
    }
  })
})

describe('BE-09 — expiration du refresh', () => {
  it('un refresh de plus de 30 jours est refusé', () => {
    expect(isSessionExpired({ expiresAt: new Date(T0.getTime() + jours(30)), now: new Date(T0.getTime() + jours(31)) })).toBe(true)
  })
})

describe('BE-07 — OTP (P8, P10)', () => {
  it("n'est jamais stocké ni renvoyé en clair", async () => {
    const { hashOtp, verifyOtp } = await import('../src/auth/otp')
    const hash = await hashOtp('123456')

    expect(hash).not.toContain('123456')
    expect(await verifyOtp('123456', hash)).toBe(true)
    expect(await verifyOtp('123457', hash)).toBe(false)
  })

  it('refuse à la 4ᵉ tentative', async () => {
    const { canAttemptOtp } = await import('../src/auth/otp')

    expect(canAttemptOtp({ attempts: 2, maxAttempts: 3 })).toBe(true)
    expect(canAttemptOtp({ attempts: 3, maxAttempts: 3 })).toBe(false)
  })

  it('expire après 5 minutes', async () => {
    const { isOtpExpired } = await import('../src/auth/otp')

    expect(isOtpExpired({ createdAt: T0, now: apres(4 * 60_000) })).toBe(false)
    expect(isOtpExpired({ createdAt: T0, now: apres(6 * 60_000) })).toBe(true)
  })

  it("la réponse d'otp/request ne révèle jamais si le numéro existe (anti-énumération)", async () => {
    const { buildOtpRequestResponse } = await import('../src/auth/otp')

    const existant = buildOtpRequestResponse({ userExists: true })
    const inconnu = buildOtpRequestResponse({ userExists: false })

    // Réponses strictement identiques : sinon on offre un annuaire de comptes.
    expect(existant).toEqual(inconnu)
  })
})
