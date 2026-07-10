import { useState, useEffect } from 'react';
import { Shield, Users, FileText, ShoppingBag, Activity, CheckCircle, XCircle, Clock, Eye, Trash2, LogOut, Building2, AlertTriangle, Briefcase, MapPin, UserCheck, Heart, Award, TrendingUp, MessageSquare, Mail, CreditCard, BookOpen, Gavel, Layers } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import { AdminStats } from '../components/admin/AdminStats';
import { ReportsSection } from '../components/admin/ReportsSection';
import { BusinessesSection } from '../components/admin/BusinessesSection';
import { JobPostingsSection } from '../components/admin/JobPostingsSection';
import { ReviewsSection } from '../components/admin/ReviewsSection';
import { ClassifiedAdsSection } from '../components/admin/ClassifiedAdsSection';
import { AdminProfileDashboard } from '../components/admin/AdminProfileDashboard';
import UsersManagementSection from '../components/admin/UsersManagementSection';
import { SolidaritySection } from '../components/admin/SolidaritySection';
import { LeaderboardSection } from '../components/admin/LeaderboardSection';
import { BusinessTrackingSection } from '../components/admin/BusinessTrackingSection';
import { OsmImportSection } from '../components/admin/OsmImportSection';
import { MessagingSection } from '../components/admin/MessagingSection';
import { ContactSection } from '../components/admin/ContactSection';
import { PlatformMessagesSection } from '../components/admin/PlatformMessagesSection';
import { PlansSection } from '../components/admin/PlansSection';
import { RulesSection } from '../components/admin/RulesSection';
import { PageCustomizationSection } from '../components/admin/PageCustomizationSection';
import AuctionsSection from '../components/admin/AuctionsSection';
import { ProfessionalProfilesSection } from '../components/admin/ProfessionalProfilesSection';
import { useToast } from '../components/common/Toast';

interface DashboardStats {
  totalUsers: number;
  trialUsers: number;
  totalReviews: number;
  pendingReviews: number;
  totalAds: number;
  adsSell: number;
  adsBuy: number;
  adsGift: number;
  activeSubscriptions: number;
  trialSubscriptions: number;
  totalBusinesses: number;
  totalReports: number;
  pendingReports: number;
  pendingAds: number;
  pendingJobs: number;
  pendingAuctions: number;
  totalJobPostings: number;
  totalJobSeekers: number;
  totalAuctions: number;
  registeredBusinesses: number;
  importedBusinesses: number;
  userAddedBusinesses: number;
  claimedBusinesses: number;
  selfRegisteredBusinesses: number;
  totalLocations: number;
  totalFamilyMembers: number;
  solidarityTotal: number;
}

interface PendingCounts {
  reviews: number;
  ads: number;
  businesses: number;
  reports: number;
  auctions: number;
  jobs: number;
  jobSeekers: number;
  newUsers: number;
  newSubscriptions: number;
  newMessages: number;
  unreadPlatformMessages: number;
}

interface PendingReview {
  id: string;
  title: string;
  content: string;
  rating: number;
  overall_rating: number;
  price_rating: number | null;
  service_rating: number | null;
  quality_rating: number | null;
  proof_image_url: string | null;
  proof_documents: string[] | null;
  review_status: string;
  created_at: string;
  customer: {
    full_name: string;
    nickname: string | null;
    email: string;
  };
  family_member?: {
    nickname: string | null;
    full_name: string;
  } | null;
  business_id: string | null;
  business_location_id: string | null;
  unclaimed_business_location_id: string | null;
  business_location?: {
    name: string;
    internal_name: string | null;
    city: string;
    address: string;
  } | null;
  unclaimed_business_location?: {
    name: string;
    city: string;
    street: string;
  } | null;
  businesses?: {
    name: string;
  } | null;
}

interface User {
  id: string;
  full_name: string;
  email: string;
  user_type: string;
  subscription_status: string;
  created_at: string;
  is_admin: boolean;
}

interface Subscription {
  id: string;
  status: string;
  start_date: string;
  end_date: string;
  customer_id: string;
  plan_id: string;
  customer: {
    full_name: string;
    email: string;
    user_type: string;
    subscription_status: string | null;
    nickname?: string;
  };
  plan: {
    name: string;
    price: number;
  };
}

interface FamilyMember {
  id: string;
  nickname: string | null;
  full_name: string;
  relationship: string;
}

interface BusinessLocation {
  id: string;
  name: string;
  internal_name: string | null;
  city: string;
  province: string;
  address: string;
  phone: string | null;
  email: string | null;
}

interface ClassifiedAd {
  id: string;
  title: string;
  description: string;
  price: number | null;
  status: string;
  created_at: string;
  user: {
    full_name: string;
    email: string;
  };
}

interface Report {
  id: string;
  reason: string;
  description: string;
  status: string;
  created_at: string;
  reported_entity_type: string;
  reported_entity_id: string;
  reporter: {
    full_name: string;
    nickname: string | null;
    email: string;
  };
}

interface JobPosting {
  id: string;
  title: string;
  description: string;
  salary_range: string | null;
  location: string;
  status: string;
  created_at: string;
  business_location: {
    name: string;
  } | null;
}

interface RegisteredBusiness {
  id: string;
  name: string;
  vat_number: string | null;
  verified: boolean;
  is_verified?: boolean;
  created_at: string;
  owner: {
    full_name: string;
    email: string;
  };
  category: {
    name: string;
  } | null;
  locations_count: number;
}

export function AdminDashboardPage() {
  const { showToast } = useToast();
  const { profile, user } = useAuth();
  const [activeTab, setActiveTab] = useState('dashboard');

  // DB-persisted tab-seen timestamps so badges survive browser/device changes
  const [seenTabs, setSeenTabs] = useState<Record<string, string>>({});

  const handleTabChange = (tab: string) => {
    setActiveTab(tab);
    const now = new Date().toISOString();
    const updated = { ...seenTabs, [tab]: now };
    setSeenTabs(updated);
    if (user?.id) {
      supabase.from('admin_tab_seen')
        .upsert({ admin_id: user.id, tab, seen_at: now }, { onConflict: 'admin_id,tab' })
        .then(() => {});
    }
    // Reload counts immediately with the updated seen map so badge disappears at once
    loadPendingCounts(updated);
  };

  const [statsPeriod, setStatsPeriod] = useState<number | null>(null); // null = tutti i tempi
  const [stats, setStats] = useState<DashboardStats>({
    totalUsers: 0,
    trialUsers: 0,
    totalReviews: 0,
    pendingReviews: 0,
    totalAds: 0,
    adsSell: 0,
    adsBuy: 0,
    adsGift: 0,
    activeSubscriptions: 0,
    trialSubscriptions: 0,
    totalBusinesses: 0,
    totalReports: 0,
    pendingReports: 0,
    pendingAds: 0,
    pendingJobs: 0,
    pendingAuctions: 0,
    totalJobPostings: 0,
    totalJobSeekers: 0,
    totalAuctions: 0,
    registeredBusinesses: 0,
    importedBusinesses: 0,
    userAddedBusinesses: 0,
    claimedBusinesses: 0,
    selfRegisteredBusinesses: 0,
    totalLocations: 0,
    totalFamilyMembers: 0,
    solidarityTotal: 0,
  });
  const [pendingReviews, setPendingReviews] = useState<PendingReview[]>([]);
  const [users, setUsers] = useState<User[]>([]);
  const [subscriptions, setSubscriptions] = useState<Subscription[]>([]);
  const [classifiedAds, setClassifiedAds] = useState<ClassifiedAd[]>([]);
  const [reports, setReports] = useState<Report[]>([]);
  const [jobPostings, setJobPostings] = useState<JobPosting[]>([]);
  const [businesses, setBusinesses] = useState<RegisteredBusiness[]>([]);
  const [loading, setLoading] = useState(true);
  const [pendingCounts, setPendingCounts] = useState<PendingCounts>({ reviews: 0, ads: 0, businesses: 0, reports: 0, auctions: 0, jobs: 0, jobSeekers: 0, newUsers: 0, newSubscriptions: 0, newMessages: 0, unreadPlatformMessages: 0 });

  // Counts already reflect last-seen timestamps from loadPendingCounts; use directly
  const displayCounts = { ...pendingCounts };
  const [selectedReview, setSelectedReview] = useState<PendingReview | null>(null);
  const [isAdmin, setIsAdmin] = useState(false);
  const [checkingAdmin, setCheckingAdmin] = useState(true);
  const [selectedSubscription, setSelectedSubscription] = useState<Subscription | null>(null);
  const [familyMembers, setFamilyMembers] = useState<FamilyMember[]>([]);
  const [businessLocations, setBusinessLocations] = useState<BusinessLocation[]>([]);
  const [loadingDetails, setLoadingDetails] = useState(false);
  const [subscriptionFilters, setSubscriptionFilters] = useState({
    email: '',
    status: '',
    userType: '',
    planId: '',
    startDate: '',
    endDate: ''
  });
  const [availablePlans, setAvailablePlans] = useState<any[]>([]);

  useEffect(() => {
    const checkAdminStatus = async () => {
      if (!user) {
        console.log('No user found, redirecting to admin login');
        window.location.href = '/admin-login';
        return;
      }

      console.log('Checking admin status for user:', user.id, user.email);

      const { data: adminCheck, error: adminError } = await supabase
        .from('admins')
        .select('user_id')
        .eq('user_id', user.id)
        .maybeSingle();

      console.log('Admin check result:', { adminCheck, adminError });

      if (!adminCheck) {
        console.log('User is not an admin, redirecting to admin login');
        // Sign out the user first
        await supabase.auth.signOut();
        showToast('Non hai i permessi di amministratore. Effettua il logout e accedi con un account admin.', 'info');
        window.location.href = '/admin-login';
        return;
      }

      console.log('User is admin, loading dashboard');
      // Load seen-tab timestamps from DB so badge counts are correct from the start
      const { data: seenData } = await supabase
        .from('admin_tab_seen')
        .select('tab, seen_at')
        .eq('admin_id', user.id);
      const seenMap: Record<string, string> = {};
      if (seenData) seenData.forEach(r => { seenMap[r.tab] = r.seen_at; });
      setSeenTabs(seenMap);
      setIsAdmin(true);
      setCheckingAdmin(false);
      // Pass seenMap directly to avoid stale state in subsequent loadPendingCounts call
      setTimeout(() => loadPendingCounts(seenMap), 0);
    };

    checkAdminStatus();
  }, [user]);

  useEffect(() => {
    if (!checkingAdmin && isAdmin) {
      loadData();
      loadSubscriptionPlans();
    }
  }, [checkingAdmin, isAdmin, activeTab]);

  useEffect(() => {
    if (!checkingAdmin && isAdmin) {
      loadPendingCounts();
    }
  }, [checkingAdmin, isAdmin]);

  // Realtime subscriptions: refresh badge counts when pending items change
  useEffect(() => {
    if (!isAdmin) return;

    const channel = supabase
      .channel('admin_pending_realtime')
      .on('postgres_changes', { event: '*', schema: 'public', table: 'reviews' }, () => loadPendingCounts())
      .on('postgres_changes', { event: '*', schema: 'public', table: 'classified_ads' }, () => loadPendingCounts())
      .on('postgres_changes', { event: '*', schema: 'public', table: 'unclaimed_business_locations' }, () => loadPendingCounts())
      .on('postgres_changes', { event: '*', schema: 'public', table: 'reports' }, () => loadPendingCounts())
      .on('postgres_changes', { event: '*', schema: 'public', table: 'auctions' }, () => loadPendingCounts())
      .on('postgres_changes', { event: '*', schema: 'public', table: 'job_postings' }, () => loadPendingCounts())
      .on('postgres_changes', { event: '*', schema: 'public', table: 'job_seekers' }, () => loadPendingCounts())
      .on('postgres_changes', { event: '*', schema: 'public', table: 'platform_messages' }, () => loadPendingCounts())
      .on('postgres_changes', { event: 'INSERT', schema: 'public', table: 'profiles' }, () => loadPendingCounts())
      .on('postgres_changes', { event: 'INSERT', schema: 'public', table: 'subscriptions' }, () => loadPendingCounts())
      .subscribe();

    return () => { supabase.removeChannel(channel); };
  }, [isAdmin]);

  useEffect(() => {
    if (!checkingAdmin && isAdmin && activeTab === 'dashboard') {
      loadStats(statsPeriod);
    }
  }, [statsPeriod]);

  const loadPendingCounts = async (overrideSeen?: Record<string, string>) => {
    try {
      const seen = overrideSeen ?? seenTabs;
      // For informational tabs, count items created AFTER the last visit (or last 24h if never visited)
      const oneDayAgo = new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString();
      const usersSince = seen['users'] ?? oneDayAgo;
      const subsSince = seen['subscriptions'] ?? oneDayAgo;

      const [reviewsRes, adsRes, businessesRes, reportsRes, auctionsRes, jobsRes, jobSeekersRes, newUsersRes, newSubsRes, unreadPlatformMsgsRes] = await Promise.all([
        supabase.from('reviews').select('id', { count: 'exact', head: true }).eq('review_status', 'pending'),
        supabase.from('classified_ads').select('id', { count: 'exact', head: true }).eq('approval_status', 'pending'),
        supabase.from('unclaimed_business_locations').select('id', { count: 'exact', head: true }).eq('approval_status', 'pending'),
        supabase.from('reports').select('id', { count: 'exact', head: true }).eq('status', 'pending'),
        supabase.from('auctions').select('id', { count: 'exact', head: true }).eq('approval_status', 'pending'),
        supabase.from('job_postings').select('id', { count: 'exact', head: true }).eq('approval_status', 'pending'),
        supabase.from('job_seekers').select('id', { count: 'exact', head: true }).eq('approval_status', 'pending'),
        supabase.from('profiles').select('id', { count: 'exact', head: true }).gte('created_at', usersSince),
        supabase.from('subscriptions').select('id', { count: 'exact', head: true }).gte('created_at', subsSince),
        supabase.from('platform_messages').select('id', { count: 'exact', head: true }).eq('status', 'unread'),
      ]);
      setPendingCounts({
        reviews: reviewsRes.count || 0,
        ads: adsRes.count || 0,
        businesses: businessesRes.count || 0,
        reports: reportsRes.count || 0,
        auctions: auctionsRes.count || 0,
        jobs: jobsRes.count || 0,
        jobSeekers: jobSeekersRes.count || 0,
        newUsers: newUsersRes.count || 0,
        newSubscriptions: newSubsRes.count || 0,
        newMessages: 0,
        unreadPlatformMessages: unreadPlatformMsgsRes.count || 0,
      });
    } catch (error) {
      console.error('Error loading pending counts:', error);
    }
  };

  const loadData = async () => {
    setLoading(true);
    try {
      if (activeTab === 'dashboard') {
        await loadStats(statsPeriod);
      } else if (activeTab === 'reviews') {
        await loadPendingReviews();
      } else if (activeTab === 'users') {
        await loadUsers();
      } else if (activeTab === 'subscriptions') {
        await loadSubscriptions();
        await loadSubscriptionPlans();
      } else if (activeTab === 'ads') {
        await loadClassifiedAds();
      } else if (activeTab === 'reports') {
        await loadReports();
      } else if (activeTab === 'jobs') {
        await loadJobPostings();
      } else if (activeTab === 'businesses') {
        await loadBusinesses();
      }
    } catch (error) {
      console.error('Error loading data:', error);
    } finally {
      setLoading(false);
    }
  };

  const loadStats = async (days: number | null = null) => {
    const since = days !== null
      ? new Date(Date.now() - days * 24 * 60 * 60 * 1000).toISOString()
      : null;

    // Applica filtro data di creazione solo alle metriche di attività (non agli stati istantanei)
    const dated = (q: ReturnType<typeof supabase.from>) =>
      since ? (q as any).gte('created_at', since) : q;

    const [
      usersCount,
      trialUsersCount,
      reviewsCount,
      pendingReviewsCount,
      adsSellCount,
      adsBuyCount,
      adsGiftCount,
      activeSubsCount,
      trialSubsCount,
      reportsCount,
      pendingReportsCount,
      pendingAdsCount,
      pendingJobsCount,
      pendingAuctionsCount,
      jobPostingsCount,
      jobSeekersCount,
      auctionsCount,
      // Aziende — 4 tipologie
      importedBizCount,
      userAddedBizCount,
      selfRegisteredBizCount,
      claimedBizCount,
      locationsCount,
      familyCount,
      solidarityData,
    ] = await Promise.all([
      dated(supabase.from('profiles').select('id', { count: 'exact', head: true }).neq('user_type', 'admin')),
      // Stato istantaneo — non filtrato per data
      supabase.from('profiles').select('id', { count: 'exact', head: true }).eq('subscription_status', 'trial'),
      dated(supabase.from('reviews').select('id', { count: 'exact', head: true })),
      // Pending: sempre totale corrente
      supabase.from('reviews').select('id', { count: 'exact', head: true }).eq('review_status', 'pending'),
      dated(supabase.from('classified_ads').select('id', { count: 'exact', head: true }).eq('ad_type', 'sell')),
      dated(supabase.from('classified_ads').select('id', { count: 'exact', head: true }).eq('ad_type', 'buy')),
      dated(supabase.from('classified_ads').select('id', { count: 'exact', head: true }).eq('ad_type', 'gift')),
      // Abbonamenti attivi/trial: stato istantaneo
      supabase.from('subscriptions').select('id', { count: 'exact', head: true }).eq('status', 'active'),
      supabase.from('subscriptions').select('id', { count: 'exact', head: true }).eq('status', 'trial'),
      dated(supabase.from('reports').select('id', { count: 'exact', head: true })),
      // Pending: sempre stato istantaneo
      supabase.from('reports').select('id', { count: 'exact', head: true }).eq('status', 'pending'),
      supabase.from('classified_ads').select('id', { count: 'exact', head: true }).eq('approval_status', 'pending'),
      supabase.from('job_postings').select('id', { count: 'exact', head: true }).eq('approval_status', 'pending'),
      supabase.from('auctions').select('id', { count: 'exact', head: true }).eq('approval_status', 'pending'),
      dated(supabase.from('job_postings').select('id', { count: 'exact', head: true })),
      dated(supabase.from('job_seekers').select('id', { count: 'exact', head: true })),
      dated(supabase.from('auctions').select('id', { count: 'exact', head: true })),
      // Importate: unclaimed senza added_by (inserite da import OSM/Google)
      dated(supabase.from('unclaimed_business_locations').select('id', { count: 'exact', head: true }).is('added_by', null)),
      // Aggiunte da utente: unclaimed con added_by valorizzato
      dated(supabase.from('unclaimed_business_locations').select('id', { count: 'exact', head: true }).not('added_by', 'is', null)),
      // Iscritte da sole: source_type = 'direct_registration'
      dated(supabase.from('registered_businesses').select('id', { count: 'exact', head: true }).eq('source_type', 'direct_registration')),
      // Rivendicate: source_type claimed
      dated(supabase.from('registered_businesses').select('id', { count: 'exact', head: true }).in('source_type', ['claimed_imported', 'claimed_user_added'])),
      dated(supabase.from('registered_business_locations').select('id', { count: 'exact', head: true })),
      dated(supabase.from('customer_family_members').select('id', { count: 'exact', head: true })),
      since
        ? supabase.from('solidarity_documents').select('amount').gte('created_at', since)
        : supabase.from('solidarity_documents').select('amount'),
    ]);

    const solidarityTotal = (solidarityData.data || []).reduce(
      (sum: number, doc: { amount: number | null }) => sum + (doc.amount || 0),
      0
    );

    const imported = importedBizCount.count || 0;
    const userAdded = userAddedBizCount.count || 0;
    const selfReg = selfRegisteredBizCount.count || 0;
    const claimed = claimedBizCount.count || 0;

    setStats({
      totalUsers: usersCount.count || 0,
      trialUsers: trialUsersCount.count || 0,
      totalReviews: reviewsCount.count || 0,
      pendingReviews: pendingReviewsCount.count || 0,
      totalAds: (adsSellCount.count || 0) + (adsBuyCount.count || 0) + (adsGiftCount.count || 0),
      adsSell: adsSellCount.count || 0,
      adsBuy: adsBuyCount.count || 0,
      adsGift: adsGiftCount.count || 0,
      activeSubscriptions: activeSubsCount.count || 0,
      trialSubscriptions: trialSubsCount.count || 0,
      totalBusinesses: imported + userAdded + selfReg + claimed,
      totalReports: reportsCount.count || 0,
      pendingReports: pendingReportsCount.count || 0,
      pendingAds: pendingAdsCount.count || 0,
      pendingJobs: pendingJobsCount.count || 0,
      pendingAuctions: pendingAuctionsCount.count || 0,
      totalJobPostings: jobPostingsCount.count || 0,
      totalJobSeekers: jobSeekersCount.count || 0,
      totalAuctions: auctionsCount.count || 0,
      registeredBusinesses: selfReg + claimed,
      importedBusinesses: imported,
      userAddedBusinesses: userAdded,
      claimedBusinesses: claimed,
      selfRegisteredBusinesses: selfReg,
      totalLocations: locationsCount.count || 0,
      totalFamilyMembers: familyCount.count || 0,
      solidarityTotal,
    });
  };

  const loadPendingReviews = async () => {
    console.log('Loading reviews...');
    const { data, error } = await supabase
      .from('reviews')
      .select(`
        *,
        customer:profiles!customer_id(id, full_name, nickname, email),
        family_member:customer_family_members!family_member_id(first_name, last_name, nickname),
        business_location:business_locations!business_location_id(name, internal_name, city, province, region, address),
        unclaimed_business_location:unclaimed_business_locations!unclaimed_business_location_id(name, city, province, region, street, category:business_categories!category_id(name)),
        registered_business_location:registered_business_locations!registered_business_location_id(name, internal_name, city, province, region, street, category:business_categories!category_id(name), parent_business:registered_businesses!business_id(name)),
        registered_business:registered_businesses!registered_business_id(name),
        businesses:businesses!business_id(name),
        responses:review_responses(*)
      `)
      .order('created_at', { ascending: false })
      .limit(200);

    if (error) {
      console.error('Error loading reviews:', error);
      return;
    }

    console.log('Reviews loaded:', data?.length || 0, 'reviews');
    console.log('Reviews data:', data);
    setPendingReviews(data || []);
  };

  const loadUsers = async () => {
    const { data, error } = await supabase
      .from('profiles')
      .select('id, full_name, email, user_type, subscription_status, created_at, is_admin')
      .order('created_at', { ascending: false })
      .limit(100);

    if (error) {
      console.error('Error loading users:', error);
      return;
    }

    setUsers(data || []);
  };

  const loadSubscriptions = async () => {
    console.log('Loading subscriptions...');
    const { data: subsData, error: subsError } = await supabase
      .from('subscriptions')
      .select('id, status, start_date, end_date, customer_id, plan_id')
      .order('start_date', { ascending: false })
      .limit(100);

    if (subsError) {
      console.error('Error loading subscriptions:', subsError);
      console.error('Supabase request failed', subsError);
      return;
    }

    console.log('Subscriptions loaded:', subsData);

    // Carica i dati dei clienti e dei piani separatamente
    const enrichedSubs = await Promise.all(
      (subsData || []).map(async (sub) => {
        const [customerResult, planResult] = await Promise.all([
          supabase
            .from('profiles')
            .select('full_name, email, user_type, subscription_status, nickname')
            .eq('id', sub.customer_id)
            .maybeSingle(),
          supabase
            .from('subscription_plans')
            .select('name, price')
            .eq('id', sub.plan_id)
            .maybeSingle()
        ]);

        return {
          ...sub,
          customer: customerResult.data || { full_name: 'Unknown', email: '', user_type: 'customer', subscription_status: null, nickname: null },
          plan: planResult.data || { name: 'Unknown', price: 0 }
        };
      })
    );

    console.log('Enriched subscriptions:', enrichedSubs);
    setSubscriptions(enrichedSubs);
  };

  const loadSubscriptionPlans = async () => {
    const { data, error } = await supabase
      .from('subscription_plans')
      .select('id, name, price, billing_period, max_persons')
      .order('price', { ascending: true });

    if (error) {
      console.error('Error loading subscription plans:', error);
      return;
    }

    // Aggiungi il tipo utente determinato dal nome del piano
    const plansWithType = (data || []).map(plan => ({
      ...plan,
      target_user_type: plan.name.toLowerCase().includes('business') ? 'business' : 'customer'
    }));

    setAvailablePlans(plansWithType);
  };

  const loadClassifiedAds = async () => {
    const { data, error } = await supabase
      .from('classified_ads')
      .select(`
        id,
        title,
        description,
        price,
        status,
        approval_status,
        ad_type,
        city,
        province,
        region,
        images,
        created_at,
        expires_at,
        user_id,
        family_member_id,
        category_id,
        classified_categories!classified_ads_category_id_fkey(name),
        profiles!classified_ads_user_id_fkey(full_name, email, nickname)
      `)
      .order('created_at', { ascending: false })
      .limit(200);

    if (error) {
      console.error('Error loading ads:', error);
      return;
    }

    // Transform data to match expected format
    const transformedData = (data || []).map(ad => ({
      ...ad,
      category: ad.classified_categories?.name || 'N/A',
      user: ad.profiles || { full_name: 'Unknown', email: '', nickname: null }
    }));

    setClassifiedAds(transformedData as any);
  };

  const loadReports = async () => {
    const { data, error } = await supabase
      .from('reports')
      .select(`
        id,
        reason,
        description,
        status,
        created_at,
        reported_entity_type,
        reported_entity_id,
        family_member_id,
        reporter:profiles!reports_reporter_id_fkey(full_name, email, nickname),
        family_member:customer_family_members!reports_family_member_id_fkey(first_name, last_name, nickname)
      `)
      .order('created_at', { ascending: false })
      .limit(100);

    if (error) {
      console.error('Error loading reports:', error);
      return;
    }

    // Enrich reports with entity names
    const enrichedReports = await Promise.all((data || []).map(async (report: any) => {
      let entityName = '';

      try {
        if (report.reported_entity_type === 'classified_ad') {
          const { data: ad } = await supabase
            .from('classified_ads')
            .select('title')
            .eq('id', report.reported_entity_id)
            .maybeSingle();
          entityName = ad?.title || '';
        } else if (report.reported_entity_type === 'review') {
          const { data: review } = await supabase
            .from('reviews')
            .select('title')
            .eq('id', report.reported_entity_id)
            .maybeSingle();
          entityName = review?.title || '';
        } else if (report.reported_entity_type === 'business') {
          // Try different business tables
          let { data: business } = await supabase
            .from('registered_businesses')
            .select('name')
            .eq('id', report.reported_entity_id)
            .maybeSingle();

          if (!business) {
            const { data: location } = await supabase
              .from('registered_business_locations')
              .select('name')
              .eq('id', report.reported_entity_id)
              .maybeSingle();
            business = location;
          }

          if (!business) {
            const { data: unclaimed } = await supabase
              .from('unclaimed_business_locations')
              .select('name')
              .eq('id', report.reported_entity_id)
              .maybeSingle();
            business = unclaimed;
          }

          entityName = business?.name || '';
        } else if (report.reported_entity_type === 'job_posting') {
          const { data: job } = await supabase
            .from('job_postings')
            .select('title')
            .eq('id', report.reported_entity_id)
            .maybeSingle();
          entityName = job?.title || '';
        }
      } catch (err) {
        console.error('Error loading entity name:', err);
      }

      return {
        ...report,
        entity_name: entityName
      };
    }));

    setReports(enrichedReports);
  };

  const loadJobPostings = async () => {
    // Job postings are loaded directly by JobPostingsSection
  };

  const loadBusinesses = async () => {
    const { data, error } = await supabase
      .from('registered_businesses')
      .select(`
        id,
        name,
        vat_number,
        verified,
        created_at,
        owner:owner_id(full_name, email),
        category:category_id(name)
      `)
      .order('created_at', { ascending: false })
      .limit(100);

    if (error) {
      console.error('Error loading businesses:', error);
      return;
    }

    const businessesWithLocations = await Promise.all(
      (data || []).map(async (business) => {
        const { count } = await supabase
          .from('business_locations')
          .select('id', { count: 'exact', head: true })
          .eq('business_id', business.id);

        return {
          ...business,
          verified: business.is_verified,
          locations_count: count || 0,
        };
      })
    );

    setBusinesses(businessesWithLocations);
  };


  const approveReview = async (reviewId: string) => {
    try {
      const { error } = await supabase.rpc('approve_review', {
        review_id_param: reviewId,
        staff_id_param: profile!.id,
      });

      if (error) throw error;

      showToast('Recensione approvata con successo!', 'success');
      await loadPendingReviews();
      await loadPendingCounts();
      setSelectedReview(null);
    } catch (error: any) {
      console.error('Error approving review:', error);
      showToast(`Errore: ${error.message}`, 'error');
    }
  };

  const rejectReview = async (reviewId: string) => {
    try {
      const { error } = await supabase.rpc('reject_review', {
        review_id_param: reviewId,
        staff_id_param: profile!.id,
      });

      if (error) throw error;

      showToast('Recensione rifiutata', 'info');
      await loadPendingReviews();
      await loadPendingCounts();
      setSelectedReview(null);
    } catch (error: any) {
      console.error('Error rejecting review:', error);
      showToast(`Errore: ${error.message}`, 'error');
    }
  };

  const toggleAdmin = async (userId: string, currentStatus: boolean) => {
    const confirmMessage = currentStatus
      ? 'Sei sicuro di voler rimuovere i privilegi di amministratore a questo utente?'
      : 'Sei sicuro di voler concedere i privilegi di amministratore a questo utente?';

    if (!confirm(confirmMessage)) return;

    try {
      const { error } = await supabase
        .from('profiles')
        .update({ is_admin: !currentStatus })
        .eq('id', userId);

      if (error) throw error;

      showToast(`Stato admin ${!currentStatus ? 'abilitato' : 'disabilitato'} con successo`, 'success');
      await loadUsers();
    } catch (error: any) {
      console.error('Error updating admin status:', error);
      showToast(`Errore: ${error.message}`, 'error');
    }
  };

  const deleteUser = async (userId: string) => {
    if (!confirm('Sei sicuro di voler eliminare questo utente? Questa azione è irreversibile.')) {
      return;
    }

    try {
      const { error } = await supabase.rpc('delete_user_account', {
        user_id_to_delete: userId,
      });

      if (error) throw error;

      showToast('Utente eliminato con successo', 'success');
      await loadUsers();
    } catch (error: any) {
      console.error('Error deleting user:', error);
      showToast(`Errore: ${error.message}`, 'error');
    }
  };

  const updateSubscriptionStatus = async (subscriptionId: string, newStatus: string) => {
    try {
      const { error } = await supabase
        .from('subscriptions')
        .update({ status: newStatus })
        .eq('id', subscriptionId);

      if (error) throw error;

      showToast('Stato abbonamento aggiornato con successo', 'success');
      await loadSubscriptions();
    } catch (error: any) {
      console.error('Error updating subscription:', error);
      showToast(`Errore: ${error.message}`, 'error');
    }
  };

  const viewSubscriptionDetails = async (subscription: Subscription) => {
    setSelectedSubscription(subscription);
    setLoadingDetails(true);
    setFamilyMembers([]);
    setBusinessLocations([]);

    try {
      if (subscription.customer.user_type === 'customer') {
        // Carica membri famiglia per utenti privati
        const { data: familyData, error: familyError } = await supabase
          .from('customer_family_members')
          .select('id, nickname, first_name, last_name, relationship')
          .eq('customer_id', subscription.customer_id)
          .order('relationship');

        if (familyError) throw familyError;

        // Transform to match expected format
        const transformedFamily = (familyData || []).map(m => ({
          id: m.id,
          nickname: m.nickname,
          full_name: `${m.first_name} ${m.last_name}`,
          relationship: m.relationship
        }));

        setFamilyMembers(transformedFamily);
      } else if (subscription.customer.user_type === 'business') {
        // Carica sedi per aziende
        const { data: locationsData, error: locationsError } = await supabase
          .from('business_locations')
          .select('id, name, internal_name, city, province, address, phone, email')
          .eq('business_id', subscription.customer_id)
          .order('name');

        if (locationsError) throw locationsError;
        setBusinessLocations(locationsData || []);
      }
    } catch (error: any) {
      console.error('Error loading subscription details:', error);
      showToast(`Errore nel caricamento dei dettagli: ${error.message}`, 'error');
    } finally {
      setLoadingDetails(false);
    }
  };

  const closeSubscriptionDetails = () => {
    setSelectedSubscription(null);
    setFamilyMembers([]);
    setBusinessLocations([]);
  };

  const updateAdStatus = async (adId: string, newStatus: string) => {
    try {
      const { error } = await supabase
        .from('classified_ads')
        .update({ status: newStatus })
        .eq('id', adId);

      if (error) throw error;

      showToast('Stato annuncio aggiornato con successo', 'success');
      await loadClassifiedAds();
    } catch (error: any) {
      console.error('Error updating ad:', error);
      showToast(`Errore: ${error.message}`, 'error');
    }
  };

  const handleLogout = async () => {
    if (confirm('Sei sicuro di voler uscire?')) {
      try {
        // Log the logout time
        await supabase.rpc('log_admin_logout');

        await supabase.auth.signOut();
        localStorage.clear();
        window.location.href = '/';
      } catch (error) {
        console.error('Error during logout:', error);
        window.location.href = '/';
      }
    }
  };

  if (checkingAdmin) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto mb-4"></div>
          <p className="text-gray-600">Verifica permessi amministratore...</p>
        </div>
      </div>
    );
  }

  if (!isAdmin) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <Shield className="w-24 h-24 text-red-500 mx-auto mb-4" />
          <h1 className="text-3xl font-bold text-gray-900 mb-2">Accesso Negato</h1>
          <p className="text-gray-600 mb-4">Non hai i permessi per accedere a questa pagina.</p>
          <button
            onClick={() => window.location.href = '/admin-login'}
            className="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700"
          >
            Vai al Login Admin
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
      <div className="bg-white shadow-lg border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="py-6">
            <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4 mb-6">
              <div className="flex items-center gap-3">
                <div className="p-2 bg-gradient-to-br from-blue-500 to-blue-600 rounded-xl shadow-lg">
                  <Shield className="w-7 h-7 text-white" />
                </div>
                <div>
                  <h1 className="text-2xl md:text-3xl font-bold text-gray-900">Pannello Amministratore</h1>
                  <p className="text-sm text-gray-600">Benvenuto, {profile?.full_name} - Numero Utente: 123456</p>
                </div>
              </div>
              <button
                onClick={handleLogout}
                className="flex items-center justify-center gap-2 px-5 py-2.5 bg-gradient-to-r from-red-500 to-red-600 text-white rounded-xl hover:from-red-600 hover:to-red-700 transition-all duration-200 shadow-md hover:shadow-lg font-medium"
              >
                <LogOut className="w-4 h-4" />
                Esci
              </button>
            </div>

            <div className="flex gap-2 overflow-x-auto pb-2 scrollbar-hide">
              <button
                onClick={() => handleTabChange('dashboard')}
                className={`px-5 py-2.5 rounded-xl font-medium whitespace-nowrap transition-all duration-200 flex items-center gap-2 ${
                  activeTab === 'dashboard'
                    ? 'bg-gradient-to-r from-blue-500 to-blue-600 text-white shadow-md'
                    : 'bg-white text-gray-700 hover:bg-gray-50 border border-gray-200'
                }`}
              >
                <Activity className="w-4 h-4" />
                Dashboard
              </button>
              <button
                onClick={() => handleTabChange('reviews')}
                className={`relative px-5 py-2.5 rounded-xl font-medium whitespace-nowrap transition-all duration-200 flex items-center gap-2 ${
                  activeTab === 'reviews'
                    ? 'bg-gradient-to-r from-green-500 to-green-600 text-white shadow-md'
                    : 'bg-white text-gray-700 hover:bg-gray-50 border border-gray-200'
                }`}
              >
                <FileText className="w-4 h-4" />
                Recensioni
                {displayCounts.reviews > 0 && (
                  <span className="absolute -top-2 -right-2 min-w-[22px] h-[22px] flex items-center justify-center px-1.5 bg-red-600 text-white text-xs font-bold rounded-full shadow-lg ring-2 ring-white">
                    {displayCounts.reviews}
                  </span>
                )}
              </button>
              <button
                onClick={() => handleTabChange('users')}
                className={`relative px-5 py-2.5 rounded-xl font-medium whitespace-nowrap transition-all duration-200 flex items-center gap-2 ${
                  activeTab === 'users'
                    ? 'bg-gradient-to-r from-blue-500 to-blue-600 text-white shadow-md'
                    : 'bg-white text-gray-700 hover:bg-gray-50 border border-gray-200'
                }`}
              >
                <Users className="w-4 h-4" />
                Utenti
                {displayCounts.newUsers > 0 && (
                  <span className="absolute -top-2 -right-2 min-w-[22px] h-[22px] flex items-center justify-center px-1.5 bg-red-600 text-white text-xs font-bold rounded-full shadow-lg ring-2 ring-white">
                    {displayCounts.newUsers}
                  </span>
                )}
              </button>
              <button
                onClick={() => handleTabChange('subscriptions')}
                className={`relative px-5 py-2.5 rounded-xl font-medium whitespace-nowrap transition-all duration-200 flex items-center gap-2 ${
                  activeTab === 'subscriptions'
                    ? 'bg-gradient-to-r from-teal-500 to-teal-600 text-white shadow-md'
                    : 'bg-white text-gray-700 hover:bg-gray-50 border border-gray-200'
                }`}
              >
                <Activity className="w-4 h-4" />
                Abbonamenti
                {displayCounts.newSubscriptions > 0 && (
                  <span className="absolute -top-2 -right-2 min-w-[22px] h-[22px] flex items-center justify-center px-1.5 bg-red-600 text-white text-xs font-bold rounded-full shadow-lg ring-2 ring-white">
                    {displayCounts.newSubscriptions}
                  </span>
                )}
              </button>
              <button
                onClick={() => handleTabChange('ads')}
                className={`relative px-5 py-2.5 rounded-xl font-medium whitespace-nowrap transition-all duration-200 flex items-center gap-2 ${
                  activeTab === 'ads'
                    ? 'bg-gradient-to-r from-pink-500 to-pink-600 text-white shadow-md'
                    : 'bg-white text-gray-700 hover:bg-gray-50 border border-gray-200'
                }`}
              >
                <ShoppingBag className="w-4 h-4" />
                Annunci
                {displayCounts.ads > 0 && (
                  <span className="absolute -top-2 -right-2 min-w-[22px] h-[22px] flex items-center justify-center px-1.5 bg-red-600 text-white text-xs font-bold rounded-full shadow-lg ring-2 ring-white">
                    {displayCounts.ads}
                  </span>
                )}
              </button>
              <button
                onClick={() => handleTabChange('auctions')}
                className={`relative px-5 py-2.5 rounded-xl font-medium whitespace-nowrap transition-all duration-200 flex items-center gap-2 ${
                  activeTab === 'auctions'
                    ? 'bg-gradient-to-r from-orange-500 to-orange-600 text-white shadow-md'
                    : 'bg-white text-gray-700 hover:bg-gray-50 border border-gray-200'
                }`}
              >
                <Gavel className="w-4 h-4" />
                Aste
                {displayCounts.auctions > 0 && (
                  <span className="absolute -top-2 -right-2 min-w-[22px] h-[22px] flex items-center justify-center px-1.5 bg-red-600 text-white text-xs font-bold rounded-full shadow-lg ring-2 ring-white">
                    {displayCounts.auctions}
                  </span>
                )}
              </button>
              <button
                onClick={() => handleTabChange('reports')}
                className={`relative px-5 py-2.5 rounded-xl font-medium whitespace-nowrap transition-all duration-200 flex items-center gap-2 ${
                  activeTab === 'reports'
                    ? 'bg-gradient-to-r from-red-500 to-red-600 text-white shadow-md'
                    : 'bg-white text-gray-700 hover:bg-gray-50 border border-gray-200'
                }`}
              >
                <AlertTriangle className="w-4 h-4" />
                Segnalazioni
                {displayCounts.reports > 0 && (
                  <span className="absolute -top-2 -right-2 min-w-[22px] h-[22px] flex items-center justify-center px-1.5 bg-red-600 text-white text-xs font-bold rounded-full shadow-lg ring-2 ring-white">
                    {displayCounts.reports}
                  </span>
                )}
              </button>
              <button
                onClick={() => handleTabChange('businesses')}
                className={`relative px-5 py-2.5 rounded-xl font-medium whitespace-nowrap transition-all duration-200 flex items-center gap-2 ${
                  activeTab === 'businesses'
                    ? 'bg-gradient-to-r from-orange-500 to-orange-600 text-white shadow-md'
                    : 'bg-white text-gray-700 hover:bg-gray-50 border border-gray-200'
                }`}
              >
                <Building2 className="w-4 h-4" />
                Attività
                {displayCounts.businesses > 0 && (
                  <span className="absolute -top-2 -right-2 min-w-[22px] h-[22px] flex items-center justify-center px-1.5 bg-red-600 text-white text-xs font-bold rounded-full shadow-lg ring-2 ring-white">
                    {displayCounts.businesses}
                  </span>
                )}
              </button>
              <button
                onClick={() => handleTabChange('jobs')}
                className={`relative px-5 py-2.5 rounded-xl font-medium whitespace-nowrap transition-all duration-200 flex items-center gap-2 ${
                  activeTab === 'jobs'
                    ? 'bg-gradient-to-r from-cyan-500 to-cyan-600 text-white shadow-md'
                    : 'bg-white text-gray-700 hover:bg-gray-50 border border-gray-200'
                }`}
              >
                <Briefcase className="w-4 h-4" />
                Lavoro
                {(displayCounts.jobs + displayCounts.jobSeekers) > 0 && (
                  <span className="absolute -top-2 -right-2 min-w-[22px] h-[22px] flex items-center justify-center px-1.5 bg-red-600 text-white text-xs font-bold rounded-full shadow-lg ring-2 ring-white">
                    {displayCounts.jobs + displayCounts.jobSeekers}
                  </span>
                )}
              </button>
              <button
                onClick={() => handleTabChange('professional_profiles')}
                className={`px-5 py-2.5 rounded-xl font-medium whitespace-nowrap transition-all duration-200 flex items-center gap-2 ${
                  activeTab === 'professional_profiles'
                    ? 'bg-gradient-to-r from-blue-500 to-blue-600 text-white shadow-md'
                    : 'bg-white text-gray-700 hover:bg-gray-50 border border-gray-200'
                }`}
              >
                <UserCheck className="w-4 h-4" />
                Profili Prof.
              </button>
              <button
                onClick={() => handleTabChange('solidarity')}
                className={`px-5 py-2.5 rounded-xl font-medium whitespace-nowrap transition-all duration-200 flex items-center gap-2 ${
                  activeTab === 'solidarity'
                    ? 'bg-gradient-to-r from-pink-500 to-rose-600 text-white shadow-md'
                    : 'bg-white text-gray-700 hover:bg-gray-50 border border-gray-200'
                }`}
              >
                <Heart className="w-4 h-4" />
                Solidarietà
              </button>
              <button
                onClick={() => handleTabChange('leaderboard')}
                className={`px-5 py-2.5 rounded-xl font-medium whitespace-nowrap transition-all duration-200 flex items-center gap-2 ${
                  activeTab === 'leaderboard'
                    ? 'bg-gradient-to-r from-purple-500 to-purple-600 text-white shadow-md'
                    : 'bg-white text-gray-700 hover:bg-gray-50 border border-gray-200'
                }`}
              >
                <Award className="w-4 h-4" />
                Classifica
              </button>
              <button
                onClick={() => handleTabChange('tracking')}
                className={`px-5 py-2.5 rounded-xl font-medium whitespace-nowrap transition-all duration-200 flex items-center gap-2 ${
                  activeTab === 'tracking'
                    ? 'bg-gradient-to-r from-orange-500 to-amber-600 text-white shadow-md'
                    : 'bg-white text-gray-700 hover:bg-gray-50 border border-gray-200'
                }`}
              >
                <TrendingUp className="w-4 h-4" />
                Tracking
              </button>
              <button
                onClick={() => handleTabChange('osm_import')}
                className={`px-5 py-2.5 rounded-xl font-medium whitespace-nowrap transition-all duration-200 flex items-center gap-2 ${
                  activeTab === 'osm_import'
                    ? 'bg-gradient-to-r from-emerald-500 to-teal-600 text-white shadow-md'
                    : 'bg-white text-gray-700 hover:bg-gray-50 border border-gray-200'
                }`}
              >
                <MapPin className="w-4 h-4" />
                Import OSM
              </button>
              <button
                onClick={() => handleTabChange('messaging')}
                className={`relative px-5 py-2.5 rounded-xl font-medium whitespace-nowrap transition-all duration-200 flex items-center gap-2 ${
                  activeTab === 'messaging'
                    ? 'bg-gradient-to-r from-blue-500 to-blue-600 text-white shadow-md'
                    : 'bg-white text-gray-700 hover:bg-gray-50 border border-gray-200'
                }`}
              >
                <MessageSquare className="w-4 h-4" />
                Messaggi
                {displayCounts.newMessages > 0 && (
                  <span className="absolute -top-2 -right-2 min-w-[22px] h-[22px] flex items-center justify-center px-1.5 bg-red-600 text-white text-xs font-bold rounded-full shadow-lg ring-2 ring-white">
                    {displayCounts.newMessages}
                  </span>
                )}
              </button>
              <button
                onClick={() => handleTabChange('contact')}
                className={`relative px-5 py-2.5 rounded-xl font-medium whitespace-nowrap transition-all duration-200 flex items-center gap-2 ${
                  activeTab === 'contact'
                    ? 'bg-gradient-to-r from-cyan-500 to-cyan-600 text-white shadow-md'
                    : 'bg-white text-gray-700 hover:bg-gray-50 border border-gray-200'
                }`}
              >
                <Mail className="w-4 h-4" />
                Contatti
                {displayCounts.unreadPlatformMessages > 0 && (
                  <span className="absolute -top-2 -right-2 min-w-[22px] h-[22px] flex items-center justify-center px-1.5 bg-red-600 text-white text-xs font-bold rounded-full shadow-lg ring-2 ring-white">
                    {displayCounts.unreadPlatformMessages}
                  </span>
                )}
              </button>
              <button
                onClick={() => handleTabChange('platform_messages')}
                className={`px-5 py-2.5 rounded-xl font-medium whitespace-nowrap transition-all duration-200 flex items-center gap-2 ${
                  activeTab === 'platform_messages'
                    ? 'bg-gradient-to-r from-blue-500 to-blue-600 text-white shadow-md'
                    : 'bg-white text-gray-700 hover:bg-gray-50 border border-gray-200'
                }`}
              >
                <MessageSquare className="w-4 h-4" />
                Messaggi Utenti
                {displayCounts.unreadPlatformMessages > 0 && (
                  <span className="ml-1 bg-red-500 text-white text-xs font-bold px-1.5 py-0.5 rounded-full">
                    {displayCounts.unreadPlatformMessages}
                  </span>
                )}
              </button>
              <button
                onClick={() => handleTabChange('plans')}
                className={`px-5 py-2.5 rounded-xl font-medium whitespace-nowrap transition-all duration-200 flex items-center gap-2 ${
                  activeTab === 'plans'
                    ? 'bg-gradient-to-r from-pink-500 to-pink-600 text-white shadow-md'
                    : 'bg-white text-gray-700 hover:bg-gray-50 border border-gray-200'
                }`}
              >
                <CreditCard className="w-4 h-4" />
                Piani
              </button>
              <button
                onClick={() => handleTabChange('rules')}
                className={`px-5 py-2.5 rounded-xl font-medium whitespace-nowrap transition-all duration-200 flex items-center gap-2 ${
                  activeTab === 'rules'
                    ? 'bg-gradient-to-r from-indigo-500 to-indigo-600 text-white shadow-md'
                    : 'bg-white text-gray-700 hover:bg-gray-50 border border-gray-200'
                }`}
              >
                <BookOpen className="w-4 h-4" />
                Regole
              </button>
              <button
                onClick={() => handleTabChange('page_customization')}
                className={`px-5 py-2.5 rounded-xl font-medium whitespace-nowrap transition-all duration-200 flex items-center gap-2 ${
                  activeTab === 'page_customization'
                    ? 'bg-gradient-to-r from-blue-500 to-cyan-500 text-white shadow-md'
                    : 'bg-white text-gray-700 hover:bg-gray-50 border border-gray-200'
                }`}
              >
                <Layers className="w-4 h-4" />
                Pagine
              </button>
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {loading ? (
          <div className="text-center py-12">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
          </div>
        ) : (
          <>
            {activeTab === 'dashboard' && (
              <AdminStats
                stats={stats}
                period={statsPeriod}
                onPeriodChange={(days) => setStatsPeriod(days)}
              />
            )}

            {activeTab === 'reviews' && (
              <ReviewsSection reviews={pendingReviews} onReload={async () => { await loadPendingReviews(); await loadPendingCounts(); }} adminId={profile!.id} />
            )}

            {activeTab === 'users' && (
              <UsersManagementSection onReload={loadData} />
            )}

            {activeTab === 'subscriptions' && (
              <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                <div className="px-6 py-5 border-b border-gray-200 bg-gradient-to-r from-teal-50 to-teal-100">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                      <div className="p-2 bg-teal-500 rounded-lg">
                        <Activity className="w-5 h-5 text-white" />
                      </div>
                      <div>
                        <h2 className="text-xl font-bold text-gray-900">Gestione Abbonamenti</h2>
                        <p className="text-sm text-gray-600">
                          {subscriptions.filter(sub => {
                            if (subscriptionFilters.email && !sub.customer.email.toLowerCase().includes(subscriptionFilters.email.toLowerCase())) return false;
                            if (subscriptionFilters.status && sub.status !== subscriptionFilters.status) return false;
                            if (subscriptionFilters.userType) {
                              if (subscriptionFilters.userType === 'trial') {
                                if (sub.customer.subscription_status !== 'trial') return false;
                              } else {
                                if (sub.customer.user_type !== subscriptionFilters.userType) return false;
                              }
                            }
                            if (subscriptionFilters.planId && sub.plan_id !== subscriptionFilters.planId) return false;
                            if (subscriptionFilters.startDate && new Date(sub.start_date).toISOString().split('T')[0] !== subscriptionFilters.startDate) return false;
                            if (subscriptionFilters.endDate && new Date(sub.end_date).toISOString().split('T')[0] !== subscriptionFilters.endDate) return false;
                            return true;
                          }).length} di {subscriptions.length} abbonamenti
                        </p>
                      </div>
                    </div>
                  </div>
                </div>

                {/* Filtri */}
                <div className="px-6 py-4 bg-gray-50 border-b border-gray-200">
                  <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Email</label>
                      <input
                        type="text"
                        placeholder="Cerca per email..."
                        value={subscriptionFilters.email}
                        onChange={(e) => setSubscriptionFilters({ ...subscriptionFilters, email: e.target.value })}
                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-teal-500 focus:border-transparent"
                      />
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Tipo Utente</label>
                      <select
                        value={subscriptionFilters.userType}
                        onChange={(e) => {
                          setSubscriptionFilters({
                            ...subscriptionFilters,
                            userType: e.target.value,
                            planId: ''
                          });
                        }}
                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-teal-500 focus:border-transparent"
                      >
                        <option value="">Tutti</option>
                        <option value="customer">Privato</option>
                        <option value="business">Business</option>
                        <option value="trial">Prova</option>
                      </select>
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Piano Abbonamento</label>
                      <select
                        value={subscriptionFilters.planId}
                        onChange={(e) => setSubscriptionFilters({ ...subscriptionFilters, planId: e.target.value })}
                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-teal-500 focus:border-transparent"
                      >
                        <option value="">Tutti i piani</option>
                        {availablePlans
                          .filter(plan => !subscriptionFilters.userType || plan.target_user_type === subscriptionFilters.userType)
                          .map(plan => (
                            <option key={plan.id} value={plan.id}>
                              {plan.name} - €{plan.price.toFixed(2)} ({plan.target_user_type === 'customer' ? 'Privato' : 'Business'})
                            </option>
                          ))}
                      </select>
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Stato</label>
                      <select
                        value={subscriptionFilters.status}
                        onChange={(e) => setSubscriptionFilters({ ...subscriptionFilters, status: e.target.value })}
                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-teal-500 focus:border-transparent"
                      >
                        <option value="">Tutti</option>
                        <option value="trial">Trial</option>
                        <option value="active">Attivo</option>
                        <option value="expired">Scaduto</option>
                        <option value="cancelled">Cancellato</option>
                      </select>
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Data Inizio</label>
                      <input
                        type="date"
                        value={subscriptionFilters.startDate}
                        onChange={(e) => setSubscriptionFilters({ ...subscriptionFilters, startDate: e.target.value })}
                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-teal-500 focus:border-transparent"
                      />
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Data Scadenza</label>
                      <input
                        type="date"
                        value={subscriptionFilters.endDate}
                        onChange={(e) => setSubscriptionFilters({ ...subscriptionFilters, endDate: e.target.value })}
                        className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-teal-500 focus:border-transparent"
                      />
                    </div>
                  </div>

                  <div className="mt-3 flex gap-2">
                    <button
                      onClick={() => setSubscriptionFilters({
                        email: '',
                        status: '',
                        userType: '',
                        planId: '',
                        startDate: '',
                        endDate: ''
                      })}
                      className="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors text-sm font-medium"
                    >
                      Cancella Filtri
                    </button>
                  </div>
                </div>
                <div className="overflow-x-auto">
                  <table className="min-w-full divide-y divide-gray-200">
                    <thead className="bg-gray-50">
                      <tr>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                          Utente
                        </th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                          Piano
                        </th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                          Prezzo
                        </th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                          Stato
                        </th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                          Inizio
                        </th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                          Scadenza
                        </th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                          Azioni
                        </th>
                      </tr>
                    </thead>
                    <tbody className="bg-white divide-y divide-gray-200">
                      {subscriptions
                        .filter(sub => {
                          if (subscriptionFilters.email && !sub.customer.email.toLowerCase().includes(subscriptionFilters.email.toLowerCase())) return false;
                          if (subscriptionFilters.status && sub.status !== subscriptionFilters.status) return false;
                          if (subscriptionFilters.userType) {
                            if (subscriptionFilters.userType === 'trial') {
                              if (sub.customer.subscription_status !== 'trial') return false;
                            } else {
                              if (sub.customer.user_type !== subscriptionFilters.userType) return false;
                            }
                          }
                          if (subscriptionFilters.planId && sub.plan_id !== subscriptionFilters.planId) return false;
                          if (subscriptionFilters.startDate && new Date(sub.start_date).toISOString().split('T')[0] !== subscriptionFilters.startDate) return false;
                          if (subscriptionFilters.endDate && new Date(sub.end_date).toISOString().split('T')[0] !== subscriptionFilters.endDate) return false;
                          return true;
                        })
                        .map((sub) => (
                        <tr key={sub.id}>
                          <td className="px-6 py-4 whitespace-nowrap">
                            <div className="text-sm font-medium text-gray-900">
                              {sub.customer.full_name}
                            </div>
                            <div className="text-sm text-gray-500">{sub.customer.email}</div>
                          </td>
                          <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                            {sub.plan.name}
                          </td>
                          <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                            €{sub.plan.price}
                          </td>
                          <td className="px-6 py-4 whitespace-nowrap">
                            <span
                              className={`px-2 py-1 text-xs rounded-full ${
                                sub.status === 'active'
                                  ? 'bg-green-100 text-green-800'
                                  : sub.status === 'trial'
                                  ? 'bg-yellow-100 text-yellow-800'
                                  : 'bg-red-100 text-red-800'
                              }`}
                            >
                              {sub.status}
                            </span>
                          </td>
                          <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                            {new Date(sub.start_date).toLocaleDateString('it-IT')}
                          </td>
                          <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                            {new Date(sub.end_date).toLocaleDateString('it-IT')}
                          </td>
                          <td className="px-6 py-4 whitespace-nowrap text-sm flex gap-2">
                            <button
                              onClick={() => viewSubscriptionDetails(sub)}
                              className="bg-blue-600 text-white p-2 rounded-lg hover:bg-blue-700 transition-colors"
                              title="Visualizza dettagli"
                            >
                              <Eye className="w-4 h-4" />
                            </button>
                            <select
                              value={sub.status}
                              onChange={(e) => updateSubscriptionStatus(sub.id, e.target.value)}
                              className="border rounded px-2 py-1 text-sm"
                            >
                              <option value="trial">Trial</option>
                              <option value="active">Attivo</option>
                              <option value="expired">Scaduto</option>
                              <option value="cancelled">Cancellato</option>
                            </select>
                          </td>
                        </tr>
                      ))}
                      {subscriptions.filter(sub => {
                        if (subscriptionFilters.email && !sub.customer.email.toLowerCase().includes(subscriptionFilters.email.toLowerCase())) return false;
                        if (subscriptionFilters.status && sub.status !== subscriptionFilters.status) return false;
                        if (subscriptionFilters.userType && sub.customer.user_type !== subscriptionFilters.userType) return false;
                        if (subscriptionFilters.planId && sub.plan_id !== subscriptionFilters.planId) return false;
                        if (subscriptionFilters.startDate && new Date(sub.start_date).toISOString().split('T')[0] !== subscriptionFilters.startDate) return false;
                        if (subscriptionFilters.endDate && new Date(sub.end_date).toISOString().split('T')[0] !== subscriptionFilters.endDate) return false;
                        return true;
                      }).length === 0 && (
                        <tr>
                          <td colSpan={7} className="px-6 py-12 text-center">
                            <div className="text-gray-500">
                              <Activity className="w-12 h-12 mx-auto mb-3 text-gray-400" />
                              <p className="text-lg font-medium">Nessun abbonamento trovato</p>
                              <p className="text-sm">Prova a modificare i filtri di ricerca</p>
                            </div>
                          </td>
                        </tr>
                      )}
                    </tbody>
                  </table>
                </div>

                {/* Modal Dettagli Abbonamento */}
                {selectedSubscription && (
                  <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
                    <div className="bg-white rounded-xl shadow-2xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
                      <div className="sticky top-0 bg-gradient-to-r from-teal-600 to-teal-700 px-6 py-4 flex items-center justify-between">
                        <h3 className="text-xl font-bold text-white">Dettagli Abbonamento</h3>
                        <button
                          onClick={closeSubscriptionDetails}
                          className="p-2 hover:bg-white/20 rounded-lg transition-colors"
                        >
                          <XCircle className="w-5 h-5 text-white" />
                        </button>
                      </div>

                      <div className="p-6 space-y-6">
                        {/* Informazioni Utente */}
                        <div className="bg-gray-50 rounded-lg p-4">
                          <h4 className="font-semibold text-gray-900 mb-3 flex items-center gap-2">
                            <Users className="w-5 h-5 text-teal-600" />
                            Informazioni Utente
                          </h4>
                          <div className="grid grid-cols-2 gap-4 text-sm">
                            <div>
                              <span className="text-gray-600">Nome:</span>
                              <p className="font-medium">{selectedSubscription.customer.nickname || selectedSubscription.customer.full_name}</p>
                            </div>
                            <div>
                              <span className="text-gray-600">Email:</span>
                              <p className="font-medium">{selectedSubscription.customer.email}</p>
                            </div>
                            <div>
                              <span className="text-gray-600">Tipo:</span>
                              <p className="font-medium">
                                {selectedSubscription.customer.user_type === 'customer' ? 'Privato' : 'Azienda'}
                              </p>
                            </div>
                            <div>
                              <span className="text-gray-600">Piano:</span>
                              <p className="font-medium">{selectedSubscription.plan.name}</p>
                            </div>
                            <div>
                              <span className="text-gray-600">Prezzo:</span>
                              <p className="font-medium text-green-600">€{selectedSubscription.plan.price}</p>
                            </div>
                            <div>
                              <span className="text-gray-600">Stato:</span>
                              <span
                                className={`inline-block px-2 py-1 text-xs rounded-full font-medium ${
                                  selectedSubscription.status === 'active'
                                    ? 'bg-green-100 text-green-800'
                                    : selectedSubscription.status === 'trial'
                                    ? 'bg-yellow-100 text-yellow-800'
                                    : 'bg-red-100 text-red-800'
                                }`}
                              >
                                {selectedSubscription.status}
                              </span>
                            </div>
                          </div>
                        </div>

                        {/* Loading State */}
                        {loadingDetails && (
                          <div className="flex items-center justify-center py-8">
                            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-teal-600"></div>
                          </div>
                        )}

                        {/* Membri Famiglia (per utenti privati) */}
                        {!loadingDetails && selectedSubscription.customer.user_type === 'customer' && (
                          <div>
                            <h4 className="font-semibold text-gray-900 mb-3 flex items-center gap-2">
                              <Users className="w-5 h-5 text-teal-600" />
                              Membri Famiglia ({familyMembers.length})
                            </h4>
                            {familyMembers.length === 0 ? (
                              <div className="bg-gray-50 rounded-lg p-6 text-center">
                                <Users className="w-12 h-12 text-gray-400 mx-auto mb-2" />
                                <p className="text-gray-600">Nessun membro famiglia registrato</p>
                              </div>
                            ) : (
                              <div className="grid md:grid-cols-2 gap-4">
                                {familyMembers.map((member) => (
                                  <div key={member.id} className="bg-white border border-gray-200 rounded-lg p-4">
                                    <div className="flex items-start gap-3">
                                      <div className="w-10 h-10 bg-teal-100 rounded-full flex items-center justify-center flex-shrink-0">
                                        <Users className="w-5 h-5 text-teal-600" />
                                      </div>
                                      <div className="flex-1">
                                        <p className="font-semibold text-gray-900">
                                          {member.nickname || member.full_name}
                                        </p>
                                        {member.nickname && (
                                          <p className="text-sm text-gray-600">{member.full_name}</p>
                                        )}
                                        <p className="text-sm text-gray-500 mt-1">
                                          <span className="inline-block px-2 py-1 bg-gray-100 rounded text-xs">
                                            {member.relationship}
                                          </span>
                                        </p>
                                      </div>
                                    </div>
                                  </div>
                                ))}
                              </div>
                            )}
                          </div>
                        )}

                        {/* Sedi Business (per aziende) */}
                        {!loadingDetails && selectedSubscription.customer.user_type === 'business' && (
                          <div>
                            <h4 className="font-semibold text-gray-900 mb-3 flex items-center gap-2">
                              <Building2 className="w-5 h-5 text-teal-600" />
                              Sedi Aziendali ({businessLocations.length})
                            </h4>
                            {businessLocations.length === 0 ? (
                              <div className="bg-gray-50 rounded-lg p-6 text-center">
                                <Building2 className="w-12 h-12 text-gray-400 mx-auto mb-2" />
                                <p className="text-gray-600">Nessuna sede registrata</p>
                              </div>
                            ) : (
                              <div className="space-y-4">
                                {businessLocations.map((location) => (
                                  <div key={location.id} className="bg-white border border-gray-200 rounded-lg p-4">
                                    <div className="flex items-start gap-3">
                                      <div className="w-10 h-10 bg-teal-100 rounded-full flex items-center justify-center flex-shrink-0">
                                        <MapPin className="w-5 h-5 text-teal-600" />
                                      </div>
                                      <div className="flex-1">
                                        <h5 className="font-semibold text-gray-900">
                                          {location.internal_name || location.name}
                                        </h5>
                                        {location.internal_name && (
                                          <p className="text-sm text-gray-600">{location.name}</p>
                                        )}
                                        <div className="mt-2 space-y-1 text-sm">
                                          <p className="text-gray-700">
                                            <span className="font-medium">Indirizzo:</span> {location.address}
                                          </p>
                                          <p className="text-gray-700">
                                            <span className="font-medium">Città:</span> {location.city}, {location.province}
                                          </p>
                                          {location.phone && (
                                            <p className="text-gray-700">
                                              <span className="font-medium">Telefono:</span> {location.phone}
                                            </p>
                                          )}
                                          {location.email && (
                                            <p className="text-gray-700">
                                              <span className="font-medium">Email:</span> {location.email}
                                            </p>
                                          )}
                                        </div>
                                      </div>
                                    </div>
                                  </div>
                                ))}
                              </div>
                            )}
                          </div>
                        )}
                      </div>

                      <div className="sticky bottom-0 bg-gray-50 px-6 py-4 flex justify-end border-t border-gray-200">
                        <button
                          onClick={closeSubscriptionDetails}
                          className="px-6 py-2 bg-teal-600 text-white rounded-lg hover:bg-teal-700 transition-colors font-medium"
                        >
                          Chiudi
                        </button>
                      </div>
                    </div>
                  </div>
                )}
              </div>
            )}

            {activeTab === 'ads' && (
              <ClassifiedAdsSection ads={classifiedAds} onReload={async () => { await loadClassifiedAds(); await loadPendingCounts(); }} />
            )}

            {activeTab === 'auctions' && <AuctionsSection />}

            {activeTab === 'reports' && <ReportsSection reports={reports} onReload={async () => { await loadReports(); await loadPendingCounts(); }} />}

            {activeTab === 'businesses' && <BusinessesSection onReload={async () => { await loadBusinesses(); await loadPendingCounts(); }} />}

            {activeTab === 'jobs' && <JobPostingsSection jobPostings={jobPostings} onReload={loadJobPostings} pendingJobSeekers={pendingCounts.jobSeekers} />}

            {activeTab === 'professional_profiles' && <ProfessionalProfilesSection />}

            {activeTab === 'solidarity' && <SolidaritySection onReload={loadData} />}

            {activeTab === 'leaderboard' && <LeaderboardSection />}

            {activeTab === 'tracking' && <BusinessTrackingSection onReload={loadData} />}

            {activeTab === 'osm_import' && <OsmImportSection />}

            {activeTab === 'messaging' && <MessagingSection adminId={profile!.id} />}

            {activeTab === 'contact' && <ContactSection adminId={profile!.id} />}

            {activeTab === 'platform_messages' && <PlatformMessagesSection adminId={profile!.id} />}

            {activeTab === 'plans' && <PlansSection adminId={profile!.id} />}

            {activeTab === 'rules' && <RulesSection adminId={profile!.id} />}

            {activeTab === 'page_customization' && <PageCustomizationSection adminId={profile!.id} />}
          </>
        )}
      </div>

    </div>
  );
}
