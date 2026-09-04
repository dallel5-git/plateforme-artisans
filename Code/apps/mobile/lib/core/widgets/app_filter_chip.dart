import 'package:flutter/material.dart';

import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';

/// Puce de filtre (design-system.html — maquette A1), utilisée pour les
/// filtres de résultats de recherche (Vérifié / Note 4+ / Urgence, FM-27/28).
/// Purement présentation : l'appelant possède l'état sélectionné et décide
/// de la sémantique du filtre, ce widget ne fait qu'afficher/toggler.
class AppFilterChip extends StatelessWidget {
  const AppFilterChip({
    required this.label,
    required this.selected,
    super.key,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(AppRadius.pill),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: selected ? colors.accent : Colors.transparent,
            borderRadius: const BorderRadius.all(AppRadius.pill),
            border: selected ? null : Border.all(color: colors.border),
          ),
          child: Text(
            label,
            style: AppText.small(locale).copyWith(
              color: selected ? colors.onAccent : colors.textSecondary,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
