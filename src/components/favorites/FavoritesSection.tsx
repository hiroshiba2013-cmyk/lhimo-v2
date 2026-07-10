import { useState, useEffect } from 'react';
import { Heart, Building2, ShoppingBag, Briefcase, User, X } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useAuth } from '../../contexts/AuthContext';
import { useNavigate } from '../Router';
import { useToast } from '../common/Toast';

interface FavoriteItem {
  id: string;
  created_at: string;
  family_member_id: string | null;
  item: any;
}

interface FamilyMember {
  id: string;
  first_name: string;
  last_name: string;
  nickname: string | null;
}

export function FavoritesSection() {
  const { showToast } = useToast();
  const { user, profile } = useAuth();
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState<'businesses' | 'ads' | 'jobs'>('businesses');
  const [favoriteBusinesses, setFavoriteBusinesses] = useState<FavoriteItem[]>([]);
  const [favoriteAds, setFavoriteAds] = useState<FavoriteItem[]>([]);
  const [favoriteJobs, setFavoriteJobs] = useState<FavoriteItem[]>([]);
  const [familyMembers, setFamilyMembers] = useState<FamilyMember[]>([]);
  const [loading, setLoading] = useState(true);
  const [counts, setCounts] = useState({ businesses: 0, ads: 0, jobs: 0 });

  useEffect(() => {
    if (user && profile) {
      loadFavorites();
      loadFamilyMembers();
    }
  }, [user, profile, activeTab]);

  // Carica i conteggi di tutti i tab al mount per i badge
  useEffect(() => {
    if (!user) return;
    (async () => {
      try {
        const [bRes, aRes, jRes] = await Promise.all([
          supabase.from('favorite_businesses').select('id').eq('user_id', user.id),
          supabase.from('favorite_classified_ads').select('id').eq('user_id', user.id),
          supabase.from('favorite_job_postings').select('id').eq('user_id', user.id),
        ]);
        setCounts({
          businesses: bRes.data?.length ?? 0,
          ads: aRes.data?.length ?? 0,
          jobs: jRes.data?.length ?? 0,
        });
      } catch {}
    })();
  }, [user]);

  const loadFamilyMembers = async () => {
    if (!profile) return;

    try {
      const { data } = await supabase
        .from('customer_family_members')
        .select('id, first_name, last_name, nickname')
        .eq('customer_id', profile.id);

      setFamilyMembers(data || []);
    } catch (error) {
      console.error('Error loading family members:', error);
    }
  };

  const loadFavorites = async () => {
    if (!user) return;

    setLoading(true);
    try {
      if (activeTab === 'businesses') {
        const { data: favoritesData } = await supabase
          .from('favorite_businesses')
          .select(`
            id,
            created_at,
            family_member_id,
            business_id,
            business_location_id,
            unclaimed_business_location_id,
            registered_business_location_id,
            registered_business_id
          `)
          .eq('user_id', user.id)
          .order('created_at', { ascending: false });

        if (!favoritesData) {
          setFavoriteBusinesses([]);
          return;
        }


        const enrichedFavorites = await Promise.all(
          favoritesData.map(async (fav: any) => {
            let itemData = null;

            if (fav.registered_business_location_id) {
              // Sede di attività registrata (sistema nuovo)
              const { data: rblData } = await supabase
                .from('registered_business_locations')
                .select(`
                  id,
                  name,
                  internal_name,
                  street,
                  city,
                  phone,
                  registered_businesses!business_id(id, name)
                `)
                .eq('id', fav.registered_business_location_id)
                .maybeSingle();

              if (rblData) {
                const rb = (rblData as any).registered_businesses;
                itemData = {
                  id: rblData.id,
                  business_id: rb?.id || rblData.id,
                  address: rblData.street,
                  city: rblData.city,
                  phone: rblData.phone,
                  businesses: { name: rb?.name || rblData.internal_name || rblData.name || 'Attività' },
                  is_registered: true
                };
              }
            } else if (fav.registered_business_id) {
              // Attività registrata senza sede specifica
              const { data: rbData } = await supabase
                .from('registered_businesses')
                .select('id, name, phone, billing_city')
                .eq('id', fav.registered_business_id)
                .maybeSingle();

              if (rbData) {
                itemData = {
                  id: rbData.id,
                  business_id: rbData.id,
                  address: null,
                  city: (rbData as any).billing_city || null,
                  phone: (rbData as any).phone || null,
                  businesses: { name: (rbData as any).name || 'Attività' },
                  is_registered: true
                };
              }
            } else if (fav.business_location_id) {
              // Per sedi specifiche di business rivendicati (sistema legacy)
              const { data: locationData } = await supabase
                .from('business_locations')
                .select(`
                  id,
                  name,
                  internal_name,
                  address,
                  city,
                  phone,
                  business:businesses(id, name)
                `)
                .eq('id', fav.business_location_id)
                .maybeSingle();

              if (locationData && locationData.business) {
                itemData = {
                  id: locationData.id,
                  business_id: locationData.business.id,
                  address: locationData.address,
                  city: locationData.city,
                  phone: locationData.phone,
                  businesses: { name: locationData.business.name }
                };
              }
            } else if (fav.business_id) {
              // Per attività rivendicate (generiche, senza sede specifica)
              const { data: businessData } = await supabase
                .from('businesses')
                .select(`
                  id,
                  name,
                  locations:business_locations(
                    id,
                    address,
                    city,
                    phone
                  )
                `)
                .eq('id', fav.business_id)
                .maybeSingle();

              if (businessData && businessData.locations && businessData.locations.length > 0) {
                const location = businessData.locations[0];
                itemData = {
                  id: location.id,
                  business_id: businessData.id,
                  address: location.address,
                  city: location.city,
                  phone: location.phone,
                  businesses: { name: businessData.name }
                };
              }
            } else if (fav.unclaimed_business_location_id) {
              // Per attività non rivendicate
              const { data } = await supabase
                .from('unclaimed_business_locations')
                .select(`
                  id,
                  name,
                  street,
                  city,
                  phone
                `)
                .eq('id', fav.unclaimed_business_location_id)
                .maybeSingle();

              if (data) {
                itemData = {
                  id: data.id,
                  business_id: data.id,
                  address: data.street,
                  city: data.city,
                  phone: data.phone,
                  businesses: { name: data.name },
                  is_unclaimed: true
                };
              }
            }

            return {
              ...fav,
              item: itemData
            };
          })
        );

        const filteredFavorites = enrichedFavorites.filter(f => f.item !== null);
        setFavoriteBusinesses(filteredFavorites);
        setCounts(prev => ({ ...prev, businesses: filteredFavorites.length }));
      } else if (activeTab === 'ads') {
        const { data } = await supabase
          .from('favorite_classified_ads')
          .select(`
            id,
            created_at,
            family_member_id,
            item:classified_ads(
              id,
              title,
              price,
              ad_type,
              city,
              images
            )
          `)
          .eq('user_id', user.id)
          .order('created_at', { ascending: false });

        setFavoriteAds(data || []);
        setCounts(prev => ({ ...prev, ads: data?.length ?? prev.ads }));
      } else if (activeTab === 'jobs') {
        const { data } = await supabase
          .from('favorite_job_postings')
          .select(`
            id,
            created_at,
            family_member_id,
            item:job_postings(
              id,
              title,
              location,
              position_type,
              gross_annual_salary,
              salary_currency,
              businesses(name)
            )
          `)
          .eq('user_id', user.id)
          .order('created_at', { ascending: false });

        setFavoriteJobs(data || []);
        setCounts(prev => ({ ...prev, jobs: data?.length ?? prev.jobs }));
      }
    } catch (error) {
      console.error('Error loading favorites:', error);
    } finally {
      setLoading(false);
    }
  };

  const removeFavorite = async (favoriteId: string, type: string) => {
    if (!confirm('Rimuovere dai preferiti?')) return;

    try {
      const tableName = type === 'businesses'
        ? 'favorite_businesses'
        : type === 'ads'
        ? 'favorite_classified_ads'
        : 'favorite_job_postings';

      await supabase
        .from(tableName)
        .delete()
        .eq('id', favoriteId);

      loadFavorites();
    } catch (error) {
      console.error('Error removing favorite:', error);
      showToast('Errore durante la rimozione', 'error');
    }
  };

  const getFamilyMemberName = (familyMemberId: string | null) => {
    if (!familyMemberId) return profile?.full_name || 'Tu';
    const member = familyMembers.find(m => m.id === familyMemberId);
    if (!member) return 'Membro famiglia';
    return member.nickname || `${member.first_name} ${member.last_name}`;
  };

  const groupedBusinesses = favoriteBusinesses.reduce((acc, fav) => {
    const owner = fav.family_member_id || 'main';
    if (!acc[owner]) acc[owner] = [];
    acc[owner].push(fav);
    return acc;
  }, {} as Record<string, FavoriteItem[]>);

const groupedAds = favoriteAds.reduce((acc, fav) => {
    const owner = fav.family_member_id || 'main';
    if (!acc[owner]) acc[owner] = [];
    acc[owner].push(fav);
    return acc;
  }, {} as Record<string, FavoriteItem[]>);

  const groupedJobs = favoriteJobs.reduce((acc, fav) => {
    const owner = fav.family_member_id || 'main';
    if (!acc[owner]) acc[owner] = [];
    acc[owner].push(fav);
    return acc;
  }, {} as Record<string, FavoriteItem[]>);

  const renderBusinessCard = (fav: FavoriteItem) => {
    if (!fav.item) return null;
    const business = fav.item;

    const handleViewDetails = (e: React.MouseEvent) => {
      e.stopPropagation();
      if (business.is_unclaimed) {
        navigate(`/business/unclaimed/${business.id}`);
      } else if (business.is_registered) {
        navigate(`/business/${business.business_id}`);
      } else {
        navigate(`/business/${business.business_id}`);
      }
    };

    return (
      <div key={fav.id} className="bg-white border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow">
        <div className="flex items-start justify-between">
          <div className="flex-1">
            <h4 className="font-semibold text-gray-900 mb-1">
              {business.businesses?.name || 'Attività'}
            </h4>
            <p className="text-sm text-gray-600 mb-2">
              {business.address}, {business.city}
            </p>
            {business.phone && (
              <p className="text-sm text-gray-500">{business.phone}</p>
            )}
            <button
              onClick={handleViewDetails}
              className="inline-block mt-3 text-sm text-blue-600 hover:text-blue-700 font-medium"
            >
              Visualizza dettagli →
            </button>
          </div>
          <button
            onClick={() => removeFavorite(fav.id, 'businesses')}
            className="p-2 text-red-600 hover:bg-red-50 rounded-lg transition-colors"
            title="Rimuovi dai preferiti"
          >
            <X className="w-4 h-4" />
          </button>
        </div>
      </div>
    );
  };

  const renderAdCard = (fav: FavoriteItem) => {
    if (!fav.item) return null;
    const ad = fav.item;

    return (
      <div key={fav.id} className="bg-white border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow">
        <div className="flex items-start justify-between">
          <div className="flex-1">
            <div className="flex items-center gap-2 mb-2">
              <span className={`text-xs px-2 py-1 rounded-full font-bold ${
                ad.ad_type === 'sell' ? 'bg-blue-100 text-blue-700' :
                ad.ad_type === 'buy' ? 'bg-green-100 text-green-700' :
                'bg-orange-100 text-orange-700'
              }`}>
                {ad.ad_type === 'sell' ? 'Vendo' : ad.ad_type === 'buy' ? 'Cerco' : 'Regalo'}
              </span>
            </div>
            <h4 className="font-semibold text-gray-900 mb-1">{ad.title}</h4>
            {ad.price && (
              <p className="text-lg font-bold text-blue-600 mb-1">€{ad.price}</p>
            )}
            <p className="text-sm text-gray-600">{ad.city}</p>
            <button
              onClick={(e) => {
                e.stopPropagation();
                navigate(`/classified-ads/${ad.id}`);
              }}
              className="inline-block mt-3 text-sm text-blue-600 hover:text-blue-700 font-medium"
            >
              Visualizza annuncio →
            </button>
          </div>
          <button
            onClick={() => removeFavorite(fav.id, 'ads')}
            className="p-2 text-red-600 hover:bg-red-50 rounded-lg transition-colors"
            title="Rimuovi dai preferiti"
          >
            <X className="w-4 h-4" />
          </button>
        </div>
      </div>
    );
  };

  const renderJobCard = (fav: FavoriteItem) => {
    if (!fav.item) return null;
    const job = fav.item;

    return (
      <div key={fav.id} className="bg-white border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow">
        <div className="flex items-start justify-between">
          <div className="flex-1">
            <h4 className="font-semibold text-gray-900 mb-1">{job.title}</h4>
            <p className="text-sm text-gray-600 mb-2">{job.businesses?.name || 'Azienda'}</p>
            <div className="flex flex-wrap gap-3 text-sm text-gray-600">
              <span>{job.location}</span>
              <span className="text-green-600 font-medium">{job.position_type}</span>
              {job.gross_annual_salary && (
                <span>€{job.gross_annual_salary.toLocaleString()}/anno</span>
              )}
            </div>
            <button
              onClick={(e) => {
                e.stopPropagation();
                navigate('/jobs');
              }}
              className="inline-block mt-3 text-sm text-blue-600 hover:text-blue-700 font-medium"
            >
              Visualizza offerta →
            </button>
          </div>
          <button
            onClick={() => removeFavorite(fav.id, 'jobs')}
            className="p-2 text-red-600 hover:bg-red-50 rounded-lg transition-colors"
            title="Rimuovi dai preferiti"
          >
            <X className="w-4 h-4" />
          </button>
        </div>
      </div>
    );
  };

  return (
    <div className="bg-white rounded-lg shadow-sm p-6">
      <h2 className="text-2xl font-semibold text-gray-900 mb-6 flex items-center gap-2">
        <Heart className="w-6 h-6 text-red-500 fill-current" />
        I Miei Preferiti
      </h2>

      <div className="flex gap-2 mb-6 border-b">
        <button
          onClick={() => setActiveTab('businesses')}
          className={`flex items-center gap-2 px-4 py-3 font-medium transition-colors ${
            activeTab === 'businesses'
              ? 'text-blue-600 border-b-2 border-blue-600'
              : 'text-gray-600 hover:text-gray-900'
          }`}
        >
          <Building2 className="w-5 h-5" />
          Attività
          {counts.businesses > 0 && (
            <span className="ml-1 inline-flex items-center justify-center min-w-[20px] h-5 px-1.5 bg-red-500 text-white text-xs font-bold rounded-full">
              {counts.businesses}
            </span>
          )}
        </button>
        <button
          onClick={() => setActiveTab('ads')}
          className={`flex items-center gap-2 px-4 py-3 font-medium transition-colors ${
            activeTab === 'ads'
              ? 'text-blue-600 border-b-2 border-blue-600'
              : 'text-gray-600 hover:text-gray-900'
          }`}
        >
          <ShoppingBag className="w-5 h-5" />
          Annunci
          {counts.ads > 0 && (
            <span className="ml-1 inline-flex items-center justify-center min-w-[20px] h-5 px-1.5 bg-red-500 text-white text-xs font-bold rounded-full">
              {counts.ads}
            </span>
          )}
        </button>
        <button
          onClick={() => setActiveTab('jobs')}
          className={`flex items-center gap-2 px-4 py-3 font-medium transition-colors ${
            activeTab === 'jobs'
              ? 'text-blue-600 border-b-2 border-blue-600'
              : 'text-gray-600 hover:text-gray-900'
          }`}
        >
          <Briefcase className="w-5 h-5" />
          Offerte di Lavoro
          {counts.jobs > 0 && (
            <span className="ml-1 inline-flex items-center justify-center min-w-[20px] h-5 px-1.5 bg-red-500 text-white text-xs font-bold rounded-full">
              {counts.jobs}
            </span>
          )}
        </button>
      </div>

      {loading ? (
        <div className="text-center py-12">
          <div className="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
          <p className="text-sm text-gray-500 mt-2">Caricamento preferiti...</p>
        </div>
      ) : (
        <div className="space-y-8">
          {activeTab === 'businesses' && (
            <>
              {favoriteBusinesses.length === 0 ? (
                <p className="text-gray-600 text-center py-8">Nessuna attività nei preferiti</p>
              ) : Object.keys(groupedBusinesses).length === 0 ? (
                <p className="text-gray-600 text-center py-8">
                  Hai {favoriteBusinesses.length} preferiti ma c'è un problema nel caricamento.
                  Controlla la console per i dettagli.
                </p>
              ) : (
                <>
                  {groupedBusinesses['main'] && (
                    <div>
                      <h3 className="text-lg font-semibold text-gray-900 mb-4 flex items-center gap-2">
                        <User className="w-5 h-5" />
                        {profile?.full_name}
                      </h3>
                      <div className="grid gap-4">
                        {groupedBusinesses['main'].map(renderBusinessCard)}
                      </div>
                    </div>
                  )}
                  {Object.keys(groupedBusinesses)
                    .filter(key => key !== 'main')
                    .map(familyMemberId => (
                      <div key={familyMemberId}>
                        <h3 className="text-lg font-semibold text-gray-900 mb-4 flex items-center gap-2">
                          <User className="w-5 h-5" />
                          {getFamilyMemberName(familyMemberId)}
                        </h3>
                        <div className="grid gap-4">
                          {groupedBusinesses[familyMemberId].map(renderBusinessCard)}
                        </div>
                      </div>
                    ))}
                </>
              )}
            </>
          )}

          {activeTab === 'ads' && (
            <>
              {Object.keys(groupedAds).length === 0 ? (
                <p className="text-gray-600 text-center py-8">Nessun annuncio nei preferiti</p>
              ) : (
                <>
                  {groupedAds['main'] && (
                    <div>
                      <h3 className="text-lg font-semibold text-gray-900 mb-4 flex items-center gap-2">
                        <User className="w-5 h-5" />
                        {profile?.full_name}
                      </h3>
                      <div className="grid gap-4">
                        {groupedAds['main'].map(renderAdCard)}
                      </div>
                    </div>
                  )}
                  {Object.keys(groupedAds)
                    .filter(key => key !== 'main')
                    .map(familyMemberId => (
                      <div key={familyMemberId}>
                        <h3 className="text-lg font-semibold text-gray-900 mb-4 flex items-center gap-2">
                          <User className="w-5 h-5" />
                          {getFamilyMemberName(familyMemberId)}
                        </h3>
                        <div className="grid gap-4">
                          {groupedAds[familyMemberId].map(renderAdCard)}
                        </div>
                      </div>
                    ))}
                </>
              )}
            </>
          )}

          {activeTab === 'jobs' && (
            <>
              {Object.keys(groupedJobs).length === 0 ? (
                <p className="text-gray-600 text-center py-8">Nessuna offerta di lavoro nei preferiti</p>
              ) : (
                <>
                  {groupedJobs['main'] && (
                    <div>
                      <h3 className="text-lg font-semibold text-gray-900 mb-4 flex items-center gap-2">
                        <User className="w-5 h-5" />
                        {profile?.full_name}
                      </h3>
                      <div className="grid gap-4">
                        {groupedJobs['main'].map(renderJobCard)}
                      </div>
                    </div>
                  )}
                  {Object.keys(groupedJobs)
                    .filter(key => key !== 'main')
                    .map(familyMemberId => (
                      <div key={familyMemberId}>
                        <h3 className="text-lg font-semibold text-gray-900 mb-4 flex items-center gap-2">
                          <User className="w-5 h-5" />
                          {getFamilyMemberName(familyMemberId)}
                        </h3>
                        <div className="grid gap-4">
                          {groupedJobs[familyMemberId].map(renderJobCard)}
                        </div>
                      </div>
                    ))}
                </>
              )}
            </>
          )}
        </div>
      )}
    </div>
  );
}
