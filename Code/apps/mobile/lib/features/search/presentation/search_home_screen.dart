import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/empty_state.dart';
import 'package:sanaya/core/widgets/error_state.dart';
import 'package:sanaya/features/search/application/catalog_providers.dart';
import 'package:sanaya/features/search/application/category_resolver.dart';
import 'package:sanaya/features/search/data/catalog_repository.dart';
import 'package:sanaya/features/search/data/search_filters.dart';
import 'package:sanaya/features/search/presentation/widgets/category_grid.dart';
import 'package:sanaya/features/search/presentation/widgets/category_grid_skeleton.dart';
import 'package:sanaya/features/search/presentation/widgets/governorate_picker_sheet.dart';
import 'package:sanaya/features/search/presentation/widgets/search_home_bar.dart';

/// Écran d'accueil client (FM-06, US-C-01) : recherche + grille de
/// catégories chargée depuis l'API (BE-14), gouvernorat mémorisé entre deux
/// lancements. Route `/client` (lib/app/router.dart).
class SearchHomeScreen extends ConsumerStatefulWidget {
  const SearchHomeScreen({super.key});

  @override
  ConsumerState<SearchHomeScreen> createState() => _SearchHomeScreenState();
}

class _SearchHomeScreenState extends ConsumerState<SearchHomeScreen> {
  String _query = '';

  void _submitSearch(
    BuildContext context,
    String query,
    List<CategoryTreeNode> categories,
  ) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final govId = ref.read(selectedGovernorateIdProvider);
    final matchedCategory = CategoryResolver.resolveCategory(
      trimmed,
      categories,
    );

    unawaited(
      context.pushNamed(
        'client-results',
        extra: SearchFilters(
          governorateId: govId ?? 'sousse',
          categorySlug: matchedCategory?.slug,
          query: matchedCategory == null ? trimmed : null,
        ),
      ),
    );
  }

  void _onSuggestionTap(BuildContext context, CategoryTreeNode category) {
    final govId = ref.read(selectedGovernorateIdProvider);
    unawaited(
      context.pushNamed(
        'client-results',
        extra: SearchFilters(
          governorateId: govId ?? 'sousse',
          categorySlug: category.slug,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

    final categories =
        categoriesAsync.valueOrNull ?? const <CategoryTreeNode>[];
    final suggestions = _query.trim().isNotEmpty
        ? CategoryResolver.getSuggestions(_query, categories)
        : const <CategoryTreeNode>[];

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
                suggestions: suggestions,
                onSuggestionTap: (cat) => _onSuggestionTap(context, cat),
                onQueryChanged: (q) => setState(() => _query = q),
                onLocationTap: () => showGovernoratePicker(
                  context,
                  onSelected: (id) =>
                      ref.read(selectedGovernorateIdProvider.notifier).state =
                          id,
                ),
                onQuerySubmitted: (query) =>
                    _submitSearch(context, query, categories),
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
                error: (error, stackTrace) => ErrorState(
                  icon: '⚠️',
                  title: t.search.categoriesErrorTitle,
                  message: t.search.categoriesError,
                  actionLabel: t.search.retry,
                  onAction: () => ref.invalidate(categoriesProvider),
                ),
                data: (categoriesList) => categoriesList.isEmpty
                    ? EmptyState(
                        icon: '🗂️',
                        title: t.search.categoriesEmptyTitle,
                        message: t.search.categoriesEmpty,
                      )
                    : CategoryGrid(
                        categories: categoriesList,
                        onTap: (category) {
                          final govId = ref.read(selectedGovernorateIdProvider);
                          unawaited(
                            context.pushNamed(
                              'client-results',
                              extra: SearchFilters(
                                governorateId: govId ?? 'sousse',
                                categorySlug: category.slug,
                              ),
                            ),
                          );
                        },
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
