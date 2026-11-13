import React from 'react';
import type { Metadata } from 'next';
import Link from 'next/link';
import { Search, Phone, ShieldCheck, Star, Users, ArrowRight, Zap } from 'lucide-react';
import { Button } from '@/components/ui/Button';

interface PageProps {
  params: Promise<{ locale: string }>;
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const isAr = locale === 'ar';
  const title = isAr
    ? 'كيف تعمل منصة صَنَايعِيّة | دليلك خطوة بخطوة'
    : 'Comment ça marche ? | Guide Sanaya Particuliers & Artisans';
  const description = isAr
    ? 'اكتشف كيف تربط منصة صَنَايعِيّة الحرفيين بالعملاء في الساحل التونسي بدون وسيط ولا عمولة.'
    : 'Découvrez comment trouver un artisan fiable au Sahel ou booster votre activité d’artisan sans intermédiaire ni commission.';

  return { title, description };
}

export default async function HowItWorksPage({ params }: PageProps) {
  const { locale } = await params;
  const isAr = locale === 'ar';

  const userSteps = [
    {
      num: '01',
      titleFr: 'Recherchez votre métier & votre ville',
      titleAr: 'ابحث عن الحرفة ومدينتك',
      descFr:
        'Indiquez votre besoin (plombier, électricien, serrurier...) et votre localisation précise au Sahel (Sousse, Monastir, Mahdia).',
      descAr:
        'حدد احتياجك بدقة (سباك، كهربائي، حداد...) ومنطقتك في الساحل التونسي (سوسة، المنستير، المهدية).',
      icon: Search,
    },
    {
      num: '02',
      titleFr: 'Comparez les profils vérifiés',
      titleAr: 'قارن الملفات والتقييمات الموثقة',
      descFr:
        'Consultez les photos des chantiers récents, les grilles de tarifs transparentes et les avis authentiques de voisins.',
      descAr:
        'اطلع على صور الإنجازات السابقة، جداول الأسعار التقديرية، والتقييمات الحقيقية من حرفاء سابقين.',
      icon: Star,
    },
    {
      num: '03',
      titleFr: 'Contactez directement par Téléphone ou WhatsApp',
      titleAr: 'تواصل مباشرة عبر الهاتف أو الواتساب',
      descFr:
        'Un clic révèle le numéro direct de l’artisan. Aucune commission n’est prélevée sur votre devis ou vos travaux.',
      descAr:
        'ضغطة واحدة تكشف رقم الهاتف المباشر. لا نقتطع أي مليم كعمولة أو وساطة على تدخلك.',
      icon: Phone,
    },
  ];

  const proSteps = [
    {
      num: '01',
      titleFr: 'Créez votre vitrine professionnelle',
      titleAr: 'أنشئ صفحتك المهنية مجاناً',
      descFr:
        'Présentez vos spécialités, vos zones d’intervention au Sahel et publiez vos photos de chantiers terminés.',
      descAr:
        'اعرض تخصصاتك، مناطق تنقلك في الساحل، وأضف صوراً لأبرز أعمالك المتقنة.',
      icon: Users,
    },
    {
      num: '02',
      titleFr: 'Recevez des appels directs de clients locaux',
      titleAr: 'استقبل مكالمات مباشرة من حرفاء منطقتك',
      descFr:
        'Les particuliers proches de chez vous vous appellent ou vous écrivent sur WhatsApp dès qu’ils ont un besoin urgent.',
      descAr:
        'يتصل بك الحرفاء القريبون منك مباشرة دون وسيط بمجرد احتياجهم لتدخل أو صيانة.',
      icon: Zap,
    },
    {
      num: '03',
      titleFr: 'Développez votre réputation & gagnez 100% de vos revenus',
      titleAr: 'طوّر سمعتك واحتفظ بـ 100% من مداخيلك',
      descFr:
        'Chaque client satisfait peut laisser un avis vérifié. Vous encaissez l’intégralité de votre prix sans commission.',
      descAr:
        'كل حريف يترك تقييماً إيجابياً يعزز ثقة الآخرين بك، وأرباحك كاملة لك 100%.',
      icon: ShieldCheck,
    },
  ];

  return (
    <div className="container mx-auto px-4 py-12 space-y-16">
      {/* Hero Header */}
      <div className="text-center max-w-3xl mx-auto space-y-4">
        <span className="px-3 py-1 rounded-full text-xs font-bold bg-blue-100 dark:bg-blue-950 text-blue-700 dark:text-blue-300">
          {isAr ? 'بكل شفافية وبساطة' : 'Simple, transparent et sans intermédiaire'}
        </span>
        <h1 className="text-3xl md:text-5xl font-extrabold text-slate-900 dark:text-white tracking-tight">
          {isAr ? 'كيف تعمل صَنَايعِيّة ؟' : 'Comment fonctionne Sanaya ?'}
        </h1>
        <p className="text-slate-600 dark:text-slate-400 text-sm md:text-base leading-relaxed">
          {isAr
            ? 'صَنَايعِيّة هي المنصة الأولى التي تسهل العثور على أمهر الحرفيين في الساحل التونسي وتربطهم مباشرة بالمواطنين بدون عمولة.'
            : 'Sanaya met en relation directe les particuliers du Sahel avec les meilleurs artisans locaux, pour un dépannage rapide ou des projets de rénovation sans frais cachés.'}
        </p>
      </div>

      {/* Particuliers Section */}
      <section className="space-y-8">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-2xl bg-blue-600 text-white font-bold flex items-center justify-center text-lg">
            1
          </div>
          <div>
            <h2 className="text-xl md:text-2xl font-bold text-slate-900 dark:text-white">
              {isAr ? 'لأصحاب المنازل والشركات (الحرفاء)' : 'Pour les Particuliers & Entreprises'}
            </h2>
            <p className="text-xs text-slate-500">
              {isAr ? 'ابحث عن حل لأعطالك في 3 خطوات بسيطة' : 'Trouvez un dépanneur en 3 étapes claires'}
            </p>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {userSteps.map((step) => {
            const Icon = step.icon;
            return (
              <div
                key={step.num}
                className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 relative hover:shadow-md transition-shadow"
              >
                <div className="text-3xl font-black text-slate-200 dark:text-slate-800 mb-4">
                  {step.num}
                </div>
                <div className="w-12 h-12 rounded-2xl bg-blue-50 dark:bg-blue-950/60 text-blue-600 flex items-center justify-center mb-4">
                  <Icon className="w-6 h-6" />
                </div>
                <h3 className="font-bold text-base text-slate-900 dark:text-white mb-2">
                  {isAr ? step.titleAr : step.titleFr}
                </h3>
                <p className="text-xs md:text-sm text-slate-600 dark:text-slate-400 leading-relaxed">
                  {isAr ? step.descAr : step.descFr}
                </p>
              </div>
            );
          })}
        </div>

        <div className="text-center pt-2">
          <Link href={`/${locale}/recherche`}>
            <Button variant="primary" size="lg" className="font-bold gap-2">
              <span>{isAr ? 'ابدأ البحث الآن' : 'Trouver un artisan maintenant'}</span>
              <ArrowRight className="w-4 h-4 rtl:rotate-180" />
            </Button>
          </Link>
        </div>
      </section>

      {/* Artisans Section */}
      <section className="bg-slate-50 dark:bg-slate-900/40 border border-slate-200 dark:border-slate-800 rounded-3xl p-8 md:p-12 space-y-8">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-2xl bg-emerald-600 text-white font-bold flex items-center justify-center text-lg">
            2
          </div>
          <div>
            <h2 className="text-xl md:text-2xl font-bold text-slate-900 dark:text-white">
              {isAr ? 'للحرفيين والمهنيين' : 'Pour les Artisans & Professionnels'}
            </h2>
            <p className="text-xs text-slate-500">
              {isAr ? 'عزز دخلك وحقق استقلاليتك المهنية' : 'Développez votre clientèle sans payer de commissions'}
            </p>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {proSteps.map((step) => {
            const Icon = step.icon;
            return (
              <div
                key={step.num}
                className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-6"
              >
                <div className="text-3xl font-black text-slate-200 dark:text-slate-800 mb-4">
                  {step.num}
                </div>
                <div className="w-12 h-12 rounded-2xl bg-emerald-50 dark:bg-emerald-950/60 text-emerald-600 flex items-center justify-center mb-4">
                  <Icon className="w-6 h-6" />
                </div>
                <h3 className="font-bold text-base text-slate-900 dark:text-white mb-2">
                  {isAr ? step.titleAr : step.titleFr}
                </h3>
                <p className="text-xs md:text-sm text-slate-600 dark:text-slate-400 leading-relaxed">
                  {isAr ? step.descAr : step.descFr}
                </p>
              </div>
            );
          })}
        </div>

        <div className="text-center pt-2">
          <Link href={`/${locale}/devenir-artisan`}>
            <Button
              variant="primary"
              size="lg"
              className="font-bold bg-emerald-600 hover:bg-emerald-700 gap-2 text-white border-none"
            >
              <span>{isAr ? 'انضم إلينا كحرفي معتمد' : 'Rejoindre Sanaya comme artisan'}</span>
              <ArrowRight className="w-4 h-4 rtl:rotate-180" />
            </Button>
          </Link>
        </div>
      </section>

      {/* Trust & INPDP Privacy Guarantee */}
      <div className="border border-blue-200 dark:border-blue-900/50 bg-blue-50/50 dark:bg-blue-950/20 rounded-3xl p-6 md:p-8 flex flex-col md:flex-row items-center gap-6">
        <div className="w-14 h-14 rounded-2xl bg-blue-600 text-white flex items-center justify-center shrink-0">
          <ShieldCheck className="w-8 h-8" />
        </div>
        <div className="space-y-1 text-center md:text-start">
          <h3 className="font-bold text-slate-900 dark:text-white text-base">
            {isAr
              ? 'حماية كاملة للبيانات الشخصية وشفافية مطلقة'
              : 'Protection absolue des données & Conformité INPDP'}
          </h3>
          <p className="text-xs md:text-sm text-slate-600 dark:text-slate-400">
            {isAr
              ? 'نحن نلتزم بالقوانين التونسية لحماية المعطيات الشخصية (INPDP). لا نقوم ببيع أرقام الهواتف أو استخدامها في رسائل إعلانية مزعجة.'
              : 'Sanaya respecte rigoureusement la législation tunisienne sur la protection des données personnelles. Vos coordonnées ne sont jamais cédées à des tiers pour du démarchage abusif.'}
          </p>
        </div>
      </div>
    </div>
  );
}
