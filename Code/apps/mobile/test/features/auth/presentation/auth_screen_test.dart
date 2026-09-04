import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/core/api/auth_token_store.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/features/auth/application/auth_providers.dart';
import 'package:sanaya/features/auth/data/auth_repository.dart';
import 'package:sanaya/features/auth/presentation/auth_screen.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockAuthTokenStore extends Mock implements AuthTokenStore {}

class _MockVerifyResponse extends Mock
    implements V1AuthOtpVerifyPost200Response {}

class _MockUser extends Mock implements V1AuthOtpVerifyPost200ResponseUser {}

Widget _wrap({
  required AuthRepository authRepository,
  required AuthTokenStore authTokenStore,
}) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      authTokenStoreProvider.overrideWithValue(authTokenStore),
    ],
    child: MaterialApp(
      theme: buildTheme(
        brightness: Brightness.light,
        locale: const Locale('fr'),
      ),
      locale: const Locale('fr'),
      home: const AuthScreen(),
    ),
  );
}

void main() {
  final t = AppLocale.fr.buildSync();

  testWidgets("affiche directement l'écran de saisie du téléphone (FM-33)", (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        authRepository: _MockAuthRepository(),
        authTokenStore: _MockAuthTokenStore(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(t.auth.phoneTitle), findsOneWidget);
  });

  testWidgets(
    '🔒 parcours complet : téléphone → OTP → session ouverte '
    '(P3 — le notifier n’importe pas le routeur, l’écran réagit à '
    'verifiedUser)',
    (tester) async {
      final authRepository = _MockAuthRepository();
      final authTokenStore = _MockAuthTokenStore();
      final user = _MockUser();
      final response = _MockVerifyResponse();
      when(() => response.accessToken).thenReturn('access-xyz');
      when(() => response.refreshToken).thenReturn('session-id.token-id');
      when(() => response.user).thenReturn(user);
      when(() => user.roles).thenReturn(
        BuiltList<V1AuthOtpVerifyPost200ResponseUserRolesEnum>([
          V1AuthOtpVerifyPost200ResponseUserRolesEnum.CLIENT,
        ]),
      );
      // FM-05d : `submitOtp` attend la résolution du bootstrap de session
      // (`authStateProvider`) avant d'y écrire l'état authentifié.
      when(
        authTokenStore.restoreSession,
      ).thenAnswer((_) async => false);
      when(
        () => authRepository.requestOtp('+21622123456'),
      ).thenAnswer((_) async {});
      when(
        () => authRepository.verifyOtp(
          phone: '+21622123456',
          code: '123456',
        ),
      ).thenAnswer((_) async => response);
      when(
        () => authTokenStore.saveSession(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(
        _wrap(authRepository: authRepository, authTokenStore: authTokenStore),
      );
      await tester.pumpAndSettle();

      expect(find.text(t.auth.phoneTitle), findsOneWidget);

      await tester.enterText(find.byType(TextField), '22123456');
      await tester.pumpAndSettle();
      await tester.tap(find.text(t.auth.phoneCta));
      await tester.pumpAndSettle();

      expect(find.text(t.auth.otpTitle), findsOneWidget);
      expect(find.textContaining('+21622123456'), findsOneWidget);

      final otpFields = find.byType(TextField);
      for (var i = 0; i < 6; i++) {
        await tester.enterText(otpFields.at(i), '${i + 1}');
      }
      await tester.pumpAndSettle();

      verify(
        () => authTokenStore.saveSession(
          accessToken: 'access-xyz',
          refreshToken: 'session-id.token-id',
        ),
      ).called(1);
    },
  );

  testWidgets(
    'code invalide : affiche le nombre de tentatives restantes (BE-10e) '
    'et bloque après OTP_TOO_MANY_ATTEMPTS',
    (tester) async {
      final authRepository = _MockAuthRepository();
      final authTokenStore = _MockAuthTokenStore();
      when(
        () => authRepository.requestOtp('+21622123456'),
      ).thenAnswer((_) async {});
      when(
        () => authRepository.verifyOtp(
          phone: '+21622123456',
          code: any(named: 'code'),
        ),
      ).thenThrow(
        UnauthorizedException(
          code: 'OTP_INVALID',
          message: 'Code invalide',
          details: const {'attemptsRemaining': 2},
        ),
      );

      await tester.pumpWidget(
        _wrap(authRepository: authRepository, authTokenStore: authTokenStore),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '22123456');
      await tester.pumpAndSettle();
      await tester.tap(find.text(t.auth.phoneCta));
      await tester.pumpAndSettle();

      final otpFields = find.byType(TextField);
      for (var i = 0; i < 6; i++) {
        await tester.enterText(otpFields.at(i), '0');
      }
      await tester.pumpAndSettle();

      expect(
        find.text(t.auth.otpAttemptsRemaining.replaceAll('{count}', '2')),
        findsOneWidget,
      );
      verifyZeroInteractions(authTokenStore);
    },
  );
}
