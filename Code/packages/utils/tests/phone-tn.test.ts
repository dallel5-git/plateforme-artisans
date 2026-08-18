/**
 * BE-06 — Normalisation des numéros tunisiens · `packages/utils/src/phone-tn.ts`
 *
 * À placer dans : Code/packages/utils/tests/phone-tn.test.ts
 *
 * ⚠️ Ces tests ÉCHOUENT tant que la fonction n'existe pas. C'est voulu.
 *
 * Pourquoi c'est critique malgré son apparence triviale : le téléphone est la
 * CLÉ D'IDENTITÉ du compte. Si `22 123 456` et `+21622123456` ne se normalisent
 * pas vers la même valeur, le même artisan crée deux comptes, l'OTP part sur un
 * compte fantôme, et la contrainte d'unicité ne sert à rien.
 *
 * Le critère d'acceptation demande 12 cas, dont 4 formats invalides rejetés.
 */
import { describe, it, expect } from 'vitest'
import { normalizePhoneTn, isValidPhoneTn, formatPhoneTnDisplay } from '../src/phone-tn.js'

describe('BE-06 — formats acceptés (tous vers +216XXXXXXXX)', () => {
  const CAS: Array<[string, string]> = [
    ['22123456', '+21622123456'],            // brut, 8 chiffres
    ['22 123 456', '+21622123456'],          // espaces
    ['22.123.456', '+21622123456'],          // points
    ['22-123-456', '+21622123456'],          // tirets
    ['+216 22 123 456', '+21622123456'],     // international espacé
    ['+21622123456', '+21622123456'],        // déjà normalisé
    ['0021622123456', '+21622123456'],       // préfixe 00
    ['00216 22 123 456', '+21622123456'],    // 00 espacé
    ['216 22 123 456', '+21622123456'],      // indicatif sans +
    [' 22123456 ', '+21622123456'],          // espaces autour
    ['(+216) 22-123-456', '+21622123456'],   // parenthèses
    ['٢٢١٢٣٤٥٦', '+21622123456'],            // chiffres arabes-indiens
  ]

  it.each(CAS)('normalise « %s » vers %s', (entree, attendu) => {
    expect(normalizePhoneTn(entree)).toBe(attendu)
  })

  it('est idempotent : normaliser deux fois ne change rien', () => {
    const une = normalizePhoneTn('22 123 456')
    expect(normalizePhoneTn(une!)).toBe(une)
  })
})

describe('BE-06 — les 4 formats invalides rejetés', () => {
  const INVALIDES: Array<[string, string]> = [
    ['1234567', 'trop court (7 chiffres)'],
    ['221234567', 'trop long (9 chiffres)'],
    ['+33612345678', 'indicatif étranger'],
    ['12123456', 'préfixe inexistant en Tunisie'],
  ]

  it.each(INVALIDES)('rejette « %s » — %s', (entree) => {
    expect(normalizePhoneTn(entree)).toBeNull()
    expect(isValidPhoneTn(entree)).toBe(false)
  })

  it('rejette une chaîne vide, des lettres, et null', () => {
    expect(normalizePhoneTn('')).toBeNull()
    expect(normalizePhoneTn('abcdefgh')).toBeNull()
    expect(normalizePhoneTn(null as unknown as string)).toBeNull()
    expect(normalizePhoneTn(undefined as unknown as string)).toBeNull()
  })
})

describe('BE-06 — préfixes mobiles tunisiens', () => {
  // Les mobiles tunisiens commencent par 2, 4, 5 ou 9. Le 7 est du fixe.
  it.each(['20', '25', '29', '40', '50', '55', '90', '95', '99'])(
    'accepte le préfixe mobile %s',
    (prefixe) => {
      expect(normalizePhoneTn(`${prefixe}123456`)).toBe(`+216${prefixe}123456`)
    },
  )

  it('accepte un fixe en 7x — un artisan peut en avoir un', () => {
    expect(normalizePhoneTn('71123456')).toBe('+21671123456')
  })

  it('rejette les préfixes inexistants (1, 3, 6, 8)', () => {
    for (const p of ['10', '30', '60', '80']) {
      expect(normalizePhoneTn(`${p}123456`)).toBeNull()
    }
  })
})

describe('BE-06 — 🔒 unicité : la normalisation précède TOUTE écriture', () => {
  /**
   * 🔒 NON-RÉGRESSION — P4 / anti-doublon : ne jamais supprimer.
   *
   * Si ce test casse, le même artisan peut créer deux comptes avec le même
   * numéro écrit différemment. L'OTP part sur l'un, la fiche existe sur
   * l'autre, et le support ne comprend rien.
   */
  it('toutes les écritures du même numéro convergent vers une seule valeur', () => {
    const memeNumero = [
      '22123456', '22 123 456', '+216 22 123 456',
      '0021622123456', '216-22-123-456', '(+216) 22 123 456',
    ]
    const normalises = new Set(memeNumero.map(normalizePhoneTn))

    expect(normalises.size).toBe(1)
    expect([...normalises][0]).toBe('+21622123456')
  })
})

describe('BE-06 — affichage', () => {
  it('formate pour l\'humain sans altérer le stockage', () => {
    expect(formatPhoneTnDisplay('+21622123456')).toBe('+216 22 123 456')
  })

  it("l'affichage se re-normalise vers la valeur stockée", () => {
    const stocke = '+21622123456'
    expect(normalizePhoneTn(formatPhoneTnDisplay(stocke))).toBe(stocke)
  })
})
