import React from 'react';
import type { Metadata } from 'next';
import Link from 'next/link';
import { Check, HelpCircle } from 'lucide-react';
import { Button } from '@/components/ui/Button';

interface PageProps {
  params: Promise<{ locale: string }>;
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const isAr = locale === 'ar';
  const title = isAr
    ? 'تعريفات واشتراكات الحرفيين | صَنَايعِيّة'
    : 'Tarifs & Formules d’abonnement Artisans | Sanaya';
  const description = isAr
    ? 'اطلع على باقات الاشتراك للحرفيين في تونس. باقة مجانية وباقة محترفة بـ 29 دينار شهرياً بدون أي عمولة على التدخلات.'
    : 'Découvrez nos formules claires pour artisans : profil gratuit ou pack Pro à 29 DT/mois pour maximiser vos contacts au Sahel.';

  return { title, description };
}

export default async function PricingPage({ params }: PageProps) {
  const { locale } = await params;
  const isAr = locale === 'ar';

  const plans = [
    {
      nameFr: 'Découverte',
      nameAr: 'الانطلاق المجاني',
      price: '0',
      periodFr: 'Gratuit à vie',
      periodAr: 'مجاني مدى الحياة',
      descFr: 'Idéal pour démarrer et tester la plateforme dans votre ville.',
      descAr: 'مثالي للبدء وتجربة المنصة واستقبال أولى المكالمات في منطقتك.',
      highlight: false,
      featuresFr: [
        'Profil artisan avec coordonnées de base',
        '1 métier référencé',
        'Jusqu’à 3 photos de chantiers',
        'Réception d’appels téléphoniques directs',
        '0% de commission sur vos devis',
      ],
      featuresAr: [
        'صفحة تعريفية أساسية مع رقم الهاتف',
        'إدراج في حرفة رئيسية واحدة',
        'حتى 3 صور للأعمال السابقة',
        'استقبال مكالمات الحرفاء المباشرة',
        '0% عمولة على تدخلك',
      ],
      ctaFr: 'Commencer gratuitement',
      ctaAr: 'ابدأ مجاناً الآن',
    },
    {
      nameFr: 'Artisan Pro',
      nameAr: 'المحترف الشامل',
      price: '29',
      periodFr: 'DT / mois (sans engagement)',
      periodAr: 'د.ت / شهرياً (بدون التزام)',
      descFr: 'La formule complète pour maximiser vos demandes et décrocher des chantiers chaque jour.',
      descAr: 'الباقة الأكثر طلباً لمضاعفة زبائنك والحصول على شارة الثقة الرسمية.',
      highlight: true,
      badgeFr: 'Le plus populaire',
      badgeAr: 'الأكثر شعبية',
      featuresFr: [
        'Badge de confiance "Vérifié" officiel',
        'Bouton WhatsApp direct en 1 clic',
        'Jusqu’à 3 métiers et spécialités',
        'Galerie photos illimitée pour vos réalisations',
        'Statistiques détaillées des vues et appels',
        'Priorité dans les résultats de recherche',
        'Support prioritaire par WhatsApp',
      ],
      featuresAr: [
        'شارة "حرفي موثق" الرسمية لتعزيز الثقة',
        'زر واتساب مباشر بنقرة واحدة',
        'إدراج في حتى 3 حرف وتخصصات',
        'معرض صور غير محدود لإنجازاتك',
        'إحصائيات مفصلة للمكالمات والمشاهدات',
        'أولوية الظهور في نتائج البحث بالولاية',
        'دعم فني مخصص عبر تطبيق واتساب',
      ],
      ctaFr: 'Choisir le Pack Pro',
      ctaAr: 'اختر باقة المحترف',
    },
    {
      nameFr: 'Boost Express',
      nameAr: 'الظهور الذهبي السريع',
      price: '15',
      periodFr: 'DT / 7 jours',
      periodAr: 'د.ت / لمدة 7 أيام',
      descFr: 'Poussez votre profil en tête absolue sur votre délégation pendant une semaine de forte demande.',
      descAr: 'ضع ملفك في المرتبة الأولى في معتمديتك لأسبوع كامل عند رغبتك في مضاعفة العمل.',
      highlight: false,
      featuresFr: [
        'Épinglage en première position locale',
        'Mise en avant "Urgence 24/7"',
        'Encadré visuel doré distinctif',
        'Parfait pour les périodes de travaux intenses',
      ],
      featuresAr: [
        'تثبيت في المرتبة الأولى محلياً',
        'إبراز خاصية التدخل العاجل 24/7',
        'إطار ذهبي مميز يلفت انتباه الزبائن',
        'مثالي في أوقات الذروة والمواسم',
      ],
      ctaFr: 'Activer un Boost',
      ctaAr: 'تفعيل الظهور السريع',
    },
  ];

  return (
    <div className="container mx-auto px-4 py-12 space-y-16">
      {/* Title Header */}
      <div className="text-center max-w-3xl mx-auto space-y-4">
        <span className="px-3.5 py-1 rounded-full text-xs font-bold bg-blue-100 dark:bg-blue-950 text-blue-700 dark:text-blue-300">
          {isAr ? 'شفافية مالية تامة' : 'Tarification claire & sans engagement'}
        </span>
        <h1 className="text-3xl md:text-5xl font-extrabold text-slate-900 dark:text-white tracking-tight">
          {isAr ? 'استثمر في مهنتك بأسعار واضحة وبسيطة' : 'Des formules adaptées à chaque artisan'}
        </h1>
        <p className="text-slate-600 dark:text-slate-400 text-sm md:text-base leading-relaxed">
          {isAr
            ? 'سواء كنت مبتدئاً أو محترفاً ذو خبرة، اختر الباقة التي تناسب تطلعاتك. 0 مليم عمولة على فواتيرك مع الحرفاء.'
            : 'Que vous démarriez votre activité ou souhaitiez remplir votre carnet de commandes, nos forfaits vous garantissent une rentabilité maximale sans commission.'}
        </p>
      </div>

      {/* Pricing Cards Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 items-stretch">
        {plans.map((p, idx) => (
          <div
            key={idx}
            className={`rounded-3xl p-8 flex flex-col justify-between transition-all duration-200 relative ${
              p.highlight
                ? 'bg-white dark:bg-slate-900 border-2 border-blue-600 dark:border-blue-500 shadow-xl shadow-blue-500/10'
                : 'bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 shadow-sm hover:shadow-md'
            }`}
          >
            {p.highlight && (
              <div className="absolute -top-3.5 start-1/2 -translate-x-1/2 px-4 py-1 rounded-full bg-blue-600 text-white text-xs font-bold shadow-md">
                {isAr ? p.badgeAr : p.badgeFr}
              </div>
            )}

            <div className="space-y-6">
              <div>
                <h2 className="text-xl font-bold text-slate-900 dark:text-white">
                  {isAr ? p.nameAr : p.nameFr}
                </h2>
                <p className="text-xs text-slate-500 dark:text-slate-400 mt-1 min-h-[32px]">
                  {isAr ? p.descAr : p.descFr}
                </p>
              </div>

              {/* Price Tag */}
              <div className="flex items-baseline gap-2">
                <span className="text-4xl md:text-5xl font-black text-slate-900 dark:text-white">
                  {p.price}
                </span>
                <span className="text-sm font-semibold text-slate-500">
                  {isAr ? p.periodAr : p.periodFr}
                </span>
              </div>

              {/* Feature List */}
              <div className="space-y-3 pt-4 border-t border-slate-100 dark:border-slate-800">
                {(isAr ? p.featuresAr : p.featuresFr).map((feat, fIdx) => (
                  <div key={fIdx} className="flex items-start gap-2.5 text-xs text-slate-700 dark:text-slate-300">
                    <Check className="w-4 h-4 text-emerald-600 shrink-0 mt-0.5" />
                    <span>{feat}</span>
                  </div>
                ))}
              </div>
            </div>

            <div className="pt-8">
              <Link href={`/${locale}/devenir-artisan`} className="block">
                <Button
                  variant={p.highlight ? 'primary' : 'outline'}
                  size="lg"
                  className="w-full font-bold justify-center"
                >
                  {isAr ? p.ctaAr : p.ctaFr}
                </Button>
              </Link>
            </div>
          </div>
        ))}
      </div>

      {/* Accepted Payment Methods in Tunisia */}
      <div className="bg-slate-50 dark:bg-slate-900/60 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 md:p-8 space-y-4 text-center">
        <h3 className="font-bold text-slate-900 dark:text-white text-base">
          {isAr ? 'طرق الدفع التونسية المقبولة' : 'Moyens de paiement acceptés en Tunisie'}
        </h3>
        <p className="text-xs text-slate-500 max-w-xl mx-auto">
          {isAr
            ? 'يمكنك تفعيل باقتك بسهولة وأمان عبر بطاقة بنكية تونسية، D17 للبريد التونسي، تطبيق فلوصي (Flouci) أو بالتحويل البنكي المباشر.'
            : 'Paiement simple et sécurisé en Dinars Tunisiens par Carte bancaire locale (CIB), D17 de la Poste Tunisienne, Flouci ou virement bancaire.'}
        </p>
      </div>

      {/* FAQ on Pricing */}
      <div className="max-w-3xl mx-auto space-y-6">
        <div className="flex items-center gap-2">
          <HelpCircle className="w-5 h-5 text-blue-600" />
          <h3 className="font-bold text-lg text-slate-900 dark:text-white">
            {isAr ? 'أسئلة متكررة حول الاشتراكات' : 'Questions fréquentes sur les tarifs'}
          </h3>
        </div>

        <div className="space-y-4 text-sm">
          <div className="p-5 rounded-2xl bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 space-y-2">
            <h4 className="font-bold text-slate-900 dark:text-white">
              {isAr ? 'هل يوجد أي التزام بالمدة في باقة Pro ؟' : 'Y a-t-il un engagement dans le Pack Pro ?'}
            </h4>
            <p className="text-xs text-slate-600 dark:text-slate-400 leading-relaxed">
              {isAr
                ? 'لا، يمكنك إلغاء اشتراكك أو تغييره في أي وقت بنقرة واحدة من لوحة تحكمك دون أي غرامة.'
                : 'Non, nos abonnements sont sans engagement. Vous pouvez stopper ou suspendre votre forfait à tout moment depuis votre espace.'}
            </p>
          </div>

          <div className="p-5 rounded-2xl bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 space-y-2">
            <h4 className="font-bold text-slate-900 dark:text-white">
              {isAr ? 'هل تأخذ منصة صَنَايعِيّة نسبة مئوية من الفاتورة ؟' : 'Prenez-vous une commission sur les chantiers ?'}
            </h4>
            <p className="text-xs text-slate-600 dark:text-slate-400 leading-relaxed">
              {isAr
                ? 'مطلقاً. 0 مليم عمولة. أنت تتفق مباشرة مع الحريف على المبلغ الكامل وهو حقك الصافي 100%.'
                : 'Absolument aucune. Sanaya perçoit uniquement un abonnement fixe pour les fonctionnalités pro. 100% du prix de votre travail vous revient directement.'}
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
