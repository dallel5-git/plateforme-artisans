import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/i18n/format.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/app_card.dart';
import 'package:sanaya/core/widgets/app_skeleton.dart';
import 'package:sanaya/core/widgets/empty_state.dart';
import 'package:sanaya/core/widgets/error_state.dart';
import 'package:sanaya/core/widgets/rating_stars.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';
import 'package:sanaya/features/provider_profile/application/provider_profile_providers.dart';
import 'package:sanaya/features/provider_profile/presentation/widgets/review_tile.dart';
import 'package:sanaya/features/reviews/application/pro_reviews_providers.dart';

/// Onglet Avis de l'Espace Pro (`/pro/reviews`, FM-39, issue #236).
///
/// Permet à l'artisan authentifié de consulter les avis clients reçus sur son
/// profil, paginés par curseur (P5), sans avoir à connaître son slug public.
/// Réutilise [providerReviewsProvider] avec le slug résolu depuis
/// [myProviderProfileProvider] (`GET /v1/providers/me`, BE-44).
class ProReviewsScreen extends ConsumerWidget {
  const ProReviewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final t = ref.watch(translationsProvider);
    final profileAsync = ref.watch(myProviderProfileProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(t.reviews.title)),
      body: profileAsync.when(
        loading: () => const _ProReviewsSkeleton(),
        error: (_, _) => _ProReviewsError(
          title: t.reviews.loadError,
          message: t.reviews.errorMessage,
          retryLabel: t.reviews.retry,
          onRetry: () => ref.invalidate(myProviderProfileProvider),
        ),
        data: (profile) {
          if (profile == null) {
            return Center(
              child: EmptyState(
                icon: '⭐',
                title: t.reviews.emptyTitle,
                message: t.reviews.emptyMessage,
              ),
            );
          }
          return _ProReviewsBody(profile: profile);
        },
      ),
    );
  }
}

class _ProReviewsBody extends ConsumerWidget {
  const _ProReviewsBody({required this.profile});

  final ProviderMe profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);
    final reviewsAsync = ref.watch(providerReviewsProvider(profile.slug));

    return reviewsAsync.when(
      loading: () => const _ProReviewsSkeleton(),
      error: (_, _) => _ProReviewsError(
        title: t.reviews.loadError,
        message: t.reviews.errorMessage,
        retryLabel: t.reviews.retry,
        onRetry: () => ref.invalidate(providerReviewsProvider(profile.slug)),
      ),
      data: (state) {
        if (state.reviews.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(providerReviewsProvider(profile.slug));
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: AppSpacing.s2xl),
                EmptyState(
                  icon: '⭐',
                  title: t.reviews.emptyTitle,
                  message: t.reviews.emptyMessage,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(providerReviewsProvider(profile.slug));
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (state.hasMore &&
                  !state.isLoadingMore &&
                  notification.metrics.pixels >=
                      notification.metrics.maxScrollExtent - 200) {
                unawaited(
                  ref
                      .read(providerReviewsProvider(profile.slug).notifier)
                      .loadMore(),
                );
              }
              return false;
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: 1 + state.reviews.length + (state.hasMore ? 1 : 0),
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _ProReviewsHeaderCard(
                    profile: profile,
                    reviewsCount: state.reviews.length,
                  );
                }

                final reviewIndex = index - 1;
                if (reviewIndex >= state.reviews.length) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                      ),
                      child: state.isLoadingMore
                          ? const CircularProgressIndicator.adaptive()
                          : AppButton(
                              label: t.reviews.loadMore,
                              variant: AppButtonVariant.ghost,
                              onPressed: () {
                                unawaited(
                                  ref
                                      .read(
                                        providerReviewsProvider(
                                          profile.slug,
                                        ).notifier,
                                      )
                                      .loadMore(),
                                );
                              },
                            ),
                    ),
                  );
                }

                final review = state.reviews[reviewIndex];
                return _ProReviewItem(review: review);
              },
            ),
          ),
        );
      },
    );
  }
}

/// Carte récapitulative affichée en haut de la liste d'avis pro.
class _ProReviewsHeaderCard extends ConsumerWidget {
  const _ProReviewsHeaderCard({
    required this.profile,
    required this.reviewsCount,
  });

  final ProviderMe profile;
  final int reviewsCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final t = ref.watch(translationsProvider);
    final effectiveCount = profile.ratingCount > 0
        ? profile.ratingCount
        : reviewsCount;
    final ratingValue = profile.ratingAvg.toDouble();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.reviews.ratingSummary,
            style: AppText.small(locale).copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Text(
                formatNumber(profile.ratingAvg, locale),
                style: AppText.h1(locale).copyWith(color: colors.textPrimary),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RatingStars(rating: ratingValue),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    t.reviews.reviewsCount(count: effectiveCount),
                    style: AppText.caption(locale).copyWith(
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Item affichant un avis individuel et le point d'extension pour la réponse.
class _ProReviewItem extends ConsumerWidget {
  const _ProReviewItem({required this.review});

  final V1ProvidersSlugReviewsGet200ResponseItemsInner review;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final t = ref.watch(translationsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ReviewTile(review: review),
        // Point d'extension BE-22b (modèle ReviewReply) :
        // La réponse de l'artisan est hors périmètre v1, indiquée en
        // action informative pour l'artisan.
        Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.xs,
            left: AppSpacing.xs,
            right: AppSpacing.xs,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.reply_outlined, size: 14, color: colors.textMuted),
              const SizedBox(width: AppSpacing.xs),
              Text(
                t.reviews.replyComingSoon,
                style: AppText.caption(locale).copyWith(
                  color: colors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Skeleton de chargement de l'écran des avis reçus.
class _ProReviewsSkeleton extends StatelessWidget {
  const _ProReviewsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 4,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (_, _) => const AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppSkeleton(width: 120),
                AppSkeleton(width: 60, height: 12),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            AppSkeleton(width: 100),
            SizedBox(height: AppSpacing.md),
            AppSkeleton(height: 12),
            SizedBox(height: AppSpacing.xs),
            AppSkeleton(width: 180, height: 12),
          ],
        ),
      ),
    );
  }
}

/// Vue d'erreur avec bouton réessayer.
class _ProReviewsError extends StatelessWidget {
  const _ProReviewsError({
    required this.title,
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String title;
  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ErrorState(
        icon: '⚠️',
        title: title,
        message: message,
        actionLabel: retryLabel,
        onAction: onRetry,
      ),
    );
  }
}
