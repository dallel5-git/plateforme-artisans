import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/provider_profile/presentation/widgets/review_tile.dart';

V1ProvidersSlugReviewsGet200ResponseItemsInner _review({
  required String authorDisplayName,
  required int rating,
  required DateTime createdAt,
  bool isVerifiedContact = false,
  String comment = '',
}) => V1ProvidersSlugReviewsGet200ResponseItemsInner(
  (b) => b
    ..id = 'rev-1'
    ..authorDisplayName = authorDisplayName
    ..rating = rating
    ..createdAt = createdAt
    ..isVerifiedContact = isVerifiedContact
    ..comment = comment,
);

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
      home: Directionality(
        textDirection: locale.languageCode == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Scaffold(body: child),
      ),
    ),
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr');
    await initializeDateFormatting('ar');
  });

  testWidgets('ReviewTile affiche auteur, note, commentaire et date', (
    tester,
  ) async {
    final review = _review(
      authorDisplayName: 'Amine B.',
      rating: 5,
      createdAt: DateTime.utc(2026, 8, 20),
      comment: 'Travail impeccable et rapide.',
    );

    await tester.pumpWidget(_wrap(ReviewTile(review: review)));

    expect(find.text('Amine B.'), findsOneWidget);
    expect(find.text('Travail impeccable et rapide.'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsNWidgets(5));
    expect(find.text('Contact vérifié'), findsNothing);
  });

  testWidgets(
    'ReviewTile affiche le badge Contact vérifié si isVerifiedContact',
    (tester) async {
      final review = _review(
        authorDisplayName: 'Sonia M.',
        rating: 4,
        createdAt: DateTime.utc(2026, 8, 21),
        isVerifiedContact: true,
      );

      await tester.pumpWidget(_wrap(ReviewTile(review: review)));

      expect(find.text('Contact vérifié'), findsOneWidget);
    },
  );
}
