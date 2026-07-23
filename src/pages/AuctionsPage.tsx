import { useState, useEffect } from 'react';
import { Plus, Search, Filter } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import { useLanguage } from '../contexts/LanguageContext';
import { useItalianLocations } from '../hooks/useItalianLocations';
import AuctionCard from '../components/auctions/AuctionCard';
import AuctionForm from '../components/auctions/AuctionForm';
import { ItalianCityProvinceSelect } from '../components/common/ItalianCityProvinceSelect';

const categories = [
  'Tutte',
  'Elettronica',
  'Motori',
  'Casa e Giardino',
  'Moda e Accessori',
  'Hobby e Tempo Libero',
  'Infanzia',
  'Libri',
  'Film',
  'Musica',
  'Attrezzature Professionali',
  'Aste Solidali',
  'Altro'
];

export default function AuctionsPage() {
  const { regions } = useItalianLocations();
  const { user } = useAuth();
  const { t } = useLanguage();
  const [auctions, setAuctions] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [showCreateForm, setShowCreateForm] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('Tutte');
  const [showFilters, setShowFilters] = useState(false);

  const [filters, setFilters] = useState({
    city: '',
    province: '',
    region: '',
    status: 'active'
  });

  useEffect(() => {
    loadAuctions();
  }, [filters, selectedCategory]);

  const loadAuctions = async () => {
    setLoading(true);
    try {
      const now = new Date().toISOString();
      let query = supabase
        .from('auctions')
        .select(`
          *,
          user:user_id(full_name, nickname),
          bid_count:auction_bids(count)
        `)
        .eq('approval_status', 'approved')
        .order('created_at', { ascending: false });

      if (filters.status === 'active') {
        query = query.gt('ends_at', now);
      } else {
        query = query.lte('ends_at', now);
      }

      if (selectedCategory !== 'Tutte') {
        query = query.eq('category', selectedCategory);
      }

      if (filters.city) {
        query = query.ilike('city', `%${filters.city}%`);
      }

      if (filters.province) {
        query = query.ilike('province', `%${filters.province}%`);
      }

      if (filters.region) {
        query = query.ilike('region', `%${filters.region}%`);
      }

      const { data, error } = await query;

      if (error) throw error;

      const auctionsWithBidCount = (data || []).map(auction => ({
        ...auction,
        bid_count: auction.bid_count?.[0]?.count || 0
      }));

      setAuctions(auctionsWithBidCount);
    } catch (err: any) {
      console.error('Error loading auctions:', err);
    } finally {
      setLoading(false);
    }
  };

  const filteredAuctions = auctions.filter(auction => {
    const term = searchTerm.toLowerCase();
    return (
      (auction.title || '').toLowerCase().includes(term) ||
      (auction.description || '').toLowerCase().includes(term)
    );
  });

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Hero */}
      <section className="bg-white border-b border-gray-100">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 md:py-20">
          <div className="flex flex-col md:flex-row md:items-end md:justify-between gap-6">
            <div>
              <div className="inline-flex items-center gap-2 bg-orange-50 text-orange-700 text-xs font-semibold px-3 py-1.5 rounded-full mb-6">
                <div className="w-1.5 h-1.5 bg-orange-500 rounded-full"></div>
                Aste in corso
              </div>
              <h1 className="text-4xl md:text-5xl lg:text-6xl font-extrabold text-gray-900 leading-tight mb-3">Aste</h1>
              <p className="text-lg text-gray-500">Partecipa alle aste e trova occasioni uniche</p>
            </div>
            {user && (
              <button
                onClick={() => setShowCreateForm(true)}
                className="inline-flex items-center gap-2 bg-blue-600 hover:bg-blue-700 text-white px-7 py-3.5 rounded-xl font-bold text-base transition-colors shadow-sm hover:shadow-md"
              >
                <Plus className="w-5 h-5" />
                Crea Asta
              </button>
            )}
          </div>
        </div>
      </section>

      <div className="max-w-7xl mx-auto px-4 py-8">

        {showCreateForm && (
          <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50 overflow-y-auto">
            <div className="bg-white rounded-lg max-w-2xl w-full p-6 my-8">
              <h2 className="text-2xl font-bold text-gray-900 mb-6">Crea Nuova Asta</h2>
              <AuctionForm
                onSuccess={() => {
                  setShowCreateForm(false);
                  loadAuctions();
                }}
                onCancel={() => setShowCreateForm(false)}
              />
            </div>
          </div>
        )}

        <div className="bg-white rounded-lg shadow-sm p-6 mb-6">
          <div className="flex flex-col md:flex-row gap-4">
            <div className="flex-1 relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-5 h-5" />
              <input
                type="text"
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                placeholder="Cerca aste..."
                className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>
            <button
              onClick={() => setShowFilters(!showFilters)}
              className="flex items-center gap-2 px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50"
            >
              <Filter className="w-5 h-5" />
              Filtri
            </button>
          </div>

          {showFilters && (
            <div className="mt-4 pt-4 border-t border-gray-200 space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1.5">Regione</label>
                <select
                  value={filters.region}
                  onChange={(e) => setFilters(prev => ({ ...prev, region: e.target.value, province: '', city: '' }))}
                  className="w-full px-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-100 focus:border-blue-500 text-sm bg-white"
                >
                  <option value="">Tutte le regioni</option>
                  {regions.map(r => <option key={r} value={r}>{r}</option>)}
                </select>
              </div>
              <ItalianCityProvinceSelect
                province={filters.province}
                city={filters.city}
                region={filters.region}
                onProvinceChange={(prov) => setFilters(prev => ({ ...prev, province: prov, city: '' }))}
                onCityChange={(c) => setFilters(prev => ({ ...prev, city: c }))}
              />
            </div>
          )}

          <div className="mt-4 grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1.5">Categoria</label>
              <select
                value={selectedCategory}
                onChange={(e) => setSelectedCategory(e.target.value)}
                className="w-full px-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-100 focus:border-blue-500 text-sm bg-white"
              >
                {categories.map(cat => (
                  <option key={cat} value={cat}>{cat}</option>
                ))}
              </select>
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1.5">Stato</label>
              <select
                value={filters.status}
                onChange={(e) => setFilters({ ...filters, status: e.target.value })}
                className="w-full px-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-100 focus:border-blue-500 text-sm bg-white"
              >
                <option value="active">Attive</option>
                <option value="completed">Concluse</option>
              </select>
            </div>
          </div>
        </div>

        {loading ? (
          <div className="flex items-center justify-center py-12">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
          </div>
        ) : filteredAuctions.length === 0 ? (
          <div className="bg-white rounded-lg shadow-sm p-12 text-center">
            <p className="text-gray-600 text-lg">Nessuna asta trovata</p>
            {user && (
              <button
                onClick={() => setShowCreateForm(true)}
                className="mt-4 text-blue-600 hover:underline"
              >
                Crea la prima asta
              </button>
            )}
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {filteredAuctions.map(auction => (
              <AuctionCard key={auction.id} auction={auction} />
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
