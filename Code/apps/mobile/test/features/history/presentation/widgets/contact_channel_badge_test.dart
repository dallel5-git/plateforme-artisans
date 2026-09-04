import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/features/contact/domain/contact_channel.dart';
import 'package:sanaya/features/history/presentation/widgets/contact_channel_badge.dart';

import '../../../../core/widgets/widget_test_helpers.dart';

void main() {
  Widget buildTestWidget({
    required ContactChannel channel,
    Locale locale = const Locale('fr'),
  }) {
    return ProviderScope(
      overrides: [localeProvider.overrideWith((ref) => locale)],
      child: themedApp(
        Scaffold(body: ContactChannelBadge(channel: channel)),
        locale: locale,
      ),
    );
  }

  group('ContactChannelBadge', () {
    testWidgets('affiche « Appel » et l’icône téléphone pour le canal phone', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(channel: ContactChannel.phone),
      );
      await tester.pumpAndSettle();

      expect(find.text('Appel'), findsOneWidget);
      expect(find.byIcon(Icons.call), findsOneWidget);
    });

    testWidgets(
      'affiche « WhatsApp » et l’icône chat pour le canal whatsapp',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(channel: ContactChannel.whatsapp),
        );
        await tester.pumpAndSettle();

        expect(find.text('WhatsApp'), findsOneWidget);
        expect(find.byIcon(Icons.chat), findsOneWidget);
      },
    );

    testWidgets('se rend sans exception en arabe (RTL)', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          channel: ContactChannel.phone,
          locale: const Locale('ar'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('اتصال'), findsOneWidget);
    });
  });
}
