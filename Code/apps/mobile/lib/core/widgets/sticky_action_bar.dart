import 'package:flutter/material.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';

/// Barre d'action fixe en bas d'écran (design-system.html, issue FM-41/#238) :
/// fond `surface`, filet supérieur `border`, `SafeArea`. Généralise
/// `_ContactBar` (fiche artisan, boutons Appeler/WhatsApp) — trois autres
/// écrans traitaient jusqu'ici ce même motif de manière ad hoc ou pas du
/// tout (dépôt d'avis, « Continuer » de l'onboarding, « Activer le boost »).
///
/// Prévue comme `bottomNavigationBar` d'un `Scaffold` : ne porte que le
/// chrome, [child] reste responsable du contenu (un ou plusieurs boutons).
class StickyActionBar extends StatelessWidget {
  const StickyActionBar({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: SafeArea(child: child),
    );
  }
}
