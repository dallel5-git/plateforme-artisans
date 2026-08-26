import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/search/data/catalog_repository.dart';

class _DefaultApiMock extends Mock implements DefaultApi {}

Response<T> _okResponse<T>(String path, T data) => Response<T>(
  requestOptions: RequestOptions(path: path),
  statusCode: 200,
  data: data,
);

void main() {
  late _DefaultApiMock api;
  late CatalogRepository repository;

  setUp(() {
    api = _DefaultApiMock();
    repository = CatalogRepository(api);
  });

  group('CatalogRepository.fetchCategories', () {
    test("renvoie l'arbre de catégories depuis /v1/categories", () async {
      final node = CategoryTreeNode(
        (b) => b
          ..id = 'cat-1'
          ..slug = 'plomberie'
          ..nameFr = 'Plomberie'
          ..nameAr = 'سباكة'
          ..descriptionFr = ''
          ..descriptionAr = ''
          ..iconKey = 'plomberie'
          ..colorHex = '#3B6FE0'
          ..sortOrder = 1,
      );
      when(() => api.v1CategoriesGet()).thenAnswer(
        (_) async => _okResponse(
          '/v1/categories',
          V1CategoriesGet200Response((b) => b..categories.add(node)),
        ),
      );

      final result = await repository.fetchCategories();

      expect(result, [node]);
    });

    test(
      "propage l'exception réseau — jamais une liste vide silencieuse",
      () async {
        // 🔒 NON-RÉGRESSION — critère d'acceptation FM-06 : les catégories
        // ne viennent jamais d'une liste codée en dur. Un échec réseau doit
        // rester visible (état d'erreur), pas être masqué par un fallback
        // local.
        when(() => api.v1CategoriesGet()).thenThrow(
          DioException(requestOptions: RequestOptions(path: '/v1/categories')),
        );

        expect(repository.fetchCategories(), throwsA(isA<DioException>()));
      },
    );
  });

  group('CatalogRepository.fetchGovernorates', () {
    test("trie par sortOrder, indépendamment de l'ordre de l'API", () async {
      Governorate gov(String id, int sortOrder) => Governorate(
        (b) => b
          ..id = id
          ..code = id
          ..nameFr = id
          ..nameAr = id
          ..slug = id
          ..latitude = 0
          ..longitude = 0
          ..sortOrder = sortOrder,
      );
      when(() => api.v1GovernoratesGet()).thenAnswer(
        (_) async => _okResponse(
          '/v1/governorates',
          V1GovernoratesGet200Response(
            (b) =>
                b.governorates.addAll([gov('sousse', 2), gov('monastir', 1)]),
          ),
        ),
      );

      final result = await repository.fetchGovernorates();

      expect(result.map((g) => g.id), ['monastir', 'sousse']);
    });
  });
}
