'use client';

import React, { useState } from 'react';
import { useRouter } from 'next/navigation';
import { Search, MapPin, Wrench } from 'lucide-react';
import { Button } from '@/components/ui/Button';
import type { Category, Governorate } from '@/lib/api/demo-data';

export interface HomeSearchFormProps {
  locale: string;
  categories: Category[];
  governorates: Governorate[];
}

export const HomeSearchForm: React.FC<HomeSearchFormProps> = ({
  locale,
  categories,
  governorates,
}) => {
  const router = useRouter();
  const [query, setQuery] = useState('');
  const [category, setCategory] = useState('');
  const [governorate, setGovernorate] = useState('sousse');
  const isAr = locale === 'ar';

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const params = new URLSearchParams();
    if (query.trim()) params.set('query', query.trim());
    if (category) params.set('category', category);
    if (governorate) params.set('governorate', governorate);

    router.push(`/${locale}/recherche?${params.toString()}`);
  };

  return (
    <form
      onSubmit={handleSubmit}
      className="bg-white dark:bg-slate-900 p-3 sm:p-4 rounded-2xl shadow-xl border border-slate-200/80 dark:border-slate-800 flex flex-col md:flex-row items-center gap-3"
    >
      {/* 1. Mot clé / Métier */}
      <div className="relative flex-1 w-full flex items-center">
        <Search className="w-5 h-5 text-slate-400 absolute start-3.5 pointer-events-none" />
        <input
          type="text"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          placeholder={
            isAr
              ? 'ابحث عن حرفي، سباك، كهربائي...'
              : 'Quel artisan cherchez-vous ? (ex: électricien)'
          }
          className="w-full bg-slate-50 dark:bg-slate-800/80 text-slate-900 dark:text-white ps-11 pe-4 py-3 rounded-xl text-sm placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500/20 border-0"
        />
      </div>

      {/* 2. Catégorie Dropdown */}
      <div className="relative w-full md:w-56 flex items-center">
        <Wrench className="w-4 h-4 text-slate-400 absolute start-3.5 pointer-events-none" />
        <select
          value={category}
          onChange={(e) => setCategory(e.target.value)}
          className="w-full bg-slate-50 dark:bg-slate-800/80 text-slate-900 dark:text-white ps-10 pe-8 py-3 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500/20 border-0 appearance-none cursor-pointer"
        >
          <option value="">{isAr ? 'جميع الاختصاصات' : 'Toutes les catégories'}</option>
          {categories.map((c) => (
            <option key={c.id} value={c.slug}>
              {isAr ? c.nameAr : c.nameFr}
            </option>
          ))}
        </select>
      </div>

      {/* 3. Gouvernorat Dropdown */}
      <div className="relative w-full md:w-48 flex items-center">
        <MapPin className="w-4 h-4 text-slate-400 absolute start-3.5 pointer-events-none" />
        <select
          value={governorate}
          onChange={(e) => setGovernorate(e.target.value)}
          className="w-full bg-slate-50 dark:bg-slate-800/80 text-slate-900 dark:text-white ps-10 pe-8 py-3 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500/20 border-0 appearance-none cursor-pointer font-medium"
        >
          {governorates.map((g) => (
            <option key={g.id} value={g.slug}>
              {isAr ? g.nameAr : g.nameFr}
            </option>
          ))}
        </select>
      </div>

      {/* 4. Bouton Rechercher */}
      <Button
        type="submit"
        variant="primary"
        size="lg"
        className="w-full md:w-auto px-7 py-3 rounded-xl font-bold text-sm shrink-0 shadow-md shadow-blue-500/20"
      >
        {isAr ? 'ابحث الآن' : 'Rechercher'}
      </Button>
    </form>
  );
};
