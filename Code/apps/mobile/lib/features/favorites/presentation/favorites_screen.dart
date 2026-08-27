import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
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
    final locale = Localizations.localeOf(context);
    final t = ref.watch(translationsProvider);
    final favoritesAsync = ref.watch(favoritesListProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        title: Text(
          t.favorites.title,
          style: AppText.h3(locale).copyWith(color: colors.textPrimary),
        ),
      ),
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
          error: (error, _) => _FavoritesErrorView(
            message: t.favorites.loadError,
            retryLabel: t.favorites.retry,
            onRetry: () => ref.read(favoritesListProvider.notifier).refresh(),
          ),
          data: (items) => items.isEmpty
              ? _FavoritesEmptyView(
                  title: t.favorites.emptyTitle,
                  subtitle: t.favorites.emptySubtitle,
                  ctaLabel: t.favorites.exploreCta,
                  onExploreTap: () => context.go('/client'),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) => FavoriteCard(
                    item: items[index],
                  ),
                ),
        ),
      ),
    );
  }
}

class _FavoritesEmptyView extends StatelessWidget {
  const _FavoritesEmptyView({
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    required this.onExploreTap,
  });

  final String title;
  final String subtitle;
  final String ctaLabel;
  final VoidCallback onExploreTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 64,
                  color: colors.textMuted,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  title,
                  style: AppText.h3(locale).copyWith(color: colors.textPrimary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: AppText.small(locale).copyWith(
                    color: colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: ctaLabel,
                  onPressed: onExploreTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FavoritesErrorView extends StatelessWidget {
  const _FavoritesErrorView({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: colors.destructive,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  message,
                  style: AppText.body(locale).copyWith(
                    color: colors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  label: retryLabel,
                  variant: AppButtonVariant.secondary,
                  onPressed: onRetry,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
