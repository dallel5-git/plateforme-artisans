import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/auth/application/current_user_provider.dart';
import 'package:sanaya/features/dashboard/application/dashboard_providers.dart';
import 'package:sanaya/features/dashboard/data/dashboard_repository.dart';
import 'package:sanaya/features/dashboard/presentation/screens/dashboard_screen.dart';

class _DashboardRepositoryMock extends Mock implements DashboardRepository {}

// Construit un ProviderStats minimal (série vide, stats à 0 — suffisant pour
// les tests d'en-tête FM-37a qui ne testent pas les métriques).
ProviderStats _buildMinimalStats() {
  return ProviderStats(
    (b) => b
      ..totals.profileViews = 10
      ..totals.uniqueProfileViews = 8
      ..totals.contacts = 2
      ..totals.contactsByChannel.phone = 1
      ..totals.contactsByChannel.whatsapp = 1
      ..totals.viewToContactRatio = 0.2
      ..series = ListBuilder<ProviderStatsSeriesPoint>([]),
  );
}

/// Construit un utilisateur authentifié minimal.
/// Seul `firstName` nous importe pour les tests d'en-tête ;
/// les autres champs requis sont renseignés avec des valeurs neutres.
V1AuthMeGet200Response _buildUser({required String firstName}) {
  return V1AuthMeGet200Response(
    (b) => b
      ..id = 'user-123'
      ..firstName = firstName
      ..lastName = 'Test'
      ..phone = '+21612345678'
      ..phoneVerifiedAt = DateTime(2026)
      ..email = 'test@example.com'
      ..emailVerifiedAt = DateTime(2026)
      ..avatarMediaId = ''
      ..roles = ListBuilder<V1AuthOtpVerifyPost200ResponseUserRolesEnum>([
        V1AuthOtpVerifyPost200ResponseUserRolesEnum.PROVIDER,
      ])
      ..status = V1AuthMeGet200ResponseStatusEnum.ACTIVE
      ..locale = 'fr'
      ..lastLoginAt = DateTime(2026)
      ..marketingOptIn = false
      ..createdAt = DateTime(2026)
      ..updatedAt = DateTime(2026),
  );
}

Widget _wrap({
  required DashboardRepository statsRepo,
  AsyncValue<V1AuthMeGet200Response?>? currentUser,
  Locale locale = const Locale('fr'),
}) {
  return ProviderScope(
    overrides: [
      localeProvider.overrideWith((ref) => locale),
      dashboardRepositoryProvider.overrideWithValue(statsRepo),
      if (currentUser != null)
        currentUserProvider.overrideWith((ref) async {
          return currentUser.when(
            data: (v) => v,
            loading: () => null,
            error: Error.throwWithStackTrace,
          );
        }),
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
        child: const DashboardScreen(),
      ),
    ),
  );
}

void main() {
  group('DashboardScreen — FM-37a : en-tête salutation', () {
    testWidgets(
      'affiche "Bonjour, Karim" quand currentUserProvider retourne firstName',
      (tester) async {
        final repo = _DashboardRepositoryMock();
        when(repo.fetchStats).thenAnswer((_) async => _buildMinimalStats());

        await tester.pumpWidget(
          _wrap(
            statsRepo: repo,
            currentUser: AsyncValue.data(_buildUser(firstName: 'Karim')),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Bonjour, Karim'), findsOneWidget);
      },
    );

    testWidgets(
      'affiche le titre fallback quand currentUserProvider est en erreur',
      (tester) async {
        final repo = _DashboardRepositoryMock();
        when(repo.fetchStats).thenAnswer((_) async => _buildMinimalStats());

        await tester.pumpWidget(
          _wrap(
            statsRepo: repo,
            currentUser: AsyncValue.error(
              Exception('auth error'),
              StackTrace.empty,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Jamais d'écran blanc — titre fallback "Tableau de bord" affiché
        expect(find.text('Tableau de bord'), findsOneWidget);
        expect(find.textContaining('Bonjour'), findsNothing);
      },
    );

    testWidgets(
      'affiche le titre fallback quand firstName est une chaîne vide',
      (tester) async {
        final repo = _DashboardRepositoryMock();
        when(repo.fetchStats).thenAnswer((_) async => _buildMinimalStats());

        await tester.pumpWidget(
          _wrap(
            statsRepo: repo,
            currentUser: AsyncValue.data(_buildUser(firstName: '')),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Tableau de bord'), findsOneWidget);
        expect(find.textContaining('Bonjour'), findsNothing);
      },
    );

    testWidgets(
      'affiche la salutation en arabe avec RTL actif',
      (tester) async {
        final repo = _DashboardRepositoryMock();
        when(repo.fetchStats).thenAnswer((_) async => _buildMinimalStats());

        await tester.pumpWidget(
          _wrap(
            statsRepo: repo,
            currentUser: AsyncValue.data(_buildUser(firstName: 'كريم')),
            locale: const Locale('ar'),
          ),
        );
        await tester.pumpAndSettle();

        // La salutation arabe doit contenir le prénom
        expect(find.textContaining('مرحباً'), findsOneWidget);

        final dir = tester.widget<Directionality>(
          find.byType(Directionality).first,
        );
        expect(dir.textDirection, TextDirection.rtl);
      },
    );
  });
}
