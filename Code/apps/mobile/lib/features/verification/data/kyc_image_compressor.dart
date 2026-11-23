import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

/// Dimension max (plus grand côté) et qualité JPEG appliquées avant tout
/// upload de pièce d'identité (CIN) pour la vérification KYC (MOB-030).
/// Résolution 1080p/1920px optimale pour la lisibilité des caractères
/// arabes/latins tout en réduisant le poids à ~300-500 Ko (P5).
const kycImageMaxDimension = 1920;
const kycImageQuality = 85;

/// Levée quand la compression d'un document d'identité échoue.
class KycCompressionException implements Exception {
  const KycCompressionException(this.path);

  final String path;

  @override
  String toString() => 'KycCompressionException($path)';
}

/// Compresse [file] avant upload vers Cloudflare R2 privé (P5 / Low-Bandwidth).
Future<Uint8List> compressKycImage(File file) async {
  final result = await FlutterImageCompress.compressWithFile(
    file.absolute.path,
    minHeight: kycImageMaxDimension,
    quality: kycImageQuality,
  );
  if (result == null) {
    throw KycCompressionException(file.path);
  }
  return result;
}
