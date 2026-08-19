const ARABIC_INDIC_DIGITS_START = 0x0660;

const VALID_LOCAL_PREFIXES = new Set(['2', '4', '5', '7', '9']);

function toAsciiDigits(input: string): string {
  return input.replace(/[٠-٩]/g, (digit) =>
    String(digit.charCodeAt(0) - ARABIC_INDIC_DIGITS_START),
  );
}

// La longueur totale désambiguïse le préfixe international : un "216" qui laisse
// exactement 8 chiffres derrière lui est un indicatif, pas le début du numéro local.
function extractLocalNumber(digitsOnly: string): string {
  if (digitsOnly.startsWith('00216') && digitsOnly.length === 13) {
    return digitsOnly.slice(5);
  }
  if (digitsOnly.startsWith('216') && digitsOnly.length === 11) {
    return digitsOnly.slice(3);
  }
  return digitsOnly;
}

export function normalizePhoneTn(input: string | null | undefined): string | null {
  if (typeof input !== 'string') return null;

  const digitsOnly = toAsciiDigits(input).replace(/\D/g, '');
  if (digitsOnly.length === 0) return null;

  const local = extractLocalNumber(digitsOnly);
  if (local.length !== 8) return null;
  if (!VALID_LOCAL_PREFIXES.has(local.charAt(0))) return null;

  return `+216${local}`;
}

export function isValidPhoneTn(input: string | null | undefined): boolean {
  return normalizePhoneTn(input) !== null;
}

export function formatPhoneTnDisplay(e164: string): string {
  const local = e164.slice(4);
  return `+216 ${local.slice(0, 2)} ${local.slice(2, 5)} ${local.slice(5, 8)}`;
}
