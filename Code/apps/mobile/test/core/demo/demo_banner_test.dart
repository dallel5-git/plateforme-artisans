import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/core/demo/demo_banner.dart';
import 'package:sanaya/core/demo/demo_mode_provider.dart';

import '../widgets/widget_test_helpers.dart';

void main() {
  Widget buildBanner({
    required bool isDemo,
    required DemoRole role,
  }) {
    return ProviderScope(
      overrides: [
        demoModeProvider.overrideWith(
          (ref) => DemoModeNotifier(initial: isDemo),
        ),
        demoRoleProvider.overrideWith((ref) => DemoRoleNotifier(role)),
      ],
      child: themedApp(
        const Scaffold(
          body: DemoBanner(),
        ),
      ),
    );
  }

  group('DemoBanner widget test', () {
    testWidgets('renders empty shrink widget when demoMode is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildBanner(isDemo: false, role: DemoRole.client),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.science_outlined), findsNothing);
    });

    testWidgets('renders banner when demoMode is true', (tester) async {
      await tester.pumpWidget(
        buildBanner(isDemo: true, role: DemoRole.client),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.science_outlined), findsOneWidget);
    });
  });
}
