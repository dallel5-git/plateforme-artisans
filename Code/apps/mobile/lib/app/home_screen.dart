import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final t = ref.watch(translationsProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.surface,
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
          IconButton(
            tooltip: t.common.home.designSystemPreview,
            icon: const Icon(Icons.palette_outlined),
            onPressed: () => context.go('/_ds-preview'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              t.common.appName,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: AppSpacing.s2xl),
            _NavButton(
              label: t.common.home.navAuth,
              onTap: () => context.go('/auth'),
            ),
            const SizedBox(height: AppSpacing.sm),
            _NavButton(
              label: t.common.home.navClient,
              onTap: () => context.go('/client'),
            ),
            const SizedBox(height: AppSpacing.sm),
            _NavButton(
              label: t.common.home.navPro,
              onTap: () => context.go('/pro'),
            ),
            const SizedBox(height: AppSpacing.sm),
            _NavButton(
              label: t.common.home.navProDashboard,
              onTap: () => context.go('/pro/dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          // `Icons.chevron_right` porte déjà IconData.matchTextDirection:
          // true — Flutter le miroite automatiquement selon la
          // Directionality ambiante (cf. apps/mobile/CLAUDE.md, RTL &
          // bilingue). Aucun wrapper personnalisé nécessaire.
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
