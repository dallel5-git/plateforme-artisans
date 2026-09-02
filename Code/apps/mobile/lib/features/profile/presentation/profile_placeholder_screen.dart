import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/widgets/empty_state.dart';

/// Onglet Profil (`/client/profile`) — contenu réel = `FM-32`. Porte pour
/// l'instant les 2 réglages relogés depuis l'ancien hub de dev (`FM-23`) :
/// bascule langue FR/AR et bascule thème clair/sombre — sans quoi ces
/// réglages disparaîtraient de l'app à la suppression du hub.
class ProfilePlaceholderScreen extends ConsumerWidget {
  const ProfilePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final t = ref.watch(translationsProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(t.profile.title),
        actions: [
          IconButton(
            tooltip: t.common.home.toggleLocale,
            icon: const Icon(Icons.language),
            onPressed: () => ref.read(localeProvider.notifier).state =
                locale.languageCode == 'fr'
                ? const Locale('ar')
                : const Locale('fr'),
          ),
          IconButton(
            tooltip: t.common.home.toggleTheme,
            icon: Icon(
              themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: () => ref.read(themeModeProvider.notifier).state =
                themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
          ),
        ],
      ),
      body: Center(
        child: EmptyState(
          icon: '👤',
          title: t.profile.emptyTitle,
          message: t.profile.emptyMessage,
        ),
      ),
    );
  }
}
