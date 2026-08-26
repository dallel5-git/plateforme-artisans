import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/features/search/data/governorate_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'readInitialGovernorateId renvoie null si aucun choix mémorisé',
    () async {
      SharedPreferences.setMockInitialValues({});

      expect(await readInitialGovernorateId(), isNull);
    },
  );

  test(
    "persistGovernorateId puis readInitialGovernorateId font l'aller-retour",
    () async {
      // Critère d'acceptation FM-06 : le gouvernorat choisi est mémorisé entre
      // deux lancements.
      SharedPreferences.setMockInitialValues({});

      await persistGovernorateId('gov-sousse');

      expect(await readInitialGovernorateId(), 'gov-sousse');
    },
  );

  test('un nouveau choix remplace le précédent', () async {
    SharedPreferences.setMockInitialValues({
      'sanaya.governorate_id': 'gov-sousse',
    });

    await persistGovernorateId('gov-monastir');

    expect(await readInitialGovernorateId(), 'gov-monastir');
  });
}
