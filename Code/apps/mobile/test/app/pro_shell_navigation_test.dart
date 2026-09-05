import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/app/router.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/core/api/auth_token_store.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/features/auth/application/auth_providers.dart';
import 'package:sanaya/features/auth/data/auth_repository.dart';
import 'package:sanaya/features/onboarding/application/onboarding_providers.dart';
import 'package:sanaya/features/reviews/application/pro_reviews_providers.dart';
import 'package:sanaya/main.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockAuthTokenStore extends Mock implements AuthTokenStore {}

class _MockMeResponse extends Mock implements V1AuthMeGet200Response {}

/// FM-24 — premier test du shell pro : verrouille que les 4 onglets
/// (`AppBottomNav`) mènent bien à leurs 4 branches respectives
/// (`StatefulShellRoute.indexedStack`, même patron que le shell client
/// FM-23/`shell_navigation_test.dart`).
void main() {
  final t = AppLocale.fr.buildSync();

  setUp(() => router.go('/'));

  Future<void> pumpPastSplash(WidgetTester tester) async {
    await tester.pump();
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Widget buildApp() {
    final authRepository = _MockAuthRepository();
    final authTokenStore = _MockAuthTokenStore();
    when(authTokenStore.restoreSession).thenAnswer((_) async => true);
    final me = _MockMeResponse();
    when(() => me.roles).thenReturn(
      BuiltList<V1AuthOtpVerifyPost200ResponseUserRolesEnum>([
        V1AuthOtpVerifyPost200ResponseUserRolesEnum.PROVIDER,
      ]),
    );
    when(authRepository.getCurrentUser).thenAnswer((_) async => me);

    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        authTokenStoreProvider.overrideWithValue(authTokenStore),
        hasPublishedProfileProvider.overrideWith((ref) => true),
        myProviderProfileProvider.overrideWith((ref) async => null),
      ],
      child: const SanayaApp(),
    );
  }

  testWidgets(
    'tap sur chaque onglet affiche la branche correspondante '
    '(dashboard/boosts/avis/profil)',
    (tester) async {
      await tester.pumpWidget(buildApp());
      await pumpPastSplash(tester);

      expect(find.text(t.dashboard.title), findsWidgets);

      await tester.tap(find.text(t.common.nav.boostsTab));
      await tester.pumpAndSettle();
      expect(find.text(t.billing.creditsBalance), findsOneWidget);

      await tester.tap(find.text(t.common.nav.reviewsTab));
      await tester.pumpAndSettle();
      expect(find.text(t.reviews.emptyTitle), findsOneWidget);

      await tester.tap(find.text(t.common.nav.profileTab));
      await tester.pumpAndSettle();
      expect(find.text(t.proProfile.emptyTitle), findsOneWidget);

      await tester.tap(find.text(t.common.nav.dashboardTab));
      await tester.pumpAndSettle();
      expect(find.text(t.dashboard.title), findsWidgets);
    },
  );
}
