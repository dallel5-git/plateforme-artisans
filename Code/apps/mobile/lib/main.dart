import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:sanaya/app/providers.dart';
import 'package:sanaya/app/router.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/i18n/locale_persistence.dart';
import 'package:sanaya/features/auth/application/auth_state_provider.dart';
import 'package:sanaya/features/auth/application/auth_status.dart';
import 'package:sanaya/features/contact/application/contact_providers.dart';
import 'package:sanaya/features/search/application/catalog_providers.dart';
import 'package:sanaya/features/search/data/governorate_persistence.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialLocale = await readInitialLocale();
  final initialGovernorateId = await readInitialGovernorateId();

  // FM-03d : DateFormat lève une exception tant que les données de locale
  // ne sont pas chargées — fait une seule fois au bootstrap pour les deux
  // locales supportées, avant tout usage de lib/core/i18n/format.dart.
  await initializeDateFormatting('fr');
  await initializeDateFormatting('ar');

  runApp(
    ProviderScope(
      overrides: [
        localeProvider.overrideWith((ref) => initialLocale),
        // FM-06 : même patron que `localeProvider` — lecture une seule
        // fois avant `runApp`, écriture via `ref.listen` dans `SanayaApp`.
        selectedGovernorateIdProvider.overrideWith(
          (ref) => initialGovernorateId,
        ),
      ],
      child: const SanayaApp(),
    ),
  );
}

class SanayaApp extends ConsumerWidget {
  const SanayaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

    // FM-03b : persiste tout changement de langue — la lecture initiale se
    // fait une seule fois avant runApp (voir main() ci-dessus). FM-06 :
    // idem pour le gouvernorat choisi (critère d'acceptation — mémorisé
    // entre deux lancements) ; `null` = aucun choix encore fait, rien à
    // persister.
    ref
      ..listen<Locale>(localeProvider, (_, next) => persistLocale(next))
      ..listen<String?>(
        selectedGovernorateIdProvider,
        (_, next) => next == null ? null : persistGovernorateId(next),
      )
      // FM-09c : vidage opportuniste de la file de contacts hors ligne, une
      // seule fois au premier build (valeur ignorée — l'échec d'un renvoi
      // ne doit rien changer à l'affichage, P5).
      ..watch(contactQueueFlushProvider)
      // FM-05d : démarre la restauration de session (AuthTokenStore +
      // GET /auth/me) dès le premier frame, et relaie chaque changement à
      // `router` (singleton top-level, pas un `Provider<GoRouter>` — voir
      // router.dart) pour que sa garde `redirect:` se réévalue.
      ..listen<AsyncValue<AuthStatus>>(
        authStateProvider,
        (_, _) => authRouterRefreshListenable.refresh(),
      );

    return MaterialApp.router(
      routerConfig: router,
      // Directionality est pilotée ici, au niveau de MaterialApp, jamais
      // par écran (cf. apps/mobile/CLAUDE.md — RTL automatique pour 'ar'
      // via les délégués de localisation ci-dessous).
      locale: locale,
      supportedLocales: const [Locale('fr'), Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: buildTheme(brightness: Brightness.light, locale: locale),
      darkTheme: buildTheme(brightness: Brightness.dark, locale: locale),
      themeMode: themeMode,
    );
  }
}
