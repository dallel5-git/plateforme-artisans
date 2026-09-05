import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/i18n/format.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_bar_chart.dart';
import 'package:sanaya/core/widgets/app_skeleton.dart';
import 'package:sanaya/core/widgets/empty_state.dart';
import 'package:sanaya/core/widgets/error_state.dart';
import 'package:sanaya/features/dashboard/application/dashboard_comparison.dart';
import 'package:sanaya/features/dashboard/application/dashboard_providers.dart';
import 'package:sanaya/features/dashboard/data/dashboard_repository.dart';
import 'package:sanaya/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:sanaya/features/dashboard/presentation/widgets/dashboard_kpi_card.dart';

/// Tableau de bord de l'Espace Pro (FM-12, issue #41) : vues, contacts,
/// ratio vue→contact et histogramme 7 jours de l'artisan authentifié.
/// `dashboardStatsProvider` (FM-12a) est l'unique source des chiffres —
/// aucun calcul métier ici (P3), seule la comparaison mois-1 est dérivée
/// côté client de cette même réponse (`deriveMonthOverMonth`, FM-12b, voir
/// sa doc : pas de second appel API, pas de champ dédié côté backend).
///
/// FM-37a : DashboardHeader salue l'artisan (« Bonjour, firstName ») et
/// affiche le badge de disponibilité.
/// FM-37b : DashboardKpiCard regroupe Vues/Contacts/Ratio sur fond accent.
/// FM-37c : AppBarChart affiche l'histogramme 7 jours (avec état vide
/// EmptyState).
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final t = ref.watch(translationsProvider);
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: statsAsync.when(
          loading: () => const _DashboardSkeleton(),
          error: (error, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const DashboardHeader(),
              Expanded(
                child: ErrorState(
                  icon: '⚠️',
                  title: t.dashboard.errorTitle,
                  message: t.dashboard.errorMessage,
                  actionLabel: t.dashboard.retry,
                  onAction: () => ref.invalidate(dashboardStatsProvider),
                ),
              ),
            ],
          ),
          data: (stats) => _DashboardContent(stats: stats, t: t),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.stats, required this.t});

  final ProviderStats stats;
  final Translations t;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final colors = context.colors;
    final totals = stats.totals;
    final comparison = deriveMonthOverMonth(stats.series.toList());
    final ratioPercent = formatNumber(
      totals.viewToContactRatio * 100,
      locale,
    );
    final ratioLabel = '$ratioPercent%';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DashboardHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // FM-37b : carte KPI bleue (Vues / Contacts / Ratio) sur fond accent.
                DashboardKpiCard(
                  viewsLabel: t.dashboard.statViews,
                  viewsValue: '${totals.profileViews}',
                  contactsLabel: t.dashboard.statContacts,
                  contactsValue: '${totals.contacts}',
                  ratioLabel: t.dashboard.statRatio,
                  ratioValue: ratioLabel,
                  viewsDeltaRatio: comparison.viewsDeltaRatio,
                  contactsDeltaRatio: comparison.contactsDeltaRatio,
                  comparisonNewLabel: t.dashboard.comparisonNew,
                  comparisonPeriodLabel: t.dashboard.comparisonPreviousPeriod,
                ),
                const SizedBox(height: AppSpacing.xl),
                // FM-37c : histogramme 7 barres (derniers 7 jours de la série
                // 30 jours) + état vide si profileViews totaux == 0.
                if (totals.profileViews == 0) ...[
                  EmptyState(
                    icon: '📈',
                    title: t.dashboard.emptyTitle,
                    message: t.dashboard.emptyMessage,
                  ),
                ] else ...[
                  Text(
                    t.dashboard.chartTitle7d,
                    style: AppText.bodyStrong(locale).copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _DashboardBarChart(series: stats.series.toList()),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Extrait les 7 derniers points de la série et les convertit en
/// barres pour [AppBarChart]. L'index du jour le plus récent (aujourd'hui)
/// est toujours la dernière barre (index = 6).
class _DashboardBarChart extends StatelessWidget {
  const _DashboardBarChart({required this.series});

  final List<ProviderStatsSeriesPoint> series;

  @override
  Widget build(BuildContext context) {
    // On extrait les 7 derniers jours. Si la série est plus courte, on prend
    // ce qu'il y a (défensif — l'API garantit 30 jours pleins).
    final last7 = series.length >= 7
        ? series.sublist(series.length - 7)
        : series;

    final values = last7.map((p) => p.profileViews).toList();

    // Libellés j - N : initiales des jours de la semaine.
    // On utilise une représentation numérique simple (J-6 à J) car
    // la locale n’est pas connue dans le Painter sans TextPainter (déjà
    // utilisé pour le rendu). Étiquettes courtes pour tenir dans la barre.
    final labels = List.generate(
      last7.length,
      (i) {
        final daysAgo = last7.length - 1 - i;
        return daysAgo == 0 ? 'J' : 'J-$daysAgo';
      },
    );

    // La dernière barre = jour courant (index last7.length - 1).
    final highlightIndex = last7.isNotEmpty ? last7.length - 1 : null;

    return AppBarChart(
      values: values,
      labels: labels,
      highlightIndex: highlightIndex,
    );
  }
}

class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    // Skeleton FM-37a/b/c : en-tête + carte KPI + graphe barres.
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DashboardHeader(),
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSkeleton(height: 96),
              SizedBox(height: AppSpacing.xl),
              AppSkeleton(height: 140),
            ],
          ),
        ),
      ],
    );
  }
}
