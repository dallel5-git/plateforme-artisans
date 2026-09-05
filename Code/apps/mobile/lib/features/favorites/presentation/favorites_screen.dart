import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/widgets/empty_state.dart';
import 'package:sanaya/core/widgets/error_state.dart';
import 'package:sanaya/features/favorites/application/favorites_providers.dart';
import 'package:sanaya/features/favorites/presentation/widgets/favorite_card.dart';
import 'package:sanaya/features/favorites/presentation/widgets/favorite_card_skeleton.dart';

/// Écran « Mes favoris » (US-C-08, FM-13).
/// Affiche la liste des artisans sauvegardés par le client authentifié,
/// avec accès direct aux CTA de contact et gestion hors ligne/réseau dégradé.
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final t = ref.watch(translationsProvider);
    final favoritesAsync = ref.watch(favoritesListProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(t.favorites.title)),
      body: RefreshIndicator(
        onRefresh: () => ref.read(favoritesListProvider.notifier).refresh(),
        child: favoritesAsync.when(
          loading: () => ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: 4,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) => const FavoriteCardSkeleton(),
          ),
          error: (error, _) => _FavoritesStateView(
            child: ErrorState(
              icon: '⚠️',
              title: t.favorites.errorTitle,
              message: t.favorites.loadError,
              actionLabel: t.favorites.retry,
              onAction: () =>
                  ref.read(favoritesListProvider.notifier).refresh(),
            ),
          ),
          data: (items) => items.isEmpty
              ? _FavoritesStateView(
                  child: EmptyState(
                    icon: '🤍',
                    title: t.favorites.emptyTitle,
                    message: t.favorites.emptySubtitle,
                    actionLabel: t.favorites.exploreCta,
                    // FM-23 : sous le shell, changer d'onglet (index 0 =
                    // Rechercher) plutôt que de re-résoudre toute la route
                    // depuis la racine.
                    onAction: () =>
                        StatefulNavigationShell.of(context).goBranch(0),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) => FavoriteCard(
                    item: items[index],
                    onTap: () => context.pushNamed(
                      'provider-profile',
                      pathParameters: {'slug': items[index].slug},
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

/// Enrobe [EmptyState]/[ErrorState] pour qu'elles restent centrées même
/// quand le contenu est plus court que l'écran (patron déjà en place dans
/// `client_history_screen.dart`/FM-31 pour le même problème sur une liste).
class _FavoritesStateView extends StatelessWidget {
  const _FavoritesStateView({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(child: child),
        ),
      ),
    );
  }
}
