import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/connectivity/connectivity_service.dart';

/// Instance partagée — un seul abonnement au flux de connectivité pour toute
/// l'app (même pattern que `authTokenStoreProvider`/`apiClientProvider`,
/// api_client_provider.dart). `start()` est lancé dès la première lecture du
/// provider. `isOnline` (`ValueNotifier<bool>`) est destiné à être consommé
/// via `ValueListenableBuilder` là où un bandeau hors ligne doit s'afficher
/// — widget fourni par FM-04e (design system), câblé dans une PR de suivi
/// une fois livré (même point d'extension que `ContactButtons`/FM-08→FM-09).
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  unawaited(service.start());
  ref.onDispose(service.dispose);
  return service;
});
