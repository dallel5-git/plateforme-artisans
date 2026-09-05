import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/i18n/format.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_skeleton.dart';
import 'package:sanaya/core/widgets/error_state.dart';
import 'package:sanaya/features/dashboard/application/dashboard_comparison.dart';
import 'package:sanaya/features/dashboard/application/dashboard_providers.dart';
import 'package:sanaya/features/dashboard/data/dashboard_repository.dart';
import 'package:sanaya/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:sanaya/features/dashboard/presentation/widgets/dashboard_kpi_card.dart';
import 'package:sanaya/features/dashboard/presentation/widgets/dashboard_trend_chart.dart';

/// Tableau de bord de l'Espace Pro (FM-12, issue #41) : vues, contacts,
/// ratio vue→contact et courbe 30 jours de l'artisan authentifié.
/// `dashboardStatsProvider` (FM-12a) est l'unique source des chiffres —
/// aucun calcul métier ici (P3), seule la comparaison mois-1 est dérivée
/// côté client de cette même réponse (`deriveMonthOverMonth`, FM-12b, voir
/// sa doc : pas de second appel API, pas de champ dédié côté backend).
///
/// FM-37a : DashboardHeader salue l'artisan (« Bonjour, firstName ») et
/// affiche le badge de disponibilité.
/// FM-37b : la grille 2×2 de DashboardStatCard est remplacée par
/// DashboardKpiCard (carte accent regroupant Vues/Contacts/Ratio).
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
                Text(
                  t.dashboard.chartTitle,
                  style: AppText.bodyStrong(locale).copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _ChartLegend(t: t),
                const SizedBox(height: AppSpacing.md),
                DashboardTrendChart(series: stats.series.toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartLegend extends StatelessWidget {
  const _ChartLegend({required this.t});

  final Translations t;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    Widget dot(Color color, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: AppText.small(locale).copyWith(color: colors.textSecondary),
        ),
      ],
    );

    return Row(
      children: [
        dot(colors.accent, t.dashboard.chartViewsLabel),
        const SizedBox(width: AppSpacing.md),
        dot(colors.whatsapp, t.dashboard.chartContactsLabel),
      ],
    );
  }
}

class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    // Skeleton FM-37a/b : en-tête + une carte pleine largeur (KPI) + graphe.
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
