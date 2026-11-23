'use client';

import React, { useState, useMemo } from 'react';
import { useRouter, useSearchParams, usePathname } from 'next/navigation';
import { Search, Filter, X, SlidersHorizontal, ShieldCheck, Zap, Star } from 'lucide-react';
import { ProviderCard } from '@/components/ui/ProviderCard';
import { Button } from '@/components/ui/Button';
import { EmptyState } from '@/components/ui/EmptyState';
import type { Category, Governorate, ProviderDetail } from '@/lib/api/demo-data';

interface SearchFilterClientProps {
  locale: string;
  categories: Category[];
  governorates: Governorate[];
  initialProviders: ProviderDetail[];
  initialQuery?: string;
  initialCategory?: string;
  initialGovernorate?: string;
}

export function SearchFilterClient({
  locale,
  categories,
  governorates,
  initialProviders,
  initialQuery = '',
  initialCategory = '',
  initialGovernorate = '',
}: SearchFilterClientProps) {
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const isAr = locale === 'ar';

  const [query, setQuery] = useState(initialQuery || searchParams.get('q') || '');
  const [selectedCategory, setSelectedCategory] = useState(
    initialCategory || searchParams.get('categorie') || '',
  );
  const [selectedGovernorate, setSelectedGovernorate] = useState(
    initialGovernorate || searchParams.get('gouvernorat') || '',
  );
  const [selectedDelegation, setSelectedDelegation] = useState(
    searchParams.get('delegation') || '',
  );
  const [verifiedOnly, setVerifiedOnly] = useState(searchParams.get('verifie') === '1');
  const [emergencyOnly, setEmergencyOnly] = useState(searchParams.get('urgence') === '1');
  const [minRating, setMinRating] = useState<number>(Number(searchParams.get('note')) || 0);
  const [sortBy, setSortBy] = useState<'relevance' | 'rating' | 'reviews'>('relevance');
  const [isMobileFilterOpen, setIsMobileFilterOpen] = useState(false);

  // Available delegations based on chosen governorate
  const currentGovernorate = governorates.find(
    (g) => g.slug.toLowerCase() === selectedGovernorate.toLowerCase(),
  );

  // Sync state with URL params
  const applyFiltersToUrl = (newParams: Record<string, string | null>) => {
    const params = new URLSearchParams(searchParams.toString());
    Object.entries(newParams).forEach(([key, val]) => {
      if (val) {
        params.set(key, val);
      } else {
        params.delete(key);
      }
    });
    router.replace(`${pathname}?${params.toString()}`, { scroll: false });
  };

  const handleQuerySubmit = (e: React.FormEvent) => {
    e.preventDefault();
    applyFiltersToUrl({ q: query || null });
  };

  const handleResetFilters = () => {
    setQuery('');
    setSelectedCategory('');
    setSelectedGovernorate('');
    setSelectedDelegation('');
    setVerifiedOnly(false);
    setEmergencyOnly(false);
    setMinRating(0);
    setSortBy('relevance');
    router.replace(pathname, { scroll: false });
  };

  // Filter items in memory or fetched from API
  const filteredProviders = useMemo(() => {
    let list = [...initialProviders];

    if (query.trim()) {
      const q = query.toLowerCase().trim();
      list = list.filter(
        (p) =>
          p.businessName.toLowerCase().includes(q) ||
          p.headline.toLowerCase().includes(q) ||
          p.bio.toLowerCase().includes(q) ||
          p.primaryCategoryNameFr.toLowerCase().includes(q) ||
          p.primaryCategoryNameAr.toLowerCase().includes(q),
      );
    }

    if (selectedCategory) {
      list = list.filter(
        (p) =>
          p.primaryCategorySlug.toLowerCase() === selectedCategory.toLowerCase() ||
          p.categories.some((c) => c.slug.toLowerCase() === selectedCategory.toLowerCase()),
      );
    }

    if (selectedGovernorate) {
      list = list.filter(
        (p) => p.baseGovernorateSlug.toLowerCase() === selectedGovernorate.toLowerCase(),
      );
    }

    if (selectedDelegation) {
      list = list.filter((p) =>
        p.baseDelegationNameFr.toLowerCase().includes(selectedDelegation.toLowerCase()),
      );
    }

    if (verifiedOnly) {
      list = list.filter((p) => p.isVerified);
    }

    if (emergencyOnly) {
      list = list.filter((p) => p.acceptsEmergency);
    }

    if (minRating > 0) {
      list = list.filter((p) => p.ratingAvg >= minRating);
    }

    if (sortBy === 'rating') {
      list.sort((a, b) => b.ratingAvg - a.ratingAvg);
    } else if (sortBy === 'reviews') {
      list.sort((a, b) => b.ratingCount - a.ratingCount);
    }

    return list;
  }, [
    initialProviders,
    query,
    selectedCategory,
    selectedGovernorate,
    selectedDelegation,
    verifiedOnly,
    emergencyOnly,
    minRating,
    sortBy,
  ]);

  const activeFiltersCount = [
    selectedCategory,
    selectedGovernorate,
    selectedDelegation,
    verifiedOnly,
    emergencyOnly,
    minRating > 0,
  ].filter(Boolean).length;

  return (
    <div className="space-y-6">
      {/* Search Header Bar */}
      <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-4 shadow-sm">
        <form onSubmit={handleQuerySubmit} className="flex flex-col md:flex-row items-center gap-3">
          <div className="relative flex-1 w-full">
            <Search className="absolute start-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400" />
            <input
              type="text"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              placeholder={
                isAr
                  ? 'ابحث عن حرفي، سباك، كهربائي...'
                  : 'Rechercher un artisan, un métier (ex: plombier, électricien)...'
              }
              className="w-full ps-11 pe-4 py-3 bg-slate-50 dark:bg-slate-800/60 border border-slate-200 dark:border-slate-700 rounded-xl text-slate-900 dark:text-white placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
            />
          </div>

          <div className="flex items-center gap-2 w-full md:w-auto">
            <Button type="submit" variant="primary" className="flex-1 md:flex-initial">
              {isAr ? 'بحث' : 'Rechercher'}
            </Button>
            <Button
              type="button"
              variant="outline"
              className="md:hidden flex items-center gap-2 px-3"
              onClick={() => setIsMobileFilterOpen(true)}
            >
              <SlidersHorizontal className="w-4 h-4" />
              <span>{isAr ? 'تصفية' : 'Filtres'}</span>
              {activeFiltersCount > 0 && (
                <span className="w-5 h-5 rounded-full bg-blue-600 text-white text-xs flex items-center justify-center font-bold">
                  {activeFiltersCount}
                </span>
              )}
            </Button>
          </div>
        </form>

        {/* Quick Category Pills */}
        <div className="flex items-center gap-2 overflow-x-auto pb-1 pt-3 no-scrollbar border-t border-slate-100 dark:border-slate-800/80 mt-3">
          <button
            type="button"
            onClick={() => {
              setSelectedCategory('');
              applyFiltersToUrl({ categorie: null });
            }}
            className={`px-3 py-1.5 rounded-full text-xs font-medium whitespace-nowrap transition-colors ${
              !selectedCategory
                ? 'bg-blue-600 text-white shadow-sm'
                : 'bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 hover:bg-slate-200 dark:hover:bg-slate-700'
            }`}
          >
            {isAr ? 'جميع المهن' : 'Tous les métiers'}
          </button>
          {categories.map((cat) => {
            const isSelected = selectedCategory.toLowerCase() === cat.slug.toLowerCase();
            return (
              <button
                key={cat.id}
                type="button"
                onClick={() => {
                  const nextVal = isSelected ? '' : cat.slug;
                  setSelectedCategory(nextVal);
                  applyFiltersToUrl({ categorie: nextVal || null });
                }}
                className={`px-3 py-1.5 rounded-full text-xs font-medium whitespace-nowrap transition-colors ${
                  isSelected
                    ? 'bg-blue-600 text-white shadow-sm'
                    : 'bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 hover:bg-slate-200 dark:hover:bg-slate-700'
                }`}
              >
                {isAr ? cat.nameAr : cat.nameFr}
              </button>
            );
          })}
        </div>
      </div>

      {/* Main Grid: Sidebar Filters + Results */}
      <div className="grid grid-cols-1 lg:grid-cols-4 gap-6 items-start">
        {/* Desktop Sidebar Filters */}
        <aside className="hidden lg:block lg:col-span-1 bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-5 sticky top-24 space-y-6">
          <div className="flex items-center justify-between pb-3 border-b border-slate-100 dark:border-slate-800">
            <h2 className="font-bold text-slate-900 dark:text-white flex items-center gap-2 text-base">
              <Filter className="w-4 h-4 text-blue-600" />
              {isAr ? 'تصفية النتائج' : 'Filtres de recherche'}
            </h2>
            {activeFiltersCount > 0 && (
              <button
                type="button"
                onClick={handleResetFilters}
                className="text-xs text-blue-600 hover:underline font-medium"
              >
                {isAr ? 'إعادة ضبط' : 'Réinitialiser'}
              </button>
            )}
          </div>

          {/* Gouvernorat */}
          <div className="space-y-2">
            <label className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
              {isAr ? 'الولاية' : 'Gouvernorat'}
            </label>
            <select
              value={selectedGovernorate}
              onChange={(e) => {
                const val = e.target.value;
                setSelectedGovernorate(val);
                setSelectedDelegation('');
                applyFiltersToUrl({ gouvernorat: val || null, delegation: null });
              }}
              className="w-full px-3 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm text-slate-800 dark:text-slate-200 focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="">{isAr ? 'كل ولايات الساحل' : 'Tout le Sahel tunisien'}</option>
              {governorates.map((gov) => (
                <option key={gov.id} value={gov.slug}>
                  {isAr ? gov.nameAr : gov.nameFr}
                </option>
              ))}
            </select>
          </div>

          {/* Délégation */}
          {currentGovernorate && currentGovernorate.delegations.length > 0 && (
            <div className="space-y-2">
              <label className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
                {isAr ? 'المعتمدية / المنطقة' : 'Délégation / Quartier'}
              </label>
              <select
                value={selectedDelegation}
                onChange={(e) => {
                  const val = e.target.value;
                  setSelectedDelegation(val);
                  applyFiltersToUrl({ delegation: val || null });
                }}
                className="w-full px-3 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm text-slate-800 dark:text-slate-200 focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="">{isAr ? 'كل المعتمديات' : 'Toutes les délégations'}</option>
                {currentGovernorate.delegations.map((del) => (
                  <option key={del.id} value={del.nameFr}>
                    {isAr ? del.nameAr : del.nameFr}
                  </option>
                ))}
              </select>
            </div>
          )}

          {/* Critères de confiance */}
          <div className="space-y-3 pt-2 border-t border-slate-100 dark:border-slate-800">
            <label className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
              {isAr ? 'شروط خاصة' : 'Disponibilité & Confiance'}
            </label>

            <label className="flex items-center gap-3 cursor-pointer">
              <input
                type="checkbox"
                checked={verifiedOnly}
                onChange={(e) => {
                  setVerifiedOnly(e.target.checked);
                  applyFiltersToUrl({ verifie: e.target.checked ? '1' : null });
                }}
                className="w-4 h-4 rounded text-blue-600 focus:ring-blue-500 border-slate-300"
              />
              <span className="flex items-center gap-1.5 text-xs text-slate-700 dark:text-slate-300 font-medium">
                <ShieldCheck className="w-4 h-4 text-emerald-600" />
                {isAr ? 'حرفيون موثقون فقط' : 'Profils vérifiés uniquement'}
              </span>
            </label>

            <label className="flex items-center gap-3 cursor-pointer">
              <input
                type="checkbox"
                checked={emergencyOnly}
                onChange={(e) => {
                  setEmergencyOnly(e.target.checked);
                  applyFiltersToUrl({ urgence: e.target.checked ? '1' : null });
                }}
                className="w-4 h-4 rounded text-blue-600 focus:ring-blue-500 border-slate-300"
              />
              <span className="flex items-center gap-1.5 text-xs text-slate-700 dark:text-slate-300 font-medium">
                <Zap className="w-4 h-4 text-amber-500 fill-amber-500" />
                {isAr ? 'طوارئ 24/7 متوفر' : 'Dépannage d’urgence 24/7'}
              </span>
            </label>
          </div>

          {/* Note minimale */}
          <div className="space-y-2 pt-2 border-t border-slate-100 dark:border-slate-800">
            <label className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
              {isAr ? 'التقييم الأدنى' : 'Note minimale'}
            </label>
            <div className="space-y-1.5">
              {[
                { val: 0, labelFr: 'Toutes les notes', labelAr: 'كل التقييمات' },
                { val: 4, labelFr: '4.0 étoiles et +', labelAr: '4.0 نجوم وأكثر' },
                { val: 4.5, labelFr: '4.5 étoiles et +', labelAr: '4.5 نجوم وأكثر' },
              ].map((opt) => (
                <button
                  key={opt.val}
                  type="button"
                  onClick={() => {
                    setMinRating(opt.val);
                    applyFiltersToUrl({ note: opt.val > 0 ? String(opt.val) : null });
                  }}
                  className={`w-full flex items-center justify-between px-3 py-1.5 rounded-lg text-xs font-medium text-start transition-colors ${
                    minRating === opt.val
                      ? 'bg-blue-50 dark:bg-blue-950/60 text-blue-700 dark:text-blue-300 font-semibold'
                      : 'hover:bg-slate-100 dark:hover:bg-slate-800 text-slate-600 dark:text-slate-400'
                  }`}
                >
                  <span className="flex items-center gap-1.5">
                    {opt.val > 0 && <Star className="w-3.5 h-3.5 text-amber-500 fill-amber-500" />}
                    {isAr ? opt.labelAr : opt.labelFr}
                  </span>
                  {minRating === opt.val && <span className="text-blue-600 font-bold">✓</span>}
                </button>
              ))}
            </div>
          </div>
        </aside>

        {/* Results Column */}
        <section className="lg:col-span-3 space-y-4">
          {/* Header of results: count & sort selector */}
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-4">
            <div>
              <h1 className="font-bold text-slate-900 dark:text-white text-lg">
                {isAr
                  ? `${filteredProviders.length} حرفي متوفر`
                  : `${filteredProviders.length} artisan${filteredProviders.length > 1 ? 's' : ''} disponible${filteredProviders.length > 1 ? 's' : ''}`}
              </h1>
              <p className="text-xs text-slate-500 dark:text-slate-400 mt-0.5">
                {selectedGovernorate
                  ? isAr
                    ? `في ولاية ${currentGovernorate?.nameAr || ''}`
                    : `dans le gouvernorat de ${currentGovernorate?.nameFr || ''}`
                  : isAr
                    ? 'في منطقة الساحل (سوسة، المنستير، المهدية)'
                    : 'dans la région du Sahel (Sousse, Monastir, Mahdia)'}
              </p>
            </div>

            {/* Tri */}
            <div className="flex items-center gap-2">
              <span className="text-xs text-slate-500 whitespace-nowrap">
                {isAr ? 'ترتيب حسب:' : 'Trier par :'}
              </span>
              <select
                value={sortBy}
                onChange={(e) => setSortBy(e.target.value as 'relevance' | 'rating' | 'reviews')}
                className="px-3 py-1.5 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs text-slate-800 dark:text-slate-200 focus:outline-none focus:ring-1 focus:ring-blue-500"
              >
                <option value="relevance">{isAr ? 'الأكثر ملائمة' : 'Pertinence'}</option>
                <option value="rating">{isAr ? 'أعلى تقييم' : 'Meilleure note'}</option>
                <option value="reviews">{isAr ? 'عدد التقييمات' : 'Nombre d’avis'}</option>
              </select>
            </div>
          </div>

          {/* Provider Cards Grid */}
          {filteredProviders.length > 0 ? (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {filteredProviders.map((provider) => (
                <ProviderCard key={provider.id} provider={provider} locale={locale} />
              ))}
            </div>
          ) : (
            <EmptyState
              title={
                isAr
                  ? 'لا يوجد حرفيون يطابقون بحثك'
                  : 'Aucun artisan ne correspond à votre recherche'
              }
              description={
                isAr
                  ? 'جرب تعديل الكلمات المفتاحية أو إزالة بعض شروط التصفية للعثور على حرفيين في منطقتك.'
                  : 'Essayez d’élargir vos filtres ou de changer de gouvernorat pour afficher plus de professionnels disponibles.'
              }
              actionLabel={isAr ? 'إعادة ضبط كل الفلاتر' : 'Réinitialiser tous les filtres'}
              onAction={handleResetFilters}
            />
          )}
        </section>
      </div>

      {/* Mobile Filters Drawer Modal */}
      {isMobileFilterOpen && (
        <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex justify-end">
          <div className="bg-white dark:bg-slate-900 w-full max-w-sm h-full overflow-y-auto p-5 space-y-6 flex flex-col justify-between">
            <div className="space-y-5">
              <div className="flex items-center justify-between pb-3 border-b border-slate-100 dark:border-slate-800">
                <h2 className="font-bold text-slate-900 dark:text-white text-lg flex items-center gap-2">
                  <Filter className="w-5 h-5 text-blue-600" />
                  {isAr ? 'تصفية النتائج' : 'Filtres de recherche'}
                </h2>
                <button
                  type="button"
                  onClick={() => setIsMobileFilterOpen(false)}
                  className="p-1 rounded-lg text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800"
                >
                  <X className="w-5 h-5" />
                </button>
              </div>

              {/* Gouvernorat mobile */}
              <div className="space-y-2">
                <label className="text-xs font-bold text-slate-500">
                  {isAr ? 'الولاية' : 'Gouvernorat'}
                </label>
                <select
                  value={selectedGovernorate}
                  onChange={(e) => {
                    const val = e.target.value;
                    setSelectedGovernorate(val);
                    setSelectedDelegation('');
                    applyFiltersToUrl({ gouvernorat: val || null, delegation: null });
                  }}
                  className="w-full px-3 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm"
                >
                  <option value="">{isAr ? 'كل ولايات الساحل' : 'Tout le Sahel tunisien'}</option>
                  {governorates.map((gov) => (
                    <option key={gov.id} value={gov.slug}>
                      {isAr ? gov.nameAr : gov.nameFr}
                    </option>
                  ))}
                </select>
              </div>

              {/* Delegation mobile */}
              {currentGovernorate && currentGovernorate.delegations.length > 0 && (
                <div className="space-y-2">
                  <label className="text-xs font-bold text-slate-500">
                    {isAr ? 'المعتمدية' : 'Délégation'}
                  </label>
                  <select
                    value={selectedDelegation}
                    onChange={(e) => {
                      const val = e.target.value;
                      setSelectedDelegation(val);
                      applyFiltersToUrl({ delegation: val || null });
                    }}
                    className="w-full px-3 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm"
                  >
                    <option value="">{isAr ? 'كل المعتمديات' : 'Toutes les délégations'}</option>
                    {currentGovernorate.delegations.map((del) => (
                      <option key={del.id} value={del.nameFr}>
                        {isAr ? del.nameAr : del.nameFr}
                      </option>
                    ))}
                  </select>
                </div>
              )}

              {/* Toggles mobile */}
              <div className="space-y-3 pt-3 border-t border-slate-100 dark:border-slate-800">
                <label className="flex items-center gap-3">
                  <input
                    type="checkbox"
                    checked={verifiedOnly}
                    onChange={(e) => {
                      setVerifiedOnly(e.target.checked);
                      applyFiltersToUrl({ verifie: e.target.checked ? '1' : null });
                    }}
                    className="w-4 h-4 rounded text-blue-600 focus:ring-blue-500"
                  />
                  <span className="text-sm text-slate-700 dark:text-slate-300 font-medium">
                    {isAr ? 'حرفيون موثقون فقط' : 'Profils vérifiés uniquement'}
                  </span>
                </label>

                <label className="flex items-center gap-3">
                  <input
                    type="checkbox"
                    checked={emergencyOnly}
                    onChange={(e) => {
                      setEmergencyOnly(e.target.checked);
                      applyFiltersToUrl({ urgence: e.target.checked ? '1' : null });
                    }}
                    className="w-4 h-4 rounded text-blue-600 focus:ring-blue-500"
                  />
                  <span className="text-sm text-slate-700 dark:text-slate-300 font-medium">
                    {isAr ? 'طوارئ 24/7 متوفر' : 'Dépannage d’urgence 24/7'}
                  </span>
                </label>
              </div>
            </div>

            <div className="pt-4 border-t border-slate-100 dark:border-slate-800 flex gap-2">
              <Button
                type="button"
                variant="outline"
                className="flex-1"
                onClick={handleResetFilters}
              >
                {isAr ? 'مسح' : 'Effacer'}
              </Button>
              <Button
                type="button"
                variant="primary"
                className="flex-1"
                onClick={() => setIsMobileFilterOpen(false)}
              >
                {isAr
                  ? `عرض ${filteredProviders.length} نتيجة`
                  : `Voir ${filteredProviders.length} résultat${filteredProviders.length > 1 ? 's' : ''}`}
              </Button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
