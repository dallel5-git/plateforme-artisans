import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_badge.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/app_card.dart';
import 'package:sanaya/core/widgets/app_skeleton.dart';
import 'package:sanaya/features/onboarding/data/onboarding_repository.dart';
import 'package:sanaya/features/pro_profile/application/pro_profile_providers.dart';
import 'package:sanaya/features/pro_profile/data/offerings_repository.dart';

/// Carte affichant les prestations et tarifs indicatifs de l'artisan (MOB-022).
class ProOfferingsCard extends ConsumerWidget {
  const ProOfferingsCard({
    required this.profile,
    required this.onAddOffering,
    required this.onEditOffering,
    required this.onDeleteOffering,
    super.key,
  });

  final ProviderMe profile;
  final VoidCallback onAddOffering;
  final ValueChanged<MyOffering> onEditOffering;
  final ValueChanged<MyOffering> onDeleteOffering;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final offeringsAsync = ref.watch(myOfferingsProvider);

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
                  Icons.price_change_rounded,
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
                      t.proProfile.offeringsSection,
                      style: AppText.bodyStrong(locale).copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t.proProfile.offeringsDesc,
                      style: AppText.caption(locale).copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          offeringsAsync.when(
            loading: () => const Column(
              children: [
                AppSkeleton(height: 56),
                SizedBox(height: AppSpacing.sm),
                AppSkeleton(height: 56),
              ],
            ),
            error: (_, _) => Text(
              t.proProfile.errorMessage,
              style: AppText.body(locale).copyWith(color: colors.destructive),
            ),
            data: (offerings) {
              if (offerings.isEmpty) {
                return Text(
                  t.proProfile.offeringsEmpty,
                  style: AppText.body(locale).copyWith(
                    color: colors.textSecondary,
                  ),
                );
              }
              return Column(
                children: [
                  for (final offering in offerings) ...[
                    _OfferingItemTile(
                      offering: offering,
                      onEdit: () => onEditOffering(offering),
                      onDelete: () => onDeleteOffering(offering),
                    ),
                    if (offering != offerings.last)
                      const SizedBox(height: AppSpacing.sm),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: t.proProfile.offeringsAdd,
            variant: AppButtonVariant.secondary,
            icon: const Icon(Icons.add_rounded, size: AppIconSize.sm),
            onPressed: onAddOffering,
          ),
        ],
      ),
    );
  }
}

class _OfferingItemTile extends ConsumerWidget {
  const _OfferingItemTile({
    required this.offering,
    required this.onEdit,
    required this.onDelete,
  });

  final MyOffering offering;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';

    final title = isArabic && offering.titleAr.isNotEmpty
        ? offering.titleAr
        : offering.titleFr;

    final categoryName = isArabic && offering.category.nameAr.isNotEmpty
        ? offering.category.nameAr
        : offering.category.nameFr;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: colors.surfaceSunken,
        borderRadius: const BorderRadius.all(AppRadius.md),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppText.bodyStrong(locale).copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (categoryName.isNotEmpty)
                      AppBadge(
                        label: categoryName,
                        variant: AppBadgeVariant.neutral,
                        bordered: true,
                      ),
                    Text(
                      offering.displayPrice,
                      style: AppText.caption(locale).copyWith(
                        color: colors.accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (offering.isNegotiable)
                      AppBadge(
                        label: t.proProfile.offeringsNegotiable,
                        variant: AppBadgeVariant.verified,
                      ),
                  ],
                ),
                if (offering.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    offering.description,
                    style: AppText.caption(locale).copyWith(
                      color: colors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: AppIconSize.sm),
            tooltip: t.proProfile.offeringsEdit,
            onPressed: onEdit,
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline_rounded,
              size: AppIconSize.sm,
              color: colors.destructive,
            ),
            tooltip: t.proProfile.offeringsDelete,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
