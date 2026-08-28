import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_card.dart';
import 'package:sanaya/core/widgets/rating_stars.dart';
import 'package:sanaya/core/widgets/verified_badge.dart';
import 'package:sanaya/features/contact/presentation/contact_buttons.dart';
import 'package:sanaya/features/favorites/application/favorites_providers.dart';
import 'package:sanaya/features/favorites/data/favorites_repository.dart';

/// Carte affichant un artisan favori (US-C-08, FM-13).
/// Présentation pure basée sur [AppCard], avec boutons de contact intégrés
/// ([ContactButtons], traçage P9) et bouton de retrait des favoris.
class FavoriteCard extends ConsumerWidget {
  const FavoriteCard({
    required this.item,
    super.key,
    this.onTap,
  });

  final FavoriteItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final t = ref.watch(translationsProvider);

    return AppCard(
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
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            item.businessName,
                            style: AppText.bodyStrong(locale).copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (item.isVerified) ...[
                          const SizedBox(width: AppSpacing.xs),
                          const VerifiedBadge(),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      item.headline,
                      style: AppText.small(locale).copyWith(
                        color: colors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    RatingStars(
                      rating: item.ratingAvg.toDouble(),
                      reviewCount: item.ratingCount.toInt(),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: colors.accent,
                ),
                tooltip: t.favorites.removeTooltip,
                onPressed: () async {
                  try {
                    await ref
                        .read(favoritesListProvider.notifier)
                        .removeFavorite(item.providerId);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(t.favorites.removeSuccess),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  } on Object {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(t.favorites.removeError),
                          backgroundColor: colors.destructive,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ContactButtons(
            providerId: item.providerId,
            sourceScreen: 'favorites',
          ),
        ],
      ),
    );
  }
}
