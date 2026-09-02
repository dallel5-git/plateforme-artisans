import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/core/theme/app_colors.dart';

import '../../support/wcag_contrast.dart';

/// design-system.html §10 : AA = 4,5:1 pour le texte, 3:1 pour les éléments
/// graphiques (icônes, étoiles…), vérifié en clair *et* en sombre.
const _aaText = 4.5;
const _aaGraphic = 3.0;

void main() {
  void expectAA(String label, double ratio, double minRatio) {
    expect(
      ratio,
      greaterThanOrEqualTo(minRatio),
      reason:
          '$label : ratio calculé ${ratio.toStringAsFixed(2)}:1, '
          'seuil AA requis $minRatio:1',
    );
  }

  group('FM-17b — contraste AA (paires réellement utilisées ou exposées)', () {
    test('rating (étoiles, graphique) sur surface — clair', () {
      expectAA(
        'rating/surface clair',
        contrastRatio(AppColors.light.rating, AppColors.light.surface),
        _aaGraphic,
      );
    });

    test('rating (étoiles, graphique) sur surface — sombre', () {
      expectAA(
        'rating/surface sombre',
        contrastRatio(AppColors.dark.rating, AppColors.dark.surface),
        _aaGraphic,
      );
    });

    test('textMuted (texte) sur background — sombre', () {
      expectAA(
        'textMuted/background sombre',
        contrastRatio(AppColors.dark.textMuted, AppColors.dark.background),
        _aaText,
      );
    });

    test('onAccent (texte) sur accent — clair', () {
      expectAA(
        'onAccent/accent clair',
        contrastRatio(AppColors.light.onAccent, AppColors.light.accent),
        _aaText,
      );
    });

    test('onAccent (texte) sur accent — sombre', () {
      expectAA(
        'onAccent/accent sombre',
        contrastRatio(AppColors.dark.onAccent, AppColors.dark.accent),
        _aaText,
      );
    });

    test(
      'onAccent (texte du bouton WhatsApp, app_button.dart) sur whatsapp '
      '— sombre',
      () {
        expectAA(
          'onAccent/whatsapp sombre',
          contrastRatio(AppColors.dark.onAccent, AppColors.dark.whatsapp),
          _aaText,
        );
      },
    );

    test('onAmber (texte) sur amber — sombre', () {
      expectAA(
        'onAmber/amber sombre',
        contrastRatio(AppColors.dark.onAmber, AppColors.dark.amber),
        _aaText,
      );
    });

    test('onScrim (texte) sur scrim — clair', () {
      expectAA(
        'onScrim/scrim clair',
        contrastRatio(AppColors.light.onScrim, AppColors.light.scrim),
        _aaText,
      );
    });

    test('onScrim (texte) sur scrim — sombre', () {
      expectAA(
        'onScrim/scrim sombre',
        contrastRatio(AppColors.dark.onScrim, AppColors.dark.scrim),
        _aaText,
      );
    });
  });

  group('FM-17b — dette AA connue (`backlog/TODO.md` § FM-17c)', () {
    // Ces ratios sont épinglés à leur valeur mesurée aujourd'hui plutôt que
    // comparés au seuil AA, qu'ils ne respectent pas encore — corriger ces
    // paires touche tokens.json (FM-15/FM-18), hors périmètre de FM-17.
    // Si ce test échoue parce que le ratio a *changé*, tokens.json a bougé :
    // mettre à jour la valeur épinglée ici et la ligne FM-17c de
    // `backlog/TODO.md` (ratio amélioré → clore l'entrée ; dégradé →
    // alerter, régression).
    void expectPinned(String label, double ratio, double pinned) {
      expect(
        ratio,
        closeTo(pinned, 0.02),
        reason:
            '$label : ratio mesuré ${ratio.toStringAsFixed(2)}:1, attendu '
            '≈$pinned:1 (dette AA connue, voir backlog/TODO.md § FM-17c). '
            'Si ce nombre a changé, tokens.json a été modifié : mettre à '
            'jour la valeur épinglée et la ligne backlog associée.',
      );
    }

    test('textMuted/background — clair (sous le seuil texte 4,5:1)', () {
      expectPinned(
        'textMuted/background clair',
        contrastRatio(AppColors.light.textMuted, AppColors.light.background),
        3.83,
      );
    });

    test('textMuted/surface — clair (sous le seuil texte 4,5:1)', () {
      expectPinned(
        'textMuted/surface clair',
        contrastRatio(AppColors.light.textMuted, AppColors.light.surface),
        3.94,
      );
    });

    test('textMuted/surface — sombre (sous le seuil texte 4,5:1)', () {
      expectPinned(
        'textMuted/surface sombre',
        contrastRatio(AppColors.dark.textMuted, AppColors.dark.surface),
        4.44,
      );
    });

    test(
      'onAccent (texte réel du bouton WhatsApp) sur whatsapp — clair '
      '(sous le seuil texte 4,5:1)',
      () {
        expectPinned(
          'onAccent/whatsapp clair',
          contrastRatio(AppColors.light.onAccent, AppColors.light.whatsapp),
          4.14,
        );
      },
    );

    test('onAmber/amber — clair (sous le seuil texte 4,5:1)', () {
      expectPinned(
        'onAmber/amber clair',
        contrastRatio(AppColors.light.onAmber, AppColors.light.amber),
        3.43,
      );
    });

    test(
      'onWhatsapp/whatsapp — sombre (piège : très en dessous du seuil, '
      "mais `onWhatsapp` n'est utilisé par aucun widget aujourd'hui — "
      'app_button.dart utilise `onAccent` sur la variante whatsapp. '
      'Ne pas basculer vers `onWhatsapp` sans corriger tokens.json)',
      () {
        expectPinned(
          'onWhatsapp/whatsapp sombre',
          contrastRatio(AppColors.dark.onWhatsapp, AppColors.dark.whatsapp),
          1.98,
        );
      },
    );
  });
}
