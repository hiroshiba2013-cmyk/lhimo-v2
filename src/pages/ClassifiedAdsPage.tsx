import { useState, useEffect, useMemo } from 'react';
import { Plus, Search, MapPin, Euro, Calendar, ArrowUpDown } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import { ClassifiedAdCard } from '../components/classifieds/ClassifiedAdCard';
import { ClassifiedAdForm } from '../components/classifieds/ClassifiedAdForm';
import { ItalianCityProvinceSelect } from '../components/common/ItalianCityProvinceSelect';
import { ITALIAN_REGIONS } from '../lib/cities';

interface Category {
  id: string;
  name: string;
  slug: string;
  icon: string;
}

interface ClassifiedAd {
  id: string;
  user_id: string;
  title: string;
  description: string;
  price: number | null;
  location: string;
  city: string;
  province: string;
  region: string;
  images: string[] | null;
  category_id: string;
  family_member_id: string | null;
  views_count: number;
  created_at: string;
  ad_type: 'sell' | 'buy' | 'gift';
  profiles: {
    full_name: string;
    nickname: string | null;
    avatar_url: string | null;
  };
  family_member?: {
    nickname: string;
    avatar_url: string | null;
  } | null;
  classified_categories: {
    name: string;
    icon: string;
  };
}

export function ClassifiedAdsPage() {
  const { user, profile } = useAuth();
  const [ads, setAds] = useState<ClassifiedAd[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [loading, setLoading] = useState(true);
  // Filters
  const urlParams = new URLSearchParams(window.location.search);
  const actionParam = urlParams.get('action');
  const [showCreateForm, setShowCreateForm] = useState(actionParam === 'create');

  const typeParam = urlParams.get('type') as 'sell' | 'buy' | 'gift' | null;
  const [adType, setAdType] = useState<'all' | 'sell' | 'buy' | 'gift'>(typeParam || 'all');
  const [selectedCategory, setSelectedCategory] = useState<string>('');
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedRegion, setSelectedRegion] = useState('');
  const [selectedProvince, setSelectedProvince] = useState('');
  const [selectedCity, setSelectedCity] = useState('');
  const [minPrice, setMinPrice] = useState('');
  const [maxPrice, setMaxPrice] = useState('');
  const [sortBy, setSortBy] = useState<string>('recent_desc');

  useEffect(() => {
    loadCategories();
    loadAds();
  }, [adType, selectedCategory, searchQuery, selectedRegion, selectedProvince, selectedCity, minPrice, maxPrice]);

  const loadCategories = async () => {
    try {
      const { data, error } = await supabase
        .from('classified_categories')
        .select('*')
        .order('name');

      if (error) throw error;
      setCategories(data || []);
    } catch (error) {
      console.error('Error loading categories:', error);
    }
  };

  const loadAds = async () => {
    try {
      setLoading(true);
      let query = supabase
        .from('classified_ads')
        .select(`
          *,
          classified_categories!category_id(name, icon)
        `)
        .eq('status', 'active')
        .eq('approval_status', 'approved')
        .order('created_at', { ascending: false });

      if (adType !== 'all') {
        query = query.eq('ad_type', adType);
      }

      if (selectedCategory) {
        query = query.eq('category_id', selectedCategory);
      }

      if (searchQuery) {
        query = query.or(`title.ilike.%${searchQuery}%,description.ilike.%${searchQuery}%`);
      }

      if (selectedRegion) {
        query = query.ilike('region', `%${selectedRegion}%`);
      }

      if (selectedProvince) {
        query = query.ilike('province', `%${selectedProvince}%`);
      }

      if (selectedCity) {
        query = query.ilike('city', `%${selectedCity}%`);
      }

      if (minPrice) {
        query = query.gte('price', parseFloat(minPrice));
      }

      if (maxPrice) {
        query = query.lte('price', parseFloat(maxPrice));
      }

      const { data, error } = await query;

      if (error) throw error;

      if (data && data.length > 0) {
        const userIds = [...new Set(data.map((ad: any) => ad.user_id))];
        const familyMemberIds = [...new Set(data.map((ad: any) => ad.family_member_id).filter(Boolean))];

        const { data: profilesData, error: profilesError } = await supabase
          .from('profiles')
          .select('id, full_name, nickname, avatar_url')
          .in('id', userIds);

        if (profilesError) {
          console.error('Error loading profiles:', profilesError);
        }

        let familyMembersData: any[] = [];
        if (familyMemberIds.length > 0) {
          const { data: fmData, error: fmError } = await supabase
            .from('customer_family_members')
            .select('id, nickname, avatar_url')
            .in('id', familyMemberIds);

          if (fmError) {
            console.error('Error loading family members:', fmError);
          } else {
            familyMembersData = fmData || [];
          }
        }

        const profilesMap = new Map(profilesData?.map(p => [p.id, p]) || []);
        const familyMembersMap = new Map(familyMembersData.map(fm => [fm.id, fm]));

        const adsWithProfiles = data.map((ad: any) => {
          const profile = profilesMap.get(ad.user_id);
          const familyMember = ad.family_member_id ? familyMembersMap.get(ad.family_member_id) : null;

          return {
            ...ad,
            profiles: profile
              ? { full_name: profile.full_name, nickname: profile.nickname, avatar_url: profile.avatar_url }
              : { full_name: 'Utente', nickname: null, avatar_url: null },
            family_member: familyMember || null
          };
        });

        setAds(adsWithProfiles);
      } else {
        setAds([]);
      }
    } catch (error) {
      console.error('Error loading ads:', error);
    } finally {
      setLoading(false);
    }
  };

  const sortedAds = useMemo(() => {
    const arr = [...ads];
    switch (sortBy) {
      case 'recent_desc': return arr.sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());
      case 'recent_asc': return arr.sort((a, b) => new Date(a.created_at).getTime() - new Date(b.created_at).getTime());
      case 'price_asc': return arr.sort((a, b) => (a.price ?? 0) - (b.price ?? 0));
      case 'price_desc': return arr.sort((a, b) => (b.price ?? 0) - (a.price ?? 0));
      case 'name_asc': return arr.sort((a, b) => a.title.localeCompare(b.title, 'it'));
      case 'views_desc': return arr.sort((a, b) => (b.views_count || 0) - (a.views_count || 0));
      default: return arr;
    }
  }, [ads, sortBy]);

  const handleAdCreated = () => {
    setShowCreateForm(false);
    loadAds();
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Hero */}
      <section className="bg-white border-b border-gray-100">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 md:py-20">
          <div className="flex flex-col md:flex-row md:items-end md:justify-between gap-6">
            <div>
              <div className="inline-flex items-center gap-2 bg-blue-50 text-blue-700 text-xs font-semibold px-3 py-1.5 rounded-full mb-6">
                <div className="w-1.5 h-1.5 bg-blue-500 rounded-full"></div>
                Vendi, compra e regala
              </div>
              <h1 className="text-4xl md:text-5xl lg:text-6xl font-extrabold text-gray-900 leading-tight mb-3">Annunci</h1>
              <p className="text-lg text-gray-500">Trova quello che cerchi o pubblica il tuo annuncio</p>
            </div>
            {user && (
              <button
                onClick={() => setShowCreateForm(true)}
                className="inline-flex items-center gap-2 bg-blue-600 hover:bg-blue-700 text-white px-7 py-3.5 rounded-xl font-bold text-base transition-colors shadow-sm hover:shadow-md"
              >
                <Plus className="w-5 h-5" />
                Pubblica Annuncio
              </button>
            )}
          </div>
        </div>
      </section>

      <div className="max-w-7xl mx-auto px-4 py-8">

        {/* Ad Type Tabs */}
        <div className="bg-white rounded-lg shadow-sm p-4 mb-6">
          <div className="grid grid-cols-2 md:grid-cols-4 gap-2">
            <button
              onClick={() => setAdType('all')}
              className={`px-6 py-3 rounded-lg font-medium transition-all ${
                adType === 'all'
                  ? 'bg-gray-800 text-white'
                  : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
              }`}
            >
              Tutti gli annunci
            </button>
            <button
              onClick={() => setAdType('sell')}
              className={`px-6 py-3 rounded-lg font-medium transition-all ${
                adType === 'sell'
                  ? 'bg-blue-600 text-white'
                  : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
              }`}
            >
              💰 Vendo
            </button>
            <button
              onClick={() => setAdType('buy')}
              className={`px-6 py-3 rounded-lg font-medium transition-all ${
                adType === 'buy'
                  ? 'bg-green-600 text-white'
                  : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
              }`}
            >
              🔍 Cerco
            </button>
            <button
              onClick={() => setAdType('gift')}
              className={`px-6 py-3 rounded-lg font-medium transition-all ${
                adType === 'gift'
                  ? 'bg-orange-600 text-white'
                  : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
              }`}
            >
              🎁 Regalo
            </button>
          </div>
        </div>

        {/* Filters */}
        <div className="bg-white rounded-lg shadow-sm p-6 mb-8">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
            {/* Search */}
            <div className="lg:col-span-2">
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Cerca
              </label>
              <div className="relative">
                <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                <input
                  type="text"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  placeholder="Cerca annunci..."
                  className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>
            </div>

            {/* Category */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Categoria
              </label>
              <select
                value={selectedCategory}
                onChange={(e) => setSelectedCategory(e.target.value)}
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              >
                <option value="">Tutte</option>
                {categories.map((category) => (
                  <option key={category.id} value={category.id}>
                    {category.name}
                  </option>
                ))}
              </select>
            </div>

            {/* Price Range */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Prezzo
              </label>
              <div className="flex gap-2">
                <input
                  type="number"
                  value={minPrice}
                  onChange={(e) => setMinPrice(e.target.value)}
                  placeholder="Min"
                  className="w-1/2 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
                <input
                  type="number"
                  value={maxPrice}
                  onChange={(e) => setMaxPrice(e.target.value)}
                  placeholder="Max"
                  className="w-1/2 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>
            </div>
          </div>

          <div className="mt-6 space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1.5">Regione</label>
              <select
                value={selectedRegion}
                onChange={(e) => { setSelectedRegion(e.target.value); setSelectedProvince(''); setSelectedCity(''); }}
                className="w-full px-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-100 focus:border-blue-500 text-sm bg-white"
              >
                <option value="">Tutte le regioni</option>
                {ITALIAN_REGIONS.map(r => <option key={r} value={r}>{r}</option>)}
              </select>
            </div>
            <ItalianCityProvinceSelect
              province={selectedProvince}
              city={selectedCity}
              region={selectedRegion}
              onProvinceChange={(prov) => { setSelectedProvince(prov); setSelectedCity(''); }}
              onCityChange={setSelectedCity}
            />
          </div>

          {/* Clear Filters */}
          {(adType !== 'all' || selectedCategory || searchQuery || selectedRegion || selectedProvince || selectedCity || minPrice || maxPrice) && (
            <button
              onClick={() => {
                setAdType('all');
                setSelectedCategory('');
                setSearchQuery('');
                setSelectedRegion('');
                setSelectedProvince('');
                setSelectedCity('');
                setMinPrice('');
                setMaxPrice('');
              }}
              className="mt-4 text-blue-600 hover:text-blue-700 font-medium"
            >
              Cancella filtri
            </button>
          )}
        </div>

        {/* Sort + Count bar */}
        {!loading && (
          <div className="flex items-center justify-between mb-4">
            <p className="text-sm text-gray-500">{ads.length} annunci trovati</p>
            <div className="flex items-center gap-2">
              <ArrowUpDown className="w-4 h-4 text-gray-400" />
              <select
                value={sortBy}
                onChange={(e) => setSortBy(e.target.value)}
                className="text-sm border border-gray-300 rounded-lg px-3 py-1.5 focus:ring-2 focus:ring-blue-500 focus:border-transparent bg-white"
              >
                <option value="recent_desc">Dal più recente</option>
                <option value="recent_asc">Dal meno recente</option>
                <option value="price_asc">Prezzo crescente</option>
                <option value="price_desc">Prezzo decrescente</option>
                <option value="name_asc">Titolo A→Z</option>
                <option value="views_desc">Più visti</option>
              </select>
            </div>
          </div>
        )}

        {/* Ads Grid */}
        {loading ? (
          <div className="text-center py-12">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
          </div>
        ) : ads.length === 0 ? (
          <div className="text-center py-12 bg-white rounded-lg">
            <Calendar className="w-16 h-16 text-gray-400 mx-auto mb-4" />
            <h3 className="text-xl font-semibold text-gray-900 mb-2">
              Nessun annuncio trovato
            </h3>
            <p className="text-gray-600 mb-6">
              Prova a modificare i filtri o sii il primo a pubblicare un annuncio!
            </p>
            {user && (
              <button
                onClick={() => setShowCreateForm(true)}
                className="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors"
              >
                Pubblica Annuncio
              </button>
            )}
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {sortedAds.map((ad) => (
              <ClassifiedAdCard key={ad.id} ad={ad} />
            ))}
          </div>
        )}
      </div>

      {/* Create Ad Modal */}
      {showCreateForm && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg max-w-2xl w-full max-h-[90vh] overflow-y-auto">
            <ClassifiedAdForm
              onSuccess={handleAdCreated}
              onCancel={() => setShowCreateForm(false)}
            />
          </div>
        </div>
      )}
    </div>
  );
}
