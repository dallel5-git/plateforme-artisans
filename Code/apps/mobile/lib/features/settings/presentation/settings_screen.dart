import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/app/providers.dart';
import 'package:sanaya/core/i18n/locale_persistence.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/app_card.dart';
import 'package:sanaya/features/auth/application/auth_providers.dart';

/// Écran des réglages de l'application (FM-13).
/// Gère la langue avec bascule immédiate et persistance, l'apparence,
/// les mentions légales et la déconnexion sécurisée.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final t = ref.watch(translationsProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        title: Text(
          t.settings.title,
          style: AppText.h3(locale).copyWith(color: colors.textPrimary),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Section Langue
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

          // Section Thème
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

          // Section Mentions Légales
          _SectionHeader(title: t.settings.legalSection),
          const SizedBox(height: AppSpacing.xs),
          AppCard(
            padding: EdgeInsets.zero,
            child: _SettingsNavTile(
              title: t.settings.legalNotices,
              onTap: () {
                final router = GoRouter.maybeOf(context);
                if (router != null) {
                  unawaited(context.push('/settings/legal'));
                }
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Section Compte / Déconnexion
          _SectionHeader(title: t.settings.accountSection),
          const SizedBox(height: AppSpacing.xs),
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
        backgroundColor: colors.surface,
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
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.logout();
      if (context.mounted) {
        final router = GoRouter.maybeOf(context);
        if (router != null) {
          context.go('/');
        }
      }
    }
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
