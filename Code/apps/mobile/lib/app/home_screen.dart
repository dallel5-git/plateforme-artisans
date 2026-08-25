import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sanaya/app/bootstrap_copy.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.surface,
        actions: [
          IconButton(
            tooltip: BootstrapCopy.toggleLocaleTooltip,
            icon: const Icon(Icons.language),
            onPressed: () => ref.read(localeProvider.notifier).state =
                locale.languageCode == 'fr'
                ? const Locale('ar')
                : const Locale('fr'),
          ),
          IconButton(
            tooltip: BootstrapCopy.toggleThemeTooltip,
            icon: Icon(
              themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: () => ref.read(themeModeProvider.notifier).state =
                themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
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
              BootstrapCopy.appName,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: AppSpacing.s2xl),
            _NavButton(
              label: BootstrapCopy.authLabel,
              onTap: () => context.go('/auth'),
            ),
            const SizedBox(height: AppSpacing.sm),
            _NavButton(
              label: BootstrapCopy.clientLabel,
              onTap: () => context.go('/client'),
            ),
            const SizedBox(height: AppSpacing.sm),
            _NavButton(
              label: BootstrapCopy.proLabel,
              onTap: () => context.go('/pro'),
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
    return FilledButton(onPressed: onTap, child: Text(label));
  }
}
