import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/features/onboarding/data/publication_status_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('FM-24a — persistance du statut de publication', () {
    testWidgets(
      "readInitialPublicationStatus() retourne false quand rien n'est "
      'persisté',
      (tester) async {
        SharedPreferences.setMockInitialValues({});

        expect(await readInitialPublicationStatus(), isFalse);
      },
    );

    testWidgets(
      'readInitialPublicationStatus() retourne la préférence persistée '
      '(true)',
      (tester) async {
        SharedPreferences.setMockInitialValues({
          'sanaya.has_published_profile': true,
        });

        expect(await readInitialPublicationStatus(), isTrue);
      },
    );

    testWidgets(
      'persistPublicationStatus() écrit une valeur relue par '
      'readInitialPublicationStatus()',
      (tester) async {
        SharedPreferences.setMockInitialValues({});

        await persistPublicationStatus(hasPublishedProfile: true);

        expect(await readInitialPublicationStatus(), isTrue);
      },
    );
  });
}
