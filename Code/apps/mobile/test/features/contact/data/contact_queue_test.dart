import 'package:flutter_test/flutter_test.dart';
import 'package:sanaya/features/contact/data/contact_queue.dart';
import 'package:sanaya/features/contact/domain/contact_channel.dart';
import 'package:sanaya/features/contact/domain/pending_contact.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferencesContactQueue queue;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    queue = SharedPreferencesContactQueue();
  });

  test("pending() est vide tant que rien n'a été mis en file", () async {
    expect(await queue.pending(), isEmpty);
  });

  test("enqueue() puis pending() font l'aller-retour", () async {
    final contact = PendingContact(
      providerId: 'p1',
      channel: ContactChannel.phone,
      at: DateTime(2026, 8, 20, 10, 30),
      categoryId: 'cat-1',
      sourceScreen: 'profile',
      locale: 'ar',
    );

    await queue.enqueue(contact);

    expect(await queue.pending(), [contact]);
  });

  test("plusieurs contacts en file gardent leur ordre d'ajout", () async {
    final first = PendingContact(
      providerId: 'p1',
      channel: ContactChannel.phone,
      at: DateTime(2026, 8, 20),
    );
    final second = PendingContact(
      providerId: 'p2',
      channel: ContactChannel.whatsapp,
      at: DateTime(2026, 8, 21),
    );

    await queue.enqueue(first);
    await queue.enqueue(second);

    expect(await queue.pending(), [first, second]);
  });

  test('remove() retire uniquement le contact visé', () async {
    final first = PendingContact(
      providerId: 'p1',
      channel: ContactChannel.phone,
      at: DateTime(2026, 8, 20),
    );
    final second = PendingContact(
      providerId: 'p2',
      channel: ContactChannel.whatsapp,
      at: DateTime(2026, 8, 21),
    );
    await queue.enqueue(first);
    await queue.enqueue(second);

    await queue.remove(first);

    expect(await queue.pending(), [second]);
  });

  test('survit à une nouvelle instance (persistance disque réelle)', () async {
    // 🔒 NON-RÉGRESSION — P9 : la file doit survivre à un redémarrage de
    // l'app, pas seulement à la durée de vie de l'objet en mémoire.
    final contact = PendingContact(
      providerId: 'p1',
      channel: ContactChannel.phone,
      at: DateTime(2026, 8, 20),
    );
    await queue.enqueue(contact);

    final reloaded = SharedPreferencesContactQueue();

    expect(await reloaded.pending(), [contact]);
  });
}
