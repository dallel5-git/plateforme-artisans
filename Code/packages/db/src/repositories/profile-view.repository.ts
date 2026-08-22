// BE-23 : agrégat ProfileView — dédup par (providerId, sessionHash, viewDate), garantie par la
// contrainte unique en base (schema.prisma), pas par une requête préalable (évite une course
// entre deux requêtes quasi-simultanées pour la même session/jour, même geste que
// `createReview`/`DuplicateReviewError`, BE-22c — sauf qu'ici un duplicata n'est pas une erreur
// métier à renvoyer au client, juste un signal interne : retour normal, jamais de `throw`).
import { Prisma } from '@prisma/client';

import { prisma } from '../client.js';
import type { DbClient } from '../types.js';

const select = {
  id: true,
  providerId: true,
  viewerId: true,
  sessionHash: true,
  viewDate: true,
  source: true,
  createdAt: true,
} as const;

export interface ProfileView {
  id: string;
  providerId: string;
  viewerId: string | null;
  sessionHash: string;
  viewDate: Date;
  source: string | null;
  createdAt: Date;
}

export interface CreateProfileViewInput {
  providerId: string;
  viewerId?: string;
  sessionHash: string;
  viewDate: Date;
  source?: string;
}

export interface CreateProfileViewResult {
  view: ProfileView | null;
  isNew: boolean;
}

// Isolée de `createProfileView` pour rester testable sans base (ADR-006 règle 1 : le harnais
// Vitest+Postgres est différé, BE-02b) — construit directement une
// `Prisma.PrismaClientKnownRequestError`, aucune I/O. Si quelqu'un élargit un jour la contrainte
// unique de `ProfileView` (ex. ajout d'une colonne) sans mettre à jour ce contrôle, ce test devient
// rouge : un vrai conflit de dédup serait alors traité comme une erreur inattendue (relancée),
// au lieu du retour silencieux `{ isNew: false }` attendu par le critère d'acceptation BE-23.
export function isSessionHashConflict(error: unknown): boolean {
  return (
    error instanceof Prisma.PrismaClientKnownRequestError &&
    error.code === 'P2002' &&
    ((error.meta?.target as string[] | undefined)?.includes('sessionHash') ?? false)
  );
}

/**
 * Tente de créer la ligne `ProfileView` du jour pour cette empreinte de session. `isNew: false`
 * (sans erreur) si une vue existe déjà pour ce (providerId, sessionHash, viewDate) — critère
 * d'acceptation BE-23 : « une vue est comptée une seule fois par session et par jour ».
 */
export async function createProfileView(
  input: CreateProfileViewInput,
  db: DbClient = prisma,
): Promise<CreateProfileViewResult> {
  try {
    const view = await db.profileView.create({ data: input, select });
    return { view, isNew: true };
  } catch (error) {
    if (isSessionHashConflict(error)) {
      return { view: null, isNew: false };
    }
    throw error;
  }
}
