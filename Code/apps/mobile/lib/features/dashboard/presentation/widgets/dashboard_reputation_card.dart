import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/core/i18n/format.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/app_card.dart';
import 'package:sanaya/core/widgets/rating_stars.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';

/// Synthèse des avis clients et réputation sur le tableau de bord pro.
class DashboardReputationCard extends StatelessWidget {
  const DashboardReputationCard({
    required this.t,
    this.profile,
    super.key,
  });

  final Translations t;
  final ProviderMe? profile;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    final ratingAvg = profile?.ratingAvg ?? 4.9;
    final ratingCount = profile?.ratingCount ?? 28;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star_rounded, size: 20, color: colors.rating),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  t.dashboard.reputationTitle,
                  style: AppText.bodyStrong(locale).copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: colors.verified.withValues(alpha: 0.12),
              borderRadius: const BorderRadius.all(AppRadius.pill),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_rounded, size: 12, color: colors.verified),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    t.dashboard.reputationBadge,
                    style: AppText.caption(locale).copyWith(
                      color: colors.verified,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                formatNumber(ratingAvg, locale),
                style: AppText.h1(locale).copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RatingStars(rating: ratingAvg.toDouble()),
                    const SizedBox(height: 2),
                    Text(
                      t.dashboard.reputationCount(count: ratingCount),
                      style: AppText.caption(locale).copyWith(
                        color: colors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: colors.surfaceSunken,
              borderRadius: const BorderRadius.all(AppRadius.md),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.dashboard.reputationLatestReview,
                  style: AppText.caption(locale).copyWith(
                    color: colors.textPrimary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    t.dashboard.reputationAuthor,
                    style: AppText.caption(locale).copyWith(
                      color: colors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: t.dashboard.reputationSeeAll,
            variant: AppButtonVariant.secondary,
            icon: const Icon(Icons.arrow_forward_rounded, size: 16),
            onPressed: () => context.go('/pro/reviews'),
          ),
        ],
      ),
    );
  }
}
