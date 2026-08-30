import 'package:flutter/material.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_card.dart';
import 'package:sanaya/features/dashboard/presentation/widgets/dashboard_comparison_chip.dart';

/// Une tuile du tableau de bord : libellé, valeur totale, puce de variation
/// mois-1 optionnelle (`totalsViews`/`totalsContacts` seulement — le ratio
/// vue→contact et les visiteurs uniques n'ont pas d'équivalent dans
/// `DashboardComparison`, FM-12b).
class DashboardStatCard extends StatelessWidget {
  const DashboardStatCard({
    required this.label,
    required this.value,
    super.key,
    this.comparisonRatio,
    this.comparisonNewLabel,
  });

  final String label;
  final String value;
  final double? comparisonRatio;
  final String? comparisonNewLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final newLabel = comparisonNewLabel;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppText.small(locale).copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppText.h2(locale).copyWith(color: colors.textPrimary),
          ),
          if (newLabel != null) ...[
            const SizedBox(height: AppSpacing.xs),
            DashboardComparisonChip(
              deltaRatio: comparisonRatio,
              newLabel: newLabel,
            ),
          ],
        ],
      ),
    );
  }
}
