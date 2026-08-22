import { createHash } from 'node:crypto';

export interface BuildSessionFingerprintInput {
  userId: string;
  deviceId: string;
  ip: string;
}

// P8 : jamais l'IP/userId/deviceId en clair dans l'empreinte (elle finit en base et dans les
// logs). JSON.stringify évite toute ambiguïté de délimiteur entre les trois champs — une IPv6
// contient des ':', un join naïf par ':' collisionnerait.
export function buildSessionFingerprint(input: BuildSessionFingerprintInput): string {
  return createHash('sha256')
    .update(JSON.stringify([input.userId, input.deviceId, input.ip]))
    .digest('hex');
}

export function hashIp(ip: string): string {
  return createHash('sha256').update(ip).digest('hex');
}
