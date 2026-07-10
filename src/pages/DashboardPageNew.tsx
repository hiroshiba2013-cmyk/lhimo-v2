// v2 - badge navigation
import React, { useState, useEffect } from 'react';
import { Plus, Star, Building, Building2, MessageSquare, User, Check, Shield, TrendingUp, Heart, Gift, Users as UsersIcon, Briefcase, Users, DollarSign, Trophy, Activity, Tag, ChevronDown, ChevronUp, MapPin } from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';
import { supabase, Business, Review, FamilyMember } from '../lib/supabase';
import { BusinessJobPostingForm } from '../components/business/BusinessJobPostingForm';
import { EditBusinessLocationsForm } from '../components/business/EditBusinessLocationsForm';
import { EditBusinessForm } from '../components/business/EditBusinessForm';
import { CreateBusinessForm } from '../components/business/CreateBusinessForm';
import { ReviewResponseForm } from '../components/reviews/ReviewResponseForm';
import { ImportBusinessesForm } from '../components/business/ImportBusinessesForm';
import { FavoritesSection } from '../components/favorites/FavoritesSection';
import TrialStatusBanner from '../components/subscription/TrialStatusBanner';
import TrialExpirationModal from '../components/subscription/TrialExpirationModal';
import { ActivityFeed } from '../components/activity/ActivityFeed';
import { UserAuctionsSection } from '../components/auctions/UserAuctionsSection';
import { ProfileClassifiedAdCard } from '../components/classifieds/ProfileClassifiedAdCard';
import { ClassifiedAdForm } from '../components/classifieds/ClassifiedAdForm';
import { useNavigate } from '../components/Router';
import { BusinessLocationAvatarUpload } from '../components/business/BusinessLocationAvatarUpload';
import { usePageCustomization } from '../hooks/usePageCustomization';

interface SubscriptionPlan {
  id: string;
  name: string;
  price: number;
  billing_period: 'monthly' | 'yearly';
  max_persons: number;
}

interface Subscription {
  id: string;
  plan: SubscriptionPlan;
  status: string;
  start_date: string;
  end_date: string;
  trial_end_date?: string;
}

interface JobPosting {
  id: string;
  business_id: string;
  location_id: string | null;
  title: string;
  created_at: string;
}

interface JobSeeker {
  id: string;
  user_id: string;
  title: string;
  description: string;
  category: string;
  city: string;
  province: string;
  created_at: string;
  profiles: {
    full_name: string;
    nickname: string | null;
    avatar_url: string | null;
  };
}

interface TopLocation {
  id: string;
  name: string;
  internal_name: string;
  city: string;
  province: string;
  avg_rating: number;
  review_count: number;
  business: {
    name: string;
  };
}

interface SolidarityStats {
  total_revenue: number;
  charity_amount: number;
}

export function DashboardPageNew() {
  const { profile, selectedBusinessLocationId, activeProfile, refreshBusinessLocations, businessLocations } = useAuth();
  const navigate = useNavigate();
  const customization = usePageCustomization(profile?.user_type === 'business' ? 'dashboard_business' : 'dashboard_private');
  const [businesses, setBusinesses] = useState<Business[]>([]);
  const [reviews, setReviews] = useState<Review[]>([]);
  const [jobPostings, setJobPostings] = useState<JobPosting[]>([]);
  const [jobSeekers, setJobSeekers] = useState<JobSeeker[]>([]);
  const [topLocations, setTopLocations] = useState<TopLocation[]>([]);
  const [solidarityStats, setSolidarityStats] = useState<SolidarityStats | null>(null);
  const [familyMembers, setFamilyMembers] = useState<FamilyMember[]>([]);
  const [loading, setLoading] = useState(true);

  const [showCreateBusinessForm, setShowCreateBusinessForm] = useState(false);
  const [showResponseForm, setShowResponseForm] = useState<string | null>(null);
  const [businessClassifiedAds, setBusinessClassifiedAds] = useState<any[]>([]);
  const [showClassifiedAdForm, setShowClassifiedAdForm] = useState(false);
  const [editingClassifiedAdId, setEditingClassifiedAdId] = useState<string | undefined>(undefined);
  const [customerClassifiedAds, setCustomerClassifiedAds] = useState<any[]>([]);
  const [favBusinessesCount, setFavBusinessesCount] = useState(0);
  const [showCustomerAdForm, setShowCustomerAdForm] = useState(false);
  const [editingCustomerAdId, setEditingCustomerAdId] = useState<string | undefined>(undefined);
  const [selectedBusinessId, setSelectedBusinessId] = useState<string | null>(null);
  const [isRegisteredBusiness, setIsRegisteredBusiness] = useState(false);
  const [currentSubscription, setCurrentSubscription] = useState<Subscription | null>(null);
  const [availablePlans, setAvailablePlans] = useState<SubscriptionPlan[]>([]);
  const [upgradeMessage, setUpgradeMessage] = useState('');
  const [leaderboardTab, setLeaderboardTab] = useState<'leaderboard' | 'my_activities'>('leaderboard');
  const [userRank, setUserRank] = useState<{ points: number; rank: number; reviews_count: number } | null>(null);
  const [openSections, setOpenSections] = useState<Record<string, boolean>>({
    auctions: true,
    ads: true,
    favorites: false,
    leaderboard: false,
    reviews: false,
    family_reviews: false,
    plans: false,
    business_activities: false,
    job_postings: false,
    business_reviews: false,
    job_seekers: false,
    solidarity: false,
    business_plans: false,
  });
  const toggleSection = (key: string) =>
    setOpenSections(prev => ({ ...prev, [key]: !prev[key] }));

  const loadBusinessClassifiedAds = async () => {
    if (!profile) return;
    const { data, error } = await supabase
      .from('classified_ads')
      .select('*, classified_categories(name, icon)')
      .eq('user_id', profile.id)
      .order('created_at', { ascending: false });
    if (data) setBusinessClassifiedAds(data);
  };

  const loadCustomerClassifiedAds = async () => {
    if (!profile) return;
    const familyMemberId = activeProfile && !activeProfile.isOwner ? activeProfile.id : null;
    let query = supabase
      .from('classified_ads')
      .select('*, classified_categories(name, icon)')
      .eq('user_id', profile.id)
      .order('created_at', { ascending: false });
    if (familyMemberId) {
      query = query.eq('family_member_id', familyMemberId);
    } else {
      query = query.is('family_member_id', null);
    }
    const { data } = await query;
    if (data) setCustomerClassifiedAds(data);
  };

  const deleteClassifiedAd = async (adId: string) => {
    await supabase.from('classified_ads').delete().eq('id', adId);
    if (profile?.user_type === 'business') {
      loadBusinessClassifiedAds();
    } else {
      loadCustomerClassifiedAds();
    }
  };

  useEffect(() => {
    if (!profile) return;
    loadDashboardData();
    loadSubscriptionData();
  }, [profile, selectedBusinessLocationId, activeProfile]);

  const loadDashboardData = async () => {
    if (!profile) return;

    setLoading(true);

    // Reset dei dati quando cambia la sede
    setReviews([]);
    setJobPostings([]);
    setJobSeekers([]);
    setTopLocations([]);

    try {
      if (profile.user_type === 'business') {
        const { data: jobSeekersData, error: jobSeekersError } = await supabase
          .from('job_seekers')
          .select(`
            *,
            profiles!inner(full_name, nickname, avatar_url)
          `)
          .eq('status', 'active')
          .order('created_at', { ascending: false })
          .limit(10);

        if (!jobSeekersError && jobSeekersData) {
          setJobSeekers(jobSeekersData);
        }
        const { data: topLocationsData, error: topLocationsError } = await supabase
          .rpc('get_top_business_locations', { limit_count: 10 });

        if (!topLocationsError && topLocationsData) {
          setTopLocations(topLocationsData);
        }
        const { data: revenueData, error: revenueError } = await supabase
          .rpc('get_total_revenue');

        if (!revenueError && revenueData !== null) {
          const totalRevenue = revenueData;
          const charityAmount = totalRevenue * 0.1;
          setSolidarityStats({
            total_revenue: totalRevenue,
            charity_amount: charityAmount,
          });
        }
        // Cerca prima in registered_businesses (nuovo sistema)
        let { data: registeredData } = await supabase
          .from('registered_businesses')
          .select('*')
          .eq('owner_id', profile.id);

        let isRegistered = false;
        let businessesData: any[] | null = registeredData;

        // Fallback a businesses (vecchio sistema)
        if (!businessesData || businessesData.length === 0) {
          const result = await supabase
            .from('businesses')
            .select('*')
            .eq('owner_id', profile.id);
          businessesData = result.data;
        } else {
          isRegistered = true;
        }

        setIsRegisteredBusiness(isRegistered);

        if (businessesData) {
          setBusinesses(businessesData);

          if (businessesData.length > 0) {
            setSelectedBusinessId(businessesData[0].id);
          }

          if (businessesData.length > 0) {
            const businessIds = businessesData.map(b => b.id);

            if (isRegistered) {
              // Registered businesses: get location IDs first, then query reviews
              const locationsQuery = supabase
                .from('registered_business_locations')
                .select('id')
                .in('business_id', businessIds);
              const { data: locationRows } = await locationsQuery;
              const locationIds = locationRows ? locationRows.map(l => l.id) : [];

              if (locationIds.length > 0) {
                let reviewsQuery = supabase
                  .from('reviews')
                  .select(`
                    *,
                    customer:profiles!customer_id(full_name),
                    responses:review_responses(*)
                  `)
                  .in('business_location_id', locationIds)
                  .eq('review_status', 'approved')
                  .order('created_at', { ascending: false });

                if (selectedBusinessLocationId) {
                  reviewsQuery = reviewsQuery.eq('business_location_id', selectedBusinessLocationId);
                }

                const { data: reviewsData } = await reviewsQuery;
                if (reviewsData) setReviews(reviewsData);
              }
            } else {
              // Old businesses table
              let reviewsQuery = supabase
                .from('reviews')
                .select(`
                  *,
                  customer:profiles!customer_id(full_name),
                  responses:review_responses(*),
                  business_location:business_locations(internal_name, address)
                `)
                .in('business_id', businessIds)
                .eq('review_status', 'approved')
                .order('created_at', { ascending: false });

              if (selectedBusinessLocationId) {
                reviewsQuery = reviewsQuery.eq('business_location_id', selectedBusinessLocationId);
              }

              const { data: reviewsData } = await reviewsQuery;
              if (reviewsData) setReviews(reviewsData);
            }

            // Job postings - support both old and new system
            const [jpOld, jpNew] = await Promise.all([
              supabase
                .from('job_postings')
                .select('*')
                .in('business_id', businessIds)
                .is('registered_business_id', null)
                .then(r => r.data || []),
              supabase
                .from('job_postings')
                .select('*')
                .in('registered_business_id', businessIds)
                .then(r => r.data || []),
            ]);
            let allJobPostings = [...jpOld, ...jpNew];

            if (selectedBusinessLocationId) {
              allJobPostings = allJobPostings.filter(jp =>
                jp.business_location_id === selectedBusinessLocationId ||
                jp.registered_business_location_id === selectedBusinessLocationId
              );
            }

            allJobPostings.sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());
            setJobPostings(allJobPostings);
          }
        }
      } else {
        const { data: familyMembersData } = await supabase
          .from('customer_family_members')
          .select('*')
          .eq('customer_id', profile.id)
          .order('created_at', { ascending: true });

        if (familyMembersData) {
          setFamilyMembers(familyMembersData);
        }

        const { data: reviewsData } = await supabase
          .from('reviews')
          .select(`
            *,
            business:businesses(name),
            family_member:customer_family_members(*)
          `)
          .eq('customer_id', profile.id)
          .order('created_at', { ascending: false });

        if (reviewsData) {
          setReviews(reviewsData);
        }

        // Load user ranking
        const familyMemberId = activeProfile?.isOwner === false ? activeProfile.id : null;
        const activityQuery = supabase
          .from('user_activity')
          .select('total_points, reviews_count')
          .eq('user_id', profile.id);

        if (familyMemberId) {
          activityQuery.eq('family_member_id', familyMemberId);
        } else {
          activityQuery.is('family_member_id', null);
        }

        const { data: activityData } = await activityQuery.maybeSingle();
        const totalPoints = activityData?.total_points || 0;

        const { count: higherCount } = await supabase
          .from('user_activity')
          .select('*', { count: 'exact', head: true })
          .gt('total_points', totalPoints);

        setUserRank({
          points: totalPoints,
          rank: (higherCount || 0) + 1,
          reviews_count: activityData?.reviews_count || 0,
        });
      }
      // Load classified ads
      const familyMemberId = activeProfile && !activeProfile.isOwner ? activeProfile.id : null;
      if (profile.user_type === 'business') {
        const { data: adsData } = await supabase
          .from('classified_ads')
          .select('*, classified_categories(name, icon)')
          .eq('user_id', profile.id)
          .order('created_at', { ascending: false });
        if (adsData) setBusinessClassifiedAds(adsData);
      } else {
        let adsQuery = supabase
          .from('classified_ads')
          .select('*, classified_categories(name, icon)')
          .eq('user_id', profile.id)
          .order('created_at', { ascending: false });
        if (familyMemberId) {
          adsQuery = adsQuery.eq('family_member_id', familyMemberId);
        } else {
          adsQuery = adsQuery.is('family_member_id', null);
        }
        const { data: adsData } = await adsQuery;
        if (adsData) setCustomerClassifiedAds(adsData);

        // Conteggio attività preferite
        const { data: favData } = await supabase
          .from('favorite_businesses')
          .select('id')
          .eq('user_id', profile.id);
        setFavBusinessesCount(favData?.length ?? 0);
      }
    } catch (error) {
      console.error('Error loading dashboard data:', error);
    } finally {
      setLoading(false);
    }
  };

  const loadSubscriptionData = async () => {
    if (!profile) return;

    try {
      // Get all active/trial subscriptions ordered by creation date (most recent first)
      const { data: subscriptionsData } = await supabase
        .from('subscriptions')
        .select('id, status, start_date, end_date, trial_end_date, plan:subscription_plans(id, name, price, billing_period, max_persons)')
        .eq('customer_id', profile.id)
        .in('status', ['active', 'trial'])
        .order('created_at', { ascending: false });

      // Use the most recent subscription
      if (subscriptionsData && subscriptionsData.length > 0) {
        setCurrentSubscription(subscriptionsData[0] as any);

        // If there are duplicate subscriptions, log a warning
        if (subscriptionsData.length > 1) {
          console.warn('⚠️ Trovate subscription duplicate per l\'utente:', profile.id, subscriptionsData.length);
        }
      }

      if (profile.user_type === 'business') {
        const { data: plansData } = await supabase
          .from('subscription_plans')
          .select('*')
          .like('name', '%Business%')
          .order('billing_period')
          .order('max_persons');

        if (plansData) {
          setAvailablePlans(plansData);
        }
      } else {
        const { data: plansData } = await supabase
          .from('subscription_plans')
          .select('*')
          .not('name', 'like', '%Business%')
          .order('max_persons')
          .order('billing_period');

        if (plansData) {
          setAvailablePlans(plansData);
        }
      }
    } catch (error) {
      console.error('Error loading subscription data:', error);
    }
  };

  const calculateSavings = (plan: SubscriptionPlan) => {
    if (plan.billing_period !== 'yearly') return null;

    const monthlyPlan = availablePlans.find(
      p => p.max_persons === plan.max_persons && p.billing_period === 'monthly'
    );

    if (!monthlyPlan) return null;

    const yearlyIfMonthly = monthlyPlan.price * 12;
    return yearlyIfMonthly - plan.price;
  };

  const handleChangePlan = async (planId: string) => {
    if (!profile || !currentSubscription) return;

    setUpgradeMessage('');

    try {
      const selectedPlan = availablePlans.find(p => p.id === planId);
      if (!selectedPlan) throw new Error('Piano non trovato');

      const endDate = new Date();
      if (selectedPlan.billing_period === 'monthly') {
        endDate.setMonth(endDate.getMonth() + 1);
      } else {
        endDate.setFullYear(endDate.getFullYear() + 1);
      }

      const { error: updateError } = await supabase
        .from('subscriptions')
        .update({
          plan_id: planId,
          end_date: endDate.toISOString(),
          status: 'active',
        })
        .eq('id', currentSubscription.id);

      if (updateError) throw updateError;

      const { error: profileError } = await supabase
        .from('profiles')
        .update({
          subscription_type: selectedPlan.billing_period === 'monthly' ? 'monthly' : 'annual',
          subscription_status: 'active',
          subscription_expires_at: endDate.toISOString(),
        })
        .eq('id', profile.id);

      if (profileError) throw profileError;

      setUpgradeMessage('Piano aggiornato con successo!');

      setTimeout(() => {
        window.location.reload();
      }, 1500);
    } catch (error) {
      console.error('Error changing plan:', error);
      setUpgradeMessage('Errore durante il cambio del piano');
    }
  };

  if (!profile) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <p className="text-gray-600">Caricamento profilo...</p>
      </div>
    );
  }


  if (profile.subscription_status !== 'active' && profile.subscription_status !== 'trial') {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center bg-white p-8 rounded-lg shadow-lg max-w-md">
          <h2 className="text-2xl font-bold text-gray-900 mb-4">
            Abbonamento Necessario
          </h2>
          <p className="text-gray-600 mb-4">
            Per accedere alla dashboard e utilizzare tutte le funzionalità, attiva un abbonamento.
          </p>
          <p className="text-sm text-gray-500 mb-6">
            Stato attuale: {profile.subscription_status || 'nessuno'}
          </p>
          <a
            href="/subscription"
            className="inline-block bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors"
          >
            Vedi Piani
          </a>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <TrialExpirationModal />
      {customization?.announcement_active && customization.announcement_text && (
        <div className="bg-slate-800 text-white text-sm font-medium text-center py-2 px-4">
          {customization.announcement_text}
        </div>
      )}

      {/* Hero */}
      <section className="bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900 border-b border-slate-700">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 md:py-14">
          {(() => {
            // Sede attiva: sede selezionata esplicitamente, oppure prima sede se owner
            const activeSede = selectedBusinessLocationId
              ? businessLocations.find(l => l.id === selectedBusinessLocationId) ?? null
              : (profile.user_type === 'business' && businessLocations.length > 0 ? businessLocations[0] : null);
            const sedeAvatarUrl = activeSede?.avatar_url ?? null;
            const sedeLocationId = activeSede?.id ?? null;
            const sedeTable = (activeSede as any)?._table ?? 'registered_business_locations';
            const sedeName = (activeSede as any)?.internal_name || activeSede?.name || null;
            const sedeCity = activeSede?.city ?? null;
            const sedeProv = activeSede?.province ?? null;
            return (
          <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-6">
            <div className="flex items-center gap-5">
              {/* Avatar sede — visibile sempre per utenti business con sedi */}
              {profile.user_type === 'business' && (
                sedeLocationId ? (
                  <div className="flex-shrink-0">
                    <BusinessLocationAvatarUpload
                      locationId={sedeLocationId}
                      currentAvatarUrl={sedeAvatarUrl}
                      table={sedeTable}
                      onAvatarUpdate={async () => { await refreshBusinessLocations(); }}
                    />
                  </div>
                ) : (
                  /* Placeholder: nessuna sede ancora caricata */
                  <div className="w-24 h-24 rounded-full bg-white/10 flex items-center justify-center flex-shrink-0 ring-2 ring-white/20">
                    <Building2 className="w-10 h-10 text-white/40" />
                  </div>
                )
              )}
              <div>
                <div className="inline-flex items-center gap-2 bg-white/10 text-white/80 text-xs font-semibold px-3 py-1.5 rounded-full mb-4 backdrop-blur">
                  <div className="w-1.5 h-1.5 bg-emerald-400 rounded-full animate-pulse"></div>
                  {profile.user_type === 'business' ? 'Account Business' : 'Account Privato'}
                </div>
                <h1 className="text-3xl md:text-4xl font-bold text-white leading-tight mb-1">
                  {profile.user_type === 'business' && sedeName
                    ? sedeName
                    : `Ciao, ${activeProfile ? (activeProfile.nickname || activeProfile.name.split(' ')[0]) : (profile.full_name?.split(' ')[0] || 'Utente')}`
                  }
                </h1>
                {profile.user_type === 'business' && sedeCity && (
                  <p className="text-slate-300 text-sm flex items-center gap-1.5 mb-1">
                    <MapPin className="w-3.5 h-3.5" />
                    {sedeCity}{sedeProv ? `, ${sedeProv}` : ''}
                  </p>
                )}
                <p className="text-slate-400 text-base">
                  {profile.user_type === 'business' ? 'Gestisci la tua attivita e le sedi' : 'Gestisci il tuo profilo e le attivita'}
                </p>
              </div>
            </div>
            {currentSubscription && (
              <div className="bg-white/10 backdrop-blur border border-white/20 rounded-2xl px-5 py-4 flex items-center gap-4">
                <div>
                  <p className="text-xs text-slate-400 mb-0.5">Piano Attivo</p>
                  <p className="text-base font-bold text-white">{currentSubscription.plan.name}</p>
                  <p className="text-xs text-slate-400">
                    {currentSubscription.plan.billing_period === 'monthly' ? 'Mensile' : 'Annuale'}
                  </p>
                </div>
                {currentSubscription.status === 'trial' && (
                  <span className="inline-flex items-center gap-1.5 text-xs font-semibold text-emerald-300 bg-emerald-500/20 border border-emerald-500/30 px-2.5 py-1 rounded-full">
                    <div className="w-1 h-1 bg-emerald-400 rounded-full animate-pulse"></div>
                    Prova gratuita
                  </span>
                )}
              </div>
            )}
          </div>
            );
          })()}
        </div>
      </section>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

        {profile.user_type === 'business' && (
          <TrialStatusBanner onUpgradeClick={() => navigate('/subscription')} />
        )}

        {loading ? (
          <div className="text-center py-12">
            <div className="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
          </div>
        ) : (
          <div className="space-y-3">

            {profile.user_type === 'business' ? (
              <>
                {selectedBusinessLocationId && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
                    <div className="grid grid-cols-2 gap-3">
                      <div className="text-center">
                        <p className="text-2xl font-bold text-yellow-600">{reviews.length}</p>
                        <p className="text-xs text-gray-500 mt-0.5 flex items-center justify-center gap-1"><Star className="w-3 h-3" />Recensioni</p>
                      </div>
                      <div className="text-center border-l border-gray-100">
                        <p className="text-2xl font-bold text-orange-600">{jobPostings.length}</p>
                        <p className="text-xs text-gray-500 mt-0.5 flex items-center justify-center gap-1"><Briefcase className="w-3 h-3" />Offerte</p>
                      </div>
                    </div>
                  </div>
                )}

                {/* Badge navigation - Business */}
                <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-4">
                  <div className="flex flex-wrap gap-2">
                    {([
                      { key: 'biz_ads', label: 'I Miei Annunci', icon: Tag, color: 'green', badge: businessClassifiedAds.length > 0 ? String(businessClassifiedAds.length) : null },
                      { key: 'biz_jobs', label: 'Offerte di Lavoro', icon: Briefcase, color: 'blue', badge: jobPostings.length > 0 ? String(jobPostings.length) : null },
                      { key: 'biz_reviews', label: 'Recensioni Ricevute', icon: Star, color: 'amber', badge: reviews.length > 0 ? String(reviews.length) : null },
                      { key: 'biz_auctions', label: 'Le Mie Aste', icon: TrendingUp, color: 'orange', badge: null },
                      { key: 'biz_favorites', label: 'Preferiti', icon: Heart, color: 'red', badge: null },
                      ...(!selectedBusinessLocationId ? [{ key: 'business_activities', label: 'Le Mie Attivita', icon: Building, color: 'sky', badge: businesses.length > 0 ? String(businesses.length) : null }] : []),
                      { key: 'biz_seekers', label: 'Profili Cerco Lavoro', icon: Users, color: 'teal', badge: jobSeekers.length > 0 ? String(jobSeekers.length) : null },
                      ...(solidarityStats ? [{ key: 'biz_solidarity', label: 'Solidarieta', icon: Gift, color: 'emerald', badge: null }] : []),
                      ...(currentSubscription && availablePlans.length > 0 ? [{ key: 'business_plans', label: 'Cambia Piano', icon: Shield, color: 'slate', badge: currentSubscription.plan.name }] : []),
                    ] as Array<{ key: string; label: string; icon: React.ElementType; color: string; badge: string | null }>).map(({ key, label, icon: Icon, color, badge }) => {
                      const active = !!openSections[key];
                      const colorMap: Record<string, { on: string; off: string }> = {
                        green:   { on: 'bg-green-600 text-white border-green-600',     off: 'bg-green-50 text-green-700 border-green-200 hover:bg-green-100' },
                        blue:    { on: 'bg-blue-600 text-white border-blue-600',       off: 'bg-blue-50 text-blue-700 border-blue-200 hover:bg-blue-100' },
                        amber:   { on: 'bg-amber-500 text-white border-amber-500',     off: 'bg-amber-50 text-amber-700 border-amber-200 hover:bg-amber-100' },
                        orange:  { on: 'bg-orange-500 text-white border-orange-500',   off: 'bg-orange-50 text-orange-700 border-orange-200 hover:bg-orange-100' },
                        red:     { on: 'bg-red-500 text-white border-red-500',         off: 'bg-red-50 text-red-700 border-red-200 hover:bg-red-100' },
                        sky:     { on: 'bg-sky-500 text-white border-sky-500',         off: 'bg-sky-50 text-sky-700 border-sky-200 hover:bg-sky-100' },
                        teal:    { on: 'bg-teal-600 text-white border-teal-600',       off: 'bg-teal-50 text-teal-700 border-teal-200 hover:bg-teal-100' },
                        emerald: { on: 'bg-emerald-600 text-white border-emerald-600', off: 'bg-emerald-50 text-emerald-700 border-emerald-200 hover:bg-emerald-100' },
                        slate:   { on: 'bg-slate-600 text-white border-slate-600',     off: 'bg-slate-50 text-slate-700 border-slate-200 hover:bg-slate-100' },
                      };
                      const cls = colorMap[color] ?? colorMap.blue;
                      return (
                        <button key={key} onClick={() => toggleSection(key)} className={`inline-flex items-center gap-1.5 px-3 py-2 rounded-xl border text-xs font-semibold transition-all ${active ? cls.on : cls.off}`}>
                          <Icon className="w-3.5 h-3.5 flex-shrink-0" />
                          <span>{label}</span>
                          {badge && <span className={`ml-0.5 min-w-[18px] h-[18px] flex items-center justify-center rounded-full text-[10px] font-bold px-1 ${active ? 'bg-white/30 text-white' : 'bg-white shadow-sm'}`}>{badge}</span>}
                        </button>
                      );
                    })}
                  </div>
                </div>

                {/* I Miei Annunci */}
                {openSections.biz_ads && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                    <div className="flex items-center justify-between px-5 py-4 border-b border-gray-100">
                      <div className="flex items-center gap-3">
                        <div className="w-8 h-8 bg-green-100 rounded-lg flex items-center justify-center"><Tag className="w-4 h-4 text-green-600" /></div>
                        <span className="font-semibold text-gray-900">I Miei Annunci</span>
                        {businessClassifiedAds.length > 0 && <span className="bg-green-100 text-green-700 text-xs font-bold px-2 py-0.5 rounded-full">{businessClassifiedAds.length}</span>}
                      </div>
                      <button onClick={() => { setEditingClassifiedAdId(undefined); setShowClassifiedAdForm(true); }} className="bg-green-600 hover:bg-green-700 text-white px-3 py-1.5 rounded-lg text-xs font-semibold flex items-center gap-1"><Plus className="w-3 h-3" />Nuovo</button>
                    </div>
                    <div className="px-5 pb-5">
                      {businessClassifiedAds.length === 0 ? (
                        <div className="text-center py-8">
                          <Tag className="w-10 h-10 text-gray-200 mx-auto mb-3" />
                          <p className="text-sm text-gray-500 mb-3">Nessun annuncio pubblicato</p>
                          <button onClick={() => { setEditingClassifiedAdId(undefined); setShowClassifiedAdForm(true); }} className="inline-flex items-center gap-2 bg-green-600 text-white px-4 py-2 rounded-xl hover:bg-green-700 text-sm font-semibold"><Plus className="w-4 h-4" />Crea annuncio</button>
                        </div>
                      ) : (
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-3 pt-4">
                          {businessClassifiedAds.map(ad => (
                            <ProfileClassifiedAdCard key={ad.id} ad={{ ...ad, price: ad.price ? parseFloat(ad.price) : null, classified_categories: ad.classified_categories, profiles: { full_name: profile?.nickname || profile?.full_name || 'Utente', avatar_url: null } }} onEdit={(ad) => { setEditingClassifiedAdId(ad.id); setShowClassifiedAdForm(true); }} onDelete={deleteClassifiedAd} />
                          ))}
                        </div>
                      )}
                    </div>
                  </div>
                )}

                {/* Offerte di Lavoro */}
                {openSections.biz_jobs && !loading && (selectedBusinessId || businesses[0]?.id) && (
                  <BusinessJobPostingForm key={`${selectedBusinessId || businesses[0]?.id}-${selectedBusinessLocationId || 'all'}`} businessId={(selectedBusinessId || businesses[0]?.id)!} isRegisteredBusiness={isRegisteredBusiness} selectedLocationId={selectedBusinessLocationId || undefined} />
                )}

                {/* Recensioni Ricevute */}
                {openSections.biz_reviews && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                    <div className="flex items-center gap-3 px-5 py-4 border-b border-gray-100">
                      <div className="w-8 h-8 bg-amber-100 rounded-lg flex items-center justify-center"><Star className="w-4 h-4 text-amber-600" /></div>
                      <span className="font-semibold text-gray-900">{selectedBusinessLocationId ? 'Recensioni Sede' : 'Recensioni Ricevute'}</span>
                      {reviews.length > 0 && <span className="bg-amber-100 text-amber-700 text-xs font-bold px-2 py-0.5 rounded-full">{reviews.length}</span>}
                    </div>
                    <div className="px-5 pb-5">
                      {reviews.length === 0 ? (
                        <p className="text-gray-500 text-sm text-center py-6">{selectedBusinessLocationId ? 'Nessuna recensione per questa sede' : 'Nessuna recensione ricevuta'}</p>
                      ) : (
                        <div className="space-y-3 pt-4">
                          {reviews.map((review) => (
                            <div key={review.id} className="border border-gray-100 rounded-xl p-4">
                              <div className="flex items-start justify-between mb-1">
                                <div className="flex">{[...Array(5)].map((_, i) => <Star key={i} className={`w-3.5 h-3.5 ${i < review.rating ? 'fill-yellow-400 text-yellow-400' : 'text-gray-300'}`} />)}</div>
                                <span className="text-xs text-gray-400">{new Date(review.created_at).toLocaleDateString('it-IT')}</span>
                              </div>
                              <h4 className="font-semibold text-sm mb-1">{review.title}</h4>
                              <p className="text-gray-600 text-sm">{review.content}</p>
                              {!review.responses || review.responses.length === 0 ? (
                                <button onClick={() => setShowResponseForm(review.id)} className="mt-2 text-blue-600 text-xs hover:text-blue-700 flex items-center gap-1"><MessageSquare className="w-3.5 h-3.5" />Rispondi</button>
                              ) : (
                                <div className="mt-2 pl-3 border-l-2 border-blue-200"><p className="text-xs font-medium text-gray-500 mb-0.5">La tua risposta:</p><p className="text-xs text-gray-700">{review.responses[0].content}</p></div>
                              )}
                            </div>
                          ))}
                        </div>
                      )}
                    </div>
                  </div>
                )}

                {/* Le Mie Aste */}
                {openSections.biz_auctions && (
                  <UserAuctionsSection />
                )}

                {/* Preferiti */}
                {openSections.biz_favorites && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                    <div className="flex items-center gap-3 px-5 py-4 border-b border-gray-100">
                      <div className="w-8 h-8 bg-red-100 rounded-lg flex items-center justify-center"><Heart className="w-4 h-4 text-red-500" /></div>
                      <span className="font-semibold text-gray-900">Preferiti</span>
                    </div>
                    <FavoritesSection />
                  </div>
                )}

                {/* Le Mie Attivita */}
                {openSections.business_activities && !selectedBusinessLocationId && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                    <div className="flex items-center justify-between px-5 py-4 border-b border-gray-100">
                      <div className="flex items-center gap-3">
                        <div className="w-8 h-8 bg-sky-100 rounded-lg flex items-center justify-center"><Building className="w-4 h-4 text-sky-600" /></div>
                        <span className="font-semibold text-gray-900">Le Mie Attivita</span>
                        {businesses.length > 0 && <span className="bg-sky-100 text-sky-700 text-xs font-bold px-2 py-0.5 rounded-full">{businesses.length}</span>}
                      </div>
                      <button onClick={() => setShowCreateBusinessForm(true)} className="bg-sky-600 hover:bg-sky-700 text-white px-3 py-1.5 rounded-lg text-xs font-semibold flex items-center gap-1"><Plus className="w-3 h-3" />Aggiungi</button>
                    </div>
                    <div className="px-5 pb-5 pt-4">
                      {showCreateBusinessForm ? (
                        <CreateBusinessForm ownerId={profile.id} onSuccess={() => { setShowCreateBusinessForm(false); loadDashboardData(); }} onCancel={() => setShowCreateBusinessForm(false)} />
                      ) : (
                        <>
                          {businesses.length === 0 ? (
                            <p className="text-sm text-gray-500 text-center py-4">Non hai ancora registrato nessuna attivita</p>
                          ) : (
                            <div className="grid gap-2 mb-4">
                              {businesses.map((business) => (
                                <div key={business.id} onClick={() => setSelectedBusinessId(business.id)} className={`border rounded-xl p-3 cursor-pointer transition-all flex items-center justify-between ${selectedBusinessId === business.id ? 'border-sky-500 bg-sky-50' : 'border-gray-200 hover:border-sky-300'}`}>
                                  <div><h3 className="font-semibold text-gray-900 text-sm">{business.name}</h3><p className="text-gray-500 text-xs">{business.city}</p></div>
                                  {business.verified ? <span className="px-2 py-0.5 bg-green-100 text-green-700 text-xs rounded-full font-medium">Verificato</span> : <span className="px-2 py-0.5 bg-yellow-100 text-yellow-700 text-xs rounded-full font-medium">In Attesa</span>}
                                </div>
                              ))}
                            </div>
                          )}
                          {selectedBusinessId && (
                            <>
                              <EditBusinessForm businessId={selectedBusinessId} selectedLocationId={selectedBusinessLocationId} onUpdate={loadDashboardData} />
                              <EditBusinessLocationsForm businessId={selectedBusinessId} selectedLocationId={selectedBusinessLocationId} onUpdate={loadDashboardData} />
                            </>
                          )}
                          <ImportBusinessesForm onImportComplete={loadDashboardData} />
                        </>
                      )}
                    </div>
                  </div>
                )}

                {/* Profili Cerco Lavoro */}
                {openSections.biz_seekers && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                    <div className="flex items-center gap-3 px-5 py-4 border-b border-gray-100">
                      <div className="w-8 h-8 bg-teal-100 rounded-lg flex items-center justify-center"><Users className="w-4 h-4 text-teal-600" /></div>
                      <span className="font-semibold text-gray-900">Profili Cerco Lavoro</span>
                      {jobSeekers.length > 0 && <span className="bg-teal-100 text-teal-700 text-xs font-bold px-2 py-0.5 rounded-full">{jobSeekers.length}</span>}
                    </div>
                    <div className="px-5 pb-5">
                      {jobSeekers.length === 0 ? (
                        <p className="text-sm text-gray-500 text-center py-6">Nessun profilo disponibile</p>
                      ) : (
                        <div className="grid gap-2 pt-4">
                          {jobSeekers.map((seeker) => (
                            <div key={seeker.id} className="border border-gray-100 rounded-xl p-3 hover:border-teal-200 transition-all flex items-center gap-3">
                              {seeker.profiles.avatar_url ? <img src={seeker.profiles.avatar_url} alt={seeker.profiles.full_name} className="w-9 h-9 rounded-full object-cover flex-shrink-0" /> : <div className="w-9 h-9 rounded-full bg-teal-100 flex items-center justify-center text-teal-600 font-bold text-sm flex-shrink-0">{seeker.profiles.full_name.charAt(0)}</div>}
                              <div className="flex-1 min-w-0">
                                <div className="flex items-start justify-between gap-2">
                                  <h3 className="font-semibold text-gray-900 text-sm truncate">{seeker.title}</h3>
                                  <span className="px-2 py-0.5 bg-teal-100 text-teal-700 text-xs rounded-full font-medium flex-shrink-0">{seeker.category}</span>
                                </div>
                                <p className="text-xs text-gray-500">{seeker.profiles.nickname || seeker.profiles.full_name} · {seeker.city}</p>
                              </div>
                            </div>
                          ))}
                        </div>
                      )}
                      <div className="mt-3 text-center"><button onClick={() => navigate('/jobs')} className="text-teal-600 text-sm font-semibold hover:underline">Vedi tutti i profili</button></div>
                    </div>
                  </div>
                )}

                {/* Solidarieta */}
                {openSections.biz_solidarity && solidarityStats && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                    <div className="flex items-center gap-3 px-5 py-4 border-b border-gray-100">
                      <div className="w-8 h-8 bg-emerald-100 rounded-lg flex items-center justify-center"><Gift className="w-4 h-4 text-emerald-600" /></div>
                      <span className="font-semibold text-gray-900">Solidarieta</span>
                      <span className="bg-emerald-100 text-emerald-700 text-xs font-bold px-2 py-0.5 rounded-full">€{solidarityStats.charity_amount.toLocaleString('it-IT', { maximumFractionDigits: 0 })}</span>
                    </div>
                    <div className="px-5 pb-5 pt-4">
                      <div className="grid md:grid-cols-2 gap-3">
                        <div className="bg-green-50 rounded-xl p-4 border border-green-100"><div className="flex items-center gap-2 mb-1"><DollarSign className="w-4 h-4 text-green-600" /><span className="text-xs font-semibold text-gray-600">Fatturato Totale</span></div><p className="text-xl font-bold text-green-600">€{solidarityStats.total_revenue.toLocaleString('it-IT', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</p></div>
                        <div className="bg-blue-50 rounded-xl p-4 border border-blue-100"><div className="flex items-center gap-2 mb-1"><Heart className="w-4 h-4 text-blue-600" /><span className="text-xs font-semibold text-gray-600">Donato in Beneficenza</span></div><p className="text-xl font-bold text-blue-600">€{solidarityStats.charity_amount.toLocaleString('it-IT', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</p></div>
                      </div>
                      <div className="mt-3 text-center"><button onClick={() => navigate('/solidarity')} className="text-emerald-600 text-sm font-semibold hover:underline">Scopri di piu</button></div>
                    </div>
                  </div>
                )}

                {/* Cambia Piano */}
                {openSections.business_plans && currentSubscription && availablePlans.length > 0 && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                    <div className="flex items-center gap-3 px-5 py-4 border-b border-gray-100">
                      <div className="w-8 h-8 bg-slate-100 rounded-lg flex items-center justify-center"><Shield className="w-4 h-4 text-slate-600" /></div>
                      <span className="font-semibold text-gray-900">Cambia Piano</span>
                      <span className="bg-slate-100 text-slate-600 text-xs font-bold px-2 py-0.5 rounded-full">{currentSubscription.plan.name}</span>
                    </div>
                    <div className="px-5 pb-5 pt-4">
                      {upgradeMessage && <div className={`mb-4 p-3 rounded-xl text-sm ${upgradeMessage.includes('successo') ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}`}>{upgradeMessage}</div>}
                      <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-3">
                        {availablePlans.map((plan) => {
                          const monthlyEquivalent = availablePlans.find(p => p.max_persons === plan.max_persons && p.billing_period === 'monthly');
                          const isAnnual = plan.billing_period === 'yearly';
                          const savings = isAnnual && monthlyEquivalent ? (monthlyEquivalent.price * 12) - plan.price : null;
                          const isCurrent = currentSubscription.plan.id === plan.id;
                          return (
                            <div key={plan.id} className={`rounded-xl p-4 border-2 relative ${isCurrent ? 'border-blue-500 bg-blue-50' : 'border-gray-200 hover:border-blue-300'}`}>
                              {isAnnual && !isCurrent && <span className="absolute -top-2.5 left-1/2 -translate-x-1/2 bg-green-500 text-white text-xs font-bold px-2.5 py-0.5 rounded-full">RISPARMIO</span>}
                              <h3 className="font-bold text-gray-900 text-sm mb-0.5">{plan.name}</h3>
                              <p className="text-xs text-gray-500 mb-2">{plan.billing_period === 'monthly' ? 'Mensile' : 'Annuale'} · {plan.max_persons} {plan.max_persons === 1 ? 'sede' : 'sedi'}</p>
                              <p className="text-xl font-bold text-blue-600 mb-0.5">€{Number(plan.price).toFixed(2)}</p>
                              <p className="text-xs text-gray-400 mb-2">+ IVA / {plan.billing_period === 'monthly' ? 'mese' : 'anno'}</p>
                              {savings && <p className="text-xs text-green-600 font-semibold mb-2">Risparmi €{savings.toFixed(2)}</p>}
                              {isCurrent ? <div className="w-full bg-blue-600 text-white py-1.5 rounded-lg text-xs font-semibold text-center">Piano Attuale</div> : <button onClick={() => handleChangePlan(plan.id)} className="w-full bg-gray-800 hover:bg-gray-900 text-white py-1.5 rounded-lg text-xs font-semibold transition-colors">Scegli Piano</button>}
                            </div>
                          );
                        })}
                      </div>
                    </div>
                  </div>
                )}
              </>
            ) : (
              /* ── PRIVATO ──────────────────────────────────────────── */
              <>
                {/* Badge navigation row */}
                <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-4">
                  <div className="flex flex-wrap gap-2">
                    {[
                      { key: 'leaderboard', label: 'La Tua Classifica', icon: Trophy, color: 'yellow', badge: userRank ? `#${userRank.rank}` : null },
                      { key: 'activities', label: 'Attività Aggiunte', icon: Activity, color: 'blue', badge: null },
                      { key: 'job_seekers_customer', label: 'Annunci Cerco Lavoro', icon: Briefcase, color: 'sky', badge: null },
                      { key: 'reviews', label: 'Le Tue Recensioni', icon: Star, color: 'amber', badge: reviews.filter(r => !r.family_member_id).length > 0 ? String(reviews.filter(r => !r.family_member_id).length) : null },
                      { key: 'ads', label: 'I Tuoi Annunci', icon: Tag, color: 'green', badge: customerClassifiedAds.length > 0 ? String(customerClassifiedAds.length) : null },
                      { key: 'auctions_customer', label: 'Le Mie Aste', icon: TrendingUp, color: 'orange', badge: null },
                      { key: 'fav_ads', label: 'Annunci Preferiti', icon: Heart, color: 'red', badge: null },
                      { key: 'fav_businesses', label: 'Attività Preferite', icon: Building, color: 'rose', badge: favBusinessesCount > 0 ? String(favBusinessesCount) : null },
                    ].map(({ key, label, icon: Icon, color, badge }) => {
                      const colorMap: Record<string, string> = {
                        yellow: openSections[key] ? 'bg-yellow-500 text-white border-yellow-500' : 'bg-yellow-50 text-yellow-700 border-yellow-200 hover:bg-yellow-100',
                        blue: openSections[key] ? 'bg-blue-600 text-white border-blue-600' : 'bg-blue-50 text-blue-700 border-blue-200 hover:bg-blue-100',
                        sky: openSections[key] ? 'bg-sky-500 text-white border-sky-500' : 'bg-sky-50 text-sky-700 border-sky-200 hover:bg-sky-100',
                        amber: openSections[key] ? 'bg-amber-500 text-white border-amber-500' : 'bg-amber-50 text-amber-700 border-amber-200 hover:bg-amber-100',
                        green: openSections[key] ? 'bg-green-600 text-white border-green-600' : 'bg-green-50 text-green-700 border-green-200 hover:bg-green-100',
                        orange: openSections[key] ? 'bg-orange-500 text-white border-orange-500' : 'bg-orange-50 text-orange-700 border-orange-200 hover:bg-orange-100',
                        red: openSections[key] ? 'bg-red-500 text-white border-red-500' : 'bg-red-50 text-red-700 border-red-200 hover:bg-red-100',
                        rose: openSections[key] ? 'bg-rose-500 text-white border-rose-500' : 'bg-rose-50 text-rose-700 border-rose-200 hover:bg-rose-100',
                      };
                      return (
                        <button
                          key={key}
                          onClick={() => toggleSection(key)}
                          className={`inline-flex items-center gap-1.5 px-3 py-2 rounded-xl border text-xs font-semibold transition-all ${colorMap[color]}`}
                        >
                          <Icon className="w-3.5 h-3.5 flex-shrink-0" />
                          <span>{label}</span>
                          {badge && (
                            <span className={`ml-0.5 min-w-[18px] h-[18px] flex items-center justify-center rounded-full text-[10px] font-bold px-1 ${openSections[key] ? 'bg-white/30' : 'bg-white shadow-sm'} ${openSections[key] ? 'text-white' : ''}`}>
                              {badge}
                            </span>
                          )}
                        </button>
                      );
                    })}
                  </div>
                </div>

                {/* Classifica */}
                {openSections.leaderboard && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                    <div className="flex items-center gap-3 px-5 py-4 border-b border-gray-100">
                      <div className="w-8 h-8 bg-yellow-100 rounded-lg flex items-center justify-center"><Trophy className="w-4 h-4 text-yellow-600" /></div>
                      <span className="font-semibold text-gray-900">La Tua Classifica</span>
                      {userRank && <span className="bg-yellow-100 text-yellow-700 text-xs font-bold px-2 py-0.5 rounded-full">#{userRank.rank} · {userRank.points} pt</span>}
                    </div>
                    <div className="px-5 pb-5 pt-4">
                      {userRank && (
                        <div className="bg-gradient-to-br from-yellow-50 to-orange-50 border border-yellow-200 rounded-xl p-4 mb-4">
                          <div className="flex items-center justify-between">
                            <div className="flex items-center gap-3">
                              <div className={`w-12 h-12 rounded-full flex items-center justify-center font-bold text-lg shadow ${userRank.rank === 1 ? 'bg-gradient-to-br from-yellow-400 to-amber-500 text-white' : userRank.rank === 2 ? 'bg-gradient-to-br from-gray-300 to-gray-400 text-white' : userRank.rank === 3 ? 'bg-gradient-to-br from-orange-400 to-amber-600 text-white' : 'bg-gradient-to-br from-blue-400 to-blue-500 text-white'}`}>#{userRank.rank}</div>
                              <div><p className="text-xs text-gray-500">La tua posizione</p><p className="font-bold text-gray-900">{activeProfile?.isOwner === false ? activeProfile.name : profile?.nickname || profile?.full_name}</p></div>
                            </div>
                            <div className="text-right"><p className="text-2xl font-bold text-gray-900">{userRank.points}</p><p className="text-xs text-gray-500">punti · {userRank.reviews_count} rec.</p></div>
                          </div>
                        </div>
                      )}
                      <button onClick={() => navigate('/leaderboard')} className="w-full bg-gradient-to-r from-yellow-500 to-orange-500 text-white px-4 py-2.5 rounded-xl hover:from-yellow-600 hover:to-orange-600 transition-all font-semibold text-sm text-center">Classifica Completa</button>
                    </div>
                  </div>
                )}

                {/* Attività aggiunte */}
                {openSections.activities && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                    <div className="flex items-center gap-3 px-5 py-4 border-b border-gray-100">
                      <div className="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center"><Activity className="w-4 h-4 text-blue-600" /></div>
                      <span className="font-semibold text-gray-900">Attività Aggiunte</span>
                    </div>
                    <div className="border-t border-gray-100"><ActivityFeed /></div>
                  </div>
                )}

                {/* Annunci cerco lavoro */}
                {openSections.job_seekers_customer && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                    <div className="flex items-center gap-3 px-5 py-4 border-b border-gray-100">
                      <div className="w-8 h-8 bg-sky-100 rounded-lg flex items-center justify-center"><Briefcase className="w-4 h-4 text-sky-600" /></div>
                      <span className="font-semibold text-gray-900">Annunci Cerco Lavoro</span>
                    </div>
                    <div className="px-5 pb-5 pt-4">
                      <p className="text-sm text-gray-500 text-center py-4">Vai alla sezione lavoro per gestire il tuo profilo candidato.</p>
                      <button onClick={() => navigate('/jobs')} className="w-full bg-sky-600 text-white py-2.5 rounded-xl hover:bg-sky-700 transition-colors font-semibold text-sm">Vai a Cerca Lavoro</button>
                    </div>
                  </div>
                )}

                {/* Le Tue Recensioni */}
                {openSections.reviews && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                    <div className="flex items-center gap-3 px-5 py-4 border-b border-gray-100">
                      <div className="w-8 h-8 bg-amber-100 rounded-lg flex items-center justify-center"><Star className="w-4 h-4 text-amber-600" /></div>
                      <span className="font-semibold text-gray-900">Le Tue Recensioni</span>
                      {reviews.filter(r => !r.family_member_id).length > 0 && <span className="bg-amber-100 text-amber-700 text-xs font-bold px-2 py-0.5 rounded-full">{reviews.filter(r => !r.family_member_id).length}</span>}
                    </div>
                    <div className="px-5 pb-5">
                      {reviews.filter(r => !r.family_member_id).length === 0 ? (
                        <p className="text-sm text-gray-500 text-center py-6">Non hai ancora scritto recensioni</p>
                      ) : (
                        <div className="space-y-3 pt-4">
                          {reviews.filter(r => !r.family_member_id).map((review) => (
                            <div key={review.id} className="border border-gray-100 rounded-xl p-4">
                              <div className="flex items-start justify-between mb-1">
                                <div className="flex">{[...Array(5)].map((_, i) => <Star key={i} className={`w-3.5 h-3.5 ${i < review.rating ? 'fill-yellow-400 text-yellow-400' : 'text-gray-300'}`} />)}</div>
                                <span className="text-xs text-gray-400">{new Date(review.created_at).toLocaleDateString('it-IT')}</span>
                              </div>
                              <h4 className="font-semibold text-sm mb-0.5">{review.title}</h4>
                              <p className="text-gray-600 text-sm">{review.content}</p>
                            </div>
                          ))}
                        </div>
                      )}
                    </div>
                    {/* Recensioni familiari */}
                    {familyMembers.map((member) => {
                      const memberReviews = reviews.filter(r => r.family_member_id === member.id);
                      if (memberReviews.length === 0) return null;
                      return (
                        <div key={member.id} className="border-t border-gray-100 px-5 pb-5">
                          <p className="text-xs font-semibold text-gray-500 pt-3 pb-2">Recensioni di {member.nickname || `${member.first_name} ${member.last_name}`}</p>
                          <div className="space-y-3">
                            {memberReviews.map((review) => (
                              <div key={review.id} className="border border-gray-100 rounded-xl p-4">
                                <div className="flex items-start justify-between mb-1">
                                  <div className="flex">{[...Array(5)].map((_, i) => <Star key={i} className={`w-3.5 h-3.5 ${i < review.rating ? 'fill-yellow-400 text-yellow-400' : 'text-gray-300'}`} />)}</div>
                                  <span className="text-xs text-gray-400">{new Date(review.created_at).toLocaleDateString('it-IT')}</span>
                                </div>
                                <h4 className="font-semibold text-sm mb-0.5">{review.title}</h4>
                                <p className="text-gray-600 text-sm">{review.content}</p>
                              </div>
                            ))}
                          </div>
                        </div>
                      );
                    })}
                  </div>
                )}

                {/* I Tuoi Annunci */}
                {openSections.ads && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                    <div className="flex items-center justify-between px-5 py-4 border-b border-gray-100">
                      <div className="flex items-center gap-3">
                        <div className="w-8 h-8 bg-green-100 rounded-lg flex items-center justify-center"><Tag className="w-4 h-4 text-green-600" /></div>
                        <span className="font-semibold text-gray-900">I Tuoi Annunci</span>
                        {customerClassifiedAds.length > 0 && <span className="bg-green-100 text-green-700 text-xs font-bold px-2 py-0.5 rounded-full">{customerClassifiedAds.length}</span>}
                      </div>
                      <button onClick={() => { setEditingCustomerAdId(undefined); setShowCustomerAdForm(true); }} className="bg-green-600 hover:bg-green-700 text-white px-3 py-1.5 rounded-lg text-xs font-semibold flex items-center gap-1"><Plus className="w-3 h-3" />Nuovo</button>
                    </div>
                    <div className="px-5 pb-5">
                      {customerClassifiedAds.length === 0 ? (
                        <div className="text-center py-8">
                          <Tag className="w-10 h-10 text-gray-200 mx-auto mb-3" />
                          <p className="text-sm text-gray-500 mb-3">Nessun annuncio pubblicato</p>
                          <button onClick={() => { setEditingCustomerAdId(undefined); setShowCustomerAdForm(true); }} className="inline-flex items-center gap-2 bg-green-600 text-white px-4 py-2 rounded-xl hover:bg-green-700 text-sm font-semibold"><Plus className="w-4 h-4" />Crea annuncio</button>
                        </div>
                      ) : (
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-3 pt-4">
                          {customerClassifiedAds.map(ad => (
                            <ProfileClassifiedAdCard key={ad.id} ad={{ ...ad, price: ad.price ? parseFloat(ad.price) : null, classified_categories: ad.classified_categories, profiles: { full_name: profile?.nickname || profile?.full_name || 'Utente', avatar_url: null } }} onEdit={(ad) => { setEditingCustomerAdId(ad.id); setShowCustomerAdForm(true); }} onDelete={deleteClassifiedAd} />
                          ))}
                        </div>
                      )}
                    </div>
                  </div>
                )}

                {/* Le Mie Aste */}
                {openSections.auctions_customer && (
                  <UserAuctionsSection />
                )}

                {/* Annunci Preferiti */}
                {openSections.fav_ads && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                    <div className="flex items-center gap-3 px-5 py-4 border-b border-gray-100">
                      <div className="w-8 h-8 bg-red-100 rounded-lg flex items-center justify-center"><Heart className="w-4 h-4 text-red-500" /></div>
                      <span className="font-semibold text-gray-900">Annunci Preferiti</span>
                    </div>
                    <FavoritesSection />
                  </div>
                )}

                {/* Attività Preferite */}
                {openSections.fav_businesses && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                    <div className="flex items-center gap-3 px-5 py-4 border-b border-gray-100">
                      <div className="w-8 h-8 bg-rose-100 rounded-lg flex items-center justify-center"><Building className="w-4 h-4 text-rose-500" /></div>
                      <span className="font-semibold text-gray-900">Attività Preferite</span>
                    </div>
                    <FavoritesSection />
                  </div>
                )}

                {/* Cambia Piano - Privato */}
                {currentSubscription && availablePlans.length > 0 && (
                  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                    <button onClick={() => toggleSection('plans')} className="w-full flex items-center justify-between px-5 py-4 hover:bg-gray-50 transition-colors">
                      <div className="flex items-center gap-3">
                        <div className="w-8 h-8 bg-gray-100 rounded-lg flex items-center justify-center"><Shield className="w-4 h-4 text-gray-600" /></div>
                        <span className="font-semibold text-gray-900">Cambia Piano</span>
                        <span className="bg-gray-100 text-gray-600 text-xs font-bold px-2 py-0.5 rounded-full">{currentSubscription.plan.name}</span>
                      </div>
                      {openSections.plans ? <ChevronUp className="w-4 h-4 text-gray-400" /> : <ChevronDown className="w-4 h-4 text-gray-400" />}
                    </button>
                    {openSections.plans && (
                      <div className="px-5 pb-5 border-t border-gray-100 pt-4">
                        <div className="bg-gradient-to-br from-green-50 to-blue-50 border border-green-200 rounded-xl p-5 mb-4">
                          <div className="flex items-center gap-3 mb-3">
                            <div className="w-9 h-9 bg-green-500 rounded-full flex items-center justify-center"><Heart className="w-5 h-5 text-white" fill="currentColor" /></div>
                            <h3 className="font-bold text-gray-900">10% in Beneficenza</h3>
                          </div>
                          <p className="text-sm text-gray-700 mb-3">Ogni anno Lhimo dona il <strong>10% del fatturato</strong> ad associazioni di beneficenza.</p>
                          <div className="grid grid-cols-3 gap-2">
                            <div className="bg-white/80 rounded-lg p-2 text-center"><Gift className="w-4 h-4 text-green-600 mx-auto mb-1" /><p className="text-xs font-semibold text-gray-900">Trasparenza</p></div>
                            <div className="bg-white/80 rounded-lg p-2 text-center"><UsersIcon className="w-4 h-4 text-green-600 mx-auto mb-1" /><p className="text-xs font-semibold text-gray-900">Voti Utenti</p></div>
                            <div className="bg-white/80 rounded-lg p-2 text-center"><TrendingUp className="w-4 h-4 text-green-600 mx-auto mb-1" /><p className="text-xs font-semibold text-gray-900">Impatto Reale</p></div>
                          </div>
                        </div>
                        {upgradeMessage && <div className={`mb-4 p-3 rounded-xl text-sm ${upgradeMessage.includes('successo') ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}`}>{upgradeMessage}</div>}
                        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-3">
                          {availablePlans.map((plan) => {
                            const savings = calculateSavings(plan);
                            const isAnnual = plan.billing_period === 'yearly';
                            const isCurrent = currentSubscription.plan.id === plan.id;
                            return (
                              <div key={plan.id} className={`rounded-xl p-4 border-2 relative ${isCurrent ? 'border-yellow-500 bg-yellow-50' : isAnnual ? 'border-green-400 ring-2 ring-green-100' : 'border-gray-200 hover:border-blue-400'}`}>
                                {isAnnual && !isCurrent && <div className="absolute -top-2.5 left-1/2 -translate-x-1/2"><span className="inline-flex items-center gap-1 bg-green-500 text-white text-xs font-bold px-2.5 py-0.5 rounded-full"><Star className="w-2.5 h-2.5" fill="currentColor" />RISPARMIO</span></div>}
                                <h3 className="font-bold text-gray-900 text-sm mb-0.5">{plan.name}</h3>
                                <p className="text-xs text-gray-500 mb-3">{plan.billing_period === 'monthly' ? 'Mensile' : 'Annuale'} · {plan.max_persons} {plan.max_persons === 1 ? 'persona' : 'persone'}</p>
                                <p className="text-2xl font-bold text-blue-600 mb-0.5">€{Number(plan.price).toFixed(2)}</p>
                                <p className="text-xs text-gray-400 mb-2">/{plan.billing_period === 'monthly' ? 'mese' : 'anno'}</p>
                                {savings && <p className="text-xs text-green-600 font-semibold mb-3">Risparmi €{savings.toFixed(2)}</p>}
                                <div className="space-y-1 mb-3">
                                  {['Recensioni illimitate', 'Salva preferiti', 'Pubblica annunci'].map(f => (
                                    <div key={f} className="flex items-center gap-1.5 text-xs text-gray-600"><Check className="w-3 h-3 text-green-600 flex-shrink-0" />{f}</div>
                                  ))}
                                </div>
                                {isCurrent ? <div className="w-full bg-green-600 text-white py-2 rounded-lg text-xs font-semibold text-center">Piano Attuale</div> : <button onClick={() => handleChangePlan(plan.id)} className={`w-full py-2 rounded-lg text-xs font-semibold transition-colors ${isAnnual ? 'bg-green-600 text-white hover:bg-green-700' : 'bg-blue-600 text-white hover:bg-blue-700'}`}>Cambia Piano</button>}
                              </div>
                            );
                          })}
                        </div>
                      </div>
                    )}
                  </div>
                )}
              </>
            )}
          </div>
        )}

        {showClassifiedAdForm && (
          <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
            <div className="bg-white rounded-2xl shadow-2xl w-full max-w-2xl max-h-[90vh] overflow-y-auto">
              <ClassifiedAdForm adId={editingClassifiedAdId} onSuccess={() => { setShowClassifiedAdForm(false); loadBusinessClassifiedAds(); }} onCancel={() => setShowClassifiedAdForm(false)} />
            </div>
          </div>
        )}
        {showCustomerAdForm && (
          <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
            <div className="bg-white rounded-2xl shadow-2xl w-full max-w-2xl max-h-[90vh] overflow-y-auto">
              <ClassifiedAdForm adId={editingCustomerAdId} onSuccess={() => { setShowCustomerAdForm(false); loadCustomerClassifiedAds(); }} onCancel={() => setShowCustomerAdForm(false)} />
            </div>
          </div>
        )}
        {showResponseForm && (
          <ReviewResponseForm
            reviewId={showResponseForm}
            onClose={() => setShowResponseForm(null)}
            onSuccess={() => {
              setShowResponseForm(null);
              loadDashboardData();
            }}
          />
        )}
      </div>
    </div>
  );
}
