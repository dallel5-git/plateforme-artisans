import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/i18n/translations.g.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/app_text_field.dart';
import 'package:sanaya/features/auth/application/auth_providers.dart';

/// Authentification SMS : l'API ne reçoit jamais le rôle choisi. Il guide
/// uniquement la destination après une authentification réussie.
class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authNotifierProvider);
    final t = ref.watch(translationsProvider);
    final colors = context.colors;

    ref.listen<AuthState>(authNotifierProvider, (_, next) {
      if (next.step == AuthStep.authenticated && context.mounted) {
        context.go(next.role == AuthRole.provider ? '/pro' : '/client');
      }
    });

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(backgroundColor: colors.surface),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: switch (state.step) {
                AuthStep.role => _RoleStep(
                  title: t.auth.title,
                  subtitle: t.auth.roleSubtitle,
                  clientLabel: t.auth.clientRole,
                  providerLabel: t.auth.providerRole,
                  onClient: () => ref
                      .read(authNotifierProvider.notifier)
                      .selectRole(AuthRole.client),
                  onProvider: () => ref
                      .read(authNotifierProvider.notifier)
                      .selectRole(AuthRole.provider),
                ),
                AuthStep.phone => _PhoneStep(
                  title: t.auth.phoneTitle,
                  subtitle: t.auth.phoneSubtitle,
                  label: t.auth.phoneLabel,
                  hint: t.auth.phoneHint,
                  cta: t.auth.sendCode,
                  error: _errorText(t, state.errorCode),
                  loading: state.isLoading,
                  onSubmit: (phone) => unawaited(
                    ref.read(authNotifierProvider.notifier).requestOtp(phone),
                  ),
                ),
                AuthStep.otp => _OtpStep(
                  title: t.auth.otpTitle,
                  subtitle: t.auth.otpSubtitle(phone: state.phone ?? ''),
                  label: t.auth.otpLabel,
                  hint: t.auth.otpHint,
                  cta: t.auth.verifyCode,
                  resend: t.auth.resendCode,
                  back: t.auth.changePhone,
                  error: _errorText(t, state.errorCode),
                  loading: state.isLoading,
                  onSubmit: (code) => unawaited(
                    ref.read(authNotifierProvider.notifier).verifyOtp(code),
                  ),
                  onResend: () => unawaited(
                    ref
                        .read(authNotifierProvider.notifier)
                        .requestOtp(state.phone ?? ''),
                  ),
                  onBack: ref.read(authNotifierProvider.notifier).backToPhone,
                ),
                AuthStep.authenticated => const SizedBox.shrink(),
              },
            ),
          ),
        ),
      ),
    );
  }

  String? _errorText(Translations t, String? code) => switch (code) {
    null => null,
    'PHONE_INVALID' => t.auth.phoneInvalid,
    'OTP_INVALID' || 'OTP_EXPIRED' || 'OTP_ATTEMPTS_EXCEEDED' =>
      t.auth.otpInvalid,
    'RATE_LIMIT_EXCEEDED' => t.auth.rateLimited,
    'NETWORK_ERROR' => t.auth.networkError,
    _ => t.auth.genericError,
  };
}

class _RoleStep extends StatelessWidget {
  const _RoleStep({
    required this.title,
    required this.subtitle,
    required this.clientLabel,
    required this.providerLabel,
    required this.onClient,
    required this.onProvider,
  });

  final String title;
  final String subtitle;
  final String clientLabel;
  final String providerLabel;
  final VoidCallback onClient;
  final VoidCallback onProvider;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppText.h1(locale).copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          subtitle,
          style: AppText.body(locale).copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton(label: clientLabel, onPressed: onClient),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: providerLabel,
          variant: AppButtonVariant.secondary,
          onPressed: onProvider,
        ),
      ],
    );
  }
}

class _PhoneStep extends StatefulWidget {
  const _PhoneStep({
    required this.title,
    required this.subtitle,
    required this.label,
    required this.hint,
    required this.cta,
    required this.error,
    required this.loading,
    required this.onSubmit,
  });

  final String title;
  final String subtitle;
  final String label;
  final String hint;
  final String cta;
  final String? error;
  final bool loading;
  final ValueChanged<String> onSubmit;

  @override
  State<_PhoneStep> createState() => _PhoneStepState();
}

class _PhoneStepState extends State<_PhoneStep> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _AuthForm(
    title: widget.title,
    subtitle: widget.subtitle,
    field: AppTextField(
      label: widget.label,
      hintText: widget.hint,
      errorText: widget.error,
      controller: _controller,
      keyboardType: TextInputType.phone,
    ),
    cta: widget.cta,
    loading: widget.loading,
    onSubmit: () => widget.onSubmit(_controller.text),
  );
}

class _OtpStep extends StatefulWidget {
  const _OtpStep({
    required this.title,
    required this.subtitle,
    required this.label,
    required this.hint,
    required this.cta,
    required this.resend,
    required this.back,
    required this.error,
    required this.loading,
    required this.onSubmit,
    required this.onResend,
    required this.onBack,
  });

  final String title;
  final String subtitle;
  final String label;
  final String hint;
  final String cta;
  final String resend;
  final String back;
  final String? error;
  final bool loading;
  final ValueChanged<String> onSubmit;
  final VoidCallback onResend;
  final VoidCallback onBack;

  @override
  State<_OtpStep> createState() => _OtpStepState();
}

class _OtpStepState extends State<_OtpStep> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _AuthForm(
    title: widget.title,
    subtitle: widget.subtitle,
    field: AppTextField(
      label: widget.label,
      hintText: widget.hint,
      errorText: widget.error,
      controller: _controller,
      keyboardType: TextInputType.number,
      obscureText: true,
    ),
    cta: widget.cta,
    loading: widget.loading,
    onSubmit: () => widget.onSubmit(_controller.text),
    footer: Wrap(
      alignment: WrapAlignment.center,
      children: [
        TextButton(onPressed: widget.onResend, child: Text(widget.resend)),
        TextButton(onPressed: widget.onBack, child: Text(widget.back)),
      ],
    ),
  );
}

class _AuthForm extends StatelessWidget {
  const _AuthForm({
    required this.title,
    required this.subtitle,
    required this.field,
    required this.cta,
    required this.loading,
    required this.onSubmit,
    this.footer,
  });

  final String title;
  final String subtitle;
  final Widget field;
  final String cta;
  final bool loading;
  final VoidCallback onSubmit;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppText.h1(locale).copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          subtitle,
          style: AppText.body(locale).copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xl),
        field,
        const SizedBox(height: AppSpacing.lg),
        AppButton(label: cta, onPressed: loading ? null : onSubmit),
        if (footer != null) ...[const SizedBox(height: AppSpacing.sm), footer!],
      ],
    );
  }
}
