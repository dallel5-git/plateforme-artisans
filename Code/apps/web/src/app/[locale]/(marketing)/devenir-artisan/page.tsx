import React from 'react';
import type { Metadata } from 'next';
import { ShieldCheck, Phone, DollarSign, Award, TrendingUp } from 'lucide-react';
import { ProRegistrationForm } from './ProRegistrationForm';

interface PageProps {
  params: Promise<{ locale: string }>;
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const isAr = locale === 'ar';
  const title = isAr
    ? 'انضم إلى صَنَايعِيّة | ضاعف زبائنك بدون عمولة في الساحل'
    : 'Devenir Artisan Partenaire Sanaya | 0% Commission au Sahel';
  const description = isAr
    ? 'سجل حرفتك في سوسة، المنستير، والمهدية واستقبل اتصالات مباشرة من زبائن جدد كل يوم.'
    : 'Créez votre profil d’artisan au Sahel. Recevez des appels directs de particuliers en quête de plombiers, électriciens ou peintres.';

  return { title, description };
}

export default async function BecomeProPage({ params }: PageProps) {
  const { locale } = await params;
  const isAr = locale === 'ar';

  const advantages = [
    {
      titleFr: '0% de commission sur vos devis',
      titleAr: '0 مليم عمولة على مداخيلك',
      descFr: 'Vous fixez librement vos prix et encaissez la totalité du montant convenu avec vos clients.',
      descAr: 'أنت من يحدد أسعاره بحرية تامة وتستلم مستحقاتك كاملة مباشرة من الحريف دون وساطة.',
      icon: DollarSign,
    },
    {
      titleFr: 'Appels & WhatsApp en direct',
      titleAr: 'اتصالات مباشرة وهاتف مفتوح',
      descFr: 'Les particuliers vous contactent directement sur votre téléphone mobile personnel dès leur recherche.',
      descAr: 'يتصل بك الزبائن مباشرة على هاتفك أو عبر تطبيق واتساب لطلب تدخل فوري أو أخذ موعد.',
      icon: Phone,
    },
    {
      titleFr: 'Badge de confiance Vérifié',
      titleAr: 'شارة الحرفي الموثوق',
      descFr: 'Un gage de sérieux qui rassure les familles et multiplie par 3 votre taux de transformation.',
      descAr: 'علامة ثقة تمنح الأمان للحرفاء وترفع نسبة اختيارك مقارنة بالحرفيين غير المعتمدين.',
      icon: ShieldCheck,
    },
    {
      titleFr: 'Visibilité Google locale n°1',
      titleAr: 'ظهور متميز في مدينتك',
      descFr: 'Vos pages sont optimisées pour ressortir en tête sur Google lorsque quelqu’un cherche un artisan au Sahel.',
      descAr: 'صفحات مهيأة للظهور في المراتب الأولى على محركات البحث لكل من يبحث عن خدماتك في منطقتك.',
      icon: TrendingUp,
    },
  ];

  return (
    <div className="container mx-auto px-4 py-12 space-y-16">
      {/* Hero Section with Form */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-10 items-center">
        <div className="lg:col-span-7 space-y-6">
          <span className="inline-flex items-center gap-1.5 px-3.5 py-1 rounded-full text-xs font-bold bg-emerald-100 dark:bg-emerald-950/80 text-emerald-800 dark:text-emerald-300">
            <Award className="w-4 h-4 text-emerald-600" />
            <span>{isAr ? 'المنصة المهنية رقم 1 بالساحل' : 'Pour les Artisans du Sahel'}</span>
          </span>

          <h1 className="text-3xl md:text-5xl font-extrabold text-slate-900 dark:text-white tracking-tight leading-tight">
            {isAr
              ? 'ضاعف طلبات الحرفاء في منطقتك واحتفظ بـ 100% من أرباحك'
              : 'Recevez plus de chantiers dans votre ville, sans payer aucune commission.'}
          </h1>

          <p className="text-slate-600 dark:text-slate-400 text-sm md:text-base leading-relaxed">
            {isAr
              ? 'انضم إلى مئات الحرفيين المستقلين في سوسة، المنستير، والمهدية. استقبل مكالمات زبائن حقيقيين يبحثون عن خبرتك يومياً.'
              : 'Rejoignez le réseau Sanaya au Sahel. Créez votre vitrine d’artisan, valorisez vos chantiers passés et recevez des appels directs de clients à proximité.'}
          </p>

          <div className="grid grid-cols-2 sm:grid-cols-3 gap-4 pt-4 border-t border-slate-200 dark:border-slate-800">
            <div>
              <div className="text-2xl font-black text-slate-900 dark:text-white">+1 200</div>
              <div className="text-xs text-slate-500">
                {isAr ? 'حريف شهرياً' : 'Recherches / mois'}
              </div>
            </div>
            <div>
              <div className="text-2xl font-black text-emerald-600">0 DT</div>
              <div className="text-xs text-slate-500">
                {isAr ? 'عمولة على الخدمات' : 'Commission prélevée'}
              </div>
            </div>
            <div>
              <div className="text-2xl font-black text-blue-600">100%</div>
              <div className="text-xs text-slate-500">
                {isAr ? 'اتصال مباشر' : 'Contact direct'}
              </div>
            </div>
          </div>
        </div>

        <div className="lg:col-span-5">
          <ProRegistrationForm locale={locale} />
        </div>
      </div>

      {/* 4 Advantages Grid */}
      <section className="space-y-8">
        <div className="text-center max-w-2xl mx-auto space-y-2">
          <h2 className="text-2xl md:text-3xl font-extrabold text-slate-900 dark:text-white">
            {isAr ? 'لماذا يفضل الحرفيون صَنَايعِيّة ؟' : 'Pourquoi les artisans choisissent Sanaya ?'}
          </h2>
          <p className="text-xs md:text-sm text-slate-500">
            {isAr
              ? 'صممنا المنصة خصيصاً لتناسب واقع الحرفي التونسي دون تعقيدات تقنية أو وساطة مرهقة'
              : 'Une plateforme conçue pour les professionnels du bâtiment et du dépannage en Tunisie.'}
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {advantages.map((adv, idx) => {
            const Icon = adv.icon;
            return (
              <div
                key={idx}
                className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 space-y-3 hover:border-emerald-500 transition-colors shadow-sm"
              >
                <div className="w-12 h-12 rounded-2xl bg-emerald-50 dark:bg-emerald-950/60 text-emerald-600 flex items-center justify-center">
                  <Icon className="w-6 h-6" />
                </div>
                <h3 className="font-bold text-base text-slate-900 dark:text-white">
                  {isAr ? adv.titleAr : adv.titleFr}
                </h3>
                <p className="text-xs text-slate-600 dark:text-slate-400 leading-relaxed">
                  {isAr ? adv.descAr : adv.descFr}
                </p>
              </div>
            );
          })}
        </div>
      </section>
    </div>
  );
}
