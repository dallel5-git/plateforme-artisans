import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

/// Dimension max (plus grand côté) et qualité JPEG appliquées avant tout
/// upload de photo portfolio — valeurs imposées par `apps/mobile/CLAUDE.md`
/// §Réseau dégradé et l'issue #232, jamais à ajuster au cas par cas.
const portfolioImageMaxDimension = 1600;
const portfolioImageQuality = 80;

/// Levée quand la compression échoue (format non supporté, fichier
/// corrompu). Traitée par l'appelant comme une erreur de cette seule photo
/// (FM-35) — jamais un échec global de l'étape.
class ImageCompressionException implements Exception {
  const ImageCompressionException(this.path);

  final String path;

  @override
  String toString() => 'ImageCompressionException($path)';
}

/// Compresse [file] avant upload (P5). Non couvert par les tests unitaires
/// de ce module : `flutter_image_compress` passe par un canal de plateforme,
/// vérifié uniquement sur device (voir checklist PR mobile).
Future<Uint8List> compressPortfolioImage(File file) async {
  final result = await FlutterImageCompress.compressWithFile(
    file.absolute.path,
    minWidth: portfolioImageMaxDimension,
    minHeight: portfolioImageMaxDimension,
    quality: portfolioImageQuality,
  );
  if (result == null) {
    throw ImageCompressionException(file.path);
  }
  return result;
}
