import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/core/connectivity/connectivity_provider.dart';
import 'package:sanaya/core/connectivity/connectivity_service.dart';
import 'package:sanaya/core/widgets/connectivity_banner.dart';

import 'widget_test_helpers.dart';

void main() {
  Widget wrap(ConnectivityService service) {
    return ProviderScope(
      overrides: [
        connectivityServiceProvider.overrideWithValue(service),
      ],
      child: themedApp(const Scaffold(body: ConnectivityBanner())),
    );
  }

  testWidgets(
    'FM-42e — masqué quand isOnline vaut true (rien à afficher)',
    (tester) async {
      final service = ConnectivityService()..isOnline.value = true;

      await tester.pumpWidget(wrap(service));

      expect(find.text('📡'), findsNothing);
    },
  );

  testWidgets(
    'FM-42e — affiche OfflineBanner quand isOnline vaut false',
    (tester) async {
      final service = ConnectivityService()..isOnline.value = false;

      await tester.pumpWidget(wrap(service));

      expect(find.text('📡'), findsOneWidget);
    },
  );

  testWidgets(
    'FM-42e — se met à jour tout seul quand la connectivité change',
    (tester) async {
      final service = ConnectivityService()..isOnline.value = true;

      await tester.pumpWidget(wrap(service));
      expect(find.text('📡'), findsNothing);

      service.isOnline.value = false;
      await tester.pump();
      expect(find.text('📡'), findsOneWidget);

      service.isOnline.value = true;
      await tester.pump();
      expect(find.text('📡'), findsNothing);
    },
  );
}
