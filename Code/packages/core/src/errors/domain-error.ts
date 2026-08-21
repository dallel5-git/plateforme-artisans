import { ERROR_HTTP_STATUS, type ErrorCode } from './codes.js';

// À utiliser à la place de `throw new Error(...)` nu partout dans `core` (CLAUDE.md §4.1).
// Le statut HTTP est dérivé du code, jamais choisi au cas par cas par l'appelant.
export class DomainError extends Error {
  readonly code: ErrorCode;
  readonly httpStatus: number;
  readonly details?: Record<string, unknown>;
  // BE-11 : en-têtes optionnels à renvoyer avec l'erreur (ex. `Retry-After` sur un 429).
  // Le handler global (apps/api) les copie sur la réponse avant de sérialiser le corps.
  readonly headers?: Record<string, string>;

  constructor(
    code: ErrorCode,
    message: string,
    details?: Record<string, unknown>,
    headers?: Record<string, string>,
  ) {
    super(message);
    this.name = 'DomainError';
    this.code = code;
    this.httpStatus = ERROR_HTTP_STATUS[code];
    this.details = details;
    this.headers = headers;
  }
}
