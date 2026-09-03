import { VALIDATION_ERROR } from '@repo/constants';

import { DomainError } from '../errors/domain-error.js';

// BE-47 : règle métier pour l'écriture d'un `ServiceOffering` (POST/PATCH `/providers/me/offerings`).
// Ne valide que ce que le schéma Zod ne peut pas exprimer (relation entre deux champs, contenu
// après trim) — le reste (types, uuid) vit déjà dans `packages/validators`.
export interface OfferingWriteInput {
  titleFr: string;
  priceMin?: number | null;
  priceMax?: number | null;
}

export function validateOfferingInput(input: OfferingWriteInput): void {
  if (input.titleFr.trim().length === 0) {
    throw new DomainError(VALIDATION_ERROR, 'Le titre est obligatoire', { field: 'titleFr' });
  }

  const { priceMin, priceMax } = input;
  if (priceMin != null && priceMin <= 0) {
    throw new DomainError(VALIDATION_ERROR, 'Le prix minimum doit être positif', {
      field: 'priceMin',
    });
  }
  if (priceMax != null && priceMax <= 0) {
    throw new DomainError(VALIDATION_ERROR, 'Le prix maximum doit être positif', {
      field: 'priceMax',
    });
  }
  if (priceMin != null && priceMax != null && priceMin > priceMax) {
    throw new DomainError(
      VALIDATION_ERROR,
      'Le prix minimum ne peut pas dépasser le prix maximum',
      { field: 'priceMax' },
    );
  }
}
