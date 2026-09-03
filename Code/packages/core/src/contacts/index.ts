export { shouldDeduplicate, DEDUP_WINDOW_MINUTES } from './dedup.js';
export type { ContactChannel, ShouldDeduplicateInput } from './dedup.js';

export { buildSessionFingerprint, hashIp } from './fingerprint.js';
export type { BuildSessionFingerprintInput } from './fingerprint.js';

export { buildWhatsAppMessage } from './whatsapp-message.js';
export type { BuildWhatsAppMessageInput } from './whatsapp-message.js';

export { buildContactEventLog } from './event-log.js';
export type { BuildContactEventLogInput } from './event-log.js';

export { buildContactHistoryListItem } from './history-item.js';
export type {
  ContactHistoryRecord,
  ContactHistoryProviderSummary,
  ContactHistoryListItem,
} from './history-item.js';
