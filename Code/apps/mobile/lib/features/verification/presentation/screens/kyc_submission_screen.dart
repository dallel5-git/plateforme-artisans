import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/app_text_field.dart';
import 'package:sanaya/features/verification/application/kyc_providers.dart';
import 'package:sanaya/features/verification/presentation/widgets/cin_capture_card.dart';
import 'package:sanaya/features/verification/presentation/widgets/inpdp_consent_checkbox.dart';

typedef PickImageSourceFunction = Future<XFile?> Function(ImageSource source);

/// Écran guidé de capture CIN et de soumission KYC (MOB-030).
class KycSubmissionScreen extends ConsumerStatefulWidget {
  const KycSubmissionScreen({this.pickImage, super.key});

  /// Injectable pour les tests unitaires / widget (évite les canaux de plateforme natifs).
  final PickImageSourceFunction? pickImage;

  @override
  ConsumerState<KycSubmissionScreen> createState() =>
      _KycSubmissionScreenState();
}

class _KycSubmissionScreenState extends ConsumerState<KycSubmissionScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _cinController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _cinController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cinController.dispose();
    super.dispose();
  }

  Future<void> _openSourcePicker(bool isFront) async {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final t = ref.read(translationsProvider);
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: AppRadius.lg,
        ),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.camera_alt_rounded,
                  color: colors.accent,
                ),
                title: Text(
                  t.verification.takePhoto,
                  style: AppText.subtitle(locale).copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                onTap: () => Navigator.of(sheetCtx).pop(ImageSource.camera),
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library_rounded,
                  color: colors.accent,
                ),
                title: Text(
                  t.verification.chooseFromGallery,
                  style: AppText.subtitle(locale).copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                onTap: () => Navigator.of(sheetCtx).pop(ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );

    if (source == null) return;

    final picker =
        widget.pickImage ?? (src) => ImagePicker().pickImage(source: src);
    final xFile = await picker(source);
    if (xFile != null) {
      final file = File(xFile.path);
      await ref
          .read(kycSubmissionNotifierProvider.notifier)
          .processAndUploadFile(isFront: isFront, file: file);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final t = ref.watch(translationsProvider);
    final state = ref.watch(kycSubmissionNotifierProvider);

    if (state.isSuccess) {
      return Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: colors.verifiedSubtle,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.verified_rounded,
                    color: colors.verified,
                    size: 48,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  t.verification.submitSuccessTitle,
                  style: AppText.h2(locale).copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  t.verification.submitSuccessMessage,
                  style: AppText.body(locale).copyWith(
                    color: colors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                AppButton(
                  label: t.verification.backToDashboard,
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/pro/dashboard');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          t.verification.screenTitle,
          style: AppText.subtitle(locale).copyWith(fontWeight: FontWeight.w600),
        ),
        backgroundColor: colors.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. En-tête pédagogique
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: colors.accentSubtle,
                  borderRadius: const BorderRadius.all(AppRadius.md),
                  border: Border.all(
                    color: colors.accent.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.verified_user_rounded,
                          color: colors.accent,
                          size: 24,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            t.verification.headerTitle,
                            style: AppText.subtitle(locale).copyWith(
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      t.verification.headerSubtitle,
                      style: AppText.small(locale).copyWith(
                        color: colors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _buildAdvantage(
                      context,
                      t.verification.badgeAdvantage1,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    _buildAdvantage(
                      context,
                      t.verification.badgeAdvantage2,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 2. Formulaire d'identité
              Text(
                t.verification.identitySectionTitle,
                style: AppText.subtitle(locale).copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _nameController,
                label: t.verification.fullNameLabel,
                hintText: t.verification.fullNameHint,
                errorText:
                    _nameController.text.isNotEmpty && !state.isValidFullName
                    ? t.verification.fullNameError
                    : null,
                onChanged: (val) => ref
                    .read(kycSubmissionNotifierProvider.notifier)
                    .setFullName(val),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _cinController,
                label: t.verification.cinNumberLabel,
                hintText: t.verification.cinNumberHint,
                keyboardType: TextInputType.number,
                errorText: _cinController.text.isNotEmpty && !state.isValidCin
                    ? t.verification.cinNumberError
                    : null,
                onChanged: (val) => ref
                    .read(kycSubmissionNotifierProvider.notifier)
                    .setCinNumber(val),
              ),
              const SizedBox(height: AppSpacing.xl),

              // 3. Capture CIN Recto / Verso
              CinCaptureCard(
                title: t.verification.cinFrontTitle,
                subtitle: t.verification.cinFrontSubtitle,
                state: state.front,
                onPickImage: () => _openSourcePicker(true),
                onRemove: () => ref
                    .read(kycSubmissionNotifierProvider.notifier)
                    .removeDocument(isFront: true),
                onRetry: () => _openSourcePicker(true),
              ),
              const SizedBox(height: AppSpacing.lg),
              CinCaptureCard(
                title: t.verification.cinBackTitle,
                subtitle: t.verification.cinBackSubtitle,
                state: state.back,
                onPickImage: () => _openSourcePicker(false),
                onRemove: () => ref
                    .read(kycSubmissionNotifierProvider.notifier)
                    .removeDocument(isFront: false),
                onRetry: () => _openSourcePicker(false),
              ),
              const SizedBox(height: AppSpacing.xl),

              // 4. Case à cocher consentement INPDP
              InpdpConsentCheckbox(
                value: state.consentGiven,
                t: t,
                onChanged: (val) => ref
                    .read(kycSubmissionNotifierProvider.notifier)
                    .setConsent(consent: val),
              ),
              const SizedBox(height: AppSpacing.md),

              // 5. Erreur globale si la soumission a échoué
              if (state.submitError != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: colors.destructiveSubtle,
                    borderRadius: const BorderRadius.all(AppRadius.sm),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: colors.destructive,
                        size: 18,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          t.verification.generalError,
                          style: AppText.small(locale).copyWith(
                            color: colors.destructive,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              // 6. Bouton de soumission
              AppButton(
                label: state.isSubmitting
                    ? t.verification.submitting
                    : t.verification.submitButton,
                onPressed: state.canSubmit
                    ? () => ref
                          .read(kycSubmissionNotifierProvider.notifier)
                          .submit()
                    : null,
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdvantage(BuildContext context, String text) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle_outline, size: 16, color: colors.accent),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            text,
            style: AppText.caption(locale).copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
