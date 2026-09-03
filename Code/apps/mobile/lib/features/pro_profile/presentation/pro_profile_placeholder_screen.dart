import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/empty_state.dart';

/// Onglet Profil pro (`/pro/profile`) — contenu réel = `FM-38` (bloqué par
/// `BE-44`, `GET /v1/providers/me` toujours absent). Écran distinct du
/// `ProfilePlaceholderScreen` client (`features/profile/`) — publics et
/// contenus différents. Ce placeholder rend l'onglet du shell pro (FM-24)
/// atteignable en attendant. Porte aussi (FM-25) le retour vers l'espace
/// client : atteindre cet écran suppose déjà une session PROVIDER (garde
/// `/pro/*` de `router.dart`), aucune vérification de rôle supplémentaire
/// n'est donc nécessaire ici.
class ProProfilePlaceholderScreen extends ConsumerWidget {
  const ProProfilePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(t.proProfile.title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EmptyState(
              icon: '👤',
              title: t.proProfile.emptyTitle,
              message: t.proProfile.emptyMessage,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: t.proProfile.switchToClientSpace,
              variant: AppButtonVariant.secondary,
              onPressed: () => context.go('/client'),
            ),
          ],
        ),
      ),
    );
  }
}
