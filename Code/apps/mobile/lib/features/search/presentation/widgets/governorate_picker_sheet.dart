import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_bottom_sheet.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/features/search/application/catalog_providers.dart';

/// Ouvre le sélecteur de gouvernorat en feuille modale — implémentation
/// **unique** dans tout le dépôt (issue FM-41/#238) : sert à la fois le
/// filtre de recherche (`SearchHomeBar`, écrit dans
/// [selectedGovernorateIdProvider]) et l'étape profil de l'onboarding
/// (`OnboardingProfileStep`, écrit dans `ProfileStepValues` via
/// [onSelected]). [onSelected] laisse l'appelant décider où va la valeur ;
/// cette feuille ne connaît que `governoratesProvider`.
Future<void> showGovernoratePicker(
  BuildContext context, {
  required ValueChanged<String> onSelected,
}) {
  final t = ProviderScope.containerOf(context).read(translationsProvider);
  return showAppBottomSheet<void>(
    context,
    title: t.search.governorateLabel,
    builder: (_) => _GovernoratePickerBody(onSelected: onSelected),
  );
}

class _GovernoratePickerBody extends ConsumerWidget {
  const _GovernoratePickerBody({required this.onSelected});

  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);
    final locale = Localizations.localeOf(context);
    final governoratesAsync = ref.watch(governoratesProvider);
    final colors = context.colors;

    return governoratesAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              t.search.locationError,
              style: AppText.body(locale).copyWith(color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: t.search.retry,
              variant: AppButtonVariant.secondary,
              size: AppButtonSize.small,
              onPressed: () => ref.invalidate(governoratesProvider),
            ),
          ],
        ),
      ),
      data: (governorates) => ListView.builder(
        shrinkWrap: true,
        itemCount: governorates.length,
        itemBuilder: (context, index) {
          final governorate = governorates[index];
          final label = locale.languageCode == 'ar'
              ? governorate.nameAr
              : governorate.nameFr;
          return ListTile(
            title: Text(
              label,
              style: AppText.body(locale).copyWith(color: colors.textPrimary),
            ),
            onTap: () {
              onSelected(governorate.id);
              Navigator.of(context).pop();
            },
          );
        },
      ),
    );
  }
}
