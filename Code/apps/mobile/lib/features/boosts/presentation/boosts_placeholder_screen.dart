import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/widgets/empty_state.dart';

/// Onglet Boosts (`/pro/boosts`) — contenu réel bloqué par `FM-40`
/// (EP-BILLING/ADR-004, aucun moyen de paiement tranché). Ce placeholder
/// rend l'onglet du shell pro (FM-24) atteignable en attendant.
class BoostsPlaceholderScreen extends ConsumerWidget {
  const BoostsPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(t.boosts.title)),
      body: Center(
        child: EmptyState(
          icon: '⚡',
          title: t.boosts.emptyTitle,
          message: t.boosts.emptyMessage,
        ),
      ),
    );
  }
}
