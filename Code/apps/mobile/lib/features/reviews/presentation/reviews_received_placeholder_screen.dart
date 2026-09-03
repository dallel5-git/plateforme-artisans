import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/widgets/empty_state.dart';

/// Onglet Avis (`/pro/reviews`) — contenu réel = `FM-39` (bloqué par
/// `BE-44`, `GET /v1/providers/me` toujours absent). Ce placeholder rend
/// l'onglet du shell pro (FM-24) atteignable en attendant.
class ReviewsReceivedPlaceholderScreen extends ConsumerWidget {
  const ReviewsReceivedPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(t.reviews.title)),
      body: Center(
        child: EmptyState(
          icon: '⭐',
          title: t.reviews.emptyTitle,
          message: t.reviews.emptyMessage,
        ),
      ),
    );
  }
}
