import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanaya/main.dart';

void main() {
  testWidgets('SanayaApp démarre sans exception', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SanayaApp()));

    expect(find.text('Sanaya'), findsOneWidget);
  });
}
