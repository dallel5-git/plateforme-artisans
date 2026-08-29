import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/features/dashboard/data/dashboard_repository.dart';

final Provider<DashboardRepository> dashboardRepositoryProvider =
    Provider<DashboardRepository>(
      (ref) => DashboardRepository(ref.watch(defaultApiProvider)),
    );

/// Tableau de bord de l'artisan authentifié — état serveur géré par
/// FutureProvider : loading/error/data gratuits, aucun setState (règle
/// mobile CLAUDE.md §5). Pas de `family` (« me » n'a pas de paramètre).
/// autoDispose libère la mémoire dès que l'écran quitte la navigation ;
/// `ref.invalidate(dashboardStatsProvider)` déclenche un rechargement complet
/// (bouton « Réessayer », même patron que `providerProfileProvider`).
final AutoDisposeFutureProvider<ProviderStats> dashboardStatsProvider =
    FutureProvider.autoDispose<ProviderStats>(
      (ref) => ref.watch(dashboardRepositoryProvider).fetchStats(),
    );
