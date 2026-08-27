import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/features/contact/data/contact_queue.dart';
import 'package:sanaya/features/contact/data/url_launcher.dart';

final contactQueueProvider = Provider<ContactQueue>(
  (ref) => SharedPreferencesContactQueue(),
);

final urlLauncherProvider = Provider<UrlLauncher>((ref) => UrlLauncherImpl());
