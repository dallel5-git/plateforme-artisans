/**
 * BE-45 — `packages/core/src/contacts/history-item.ts`
 *
 * Pure : assemble une ligne de `GET /v1/contact-events` à partir d'un `ContactEvent`, d'un résumé
 * de prestataire, d'un nom de catégorie déjà résolu et d'un canal déjà converti. Aucun accès base
 * ni réseau.
 */
import { describe, expect, it } from 'vitest';
import { buildContactHistoryListItem } from '../src/contacts/history-item.js';

describe('BE-45 — buildContactHistoryListItem', () => {
  it('assemble le contact et le résumé du prestataire en une ligne de réponse', () => {
    const event = {
      id: 'event-1',
      providerId: 'provider-1',
      createdAt: new Date('2026-08-20T10:00:00Z'),
      hasReview: false,
    };
    const provider = { slug: 'ahmed-plombier-sousse', businessName: 'Ahmed Plomberie' };

    expect(buildContactHistoryListItem(event, provider, 'Plomberie', 'WHATSAPP')).toEqual({
      id: 'event-1',
      providerId: 'provider-1',
      slug: 'ahmed-plombier-sousse',
      businessName: 'Ahmed Plomberie',
      categoryName: 'Plomberie',
      channel: 'WHATSAPP',
      contactedAt: event.createdAt,
      hasReview: false,
    });
  });

  it('reporte hasReview tel quel — le CTA de dépôt d’avis (FM-31) en dépend directement', () => {
    const event = {
      id: 'event-2',
      providerId: 'provider-2',
      createdAt: new Date('2026-08-21T08:00:00Z'),
      hasReview: true,
    };
    const provider = { slug: 'sami-electricien', businessName: 'Sami Électricité' };

    expect(buildContactHistoryListItem(event, provider, null, 'PHONE').hasReview).toBe(true);
  });

  it('accepte une catégorie absente (categoryId optionnel côté POST /contact-events)', () => {
    const event = {
      id: 'event-3',
      providerId: 'provider-3',
      createdAt: new Date('2026-08-22T08:00:00Z'),
      hasReview: false,
    };
    const provider = { slug: 'lotfi-peintre', businessName: 'Lotfi Peinture' };

    expect(buildContactHistoryListItem(event, provider, null, 'PHONE').categoryName).toBeNull();
  });
});
