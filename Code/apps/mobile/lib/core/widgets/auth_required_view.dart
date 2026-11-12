import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';

/// Vue invitant un visiteur non-authentifié à se connecter ou s'inscrire.
/// Utilisée sur les onglets Favoris et Historique pour les sessions anonymes.
class AuthRequiredView extends StatelessWidget {
  const AuthRequiredView({
    required this.icon,
    required this.title,
    required this.message,
    required this.ctaLabel,
    super.key,
    this.onLogin,
  });

  final String icon;
  final String title;
  final String message;
  final String ctaLabel;
  final VoidCallback? onLogin;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.s2xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.accentSubtle,
                borderRadius: const BorderRadius.all(AppRadius.pill),
              ),
              child: Text(icon, style: const TextStyle(fontSize: 28)),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppText.h3(locale).copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppText.body(locale).copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: ctaLabel,
              onPressed: onLogin ??
                  () {
                    unawaited(context.push('/auth'));
                  },
            ),
          ],
        ),
      ),
    );
  }
}
