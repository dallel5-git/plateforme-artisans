import 'package:flutter/material.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_selectable_card.dart';

/// Carte d'option sélectionnable (catégorie ou zone) — remplace le
/// `Checkbox`+`ChoiceChip` bruts de FM-11 (issue #231/FM-34). Fine enveloppe
/// autour d'`AppSelectableCard` (FM-41) : ne porte que le contenu spécifique
/// à l'onboarding (libellé + badge « Principal » optionnel), la carte
/// partagée gère sélection/désactivation/indicateur.
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

    return AppSelectableCard(
      selected: selected,
      enabled: enabled,
      onTap: onTap,
      // FM-43 : réutilise le libellé déjà affiché comme annonce
      // d'accessibilité de la carte (même choix que category_grid.dart).
      semanticLabel: label,
      trailing: selected && primaryBadgeLabel != null
          ? Semantics(
              // FM-43 : sans `container: true`, ce nœud fusionnerait dans
              // le Semantics(button:) de la carte englobante (ci-dessus) —
              // le tap « marquer comme principal » deviendrait alors
              // injoignable au lecteur d'écran (un seul bouton pour deux
              // actions distinctes : sélectionner la carte, ou la marquer
              // principale).
              container: true,
              button: true,
              label: primaryBadgeLabel,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: AppLayout.touchTarget,
                ),
                child: InkWell(
                  onTap: onTapPrimaryBadge,
                  customBorder: const StadiumBorder(),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isPrimary ? colors.accent : colors.surfaceSunken,
                        borderRadius: const BorderRadius.all(AppRadius.pill),
                      ),
                      // FM-43 : `ExcludeSemantics` ne porte que sur ce
                      // `Text` — pas sur tout le sous-arbre (cf.
                      // commentaire d'`AppSelectableCard`) — sinon
                      // l'action `tap` implicite de l'`InkWell`
                      // ci-dessus disparaîtrait aussi, rendant le badge
                      // inactivable au lecteur d'écran (juste une
                      // étiquette statique). Seul le libellé implicite
                      // du `Text` (qui dupliquerait `primaryBadgeLabel`
                      // ci-dessus) doit être supprimé.
                      child: ExcludeSemantics(
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
                  ),
                ),
              ),
            )
          : null,
      indicator: primaryBadgeLabel != null
          ? AppSelectableCardIndicator.none
          : AppSelectableCardIndicator.check,
      child: Text(
        label,
        style: AppText.body(locale).copyWith(
          color: colors.textPrimary,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
    );
  }
}
