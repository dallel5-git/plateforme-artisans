// Stub pour le module RBAC du Back-Office
export type AdminRole = 'SUPER_ADMIN' | 'ADMIN' | 'MODERATOR';

export function hasAdminPermission(role: AdminRole, required: AdminRole): boolean {
  const levels: Record<AdminRole, number> = {
    MODERATOR: 1,
    ADMIN: 2,
    SUPER_ADMIN: 3,
  };
  return levels[role] >= levels[required];
}
