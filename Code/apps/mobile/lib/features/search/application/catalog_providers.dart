import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/search/data/catalog_repository.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>(
  (ref) => CatalogRepository(ref.watch(defaultApiProvider)),
);

/// Catégories (BE-14b) — état serveur géré par `FutureProvider` :
/// loading/error/data gratuits, aucun `setState` (règle mobile CLAUDE.md #5).
final categoriesProvider = FutureProvider<List<CategoryTreeNode>>(
  (ref) => ref.watch(catalogRepositoryProvider).fetchCategories(),
);

/// Gouvernorats (BE-14c), triés par `sortOrder`.
final governoratesProvider = FutureProvider<List<Governorate>>(
  (ref) => ref.watch(catalogRepositoryProvider).fetchGovernorates(),
);

/// Gouvernorat sélectionné par le client. Valeur initiale réelle injectée
/// via `overrideWith` dans `main()` (préférence persistée, cf.
/// `governorate_persistence.dart`) — même pattern que `localeProvider`
/// (lib/app/providers.dart). `null` tant qu'aucun choix n'a été mémorisé.
final selectedGovernorateIdProvider = StateProvider<String?>((ref) => null);
