import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
import 'package:sanaya/features/dashboard/presentation/widgets/dashboard_stat_card.dart';
import 'package:sanaya/features/dashboard/presentation/widgets/dashboard_trend_chart.dart';

/// Tableau de bord de l'Espace Pro (FM-12, issue #41) : vues, contacts,
/// ratio vue→contact et courbe 30 jours de l'artisan authentifié.
/// `dashboardStatsProvider` (FM-12a) est l'unique source des chiffres —
/// aucun calcul métier ici (P3), seule la comparaison mois-1 est dérivée
/// côté client de cette même réponse (`deriveMonthOverMonth`, FM-12b, voir
/// sa doc : pas de second appel API, pas de champ dédié côté backend).
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final t = ref.watch(translationsProvider);
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        title: Text(
          t.dashboard.title,
          style: AppText.h3(locale).copyWith(color: colors.textPrimary),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/pro'),
        ),
      ),
      body: statsAsync.when(
        loading: () => const _DashboardSkeleton(),
        error: (error, _) => ErrorState(
          icon: '⚠️',
          title: t.dashboard.errorTitle,
          message: t.dashboard.errorMessage,
          actionLabel: t.dashboard.retry,
          onAction: () => ref.invalidate(dashboardStatsProvider),
        ),
        data: (stats) => _DashboardContent(stats: stats, t: t),
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
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DashboardStatCard(
                  label: t.dashboard.statViews,
                  value: '${totals.profileViews}',
                  comparisonRatio: comparison.viewsDeltaRatio,
                  comparisonNewLabel: t.dashboard.comparisonNew,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: DashboardStatCard(
                  label: t.dashboard.statUniqueViews,
                  value: '${totals.uniqueProfileViews}',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: DashboardStatCard(
                  label: t.dashboard.statContacts,
                  value: '${totals.contacts}',
                  comparisonRatio: comparison.contactsDeltaRatio,
                  comparisonNewLabel: t.dashboard.comparisonNew,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: DashboardStatCard(
                  label: t.dashboard.statRatio,
                  value: ratioLabel,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            t.dashboard.comparisonPreviousPeriod,
            style: AppText.caption(locale).copyWith(color: colors.textMuted),
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
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: AppSkeleton(height: 84)),
              SizedBox(width: AppSpacing.md),
              Expanded(child: AppSkeleton(height: 84)),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: AppSkeleton(height: 84)),
              SizedBox(width: AppSpacing.md),
              Expanded(child: AppSkeleton(height: 84)),
            ],
          ),
          SizedBox(height: AppSpacing.xl),
          AppSkeleton(height: 140),
        ],
      ),
    );
  }
}
