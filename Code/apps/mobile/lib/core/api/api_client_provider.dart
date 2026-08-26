import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/api/generated/api.dart';

/// Instance partagée du client généré (BE-26 / FM-02b). `Dio` par défaut,
/// sans intercepteur additionnel pour l'instant — FM-02c+ y branchera
/// retry/offline/auth ; ce provider reste le point d'injection unique, seul
/// son contenu changera.
final apiClientProvider = Provider<SanayaApiClient>(
  (ref) => SanayaApiClient(),
);

/// Point d'entrée unique pour `/v1/categories` et `/v1/governorates` (BE-14)
/// — règle mobile CLAUDE.md #1 : aucun `Dio` écrit à la main, tout passe par
/// le client généré.
final defaultApiProvider = Provider<DefaultApi>(
  (ref) => ref.watch(apiClientProvider).getDefaultApi(),
);
