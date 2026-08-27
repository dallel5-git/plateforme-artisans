import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanaya/features/contact/application/contact_providers.dart';
import 'package:sanaya/features/contact/domain/contact_service.dart';

class _ServiceMock extends Mock implements ContactService {}

void main() {
  test(
    '🔒 contactQueueFlushProvider déclenche flushQueue() au démarrage',
    () async {
      // 🔒 NON-RÉGRESSION — P9 : sans ce provider câblé dans main.dart, un
      // contact mis en file hors ligne attend indéfiniment le prochain tap
      // de l'utilisateur pour être retenté.
      final service = _ServiceMock();
      when(service.flushQueue).thenAnswer((_) async {});

      final container = ProviderContainer(
        overrides: [contactServiceProvider.overrideWithValue(service)],
      );
      addTearDown(container.dispose);

      await container.read(contactQueueFlushProvider.future);

      verify(service.flushQueue).called(1);
    },
  );
}
