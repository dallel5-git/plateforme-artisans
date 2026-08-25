import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';

/// Les 3 groupes de routes bootstrap — remplacés feature par feature par
/// les tickets FM-05+.
enum BootstrapNavSpace { auth, client, pro }

/// Écran provisoire pour les groupes de routes /auth, /client, /pro.
class BootstrapPlaceholderScreen extends ConsumerWidget {
  const BootstrapPlaceholderScreen({required this.space, super.key});

  final BootstrapNavSpace space;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);
    final label = switch (space) {
      BootstrapNavSpace.auth => t.common.home.navAuth,
      BootstrapNavSpace.client => t.common.home.navClient,
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
