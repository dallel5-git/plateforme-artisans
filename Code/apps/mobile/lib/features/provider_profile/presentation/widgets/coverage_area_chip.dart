import 'package:flutter/material.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';

/// Puce affichant une zone d'intervention (gouvernorat ou délégation).
class CoverageAreaChip extends StatelessWidget {
  const CoverageAreaChip({
    required this.label,
    super.key,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceSunken,
        borderRadius: const BorderRadius.all(AppRadius.pill),
        border: Border.all(color: colors.border),
      ),
      child: Text(
        label,
        style: AppText.small(locale).copyWith(
          color: colors.textSecondary,
        ),
      ),
    );
  }
}
