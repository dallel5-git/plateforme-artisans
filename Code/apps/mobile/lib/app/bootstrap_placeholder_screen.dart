import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';

/// Groupes de routes encore en bootstrap — remplacés feature par feature
/// par les tickets FM-05+. `client` a été retiré : `/client` route
/// désormais vers `SearchHomeScreen` (FM-06).
enum BootstrapNavSpace { auth, pro }

/// Écran provisoire pour les groupes de routes /auth, /client, /pro.
class BootstrapPlaceholderScreen extends ConsumerWidget {
  const BootstrapPlaceholderScreen({required this.space, super.key});

  final BootstrapNavSpace space;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);
    final label = switch (space) {
      BootstrapNavSpace.auth => t.common.home.navAuth,
      BootstrapNavSpace.pro => t.common.home.navPro,
    };

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(backgroundColor: context.colors.surface),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
