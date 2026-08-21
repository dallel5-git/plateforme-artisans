/**
 * BE-18 — `packages/core/src/reviews/display-name.ts`
 *
 * Pure : assemble le nom d'affichage de l'auteur d'un avis à partir de firstName/lastName.
 * Aucun accès base ni réseau — le cas « compte supprimé » n'a pas de branche dédiée, il
 * traverse tel quel (voir commentaire du module).
 */
import { describe, expect, it } from 'vitest';
import {
  buildReviewAuthorDisplayName,
  DEFAULT_REVIEW_AUTHOR_NAME,
} from '../src/reviews/display-name.js';

describe('BE-18 — buildReviewAuthorDisplayName', () => {
  it('joint prénom et nom quand les deux sont renseignés', () => {
    expect(buildReviewAuthorDisplayName({ firstName: 'Ahmed', lastName: 'Ben Ali' })).toBe(
      'Ahmed Ben Ali',
    );
  });

  it('ne garde que le prénom si le nom est null', () => {
    expect(buildReviewAuthorDisplayName({ firstName: 'Ahmed', lastName: null })).toBe('Ahmed');
  });

  it('ne garde que le nom si le prénom est null', () => {
    expect(buildReviewAuthorDisplayName({ firstName: null, lastName: 'Ben Ali' })).toBe('Ben Ali');
  });

  it('passe tel quel le nom anonymisé par softDeleteUser (aucun cas spécial requis)', () => {
    expect(buildReviewAuthorDisplayName({ firstName: 'Utilisateur', lastName: 'supprimé' })).toBe(
      'Utilisateur supprimé',
    );
  });

  it('retombe sur le nom par défaut si prénom et nom sont null', () => {
    expect(buildReviewAuthorDisplayName({ firstName: null, lastName: null })).toBe(
      DEFAULT_REVIEW_AUTHOR_NAME,
    );
  });

  it('retombe sur le nom par défaut si prénom et nom sont des chaînes vides/blanches', () => {
    expect(buildReviewAuthorDisplayName({ firstName: '', lastName: '   ' })).toBe(
      DEFAULT_REVIEW_AUTHOR_NAME,
    );
  });

  it('retombe sur le nom par défaut si un seul des deux est blanc et l’autre null', () => {
    expect(buildReviewAuthorDisplayName({ firstName: '   ', lastName: null })).toBe(
      DEFAULT_REVIEW_AUTHOR_NAME,
    );
  });
});
