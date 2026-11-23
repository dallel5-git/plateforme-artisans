import {
  ACCOUNT_ALREADY_DELETED,
  ACCOUNT_DELETION_CONFIRMATION_REQUIRED,
  CANNOT_DELETE_LAST_ADMIN,
  NOT_FOUND,
} from '@repo/constants';
import {
  executeUserAccountDeletion,
  findUserById,
  getUserCompleteDataForExport,
  isLastAdmin,
  type DbClient,
  type UserExportDataRaw,
} from '@repo/db';
import { DomainError } from '../errors/domain-error.js';

export const INPDP_LEGAL_NOTICE =
  'Données personnelles exportées conformément à la loi organique tunisienne n° 2004-63 ' +
  'relative à la protection des données à caractère personnel (INPDP) et aux conditions ' +
  'générales d utilisation de la plateforme Sanaya.';

export interface UserExportDataResult extends UserExportDataRaw {
  legalNotice: string;
  exportedAt: Date;
}

export interface DeleteUserAccountOptions {
  userId: string;
  confirmation: string;
  reason?: string;
}

export interface DeleteUserAccountResult {
  success: boolean;
  status: 'DELETED';
  message: string;
  deletedAt: Date;
}

/**
 * Prépare et structure l'export complet des données personnelles pour un utilisateur.
 * @throws {DomainError} NOT_FOUND si l'utilisateur n'existe pas ou est déjà supprimé.
 */
export async function buildUserDataExport(
  userId: string,
  db?: DbClient,
): Promise<UserExportDataResult> {
  const data = await getUserCompleteDataForExport(userId, db);
  if (!data) {
    throw new DomainError(NOT_FOUND, 'Utilisateur introuvable ou compte déjà supprimé.');
  }

  return {
    legalNotice: INPDP_LEGAL_NOTICE,
    exportedAt: new Date(),
    ...data,
  };
}

/**
 * Exécute la suppression et l'anonymisation irréversible d'un compte utilisateur
 * conformément aux exigences INPDP (US-C-13 / CLAUDE.md §3.2).
 *
 * @throws {DomainError} ACCOUNT_DELETION_CONFIRMATION_REQUIRED si la confirmation est absente/invalide.
 * @throws {DomainError} ACCOUNT_ALREADY_DELETED si le compte est déjà supprimé.
 * @throws {DomainError} CANNOT_DELETE_LAST_ADMIN si l'utilisateur est le dernier administrateur actif.
 */
export async function deleteUserAccount(
  options: DeleteUserAccountOptions,
  db?: DbClient,
): Promise<DeleteUserAccountResult> {
  const confirmationUpper = options.confirmation.trim().toUpperCase();
  if (confirmationUpper !== 'SUPPRIMER' && confirmationUpper !== 'DELETE') {
    throw new DomainError(
      ACCOUNT_DELETION_CONFIRMATION_REQUIRED,
      'La confirmation explicite ("SUPPRIMER" ou "DELETE") est obligatoire pour supprimer votre compte.',
    );
  }

  const user = await findUserById(options.userId, db);
  if (!user || user.status === 'DELETED') {
    throw new DomainError(
      ACCOUNT_ALREADY_DELETED,
      'Ce compte utilisateur n existe pas ou a déjà été supprimé.',
    );
  }

  const isOnlyAdmin = await isLastAdmin(options.userId, db);
  if (isOnlyAdmin) {
    throw new DomainError(
      CANNOT_DELETE_LAST_ADMIN,
      'Impossible de supprimer ce compte : vous êtes le dernier administrateur actif sur la plateforme.',
    );
  }

  const deletedAt = await executeUserAccountDeletion(
    options.userId,
    { reason: options.reason },
    db,
  );

  return {
    success: true,
    status: 'DELETED',
    message:
      'Votre compte a été supprimé avec succès conformément à la loi INPDP 2004-63. ' +
      'Vos données personnelles ont été anonymisées et l ensemble de vos sessions a été révoqué.',
    deletedAt,
  };
}
