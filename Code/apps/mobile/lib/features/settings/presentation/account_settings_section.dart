import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/demo/demo_mode_provider.dart';
import 'package:sanaya/core/i18n/locale_persistence.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/app_card.dart';
import 'package:sanaya/core/widgets/app_section_header.dart';
import 'package:sanaya/features/auth/application/auth_state_provider.dart';
import 'package:sanaya/features/onboarding/application/onboarding_providers.dart';

/// Sections Langue/Apparence/Légal/Compte communes aux écrans Profil client
/// (`ClientProfileScreen`, FM-32) et Profil pro (`ProProfileScreen`, FM-38).
///
/// Extrait de `ClientProfileScreen` (FM-38a) — pur affichage (P3 CLAUDE.md),
/// aucune règle métier. [onOpenLegal] laisse l'écran appelant choisir sa
/// propre route imbriquée (`/client/profile/legal` ou `/pro/profile/legal`)
/// plutôt que de coder une route en dur ici. [accountActions] insère des
/// boutons entre l'en-tête « Compte » et la déconnexion (ex. bascule
/// Client↔Pro côté client, FM-25).
class AccountSettingsSection extends ConsumerWidget {
  const AccountSettingsSection({
    required this.onOpenLegal,
    this.accountActions = const [],
    super.key,
  });

  final VoidCallback onOpenLegal;
  final List<Widget> accountActions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final t = ref.watch(translationsProvider);
    final authStatus = ref.watch(authStateProvider).valueOrNull;
    final isAuthenticated = authStatus?.isAuthenticated ?? false;
    final isDemo = ref.watch(demoModeProvider);
    final demoRole = ref.watch(demoRoleProvider);
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(title: t.settings.languageSection),
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
              const AppDivider(),
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

        AppSectionHeader(title: t.settings.themeSection),
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
              const AppDivider(),
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
              const AppDivider(),
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

        AppSectionHeader(title: t.settings.legalSection),
        const SizedBox(height: AppSpacing.xs),
        AppCard(
          padding: EdgeInsets.zero,
          child: _SettingsNavTile(
            title: t.settings.legalNotices,
            onTap: onOpenLegal,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        AppSectionHeader(title: t.settings.demoSection),
        const SizedBox(height: AppSpacing.xs),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.settings.demoMode,
                            style: AppText.bodyStrong(locale).copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            t.settings.demoModeSubtitle,
                            style: AppText.caption(locale).copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: isDemo,
                      onChanged: (enabled) {
                        unawaited(
                          ref
                              .read(demoModeProvider.notifier)
                              .setEnabled(enabled: enabled),
                        );
                      },
                    ),
                  ],
                ),
              ),
              if (isDemo) ...[
                const AppDivider(),
                _SettingsOptionTile<DemoRole>(
                  title: t.settings.demoRoleClient,
                  value: DemoRole.client,
                  groupValue: demoRole,
                  onChanged: (role) {
                    if (role != null) {
                      unawaited(
                        ref.read(demoRoleProvider.notifier).setRole(role),
                      );
                    }
                  },
                ),
                const AppDivider(),
                _SettingsOptionTile<DemoRole>(
                  title: t.settings.demoRolePro,
                  value: DemoRole.provider,
                  groupValue: demoRole,
                  onChanged: (role) {
                    if (role != null) {
                      ref.read(hasPublishedProfileProvider.notifier).state =
                          true;
                      unawaited(
                        ref.read(demoRoleProvider.notifier).setRole(role),
                      );
                    }
                  },
                ),
                const AppDivider(),
                _SettingsOptionTile<DemoRole>(
                  title: t.settings.demoRoleGuest,
                  value: DemoRole.guest,
                  groupValue: demoRole,
                  onChanged: (role) {
                    if (role != null) {
                      unawaited(
                        ref.read(demoRoleProvider.notifier).setRole(role),
                      );
                    }
                  },
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        AppSectionHeader(title: t.settings.accountSection),
        const SizedBox(height: AppSpacing.xs),
        for (final action in accountActions) ...[
          action,
          const SizedBox(height: AppSpacing.md),
        ],
        if (isAuthenticated)
          AppButton(
            label: t.settings.logout,
            variant: AppButtonVariant.danger,
            onPressed: () => unawaited(_confirmLogout(context, ref)),
          )
        else
          AppButton(
            label: t.settings.login,
            onPressed: () => unawaited(context.push('/auth')),
          ),
      ],
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
              style: AppText.bodyStrong(
                locale,
              ).copyWith(color: colors.destructive),
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
            if (isSelected) Icon(Icons.check, color: colors.accent, size: 20),
          ],
        ),
      ),
    );
  }
}

class _SettingsNavTile extends StatelessWidget {
  const _SettingsNavTile({required this.title, required this.onTap});

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
            Icon(Icons.chevron_right, color: colors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
