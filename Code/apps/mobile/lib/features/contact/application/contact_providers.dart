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
