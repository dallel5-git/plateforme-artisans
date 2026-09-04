import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/features/contact/domain/contact_channel.dart';

/// Pastille « canal de contact » d'une entrée d'historique (FM-31) — même
/// gabarit visuel que `VerifiedBadge` (pill, icône + libellé). Distincte de
/// `ContactButtons` : ici on affiche un canal déjà utilisé, pas une action
/// à déclencher (mêmes icônes que `ContactButtons` — `Icons.call`/
/// `Icons.chat` — mais libellés au nom du canal, pas à l'impératif).
class ContactChannelBadge extends ConsumerWidget {
  const ContactChannelBadge({required this.channel, super.key});

  final ContactChannel channel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final t = ref.watch(translationsProvider);

    final isWhatsapp = channel == ContactChannel.whatsapp;

    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceSunken,
        borderRadius: const BorderRadius.all(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isWhatsapp ? Icons.chat : Icons.call,
            size: 12,
            color: colors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            isWhatsapp ? t.history.channelWhatsapp : t.history.channelPhone,
            style: AppText.caption(
              locale,
            ).copyWith(color: colors.textSecondary, height: 1),
          ),
        ],
      ),
    );
  }
}
