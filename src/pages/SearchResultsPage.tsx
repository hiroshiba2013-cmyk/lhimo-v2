import { useState, useEffect, useMemo } from 'react';
import { ArrowLeft, CheckCircle, Search, ArrowUpDown, MapPin, SlidersHorizontal } from 'lucide-react';
import { supabase, BusinessCategory } from '../lib/supabase';
import { LocationCard } from '../components/business/LocationCard';
import { AdvancedSearch, SearchFilters } from '../components/search/AdvancedSearch';
import { PROVINCE_TO_CODE } from '../lib/cities';
import { useAuth } from '../contexts/AuthContext';
import { usePageCustomization } from '../hooks/usePageCustomization';

interface BusinessLocation {
  id: string;
  business_id: string;
  name: string | null;
  location_label?: string | null;
  address: string;
  city: string;
  province: string;
  region: string;
  postal_code: string | null;
  phone: string | null;
  email: string | null;
  website: string | null;
  business_hours: any;
  avatar_url: string | null;
  is_claimed: boolean;
  verification_badge: boolean;
  description?: string | null;
  business_type?: 'imported' | 'user_added' | 'registered';
  business?: {
    id: string;
    name: string;
    category_id: string;
    verified: boolean;
    category?: BusinessCategory;
  };
  added_by?: string | null;
  category_name?: string | null;
  avg_rating?: number;
  review_count?: number;
  service_avg_rating?: number;
  service_review_count?: number;
  management_avg_rating?: number;
  management_review_count?: number;
  instagram_url?: string | null;
  facebook_url?: string | null;
  tiktok_url?: string | null;
}

type SortOption =
  | 'default'
  | 'rating_desc'
  | 'rating_asc'
  | 'reviews_desc'
  | 'name_asc'
  | 'name_desc'
  | 'verified_first';

const SORT_OPTIONS: { value: SortOption; label: string }[] = [
  { value: 'default', label: 'Rilevanza (default)' },
  { value: 'rating_desc', label: 'Valutazione: dalla più alta' },
  { value: 'rating_asc', label: 'Valutazione: dalla più bassa' },
  { value: 'reviews_desc', label: 'Più recensite' },
  { value: 'name_asc', label: 'Nome: A → Z' },
  { value: 'name_desc', label: 'Nome: Z → A' },
  { value: 'verified_first', label: 'Verificate prima' },
];

export function SearchResultsPage() {
  const customization = usePageCustomization('search');
  const { user } = useAuth();
  const [locations, setLocations] = useState<BusinessLocation[]>([]);
  const [loading, setLoading] = useState(false);
  const [hasSearched, setHasSearched] = useState(false);
  const [initialFilters, setInitialFilters] = useState<SearchFilters | null>(null);
  const [currentSearch, setCurrentSearch] = useState(window.location.search);
  const [sortBy, setSortBy] = useState<SortOption>('default');
  const [favoriteIds, setFavoriteIds] = useState<Set<string>>(() => {
    // Restore from sessionStorage on mount so favorites survive navigation
    if (!user) return new Set();
    try {
      const stored = sessionStorage.getItem('searchFavoriteIds');
      return stored ? new Set<string>(JSON.parse(stored)) : new Set();
    } catch {
      return new Set();
    }
  });

  const persistFavoriteIds = (set: Set<string>) => {
    try {
      sessionStorage.setItem('searchFavoriteIds', JSON.stringify([...set]));
    } catch {}
    setFavoriteIds(set);
  };

  const loadFavoriteIds = async (locs: BusinessLocation[]) => {
    if (!user) return;
    if (locs.length === 0) {
      persistFavoriteIds(new Set());
      return;
    }
    const ids = locs.map(l => l.id);
    const { data: favData } = await supabase
      .from('favorite_businesses')
      .select('unclaimed_business_location_id, registered_business_location_id')
      .eq('user_id', user.id)
      .or(
        `unclaimed_business_location_id.in.(${ids.join(',')}),registered_business_location_id.in.(${ids.join(',')})`
      );
    if (favData) {
      const favSet = new Set<string>();
      favData.forEach((f: any) => {
        if (f.unclaimed_business_location_id) favSet.add(f.unclaimed_business_location_id);
        if (f.registered_business_location_id) favSet.add(f.registered_business_location_id);
      });
      persistFavoriteIds(favSet);
    }
  };

  // Reload when user authenticates after locations already loaded
  useEffect(() => {
    if (user && locations.length > 0) {
      loadFavoriteIds(locations);
    }
    if (!user) {
      persistFavoriteIds(new Set());
    }
  }, [user]);

  useEffect(() => {
    const handleLocationChange = () => {
      setCurrentSearch(window.location.search);
    };

    window.addEventListener('popstate', handleLocationChange);

    const originalPushState = window.history.pushState;
    window.history.pushState = function(...args) {
      originalPushState.apply(window.history, args);
      handleLocationChange();
    };

    return () => {
      window.removeEventListener('popstate', handleLocationChange);
      window.history.pushState = originalPushState;
    };
  }, []);

  useEffect(() => {
    const params = new URLSearchParams(currentSearch);
    const filters: SearchFilters = {
      category: params.get('category') || '',
      region: params.get('region') || '',
      province: params.get('province') || '',
      city: params.get('city') || '',
      businessName: params.get('name') || '',
      minRating: Number(params.get('rating')) || 0,
      verifiedOnly: params.get('verified') === 'true',
      minServiceUsedRating: Number(params.get('r_service')) || 0,
      minBookingRating: Number(params.get('r_booking')) || 0,
      minQuoteRating: Number(params.get('r_quote')) || 0,
      minCustomerServiceRating: Number(params.get('r_cs')) || 0,
      minProblemRating: Number(params.get('r_problem')) || 0,
    };

    setInitialFilters(filters);
    applyFilters(filters);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [currentSearch]);

  useEffect(() => {
    const shouldRestore = sessionStorage.getItem('shouldRestoreScroll');
    const targetPosition = sessionStorage.getItem('targetScrollPosition');

    if (shouldRestore === 'true' && targetPosition && !loading && locations.length > 0) {
      const position = parseInt(targetPosition, 10);
      setTimeout(() => {
        window.scrollTo(0, position);
        sessionStorage.removeItem('shouldRestoreScroll');
        sessionStorage.removeItem('targetScrollPosition');
      }, 100);
    }
  }, [loading, locations]);

  const applyFilters = async (filters: SearchFilters) => {
    setLoading(true);
    setHasSearched(true);
    try {
      const QUERY_LIMIT = 2000;

      const provinceCode = filters.province ? PROVINCE_TO_CODE[filters.province] : null;
      const { data: businessesData, error: businessesError } = await supabase
        .rpc('search_all_businesses', {
          search_query: filters.businessName || '',
          search_city: filters.city || null,
          search_province: provinceCode || null,
          search_region: filters.region || null,
          search_category_id: filters.category || null,
          verified_only: filters.verifiedOnly || false,
          limit_count: QUERY_LIMIT
        });

      if (businessesError) throw businessesError;

      let allLocations: BusinessLocation[] = (businessesData || []).map((location: any) => ({
        id: location.id,
        business_id: location.business_id || location.id,
        name: location.business_name || location.name,
        location_label: location.business_name ? location.name : null,
        address: location.address || '',
        city: location.city || '',
        province: location.province || '',
        region: location.region || '',
        postal_code: location.postal_code || null,
        phone: location.phone || null,
        email: location.email || null,
        website: location.website || null,
        business_hours: location.business_hours || null,
        avatar_url: null,
        is_claimed: location.is_claimed || false,
        verification_badge: location.is_verified || false,
        description: location.description || null,
        business_type: location.location_type === 'unclaimed' ? 'imported' :
                      location.location_type === 'claimed' ? 'registered' : 'user_added',
        business: {
          id: location.business_id || location.id,
          name: location.name,
          category_id: location.category_id,
          verified: location.is_verified || false,
          category: location.category_id && location.category_name ? { id: location.category_id, name: location.category_name, icon: '' } : null
        },
        added_by: location.added_by || null,
        source: location.result_source || null,
        location_type: location.location_type || null,
        category_name: location.category_name || null,
        avg_rating: 0,
        review_count: 0
      }));

      if (allLocations.length === 0) {
        setLocations([]);
        return;
      }

      // Fetch ratings in bulk — split into 3 separate IN queries to avoid huge OR strings
      const allIds = allLocations.map(loc => loc.id);
      const FIELDS = 'business_id, unclaimed_business_location_id, registered_business_location_id, overall_rating, review_type';
      const [rRegistered, rUnclaimed, rLegacy, socialRegistered, socialLegacy] = await Promise.all([
        supabase.from('reviews').select(FIELDS).eq('review_status', 'approved').in('registered_business_location_id', allIds),
        supabase.from('reviews').select(FIELDS).eq('review_status', 'approved').in('unclaimed_business_location_id', allIds),
        supabase.from('reviews').select(FIELDS).eq('review_status', 'approved').in('business_id', allIds),
        supabase.from('registered_business_locations').select('id, instagram_url, facebook_url, tiktok_url').in('id', allIds),
        supabase.from('business_locations').select('id, instagram_url, facebook_url, tiktok_url').in('id', allIds),
      ]);
      const socialMap: Record<string, { instagram_url?: string | null; facebook_url?: string | null; tiktok_url?: string | null }> = {};
      [...(socialRegistered.data || []), ...(socialLegacy.data || [])].forEach((s: any) => {
        if (s.id) socialMap[s.id] = { instagram_url: s.instagram_url, facebook_url: s.facebook_url, tiktok_url: s.tiktok_url };
      });
      const ratingsData = [
        ...(rRegistered.data || []),
        ...(rUnclaimed.data || []),
        ...(rLegacy.data || []),
      ];

      const ratingMap: Record<string, { sum: number; count: number; byType: Record<string, { sum: number; count: number }> }> = {};
      ratingsData.forEach((r: any) => {
        const id = r.registered_business_location_id || r.unclaimed_business_location_id || r.business_id;
        if (!id) return;
        if (!ratingMap[id]) ratingMap[id] = { sum: 0, count: 0, byType: {} };
        ratingMap[id].sum += r.overall_rating || 0;
        ratingMap[id].count += 1;
        const rt = r.review_type || 'unknown';
        if (!ratingMap[id].byType[rt]) ratingMap[id].byType[rt] = { sum: 0, count: 0 };
        ratingMap[id].byType[rt].sum += r.overall_rating || 0;
        ratingMap[id].byType[rt].count += 1;
      });

      const MANAGEMENT_TYPES = ['booking_not_completed', 'quote_request', 'customer_service', 'problem_before_service'];

      let locationsWithRatings = allLocations.map(loc => {
        // Use loc.id as key — ratings are keyed by the location ID (registered_business_location_id / unclaimed_business_location_id)
        const rid = loc.id;
        const r = ratingMap[rid];
        const byType = r?.byType || {};

        const serviceData = byType['service_used'];
        const service_avg = serviceData && serviceData.count > 0 ? Math.round((serviceData.sum / serviceData.count) * 10) / 10 : 0;

        let mgmtSum = 0, mgmtCount = 0;
        MANAGEMENT_TYPES.forEach(t => {
          if (byType[t]) { mgmtSum += byType[t].sum; mgmtCount += byType[t].count; }
        });
        const management_avg = mgmtCount > 0 ? Math.round((mgmtSum / mgmtCount) * 10) / 10 : 0;

        return {
          ...loc,
          avg_rating: r && r.count > 0 ? Math.round((r.sum / r.count) * 10) / 10 : 0,
          review_count: r?.count || 0,
          service_avg_rating: service_avg,
          service_review_count: serviceData?.count || 0,
          management_avg_rating: management_avg,
          management_review_count: mgmtCount,
          _byTypeRating: byType,
        };
      });

      // Apply client-side rating filters
      if (filters.minRating > 0) {
        locationsWithRatings = locationsWithRatings.filter(loc => (loc.avg_rating || 0) >= filters.minRating);
      }
      if ((filters.minServiceUsedRating || 0) > 0) {
        locationsWithRatings = locationsWithRatings.filter(loc => {
          const t = (loc as any)._byTypeRating['service_used'];
          return t && t.count > 0 && (t.sum / t.count) >= (filters.minServiceUsedRating || 0);
        });
      }
      if ((filters.minBookingRating || 0) > 0) {
        locationsWithRatings = locationsWithRatings.filter(loc => {
          const t = (loc as any)._byTypeRating['booking_not_completed'];
          return t && t.count > 0 && (t.sum / t.count) >= (filters.minBookingRating || 0);
        });
      }
      if ((filters.minQuoteRating || 0) > 0) {
        locationsWithRatings = locationsWithRatings.filter(loc => {
          const t = (loc as any)._byTypeRating['quote_request'];
          return t && t.count > 0 && (t.sum / t.count) >= (filters.minQuoteRating || 0);
        });
      }
      if ((filters.minCustomerServiceRating || 0) > 0) {
        locationsWithRatings = locationsWithRatings.filter(loc => {
          const t = (loc as any)._byTypeRating['customer_service'];
          return t && t.count > 0 && (t.sum / t.count) >= (filters.minCustomerServiceRating || 0);
        });
      }
      if ((filters.minProblemRating || 0) > 0) {
        locationsWithRatings = locationsWithRatings.filter(loc => {
          const t = (loc as any)._byTypeRating['problem_before_service'];
          return t && t.count > 0 && (t.sum / t.count) >= (filters.minProblemRating || 0);
        });
      }

      // Ordina: claimed > rating > alfabetico
      locationsWithRatings.sort((a, b) => {
        const aIsClaimed = a.is_claimed ? 1 : 0;
        const bIsClaimed = b.is_claimed ? 1 : 0;
        if (aIsClaimed !== bIsClaimed) return bIsClaimed - aIsClaimed;

        const aRating = a.avg_rating || 0;
        const bRating = b.avg_rating || 0;
        if (aRating !== bRating) return bRating - aRating;

        const aName = a.name || a.business?.name || '';
        const bName = b.name || b.business?.name || '';
        return aName.localeCompare(bName);
      });

      setLocations(locationsWithRatings.map(loc => ({
        ...loc,
        ...(socialMap[loc.id] || {}),
      })));
      await loadFavoriteIds(locationsWithRatings);
    } catch (error) {
      console.error('Error during search:', error);
      setLocations([]);
    } finally {
      setLoading(false);
    }
  };

  const sortedLocations = useMemo(() => {
    const sorted = [...locations];
    switch (sortBy) {
      case 'rating_desc':
        return sorted.sort((a, b) => (b.avg_rating || 0) - (a.avg_rating || 0));
      case 'rating_asc':
        return sorted.sort((a, b) => (a.avg_rating || 0) - (b.avg_rating || 0));
      case 'reviews_desc':
        return sorted.sort((a, b) => (b.review_count || 0) - (a.review_count || 0));
      case 'name_asc':
        return sorted.sort((a, b) => (a.name || a.business?.name || '').localeCompare(b.name || b.business?.name || ''));
      case 'name_desc':
        return sorted.sort((a, b) => (b.name || b.business?.name || '').localeCompare(a.name || a.business?.name || ''));
      case 'verified_first':
        return sorted.sort((a, b) => Number(b.verification_badge) - Number(a.verification_badge) || Number(b.is_claimed) - Number(a.is_claimed));
      default:
        return sorted;
    }
  }, [locations, sortBy]);

  const handleBackToHome = () => {
    window.history.pushState({}, '', '/');
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Announcement banner */}
      {customization?.announcement_active && customization.announcement_text && (
        <div className="bg-blue-600 text-white text-sm font-medium text-center py-2 px-4">
          {customization.announcement_text}
        </div>
      )}
      {/* Hero */}
      <section
        className="bg-white border-b border-gray-100 relative"
        style={customization?.hero_image_url ? {
          backgroundImage: `url(${customization.hero_image_url})`,
          backgroundSize: 'cover',
          backgroundPosition: 'center',
        } : undefined}
      >
        {customization?.hero_image_url && <div className="absolute inset-0 bg-black/50" />}
        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 md:py-16">
          <button
            onClick={handleBackToHome}
            className={`inline-flex items-center gap-2 ${customization?.hero_image_url ? 'text-gray-300 hover:text-white' : 'text-gray-500 hover:text-gray-900'} text-sm font-medium mb-6 transition-colors`}
          >
            <ArrowLeft className="w-4 h-4" />
            Torna alla home
          </button>
          <div className={`inline-flex items-center gap-2 ${customization?.hero_image_url ? 'bg-blue-500/30 text-blue-100' : 'bg-blue-50 text-blue-700'} text-xs font-semibold px-3 py-1.5 rounded-full mb-4`}>
            <div className="w-1.5 h-1.5 bg-blue-500 rounded-full"></div>
            Attivita in tutta Italia
          </div>
          <h1 className={`text-4xl md:text-5xl lg:text-6xl font-extrabold leading-tight mb-4 ${customization?.hero_image_url ? 'text-white' : 'text-gray-900'}`}>
            {customization?.hero_title || 'Cerca Attivita'}
          </h1>
          <p className={`text-lg mb-8 ${customization?.hero_image_url ? 'text-gray-200' : 'text-gray-500'}`}>
            {customization?.hero_subtitle || 'Trova le migliori attivita locali verificate nella tua zona'}
          </p>
          <AdvancedSearch
            onSearch={applyFilters}
            isLoading={loading}
            initialFilters={initialFilters || undefined}
          />
        </div>
      </section>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="mb-6 bg-gradient-to-r from-blue-50 to-green-50 border-l-4 border-blue-600 rounded-lg p-4">
          <p className="text-sm text-gray-700">
            I dati delle attività sono forniti da{' '}
            <a
              href="https://www.openstreetmap.org"
              target="_blank"
              rel="noopener noreferrer"
              className="text-blue-600 hover:text-blue-800 font-semibold underline"
            >
              OpenStreetMap
            </a>
            {' '}e{' '}
            <a
              href="https://www.geofabrik.de"
              target="_blank"
              rel="noopener noreferrer"
              className="text-blue-600 hover:text-blue-800 font-semibold underline"
            >
              Geofabrik
            </a>
            , rilasciati sotto licenza{' '}
            <a
              href="https://www.openstreetmap.org/copyright"
              target="_blank"
              rel="noopener noreferrer"
              className="text-blue-600 hover:text-blue-800 font-semibold underline"
            >
              ODbL
            </a>
            .
          </p>
        </div>

        {hasSearched && !loading && (
          <>
            <div className="mb-6 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 bg-gradient-to-r from-blue-50 to-sky-50 rounded-2xl shadow-lg p-6 border border-blue-100">
              <div>
                <h2 className="text-2xl font-bold text-gray-900">Risultati della Ricerca</h2>
                <p className="text-gray-500 mt-1">Trova le sedi delle attività che corrispondono ai tuoi criteri</p>
              </div>
              <div className="flex items-center gap-3 flex-wrap">
                {/* Sort selector */}
                <div className="flex items-center gap-2 bg-white border border-gray-200 rounded-xl px-3 py-2 shadow-sm">
                  <ArrowUpDown className="w-4 h-4 text-gray-400 flex-shrink-0" />
                  <select
                    value={sortBy}
                    onChange={e => setSortBy(e.target.value as SortOption)}
                    className="text-sm font-medium text-gray-700 bg-transparent border-none outline-none cursor-pointer pr-1"
                  >
                    {SORT_OPTIONS.map(o => (
                      <option key={o.value} value={o.value}>{o.label}</option>
                    ))}
                  </select>
                </div>
                <div className="bg-gradient-to-br from-blue-100 to-blue-200 px-5 py-3 rounded-xl border border-blue-300 shadow-sm text-center">
                  <div className="text-3xl font-bold text-blue-700">{locations.length}</div>
                  <div className="text-xs text-blue-900 font-semibold mt-0.5">
                    {locations.length === 1 ? 'Sede' : 'Sedi'}
                  </div>
                </div>
              </div>
            </div>
            {locations.some(loc => loc.is_claimed) && (
              <div className="mb-6 bg-gradient-to-r from-green-50 to-emerald-50 border-l-4 border-green-500 rounded-lg p-4">
                <p className="text-sm text-green-900 font-medium flex items-center gap-2">
                  <CheckCircle className="w-4 h-4 text-green-600" />
                  Le attività rivendicate dai proprietari sono mostrate in cima ai risultati
                </p>
              </div>
            )}
          </>
        )}

        {loading ? (
          <div className="text-center py-12 bg-white rounded-lg shadow-sm" aria-busy="true" aria-live="polite">
            <div className="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mb-4"></div>
            <p className="text-gray-700 text-lg font-medium">Ricerca in corso...</p>
            <p className="text-gray-500 text-sm mt-2">Stiamo cercando le migliori attività per te</p>
          </div>
        ) : !hasSearched ? (
          <div className="text-center py-16 bg-white rounded-xl border border-gray-100 shadow-sm">
            <div className="w-16 h-16 bg-blue-50 rounded-2xl flex items-center justify-center mx-auto mb-4">
              <Search className="w-8 h-8 text-blue-400" />
            </div>
            <h3 className="text-lg font-semibold text-gray-900 mb-2">Cerca un'attività</h3>
            <p className="text-gray-500 max-w-sm mx-auto">Usa i filtri qui sopra per trovare attività, negozi e servizi nella tua zona</p>
          </div>
        ) : locations.length === 0 ? (
          <div className="text-center py-16 bg-white rounded-xl border border-gray-100 shadow-sm">
            <div className="w-16 h-16 bg-amber-50 rounded-2xl flex items-center justify-center mx-auto mb-4">
              <MapPin className="w-8 h-8 text-amber-400" />
            </div>
            <h3 className="text-lg font-semibold text-gray-900 mb-2">Nessuna sede trovata</h3>
            <p className="text-gray-500 mb-4 max-w-sm mx-auto">Non abbiamo trovato attività con questi criteri. Prova ad ampliare la ricerca.</p>
            <div className="flex flex-col sm:flex-row gap-2 justify-center">
              <button
                onClick={() => window.scrollTo({ top: 0, behavior: 'smooth' })}
                className="inline-flex items-center gap-2 bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors"
              >
                <SlidersHorizontal className="w-4 h-4" />
                Modifica i filtri
              </button>
              <a
                href="/"
                className="inline-flex items-center gap-2 border border-gray-300 hover:bg-gray-50 text-gray-700 px-4 py-2 rounded-lg text-sm font-medium transition-colors"
              >
                Torna alla home
              </a>
            </div>
          </div>
        ) : (
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            {sortedLocations.map((location) => (
              <LocationCard
                key={location.id}
                location={location}
                initialIsFavorite={favoriteIds.has(location.id)}
                onFavoriteToggle={(id, isFav) => {
                  setFavoriteIds(prev => {
                    const next = new Set(prev);
                    if (isFav) next.add(id); else next.delete(id);
                    try { sessionStorage.setItem('searchFavoriteIds', JSON.stringify([...next])); } catch {}
                    return next;
                  });
                }}
              />
            ))}
          </div>
        )}

        {hasSearched && locations.length > 0 && (
          <div className="mt-8 bg-gradient-to-r from-blue-50 to-green-50 border-l-4 border-blue-600 rounded-lg p-4">
            <p className="text-sm text-gray-700">
              I dati delle attività sono forniti da{' '}
              <a
                href="https://www.openstreetmap.org"
                target="_blank"
                rel="noopener noreferrer"
                className="text-blue-600 hover:text-blue-800 font-semibold underline"
              >
                OpenStreetMap
              </a>
              {' '}e{' '}
              <a
                href="https://www.geofabrik.de"
                target="_blank"
                rel="noopener noreferrer"
                className="text-blue-600 hover:text-blue-800 font-semibold underline"
              >
                Geofabrik
              </a>
              , rilasciati sotto licenza{' '}
              <a
                href="https://www.openstreetmap.org/copyright"
                target="_blank"
                rel="noopener noreferrer"
                className="text-blue-600 hover:text-blue-800 font-semibold underline"
              >
                ODbL
              </a>
              .
            </p>
          </div>
        )}
      </div>
    </div>
  );
}
