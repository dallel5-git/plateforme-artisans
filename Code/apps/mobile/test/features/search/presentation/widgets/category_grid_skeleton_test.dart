import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/theme.dart';
import 'package:sanaya/features/search/presentation/widgets/category_grid_skeleton.dart';

void main() {
  testWidgets('affiche itemCount blocs sans exception', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(
          brightness: Brightness.light,
          locale: const Locale('fr'),
        ),
        home: const Scaffold(body: CategoryGridSkeleton()),
      ),
    );

    expect(find.byType(DecoratedBox), findsNWidgets(6));
    expect(tester.takeException(), isNull);
  });
}
