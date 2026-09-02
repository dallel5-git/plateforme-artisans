import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/app_card.dart';
import 'package:sanaya/core/widgets/app_skeleton.dart';
import 'package:sanaya/core/widgets/app_text_field.dart';
import 'package:sanaya/core/widgets/empty_state.dart';
import 'package:sanaya/core/widgets/error_state.dart';
import 'package:sanaya/core/widgets/offline_banner.dart';
import 'package:sanaya/core/widgets/provider_card.dart';
import 'package:sanaya/core/widgets/rating_stars.dart';
import 'package:sanaya/core/widgets/verified_badge.dart';

/// Écran interne de vérification visuelle du design system (FM-04).
/// Outil de développement, pas une fonctionnalité produit — grandit au fil
/// des PRs FM-04a→e pour permettre une capture FR/AR sur device réel de
/// chaque widget au fur et à mesure de sa construction.
class DesignSystemPreviewScreen extends ConsumerWidget {
  const DesignSystemPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(t.common.home.designSystemPreview)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _Section(
            title: t.common.devPreview.sectionAppButton,
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                AppButton(
                  label: t.common.devPreview.buttonPrimary,
                  onPressed: () {},
                ),
                AppButton(
                  label: t.common.devPreview.buttonDisabled,
                  onPressed: null,
                ),
                AppButton(
                  label: t.common.devPreview.buttonSecondary,
                  onPressed: () {},
                  variant: AppButtonVariant.secondary,
                ),
                AppButton(
                  label: t.common.devPreview.buttonGhost,
                  onPressed: () {},
                  variant: AppButtonVariant.ghost,
                ),
                AppButton(
                  label: t.common.devPreview.buttonWhatsapp,
                  onPressed: () {},
                  variant: AppButtonVariant.whatsapp,
                ),
                AppButton(
                  label: t.common.devPreview.buttonDanger,
                  onPressed: () {},
                  variant: AppButtonVariant.danger,
                  size: AppButtonSize.small,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionAppCard,
            child: AppCard(child: Text(t.common.appName)),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionAppTextField,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  label: t.common.devPreview.phoneLabel,
                  hintText: t.common.devPreview.phoneHint,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: t.common.devPreview.otpLabel,
                  errorText: t.common.devPreview.otpError,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionRatingStars,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RatingStars(rating: 4.8, reviewCount: 63),
                SizedBox(height: AppSpacing.sm),
                RatingStars(rating: 4.2, reviewCount: 18),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionVerifiedBadge,
            child: const VerifiedBadge(),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionProviderCard,
            child: Column(
              children: [
                ProviderCard(
                  name: t.common.devPreview.sampleProvider1Name,
                  categoryLabel: t.common.devPreview.sampleProvider1Category,
                  locationLabel: t.common.devPreview.sampleProvider1Location,
                  rating: 4.8,
                  reviewCount: 63,
                  priceLabel: t.common.devPreview.sampleProvider1Price,
                  isVerified: true,
                  onTap: () {},
                ),
                const SizedBox(height: AppSpacing.sm),
                ProviderCard(
                  name: t.common.devPreview.sampleProvider2Name,
                  categoryLabel: t.common.devPreview.sampleProvider2Category,
                  locationLabel: t.common.devPreview.sampleProvider2Location,
                  rating: 4.2,
                  reviewCount: 18,
                  priceLabel: t.common.devPreview.sampleProvider2Price,
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionAppSkeleton,
            child: const Row(
              children: [
                AppSkeleton.circle(size: 48),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSkeleton(width: 140),
                      SizedBox(height: AppSpacing.sm),
                      AppSkeleton(width: 90),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionEmptyState,
            child: EmptyState(
              icon: '🔍',
              title: t.common.devPreview.emptyTitle,
              message: t.common.devPreview.emptyMessage,
              actionLabel: t.common.devPreview.emptyAction,
              onAction: () {},
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionErrorState,
            child: ErrorState(
              icon: '⚠️',
              title: t.common.devPreview.errorTitle,
              message: t.common.devPreview.errorMessage,
              actionLabel: t.common.devPreview.errorAction,
              onAction: () {},
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Section(
            title: t.common.devPreview.sectionOfflineBanner,
            child: OfflineBanner(onDismiss: () {}),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }
}
