import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/widgets/empty_state.dart';

/// Onglet Profil pro (`/pro/profile`) — contenu réel = `FM-38` (bloqué par
/// `BE-44`, `GET /v1/providers/me` toujours absent). Écran distinct du
/// `ProfilePlaceholderScreen` client (`features/profile/`) — publics et
/// contenus différents. Ce placeholder rend l'onglet du shell pro (FM-24)
/// atteignable en attendant.
class ProProfilePlaceholderScreen extends ConsumerWidget {
  const ProProfilePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(t.proProfile.title)),
      body: Center(
        child: EmptyState(
          icon: '👤',
          title: t.proProfile.emptyTitle,
          message: t.proProfile.emptyMessage,
        ),
      ),
    );
  }
}
