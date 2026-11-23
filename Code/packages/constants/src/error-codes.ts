export const OTP_TOO_MANY_ATTEMPTS = 'OTP_TOO_MANY_ATTEMPTS';
export const OTP_EXPIRED = 'OTP_EXPIRED';
export const OTP_INVALID = 'OTP_INVALID';

export const ACCESS_TOKEN_EXPIRED = 'ACCESS_TOKEN_EXPIRED';
export const ACCESS_TOKEN_INVALID = 'ACCESS_TOKEN_INVALID';
export const REFRESH_TOKEN_REUSED = 'REFRESH_TOKEN_REUSED';
export const REFRESH_TOKEN_INVALID = 'REFRESH_TOKEN_INVALID';

// BE-13 : codes génériques, communs à tous les modules (pas seulement auth).
export const VALIDATION_ERROR = 'VALIDATION_ERROR';
export const NOT_FOUND = 'NOT_FOUND';
export const UNAUTHORIZED = 'UNAUTHORIZED';
export const INTERNAL_ERROR = 'INTERNAL_ERROR';

// BE-11 : rate limiting (OTP, puis contacts via BE-21).
export const RATE_LIMIT_EXCEEDED = 'RATE_LIMIT_EXCEEDED';

// BE-12 : RBAC — authentifié mais rôle/propriété insuffisants (distinct de UNAUTHORIZED, 401).
export const FORBIDDEN = 'FORBIDDEN';

// BE-19 : onboarding artisan.
export const PROVIDER_PROFILE_NOT_FOUND = 'PROVIDER_PROFILE_NOT_FOUND';
export const PROVIDER_PROFILE_ALREADY_EXISTS = 'PROVIDER_PROFILE_ALREADY_EXISTS';
export const PROVIDER_PROFILE_INCOMPLETE = 'PROVIDER_PROFILE_INCOMPLETE';

// BE-20 : upload de médias.
export const MEDIA_UNSUPPORTED_TYPE = 'MEDIA_UNSUPPORTED_TYPE';
export const MEDIA_TOO_LARGE = 'MEDIA_TOO_LARGE';
export const MEDIA_NOT_FOUND = 'MEDIA_NOT_FOUND';

// BE-21 : révélation du numéro — aucune contrainte DB ne garantit qu'un artisan a rempli le
// champ correspondant au canal demandé (whatsappPhone/publicPhone sont tous deux nullable).
export const PROVIDER_CONTACT_CHANNEL_UNAVAILABLE = 'PROVIDER_CONTACT_CHANNEL_UNAVAILABLE';

// BE-22 : dépôt d'avis — aucun ContactEvent éligible (absent, trop récent, trop ancien, ou déjà
// utilisé par un avis existant — y compris la variante course entre deux requêtes quasi-simultanées).
export const REVIEW_REQUIRES_CONTACT = 'REVIEW_REQUIRES_CONTACT';

// BE-30 / BE-31 : vérification d'identité (KYC).
export const KYC_ALREADY_VERIFIED = 'KYC_ALREADY_VERIFIED';
export const KYC_REQUEST_ALREADY_PENDING = 'KYC_REQUEST_ALREADY_PENDING';
export const KYC_INVALID_CIN = 'KYC_INVALID_CIN';
export const KYC_DOCUMENT_NOT_FOUND = 'KYC_DOCUMENT_NOT_FOUND';
export const KYC_REQUEST_NOT_FOUND = 'KYC_REQUEST_NOT_FOUND';
export const KYC_REASON_REQUIRED = 'KYC_REASON_REQUIRED';
export const KYC_INVALID_STATUS_TRANSITION = 'KYC_INVALID_STATUS_TRANSITION';
export const KYC_DOCUMENT_ALREADY_PURGED = 'KYC_DOCUMENT_ALREADY_PURGED';
