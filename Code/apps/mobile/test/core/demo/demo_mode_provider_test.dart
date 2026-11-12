import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/core/demo/demo_mode_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('DemoModeProvider & Notifiers', () {
    test('readInitialDemoMode returns false by default', () async {
      SharedPreferences.setMockInitialValues({});
      expect(await readInitialDemoMode(), isFalse);
    });

    test('readInitialDemoMode reads persisted value', () async {
      SharedPreferences.setMockInitialValues({'sanaya.demo_mode': true});
      expect(await readInitialDemoMode(), isTrue);
    });

    test('persistDemoMode saves value', () async {
      SharedPreferences.setMockInitialValues({});
      await persistDemoMode(enabled: true);
      expect(await readInitialDemoMode(), isTrue);
    });

    test('readInitialDemoRole returns client by default', () async {
      SharedPreferences.setMockInitialValues({});
      expect(await readInitialDemoRole(), DemoRole.client);
    });

    test('readInitialDemoRole reads provider and guest', () async {
      SharedPreferences.setMockInitialValues({'sanaya.demo_role': 'provider'});
      expect(await readInitialDemoRole(), DemoRole.provider);

      SharedPreferences.setMockInitialValues({'sanaya.demo_role': 'guest'});
      expect(await readInitialDemoRole(), DemoRole.guest);
    });

    test('persistDemoRole saves role', () async {
      SharedPreferences.setMockInitialValues({});
      await persistDemoRole(DemoRole.provider);
      expect(await readInitialDemoRole(), DemoRole.provider);
    });

    test('DemoModeNotifier toggle & setEnabled', () async {
      SharedPreferences.setMockInitialValues({});
      final notifier = DemoModeNotifier();
      expect(notifier.state, isFalse);

      await notifier.toggle();
      expect(notifier.state, isTrue);

      await notifier.setEnabled(enabled: false);
      expect(notifier.state, isFalse);

      // no-op if same
      await notifier.setEnabled(enabled: false);
      expect(notifier.state, isFalse);
    });

    test('DemoRoleNotifier setRole & toggleRole', () async {
      SharedPreferences.setMockInitialValues({});
      final notifier = DemoRoleNotifier();
      expect(notifier.state, DemoRole.client);

      await notifier.setRole(DemoRole.provider);
      expect(notifier.state, DemoRole.provider);

      // cycle: provider -> guest -> client -> provider
      await notifier.toggleRole();
      expect(notifier.state, DemoRole.guest);

      await notifier.toggleRole();
      expect(notifier.state, DemoRole.client);

      await notifier.toggleRole();
      expect(notifier.state, DemoRole.provider);
    });
  });
}
