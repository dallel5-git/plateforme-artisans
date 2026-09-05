import 'package:flutter/material.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';

/// Indicateur affiché à droite du contenu quand aucun
/// [AppSelectableCard.trailing] n'est fourni.
enum AppSelectableCardIndicator {
  /// Rien (le contenu porte lui-même son propre repère de sélection).
  none,

  /// ✓ visible uniquement à l'état sélectionné (choix multiple — catégories,
  /// zones de couverture, FM-34).
  check,

  /// ⦿/○ toujours visible, les deux états (choix exclusif — durée de boost,
  /// FM-40).
  radio,
}

/// Carte générique à état sélectionné (design-system.html, issue FM-41/#238).
///
/// Remplace `OnboardingSelectableOptionCard` (FM-34, catégories/zones) et
/// `BoostOptionCard` (FM-40, durée de boost) — les deux composaient déjà le
/// même patron (contour + fond teinté quand sélectionné, `Opacity` quand
/// désactivé) avec un contenu et une couleur d'accent différents. [child]
/// porte tout l'affichage (titre seul, ou titre + description + prix) ;
/// cette carte ne gère que l'état sélectionné/désactivé et l'indicateur.
class AppSelectableCard extends StatelessWidget {
  const AppSelectableCard({
    required this.selected,
    required this.onTap,
    required this.child,
    super.key,
    this.enabled = true,
    this.indicator = AppSelectableCardIndicator.check,
    this.accentColor,
    this.selectedBackground,
    this.selectedBorderWidth = 1.0,
    this.trailing,
    this.semanticLabel,
  });

  final bool selected;

  /// `false` désactive le tap et atténue la carte (P5/UX : désactiver
  /// plutôt que bloquer au moment de sauvegarder — plafond FREE FM-34).
  final bool enabled;
  final VoidCallback onTap;
  final Widget child;
  final AppSelectableCardIndicator indicator;

  /// Couleur d'accent de la sélection (bordure, indicateur). `null` =
  /// `colors.accent` (défaut design-system). FM-40 (boosts) passe
  /// `colors.amber`.
  final Color? accentColor;

  /// Fond quand sélectionnée. `null` = `colors.accentSubtle`. FM-40 passe
  /// `colors.amber` atténué (aucun token `amberSubtle` dédié).
  final Color? selectedBackground;

  /// Épaisseur du contour à l'état sélectionné (1.0 = FM-34, 2.0 = FM-40).
  final double selectedBorderWidth;

  /// Widget optionnel remplaçant [indicator] (ex. badge « Principal »,
  /// FM-34 catégorie principale).
  final Widget? trailing;

  /// Libellé d'accessibilité optionnel — sinon le contenu de [child] doit
  /// porter ses propres `Semantics`.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = accentColor ?? colors.accent;
    final background = selected
        ? (selectedBackground ?? colors.accentSubtle)
        : colors.surface;

    final indicatorWidget = trailing ?? _buildIndicator(colors, accent);

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Semantics(
        button: true,
        selected: selected,
        label: semanticLabel,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: const BorderRadius.all(AppRadius.md),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: background,
              border: Border.all(
                color: selected ? accent : colors.border,
                width: selected ? selectedBorderWidth : 1.0,
              ),
              borderRadius: const BorderRadius.all(AppRadius.md),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: child),
                if (indicatorWidget != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  indicatorWidget,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildIndicator(AppColors colors, Color accent) {
    switch (indicator) {
      case AppSelectableCardIndicator.none:
        return null;
      case AppSelectableCardIndicator.check:
        return selected
            ? Icon(Icons.check_circle, color: accent, size: 20)
            : null;
      case AppSelectableCardIndicator.radio:
        return Icon(
          selected ? Icons.radio_button_checked : Icons.radio_button_off,
          color: selected ? accent : colors.textMuted,
          size: AppIconSize.md,
        );
    }
  }
}
