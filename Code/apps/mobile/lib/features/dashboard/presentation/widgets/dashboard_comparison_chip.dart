import 'package:flutter/material.dart';
import 'package:sanaya/core/i18n/format.dart';
import 'package:sanaya/core/widgets/app_badge.dart';

/// Puce de variation mois-1 (`DashboardComparison`, FM-12b). `deltaRatio ==
/// null` signifie une période précédente à zéro : pas de pourcentage
/// significatif, on affiche `newLabel` plutôt qu'une fausse variation
/// (division par zéro déjà évitée en amont, voir `dashboard_comparison.dart`).
class DashboardComparisonChip extends StatelessWidget {
  const DashboardComparisonChip({
    required this.deltaRatio,
    required this.newLabel,
    super.key,
  });

  final double? deltaRatio;
  final String newLabel;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    final ratio = deltaRatio;
    if (ratio == null) {
      return AppBadge(label: newLabel, variant: AppBadgeVariant.accent);
    }

    final isFlat = ratio == 0;
    final isUp = ratio > 0;
    final variant = isFlat
        ? AppBadgeVariant.neutral
        : isUp
        ? AppBadgeVariant.verified
        : AppBadgeVariant.danger;
    final sign = isFlat
        ? ''
        : isUp
        ? '+'
        : '-';
    final percent = formatNumber(ratio.abs() * 100, locale);
    final label = '$sign$percent%';

    return AppBadge(label: label, variant: variant);
  }
}
