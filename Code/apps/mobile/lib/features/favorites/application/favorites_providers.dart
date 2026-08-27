import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/features/favorites/data/favorites_repository.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>(
  (ref) => FavoritesRepository(ref.watch(defaultApiProvider)),
);

/// Notifier pour la liste des favoris de l'utilisateur avec gestion
/// optimiste des suppressions (règle Riverpod CLAUDE.md #5).
class FavoritesListNotifier extends AsyncNotifier<List<FavoriteItem>> {
  @override
  Future<List<FavoriteItem>> build() async {
    final repository = ref.watch(favoritesRepositoryProvider);
    final response = await repository.fetchFavorites();
    return response.items.toList();
  }

  /// Recharge manuellement la liste (utilisé par RefreshIndicator).
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(favoritesRepositoryProvider);
      final response = await repository.fetchFavorites();
      return response.items.toList();
    });
  }

  /// Retire un favori de manière optimiste puis synchronise avec le serveur.
  Future<void> removeFavorite(String providerId) async {
    final previousState = state;
    final currentList = state.valueOrNull ?? [];

    // Mise à jour optimiste
    state = AsyncValue.data(
      currentList.where((item) => item.providerId != providerId).toList(),
    );

    try {
      final repository = ref.read(favoritesRepositoryProvider);
      await repository.removeFavorite(providerId);
    } catch (error, stackTrace) {
      // Annulation en cas d'échec
      state = previousState;
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  /// Ajoute un favori puis rafraîchit la liste.
  Future<void> addFavorite(String providerId) async {
    final repository = ref.read(favoritesRepositoryProvider);
    await repository.addFavorite(providerId);
    await refresh();
  }
}

final favoritesListProvider =
    AsyncNotifierProvider<FavoritesListNotifier, List<FavoriteItem>>(
      FavoritesListNotifier.new,
    );

/// Indique si un prestataire donné est actuellement dans les favoris chargés.
final ProviderFamily<bool, String> isFavoriteProvider =
    Provider.family<bool, String>((ref, providerId) {
      final favoritesAsync = ref.watch(favoritesListProvider);
      return favoritesAsync.maybeWhen(
        data: (items) => items.any((item) => item.providerId == providerId),
        orElse: () => false,
      );
    });
