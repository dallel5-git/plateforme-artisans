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
}
