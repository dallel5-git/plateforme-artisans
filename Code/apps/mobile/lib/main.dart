import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sanaya/app/providers.dart';
import 'package:sanaya/app/router.dart';
import 'package:sanaya/app/theme.dart';

void main() {
  runApp(const ProviderScope(child: SanayaApp()));
}

class SanayaApp extends ConsumerWidget {
  const SanayaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

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
