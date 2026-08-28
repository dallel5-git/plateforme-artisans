import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Hors ligne = liste vide ou ne contenant que [ConnectivityResult.none].
/// Un résultat non vide peut par ailleurs contenir plusieurs interfaces à la
/// fois (ex. wifi + vpn) — il suffit qu'une seule ne soit pas `none`.
bool isOnlineFromResults(List<ConnectivityResult> results) =>
    results.any((result) => result != ConnectivityResult.none);

/// Détection de connectivité réseau (FM-02f) — expose [isOnline] comme
/// `ValueNotifier` simple, pas un provider Riverpod : ce module reste
/// découplé de la couche présentation, consommé par le bandeau hors ligne
/// (widget fourni par FM-04e) via `ValueListenableBuilder`.
class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;
  final ValueNotifier<bool> isOnline = ValueNotifier<bool>(true);
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Future<void> start() async {
    final initial = await _connectivity.checkConnectivity();
    isOnline.value = isOnlineFromResults(initial);
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      isOnline.value = isOnlineFromResults(results);
    });
  }

  void dispose() {
    unawaited(_subscription?.cancel());
    isOnline.dispose();
  }
}
