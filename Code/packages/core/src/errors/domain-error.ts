import { ERROR_HTTP_STATUS, type ErrorCode } from './codes.js';

// À utiliser à la place de `throw new Error(...)` nu partout dans `core` (CLAUDE.md §4.1).
// Le statut HTTP est dérivé du code, jamais choisi au cas par cas par l'appelant.
export class DomainError extends Error {
  readonly code: ErrorCode;
  readonly httpStatus: number;
  readonly details?: Record<string, unknown>;

  constructor(code: ErrorCode, message: string, details?: Record<string, unknown>) {
    super(message);
    this.name = 'DomainError';
    this.code = code;
    this.httpStatus = ERROR_HTTP_STATUS[code];
    this.details = details;
  }
}
