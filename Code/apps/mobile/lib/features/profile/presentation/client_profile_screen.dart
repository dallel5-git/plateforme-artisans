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
import 'package:sanaya/core/widgets/provider_avatar.dart';
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
    if (!isAuthenticated) {
      displayName = guestName;
      subtitle = guestSubtitle;
    } else {
      displayName = _displayName(user, fallbackName);
      subtitle = user != null ? maskPhone(user.phone) : null;
    }

    return AppCard(
      child: Row(
        children: [
          const ProviderAvatar(url: null, size: 56),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: currentUser.isLoading && user == null && isAuthenticated
                ? const _IdentityHeaderSkeleton()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: AppText.h3(
                          locale,
                        ).copyWith(color: colors.textPrimary),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          subtitle,
                          style: AppText.body(
                            locale,
                          ).copyWith(color: colors.textSecondary),
                        ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  String _displayName(V1AuthMeGet200Response? user, String fallback) {
    if (user == null) return fallback;
    final name = '${user.firstName} ${user.lastName}'.trim();
    return name.isEmpty ? fallback : name;
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
