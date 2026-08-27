import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/features/provider_profile/presentation/widgets/provider_gallery.dart';

Widget _wrap(Widget child, {Locale locale = const Locale('fr')}) {
  return MaterialApp(
    theme: buildTheme(brightness: Brightness.light, locale: locale),
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('ProviderGallery vide affiche une icône de remplacement', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const ProviderGallery(gallery: [])));

    expect(find.byIcon(Icons.photo_outlined), findsOneWidget);
  });

  testWidgets('ProviderGallerySkeleton a une hauteur fixe de 220 px', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const ProviderGallerySkeleton()));

    final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
    expect(sizedBox.height, 220.0);
  });
}
