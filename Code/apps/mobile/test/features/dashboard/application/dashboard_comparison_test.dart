import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/features/dashboard/application/dashboard_comparison.dart';
import 'package:sanaya/features/dashboard/data/dashboard_repository.dart';

ProviderStatsSeriesPoint _point({
  required DateTime date,
  int profileViews = 0,
  int contacts = 0,
}) => ProviderStatsSeriesPoint(
  (b) => b
    ..date = date
    ..profileViews = profileViews
    ..uniqueProfileViews = profileViews
    ..contacts = contacts,
);

List<ProviderStatsSeriesPoint> _series30({
  required List<int> views,
  required List<int> contacts,
}) => List.generate(
  30,
  (i) => _point(
    date: DateTime.utc(2026, 7, 30).add(Duration(days: i)),
    profileViews: views[i],
    contacts: contacts[i],
  ),
);

void main() {
  group('deriveMonthOverMonth', () {
    test('coupe une série de 30 jours en deux fenêtres de 15 jours', () {
      // 15 premiers jours = 1 vue/jour (période précédente = 15 vues),
      // 15 derniers jours = 2 vues/jour (période courante = 30 vues).
      final series = _series30(
        views: [...List.filled(15, 1), ...List.filled(15, 2)],
        contacts: [...List.filled(15, 0), ...List.filled(15, 1)],
      );

      final comparison = deriveMonthOverMonth(series);

      expect(comparison.previousViews, 15);
      expect(comparison.currentViews, 30);
      expect(comparison.previousContacts, 0);
      expect(comparison.currentContacts, 15);
    });

    test('calcule un delta positif quand la période courante progresse', () {
      final series = _series30(
        views: [...List.filled(15, 1), ...List.filled(15, 2)],
        contacts: List.filled(30, 0),
      );

      final comparison = deriveMonthOverMonth(series);

      expect(comparison.viewsDeltaRatio, closeTo(1.0, 0.0001)); // +100 %
    });

    test('calcule un delta négatif quand la période courante recule', () {
      final series = _series30(
        views: [...List.filled(15, 4), ...List.filled(15, 1)],
        contacts: List.filled(30, 0),
      );

      final comparison = deriveMonthOverMonth(series);

      expect(comparison.viewsDeltaRatio, closeTo(-0.75, 0.0001)); // -75 %
    });

    test('tous les jours à zéro : deltas null, pas de division par zéro', () {
      final series = _series30(
        views: List.filled(30, 0),
        contacts: List.filled(30, 0),
      );

      final comparison = deriveMonthOverMonth(series);

      expect(comparison.previousViews, 0);
      expect(comparison.currentViews, 0);
      expect(comparison.viewsDeltaRatio, isNull);
      expect(comparison.contactsDeltaRatio, isNull);
    });

    test('série vide : totaux à zéro, aucune exception', () {
      final comparison = deriveMonthOverMonth(const []);

      expect(comparison.previousViews, 0);
      expect(comparison.currentViews, 0);
      expect(comparison.viewsDeltaRatio, isNull);
    });

    test(
      'série de longueur impaire : le jour du milieu va à la période courante',
      () {
        // 3 jours : mid = 3~/2 = 1 -> previous=[0..1)=1 jour, current=[1..3)=2 jours
        final series = [
          _point(date: DateTime.utc(2026, 8, 11), profileViews: 5),
          _point(date: DateTime.utc(2026, 8, 12), profileViews: 3),
          _point(date: DateTime.utc(2026, 8, 13), profileViews: 2),
        ];

        final comparison = deriveMonthOverMonth(series);

        expect(comparison.previousViews, 5);
        expect(comparison.currentViews, 5);
      },
    );
  });
}
