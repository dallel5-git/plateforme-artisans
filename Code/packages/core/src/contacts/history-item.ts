export interface ContactHistoryRecord {
  id: string;
  providerId: string;
  createdAt: Date;
  hasReview: boolean;
}

export interface ContactHistoryProviderSummary {
  slug: string;
  businessName: string;
}

export interface ContactHistoryListItem {
  id: string;
  providerId: string;
  slug: string;
  businessName: string;
  categoryName: string | null;
  channel: 'PHONE' | 'WHATSAPP';
  contactedAt: Date;
  hasReview: boolean;
}

// BE-45 : assemble une ligne de `GET /v1/contact-events` — même logique que
// `buildFavoriteListItem` (favorites/list-item.ts, BE-25) : pas d'identifiant interne autre que
// `providerId`/`id`, tout le reste déjà résolu côté serveur (P3).
export function buildContactHistoryListItem(
  event: ContactHistoryRecord,
  provider: ContactHistoryProviderSummary,
  categoryName: string | null,
  channel: 'PHONE' | 'WHATSAPP',
): ContactHistoryListItem {
  return {
    id: event.id,
    providerId: event.providerId,
    slug: provider.slug,
    businessName: provider.businessName,
    categoryName,
    channel,
    contactedAt: event.createdAt,
    hasReview: event.hasReview,
  };
}
