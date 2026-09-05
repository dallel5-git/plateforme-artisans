import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sanaya/core/connectivity/connectivity_provider.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/widgets/offline_banner.dart';

/// Câble [OfflineBanner] sur `connectivityServiceProvider.isOnline` — un
/// seul point de câblage par shell (FM-23/FM-24) plutôt qu'un par écran
/// (FM-42, issue #239). Se met à jour tout seul quand la connectivité
/// change ; pas de [OfflineBanner.onDismiss] ici, le bandeau reflète l'état
/// réseau en direct, une fermeture manuelle réapparaîtrait dès le prochain
/// changement de connectivité sans rien gagner en confort.
class ConnectivityBanner extends ConsumerWidget {
  const ConnectivityBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityServiceProvider);

    return ValueListenableBuilder<bool>(
      valueListenable: connectivity.isOnline,
      builder: (context, isOnline, _) {
        if (isOnline) return const SizedBox.shrink();
        return const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          child: SafeArea(bottom: false, child: OfflineBanner()),
        );
      },
    );
  }
}
