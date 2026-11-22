import 'package:flutter/material.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';

/// Indicateur KPI compact à l'intérieur de [DashboardKpiCard].
/// Utilisé exclusivement par [DashboardKpiCard] — ne pas exporter seul.
class _KpiItem extends StatelessWidget {
  const _KpiItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    // Hérite du thème du parent (fond accent) via InheritedWidget — les
    // couleurs `onAccent` sont appliquées ici via DefaultTextStyle.
    final style = DefaultTextStyle.of(context).style;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppText.small(locale).copyWith(
              color: style.color?.withAlpha(180),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xxs),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(
              value,
              style: AppText.h2(locale).copyWith(color: style.color),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Carte KPI bleue du tableau de bord pro (FM-37b, issue #234, maquette A2).
///
/// Regroupe les trois métriques clés — **Vues du profil**, **Contacts** et
/// **Vue → Contact** — dans un seul conteneur sur fond `accent`, avec les
/// textes en `onAccent`.  La variation mois-1 ([viewsDeltaRatio],
/// [contactsDeltaRatio]) est optionnelle : quand elle est fournie, elle
/// s'affiche en sous-titre de la valeur concernée.
///
/// Remplace la grille 2×2 de DashboardStatCard : les vues uniques
/// (`uniqueProfileViews`) ne sont plus affichées dans la carte
/// (elles ne figurent pas dans les maquettes A2/C2 de l'issue) mais restent
/// disponibles dans `ProviderStats.totals` pour un usage futur.
///
/// Exemple d'utilisation :
/// ```dart
/// DashboardKpiCard(
///   viewsLabel: t.dashboard.statViews,
///   viewsValue: '${totals.profileViews}',
///   contactsLabel: t.dashboard.statContacts,
///   contactsValue: '${totals.contacts}',
///   ratioLabel: t.dashboard.statRatio,
///   ratioValue: ratioLabel,
///   viewsDeltaRatio: comparison.viewsDeltaRatio,
///   contactsDeltaRatio: comparison.contactsDeltaRatio,
///   comparisonNewLabel: t.dashboard.comparisonNew,
///   comparisonPeriodLabel: t.dashboard.comparisonPreviousPeriod,
/// )
/// ```
class DashboardKpiCard extends StatelessWidget {
  const DashboardKpiCard({
    required this.viewsLabel,
    required this.viewsValue,
    required this.contactsLabel,
    required this.contactsValue,
    required this.ratioLabel,
    required this.ratioValue,
    required this.comparisonPeriodLabel,
    super.key,
    this.viewsDeltaRatio,
    this.contactsDeltaRatio,
    this.comparisonNewLabel,
  });

  final String viewsLabel;
  final String viewsValue;
  final String contactsLabel;
  final String contactsValue;
  final String ratioLabel;
  final String ratioValue;

  /// Variation relative des vues (entre −1 et +∞), `null` si non disponible.
  final double? viewsDeltaRatio;

  /// Variation relative des contacts, mêmes règles que [viewsDeltaRatio].
  final double? contactsDeltaRatio;

  /// Libellé de la puce « Nouveau » affiché quand le delta est nul ou
  /// négatif depuis zéro.  Si `null`, la puce n'est pas affichée du tout.
  final String? comparisonNewLabel;

  /// Libellé de la sous-ligne de période (ex. « vs. 15 jours précédents »).
  final String comparisonPeriodLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.accent,
        borderRadius: const BorderRadius.all(AppRadius.lg),
      ),
      // DefaultTextStyle propage onAccent à tous les enfants _KpiItem
      // sans avoir à le répéter dans chacun.
      child: DefaultTextStyle(
        style: TextStyle(color: colors.onAccent),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ligne 1 : Vues | Contacts | Ratio équilibrés
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _KpiItem(
                  label: viewsLabel,
                  value: viewsValue,
                ),
                const SizedBox(width: AppSpacing.sm),
                _KpiItem(
                  label: contactsLabel,
                  value: contactsValue,
                ),
                const SizedBox(width: AppSpacing.sm),
                _KpiItem(
                  label: ratioLabel,
                  value: ratioValue,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            // Ligne 2 : puces de variation + libellé de période.
            // Un badge est affiché pour vues ET contacts :
            //   - deltaRatio != null → variation signée (+/−)
            //   - deltaRatio == null + comparisonNewLabel non null → «Nouveau»
            //     (période précédente à zéro — même sémantique que
            //     DashboardComparisonChip, voir dashboard_comparison.dart)
            Row(
              children: [
                if (viewsDeltaRatio != null ||
                    (comparisonNewLabel != null)) ...[
                  _DeltaBadge(
                    deltaRatio: viewsDeltaRatio,
                    newLabel: comparisonNewLabel,
                    onAccent: colors.onAccent,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                if (contactsDeltaRatio != null ||
                    (comparisonNewLabel != null)) ...[
                  _DeltaBadge(
                    deltaRatio: contactsDeltaRatio,
                    newLabel: comparisonNewLabel,
                    onAccent: colors.onAccent,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  child: Text(
                    comparisonPeriodLabel,
                    style: AppText.caption(locale).copyWith(
                      color: colors.onAccent.withAlpha(180),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Puce de variation inline, adaptée au fond accent :
/// vert semi-transparent si positif, rouge semi-transparent si négatif,
/// « Nouveau » si [deltaRatio] est `null` (période précédente à zéro).
class _DeltaBadge extends StatelessWidget {
  const _DeltaBadge({
    required this.deltaRatio,
    required this.onAccent,
    this.newLabel,
  });

  /// Variation relative, ou `null` si la période précédente était à zéro
  /// (même sémantique que `DashboardComparisonChip.deltaRatio`).
  final double? deltaRatio;
  final String? newLabel;
  final Color onAccent;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    // deltaRatio == null → période précédente à zéro : on affiche «Nouveau».
    if (deltaRatio == null) {
      return _Chip(
        label: newLabel ?? '',
        bg: onAccent.withAlpha(40),
        fg: onAccent,
        locale: locale,
      );
    }

    final colors = context.colors;
    final ratio = deltaRatio!;
    final isPositive = ratio >= 0;
    final percent = (ratio * 100).abs().round();
    final sign = isPositive ? '+' : '\u2212'; // «−» typographique
    final label = '$sign$percent %';

    return _Chip(
      label: label,
      bg: isPositive
          ? colors.verified.withValues(alpha: 0.2)
          : colors.destructive.withValues(alpha: 0.2),
      fg: onAccent,
      locale: locale,
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.bg,
    required this.fg,
    required this.locale,
  });

  final String label;
  final Color bg;
  final Color fg;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.all(AppRadius.pill),
      ),
      child: Text(
        label,
        style: AppText.caption(locale).copyWith(color: fg),
      ),
    );
  }
}
