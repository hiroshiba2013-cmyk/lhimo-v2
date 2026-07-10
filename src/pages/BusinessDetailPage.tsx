import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import { ReviewForm } from '../components/reviews/ReviewForm';
import { ReviewCard } from '../components/reviews/ReviewCard';
import { FavoriteButton } from '../components/favorites/FavoriteButton';
import ReportButton from '../components/moderation/ReportButton';
import { BusinessLocationPhotos } from '../components/business/BusinessLocationPhotos';
import { MapPin, Phone, Globe, Star, ArrowLeft, CheckCircle, Mail, Tag, Instagram, Facebook } from 'lucide-react';

interface BusinessDetailPageProps {
  businessId: string;
}

export function BusinessDetailPage({ businessId }: BusinessDetailPageProps) {
  const { profile } = useAuth();
  const goBack = () => window.history.back();
  const [loading, setLoading] = useState(true);
  const [business, setBusiness] = useState<any>(null);
  const [reviews, setReviews] = useState<any[]>([]);
  const [showReviewForm, setShowReviewForm] = useState(false);
  const [error, setError] = useState('');

  const isUnclaimed = window.location.pathname.startsWith('/business/unclaimed/');
  const locationId = new URLSearchParams(window.location.search).get('locationId');

  useEffect(() => {
    loadBusiness();
  }, [businessId]);

  const loadBusiness = async () => {
    try {
      setLoading(true);
      setError('');

      if (isUnclaimed) {
        // Try unclaimed_business_locations first (new table)
        const { data: unclaimedData } = await supabase
          .from('unclaimed_business_locations')
          .select('*, category:business_categories(name)')
          .eq('id', businessId)
          .maybeSingle();
        if (unclaimedData) {
          setBusiness({ ...unclaimedData, source: 'unclaimed', address: unclaimedData.street });
          loadReviews(businessId, 'unclaimed_location');
          return;
        }
        // Fallback to legacy business_locations table
        const { data, error: err } = await supabase
          .from('business_locations')
          .select('*, business:businesses(name, category:business_categories(name))')
          .eq('id', businessId)
          .maybeSingle();
        if (err) throw err;
        if (!data) { setError('Attività non trovata'); return; }
        setBusiness({ ...data, source: 'unclaimed' });
        loadReviews(businessId, 'location');
      } else {
        // If locationId is provided, try to fetch that specific registered location
        const targetId = locationId || businessId;
        const { data, error: err } = await supabase
          .from('registered_business_locations')
          .select('*, business:registered_businesses(business_name, category:business_categories(name))')
          .eq('id', targetId)
          .maybeSingle();
        if (err || !data) {
          // Fallback: try by business_id (get first location)
          const { data: byBusiness } = await supabase
            .from('registered_business_locations')
            .select('*, business:registered_businesses(business_name, category:business_categories(name))')
            .eq('business_id', businessId)
            .order('is_primary', { ascending: false })
            .limit(1)
            .maybeSingle();
          if (byBusiness) {
            setBusiness({ ...byBusiness, source: 'registered' });
            loadReviews(byBusiness.id, 'registered');
            return;
          }
          // Final fallback: legacy business_locations table
          const { data: loc, error: locErr } = await supabase
            .from('business_locations')
            .select('*, business:businesses(name, category:business_categories(name))')
            .eq('id', targetId)
            .maybeSingle();
          if (locErr) throw locErr;
          if (!loc) { setError('Attività non trovata'); return; }
          setBusiness({ ...loc, source: 'unclaimed' });
          loadReviews(targetId, 'location');
        } else {
          setBusiness({ ...data, source: 'registered' });
          loadReviews(targetId, 'registered');
        }
      }
    } catch (e: any) {
      setError('Errore nel caricamento');
    } finally {
      setLoading(false);
    }
  };

  const loadReviews = async (id: string, type: string) => {
    try {
      let col: string;
      if (type === 'registered') col = 'registered_business_location_id';
      else if (type === 'unclaimed_location') col = 'unclaimed_business_location_id';
      else col = 'business_location_id';
      const { data } = await supabase
        .from('reviews')
        .select('*, profile:profiles(full_name, nickname)')
        .eq(col, id)
        .eq('status', 'approved')
        .order('created_at', { ascending: false });
      setReviews(data || []);
    } catch {}
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  if (error || !business) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <p className="text-gray-600 mb-4">{error || 'Attività non trovata'}</p>
          <button onClick={goBack} className="text-blue-600 hover:underline flex items-center gap-2 mx-auto">
            <ArrowLeft className="w-4 h-4" />Torna indietro
          </button>
        </div>
      </div>
    );
  }

  const name = business.source === 'registered'
    ? business.business?.business_name || business.location_name || 'Attività'
    : business.business?.name || business.name || 'Attività';
  const category = business.category?.name || business.business?.category?.name || '';
  const city = business.city || '';
  const address = business.address || business.street || '';
  const phone = business.phone || '';
  const email = business.email || '';
  const website = business.website || '';
  const isVerified = business.source === 'registered' || business.is_claimed;
  const instagram_url = business.instagram_url || '';
  const facebook_url = business.facebook_url || '';
  const tiktok_url = business.tiktok_url || '';

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <button
          onClick={goBack}
          className="flex items-center gap-2 text-gray-600 hover:text-gray-900 mb-6 transition-colors"
        >
          <ArrowLeft className="w-4 h-4" />
          Torna indietro
        </button>

        <div className="bg-white rounded-2xl shadow-lg p-8 mb-6">
          <div className="flex items-start justify-between mb-4">
            <div className="flex-1">
              <div className="flex items-center gap-3 mb-2">
                <h1 className="text-3xl font-bold text-gray-900">{name}</h1>
                {isVerified && (
                  <span className="inline-flex items-center gap-1 bg-blue-100 text-blue-700 text-xs font-semibold px-2.5 py-1 rounded-full">
                    <CheckCircle className="w-3.5 h-3.5" />Verificata
                  </span>
                )}
              </div>
              {category && (
                <div className="flex items-center gap-1.5 text-sm text-gray-500 mb-1">
                  <Tag className="w-4 h-4" />{category}
                </div>
              )}
              {city && (
                <div className="flex items-center gap-1.5 text-sm text-gray-500">
                  <MapPin className="w-4 h-4" />{address ? `${address}, ` : ''}{city}
                </div>
              )}
            </div>
            <div className="flex items-center gap-2">
              <FavoriteButton
                type="business"
                itemId={businessId}
                businessColumn={business.source === 'registered' ? 'registered' : 'unclaimed'}
              />
              {profile && <ReportButton entityType="business" entityId={businessId} />}
            </div>
          </div>

          <div className="flex flex-wrap gap-4 mt-4">
            {phone && (
              <a href={`tel:${phone}`} className="flex items-center gap-2 text-blue-600 hover:text-blue-700 text-sm">
                <Phone className="w-4 h-4" />{phone}
              </a>
            )}
            {email && (
              <a href={`mailto:${email}`} className="flex items-center gap-2 text-blue-600 hover:text-blue-700 text-sm">
                <Mail className="w-4 h-4" />{email}
              </a>
            )}
            {website && (
              <a href={website} target="_blank" rel="noopener noreferrer" className="flex items-center gap-2 text-blue-600 hover:text-blue-700 text-sm">
                <Globe className="w-4 h-4" />Sito web
              </a>
            )}
            <div className="flex items-center gap-3 mt-1">
              {instagram_url ? (
                <a href={instagram_url} target="_blank" rel="noopener noreferrer" className="flex items-center gap-1.5 text-pink-500 hover:text-pink-600 text-sm transition-colors" title="Instagram">
                  <Instagram className="w-5 h-5" />Instagram
                </a>
              ) : (
                <span className="flex items-center gap-1.5 text-gray-300 text-sm cursor-default" title="Instagram non disponibile">
                  <Instagram className="w-5 h-5" />Instagram
                </span>
              )}
              {facebook_url ? (
                <a href={facebook_url} target="_blank" rel="noopener noreferrer" className="flex items-center gap-1.5 text-blue-600 hover:text-blue-700 text-sm transition-colors" title="Facebook">
                  <Facebook className="w-5 h-5" />Facebook
                </a>
              ) : (
                <span className="flex items-center gap-1.5 text-gray-300 text-sm cursor-default" title="Facebook non disponibile">
                  <Facebook className="w-5 h-5" />Facebook
                </span>
              )}
              {tiktok_url ? (
                <a href={tiktok_url} target="_blank" rel="noopener noreferrer" className="flex items-center gap-1.5 text-gray-800 hover:text-gray-900 text-sm transition-colors" title="TikTok">
                  <svg className="w-5 h-5" viewBox="0 0 24 24" fill="currentColor"><path d="M19.59 6.69a4.83 4.83 0 01-3.77-4.25V2h-3.45v13.67a2.89 2.89 0 01-2.88 2.5 2.89 2.89 0 01-2.89-2.89 2.89 2.89 0 012.89-2.89c.28 0 .54.04.79.1V9.01a6.33 6.33 0 00-.79-.05 6.34 6.34 0 00-6.34 6.34 6.34 6.34 0 006.34 6.34 6.34 6.34 0 006.33-6.34V8.97a8.27 8.27 0 004.84 1.55V7.07a4.85 4.85 0 01-1.07-.38z"/></svg>TikTok
                </a>
              ) : (
                <span className="flex items-center gap-1.5 text-gray-300 text-sm cursor-default" title="TikTok non disponibile">
                  <svg className="w-5 h-5" viewBox="0 0 24 24" fill="currentColor"><path d="M19.59 6.69a4.83 4.83 0 01-3.77-4.25V2h-3.45v13.67a2.89 2.89 0 01-2.88 2.5 2.89 2.89 0 01-2.89-2.89 2.89 2.89 0 012.89-2.89c.28 0 .54.04.79.1V9.01a6.33 6.33 0 00-.79-.05 6.34 6.34 0 00-6.34 6.34 6.34 6.34 0 006.34 6.34 6.34 6.34 0 006.33-6.34V8.97a8.27 8.27 0 004.84 1.55V7.07a4.85 4.85 0 01-1.07-.38z"/></svg>TikTok
                </span>
              )}
            </div>
          </div>
        </div>

        {business.source === 'registered' && (
          <div className="bg-white rounded-2xl shadow-lg p-8 mb-6">
            <BusinessLocationPhotos locationId={business.id} readOnly />
          </div>
        )}

        <div className="bg-white rounded-2xl shadow-lg p-8">
          <div className="flex items-center justify-between mb-6">
            <h2 className="text-xl font-bold text-gray-900">
              Recensioni ({reviews.length})
            </h2>
            {profile && profile.user_type === 'customer' && !showReviewForm && (
              <button
                onClick={() => setShowReviewForm(true)}
                className="flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors text-sm font-semibold"
              >
                <Star className="w-4 h-4" />Scrivi recensione
              </button>
            )}
          </div>

          {showReviewForm && (
            <div className="mb-6">
              <ReviewForm
                businessLocationId={isUnclaimed ? businessId : undefined}
                registeredBusinessLocationId={!isUnclaimed ? businessId : undefined}
                onSuccess={() => { setShowReviewForm(false); loadBusiness(); }}
                onCancel={() => setShowReviewForm(false)}
              />
            </div>
          )}

          {reviews.length === 0 ? (
            <div className="text-center py-8 text-gray-500">
              <Star className="w-12 h-12 mx-auto mb-3 text-gray-300" />
              <p>Nessuna recensione ancora. Sii il primo a recensire!</p>
            </div>
          ) : (
            <div className="space-y-4">
              {reviews.map(review => (
                <ReviewCard key={review.id} review={review} />
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
