import 'package:flutter/material.dart';
import 'package:sanaya/core/i18n/format.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';

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
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    final ratio = deltaRatio;
    if (ratio == null) {
      return _Chip(
        label: newLabel,
        color: colors.accent,
        background: colors.accentSubtle,
      );
    }

    final isFlat = ratio == 0;
    final isUp = ratio > 0;
    final color = isFlat
        ? colors.textMuted
        : isUp
        ? colors.verified
        : colors.destructive;
    final background = isFlat
        ? colors.surfaceSunken
        : isUp
        ? colors.verifiedSubtle
        : colors.destructiveSubtle;
    final sign = isFlat
        ? ''
        : isUp
        ? '+'
        : '-';
    final percent = formatNumber(ratio.abs() * 100, locale);
    final label = '$sign$percent%';

    return _Chip(label: label, color: color, background: background);
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: const BorderRadius.all(AppRadius.pill),
      ),
      child: Text(
        label,
        style: AppText.caption(locale).copyWith(color: color),
      ),
    );
  }
}
