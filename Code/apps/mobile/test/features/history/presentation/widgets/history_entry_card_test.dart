import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/history/data/contact_history_repository.dart';
import 'package:sanaya/features/history/presentation/widgets/history_entry_card.dart';

ContactHistoryItem _item({
  String slug = 'sami-plombier',
  bool hasReview = false,
  V1ContactEventsGet200ResponseItemsInnerChannelEnum channel =
      V1ContactEventsGet200ResponseItemsInnerChannelEnum.PHONE,
}) => ContactHistoryItem(
  (b) => b
    ..id = 'evt-1'
    ..providerId = 'prov-1'
    ..slug = slug
    ..businessName = 'Sami Plomberie'
    ..categoryName = 'Plombier'
    ..channel = channel
    ..contactedAt = DateTime.utc(2026, 9)
    ..hasReview = hasReview,
);

/// `GoRouter` réel (pas juste `MaterialApp.home`) pour vérifier la
/// navigation déclenchée par le tap sur la carte / le CTA d'avis — même
/// patron que `provider_profile_screen_test.dart#_wrapWithRouter`.
({Widget widget, GoRouter router}) _wrapWithRouter(ContactHistoryItem item) {
  final router = GoRouter(
    initialLocation: '/history',
    routes: [
      GoRoute(
        path: '/history',
        builder: (_, _) => Scaffold(body: HistoryEntryCard(item: item)),
      ),
      GoRoute(
        path: '/providers/:slug',
        name: 'provider-profile',
        builder: (_, _) => const Scaffold(body: Text('provider-screen')),
        routes: [
          GoRoute(
            path: 'review',
            name: 'provider-review',
            builder: (_, _) => const Scaffold(body: Text('review-screen')),
          ),
        ],
      ),
    ],
  );

  final widget = ProviderScope(
    child: MaterialApp.router(
      routerConfig: router,
      locale: const Locale('fr'),
      supportedLocales: const [Locale('fr'), Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: buildTheme(
        brightness: Brightness.light,
        locale: const Locale('fr'),
      ),
    ),
  );

  return (widget: widget, router: router);
}

void main() {
  group('HistoryEntryCard', () {
    testWidgets('affiche le nom, la catégorie, le canal et le CTA avis', (
      tester,
    ) async {
      final env = _wrapWithRouter(_item());
      await tester.pumpWidget(env.widget);
      await tester.pumpAndSettle();

      expect(find.text('Sami Plomberie'), findsOneWidget);
      expect(find.text('Plombier'), findsOneWidget);
      expect(find.text('Appel'), findsOneWidget);
      expect(find.text('Laisser un avis'), findsOneWidget);
    });

    testWidgets('masque le CTA avis si hasReview est true', (tester) async {
      final env = _wrapWithRouter(_item(hasReview: true));
      await tester.pumpWidget(env.widget);
      await tester.pumpAndSettle();

      expect(find.text('Laisser un avis'), findsNothing);
    });

    testWidgets('le tap sur la carte navigue vers la fiche artisan', (
      tester,
    ) async {
      final env = _wrapWithRouter(_item(slug: 'mohamed-plombier'));
      await tester.pumpWidget(env.widget);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sami Plomberie'));
      await tester.pumpAndSettle();

      expect(find.text('provider-screen'), findsOneWidget);
    });

    testWidgets(
      'le tap sur le CTA avis navigue vers le formulaire, pas la fiche',
      (tester) async {
        final env = _wrapWithRouter(_item(slug: 'mohamed-plombier'));
        await tester.pumpWidget(env.widget);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Laisser un avis'));
        await tester.pumpAndSettle();

        expect(find.text('review-screen'), findsOneWidget);
        expect(find.text('provider-screen'), findsNothing);
      },
    );
  });
}
