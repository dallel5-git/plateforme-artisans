import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/i18n/format.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/app_card.dart';
import 'package:sanaya/features/contact/domain/contact_channel.dart';
import 'package:sanaya/features/history/data/contact_history_repository.dart';
import 'package:sanaya/features/history/presentation/widgets/contact_channel_badge.dart';

/// Miroir léger de l'enum généré propre à `/v1/contact-events` vers le
/// domaine `ContactChannel` déjà partagé avec `ContactButtons` (même
/// convention que `contact_channel.dart`, pas de règle métier, juste un
/// typage — P3).
ContactChannel _toContactChannel(
  V1ContactEventsGet200ResponseItemsInnerChannelEnum channel,
) => switch (channel) {
  V1ContactEventsGet200ResponseItemsInnerChannelEnum.WHATSAPP =>
    ContactChannel.whatsapp,
  _ => ContactChannel.phone,
};

/// Carte d'une entrée d'historique (FM-31) — artisan contacté, canal, date,
/// CTA de dépôt d'avis conditionnel. Gabarit `AppCard` repris de
/// `FavoriteCard`. `businessName`/`categoryName` arrivent déjà résolus par
/// l'API (P3, BE-45) — aucun second appel `GET /providers/:slug` ici.
class HistoryEntryCard extends ConsumerWidget {
  const HistoryEntryCard({required this.item, super.key});

  final ContactHistoryItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final t = ref.watch(translationsProvider);

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: const BorderRadius.all(AppRadius.lg),
        onTap: () => context.pushNamed(
          'provider-profile',
          pathParameters: {'slug': item.slug},
        ),
        child: AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.businessName,
                          style: AppText.bodyStrong(
                            locale,
                          ).copyWith(color: colors.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.categoryName.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            item.categoryName,
                            style: AppText.small(
                              locale,
                            ).copyWith(color: colors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ContactChannelBadge(
                              channel: _toContactChannel(item.channel),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              formatDate(item.contactedAt, locale),
                              style: AppText.caption(
                                locale,
                              ).copyWith(color: colors.textMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (!item.hasReview) ...[
                    const SizedBox(width: AppSpacing.sm),
                    AppButton(
                      label: t.history.reviewCta,
                      variant: AppButtonVariant.secondary,
                      size: AppButtonSize.small,
                      onPressed: () => context.pushNamed(
                        'provider-review',
                        pathParameters: {'slug': item.slug},
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
