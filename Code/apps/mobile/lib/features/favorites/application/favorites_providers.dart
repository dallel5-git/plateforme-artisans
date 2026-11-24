import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/features/auth/application/auth_state_provider.dart';
import 'package:sanaya/features/favorites/data/favorites_repository.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>(
  (ref) => FavoritesRepository(ref.watch(defaultApiProvider)),
);

/// Notifier pour la liste des favoris de l'utilisateur avec gestion
/// optimiste des suppressions (règle Riverpod CLAUDE.md #5).
class FavoritesListNotifier extends AsyncNotifier<List<FavoriteItem>> {
  @override
  Future<List<FavoriteItem>> build() async {
    // MOB-007 : renvoie une liste vide immédiate si la session est non
    // authentifiée, évitant tout appel réseau 401 intempestif.
    final authStatus = await ref.watch(authStateProvider.future);
    if (!authStatus.isAuthenticated) {
      return const [];
    }

    final repository = ref.watch(favoritesRepositoryProvider);
    final response = await repository.fetchFavorites();
    return response.items.toList();
  }

  /// Recharge manuellement la liste (utilisé par RefreshIndicator).
  Future<void> refresh() async {
    final authStatus = await ref.read(authStateProvider.future);
    if (!authStatus.isAuthenticated) {
      state = const AsyncData([]);
      return;
    }

    state = const AsyncLoading<List<FavoriteItem>>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      final repository = ref.read(favoritesRepositoryProvider);
      final response = await repository.fetchFavorites();
      return response.items.toList();
    });
  }

  /// Retire un favori de manière optimiste puis synchronise avec le serveur.
  Future<void> removeFavorite(String providerId) async {
    final authStatus = await ref.read(authStateProvider.future);
    if (!authStatus.isAuthenticated) return;

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
    final authStatus = await ref.read(authStateProvider.future);
    if (!authStatus.isAuthenticated) return;

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
      final items = ref.watch(favoritesListProvider).valueOrNull;
      if (items == null) return false;
      return items.any((item) => item.providerId == providerId);
    });
