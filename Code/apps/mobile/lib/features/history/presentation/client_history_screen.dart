import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/auth_required_view.dart';
import 'package:sanaya/core/widgets/empty_state.dart';
import 'package:sanaya/features/auth/application/auth_state_provider.dart';
import 'package:sanaya/features/history/application/contact_history_providers.dart';
import 'package:sanaya/features/history/presentation/widgets/history_entry_card.dart';
import 'package:sanaya/features/history/presentation/widgets/history_entry_card_skeleton.dart';

/// Onglet Historique (`/client/history`, FM-31) — liste des artisans
/// contactés, triée par date décroissante (BE-45), avec le canal utilisé et
/// un raccourci vers le dépôt d'avis tant qu'aucun avis n'est posé.
/// Remplace `HistoryPlaceholderScreen` posé par `FM-23a` en attendant cette
/// issue.
class ClientHistoryScreen extends ConsumerWidget {
  const ClientHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final t = ref.watch(translationsProvider);

    final authStatus = ref.watch(authStateProvider).valueOrNull;
    if (authStatus == null || !authStatus.isAuthenticated) {
      return Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(title: Text(t.history.title)),
        body: AuthRequiredView(
          icon: '🕒',
          title: t.history.authRequiredTitle,
          message: t.history.authRequiredSubtitle,
          ctaLabel: t.history.loginCta,
        ),
      );
    }

    final historyAsync = ref.watch(contactHistoryProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(t.history.title)),
      body: RefreshIndicator(
        onRefresh: () => ref.read(contactHistoryProvider.notifier).refresh(),
        child: historyAsync.when(
          loading: () => ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: 4,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) => const HistoryEntryCardSkeleton(),
          ),
          error: (error, _) => _HistoryErrorView(
            message: t.history.loadError,
            retryLabel: t.history.retry,
            onRetry: () => ref.read(contactHistoryProvider.notifier).refresh(),
          ),
          data: (state) => state.items.isEmpty
              ? _HistoryEmptyView(
                  title: t.history.emptyTitle,
                  message: t.history.emptyMessage,
                  ctaLabel: t.history.emptyCta,
                  // FM-23 : sous le shell, changer d'onglet (index 0 =
                  // Rechercher) plutôt que de re-résoudre toute la route
                  // depuis la racine (même patron que FavoritesScreen).
                  onExploreTap: () =>
                      StatefulNavigationShell.of(context).goBranch(0),
                )
              : NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (state.hasMore &&
                        !state.isLoadingMore &&
                        notification.metrics.pixels >=
                            notification.metrics.maxScrollExtent - 200) {
                      unawaited(
                        ref.read(contactHistoryProvider.notifier).loadMore(),
                      );
                    }
                    return false;
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: state.items.length + (state.hasMore ? 1 : 0),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      if (index >= state.items.length) {
                        return const HistoryEntryCardSkeleton();
                      }
                      return HistoryEntryCard(item: state.items[index]);
                    },
                  ),
                ),
        ),
      ),
    );
  }
}

class _HistoryEmptyView extends StatelessWidget {
  const _HistoryEmptyView({
    required this.title,
    required this.message,
    required this.ctaLabel,
    required this.onExploreTap,
  });

  final String title;
  final String message;
  final String ctaLabel;
  final VoidCallback onExploreTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: EmptyState(
              icon: '🕒',
              title: title,
              message: message,
              actionLabel: ctaLabel,
              onAction: onExploreTap,
            ),
          ),
        ),
      ),
    );
  }
}

class _HistoryErrorView extends StatelessWidget {
  const _HistoryErrorView({
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
                  style: AppText.body(
                    locale,
                  ).copyWith(color: colors.textPrimary),
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
