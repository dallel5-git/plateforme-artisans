import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/features/favorites/presentation/widgets/favorite_card_skeleton.dart';

import '../../../../core/widgets/widget_test_helpers.dart';

void main() {
  testWidgets('FavoriteCardSkeleton se rend sans exception', (tester) async {
    await tester.pumpWidget(
      themedApp(
        const Scaffold(
          body: FavoriteCardSkeleton(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FavoriteCardSkeleton), findsOneWidget);
  });
}
