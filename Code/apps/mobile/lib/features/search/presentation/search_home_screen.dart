import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/features/search/application/catalog_providers.dart';
import 'package:sanaya/features/search/data/catalog_repository.dart';
import 'package:sanaya/features/search/presentation/widgets/category_grid.dart';
import 'package:sanaya/features/search/presentation/widgets/category_grid_skeleton.dart';
import 'package:sanaya/features/search/presentation/widgets/governorate_picker_sheet.dart';
import 'package:sanaya/features/search/presentation/widgets/search_home_bar.dart';

/// Écran d'accueil client (FM-06, US-C-01) : recherche + grille de
/// catégories chargée depuis l'API (BE-14), gouvernorat mémorisé entre deux
/// lancements. Route `/client` (lib/app/router.dart).
class SearchHomeScreen extends ConsumerWidget {
  const SearchHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);
    final locale = Localizations.localeOf(context);
    final categoriesAsync = ref.watch(categoriesProvider);
    final governoratesAsync = ref.watch(governoratesProvider);
    final selectedGovernorateId = ref.watch(selectedGovernorateIdProvider);

    final locationLabel = governoratesAsync.maybeWhen(
      data: (governorates) => _labelFor(
        governorates,
        selectedGovernorateId,
        locale,
        t.search.locationPlaceholder,
      ),
      orElse: () => t.search.locationPlaceholder,
    );

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SearchHomeBar(
                t: t,
                locationLabel: locationLabel,
                onLocationTap: () => showGovernoratePicker(context),
                // TODO(FM-07): brancher la recherche réelle (résultats) —
                // dépend de BE-16, non livré au moment de FM-06.
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                t.search.categoriesTitle,
                style: AppText.h3(
                  locale,
                ).copyWith(color: context.colors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.md),
              categoriesAsync.when(
                loading: () => const CategoryGridSkeleton(),
                error: (error, stackTrace) => _CategoriesError(
                  t: t,
                  onRetry: () => ref.invalidate(categoriesProvider),
                ),
                data: (categories) => categories.isEmpty
                    ? _CategoriesEmpty(t: t)
                    : CategoryGrid(
                        categories: categories,
                        // TODO(FM-07): naviguer vers les résultats filtrés
                        // par catégorie — dépend de BE-16, non livré.
                        onTap: (_) {},
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _labelFor(
  List<Governorate> governorates,
  String? selectedId,
  Locale locale,
  String placeholder,
) {
  if (selectedId == null) return placeholder;
  for (final governorate in governorates) {
    if (governorate.id == selectedId) {
      return locale.languageCode == 'ar'
          ? governorate.nameAr
          : governorate.nameFr;
    }
  }
  return placeholder;
}

class _CategoriesError extends StatelessWidget {
  const _CategoriesError({required this.t, required this.onRetry});

  final Translations t;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Column(
          children: [
            Text(
              t.search.categoriesError,
              style: AppText.body(
                locale,
              ).copyWith(color: context.colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: t.search.retry,
              variant: AppButtonVariant.secondary,
              size: AppButtonSize.small,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoriesEmpty extends StatelessWidget {
  const _CategoriesEmpty({required this.t});

  final Translations t;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Text(
        t.search.categoriesEmpty,
        style: AppText.body(
          locale,
        ).copyWith(color: context.colors.textSecondary),
        textAlign: TextAlign.center,
      ),
    );
  }
}
