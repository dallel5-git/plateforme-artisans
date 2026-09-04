import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/features/search/data/search_repository.dart';
import 'package:sanaya/features/search/data/search_results_cache.dart';

final searchRepositoryProvider = Provider<SearchRepository>(
  (ref) => SearchRepository(ref.watch(defaultApiProvider)),
);

final searchResultsCacheProvider = Provider<SearchResultsCache>(
  (ref) => SearchResultsCache.withDefaultBox(),
);
