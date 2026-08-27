import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/provider_profile/presentation/widgets/offering_card.dart';

V1ProvidersSlugGet200ResponseOfferingsInner _offering({
  required String titleFr,
  required String titleAr,
  required String displayPrice,
  String description = '',
}) => V1ProvidersSlugGet200ResponseOfferingsInner(
  (b) => b
    ..id = 'offering-1'
    ..category = V1ProvidersSlugGet200ResponseOfferingsInnerCategory(
      (c) => c
        ..slug = 'plomberie'
        ..nameFr = 'Plomberie'
        ..nameAr = 'سباكة',
    ).toBuilder()
    ..titleFr = titleFr
    ..titleAr = titleAr
    ..description = description
    ..priceMin = 50000
    ..priceMax = 80000
    ..priceUnit = V1ProvidersSlugGet200ResponseOfferingsInnerPriceUnitEnum.FIXED
    ..isNegotiable = false
    ..displayPrice = displayPrice,
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
  testWidgets('OfferingCard affiche le titre FR et le prix formaté', (
    tester,
  ) async {
    final offering = _offering(
      titleFr: 'Réparation fuite',
      titleAr: 'إصلاح تسرب',
      displayPrice: '50 TND',
      description: 'Déplacement inclus',
    );

    await tester.pumpWidget(_wrap(OfferingCard(offering: offering)));

    expect(find.text('Réparation fuite'), findsOneWidget);
    expect(find.text('50 TND'), findsOneWidget);
    expect(find.text('Déplacement inclus'), findsOneWidget);
  });

  testWidgets('OfferingCard affiche le titre AR sous la locale ar', (
    tester,
  ) async {
    final offering = _offering(
      titleFr: 'Réparation fuite',
      titleAr: 'إصلاح تسرب',
      displayPrice: '50 TND',
    );

    await tester.pumpWidget(
      _wrap(OfferingCard(offering: offering), locale: const Locale('ar')),
    );

    expect(find.text('إصلاح تسرب'), findsOneWidget);
    expect(find.text('Réparation fuite'), findsNothing);
  });
}
