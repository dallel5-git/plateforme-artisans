import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/connectivity_banner.dart';
import 'package:sanaya/core/widgets/empty_state.dart';
import 'package:sanaya/core/widgets/error_state.dart';
import 'package:sanaya/core/widgets/provider_card.dart';
import 'package:sanaya/features/search/application/catalog_providers.dart';
import 'package:sanaya/features/search/application/search_providers.dart';
import 'package:sanaya/features/search/data/search_filters.dart';
import 'package:sanaya/features/search/data/search_repository.dart';
import 'package:sanaya/features/search/presentation/widgets/search_filter_bar.dart';
import 'package:sanaya/features/search/presentation/widgets/search_results_skeleton.dart';

/// Écran des résultats de recherche paginés (FM-28d, US-C-01/US-C-03).
/// Affiche la liste d'artisans correspondant aux filtres actifs,
/// avec infinite scroll par curseur et secours cache disque (P5).
class SearchResultsScreen extends ConsumerStatefulWidget {
  const SearchResultsScreen({
    required this.initialFilters,
    super.key,
  });

  final SearchFilters initialFilters;

  @override
  ConsumerState<SearchResultsScreen> createState() =>
      _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  late SearchFilters _currentFilters;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _currentFilters = widget.initialFilters;
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= 200) {
      unawaited(
        ref.read(searchResultsProvider(_currentFilters).notifier).loadMore(),
      );
    }
  }

  void _onFiltersChanged(SearchFilters newFilters) {
    setState(() {
      _currentFilters = newFilters;
    });
  }

  void _resetFilters() {
    setState(() {
      _currentFilters = SearchFilters(
        governorateId: widget.initialFilters.governorateId,
        categorySlug: widget.initialFilters.categorySlug,
        query: widget.initialFilters.query,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(translationsProvider);
    final locale = Localizations.localeOf(context);
    final colors = context.colors;

    final resultsAsync = ref.watch(searchResultsProvider(_currentFilters));
    final title = _resolveTitle(ref, _currentFilters, t, locale);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(title, style: AppText.h3(locale)),
        backgroundColor: colors.surface,
        elevation: 0,
      ),
      body: Column(
        children: [
          const ConnectivityBanner(),
          SearchFilterBar(
            filters: _currentFilters,
            onFiltersChanged: _onFiltersChanged,
          ),
          const Divider(height: 1),
          Expanded(
            child: resultsAsync.when(
              loading: () => const SearchResultsSkeleton(),
              error: (error, _) => Center(
                child: ErrorState(
                  icon: '⚠️',
                  title: t.search.loadErrorTitle,
                  message: t.search.loadError,
                  actionLabel: t.search.retry,
                  onAction: () => ref
                      .read(searchResultsProvider(_currentFilters).notifier)
                      .refresh(),
                ),
              ),
              data: (state) {
                if (state.items.isEmpty) {
                  return Center(
                    child: EmptyState(
                      icon: '🔍',
                      title: t.search.emptyTitle,
                      message: t.search.emptySubtitle,
                      actionLabel: t.search.resetFilters,
                      onAction: _resetFilters,
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => ref
                      .read(searchResultsProvider(_currentFilters).notifier)
                      .refresh(),
                  child: ListView.separated(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount:
                        state.items.length + (state.isLoadingMore ? 1 : 0),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      if (index == state.items.length) {
                        return const Center(
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: AppSpacing.md),
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        );
                      }

                      final item = state.items[index];
                      return _SearchResultCard(
                        item: item,
                        locale: locale,
                        onTap: () {
                          unawaited(
                            context.pushNamed(
                              'provider-profile',
                              pathParameters: {'slug': item.slug},
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _resolveTitle(
    WidgetRef ref,
    SearchFilters filters,
    Translations t,
    Locale locale,
  ) {
    if (filters.categorySlug != null) {
      final categories = ref.watch(categoriesProvider).valueOrNull ?? [];
      for (final category in categories) {
        if (category.slug == filters.categorySlug) {
          return locale.languageCode == 'ar'
              ? category.nameAr
              : category.nameFr;
        }
      }
    }
    if (filters.query != null && filters.query!.trim().isNotEmpty) {
      return filters.query!.trim();
    }
    return t.search.resultsTitle;
  }
}

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({
    required this.item,
    required this.locale,
    required this.onTap,
  });

  final SearchResultItem item;
  final Locale locale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final categoryLabel = item.categories.isNotEmpty
        ? (locale.languageCode == 'ar'
            ? item.categories.first.nameAr
            : item.categories.first.nameFr)
        : '';

    return ProviderCard(
      providerId: item.id,
      name: item.businessName,
      categoryLabel: categoryLabel,
      locationLabel: item.headline,
      rating: item.ratingAvg.toDouble(),
      reviewCount: item.ratingCount,
      isVerified: item.isVerified,
      onTap: onTap,
    );
  }
}
