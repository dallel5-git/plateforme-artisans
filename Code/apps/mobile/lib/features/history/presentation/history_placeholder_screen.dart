import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/widgets/empty_state.dart';

/// Onglet Historique (`/client/history`) — contenu réel bloqué par `FM-31`/
/// `BE-45` (aucun endpoint `GET /v1/contact-events`). Ce placeholder rend
/// l'onglet du shell client (FM-23) atteignable en attendant.
class HistoryPlaceholderScreen extends ConsumerWidget {
  const HistoryPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(t.history.title)),
      body: Center(
        child: EmptyState(
          icon: '🕒',
          title: t.history.emptyTitle,
          message: t.history.emptyMessage,
        ),
      ),
    );
  }
}
