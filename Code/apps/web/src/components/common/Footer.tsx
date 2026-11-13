import React from 'react';
import Link from 'next/link';
import { Wrench, ShieldCheck, Heart } from 'lucide-react';
import { DEMO_CATEGORIES, DEMO_GOVERNORATES } from '@/lib/api/demo-data';

export interface FooterProps {
  locale: string;
}

export const Footer: React.FC<FooterProps> = ({ locale }) => {
  const isAr = locale === 'ar';

  return (
    <footer className="bg-slate-900 text-slate-300 border-t border-slate-800 pt-16 pb-12">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-10 mb-12">
          {/* Colonne 1 : À propos */}
          <div>
            <div className="flex items-center gap-2.5 font-bold text-xl text-white mb-4">
              <div className="w-8 h-8 rounded-lg bg-blue-600 text-white flex items-center justify-center">
                <Wrench className="w-4 h-4" />
              </div>
              <span>
                Sanaya<span className="text-blue-500">.tn</span>
              </span>
            </div>
            <p className="text-sm text-slate-400 mb-4 leading-relaxed">
              {isAr
                ? 'المنصة التونسية الأولى لربط الحرفيين المؤهلين بأصحاب المنازل في منطقة الساحل وكامل تراب الجمهورية. ثقة، سرعة، وبلا وسطاء.'
                : 'La 1ère plateforme tunisienne de mise en relation directe avec les meilleurs artisans qualifiés du Sahel et de toute la Tunisie. Simple, rapide et sans intermédiaire.'}
            </p>
            <div className="flex items-center gap-2 text-xs text-slate-400">
              <ShieldCheck className="w-4 h-4 text-emerald-400" />
              <span>
                {isAr
                  ? 'حماية البيانات مطابقة للهيئة الوطنية INPDP'
                  : 'Protection des données conforme INPDP'}
              </span>
            </div>
          </div>

          {/* Colonne 2 : Métiers populaires */}
          <div>
            <h4 className="text-white font-semibold text-sm mb-4">
              {isAr ? 'المهن الأكثر طلباً' : 'Métiers populaires'}
            </h4>
            <ul className="space-y-2 text-sm text-slate-400">
              {DEMO_CATEGORIES.slice(0, 6).map((cat) => (
                <li key={cat.id}>
                  <Link
                    href={`/${locale}/recherche?category=${cat.slug}`}
                    className="hover:text-white transition-colors"
                  >
                    {isAr ? cat.nameAr : cat.nameFr}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          {/* Colonne 3 : Régions du Sahel */}
          <div>
            <h4 className="text-white font-semibold text-sm mb-4">
              {isAr ? 'المناطق والمدن' : 'Régions & Villes'}
            </h4>
            <ul className="space-y-2 text-sm text-slate-400">
              {DEMO_GOVERNORATES.slice(0, 5).map((gov) => (
                <li key={gov.id}>
                  <Link
                    href={`/${locale}/recherche?governorate=${gov.slug}`}
                    className="hover:text-white transition-colors"
                  >
                    {isAr ? `حرفيون في ${gov.nameAr}` : `Artisans à ${gov.nameFr}`}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          {/* Colonne 4 : Liens utiles & Espace Pro */}
          <div>
            <h4 className="text-white font-semibold text-sm mb-4">
              {isAr ? 'روابط هامة' : 'Liens utiles'}
            </h4>
            <ul className="space-y-2 text-sm text-slate-400">
              <li>
                <Link
                  href={`/${locale}/devenir-artisan`}
                  className="text-emerald-400 hover:text-emerald-300 font-medium transition-colors"
                >
                  {isAr ? 'انضم كحرفي محترف' : 'Rejoindre le réseau artisan'}
                </Link>
              </li>
              <li>
                <Link
                  href={`/${locale}/comment-ca-marche`}
                  className="hover:text-white transition-colors"
                >
                  {isAr ? 'كيف تعمل المنصة' : 'Comment ça marche'}
                </Link>
              </li>
              <li>
                <Link
                  href={`/${locale}/tarifs`}
                  className="hover:text-white transition-colors"
                >
                  {isAr ? 'الأسعار والاشتراكات' : 'Tarifs & Packs'}
                </Link>
              </li>
              <li>
                <Link
                  href={`/${locale}/legal/cgu`}
                  className="hover:text-white transition-colors"
                >
                  {isAr ? 'شروط الاستخدام' : 'Conditions Générales'}
                </Link>
              </li>
              <li>
                <Link
                  href={`/${locale}/legal/confidentialite`}
                  className="hover:text-white transition-colors"
                >
                  {isAr ? 'سياسة الخصوصية' : 'Politique de confidentialité'}
                </Link>
              </li>
            </ul>
          </div>
        </div>

        {/* Bas de page */}
        <div className="pt-8 border-t border-slate-800 flex flex-col sm:flex-row items-center justify-between gap-4 text-xs text-slate-500">
          <p>© {new Date().getFullYear()} Sanaya.tn — Tous droits réservés.</p>
          <p className="flex items-center gap-1">
            <span>{isAr ? 'صُنع بكل فخر في تونس' : 'Fait avec passion en Tunisie'}</span>
            <Heart className="w-3.5 h-3.5 text-red-500 fill-red-500" />
          </p>
        </div>
      </div>
    </footer>
  );
};
