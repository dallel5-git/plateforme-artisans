import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/pro_profile/application/pro_profile_providers.dart';
import 'package:sanaya/features/pro_profile/data/offerings_repository.dart';
import 'package:sanaya/features/pro_profile/presentation/widgets/offering_edit_bottom_sheet.dart';

import '../../../../core/widgets/widget_test_helpers.dart';

class MockOfferingsRepository extends Mock implements OfferingsRepository {}

class MockProviderMe extends Mock
    implements V1ProvidersMePost200ResponseProvider {}

class _FakePostRequest extends Fake
    implements V1ProvidersMeOfferingsPostRequest {}

class _FakePatchRequest extends Fake
    implements V1ProvidersMeOfferingsIdPatchRequest {}

V1ProvidersMePost200ResponseProviderCategoriesInner _category({
  String id = 'cat-1',
  bool isPrimary = true,
}) {
  return V1ProvidersMePost200ResponseProviderCategoriesInner(
    (b) => b
      ..categoryId = id
      ..isPrimary = isPrimary
      ..yearsExperience = 5,
  );
}

V1ProvidersMeOfferingsGet200ResponseInner _offering({
  String id = 'offering-1',
  String titleFr = 'Réparation fuite',
  String titleAr = 'إصلاح تسرب',
  num price = 60,
}) {
  return V1ProvidersMeOfferingsGet200ResponseInner(
    (b) => b
      ..id = id
      ..titleFr = titleFr
      ..titleAr = titleAr
      ..category.slug = 'plomberie'
      ..category.nameFr = 'Plomberie'
      ..category.nameAr = 'سباكة'
      ..description = 'Intervention rapide'
      ..priceMin = price
      ..priceMax = price
      ..priceUnit = V1ProvidersMeOfferingsGet200ResponseInnerPriceUnitEnum.HOUR
      ..isNegotiable = true
      ..displayPrice = '60 DT / heure',
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakePostRequest());
    registerFallbackValue(_FakePatchRequest());
  });

  late MockOfferingsRepository mockRepo;
  late MockProviderMe mockProfile;

  setUp(() {
    mockRepo = MockOfferingsRepository();
    mockProfile = MockProviderMe();

    when(() => mockProfile.categories).thenReturn(
      BuiltList<V1ProvidersMePost200ResponseProviderCategoriesInner>([
        _category(),
      ]),
    );
  });

  Widget buildSheet({MyOffering? initialOffering}) {
    return ProviderScope(
      overrides: [
        offeringsRepositoryProvider.overrideWithValue(mockRepo),
      ],
      child: themedApp(
        Scaffold(
          body: OfferingEditBottomSheet(
            profile: mockProfile,
            initialOffering: initialOffering,
          ),
        ),
      ),
    );
  }

  void setLargeViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(500, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  group('OfferingEditBottomSheet', () {
    testWidgets('affiche les champs vides et les unités en mode ajout', (
      tester,
    ) async {
      setLargeViewport(tester);
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.text('Ajouter une prestation'), findsOneWidget);
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.text('Enregistrer'), findsOneWidget);
    });

    testWidgets('pré-remplit les champs en mode édition', (
      tester,
    ) async {
      setLargeViewport(tester);
      final initial = _offering();
      await tester.pumpWidget(buildSheet(initialOffering: initial));
      await tester.pumpAndSettle();

      expect(find.text('Modifier'), findsOneWidget);
      expect(find.text('Réparation fuite'), findsOneWidget);
      expect(find.text('إصلاح تسرب'), findsOneWidget);
      expect(find.text('Intervention rapide'), findsOneWidget);
      expect(find.text('60'), findsNWidgets(2)); // min and max
    });

    testWidgets('valide les champs requis au clic Enregistrer', (
      tester,
    ) async {
      setLargeViewport(tester);
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();

      // Form validation error should be visible
      expect(find.text('Ce champ est obligatoire'), findsOneWidget);
      verifyNever(() => mockRepo.createOffering(any()));
    });

    testWidgets('envoie createOffering lors de la saisie valide', (
      tester,
    ) async {
      setLargeViewport(tester);
      when(() => mockRepo.createOffering(any())).thenAnswer(
        (_) async => _offering(),
      );

      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      // Fill French title
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Nouvelle prestation');
      await tester.enterText(textFields.at(1), 'خدمة جديدة');
      await tester.enterText(textFields.at(3), '75'); // price min

      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();

      verify(() => mockRepo.createOffering(any())).called(1);
    });
  });
}
