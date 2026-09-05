import 'package:flutter/material.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';

/// Titre de section discret (majuscule visuelle par la graisse, pas par
/// `toUpperCase()` — l'arabe n'a pas de casse, FM-41/#238). Remplace le
/// `_SectionHeader` privé de `AccountSettingsSection` (`settings_screen.dart`
/// dans l'issue d'origine, renommé depuis) et ses recopies.
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: AppSpacing.xs,
        bottom: AppSpacing.xs,
      ),
      child: Text(
        title,
        style: AppText.small(
          locale,
        ).copyWith(color: colors.textSecondary, fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// Séparateur horizontal partagé, épaisseur/couleur de bordure fixées par
/// les design tokens (FM-15) plutôt que redéclarées à chaque écran.
class AppDivider extends StatelessWidget {
  const AppDivider({super.key, this.indent = 0});

  final double indent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Divider(
      height: 1,
      thickness: 1,
      indent: indent,
      color: colors.border,
    );
  }
}
