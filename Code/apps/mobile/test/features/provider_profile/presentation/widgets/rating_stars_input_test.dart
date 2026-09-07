import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/features/provider_profile/presentation/widgets/rating_stars_input.dart';

Widget _wrap(Widget child, {Locale locale = const Locale('fr')}) {
  return ProviderScope(
    overrides: [
      localeProvider.overrideWith((ref) => locale),
    ],
    child: MaterialApp(
      locale: locale,
      supportedLocales: const [Locale('fr'), Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: buildTheme(brightness: Brightness.light, locale: locale),
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group('FM-10b — RatingStarsInput', () {
    testWidgets('affiche 5 étoiles, aucune pleine si value: 0', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(RatingStarsInput(value: 0, onChanged: (_) {})),
      );

      expect(find.byIcon(Icons.star), findsNothing);
      expect(find.byIcon(Icons.star_border), findsNWidgets(5));
    });

    testWidgets('value: 3 affiche 3 étoiles pleines et 2 vides', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(RatingStarsInput(value: 3, onChanged: (_) {})),
      );

      expect(find.byIcon(Icons.star), findsNWidgets(3));
      expect(find.byIcon(Icons.star_border), findsNWidgets(2));
    });

    testWidgets('tap sur la 3ᵉ étoile appelle onChanged(3)', (tester) async {
      int? tapped;
      await tester.pumpWidget(
        _wrap(RatingStarsInput(value: 0, onChanged: (v) => tapped = v)),
      );

      await tester.tap(find.byIcon(Icons.star_border).at(2));
      expect(tapped, 3);
    });

    testWidgets('cible tactile ≥48 px par étoile', (tester) async {
      await tester.pumpWidget(
        _wrap(RatingStarsInput(value: 0, onChanged: (_) {})),
      );

      final size = tester.getSize(find.byType(InkWell).first);
      expect(size.width, greaterThanOrEqualTo(AppLayout.touchTarget));
      expect(size.height, greaterThanOrEqualTo(AppLayout.touchTarget));
    });

    testWidgets(
      'FM-43 — chaque étoile annonce son rang et son état sélectionné au '
      'lecteur d’écran',
      (tester) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(
          _wrap(RatingStarsInput(value: 3, onChanged: (_) {})),
        );

        final firstStar = tester.getSemantics(find.byType(InkWell).at(0));
        expect(firstStar.label, '1 étoile(s)');
        expect(firstStar.flagsCollection.isButton, isTrue);
        expect(firstStar.flagsCollection.isSelected, Tristate.isTrue);

        final lastStar = tester.getSemantics(find.byType(InkWell).at(4));
        expect(lastStar.label, '5 étoile(s)');
        expect(lastStar.flagsCollection.isSelected, Tristate.isFalse);

        handle.dispose();
      },
    );
  });
}
