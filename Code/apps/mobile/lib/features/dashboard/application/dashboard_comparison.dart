import 'package:sanaya/features/dashboard/data/dashboard_repository.dart';

/// Comparaison mois-1 dérivée de la même série de 30 jours que
/// `GET /v1/providers/me/stats` (aucun champ dédié côté backend — le
/// critère d'acceptation FM-12 exige des chiffres qui correspondent
/// exactement à cette seule réponse, donc pas de second appel API).
///
/// La série est chronologique croissante (le plus ancien en premier — voir
/// `packages/core/src/analytics/provider-stats.ts`) : la seconde moitié est
/// donc la période courante, la première moitié la période précédente.
class DashboardComparison {
  const DashboardComparison({
    required this.currentViews,
    required this.previousViews,
    required this.currentContacts,
    required this.previousContacts,
  });

  final int currentViews;
  final int previousViews;
  final int currentContacts;
  final int previousContacts;

  /// Variation relative des vues, `null` si aucune base de comparaison
  /// (période précédente à zéro) pour éviter une division par zéro.
  double? get viewsDeltaRatio => previousViews == 0
      ? null
      : (currentViews - previousViews) / previousViews;

  /// Variation relative des contacts, mêmes règles que [viewsDeltaRatio].
  double? get contactsDeltaRatio => previousContacts == 0
      ? null
      : (currentContacts - previousContacts) / previousContacts;
}

/// Coupe la série en deux fenêtres égales et somme vues/contacts de chacune.
/// Défensif sur une série vide ou de longueur impaire, même si l'API
/// garantit 30 jours pleins (jours à zéro inclus).
DashboardComparison deriveMonthOverMonth(
  List<ProviderStatsSeriesPoint> series,
) {
  final mid = series.length ~/ 2;
  final previous = series.sublist(0, mid);
  final current = series.sublist(mid);

  int sumViews(List<ProviderStatsSeriesPoint> points) =>
      points.fold(0, (sum, point) => sum + point.profileViews);
  int sumContacts(List<ProviderStatsSeriesPoint> points) =>
      points.fold(0, (sum, point) => sum + point.contacts);

  return DashboardComparison(
    currentViews: sumViews(current),
    previousViews: sumViews(previous),
    currentContacts: sumContacts(current),
    previousContacts: sumContacts(previous),
  );
}
