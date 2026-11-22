import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/features/search/data/search_filters.dart';

void main() {
  test(
    "cacheKey est stable, indépendamment de l'ordre des champs fournis",
    () {
      const a = SearchFilters(
        governorateId: 'sousse',
        minRating: 4,
        isVerified: true,
      );
      const b = SearchFilters(
        isVerified: true,
        governorateId: 'sousse',
        minRating: 4,
      );

      expect(a.cacheKey, b.cacheKey);
    },
  );

  test('un champ optionnel absent est omis de la clé, pas littéral "null"', () {
    const filters = SearchFilters(governorateId: 'sousse');

    expect(filters.cacheKey, 'governorate=sousse');
  });

  test('deux jeux de filtres différents ne collisionnent jamais', () {
    const a = SearchFilters(governorateId: 'sousse');
    const b = SearchFilters(governorateId: 'monastir');

    expect(a.cacheKey, isNot(b.cacheKey));
  });

  test(
    'deux instances construites au runtime avec les mêmes filtres sont '
    'égales (FM-28c) — clé de famille Riverpod pour SearchResultsNotifier',
    () {
      // Pas de `const` ici : simule des filtres reconstruits depuis une
      // sélection utilisateur, jamais canonicalisés par le compilateur.
      final a = SearchFilters(
        governorateId: 'sousse'.toUpperCase().toLowerCase(),
      );
      final b = SearchFilters(
        governorateId: 'sousse'.toUpperCase().toLowerCase(),
      );

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    },
  );

  test('deux jeux de filtres différents ne sont jamais égaux', () {
    const a = SearchFilters(governorateId: 'sousse');
    const b = SearchFilters(governorateId: 'monastir');

    expect(a, isNot(b));
  });

  test('query est normalisé et inclus dans cacheKey et copyWith', () {
    const a = SearchFilters(governorateId: 'sousse', query: ' Plomberie ');
    expect(a.cacheKey, 'governorate=sousse&query=plomberie');

    final b = a.copyWith(query: 'Electricien');
    expect(b.query, 'Electricien');
    expect(b.cacheKey, 'governorate=sousse&query=electricien');

    final c = b.copyWith(clearQuery: true);
    expect(c.query, isNull);
    expect(c.cacheKey, 'governorate=sousse');
  });
}
