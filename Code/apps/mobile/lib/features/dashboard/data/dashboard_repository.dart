import 'package:sanaya/core/api/generated/api.dart';

// Alias de lisibilité — mêmes types que ceux générés par openapi-generator,
// pas de redéclaration d'un type de domaine (P4 CLAUDE.md).
typedef ProviderStats = V1ProvidersMeStatsGet200Response;
typedef ProviderStatsTotals = V1ProvidersMeStatsGet200ResponseTotals;
typedef ProviderStatsSeriesPoint = V1ProvidersMeStatsGet200ResponseSeriesInner;

/// Accès BE-24 : tableau de bord statistiques de l'artisan authentifié.
/// Aucune règle métier ici (P3) — simple passage par le client généré.
/// Patron identique à ProviderProfileRepository (FM-08a).
class DashboardRepository {
  DashboardRepository(this._api);

  final DefaultApi _api;

  /// Totaux + série journalière des 30 derniers jours (vues, vues
  /// dédupliquées, contacts, ratio vue→contact), jours à zéro inclus.
  /// Lance une DioException en cas d'erreur réseau ou d'authentification.
  Future<ProviderStats> fetchStats() async {
    final response = await _api.v1ProvidersMeStatsGet();
    return response.data!;
  }
}
