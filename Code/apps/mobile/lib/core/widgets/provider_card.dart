import 'package:flutter/material.dart';

import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_card.dart';
import 'package:sanaya/core/widgets/rating_stars.dart';
import 'package:sanaya/core/widgets/verified_badge.dart';

/// Carte artisan (design-system.html §7) — le composant le plus vu du
/// produit. Purement présentation : `categoryLabel`/`locationLabel`/
/// `priceLabel` arrivent déjà formatés par l'appelant (API `displayPrice`,
/// `distanceLabel` — CLAUDE.md §3.3, aucune règle métier dupliquée en Dart).
/// `isVerified` pilote l'affichage de [VerifiedBadge] ; ce widget ne lit
/// jamais `Subscription`/`Plan` lui-même (ADR-002).
class ProviderCard extends StatelessWidget {
  const ProviderCard({
    required this.name,
    required this.categoryLabel,
    required this.locationLabel,
    required this.rating,
    super.key,
    this.reviewCount,
    this.priceLabel,
    this.isVerified = false,
    this.onTap,
  });

  final String name;
  final String categoryLabel;
  final String locationLabel;
  final double rating;
  final int? reviewCount;
  final String? priceLabel;
  final bool isVerified;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    // Material(transparency), pas de Material ambiant : même raison que
    // AppButton (design-system.html §4) — un MaterialApp ne fournit pas de
    // Material sur son `home` (seul Scaffold en insère un), et InkWell en
    // exige un ancêtre pour dessiner ses ripples.
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(AppRadius.lg),
        child: AppCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(initials: _initialsOf(name), colors: colors),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            style: AppText.bodyStrong(
                              locale,
                            ).copyWith(color: colors.textPrimary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isVerified) ...[
                          const SizedBox(width: AppSpacing.xs),
                          const VerifiedBadge(),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      '$categoryLabel · $locationLabel',
                      style: AppText.small(
                        locale,
                      ).copyWith(color: colors.textSecondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RatingStars(rating: rating, reviewCount: reviewCount),
                        if (priceLabel != null)
                          Text(
                            priceLabel!,
                            style: AppText.small(
                              locale,
                            ).copyWith(color: colors.accent, height: 1),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _initialsOf(String name) {
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    final letters = words.take(2).map((w) => w[0].toUpperCase());
    return letters.join();
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials, required this.colors});

  final String initials;
  final AppColors colors;

  static const double _size = 48;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.accentSubtle,
        shape: BoxShape.circle,
      ),
      child: Text(
        initials,
        style: AppText.bodyStrong(
          Localizations.localeOf(context),
        ).copyWith(color: colors.accent),
      ),
    );
  }
}
