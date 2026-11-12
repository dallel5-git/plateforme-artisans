import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/widgets/app_filter_chip.dart';
import 'package:sanaya/features/search/data/search_filters.dart';

/// Barre horizontale défilante des filtres de recherche (FM-28d).
/// Affiche les puces pour Vérifié, Note 4+ et Urgence.
class SearchFilterBar extends ConsumerWidget {
  const SearchFilterBar({
    required this.filters,
    required this.onFiltersChanged,
    super.key,
  });

  final SearchFilters filters;
  final ValueChanged<SearchFilters> onFiltersChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);

    final isVerifiedSelected = filters.isVerified == true;
    final isRatingSelected = filters.minRating == 4;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          AppFilterChip(
            label: t.search.filterVerified,
            selected: isVerifiedSelected,
            onTap: () {
              onFiltersChanged(
                filters.copyWith(
                  isVerified: isVerifiedSelected ? null : true,
                  clearVerified: isVerifiedSelected,
                ),
              );
            },
          ),
          const SizedBox(width: AppSpacing.sm),
          AppFilterChip(
            label: t.search.filterRatingMin,
            selected: isRatingSelected,
            onTap: () {
              onFiltersChanged(
                filters.copyWith(
                  minRating: isRatingSelected ? null : 4,
                  clearMinRating: isRatingSelected,
                ),
              );
            },
          ),
          const SizedBox(width: AppSpacing.sm),
          AppFilterChip(
            label: t.search.filterUrgent,
            selected: false,
          ),
        ],
      ),
    );
  }
}
