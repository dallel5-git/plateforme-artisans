import 'package:flutter/material.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';

/// Rôle sémantique d'un [AppBadge] — détermine la paire couleur/fond.
///
/// `sponsored` n'a pas de fond dédié dans les design tokens (FM-15) : il
/// réutilise `pendingSubtle`, même choix déjà fait par `BoostOptionCard`
/// (FM-40) avant que ce composant partagé n'existe.
enum AppBadgeVariant { pending, danger, neutral, sponsored, verified, accent }

/// Pastille de statut générique (design-system.html §5, issue FM-41/#238).
///
/// Remplace les réimplémentations ad hoc (`AvailabilityChip`,
/// `CoverageAreaChip`, la puce de `DashboardComparisonChip`, celle de
/// `ReviewTile`) qui redessinaient toutes le même conteneur pilule +
/// texte/icône. Le badge « Vérifié » (`VerifiedBadge`) garde son propre
/// widget dédié (texte + icône figés, ADR-002) ; `AppBadgeVariant.verified`
/// sert aux autres endroits qui veulent la même palette sans son texte fixe.
class AppBadge extends StatelessWidget {
  const AppBadge({
    required this.label,
    required this.variant,
    super.key,
    this.icon,
    this.bordered = false,
  });

  final String label;
  final AppBadgeVariant variant;

  /// Icône optionnelle affichée avant le texte (ex. ✓ pour un contact vérifié).
  final IconData? icon;

  /// `true` pour un contour visible plutôt qu'un simple fond teinté
  /// (ex. `CoverageAreaChip`, qui se détache sur un fond déjà `surfaceSunken`).
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    final (foreground, background) = switch (variant) {
      AppBadgeVariant.pending => (colors.pending, colors.pendingSubtle),
      AppBadgeVariant.danger => (colors.destructive, colors.destructiveSubtle),
      AppBadgeVariant.neutral => (colors.textSecondary, colors.surfaceSunken),
      AppBadgeVariant.sponsored => (colors.sponsored, colors.pendingSubtle),
      AppBadgeVariant.verified => (colors.verified, colors.verifiedSubtle),
      AppBadgeVariant.accent => (colors.accent, colors.accentSubtle),
    };

    return Semantics(
      label: label,
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: const BorderRadius.all(AppRadius.pill),
          border: bordered ? Border.all(color: colors.border) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 12, color: foreground),
              const SizedBox(width: AppSpacing.xxs),
            ],
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppText.caption(
                  locale,
                ).copyWith(color: foreground, height: 1.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
