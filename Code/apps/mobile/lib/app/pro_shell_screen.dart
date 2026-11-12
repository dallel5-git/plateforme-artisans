import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/demo/demo_banner.dart';
import 'package:sanaya/core/widgets/app_bottom_nav.dart';
import 'package:sanaya/core/widgets/connectivity_banner.dart';

/// Enrobe les 4 branches du shell pro (FM-24) : `AppBottomNav` en bas.
/// Volontairement plus simple que `ClientShellScreen` (FM-23) — pas de
/// confirmation de sortie à double-retour, hors périmètre de l'issue FM-24.
class ProShellScreen extends ConsumerWidget {
  const ProShellScreen({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      body: Column(
        children: [
          const ConnectivityBanner(),
          const DemoBanner(),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        items: [
          AppBottomNavItem(
            icon: Icons.space_dashboard_outlined,
            label: t.common.nav.dashboardTab,
          ),
          AppBottomNavItem(icon: Icons.bolt, label: t.common.nav.boostsTab),
          AppBottomNavItem(
            icon: Icons.star_outline,
            label: t.common.nav.reviewsTab,
          ),
          AppBottomNavItem(
            icon: Icons.person_outline,
            label: t.common.nav.profileTab,
          ),
        ],
        currentIndex: currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == currentIndex,
        ),
      ),
    );
  }
}
