import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/core/api/api_client_provider.dart';
import 'package:sanaya/features/contact/data/contact_queue.dart';
import 'package:sanaya/features/contact/data/url_launcher.dart';
import 'package:sanaya/features/contact/domain/contact_service.dart';

final contactQueueProvider = Provider<ContactQueue>(
  (ref) => SharedPreferencesContactQueue(),
);

final urlLauncherProvider = Provider<UrlLauncher>((ref) => UrlLauncherImpl());

final contactServiceProvider = Provider<ContactService>(
  (ref) => ContactService(
    api: ref.watch(contactEventsApiProvider),
    queue: ref.watch(contactQueueProvider),
    launcher: ref.watch(urlLauncherProvider),
  ),
);

/// Vidage opportuniste de la file au démarrage de l'app (P9 : un contact
/// mis en file hors ligne ne doit pas attendre le prochain tap pour être
/// retenté). `FutureProvider` plutôt qu'un appel direct dans `main()` : la
/// requête a besoin du `Dio` construit via `ProviderScope`, qui n'existe
/// qu'après `runApp`. Lu une seule fois (`ref.watch` sans consommer la
/// valeur) au premier build de `SanayaApp` — voir `main.dart`.
final contactQueueFlushProvider = FutureProvider<void>(
  (ref) => ref.watch(contactServiceProvider).flushQueue(),
);
