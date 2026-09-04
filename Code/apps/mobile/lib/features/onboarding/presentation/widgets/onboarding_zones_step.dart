import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/features/onboarding/domain/onboarding_plan_limits.dart';
import 'package:sanaya/features/onboarding/presentation/widgets/onboarding_selectable_option_card.dart';
import 'package:sanaya/features/search/application/catalog_providers.dart';

/// Sélection au niveau gouvernorat uniquement — `delegationId` absent
/// couvre tout le gouvernorat côté API (`providers.ts`). La granularité
/// délégation (nécessiterait `GET /governorates/:id/delegations` par
/// gouvernorat sélectionné) est hors périmètre v1 de cet écran, pas un
/// oubli — voir `backlog/DOING.md`.
class OnboardingZonesStep extends ConsumerStatefulWidget {
  const OnboardingZonesStep({
    required this.initialSelection,
    required this.isSaving,
    required this.errorMessage,
    required this.onSubmit,
    super.key,
  });

  final Set<String> initialSelection;
  final bool isSaving;
  final String? errorMessage;
  final ValueChanged<Set<String>> onSubmit;

  @override
  ConsumerState<OnboardingZonesStep> createState() =>
      _OnboardingZonesStepState();
}

class _OnboardingZonesStepState extends ConsumerState<OnboardingZonesStep> {
  late Set<String> _selection;

  @override
  void initState() {
    super.initState();
    _selection = Set.of(widget.initialSelection);
  }

  void _toggle(String governorateId) {
    setState(() {
      if (!_selection.remove(governorateId)) {
        if (_selection.length >= freePlanMaxGovernorates) return;
        _selection.add(governorateId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(translationsProvider);
    final locale = Localizations.localeOf(context);
    final colors = context.colors;
    final governoratesAsync = ref.watch(governoratesProvider);
    final canSubmit = _selection.isNotEmpty && !widget.isSaving;

    return governoratesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              t.onboarding.zonesError,
              style: AppText.body(locale).copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: t.onboarding.retry,
              variant: AppButtonVariant.secondary,
              onPressed: () => ref.invalidate(governoratesProvider),
            ),
          ],
        ),
      ),
      data: (governorates) => ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(t.onboarding.zonesTitle, style: AppText.h3(locale)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            t.onboarding.zonesCapHint,
            style: AppText.small(locale).copyWith(color: colors.textMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          for (final governorate in governorates)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: OnboardingSelectableOptionCard(
                label: locale.languageCode == 'ar'
                    ? governorate.nameAr
                    : governorate.nameFr,
                selected: _selection.contains(governorate.id),
                enabled:
                    _selection.contains(governorate.id) ||
                    _selection.length < freePlanMaxGovernorates,
                onTap: () => _toggle(governorate.id),
              ),
            ),
          if (_selection.isEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              t.onboarding.zonesEmpty,
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
