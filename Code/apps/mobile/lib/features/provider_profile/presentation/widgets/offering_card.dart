import 'package:flutter/material.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_card.dart';

/// Carte affichant une prestation proposée par l'artisan.
/// Le `displayPrice` est calculé côté API (P3 CLAUDE.md).
class OfferingCard extends StatelessWidget {
  const OfferingCard({
    required this.offering,
    super.key,
  });

  final V1ProvidersSlugGet200ResponseOfferingsInner offering;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    final title = isArabic && offering.titleAr.isNotEmpty
        ? offering.titleAr
        : offering.titleFr;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppText.bodyStrong(locale).copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
              if (offering.displayPrice.isNotEmpty) ...[
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    offering.displayPrice,
                    style: AppText.bodyStrong(locale).copyWith(
                      color: colors.accent,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ],
          ),
          if (offering.description.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              offering.description,
              style: AppText.small(locale).copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
