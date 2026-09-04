import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/widgets/app_skeleton.dart';
import 'package:sanaya/features/provider_profile/presentation/widgets/provider_gallery.dart';

Widget _wrap(
  Widget child, {
  Locale locale = const Locale('fr'),
  Brightness brightness = Brightness.light,
}) {
  return MaterialApp(
    theme: buildTheme(brightness: brightness, locale: locale),
    home: Scaffold(body: child),
  );
}

V1ProvidersSlugGet200ResponseGalleryInner _fakeGalleryItem(String id) {
  return V1ProvidersSlugGet200ResponseGalleryInner(
    (b) => b
      ..id = id
      ..url = 'https://example.com/$id.jpg'
      ..width = 800
      ..height = 600
      ..blurhash = ''
      ..caption = ''
      ..category = V1ProvidersSlugGet200ResponseCoverageAreasInnerDelegation(
        (c) => c
          ..slug = 'exterieur'
          ..nameFr = 'Extérieur'
          ..nameAr = 'خارجي',
      ).toBuilder(),
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

  testWidgets(
    'FM-18a — le pager (pastilles + fond) utilise colors.scrim/onScrim du '
    'thème, jamais Colors.black54/white/white54 littéraux',
    (tester) async {
      final gallery = [_fakeGalleryItem('1'), _fakeGalleryItem('2')];

      await tester.pumpWidget(
        _wrap(
          ProviderGallery(gallery: gallery),
          brightness: Brightness.dark,
        ),
      );
      await tester.pump();

      final decorations = tester
          .widgetList<Container>(find.byType(Container))
          .map((c) => c.decoration)
          .whereType<BoxDecoration>()
          .toList();

      final pillDecoration = decorations.firstWhere(
        (d) => d.borderRadius == const BorderRadius.all(AppRadius.pill),
      );
      expect(pillDecoration.color, AppColors.dark.scrim);

      final dotColors = decorations
          .where((d) => d.shape == BoxShape.circle)
          .map((d) => d.color)
          .toList();
      expect(dotColors, contains(AppColors.dark.onScrim));
      expect(
        dotColors,
        contains(AppColors.dark.onScrim.withValues(alpha: 0.54)),
      );
    },
  );

  testWidgets(
    'FM-29b — le chargement d une photo affiche AppSkeleton, jamais un '
    'CircularProgressIndicator plein-cadre',
    (tester) async {
      final gallery = [_fakeGalleryItem('1')];

      await tester.pumpWidget(_wrap(ProviderGallery(gallery: gallery)));
      await tester.pump();

      expect(find.byType(AppSkeleton), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );
}
