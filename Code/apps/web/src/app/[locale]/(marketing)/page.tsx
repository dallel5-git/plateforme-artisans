import React from 'react';
import Link from 'next/link';
import {
  Wrench,
  Zap,
  Wind,
  Paintbrush,
  Hammer,
  Key,
  BrickWall,
  Shield,
  CheckCircle2,
  ArrowRight,
  Sparkles,
} from 'lucide-react';
import { HomeSearchForm } from './_components/HomeSearchForm';
import { ProviderCard } from '@/components/ui/ProviderCard';
import { sanayaApi } from '@/lib/api/client';

interface PageProps {
  params: Promise<{ locale: string }>;
}

export default async function HomePage({ params }: PageProps) {
  const { locale } = await params;
  const isAr = locale === 'ar';

  const categories = await sanayaApi.getCategories();
  const governorates = await sanayaApi.getGovernorates();
  const { items: featuredProviders } = await sanayaApi.searchProviders({
    verifiedOnly: true,
  });

  const getCategoryIcon = (iconName: string) => {
    switch (iconName) {
      case 'Wrench':
        return <Wrench className="w-6 h-6 text-blue-600" />;
      case 'Zap':
        return <Zap className="w-6 h-6 text-amber-500" />;
      case 'Wind':
        return <Wind className="w-6 h-6 text-cyan-600" />;
      case 'Paintbrush':
        return <Paintbrush className="w-6 h-6 text-purple-600" />;
      case 'Hammer':
        return <Hammer className="w-6 h-6 text-emerald-600" />;
      case 'Key':
        return <Key className="w-6 h-6 text-rose-600" />;
      case 'BrickWall':
        return <BrickWall className="w-6 h-6 text-orange-600" />;
      default:
        return <Shield className="w-6 h-6 text-blue-600" />;
    }
  };

  return (
    <div className="flex flex-col min-h-screen">
      {/* 1. HERO SECTION */}
      <section className="relative overflow-hidden bg-gradient-to-b from-blue-50/70 via-white to-white dark:from-slate-900 dark:via-slate-900 dark:to-slate-950 py-16 sm:py-24 border-b border-slate-100 dark:border-slate-800">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          {/* Badge de confiance Sahel */}
          <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-blue-100/80 dark:bg-blue-950/80 text-blue-800 dark:text-blue-300 text-xs font-semibold mb-6 shadow-sm">
            <Sparkles className="w-4 h-4 text-blue-600 dark:text-blue-400" />
            <span>
              {isAr
                ? 'الدليل الأول للحرفيين الموثوقين بالساحل وسوسة والمنستير والمهدية'
                : 'N°1 des artisans qualifiés à Sousse, Monastir, Mahdia et en Tunisie'}
            </span>
          </div>

          {/* Titre Principal */}
          <h1 className="text-3xl sm:text-5xl lg:text-6xl font-black text-slate-900 dark:text-white tracking-tight max-w-4xl mx-auto mb-6 leading-tight">
            {isAr ? (
              <>
                الحرفي الثقة والأقرب إليك،{' '}
                <span className="text-blue-600">بنقرة واحدة وبلا وسيط</span>
              </>
            ) : (
              <>
                Trouvez un artisan de confiance,{' '}
                <span className="text-blue-600">près de chez vous</span>
              </>
            )}
          </h1>

          {/* Sous-titre */}
          <p className="text-base sm:text-lg text-slate-600 dark:text-slate-300 max-w-2xl mx-auto mb-10 leading-relaxed">
            {isAr
              ? 'سباكون، كهربائيون، دهانون، وفنيو تكييف مؤهلون وجاهزون للتدخل الفوري بأفضل الأسعار.'
              : 'Dépannage urgent ou projet de rénovation : comparez les avis vérifiés et contactez directement par téléphone ou WhatsApp sans frais.'}
          </p>

          {/* Formulaire de recherche Hero */}
          <div className="max-w-3xl mx-auto mb-8">
            <HomeSearchForm locale={locale} categories={categories} governorates={governorates} />
          </div>

          {/* Statistiques rapides */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4 max-w-3xl mx-auto pt-4 text-center">
            <div className="p-3">
              <p className="text-2xl font-black text-slate-900 dark:text-white">500+</p>
              <p className="text-xs text-slate-500">{isAr ? 'حرفي مسجل' : 'Artisans référencés'}</p>
            </div>
            <div className="p-3">
              <p className="text-2xl font-black text-emerald-600">100%</p>
              <p className="text-xs text-slate-500">
                {isAr ? 'اتصال مباشر' : 'Contact direct gratuit'}
              </p>
            </div>
            <div className="p-3">
              <p className="text-2xl font-black text-amber-500">4.8 / 5</p>
              <p className="text-xs text-slate-500">
                {isAr ? 'متوسط تقييم الحرفيين' : 'Note moyenne vérifiée'}
              </p>
            </div>
            <div className="p-3">
              <p className="text-2xl font-black text-blue-600">24 / 7</p>
              <p className="text-xs text-slate-500">
                {isAr ? 'خدمة طوارئ مستمرة' : 'Dépannage d’urgence'}
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* 2. CATÉGORIES POPULAIRES */}
      <section className="py-16 bg-white dark:bg-slate-900">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex flex-col sm:flex-row sm:items-end justify-between mb-10">
            <div>
              <h2 className="text-2xl sm:text-3xl font-extrabold text-slate-900 dark:text-white mb-2">
                {isAr ? 'الخدمات الأكثر طلباً' : 'Métiers & Prestations'}
              </h2>
              <p className="text-sm text-slate-500 dark:text-slate-400">
                {isAr
                  ? 'اختر مجالك واكتشف أمهر الحرفيين في مدينتك'
                  : 'Sélectionnez un domaine d’intervention et découvrez nos artisans recommandés'}
              </p>
            </div>
            <Link
              href={`/${locale}/recherche`}
              className="text-sm font-semibold text-blue-600 dark:text-blue-400 hover:underline flex items-center gap-1 mt-2 sm:mt-0"
            >
              <span>{isAr ? 'جميع الخدمات' : 'Voir toutes les catégories'}</span>
              <ArrowRight className="w-4 h-4" />
            </Link>
          </div>

          <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-4 sm:gap-6">
            {categories.map((cat) => (
              <Link
                key={cat.id}
                href={`/${locale}/recherche?category=${cat.slug}`}
                className="group p-5 rounded-2xl border border-slate-200 dark:border-slate-800 bg-[#FCFCFA] dark:bg-slate-800/50 hover:bg-white dark:hover:bg-slate-800 hover:border-blue-500 hover:shadow-md transition-all duration-200"
              >
                <div className="w-12 h-12 rounded-xl bg-white dark:bg-slate-700 shadow-sm flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                  {getCategoryIcon(cat.icon)}
                </div>
                <h3 className="font-bold text-base text-slate-900 dark:text-white mb-1 group-hover:text-blue-600 transition-colors">
                  {isAr ? cat.nameAr : cat.nameFr}
                </h3>
                <p className="text-xs text-slate-500 dark:text-slate-400 line-clamp-2">
                  {isAr ? cat.descriptionAr : cat.descriptionFr}
                </p>
              </Link>
            ))}
          </div>
        </div>
      </section>

      {/* 3. ARTISANS DU SAHEL EN VEDETTE */}
      <section className="py-16 bg-slate-50 dark:bg-slate-950 border-y border-slate-200 dark:border-slate-800">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex flex-col sm:flex-row sm:items-end justify-between mb-10">
            <div>
              <div className="flex items-center gap-2 mb-2 text-xs font-bold text-emerald-700 dark:text-emerald-400 uppercase tracking-wider">
                <CheckCircle2 className="w-4 h-4" />
                <span>{isAr ? 'حرفيون تم التحقق منهم' : 'Profils certifiés'}</span>
              </div>
              <h2 className="text-2xl sm:text-3xl font-extrabold text-slate-900 dark:text-white">
                {isAr ? 'أفضل الحرفيين المتاحين الآن بالساحل' : 'Artisans recommandés au Sahel'}
              </h2>
            </div>
            <Link
              href={`/${locale}/recherche`}
              className="text-sm font-semibold text-blue-600 dark:text-blue-400 hover:underline flex items-center gap-1 mt-2 sm:mt-0"
            >
              <span>{isAr ? 'عرض الجميع' : 'Voir tous les artisans'}</span>
              <ArrowRight className="w-4 h-4" />
            </Link>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {featuredProviders.slice(0, 6).map((provider) => (
              <ProviderCard key={provider.id} provider={provider} locale={locale} />
            ))}
          </div>
        </div>
      </section>

      {/* 4. COMMENT ÇA MARCHE */}
      <section className="py-20 bg-white dark:bg-slate-900">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center max-w-3xl mx-auto mb-16">
            <h2 className="text-3xl font-black text-slate-900 dark:text-white mb-4">
              {isAr ? 'كيف تعمل منصة صنايعية؟' : 'Comment ça marche ?'}
            </h2>
            <p className="text-base text-slate-600 dark:text-slate-400">
              {isAr
                ? 'ثلاث خطوات بسيطة للعثور على الحرفي المناسب لإنجاز أشغالك بثقة تامة.'
                : '3 étapes simples pour trouver le professionnel adapté à votre chantier en toute sérénité.'}
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div className="text-center p-6 rounded-2xl bg-slate-50 dark:bg-slate-800 border border-slate-100 dark:border-slate-700">
              <div className="w-14 h-14 rounded-2xl bg-blue-600 text-white flex items-center justify-center font-black text-xl mx-auto mb-6 shadow-lg shadow-blue-500/20">
                1
              </div>
              <h3 className="font-bold text-lg text-slate-900 dark:text-white mb-2">
                {isAr ? 'اختر الخدمة والمدينة' : 'Trouvez votre service'}
              </h3>
              <p className="text-sm text-slate-600 dark:text-slate-400 leading-relaxed">
                {isAr
                  ? 'حدد نوع العطل أو الأشغال والمنطقة في سوسة، المنستير، المهدية أو أي ولاية تونسية.'
                  : 'Recherchez par corps d’état (plomberie, électricité, etc.) et filtrez selon votre gouvernorat et délégation.'}
              </p>
            </div>

            <div className="text-center p-6 rounded-2xl bg-slate-50 dark:bg-slate-800 border border-slate-100 dark:border-slate-700">
              <div className="w-14 h-14 rounded-2xl bg-blue-600 text-white flex items-center justify-center font-black text-xl mx-auto mb-6 shadow-lg shadow-blue-500/20">
                2
              </div>
              <h3 className="font-bold text-lg text-slate-900 dark:text-white mb-2">
                {isAr ? 'قارن التقييمات والأشغال' : 'Comparez les profils'}
              </h3>
              <p className="text-sm text-slate-600 dark:text-slate-400 leading-relaxed">
                {isAr
                  ? 'اطلع على أعمال الحرفي السابقة، الصور، الأسعار التقريبية وآراء الحرفاء الذين تعاملوا معه قبلك.'
                  : 'Consultez les photos des réalisations, les tarifs indicatifs et les avis vérifiés de clients réels.'}
              </p>
            </div>

            <div className="text-center p-6 rounded-2xl bg-slate-50 dark:bg-slate-800 border border-slate-100 dark:border-slate-700">
              <div className="w-14 h-14 rounded-2xl bg-blue-600 text-white flex items-center justify-center font-black text-xl mx-auto mb-6 shadow-lg shadow-blue-500/20">
                3
              </div>
              <h3 className="font-bold text-lg text-slate-900 dark:text-white mb-2">
                {isAr ? 'تواصل فوري ومباشر' : 'Contact direct sans frais'}
              </h3>
              <p className="text-sm text-slate-600 dark:text-slate-400 leading-relaxed">
                {isAr
                  ? 'اتصل بالحرفي هاتفياً أو راسله عبر واتساب مباشرة دون وساطة أو اقتطاع أي عمولة.'
                  : 'Appelez ou échangez par WhatsApp directement avec l’artisan. Aucune commission n’est prélevée sur le devis.'}
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* 5. BANDEAU DEVENIR ARTISAN (CALL TO ACTION) */}
      <section className="py-16 bg-blue-600 text-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-2xl sm:text-4xl font-black mb-4">
            {isAr
              ? 'هل أنت حرفي أو صاحب ورشة في تونس؟'
              : 'Vous êtes artisan ou professionnel du bâtiment ?'}
          </h2>
          <p className="text-base sm:text-lg text-blue-100 max-w-2xl mx-auto mb-8">
            {isAr
              ? 'انضم اليوم مجاناً إلى شبكة صنايعية، وسّع قاعدة حرفائك واحصل على طلبات تدخل أسبوعية في منطقتك.'
              : 'Créez votre fiche en 5 minutes, valorisez vos réalisations et recevez des appels de clients qualifiés directement dans votre zone.'}
          </p>
          <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
            <Link
              href={`/${locale}/devenir-artisan`}
              className="inline-flex items-center justify-center px-6 py-3.5 rounded-xl bg-white text-blue-700 font-bold text-base hover:bg-blue-50 transition-colors shadow-lg shadow-blue-900/30"
            >
              {isAr ? 'أنشئ حسابك كحرفي الآن' : 'Créer mon profil artisan'}
            </Link>
            <Link
              href={`/${locale}/tarifs`}
              className="inline-flex items-center justify-center px-6 py-3.5 rounded-xl border border-blue-400 text-white font-semibold text-base hover:bg-blue-700 transition-colors"
            >
              {isAr ? 'اكتشف خطط الاشتراك' : 'Consulter les tarifs'}
            </Link>
          </div>
        </div>
      </section>
    </div>
  );
}
