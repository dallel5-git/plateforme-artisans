import 'package:flutter/material.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';

/// Carte d'option sélectionnable (catégorie ou zone) — remplace le
/// `Checkbox`+`ChoiceChip` bruts de FM-11 (issue #231/FM-34). Générique à
/// dessein pour être absorbée par `AppSelectableCard` (FM-41) le jour où ce
/// composant partagé existe ; pas de dépendance sur FM-41 aujourd'hui, il
/// n'est pas encore livré.
///
/// Fond `accentSubtle` si sélectionnée, [primaryBadgeLabel] optionnel (« ex.
/// Principal ») pour distinguer une sélection unique parmi plusieurs
/// (catégorie principale), ✓ sinon.
class OnboardingSelectableOptionCard extends StatelessWidget {
  const OnboardingSelectableOptionCard({
    required this.label,
    required this.selected,
    required this.enabled,
    required this.onTap,
    super.key,
    this.isPrimary = false,
    this.primaryBadgeLabel,
    this.onTapPrimaryBadge,
  });

  final String label;
  final bool selected;

  /// `false` au-delà du plafond (P5/UX : désactiver plutôt que bloquer au
  /// moment de sauvegarder, cf. critère d'acceptation de l'issue).
  final bool enabled;
  final VoidCallback onTap;

  /// `true` si c'est l'option marquée comme principale (une seule à la
  /// fois — imposé par l'appelant, pas par cette carte).
  final bool isPrimary;

  /// `null` = pas de notion de « principal » pour ce type d'option (zones).
  final String? primaryBadgeLabel;
  final VoidCallback? onTapPrimaryBadge;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: const BorderRadius.all(AppRadius.md),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: selected ? colors.accentSubtle : colors.surface,
            border: Border.all(
              color: selected ? colors.accent : colors.border,
            ),
            borderRadius: const BorderRadius.all(AppRadius.md),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppText.body(locale).copyWith(
                    color: colors.textPrimary,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
              if (selected && primaryBadgeLabel != null) ...[
                const SizedBox(width: AppSpacing.sm),
                GestureDetector(
                  onTap: onTapPrimaryBadge,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isPrimary ? colors.accent : colors.surfaceSunken,
                      borderRadius: const BorderRadius.all(AppRadius.pill),
                    ),
                    child: Text(
                      primaryBadgeLabel!,
                      style: AppText.small(locale).copyWith(
                        color: isPrimary
                            ? colors.onAccent
                            : colors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ] else if (selected) ...[
                const SizedBox(width: AppSpacing.sm),
                Icon(Icons.check_circle, color: colors.accent, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
