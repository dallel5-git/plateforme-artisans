import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/features/contact/application/contact_providers.dart';
import 'package:sanaya/features/contact/domain/contact_channel.dart';
import 'package:sanaya/features/contact/domain/contact_service.dart';
import 'package:sanaya/features/contact/presentation/contact_buttons.dart';

class _ServiceMock extends Mock implements ContactService {}

Widget _wrap(
  ContactService service,
  Widget child, {
  Locale locale = const Locale('fr'),
}) {
  return ProviderScope(
    overrides: [contactServiceProvider.overrideWithValue(service)],
    child: MaterialApp(
      theme: buildTheme(brightness: Brightness.light, locale: locale),
      locale: locale,
      supportedLocales: const [Locale('fr'), Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  late _ServiceMock service;

  setUpAll(() {
    registerFallbackValue(ContactChannel.phone);
  });

  setUp(() {
    service = _ServiceMock();
    when(
      () => service.contact(
        providerId: any(named: 'providerId'),
        channel: any(named: 'channel'),
        categoryId: any(named: 'categoryId'),
        sourceScreen: any(named: 'sourceScreen'),
        locale: any(named: 'locale'),
        fallbackPhone: any(named: 'fallbackPhone'),
      ),
    ).thenAnswer((_) async {});
  });

  testWidgets('affiche les boutons Appeler et WhatsApp', (tester) async {
    await tester.pumpWidget(
      _wrap(service, const ContactButtons(providerId: 'p1')),
    );

    expect(find.text('Appeler'), findsOneWidget);
    expect(find.text('WhatsApp'), findsOneWidget);
  });

  testWidgets(
    '🔒 tap sur Appeler poste le contact avec le canal phone (P9)',
    (tester) async {
      // 🔒 NON-RÉGRESSION — la vraie trace (POST avant lien natif) est déjà
      // couverte par ContactService (FM-09b) ; ce test vérifie seulement
      // que l'écran déclenche bien l'appel, avec les bons identifiants.
      await tester.pumpWidget(
        _wrap(
          service,
          const ContactButtons(
            providerId: 'p1',
            categoryId: 'cat-1',
            sourceScreen: 'profile',
            fallbackPhone: '+21622123456',
          ),
        ),
      );

      await tester.tap(find.text('Appeler'));
      await tester.pump();

      verify(
        () => service.contact(
          providerId: 'p1',
          channel: ContactChannel.phone,
          categoryId: 'cat-1',
          sourceScreen: 'profile',
          fallbackPhone: '+21622123456',
        ),
      ).called(1);
    },
  );

  testWidgets('tap sur WhatsApp poste le contact avec le canal whatsapp', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(service, const ContactButtons(providerId: 'p1')),
    );

    await tester.tap(find.text('WhatsApp'));
    await tester.pump();

    verify(
      () => service.contact(providerId: 'p1', channel: ContactChannel.whatsapp),
    ).called(1);
  });

  testWidgets(
    'FM-30 — en arabe (RTL), Appeler (primary) s affiche à droite et '
    'WhatsApp (outline) à gauche — miroir automatique du Row, sans logique '
    'par locale',
    (tester) async {
      await tester.pumpWidget(
        _wrap(
          service,
          const ContactButtons(providerId: 'p1'),
          locale: const Locale('ar'),
        ),
      );
      await tester.pump();

      // `translationsProvider` (app/providers.dart) pilote les libellés
      // affichés et reste par défaut sur le FR en test (pas de override
      // dans `_wrap`) — seule `Directionality`, pilotée par la `Locale` de
      // `MaterialApp`, change ici ; c'est elle qu'on vérifie.
      final callCenter = tester.getCenter(find.text('Appeler'));
      final whatsappCenter = tester.getCenter(find.text('WhatsApp'));

      expect(callCenter.dx, greaterThan(whatsappCenter.dx));
    },
  );
}
