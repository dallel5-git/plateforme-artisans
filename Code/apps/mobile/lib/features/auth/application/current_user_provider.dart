import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/features/auth/application/auth_providers.dart';
import 'package:sanaya/features/auth/application/auth_state_provider.dart';

/// Profil de l'utilisateur authentifié (`GET /v1/auth/me`), pour l'en-tête
/// d'identité de l'onglet Profil (FM-32). Se recalcule à chaque changement
/// d'[authStateProvider] (connexion/déconnexion) ; renvoie `null` en
/// l'absence de session — aucun appel réseau n'est fait dans ce cas.
final AutoDisposeFutureProvider<V1AuthMeGet200Response?> currentUserProvider =
    FutureProvider.autoDispose<V1AuthMeGet200Response?>((ref) async {
      final authStatus = await ref.watch(authStateProvider.future);
      if (!authStatus.isAuthenticated) return null;
      return ref.watch(authRepositoryProvider).getCurrentUser();
    });
