import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/widgets/app_bottom_nav.dart';

/// Enrobe les 4 branches du shell client (FM-23) : `AppBottomNav` en bas,
/// et gère le retour arrière Android — un onglet secondaire ramène à
/// Rechercher (index 0) avant de quitter l'app, qui elle-même requiert un
/// second appui dans les 2 secondes (patron Android classique, premier
/// usage dans ce repo).
class ClientShellScreen extends ConsumerStatefulWidget {
  const ClientShellScreen({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<ClientShellScreen> createState() => _ClientShellScreenState();
}

class _ClientShellScreenState extends ConsumerState<ClientShellScreen> {
  DateTime? _lastBackPressAt;

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(translationsProvider);
    final currentIndex = widget.navigationShell.currentIndex;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (currentIndex != 0) {
          widget.navigationShell.goBranch(0);
          return;
        }
        final now = DateTime.now();
        final last = _lastBackPressAt;
        if (last != null && now.difference(last) < const Duration(seconds: 2)) {
          unawaited(SystemNavigator.pop());
          return;
        }
        _lastBackPressAt = now;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            // `behavior: fixed` (pas le flottant par défaut de Material 3) :
            // au-dessus d'un `bottomNavigationBar`, une SnackBar flottante
            // peut se retrouver hors écran sur les petits viewports (assert
            // « Floating SnackBar presented off screen »).
            SnackBar(
              content: Text(t.common.nav.exitConfirmation),
              behavior: SnackBarBehavior.fixed,
            ),
          );
      },
      child: Scaffold(
        body: widget.navigationShell,
        bottomNavigationBar: AppBottomNav(
          items: [
            AppBottomNavItem(icon: Icons.search, label: t.common.nav.searchTab),
            AppBottomNavItem(
              icon: Icons.favorite_border,
              label: t.common.nav.favoritesTab,
            ),
            AppBottomNavItem(
              icon: Icons.history,
              label: t.common.nav.historyTab,
            ),
            AppBottomNavItem(
              icon: Icons.person_outline,
              label: t.common.nav.profileTab,
            ),
          ],
          currentIndex: currentIndex,
          onTap: (index) => widget.navigationShell.goBranch(
            index,
            initialLocation: index == currentIndex,
          ),
        ),
      ),
    );
  }
}
