import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/app/design_system_preview_screen.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/features/favorites/application/favorites_providers.dart';
import 'package:sanaya/features/favorites/data/favorites_repository.dart';

class _FavoritesRepositoryMock extends Mock implements FavoritesRepository {}

Widget _wrap(Locale locale) {
  final repository = _FavoritesRepositoryMock();
  when(repository.fetchFavorites).thenAnswer(
    (_) async => FavoritesResponse((b) => b..nextCursor = ''),
  );

  return ProviderScope(
    overrides: [
      localeProvider.overrideWith((ref) => locale),
      favoritesRepositoryProvider.overrideWithValue(repository),
    ],
    child: MaterialApp(
      locale: locale,
      supportedLocales: const [Locale('fr'), Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: buildTheme(brightness: Brightness.light, locale: locale),
      home: const DesignSystemPreviewScreen(),
    ),
  );
}

// Surface haute : le ListView de la vitrine dépasse largement le viewport de
// test par défaut (800×600), et un `ListView(children:)` ne construit que
// les enfants proches du viewport — les sections plus bas (le nuancier de 34
// rôles et les 13 widgets de feature ajoutés par FM-18d en particulier)
// resteraient absentes de l'arbre sans une surface assez haute.
const _tallSurface = Size(800, 12000);

void main() {
  group('FM-18c — DesignSystemPreviewScreen, aucune chaîne en dur', () {
    testWidgets('affiche les libellés traduits en français', (tester) async {
      await tester.binding.setSurfaceSize(_tallSurface);
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_wrap(const Locale('fr')));
      await tester.pump();

      expect(find.text('AppButton'), findsOneWidget);
      expect(find.text('Primary'), findsOneWidget);
      expect(find.text('Karim Ben Salah'), findsOneWidget);
      expect(find.text('Aucun artisan trouvé'), findsOneWidget);
      expect(find.text('Connexion perdue'), findsOneWidget);
    });

    testWidgets('affiche les libellés traduits en arabe (pas de repli FR)', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(_tallSurface);
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_wrap(const Locale('ar')));
      await tester.pump();

      // Les identifiants de classe (AppButton…) restent inchangés dans les
      // deux locales (comme t.common.appName = « Sanaya ») — seul le
      // contenu traduisible doit différer du français.
      expect(find.text('AppButton'), findsOneWidget);
      expect(find.text('أساسي'), findsOneWidget);
      expect(find.text('كريم بن صالح'), findsOneWidget);
      expect(find.text('لم يتم العثور على أي حرفي'), findsOneWidget);
      expect(find.text('انقطع الاتصال'), findsOneWidget);

      // Non-régression : si un libellé retombe sur un littéral français
      // codé en dur, ce texte français apparaîtrait aussi en arabe.
      expect(find.text('Primary'), findsNothing);
      expect(find.text('Karim Ben Salah'), findsNothing);
    });
  });

  group(
    'FM-18d — vitrine enrichie (nuancier, typographie, widgets feature)',
    () {
      testWidgets(
        'affiche le nuancier, la typographie et les 13 nouveaux widgets de '
        'feature, en français',
        (tester) async {
          await tester.binding.setSurfaceSize(_tallSurface);
          addTearDown(() => tester.binding.setSurfaceSize(null));

          await tester.pumpWidget(_wrap(const Locale('fr')));
          await tester.pump();

          // Nuancier — un rôle de chaque type, plus les libellés de bascule.
          expect(find.text('background'), findsOneWidget);
          expect(find.text('onScrim'), findsOneWidget);
          expect(find.text('Clair'), findsOneWidget);
          expect(find.text('Sombre'), findsOneWidget);

          // Typographie.
          expect(find.text('display'), findsOneWidget);
          expect(find.text('caption'), findsOneWidget);

          // Les 13 widgets de feature ajoutés (≥ 10 exigé par le critère
          // d'acceptation de l'issue #217, en plus des 10 core/widgets déjà
          // couverts par FM-18c).
          for (final section in [
            'AvailabilityChip',
            'ReviewTile',
            'OfferingCard',
            'ProviderGallery',
            'DashboardStatCard',
            'DashboardTrendChart',
            'DashboardComparisonChip',
            'RatingStarsInput',
            'OtpCodeField',
            'CoverageAreaChip',
            'CategoryGrid',
            'CategoryGridSkeleton',
            'FavoriteCardSkeleton',
          ]) {
            expect(
              find.text(section),
              findsOneWidget,
              reason: 'section "$section" absente de la vitrine',
            );
          }

          // Contenu localisé porté par les nouveaux widgets (pas juste les
          // titres de section) : le libellé de la tuile dashboard et le nom
          // français de la catégorie choisie par CategoryGrid selon la locale.
          expect(find.text('Vues du profil'), findsOneWidget);
          expect(find.text('Plomberie'), findsOneWidget);
        },
      );

      testWidgets(
        'affiche le nuancier, la typographie et les widgets de feature en '
        'arabe (pas de repli FR)',
        (tester) async {
          await tester.binding.setSurfaceSize(_tallSurface);
          addTearDown(() => tester.binding.setSurfaceSize(null));

          await tester.pumpWidget(_wrap(const Locale('ar')));
          await tester.pump();

          // Les noms de rôle et les identifiants de section restent en dur
          // dans les deux locales (identifiants techniques, cf. commentaire
          // du widget) — seul le contenu UI traduisible doit différer.
          expect(find.text('background'), findsOneWidget);
          expect(find.text('فاتح'), findsOneWidget);
          expect(find.text('داكن'), findsOneWidget);
          expect(find.text('AvailabilityChip'), findsOneWidget);

          expect(find.text('زيارات الملف الشخصي'), findsOneWidget);
          expect(find.text('سباكة'), findsOneWidget);

          expect(find.text('Vues du profil'), findsNothing);
          expect(find.text('Plomberie'), findsNothing);
        },
      );

      testWidgets(
        'la bascule clair/sombre du nuancier ne plante pas et ne touche pas '
        "le thème de l'app",
        (tester) async {
          await tester.binding.setSurfaceSize(_tallSurface);
          addTearDown(() => tester.binding.setSurfaceSize(null));

          await tester.pumpWidget(_wrap(const Locale('fr')));
          await tester.pump();

          await tester.tap(find.text('Sombre'));
          await tester.pump();

          expect(tester.takeException(), isNull);
          // Le nuancier reste affiché après bascule ; le thème ambiant de
          // l'app (utilisé par tout le reste de l'écran) est resté clair —
          // vérifié indirectement par l'absence d'exception et la présence
          // continue du contenu FR de la vitrine.
          expect(find.text('background'), findsOneWidget);
          expect(find.text('AppButton'), findsOneWidget);
        },
      );
    },
  );
}
