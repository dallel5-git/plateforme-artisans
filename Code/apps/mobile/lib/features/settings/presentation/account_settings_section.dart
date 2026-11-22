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
                icon: Icons.translate_rounded,
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
                icon: Icons.language_rounded,
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
        const SizedBox(height: AppSpacing.md),

        AppSectionHeader(title: t.settings.themeSection),
        const SizedBox(height: AppSpacing.xs),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _SettingsOptionTile<ThemeMode>(
                icon: Icons.brightness_auto_rounded,
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
                icon: Icons.light_mode_rounded,
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
                icon: Icons.dark_mode_rounded,
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
        const SizedBox(height: AppSpacing.md),

        AppSectionHeader(title: t.settings.legalSection),
        const SizedBox(height: AppSpacing.xs),
        AppCard(
          padding: EdgeInsets.zero,
          child: _SettingsNavTile(
            icon: Icons.gavel_rounded,
            title: t.settings.legalNotices,
            onTap: onOpenLegal,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        AppSectionHeader(title: t.settings.demoSection),
        const SizedBox(height: AppSpacing.xs),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: colors.amber.withValues(alpha: 0.15),
                        borderRadius: const BorderRadius.all(AppRadius.md),
                      ),
                      child: Icon(
                        Icons.science_rounded,
                        color: colors.amber,
                        size: AppIconSize.sm,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
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
                      activeThumbColor: colors.amber,
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
                  icon: Icons.person_outline_rounded,
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
                  icon: Icons.handyman_outlined,
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
                  icon: Icons.visibility_outlined,
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
                const AppDivider(),
                _SettingsActionTile(
                  icon: Icons.handyman_rounded,
                  iconBgColor: colors.accent.withValues(alpha: 0.15),
                  iconColor: colors.accent,
                  title: t.settings.testOnboardingPro,
                  subtitle: t.settings.testOnboardingProDesc,
                  onTap: () async {
                    await ref
                        .read(demoModeProvider.notifier)
                        .setEnabled(enabled: true);
                    await ref
                        .read(demoRoleProvider.notifier)
                        .setRole(DemoRole.provider);
                    ref.read(hasPublishedProfileProvider.notifier).state =
                        false;
                    ref.invalidate(onboardingProvider);
                    if (context.mounted) {
                      context.go('/pro/onboarding');
                    }
                  },
                ),
                const AppDivider(),
                _SettingsActionTile(
                  icon: Icons.person_search_rounded,
                  iconBgColor: colors.amber.withValues(alpha: 0.15),
                  iconColor: colors.amber,
                  title: t.settings.testOnboardingClient,
                  subtitle: t.settings.testOnboardingClientDesc,
                  onTap: () {
                    unawaited(context.push('/client/onboarding'));
                  },
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

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
            icon: const Icon(Icons.logout_rounded, size: AppIconSize.md),
            onPressed: () => unawaited(_confirmLogout(context, ref)),
          )
        else
          AppButton(
            label: t.settings.login,
            icon: const Icon(Icons.login_rounded, size: AppIconSize.md),
            onPressed: () => unawaited(context.push('/auth')),
          ),
        const SizedBox(height: AppSpacing.xl),
        Center(
          child: Column(
            children: [
              Text(
                '${t.common.appName} • ${t.settings.version} 1.0.0',
                style: AppText.caption(locale).copyWith(
                  color: colors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                t.settings.privacyPolicy,
                style: AppText.small(locale).copyWith(
                  color: colors.textMuted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
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
    this.icon,
  });

  final String title;
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final IconData? icon;

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
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color:
                      isSelected ? colors.accentSubtle : colors.surfaceSunken,
                  borderRadius: const BorderRadius.all(AppRadius.md),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? colors.accent : colors.textSecondary,
                  size: AppIconSize.sm,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Text(
                title,
                style: AppText.body(locale).copyWith(
                  color: colors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? colors.accent : Colors.transparent,
                border: Border.all(
                  color: isSelected ? colors.accent : colors.border,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check, color: colors.onAccent, size: 13)
                  : null,
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
    this.icon,
  });

  final String title;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: colors.surfaceSunken,
                  borderRadius: const BorderRadius.all(AppRadius.md),
                ),
                child: Icon(
                  icon,
                  color: colors.textSecondary,
                  size: AppIconSize.sm,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
            ],
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

class _SettingsActionTile extends StatelessWidget {
  const _SettingsActionTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.icon,
    this.iconBgColor,
    this.iconColor,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? iconBgColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBgColor ?? colors.surfaceSunken,
                  borderRadius: const BorderRadius.all(AppRadius.md),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? colors.textSecondary,
                  size: AppIconSize.sm,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppText.bodyStrong(locale).copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppText.caption(locale).copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.play_circle_outline_rounded,
              color: iconColor ?? colors.accent,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
