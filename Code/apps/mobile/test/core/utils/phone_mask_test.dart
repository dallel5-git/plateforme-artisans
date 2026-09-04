import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/core/utils/phone_mask.dart';

void main() {
  group('maskPhone', () {
    test(
      'masque les chiffres tunisiens entre l’indicatif et les 2 derniers',
      () {
        expect(maskPhone('+21622123456'), '+216 •••••• 56');
      },
    );

    test(
      'numéro sans indicatif : masque tout sauf les 2 derniers chiffres',
      () {
        expect(maskPhone('22123456'), '•••••• 56');
      },
    );

    test('numéro trop court pour être masqué : renvoyé tel quel', () {
      expect(maskPhone('56'), '56');
      expect(maskPhone(''), '');
    });
  });
}
