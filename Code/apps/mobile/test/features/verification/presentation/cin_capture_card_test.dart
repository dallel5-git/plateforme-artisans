import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/features/verification/domain/kyc_submission_state.dart';
import 'package:sanaya/features/verification/presentation/widgets/cin_capture_card.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: buildTheme(
      brightness: Brightness.light,
      locale: const Locale('fr'),
    ),
    locale: const Locale('fr'),
    home: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    ),
  );
}

void main() {
  group('CinCaptureCard — Rendu et interactions', () {
    testWidgets(
      "affiche le placeholder quand aucun fichier n'est sélectionné",
      (
        tester,
      ) async {
        var pickCalled = false;
        await tester.pumpWidget(
          _wrap(
            CinCaptureCard(
              title: 'Face avant (Recto)',
              subtitle: 'Photo nette de votre CIN',
              state: const KycDocumentState(),
              onPickImage: () => pickCalled = true,
              onRemove: () {},
            ),
          ),
        );

        expect(find.text('Face avant (Recto)'), findsOneWidget);
        expect(find.text('Photo nette de votre CIN'), findsOneWidget);
        expect(find.text('Prendre ou importer une photo'), findsOneWidget);

        await tester.tap(find.text('Prendre ou importer une photo'));
        expect(pickCalled, isTrue);
      },
    );

    testWidgets(
      'affiche les boutons Remplacer et Supprimer quand un fichier est présent',
      (
        tester,
      ) async {
        var removeCalled = false;
        var pickCalled = false;

        await tester.pumpWidget(
          _wrap(
            CinCaptureCard(
              title: 'Face avant (Recto)',
              subtitle: 'Photo nette de votre CIN',
              state: KycDocumentState(
                file: File('/tmp/test_front.jpg'),
                mediaId: 'media-123',
              ),
              onPickImage: () => pickCalled = true,
              onRemove: () => removeCalled = true,
            ),
          ),
        );

        expect(find.text('OK'), findsOneWidget);
        expect(find.text('Remplacer'), findsOneWidget);
        expect(find.text('Supprimer'), findsOneWidget);

        await tester.tap(find.text('Supprimer'));
        expect(removeCalled, isTrue);

        await tester.tap(find.text('Remplacer'));
        expect(pickCalled, isTrue);
      },
    );

    testWidgets("affiche le pourcentage de progression pendant l'upload", (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          CinCaptureCard(
            title: 'Face avant (Recto)',
            subtitle: 'Photo nette de votre CIN',
            state: KycDocumentState(
              file: File('/tmp/test_front.jpg'),
              isUploading: true,
              uploadProgress: 0.65,
            ),
            onPickImage: () {},
            onRemove: () {},
          ),
        ),
      );

      expect(find.text('65%'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets("affiche l'erreur et le bouton Réessayer en cas d'échec", (
      tester,
    ) async {
      var retryCalled = false;

      await tester.pumpWidget(
        _wrap(
          CinCaptureCard(
            title: 'Face avant (Recto)',
            subtitle: 'Photo nette de votre CIN',
            state: KycDocumentState(
              file: File('/tmp/test_front.jpg'),
              errorMessage: 'Fichier corrompu ou format non supporté',
            ),
            onPickImage: () {},
            onRemove: () {},
            onRetry: () => retryCalled = true,
          ),
        ),
      );

      expect(
        find.text('Fichier corrompu ou format non supporté'),
        findsOneWidget,
      );
      expect(find.text('Réessayer'), findsOneWidget);

      await tester.tap(find.text('Réessayer'));
      expect(retryCalled, isTrue);
    });
  });
}
