import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/pro_profile/data/offerings_repository.dart';

class MockDefaultApi extends Mock implements DefaultApi {}

class _FakePostRequest extends Fake
    implements V1ProvidersMeOfferingsPostRequest {}

class _FakePatchRequest extends Fake
    implements V1ProvidersMeOfferingsIdPatchRequest {}

RequestOptions _opts([String path = '/']) => RequestOptions(path: path);

V1ProvidersMeOfferingsGet200ResponseInner _sampleOffering({
  String id = 'offering-1',
  String titleFr = 'Plomberie générale',
  String titleAr = 'سباكة عامة',
  num price = 50,
}) {
  return V1ProvidersMeOfferingsGet200ResponseInner(
    (b) => b
      ..id = id
      ..titleFr = titleFr
      ..titleAr = titleAr
      ..category.slug = 'plomberie'
      ..category.nameFr = 'Plomberie'
      ..category.nameAr = 'سباكة'
      ..description = 'Description test'
      ..priceMin = price
      ..priceMax = price
      ..priceUnit = V1ProvidersMeOfferingsGet200ResponseInnerPriceUnitEnum.HOUR
      ..isNegotiable = true
      ..displayPrice = '50 DT / heure',
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakePostRequest());
    registerFallbackValue(_FakePatchRequest());
  });

  late MockDefaultApi mockApi;
  late OfferingsRepository repository;

  setUp(() {
    mockApi = MockDefaultApi();
    repository = OfferingsRepository(mockApi);
  });

  group('fetchMyOfferings', () {
    test("renvoie la liste des offres retournées par l'API", () async {
      final offering = _sampleOffering();
      final builtList = BuiltList<V1ProvidersMeOfferingsGet200ResponseInner>([
        offering,
      ]);

      when(
        () => mockApi.v1ProvidersMeOfferingsGet(),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: _opts('/v1/providers/me/offerings'),
          statusCode: 200,
          data: builtList,
        ),
      );

      final result = await repository.fetchMyOfferings();

      expect(result.length, 1);
      expect(result.first.id, 'offering-1');
      expect(result.first.titleFr, 'Plomberie générale');
      verify(() => mockApi.v1ProvidersMeOfferingsGet()).called(1);
    });

    test(
      "relance l'exception SanayaApiException en cas d'erreur Dio",
      () async {
        final apiException = UnauthorizedException(message: 'Non authentifié');
        when(
          () => mockApi.v1ProvidersMeOfferingsGet(),
        ).thenThrow(
          DioException(
            requestOptions: _opts('/v1/providers/me/offerings'),
            error: apiException,
          ),
        );

        await expectLater(
          repository.fetchMyOfferings(),
          throwsA(same(apiException)),
        );
      },
    );
  });

  group('createOffering', () {
    test("envoie la requête POST et retourne l'offre créée", () async {
      final offering = _sampleOffering();
      final req = V1ProvidersMeOfferingsPostRequest(
        (b) => b
          ..categoryId = 'cat-1'
          ..titleFr = 'Installation chauffe-eau'
          ..titleAr = 'تركيب سخan'
          ..priceUnit = V1ProvidersMeOfferingsPostRequestPriceUnitEnum.FIXED
          ..priceMin = 150,
      );

      when(
        () => mockApi.v1ProvidersMeOfferingsPost(
          v1ProvidersMeOfferingsPostRequest: any(
            named: 'v1ProvidersMeOfferingsPostRequest',
          ),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: _opts('/v1/providers/me/offerings'),
          statusCode: 201,
          data: offering,
        ),
      );

      final result = await repository.createOffering(req);

      expect(result.id, 'offering-1');
      final captured = verify(
        () => mockApi.v1ProvidersMeOfferingsPost(
          v1ProvidersMeOfferingsPostRequest: captureAny(
            named: 'v1ProvidersMeOfferingsPostRequest',
          ),
        ),
      ).captured;
      final sent = captured.single as V1ProvidersMeOfferingsPostRequest;
      expect(sent.titleFr, 'Installation chauffe-eau');
    });

    test("propage l'erreur de validation", () async {
      final apiException = ValidationException(
        message: 'Titre requis',
        details: {'field': 'titleFr'},
      );
      when(
        () => mockApi.v1ProvidersMeOfferingsPost(
          v1ProvidersMeOfferingsPostRequest: any(
            named: 'v1ProvidersMeOfferingsPostRequest',
          ),
        ),
      ).thenThrow(
        DioException(
          requestOptions: _opts('/v1/providers/me/offerings'),
          error: apiException,
        ),
      );

      final req = V1ProvidersMeOfferingsPostRequest(
        (b) => b
          ..categoryId = 'cat-1'
          ..titleFr = ''
          ..titleAr = ''
          ..priceUnit = V1ProvidersMeOfferingsPostRequestPriceUnitEnum.ON_QUOTE,
      );
      await expectLater(
        repository.createOffering(req),
        throwsA(same(apiException)),
      );
    });
  });

  group('updateOffering', () {
    test(
      "envoie la requête PATCH avec l'id et retourne l'offre mise à jour",
      () async {
        final offering = _sampleOffering(titleFr: 'Titre modifié');
        final req = V1ProvidersMeOfferingsIdPatchRequest(
          (b) => b..titleFr = 'Titre modifié',
        );

        when(
          () => mockApi.v1ProvidersMeOfferingsIdPatch(
            id: 'offering-1',
            v1ProvidersMeOfferingsIdPatchRequest: any(
              named: 'v1ProvidersMeOfferingsIdPatchRequest',
            ),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: _opts('/v1/providers/me/offerings/offering-1'),
            statusCode: 200,
            data: offering,
          ),
        );

        final result = await repository.updateOffering('offering-1', req);

        expect(result.titleFr, 'Titre modifié');
        verify(
          () => mockApi.v1ProvidersMeOfferingsIdPatch(
            id: 'offering-1',
            v1ProvidersMeOfferingsIdPatchRequest: any(
              named: 'v1ProvidersMeOfferingsIdPatchRequest',
            ),
          ),
        ).called(1);
      },
    );
  });

  group('deleteOffering', () {
    test("appelle la route DELETE avec l'id spécifié", () async {
      when(
        () => mockApi.v1ProvidersMeOfferingsIdDelete(id: 'offering-1'),
      ).thenAnswer(
        (_) async => Response<void>(
          requestOptions: _opts('/v1/providers/me/offerings/offering-1'),
          statusCode: 204,
        ),
      );

      await repository.deleteOffering('offering-1');

      verify(
        () => mockApi.v1ProvidersMeOfferingsIdDelete(id: 'offering-1'),
      ).called(1);
    });

    test("propage NotFoundException si l'offre n'existe pas", () async {
      final apiException = NotFoundException(message: 'Offre non trouvée');
      when(
        () => mockApi.v1ProvidersMeOfferingsIdDelete(id: 'offering-unknown'),
      ).thenThrow(
        DioException(
          requestOptions: _opts('/v1/providers/me/offerings/offering-unknown'),
          error: apiException,
        ),
      );

      await expectLater(
        repository.deleteOffering('offering-unknown'),
        throwsA(same(apiException)),
      );
    });
  });
}
