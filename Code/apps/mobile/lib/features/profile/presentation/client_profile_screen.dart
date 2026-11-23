import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/utils/phone_mask.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/app_card.dart';
import 'package:sanaya/core/widgets/app_skeleton.dart';
import 'package:sanaya/features/auth/application/auth_state_provider.dart';
import 'package:sanaya/features/auth/application/current_user_provider.dart';
import 'package:sanaya/features/settings/presentation/account_settings_section.dart';

/// Onglet Profil client (`/client/profile`, FM-32). Fusionne l'en-tête
/// d'identité (nom + numéro masqué, `GET /v1/auth/me`) avec les sections
/// Langue/Apparence/Légal/Compte (`AccountSettingsSection`, extraites en
/// FM-38a pour être réutilisées par `ProProfileScreen`) et la bascule
/// Client↔Pro posée par `ProfilePlaceholderScreen` (FM-25).
class ClientProfileScreen extends ConsumerWidget {
  const ClientProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final t = ref.watch(translationsProvider);
    final authStatus = ref.watch(authStateProvider).valueOrNull;
    final isProvider = authStatus?.isProvider ?? false;
    final isAuthenticated = authStatus?.isAuthenticated ?? false;
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(t.profile.title)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _IdentityHeader(
            currentUser: currentUser,
            fallbackName: t.profile.accountFallback,
            guestName: t.profile.guestName,
            guestSubtitle: t.profile.guestSubtitle,
            isAuthenticated: isAuthenticated,
          ),
          if (isAuthenticated && !isProvider) ...[
            const SizedBox(height: AppSpacing.lg),
            _BecomeProBanner(
              title: t.profile.becomeProTitle,
              subtitle: t.profile.becomeProSubtitle,
              buttonLabel: t.profile.becomeProButton,
              onPressed: () => context.push('/pro/onboarding'),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          AccountSettingsSection(
            onOpenLegal: () {
              final router = GoRouter.maybeOf(context);
              if (router != null) {
                unawaited(context.push('/client/profile/legal'));
              }
            },
            accountActions: isProvider
                ? [
                    AppButton(
                      label: t.profile.switchToProSpace,
                      variant: AppButtonVariant.secondary,
                      icon: const Icon(
                        Icons.storefront_rounded,
                        size: AppIconSize.md,
                      ),
                      onPressed: () => context.go('/pro'),
                    ),
                  ]
                : const [],
          ),
        ],
      ),
    );
  }
}

class _IdentityHeader extends StatelessWidget {
  const _IdentityHeader({
    required this.currentUser,
    required this.fallbackName,
    required this.guestName,
    required this.guestSubtitle,
    required this.isAuthenticated,
  });

  final AsyncValue<V1AuthMeGet200Response?> currentUser;
  final String fallbackName;
  final String guestName;
  final String guestSubtitle;
  final bool isAuthenticated;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final user = currentUser.valueOrNull;

    final String displayName;
    final String? subtitle;
    final String? initials;
    if (!isAuthenticated) {
      displayName = guestName;
      subtitle = guestSubtitle;
      initials = null;
    } else {
      displayName = _displayName(user, fallbackName);
      subtitle = user != null ? maskPhone(user.phone) : null;
      initials = _initials(user);
    }

    return AppCard(
      child: Row(
        children: [
          _buildAvatar(colors, locale, initials),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: currentUser.isLoading && user == null && isAuthenticated
                ? const _IdentityHeaderSkeleton()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              displayName,
                              style:
                                  AppText.h3(
                                    locale,
                                  ).copyWith(
                                    color: colors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isAuthenticated) ...[
                            const SizedBox(width: AppSpacing.xs),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xs,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colors.verifiedSubtle,
                                borderRadius: const BorderRadius.all(
                                  AppRadius.sm,
                                ),
                              ),
                              child: Icon(
                                Icons.verified_rounded,
                                size: AppIconSize.xs,
                                color: colors.verified,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppSpacing.xxs),
                        Row(
                          children: [
                            if (isAuthenticated) ...[
                              Icon(
                                Icons.phone_iphone_rounded,
                                size: AppIconSize.xs,
                                color: colors.textSecondary,
                              ),
                              const SizedBox(width: AppSpacing.xxs),
                            ],
                            Text(
                              subtitle,
                              style: AppText.body(
                                locale,
                              ).copyWith(color: colors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(AppColors colors, Locale locale, String? initials) {
    if (initials != null && initials.isNotEmpty) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.accentSubtle,
          border: Border.all(
            color: colors.accent.withValues(alpha: 0.25),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            initials,
            style: AppText.h3(locale).copyWith(
              color: colors.accent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.surfaceSunken,
        border: Border.all(
          color: colors.border,
          width: 2,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.person_rounded,
          color: colors.textMuted,
          size: AppIconSize.lg,
        ),
      ),
    );
  }

  String _displayName(V1AuthMeGet200Response? user, String fallback) {
    if (user == null) return fallback;
    final name = '${user.firstName} ${user.lastName}'.trim();
    return name.isEmpty ? fallback : name;
  }

  String? _initials(V1AuthMeGet200Response? user) {
    if (user == null) return null;
    final f = user.firstName.trim();
    final l = user.lastName.trim();
    final buffer = StringBuffer();
    if (f.isNotEmpty) buffer.write(f[0]);
    if (l.isNotEmpty) buffer.write(l[0]);
    final s = buffer.toString().toUpperCase();
    return s.isEmpty ? null : s;
  }
}

class _IdentityHeaderSkeleton extends StatelessWidget {
  const _IdentityHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSkeleton(width: 140, height: 18),
        SizedBox(height: AppSpacing.xxs),
        AppSkeleton(width: 100, height: 14),
      ],
    );
  }
}

class _BecomeProBanner extends StatelessWidget {
  const _BecomeProBanner({
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onPressed,
  });

  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.accentSubtle,
        borderRadius: const BorderRadius.all(AppRadius.lg),
        border: Border.all(
          color: colors.accent.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors.accent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.storefront_rounded,
                  color: colors.accent,
                  size: AppIconSize.md,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  title,
                  style: AppText.h3(locale).copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            subtitle,
            style: AppText.body(locale).copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: buttonLabel,
              icon: const Icon(
                Icons.arrow_forward_rounded,
                size: AppIconSize.md,
              ),
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}
