import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/app_skeleton.dart';
import 'package:sanaya/core/widgets/error_state.dart';
import 'package:sanaya/features/onboarding/domain/onboarding_plan_limits.dart';
import 'package:sanaya/features/onboarding/presentation/widgets/onboarding_selectable_option_card.dart';
import 'package:sanaya/features/search/application/catalog_providers.dart';

/// Sélection courante : id de catégorie -> `isPrimary`. Une seule entrée à
/// `true`, imposé par [OnboardingCategoriesStep] elle-même (le serveur exige
/// exactement un `isPrimary: true`, cf. `providers.ts`).
class OnboardingCategoriesStep extends ConsumerStatefulWidget {
  const OnboardingCategoriesStep({
    required this.initialSelection,
    required this.isSaving,
    required this.errorMessage,
    required this.onSubmit,
    super.key,
  });

  final Map<String, bool> initialSelection;
  final bool isSaving;
  final String? errorMessage;
  final ValueChanged<Map<String, bool>> onSubmit;

  @override
  ConsumerState<OnboardingCategoriesStep> createState() =>
      _OnboardingCategoriesStepState();
}

class _OnboardingCategoriesStepState
    extends ConsumerState<OnboardingCategoriesStep> {
  late Map<String, bool> _selection;

  @override
  void initState() {
    super.initState();
    _selection = Map.of(widget.initialSelection);
  }

  void _toggle(String categoryId) {
    setState(() {
      if (_selection.containsKey(categoryId)) {
        _selection.remove(categoryId);
        return;
      }
      if (_selection.length >= freePlanMaxCategories) return;
      final isFirst = _selection.isEmpty;
      _selection[categoryId] = isFirst;
    });
  }

  void _setPrimary(String categoryId) {
    setState(() {
      _selection = {for (final id in _selection.keys) id: id == categoryId};
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(translationsProvider);
    final locale = Localizations.localeOf(context);
    final colors = context.colors;
    final categoriesAsync = ref.watch(categoriesProvider);
    final canSubmit = _selection.isNotEmpty && !widget.isSaving;

    return categoriesAsync.when(
      loading: () => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppSkeleton(width: 180, height: 24),
            const SizedBox(height: AppSpacing.sm),
            const AppSkeleton(width: 220, height: 14),
            const SizedBox(height: AppSpacing.md),
            for (var i = 0; i < 4; i++) ...[
              const AppSkeleton(height: 52),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ),
      ),
      error: (error, stackTrace) => ErrorState(
        icon: '⚠️',
        title: t.onboarding.categoriesError,
        message: t.onboarding.categoriesErrorMessage,
        actionLabel: t.onboarding.retry,
        onAction: () => ref.invalidate(categoriesProvider),
      ),
      data: (categories) => ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(t.onboarding.categoriesTitle, style: AppText.h3(locale)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            t.onboarding.categoriesCapHint,
            style: AppText.small(locale).copyWith(color: colors.textMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          for (final category in categories)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: OnboardingSelectableOptionCard(
                label: locale.languageCode == 'ar'
                    ? category.nameAr
                    : category.nameFr,
                selected: _selection.containsKey(category.id),
                enabled:
                    _selection.containsKey(category.id) ||
                    _selection.length < freePlanMaxCategories,
                onTap: () => _toggle(category.id),
                isPrimary: _selection[category.id] == true,
                primaryBadgeLabel: t.onboarding.categoriesPrimaryHint,
                onTapPrimaryBadge: () => _setPrimary(category.id),
              ),
            ),
          if (_selection.isEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              t.onboarding.categoriesEmpty,
              style: AppText.small(locale).copyWith(color: colors.textMuted),
            ),
          ],
          if (widget.errorMessage != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              widget.errorMessage!,
              style: AppText.small(locale).copyWith(color: colors.destructive),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: t.onboarding.next,
            onPressed: canSubmit ? () => widget.onSubmit(_selection) : null,
          ),
        ],
      ),
    );
  }
}
