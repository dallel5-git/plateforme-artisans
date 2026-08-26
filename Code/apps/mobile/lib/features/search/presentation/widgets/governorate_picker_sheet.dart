import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/features/search/application/catalog_providers.dart';

/// Ouvre le sélecteur de gouvernorat en feuille modale. La sélection met à
/// jour [selectedGovernorateIdProvider] ; la persistance elle-même est
/// câblée au niveau de `SanayaApp` (lib/main.dart), même patron que la
/// locale (FM-03b).
Future<void> showGovernoratePicker(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _GovernoratePickerSheet(),
  );
}

class _GovernoratePickerSheet extends ConsumerWidget {
  const _GovernoratePickerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);
    final locale = Localizations.localeOf(context);
    final governoratesAsync = ref.watch(governoratesProvider);
    final colors = context.colors;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: governoratesAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stackTrace) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                t.search.locationError,
                style: AppText.body(
                  locale,
                ).copyWith(color: colors.textSecondary),
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
                  style: AppText.body(
                    locale,
                  ).copyWith(color: colors.textPrimary),
                ),
                onTap: () {
                  ref.read(selectedGovernorateIdProvider.notifier).state =
                      governorate.id;
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
