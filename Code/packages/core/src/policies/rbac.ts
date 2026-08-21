import type { UserRole } from '@repo/db';
import type { AccessTokenClaims } from '../auth/jwt.js';

// BE-12 : logique pure — ne connaît ni Fastify ni Prisma (P3). `subject` est exactement la forme
// de `request.user` posée par `requireAuth` ; `resource` est délibérément découplé des types
// Prisma (P1) — l'appelant extrait `review.clientId`/`providerProfile.userId` lui-même avant
// d'appeler `can()`.

export type Action = 'view' | 'update' | 'delete' | 'moderate';

export interface OwnedResource {
  ownerId: string;
}

// "Un admin tout" (périmètre BE-12) : seuls ADMIN/SUPER_ADMIN outrepassent la propriété.
// Les autres rôles (MODERATOR/SUPPORT/SALES/FINANCE) n'ont pas encore de règle spécifique dans
// le cadrage — deny par défaut plutôt qu'anticiper une matrice de permissions non spécifiée.
const ADMIN_ROLES: readonly UserRole[] = ['ADMIN', 'SUPER_ADMIN'];

// `action` fait partie de la signature demandée par BE-12 mais ne différencie pas encore le
// résultat : les 3 règles données ("un client ne modifie que ses avis", "un artisan que son
// profil", "un admin tout") sont toutes des vérifications de propriété, pas d'action.
export function can(subject: AccessTokenClaims, action: Action, resource: OwnedResource): boolean {
  void action;

  if (ADMIN_ROLES.includes(subject.role)) {
    return true;
  }

  return resource.ownerId === subject.sub;
}
