import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/provider_profile/presentation/widgets/availability_chip.dart';

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
  testWidgets('AvailabilityChip affiche Disponible pour AVAILABLE (FR)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const AvailabilityChip(
          status: V1ProvidersSlugGet200ResponseAvailabilityStatusEnum.AVAILABLE,
        ),
      ),
    );

    expect(find.text('Disponible'), findsOneWidget);
  });

  testWidgets('AvailabilityChip affiche Occupé pour BUSY (FR)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const AvailabilityChip(
          status: V1ProvidersSlugGet200ResponseAvailabilityStatusEnum.BUSY,
        ),
      ),
    );

    expect(find.text('Occupé'), findsOneWidget);
  });

  testWidgets('AvailabilityChip affiche En congé pour ON_HOLIDAY (FR)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const AvailabilityChip(
          status:
              V1ProvidersSlugGet200ResponseAvailabilityStatusEnum.ON_HOLIDAY,
        ),
      ),
    );

    expect(find.text('En congé'), findsOneWidget);
  });

  testWidgets('AvailabilityChip traduit en arabe sous la locale ar', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const AvailabilityChip(
          status: V1ProvidersSlugGet200ResponseAvailabilityStatusEnum.AVAILABLE,
        ),
        locale: const Locale('ar'),
      ),
    );

    expect(find.text('متوفر'), findsOneWidget);
  });
}
