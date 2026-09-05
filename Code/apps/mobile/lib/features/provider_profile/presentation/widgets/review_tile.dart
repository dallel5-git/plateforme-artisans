import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/i18n/format.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_badge.dart';
import 'package:sanaya/core/widgets/app_card.dart';
import 'package:sanaya/core/widgets/rating_stars.dart';

/// Tuile affichant un avis client sur la fiche artisan.
class ReviewTile extends ConsumerWidget {
  const ReviewTile({required this.review, super.key});

  final V1ProvidersSlugReviewsGet200ResponseItemsInner review;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final t = ref.watch(translationsProvider);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  review.authorDisplayName,
                  style: AppText.bodyStrong(
                    locale,
                  ).copyWith(color: colors.textPrimary),
                ),
              ),
              Text(
                formatDate(review.createdAt, locale),
                style: AppText.small(locale).copyWith(color: colors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              RatingStars(rating: review.rating.toDouble()),
              if (review.isVerifiedContact) ...[
                const SizedBox(width: AppSpacing.sm),
                AppBadge(
                  label: t.provider.profile.verifiedContact,
                  variant: AppBadgeVariant.verified,
                  icon: Icons.check,
                ),
              ],
            ],
          ),
          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              review.comment,
              style: AppText.body(locale).copyWith(color: colors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}
