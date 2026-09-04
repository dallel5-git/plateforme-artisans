import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/api/generated/api.dart';
import 'package:sanaya/core/i18n/locale_persistence.dart';
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

/// Onglet Profil client (`/client/profile`, FM-32). Fusionne l'en-tête
/// d'identité (nom + numéro masqué, `GET /v1/auth/me`) avec les sections
/// déjà construites de l'ancien `SettingsScreen` (FM-13) — langue, thème,
/// mentions légales, déconnexion — et la bascule Client↔Pro posée par
/// `ProfilePlaceholderScreen` (FM-25). Remplace les deux écrans, qui sont
/// supprimés (déplacés, pas dupliqués).
class ClientProfileScreen extends ConsumerWidget {
  const ClientProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final t = ref.watch(translationsProvider);
    final isProvider =
        ref.watch(authStateProvider).valueOrNull?.isProvider ?? false;
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
          ),
          const SizedBox(height: AppSpacing.lg),

          _SectionHeader(title: t.settings.languageSection),
          const SizedBox(height: AppSpacing.xs),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _SettingsOptionTile<String>(
                  title: t.settings.french,
                  value: 'fr',
                  groupValue: locale.languageCode,
                  onChanged: (value) async {
                    if (value == null || value == locale.languageCode) return;
                    const newLocale = Locale('fr');
                    ref.read(localeProvider.notifier).state = newLocale;
                    await persistLocale(newLocale);
                  },
                ),
                Divider(height: 1, color: colors.border),
                _SettingsOptionTile<String>(
                  title: t.settings.arabic,
                  value: 'ar',
                  groupValue: locale.languageCode,
                  onChanged: (value) async {
                    if (value == null || value == locale.languageCode) return;
                    const newLocale = Locale('ar');
                    ref.read(localeProvider.notifier).state = newLocale;
                    await persistLocale(newLocale);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          _SectionHeader(title: t.settings.themeSection),
          const SizedBox(height: AppSpacing.xs),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _SettingsOptionTile<ThemeMode>(
                  title: t.settings.themeSystem,
                  value: ThemeMode.system,
                  groupValue: themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(themeModeProvider.notifier).state = value;
                    }
                  },
                ),
                Divider(height: 1, color: colors.border),
                _SettingsOptionTile<ThemeMode>(
                  title: t.settings.themeLight,
                  value: ThemeMode.light,
                  groupValue: themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(themeModeProvider.notifier).state = value;
                    }
                  },
                ),
                Divider(height: 1, color: colors.border),
                _SettingsOptionTile<ThemeMode>(
                  title: t.settings.themeDark,
                  value: ThemeMode.dark,
                  groupValue: themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(themeModeProvider.notifier).state = value;
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          _SectionHeader(title: t.settings.legalSection),
          const SizedBox(height: AppSpacing.xs),
          AppCard(
            padding: EdgeInsets.zero,
            child: _SettingsNavTile(
              title: t.settings.legalNotices,
              onTap: () {
                final router = GoRouter.maybeOf(context);
                if (router != null) {
                  unawaited(context.push('/client/profile/legal'));
                }
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          _SectionHeader(title: t.settings.accountSection),
          const SizedBox(height: AppSpacing.xs),
          if (isProvider) ...[
            AppButton(
              label: t.profile.switchToProSpace,
              variant: AppButtonVariant.secondary,
              onPressed: () => context.go('/pro'),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          AppButton(
            label: t.settings.logout,
            variant: AppButtonVariant.danger,
            onPressed: () => unawaited(_confirmLogout(context, ref)),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final colors = context.colors;
    final locale = ref.read(localeProvider);
    final t = ref.read(translationsProvider);

    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          t.settings.logoutConfirmTitle,
          style: AppText.h3(locale).copyWith(color: colors.textPrimary),
        ),
        content: Text(
          t.settings.logoutConfirmMessage,
          style: AppText.body(locale).copyWith(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              t.settings.cancel,
              style: AppText.body(locale).copyWith(color: colors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              t.settings.confirm,
              style: AppText.bodyStrong(locale).copyWith(
                color: colors.destructive,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      await ref.read(authStateProvider.notifier).signOut();
      if (context.mounted) {
        final router = GoRouter.maybeOf(context);
        if (router != null) {
          context.go('/auth');
        }
      }
    }
  }
}

class _IdentityHeader extends StatelessWidget {
  const _IdentityHeader({
    required this.currentUser,
    required this.fallbackName,
  });

  final AsyncValue<V1AuthMeGet200Response?> currentUser;
  final String fallbackName;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final user = currentUser.valueOrNull;

    return AppCard(
      child: Row(
        children: [
          const ProviderAvatar(url: null, size: 56),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: currentUser.isLoading && user == null
                ? const _IdentityHeaderSkeleton()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _displayName(user, fallbackName),
                        style: AppText.h3(
                          locale,
                        ).copyWith(color: colors.textPrimary),
                      ),
                      if (user != null) ...[
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          maskPhone(user.phone),
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: AppSpacing.xs,
        bottom: AppSpacing.xs,
      ),
      child: Text(
        title,
        style: AppText.small(locale).copyWith(
          color: colors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SettingsOptionTile<T> extends StatelessWidget {
  const _SettingsOptionTile({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String title;
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppText.body(locale).copyWith(
                  color: colors.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: colors.accent,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

class _SettingsNavTile extends StatelessWidget {
  const _SettingsNavTile({
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppText.body(locale).copyWith(color: colors.textPrimary),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: colors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
