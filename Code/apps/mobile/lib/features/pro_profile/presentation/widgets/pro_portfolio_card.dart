import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_badge.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/app_card.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';
import 'package:sanaya/features/onboarding/domain/onboarding_plan_limits.dart';

/// Carte affichant la galerie et les réalisations de l'artisan (MOB-021).
class ProPortfolioCard extends ConsumerWidget {
  const ProPortfolioCard({
    required this.profile,
    required this.onManagePortfolio,
    super.key,
  });

  final ProviderMe profile;
  final VoidCallback onManagePortfolio;

  BuiltList<V1ProvidersMePost200ResponseProviderPortfolioInner> get _portfolio {
    try {
      return profile.portfolio;
    } on Object catch (_) {
      return BuiltList();
    }
  }

  String _formatQuota(String template, int count, int max) {
    return template.replaceAll('{count}', '$count').replaceAll('{max}', '$max');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final portfolio = _portfolio;
    final count = portfolio.length;
    final quotaText = _formatQuota(
      t.proProfile.portfolioQuota,
      count,
      freePlanMaxPortfolioItems,
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.accentSubtle,
                  borderRadius: const BorderRadius.all(AppRadius.md),
                ),
                child: Icon(
                  Icons.photo_library_rounded,
                  color: colors.accent,
                  size: AppIconSize.md,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.proProfile.portfolioSection,
                      style: AppText.bodyStrong(locale).copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t.proProfile.portfolioDesc,
                      style: AppText.caption(locale).copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              AppBadge(
                label: quotaText,
                variant: count >= freePlanMaxPortfolioItems
                    ? AppBadgeVariant.danger
                    : AppBadgeVariant.neutral,
                bordered: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (portfolio.isEmpty)
            Text(
              t.proProfile.portfolioEmpty,
              style: AppText.body(locale).copyWith(
                color: colors.textSecondary,
              ),
            )
          else
            SizedBox(
              height: 64,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: portfolio.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, index) {
                  return Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: colors.surfaceSunken,
                      borderRadius: const BorderRadius.all(AppRadius.sm),
                      border: Border.all(color: colors.border),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.image_outlined,
                        color: colors.textSecondary,
                        size: 28,
                      ),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: t.proProfile.portfolioAddPhoto,
            variant: AppButtonVariant.secondary,
            icon: const Icon(Icons.add_a_photo_outlined, size: AppIconSize.sm),
            onPressed: onManagePortfolio,
          ),
        ],
      ),
    );
  }
}
