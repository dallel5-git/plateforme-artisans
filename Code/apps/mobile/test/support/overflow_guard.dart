import 'package:flutter/foundation.dart';

/// Exécute [body] en capturant les erreurs remontées à `FlutterError.onError`
/// — notamment les `RenderFlex overflowed`, qui ne font pas nécessairement
/// échouer un `testWidgets` sans ce hook (elles sont rendues en widget
/// d'erreur strié, pas relancées comme exception attrapable par `pump`).
Future<List<FlutterErrorDetails>> captureFlutterErrors(
  Future<void> Function() body,
) async {
  final errors = <FlutterErrorDetails>[];
  final previousOnError = FlutterError.onError;
  FlutterError.onError = errors.add;
  try {
    await body();
  } finally {
    FlutterError.onError = previousOnError;
  }
  return errors;
}
