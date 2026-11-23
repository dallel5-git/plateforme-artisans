import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanaya/core/theme/app_colors.dart';
import 'package:sanaya/core/theme/app_spacing.dart';
import 'package:sanaya/core/theme/app_text.dart';
import 'package:sanaya/core/widgets/app_button.dart';
import 'package:sanaya/core/widgets/app_card.dart';

/// Écran du tunnel de vérification d'identité (KYC - CIN tunisienne) (MOB-030).
///
/// Point d'entrée pour la capture et soumission de la Carte d'Identité
/// Nationale conformément à l'ADR-002 et à la loi tunisienne n° 2004-63
/// (INPDP).
class KycSubmissionScreen extends StatelessWidget {
  const KycSubmissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    final isAr = locale.languageCode == 'ar';

    final title = isAr ? 'توثيق الهوية (CIN)' : "Vérification d'identité (CIN)";
    final subtitle = isAr
        ? 'احصل على شارة «حرفي موثق» بتقديم بطاقة التعريف الوطنية'
        : 'Obtenez le badge « Artisan Vérifié » en vérifiant votre CIN';
    final legalNotice = isAr
        ? 'معالجة الوثائق مؤمنة بالكامل ومطابقة لمقتضيات '
            'القانون الأساسي عدد 63 لسنة 2004 المتعلق بحماية المعطيات الشخصية '
            '(الهيئة الوطنية لحماية المعطيات الشخصية INPDP).'
        : 'Traitement 100 % sécurisé et conforme à la loi organique tunisienne '
            'n° 2004-63 relative à la protection des données à caractère '
            'personnel (INPDP).';
    final introTitle = isAr ? 'الوثائق المطلوبة' : 'Documents nécessaires';
    final introDesc = isAr
        ? '1. صورة واضحة للوجه الأمامي لبطاقة التعريف الوطنية\n'
            '2. صورة واضحة للوجه الخلفي\n'
            '3. رقم بطاقة التعريف (8 أرقام)'
        : '1. Photo nette du recto de votre carte CIN\n'
            '2. Photo nette du verso\n'
            '3. Numéro de la carte (8 chiffres)';
    final backToDashboard =
        isAr ? 'العودة إلى لوحة التحكم' : 'Retour au tableau de bord';

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/pro/dashboard');
            }
          },
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: colors.verifiedSubtle,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shield_outlined,
                  size: 36,
                  color: colors.verified,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppText.h3(locale).copyWith(
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppText.body(locale).copyWith(
                color: colors.textMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    introTitle,
                    style: AppText.bodyStrong(locale).copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    introDesc,
                    style: AppText.body(locale).copyWith(
                      color: colors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 20,
                    color: colors.verified,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      legalNotice,
                      style: AppText.caption(locale).copyWith(
                        color: colors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s2xl),
            AppButton(
              label: backToDashboard,
              variant: AppButtonVariant.secondary,
              onPressed: () => context.go('/pro/dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
