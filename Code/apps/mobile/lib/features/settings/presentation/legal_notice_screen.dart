import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_card.dart';

/// Écran des mentions légales et protection des données (INPDP) (FM-13).
class LegalNoticeScreen extends ConsumerWidget {
  const LegalNoticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final t = ref.watch(translationsProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        title: Text(
          t.legal.title,
          style: AppText.h3(locale).copyWith(color: colors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _LegalSectionCard(
              title: t.legal.editorTitle,
              content: t.legal.editorContent,
            ),
            const SizedBox(height: AppSpacing.md),
            _LegalSectionCard(
              title: t.legal.modelTitle,
              content: t.legal.modelContent,
            ),
            const SizedBox(height: AppSpacing.md),
            _LegalSectionCard(
              title: t.legal.inpdpTitle,
              content: t.legal.inpdpContent,
            ),
            const SizedBox(height: AppSpacing.md),
            _LegalSectionCard(
              title: t.legal.rightsTitle,
              content: t.legal.rightsContent,
            ),
          ],
        ),
      ),
    );
  }
}

class _LegalSectionCard extends StatelessWidget {
  const _LegalSectionCard({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppText.bodyStrong(locale).copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            content,
            style: AppText.body(locale).copyWith(
              color: colors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
