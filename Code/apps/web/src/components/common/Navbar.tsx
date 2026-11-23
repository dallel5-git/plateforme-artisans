'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { usePathname, useRouter } from 'next/navigation';
import { Wrench, Search, Globe, Sun, Moon, Menu, X, Briefcase, User } from 'lucide-react';
import { Button } from '@/components/ui/Button';

export interface NavbarProps {
  locale: string;
}

export const Navbar: React.FC<NavbarProps> = ({ locale }) => {
  const [isScrolled, setIsScrolled] = useState(false);
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const [isDark, setIsDark] = useState(false);
  const pathname = usePathname();
  const router = useRouter();
  const isAr = locale === 'ar';

  useEffect(() => {
    const handleScroll = () => {
      setIsScrolled(window.scrollY > 10);
    };
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  const toggleLanguage = () => {
    const targetLocale = isAr ? 'fr' : 'ar';
    const newPath = pathname.replace(`/${locale}`, `/${targetLocale}`);
    router.push(newPath);
  };

  const toggleDarkMode = () => {
    const nextDark = !isDark;
    setIsDark(nextDark);
    if (nextDark) {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }
  };

  return (
    <header
      className={`sticky top-0 z-50 w-full transition-all duration-200 ${
        isScrolled
          ? 'bg-white/95 dark:bg-slate-900/95 backdrop-blur-md shadow-sm border-b border-slate-200 dark:border-slate-800'
          : 'bg-white dark:bg-slate-900 border-b border-slate-100 dark:border-slate-800'
      }`}
    >
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
        {/* Logo */}
        <Link
          href={`/${locale}`}
          className="flex items-center gap-2.5 font-black text-xl tracking-tight text-blue-600 dark:text-blue-400 group"
        >
          <div className="w-9 h-9 rounded-xl bg-blue-600 text-white flex items-center justify-center shadow-md shadow-blue-500/20 group-hover:scale-105 transition-transform">
            <Wrench className="w-5 h-5" />
          </div>
          <span className="font-extrabold text-slate-900 dark:text-white">
            Sanaya<span className="text-blue-600">.tn</span>
          </span>
        </Link>

        {/* Navigation Desktop */}
        <nav className="hidden md:flex items-center gap-6">
          <Link
            href={`/${locale}/recherche`}
            className="text-sm font-medium text-slate-600 dark:text-slate-300 hover:text-blue-600 dark:hover:text-blue-400 transition-colors flex items-center gap-1.5"
          >
            <Search className="w-4 h-4" />
            {isAr ? 'بحث عن حرفي' : 'Trouver un artisan'}
          </Link>
          <Link
            href={`/${locale}/comment-ca-marche`}
            className="text-sm font-medium text-slate-600 dark:text-slate-300 hover:text-blue-600 dark:hover:text-blue-400 transition-colors"
          >
            {isAr ? 'كيف يعمل؟' : 'Comment ça marche'}
          </Link>
          <Link
            href={`/${locale}/tarifs`}
            className="text-sm font-medium text-slate-600 dark:text-slate-300 hover:text-blue-600 dark:hover:text-blue-400 transition-colors"
          >
            {isAr ? 'الأسعار' : 'Tarifs'}
          </Link>
        </nav>

        {/* Boutons d'action droite */}
        <div className="hidden md:flex items-center gap-3">
          {/* Sélecteur de langue */}
          <button
            onClick={toggleLanguage}
            className="p-2 rounded-lg text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors flex items-center gap-1 text-xs font-semibold"
            title={isAr ? 'Passer en Français' : 'التحويل إلى العربية'}
          >
            <Globe className="w-4 h-4" />
            <span>{isAr ? 'FR' : 'عربي'}</span>
          </button>

          {/* Mode Sombre */}
          <button
            onClick={toggleDarkMode}
            className="p-2 rounded-lg text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors"
            aria-label="Toggle dark mode"
          >
            {isDark ? <Sun className="w-4 h-4" /> : <Moon className="w-4 h-4" />}
          </button>

          {/* Devenir artisan */}
          <Link href={`/${locale}/devenir-artisan`}>
            <Button variant="outline" size="sm" leftIcon={<Briefcase className="w-4 h-4" />}>
              {isAr ? 'فضاء الحرفيين' : 'Espace Pro'}
            </Button>
          </Link>

          {/* Connexion */}
          <Link href={`/${locale}/connexion`}>
            <Button variant="primary" size="sm" leftIcon={<User className="w-4 h-4" />}>
              {isAr ? 'تسجيل الدخول' : 'Connexion'}
            </Button>
          </Link>
        </div>

        {/* Hamburger Mobile */}
        <div className="flex md:hidden items-center gap-2">
          <button
            onClick={toggleLanguage}
            className="p-2 rounded-lg text-slate-600 dark:text-slate-300 hover:bg-slate-100 text-xs font-bold"
          >
            {isAr ? 'FR' : 'عر'}
          </button>
          <button
            onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
            className="p-2 rounded-lg text-slate-700 dark:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800"
            aria-label="Menu"
          >
            {isMobileMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
          </button>
        </div>
      </div>

      {/* Menu Mobile Tiroir */}
      {isMobileMenuOpen && (
        <div className="md:hidden border-b border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 px-4 pt-2 pb-6 space-y-3">
          <Link
            href={`/${locale}/recherche`}
            onClick={() => setIsMobileMenuOpen(false)}
            className="flex items-center gap-3 px-3 py-2.5 rounded-lg text-slate-700 dark:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800 text-sm font-medium"
          >
            <Search className="w-5 h-5 text-blue-600" />
            {isAr ? 'بحث عن حرفي' : 'Trouver un artisan'}
          </Link>
          <Link
            href={`/${locale}/comment-ca-marche`}
            onClick={() => setIsMobileMenuOpen(false)}
            className="flex items-center gap-3 px-3 py-2.5 rounded-lg text-slate-700 dark:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800 text-sm font-medium"
          >
            {isAr ? 'كيف يعمل؟' : 'Comment ça marche'}
          </Link>
          <Link
            href={`/${locale}/tarifs`}
            onClick={() => setIsMobileMenuOpen(false)}
            className="flex items-center gap-3 px-3 py-2.5 rounded-lg text-slate-700 dark:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800 text-sm font-medium"
          >
            {isAr ? 'الأسعار' : 'Tarifs'}
          </Link>
          <Link
            href={`/${locale}/devenir-artisan`}
            onClick={() => setIsMobileMenuOpen(false)}
            className="flex items-center gap-3 px-3 py-2.5 rounded-lg text-slate-700 dark:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800 text-sm font-medium"
          >
            <Briefcase className="w-5 h-5 text-emerald-600" />
            {isAr ? 'فضاء الحرفيين' : 'Espace Pro & Inscription'}
          </Link>
          <div className="pt-2">
            <Link
              href={`/${locale}/connexion`}
              onClick={() => setIsMobileMenuOpen(false)}
              className="w-full block"
            >
              <Button variant="primary" className="w-full">
                {isAr ? 'تسجيل الدخول' : 'Connexion'}
              </Button>
            </Link>
          </div>
        </div>
      )}
    </header>
  );
};
