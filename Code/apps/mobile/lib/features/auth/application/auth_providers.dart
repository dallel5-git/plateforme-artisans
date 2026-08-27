import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/features/auth/data/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(authApiProvider)),
);

/// Action de déconnexion : révoque la session serveur et nettoie l'état.
final logoutProvider = Provider<Future<void> Function({String? refreshToken})>(
  (ref) {
    final repository = ref.watch(authRepositoryProvider);
    return ({String? refreshToken}) async {
      await repository.logout(refreshToken: refreshToken);
    };
  },
);
