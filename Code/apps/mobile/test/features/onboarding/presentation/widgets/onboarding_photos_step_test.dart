import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/features/onboarding/application/portfolio_repository_provider.dart';
import 'package:sanaya/features/onboarding/data/portfolio_repository.dart';
import 'package:sanaya/features/onboarding/presentation/widgets/onboarding_photos_step.dart';
import 'package:sanaya/features/onboarding/presentation/widgets/portfolio_photo_tile.dart';

class MockPortfolioRepository extends Mock implements PortfolioRepository {}

Widget _wrap(Widget child, {required PortfolioRepository repository}) {
  return ProviderScope(
    overrides: [portfolioRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: buildTheme(
        brightness: Brightness.light,
        locale: const Locale('fr'),
      ),
      locale: const Locale('fr'),
      home: Scaffold(
        body: SizedBox(height: 600, child: child),
      ),
    ),
  );
}

PresignedMediaUpload _presign(String mediaId) => V1MediaPresignPost200Response(
  (b) => b
    ..mediaId = mediaId
    ..uploadUrl = 'https://r2.example/$mediaId/original.jpg'
    ..expiresAt = DateTime.utc(2026, 9, 5, 10),
);

ProcessedMedia _processed(String mediaId) => V1MediaIdProcessPost200Response(
  (b) => b
    ..id = mediaId
    ..publicUrl = 'https://cdn.example/$mediaId/full.webp'
    ..thumbUrl = 'https://cdn.example/$mediaId/thumb.webp'
    ..cardUrl = 'https://cdn.example/$mediaId/card.webp'
    ..fullUrl = 'https://cdn.example/$mediaId/full.webp'
    ..width = 1600
    ..height = 1200,
);

PortfolioItem _portfolioItem(String id, String mediaId) =>
    V1ProvidersMePortfolioPost200Response(
      (b) => b
        ..id = id
        ..mediaId = mediaId
        ..categoryId = ''
        ..caption = ''
        ..sortOrder = 0,
    );

/// Câble le bonheur complet presign → upload → process → attach pour
/// [mediaId]/[itemId] fournis.
void _stubHappyPath(
  MockPortfolioRepository repo, {
  required String mediaId,
  required String itemId,
}) {
  when(
    () => repo.presignUpload(
      filename: any(named: 'filename'),
      mimeType: any(named: 'mimeType'),
      sizeBytes: any(named: 'sizeBytes'),
    ),
  ).thenAnswer((_) async => _presign(mediaId));
  when(
    () => repo.uploadToPresignedUrl(
      uploadUrl: any(named: 'uploadUrl'),
      bytes: any(named: 'bytes'),
      mimeType: any(named: 'mimeType'),
      onSendProgress: any(named: 'onSendProgress'),
    ),
  ).thenAnswer((_) async {});
  when(
    () => repo.processMedia(mediaId),
  ).thenAnswer((_) async => _processed(mediaId));
  when(
    () => repo.attachToPortfolio(
      mediaId: mediaId,
      categoryId: any(named: 'categoryId'),
      caption: any(named: 'caption'),
    ),
  ).thenAnswer((_) async => _portfolioItem(itemId, mediaId));
}

void main() {
  setUpAll(() {
    registerFallbackValue(Uint8List(0));
  });

  final t = AppLocale.fr.buildSync();

  Future<XFile?> onePick() async => XFile('/tmp/photo.jpg');
  Future<Uint8List> fakeCompress(File file) async =>
      Uint8List.fromList([1, 2, 3]);

  testWidgets('Suivant est actif sans aucune photo (étape optionnelle)', (
    tester,
  ) async {
    final repo = MockPortfolioRepository();
    await tester.pumpWidget(
      _wrap(
        OnboardingPhotosStep(
          isSaving: false,
          errorMessage: null,
          onSubmit: () {},
          pickImage: onePick,
          compressImage: fakeCompress,
        ),
        repository: repo,
      ),
    );

    final button = tester.widget<AppButton>(find.byType(AppButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets(
    'ajouter une photo suit presign → upload → process → attach '
    'et affiche la vignette terminée',
    (tester) async {
      final repo = MockPortfolioRepository();
      _stubHappyPath(repo, mediaId: 'media-1', itemId: 'item-1');

      await tester.pumpWidget(
        _wrap(
          OnboardingPhotosStep(
            isSaving: false,
            errorMessage: null,
            onSubmit: () {},
            pickImage: onePick,
            compressImage: fakeCompress,
          ),
          repository: repo,
        ),
      );

      await tester.tap(find.byIcon(Icons.add_a_photo_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(PortfolioPhotoTile), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      verify(
        () => repo.presignUpload(
          filename: any(named: 'filename'),
          mimeType: 'image/jpeg',
          sizeBytes: any(named: 'sizeBytes'),
        ),
      ).called(1);
      verify(
        () => repo.uploadToPresignedUrl(
          uploadUrl: 'https://r2.example/media-1/original.jpg',
          bytes: any(named: 'bytes'),
          mimeType: 'image/jpeg',
          onSendProgress: any(named: 'onSendProgress'),
        ),
      ).called(1);
      verify(() => repo.processMedia('media-1')).called(1);
      verify(
        () => repo.attachToPortfolio(
          mediaId: 'media-1',
          categoryId: any(named: 'categoryId'),
          caption: any(named: 'caption'),
        ),
      ).called(1);
    },
  );

  testWidgets(
    'un échec de presign (SanayaApiException) affiche une erreur avec '
    'Réessayer, sans bloquer le reste de l’étape',
    (tester) async {
      final repo = MockPortfolioRepository();
      final apiException = ValidationException(
        message: 'Fichier trop volumineux',
      );
      when(
        () => repo.presignUpload(
          filename: any(named: 'filename'),
          mimeType: any(named: 'mimeType'),
          sizeBytes: any(named: 'sizeBytes'),
        ),
      ).thenThrow(apiException);

      await tester.pumpWidget(
        _wrap(
          OnboardingPhotosStep(
            isSaving: false,
            errorMessage: null,
            onSubmit: () {},
            pickImage: onePick,
            compressImage: fakeCompress,
          ),
          repository: repo,
        ),
      );

      await tester.tap(find.byIcon(Icons.add_a_photo_outlined));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.byTooltip(t.onboarding.retry), findsOneWidget);

      final button = tester.widget<AppButton>(find.byType(AppButton));
      expect(
        button.onPressed,
        isNotNull,
        reason: 'une photo en erreur ne bloque pas Suivant',
      );
    },
  );

  testWidgets('Réessayer relance le pipeline depuis la compression', (
    tester,
  ) async {
    final repo = MockPortfolioRepository();
    var attempt = 0;
    when(
      () => repo.presignUpload(
        filename: any(named: 'filename'),
        mimeType: any(named: 'mimeType'),
        sizeBytes: any(named: 'sizeBytes'),
      ),
    ).thenAnswer((_) async {
      attempt += 1;
      if (attempt == 1) throw ValidationException(message: 'Échec réseau');
      return _presign('media-1');
    });
    when(
      () => repo.uploadToPresignedUrl(
        uploadUrl: any(named: 'uploadUrl'),
        bytes: any(named: 'bytes'),
        mimeType: any(named: 'mimeType'),
        onSendProgress: any(named: 'onSendProgress'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => repo.processMedia('media-1'),
    ).thenAnswer((_) async => _processed('media-1'));
    when(
      () => repo.attachToPortfolio(
        mediaId: 'media-1',
        categoryId: any(named: 'categoryId'),
        caption: any(named: 'caption'),
      ),
    ).thenAnswer((_) async => _portfolioItem('item-1', 'media-1'));

    await tester.pumpWidget(
      _wrap(
        OnboardingPhotosStep(
          isSaving: false,
          errorMessage: null,
          onSubmit: () {},
          pickImage: onePick,
          compressImage: fakeCompress,
        ),
        repository: repo,
      ),
    );

    await tester.tap(find.byIcon(Icons.add_a_photo_outlined));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.error_outline), findsOneWidget);

    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.error_outline), findsNothing);
    expect(attempt, 2);
  });

  testWidgets(
    'supprimer une photo terminée appelle deletePortfolioItem',
    (tester) async {
      final repo = MockPortfolioRepository();
      _stubHappyPath(repo, mediaId: 'media-1', itemId: 'item-1');
      when(
        () => repo.deletePortfolioItem('item-1'),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(
        _wrap(
          OnboardingPhotosStep(
            isSaving: false,
            errorMessage: null,
            onSubmit: () {},
            pickImage: onePick,
            compressImage: fakeCompress,
          ),
          repository: repo,
        ),
      );

      await tester.tap(find.byIcon(Icons.add_a_photo_outlined));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.byType(PortfolioPhotoTile), findsNothing);
      verify(() => repo.deletePortfolioItem('item-1')).called(1);
    },
  );

  testWidgets(
    'le plafond FREE (5 photos) masque le bouton d’ajout',
    (tester) async {
      final repo = MockPortfolioRepository();
      var counter = 0;
      when(
        () => repo.presignUpload(
          filename: any(named: 'filename'),
          mimeType: any(named: 'mimeType'),
          sizeBytes: any(named: 'sizeBytes'),
        ),
      ).thenAnswer((_) async {
        counter += 1;
        return _presign('media-$counter');
      });
      when(
        () => repo.uploadToPresignedUrl(
          uploadUrl: any(named: 'uploadUrl'),
          bytes: any(named: 'bytes'),
          mimeType: any(named: 'mimeType'),
          onSendProgress: any(named: 'onSendProgress'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => repo.processMedia(any()),
      ).thenAnswer((invocation) async {
        final mediaId = invocation.positionalArguments.single as String;
        return _processed(mediaId);
      });
      when(
        () => repo.attachToPortfolio(
          mediaId: any(named: 'mediaId'),
          categoryId: any(named: 'categoryId'),
          caption: any(named: 'caption'),
        ),
      ).thenAnswer((invocation) async {
        final mediaId = invocation.namedArguments[#mediaId] as String;
        return _portfolioItem('item-$mediaId', mediaId);
      });

      await tester.pumpWidget(
        _wrap(
          OnboardingPhotosStep(
            isSaving: false,
            errorMessage: null,
            onSubmit: () {},
            pickImage: onePick,
            compressImage: fakeCompress,
          ),
          repository: repo,
        ),
      );

      for (var i = 0; i < 5; i++) {
        await tester.tap(find.byIcon(Icons.add_a_photo_outlined));
        await tester.pumpAndSettle();
      }

      expect(find.byIcon(Icons.add_a_photo_outlined), findsNothing);
      expect(find.text(t.onboarding.photosCapReached), findsOneWidget);
    },
  );
}
