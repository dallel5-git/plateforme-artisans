import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/features/auth/presentation/widgets/otp_code_field.dart';

Future<void> _pump(WidgetTester tester, ValueChanged<String> onCompleted) =>
    tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(
          brightness: Brightness.light,
          locale: const Locale('fr'),
        ),
        home: Scaffold(
          body: OtpCodeField(length: 6, onCompleted: onCompleted),
        ),
      ),
    );

void main() {
  testWidgets('saisie case par case déclenche onCompleted au 6e chiffre', (
    tester,
  ) async {
    String? completed;
    await _pump(tester, (code) => completed = code);

    final fields = find.byType(TextField);
    for (var i = 0; i < 6; i++) {
      await tester.enterText(fields.at(i), '${i + 1}');
      await tester.pump();
    }

    expect(completed, '123456');
  });

  testWidgets(
    'coller un code entier dans la première case le distribue et '
    'déclenche onCompleted',
    (tester) async {
      String? completed;
      await _pump(tester, (code) => completed = code);

      await tester.enterText(find.byType(TextField).first, '123456');
      await tester.pump();

      expect(completed, '123456');
    },
  );

  testWidgets(
    "coller un code partiel à partir d'une case du milieu distribue à "
    'partir de cette case',
    (tester) async {
      String? completed;
      await _pump(tester, (code) => completed = code);

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), '1');
      await tester.pump();
      await tester.enterText(fields.at(1), '2');
      await tester.pump();
      // Collage de "3456" à partir de la 3e case → complète le code.
      await tester.enterText(fields.at(2), '3456');
      await tester.pump();

      expect(completed, '123456');
    },
  );

  testWidgets('onCompleted n’est pas appelé tant que le code est incomplet', (
    tester,
  ) async {
    var callCount = 0;
    await _pump(tester, (_) => callCount++);

    await tester.enterText(find.byType(TextField).at(0), '1');
    await tester.pump();
    await tester.enterText(find.byType(TextField).at(1), '2');
    await tester.pump();

    expect(callCount, 0);
  });
}
