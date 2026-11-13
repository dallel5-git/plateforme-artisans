import 'package:flutter/material.dart';

import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';

/// Un onglet de [AppBottomNav]. Le libellé arrive déjà traduit par l'écran
/// appelant (`t.common.nav.*`) — ce widget, comme `AppButton`, ignore l'i18n.
class AppBottomNavItem {
  const AppBottomNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// Barre de navigation basse partagée (design-system.html §10). Purement
/// présentation : la logique de shell (`StatefulShellRoute`) reste à
/// FM-23/FM-24. Aucun code RTL manuel — `Row` s'inverse déjà sous
/// `Directionality.rtl` ambiante, comme `CategoryGrid`.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final List<AppBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return Material(
      color: colors.navBackground,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              for (final (index, item) in items.indexed)
                Expanded(
                  child: _AppBottomNavTile(
                    item: item,
                    selected: index == currentIndex,
                    locale: locale,
                    onTap: () => onTap(index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBottomNavTile extends StatelessWidget {
  const _AppBottomNavTile({
    required this.item,
    required this.selected,
    required this.locale,
    required this.onTap,
  });

  final AppBottomNavItem item;
  final bool selected;
  final Locale locale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = selected ? colors.navActive : colors.navInactive;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppLayout.touchTarget),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              vertical: AppSpacing.xs,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, size: AppIconSize.md, color: color),
                const SizedBox(height: AppSpacing.xxs),
                // Le libellé explicite ci-dessus couvre déjà ce texte — sans
                // exclusion, Flutter concatène le label implicite du `Text`
                // au nôtre (« Favoris\nFavoris »).
                ExcludeSemantics(
                  child: Text(
                    item.label,
                    style: AppText.caption(locale).copyWith(color: color),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
