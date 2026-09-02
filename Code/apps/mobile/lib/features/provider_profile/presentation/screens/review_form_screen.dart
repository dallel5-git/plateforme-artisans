import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/api/exceptions.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/app_text_field.dart';
import 'package:sanaya/features/provider_profile/application/provider_profile_providers.dart';
import 'package:sanaya/features/provider_profile/application/review_submission_notifier.dart';
import 'package:sanaya/features/provider_profile/presentation/widgets/rating_stars_input.dart';

/// Écran de dépôt d'avis (FM-10) — note en étoiles + commentaire optionnel.
/// L'éligibilité (`ContactEvent` requis) est vérifiée côté serveur
/// uniquement (403 `REVIEW_REQUIRES_CONTACT`/`REVIEW_SELF_FORBIDDEN`) —
/// cet écran ne fait aucune vérification préalable, conforme au critère
/// d'acceptation de l'issue #39 ("l'API renvoie 403 si on force").
class ReviewFormScreen extends ConsumerStatefulWidget {
  const ReviewFormScreen({required this.slug, super.key});

  final String slug;

  @override
  ConsumerState<ReviewFormScreen> createState() => _ReviewFormScreenState();
}

class _ReviewFormScreenState extends ConsumerState<ReviewFormScreen> {
  int _rating = 0;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit(String providerId) async {
    final notifier = ref.read(reviewSubmissionProvider.notifier);
    final t = ref.read(translationsProvider);
    final success = await notifier.submitReview(
      providerId: providerId,
      slug: widget.slug,
      rating: _rating,
      comment: _commentController.text,
    );

    if (!mounted) return;
    if (success) {
      context.pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.provider.profile.reviewSuccess)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final t = ref.watch(translationsProvider);
    final profileAsync = ref.watch(providerProfileProvider(widget.slug));
    final submissionState = ref.watch(reviewSubmissionProvider);
    final isLoading = submissionState.isLoading;
    final providerId = profileAsync.valueOrNull?.id;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(t.provider.profile.reviewTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.provider.profile.ratingLabel,
              style: AppText.bodyStrong(
                locale,
              ).copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
            RatingStarsInput(
              value: _rating,
              onChanged: (value) => setState(() => _rating = value),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: t.provider.profile.commentLabel,
              hintText: t.provider.profile.commentHint,
              controller: _commentController,
              maxLines: 4,
              minLines: 3,
            ),
            const SizedBox(height: AppSpacing.lg),
            if (submissionState.hasError) ...[
              Text(
                _errorMessage(t, submissionState.error),
                style: AppText.small(
                  locale,
                ).copyWith(color: colors.destructive),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            AppButton(
              label: isLoading
                  ? t.provider.profile.submittingReview
                  : t.provider.profile.submitReview,
              onPressed: (_rating == 0 || isLoading || providerId == null)
                  ? null
                  : () => _submit(providerId),
            ),
          ],
        ),
      ),
    );
  }

  String _errorMessage(Translations t, Object? error) {
    if (error is ForbiddenException) {
      return switch (error.code) {
        'REVIEW_REQUIRES_CONTACT' => t.provider.profile.reviewRequiresContact,
        'REVIEW_SELF_FORBIDDEN' => t.provider.profile.reviewSelfForbidden,
        _ => t.provider.profile.reviewGenericError,
      };
    }
    return t.provider.profile.reviewGenericError;
  }
}
