import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/rating_stars.dart';
import 'package:sanaya/core/widgets/verified_badge.dart';
import 'package:sanaya/features/provider_profile/application/provider_profile_providers.dart';
import 'package:sanaya/features/provider_profile/data/provider_profile_repository.dart';
import 'package:sanaya/features/provider_profile/presentation/widgets/availability_chip.dart';
import 'package:sanaya/features/provider_profile/presentation/widgets/coverage_area_chip.dart';
import 'package:sanaya/features/provider_profile/presentation/widgets/offering_card.dart';
import 'package:sanaya/features/provider_profile/presentation/widgets/provider_gallery.dart';
import 'package:sanaya/features/provider_profile/presentation/widgets/review_tile.dart';

/// Écran de profil public de l'artisan (fiche artisan, FM-08).
/// C'est l'écran de décision où le client consulte les détails et avis,
/// et décide d'appeler ou de contacter via WhatsApp (FM-09).
class ProviderProfileScreen extends ConsumerWidget {
  const ProviderProfileScreen({
    required this.slug,
    super.key,
  });

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(providerProfileProvider(slug));
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          profileAsync.valueOrNull?.businessName ?? '',
          style: AppText.h3(locale).copyWith(color: colors.textPrimary),
        ),
      ),
      body: profileAsync.when(
        loading: () => const _ProfileSkeleton(),
        error: (error, _) => _ProfileError(slug: slug),
        data: (profile) => _ProfileContent(slug: slug, profile: profile),
      ),
      bottomNavigationBar: _ContactBar(slug: slug),
    );
  }
}

class _ProfileContent extends ConsumerWidget {
  const _ProfileContent({
    required this.slug,
    required this.profile,
  });

  final String slug;
  final ProviderProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    final t = ref.watch(translationsProvider);
    final reviewsAsync = ref.watch(providerReviewsProvider(slug));

    final baseLocation = isArabic
        ? '${profile.baseDelegation.nameAr}، ${profile.baseGovernorate.nameAr}'
        : '${profile.baseDelegation.nameFr}, ${profile.baseGovernorate.nameFr}';

    final yearsExpText = t.provider.profile.yearsExperience.replaceAll(
      '{n}',
      '${profile.yearsExperience}',
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSpacing.s4xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Galerie photos
          ProviderGallery(gallery: profile.gallery.toList()),

          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. En-tête : nom & badges
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.businessName,
                            style: AppText.h2(locale).copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          if (profile.headline.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              profile.headline,
                              style: AppText.body(locale).copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    AvailabilityChip(status: profile.availabilityStatus),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // Note & Badge vérifié (ADR-002)
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    RatingStars(
                      rating: profile.reviewAggregate.average.toDouble(),
                      reviewCount: profile.reviewAggregate.count,
                    ),
                    if (profile.isVerified) const VerifiedBadge(),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // Localisation de base & Années d'expérience
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: colors.textMuted,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        baseLocation,
                        style: AppText.small(locale).copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                    if (profile.yearsExperience > 0) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Icon(
                        Icons.work_history_outlined,
                        size: 16,
                        color: colors.textMuted,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        yearsExpText,
                        style: AppText.small(locale).copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),

                // Bio
                if (profile.bio.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    profile.bio,
                    style: AppText.body(locale).copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ],

                const SizedBox(height: AppSpacing.xl),

                // 3. Section Prestations & Tarifs
                if (profile.offerings.isNotEmpty) ...[
                  Text(
                    t.provider.profile.offeringsTitle,
                    style: AppText.h3(locale).copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  for (final offering in profile.offerings) ...[
                    OfferingCard(offering: offering),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                ],

                // 4. Section Zones d'intervention
                if (profile.coverageAreas.isNotEmpty) ...[
                  Text(
                    t.provider.profile.coverageTitle,
                    style: AppText.h3(locale).copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      for (final area in profile.coverageAreas)
                        CoverageAreaChip(
                          label: isArabic
                              ? area.delegation.nameAr
                              : area.delegation.nameFr,
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],

                // 5. Section Avis clients
                Text(
                  t.provider.profile.reviewsTitle,
                  style: AppText.h3(locale).copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                reviewsAsync.when(
                  loading: () => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: CircularProgressIndicator.adaptive(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colors.accent,
                        ),
                      ),
                    ),
                  ),
                  error: (_, _) => Text(
                    t.provider.profile.noReviews,
                    style: AppText.body(locale).copyWith(
                      color: colors.textMuted,
                    ),
                  ),
                  data: (reviewsState) {
                    if (reviewsState.reviews.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                        child: Text(
                          t.provider.profile.noReviews,
                          style: AppText.body(locale).copyWith(
                            color: colors.textMuted,
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        for (final review in reviewsState.reviews) ...[
                          ReviewTile(review: review),
                          const SizedBox(height: AppSpacing.sm),
                        ],
                        if (reviewsState.hasMore) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Center(
                            child: AppButton(
                              label: t.provider.profile.loadMoreReviews,
                              variant: AppButtonVariant.ghost,
                              onPressed: reviewsState.isLoadingMore
                                  ? null
                                  : () {
                                      unawaited(
                                        ref
                                            .read(
                                              providerReviewsProvider(
                                                slug,
                                              ).notifier,
                                            )
                                            .loadMore(),
                                      );
                                    },
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Barre fixe basse avec boutons Appeler et WhatsApp (P9 / FM-09).
class _ContactBar extends ConsumerWidget {
  const _ContactBar({required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final t = ref.watch(translationsProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                label: t.provider.profile.callButton,
                icon: const Icon(Icons.phone),
                onPressed: () {
                  // Point d'extension FM-09 (contact flow)
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppButton(
                label: t.provider.profile.whatsappButton,
                variant: AppButtonVariant.whatsapp,
                onPressed: () {
                  // Point d'extension FM-09 (contact flow)
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProviderGallerySkeleton(),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 24,
                  width: 200,
                  decoration: BoxDecoration(
                    color: colors.surfaceSunken,
                    borderRadius: const BorderRadius.all(AppRadius.sm),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  height: 16,
                  width: 140,
                  decoration: BoxDecoration(
                    color: colors.surfaceSunken,
                    borderRadius: const BorderRadius.all(AppRadius.sm),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Container(
                  height: 80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colors.surfaceSunken,
                    borderRadius: const BorderRadius.all(AppRadius.md),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileError extends ConsumerWidget {
  const _ProfileError({required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final t = ref.watch(translationsProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: colors.destructive,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              t.provider.profile.errorLoad,
              style: AppText.body(locale).copyWith(color: colors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: t.provider.profile.retry,
              variant: AppButtonVariant.secondary,
              onPressed: () {
                ref
                  ..invalidate(providerProfileProvider(slug))
                  ..invalidate(providerReviewsProvider(slug));
              },
            ),
          ],
        ),
      ),
    );
  }
}
