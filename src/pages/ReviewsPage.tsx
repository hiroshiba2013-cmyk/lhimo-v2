import { useState, useEffect } from 'react';
import { Star, Search, Filter, ChevronDown, MapPin, Calendar, ThumbsUp, ThumbsDown, Clock, CheckCircle } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import { ReviewCard } from '../components/reviews/ReviewCard';
import { CategoryHierarchySelect } from '../components/common/CategoryHierarchySelect';

type SortOption = 'newest' | 'oldest' | 'highest' | 'lowest';
type FilterType = 'all' | 'service_used' | 'booking_not_completed' | 'quote_request' | 'customer_service' | 'problem_before_service';

interface ReviewWithBusiness {
  id: string;
  title: string;
  content: string;
  rating: number;
  overall_rating: number;
  review_status: string;
  review_type: string;
  created_at: string;
  customer_id: string;
  family_member_id: string | null;
  points_awarded: number;
  proof_image_url: string | null;
  proof_documents: string[] | null;
  price_rating: number | null;
  service_rating: number | null;
  quality_rating: number | null;
  booking_management_rating: number | null;
  reliability_rating: number | null;
  organization_rating: number | null;
  experience_rating: number | null;
  booking_gestione_prenotazione: number | null;
  business_type: string | null;
  business_id: string | null;
  business_location_id: string | null;
  imported_business_id: string | null;
  user_added_business_id: string | null;
  unclaimed_business_location_id: string | null;
  business_name?: string;
  business_city?: string;
  reviewer_name?: string;
}

const TYPE_LABELS: Record<string, string> = {
  all: 'Tutti i tipi',
  service_used: 'Servizio Fruito',
  booking_not_completed: 'Prenotazione Non Completata',
  quote_request: 'Richiesta Preventivo',
  customer_service: 'Assistenza Clienti',
  problem_before_service: 'Problema Pre-Servizio',
};

const TYPE_COLORS: Record<string, string> = {
  service_used: 'bg-emerald-100 text-emerald-800',
  booking_not_completed: 'bg-red-100 text-red-800',
  quote_request: 'bg-blue-100 text-blue-800',
  customer_service: 'bg-teal-100 text-teal-800',
  problem_before_service: 'bg-amber-100 text-amber-800',
};

function StarDisplay({ value }: { value: number }) {
  return (
    <div className="flex items-center gap-0.5">
      {[1, 2, 3, 4, 5].map(i => (
        <Star
          key={i}
          className={`w-4 h-4 ${i <= Math.round(value) ? 'text-amber-400 fill-amber-400' : 'text-gray-200 fill-gray-200'}`}
        />
      ))}
    </div>
  );
}

export function ReviewsPage() {
  const { user, profile } = useAuth();
  const [reviews, setReviews] = useState<ReviewWithBusiness[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [sort, setSort] = useState<SortOption>('newest');
  const [filterType, setFilterType] = useState<FilterType>('all');
  const [stats, setStats] = useState({ total: 0, avg: 0, thisMonth: 0 });
  const [selectedCategory, setSelectedCategory] = useState('');
  const [categories, setCategories] = useState<{ id: string; name: string; parent_id: string | null }[]>([]);

  useEffect(() => {
    supabase.from('business_categories').select('id, name, parent_id').order('name')
      .then(({ data }) => setCategories(data || []));
  }, []);

  useEffect(() => {
    loadReviews();
  }, [sort, filterType]);

  const loadReviews = async () => {
    setLoading(true);
    try {
      let q = supabase
        .from('reviews')
        .select(`
          id, title, content, rating, overall_rating, review_status, review_type,
          created_at, customer_id, family_member_id, points_awarded,
          proof_image_url, proof_documents,
          price_rating, service_rating, quality_rating,
          booking_management_rating, reliability_rating, organization_rating, experience_rating,
          booking_gestione_prenotazione,
          business_type, business_id, business_location_id,
          imported_business_id, user_added_business_id, unclaimed_business_location_id
        `)
        .eq('review_status', 'approved');

      if (filterType !== 'all') {
        q = q.eq('review_type', filterType);
      }

      if (sort === 'newest') q = q.order('created_at', { ascending: false });
      else if (sort === 'oldest') q = q.order('created_at', { ascending: true });
      else if (sort === 'highest') q = q.order('overall_rating', { ascending: false });
      else if (sort === 'lowest') q = q.order('overall_rating', { ascending: true });

      q = q.limit(100);

      const { data, error } = await q;
      if (error) throw error;

      // Enrich with business names and category
      const enriched = await Promise.all((data || []).map(async (r) => {
        let business_name = '';
        let business_city = '';
        let business_category_id: string | null = null;
        try {
          if (r.business_type === 'registered' && r.business_location_id) {
            const { data: loc } = await supabase
              .from('registered_business_locations')
              .select('name, city, category_id')
              .eq('id', r.business_location_id)
              .maybeSingle();
            if (loc) { business_name = loc.name; business_city = loc.city; business_category_id = loc.category_id; }
          } else if (r.business_type === 'unclaimed' && r.unclaimed_business_location_id) {
            const { data: loc } = await supabase
              .from('business_locations')
              .select('name, city, category_id')
              .eq('id', r.unclaimed_business_location_id)
              .maybeSingle();
            if (loc) { business_name = loc.name; business_city = loc.city; business_category_id = loc.category_id; }
          }
        } catch { /* silent */ }
        return { ...r, business_name, business_city, business_category_id };
      }));

      setReviews(enriched);

      // Stats
      const total = enriched.length;
      const avg = total > 0 ? enriched.reduce((s, r) => s + (r.overall_rating || r.rating || 0), 0) / total : 0;
      const month = new Date(); month.setDate(1);
      const thisMonth = enriched.filter(r => new Date(r.created_at) >= month).length;
      setStats({ total, avg: Math.round(avg * 10) / 10, thisMonth });
    } catch (err) {
      console.error('Error loading reviews:', err);
    } finally {
      setLoading(false);
    }
  };

  const filtered = reviews.filter(r => {
    if (selectedCategory && (r as any).business_category_id !== selectedCategory) return false;
    if (!search.trim()) return true;
    const s = search.toLowerCase();
    return (
      (r.title || '').toLowerCase().includes(s) ||
      (r.content || '').toLowerCase().includes(s) ||
      (r.business_name || '').toLowerCase().includes(s) ||
      (r.business_city || '').toLowerCase().includes(s)
    );
  });

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Hero */}
      <div className="bg-white border-b border-gray-100">
        <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
          <div className="flex items-center gap-3 mb-2">
            <div className="bg-amber-100 p-2.5 rounded-xl">
              <Star className="w-6 h-6 text-amber-600 fill-amber-400" />
            </div>
            <h1 className="text-2xl font-bold text-gray-900">Recensioni</h1>
          </div>
          <p className="text-gray-500 mb-8">Tutte le recensioni verificate della community</p>

          {/* Stats */}
          <div className="grid grid-cols-3 gap-4">
            <div className="bg-amber-50 rounded-2xl p-4 border border-amber-100">
              <p className="text-xs font-semibold text-amber-600 uppercase tracking-wide mb-1">Totale</p>
              <p className="text-3xl font-bold text-gray-900">{stats.total}</p>
              <p className="text-xs text-gray-500 mt-0.5">recensioni approvate</p>
            </div>
            <div className="bg-green-50 rounded-2xl p-4 border border-green-100">
              <p className="text-xs font-semibold text-green-600 uppercase tracking-wide mb-1">Media</p>
              <div className="flex items-center gap-2">
                <p className="text-3xl font-bold text-gray-900">{stats.avg || '—'}</p>
                {stats.avg > 0 && <Star className="w-5 h-5 text-amber-400 fill-amber-400" />}
              </div>
              <p className="text-xs text-gray-500 mt-0.5">voto medio</p>
            </div>
            <div className="bg-blue-50 rounded-2xl p-4 border border-blue-100">
              <p className="text-xs font-semibold text-blue-600 uppercase tracking-wide mb-1">Questo mese</p>
              <p className="text-3xl font-bold text-gray-900">{stats.thisMonth}</p>
              <p className="text-xs text-gray-500 mt-0.5">nuove recensioni</p>
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Filters bar */}
        <div className="flex flex-col sm:flex-row gap-3 mb-6">
          <div className="relative flex-1">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <input
              type="text"
              placeholder="Cerca per attività, città o testo..."
              value={search}
              onChange={e => setSearch(e.target.value)}
              className="w-full pl-10 pr-4 py-2.5 border border-gray-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-amber-400 focus:border-transparent bg-white"
            />
          </div>
          <div className="relative">
            <Filter className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <select
              value={filterType}
              onChange={e => setFilterType(e.target.value as FilterType)}
              className="pl-9 pr-8 py-2.5 border border-gray-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-amber-400 bg-white appearance-none cursor-pointer"
            >
              {(Object.keys(TYPE_LABELS) as FilterType[]).map(k => (
                <option key={k} value={k}>{TYPE_LABELS[k]}</option>
              ))}
            </select>
            <ChevronDown className="absolute right-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 pointer-events-none" />
          </div>
          <div className="relative">
            <select
              value={sort}
              onChange={e => setSort(e.target.value as SortOption)}
              className="pl-4 pr-8 py-2.5 border border-gray-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-amber-400 bg-white appearance-none cursor-pointer"
            >
              <option value="newest">Piu recenti</option>
              <option value="oldest">Piu vecchie</option>
              <option value="highest">Voto piu alto</option>
              <option value="lowest">Voto piu basso</option>
            </select>
            <ChevronDown className="absolute right-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 pointer-events-none" />
          </div>
        </div>

        {/* Category filter */}
        <div className="mb-6">
          <CategoryHierarchySelect
            value={selectedCategory}
            onChange={setSelectedCategory}
            categories={categories}
            placeholder="Filtra per categoria attività..."
          />
        </div>

        {/* Results count */}
        {!loading && (
          <p className="text-sm text-gray-500 mb-4">
            {filtered.length} recension{filtered.length === 1 ? 'e' : 'i'} trovate
          </p>
        )}

        {/* List */}
        {loading ? (
          <div className="flex items-center justify-center py-20">
            <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-amber-500"></div>
          </div>
        ) : filtered.length === 0 ? (
          <div className="text-center py-20 bg-white rounded-2xl border border-gray-100">
            <Star className="w-12 h-12 text-gray-200 mx-auto mb-4" />
            <p className="text-gray-500 font-medium">Nessuna recensione trovata</p>
            <p className="text-sm text-gray-400 mt-1">Prova a modificare i filtri di ricerca</p>
          </div>
        ) : (
          <div className="space-y-4">
            {filtered.map(review => (
              <div key={review.id} className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                {/* Business header */}
                {review.business_name && (
                  <div className="flex items-center gap-2 px-5 py-3 bg-gray-50 border-b border-gray-100">
                    <MapPin className="w-3.5 h-3.5 text-gray-400 flex-shrink-0" />
                    <span className="text-sm font-semibold text-gray-700">{review.business_name}</span>
                    {review.business_city && (
                      <span className="text-xs text-gray-400">— {review.business_city}</span>
                    )}
                    {review.review_type && TYPE_COLORS[review.review_type] && (
                      <span className={`ml-auto text-xs font-semibold px-2 py-0.5 rounded-full ${TYPE_COLORS[review.review_type]}`}>
                        {TYPE_LABELS[review.review_type] || review.review_type}
                      </span>
                    )}
                  </div>
                )}
                <div className="p-5">
                  <div className="flex items-start justify-between gap-4 mb-3">
                    <div>
                      <h3 className="font-semibold text-gray-900 mb-1">{review.title || 'Recensione'}</h3>
                      <div className="flex items-center gap-2">
                        <StarDisplay value={review.overall_rating || review.rating || 0} />
                        <span className="text-sm font-bold text-gray-700">{(review.overall_rating || review.rating || 0).toFixed(1)}</span>
                      </div>
                    </div>
                    <div className="text-right flex-shrink-0">
                      <div className="flex items-center gap-1 text-xs text-gray-400">
                        <Calendar className="w-3 h-3" />
                        {new Date(review.created_at).toLocaleDateString('it-IT')}
                      </div>
                      {review.proof_image_url && (
                        <span className="inline-flex items-center gap-1 mt-1 text-xs bg-green-100 text-green-700 px-2 py-0.5 rounded-full font-medium">
                          <CheckCircle className="w-3 h-3" />
                          Verificata
                        </span>
                      )}
                    </div>
                  </div>
                  {review.content && (
                    <p className="text-sm text-gray-600 leading-relaxed">{review.content}</p>
                  )}
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
