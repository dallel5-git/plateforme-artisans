import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/features/contact/application/contact_providers.dart';
import 'package:sanaya/features/contact/domain/contact_channel.dart';

/// Boutons « Appeler » / « WhatsApp » d'une fiche prestataire. Déclenche
/// `ContactService.contact()` au tap — poste le `ContactEvent` (P9) avant
/// d'ouvrir le lien natif, cf. « Deep links natifs » (`apps/mobile/CLAUDE.md`).
/// [AppButton] reste volontairement muet sur ce point (voir sa doc) : c'est
/// ici, à l'écran appelant, que la règle P9 est respectée.
class ContactButtons extends ConsumerWidget {
  const ContactButtons({
    required this.providerId,
    super.key,
    this.categoryId,
    this.sourceScreen,
    this.fallbackPhone,
  });

  final String providerId;
  final String? categoryId;
  final String? sourceScreen;

  /// Numéro déjà révélé plus tôt dans la session pour ce prestataire — seul
  /// repli possible si le POST échoue hors ligne (P8 : aucun numéro n'est
  /// structurellement connu avant la réponse du serveur).
  final String? fallbackPhone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);
    final locale = Localizations.localeOf(context).languageCode;
    final service = ref.read(contactServiceProvider);

    Future<void> contact(ContactChannel channel) => service.contact(
      providerId: providerId,
      channel: channel,
      categoryId: categoryId,
      sourceScreen: sourceScreen,
      locale: locale,
      fallbackPhone: fallbackPhone,
    );

    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: t.contact.call,
            icon: const Icon(Icons.call, size: 18),
            onPressed: () => contact(ContactChannel.phone),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: AppButton(
            label: t.contact.whatsapp,
            icon: const Icon(Icons.chat, size: 18),
            variant: AppButtonVariant.whatsapp,
            onPressed: () => contact(ContactChannel.whatsapp),
          ),
        ),
      ],
    );
  }
}
