import { useEffect, useState, createContext, useContext, lazy, Suspense } from 'react';
import { useAuth } from '../contexts/AuthContext';
import { supabase } from '../lib/supabase';

const HomePage = lazy(() => import('../pages/HomePage').then(m => ({ default: m.HomePage })));
const DashboardPage = lazy(() => import('../pages/DashboardPage').then(m => ({ default: m.DashboardPage })));
const SubscriptionPage = lazy(() => import('../pages/SubscriptionPage').then(m => ({ default: m.SubscriptionPage })));
const JobsPage = lazy(() => import('../pages/JobsPage').then(m => ({ default: m.JobsPage })));
const ProfilePage = lazy(() => import('../pages/ProfilePage').then(m => ({ default: m.ProfilePage })));
const LeaderboardPage = lazy(() => import('../pages/LeaderboardPage').then(m => ({ default: m.LeaderboardPage })));
const BusinessDetailPage = lazy(() => import('../pages/BusinessDetailPage').then(m => ({ default: m.BusinessDetailPage })));
const SearchResultsPage = lazy(() => import('../pages/SearchResultsPage').then(m => ({ default: m.SearchResultsPage })));
const ClassifiedAdsPage = lazy(() => import('../pages/ClassifiedAdsPage').then(m => ({ default: m.ClassifiedAdsPage })));
const ClassifiedAdDetailPage = lazy(() => import('../pages/ClassifiedAdDetailPage').then(m => ({ default: m.ClassifiedAdDetailPage })));
const MessagesPage = lazy(() => import('../pages/MessagesPage').then(m => ({ default: m.MessagesPage })));
const NotificationsPage = lazy(() => import('../pages/NotificationsPage').then(m => ({ default: m.NotificationsPage })));
const SolidarityPage = lazy(() => import('../pages/SolidarityPage').then(m => ({ default: m.SolidarityPage })));
const ContactPage = lazy(() => import('../pages/ContactPage').then(m => ({ default: m.ContactPage })));
const RulesPage = lazy(() => import('../pages/RulesPage').then(m => ({ default: m.RulesPage })));
const ProfileSelectionPage = lazy(() => import('../pages/ProfileSelectionPage').then(m => ({ default: m.ProfileSelectionPage })));
const ClaimBusinessPage = lazy(() => import('../pages/ClaimBusinessPage').then(m => ({ default: m.ClaimBusinessPage })));
const AdminDashboardPage = lazy(() => import('../pages/AdminDashboardPage').then(m => ({ default: m.AdminDashboardPage })));
const AdminProfilePage = lazy(() => import('../pages/AdminProfilePage').then(m => ({ default: m.AdminProfilePage })));
const AdminRegisterPage = lazy(() => import('../pages/AdminRegisterPage').then(m => ({ default: m.AdminRegisterPage })));
const AdminLoginPage = lazy(() => import('../pages/AdminLoginPage').then(m => ({ default: m.AdminLoginPage })));
const AuctionsPage = lazy(() => import('../pages/AuctionsPage'));
const AuctionDetailPage = lazy(() => import('../pages/AuctionDetailPage'));
const JobSeekerDetailPage = lazy(() => import('../pages/JobSeekerDetailPage').then(m => ({ default: m.JobSeekerDetailPage })));
const ProfessionalProfilePage = lazy(() => import('../pages/ProfessionalProfilePage').then(m => ({ default: m.ProfessionalProfilePage })));
const ReviewsPage = lazy(() => import('../pages/ReviewsPage').then(m => ({ default: m.ReviewsPage })));

const RouterContext = createContext<{ params: Record<string, string> }>({ params: {} });

export function useParams() {
  return useContext(RouterContext).params;
}

export function useNavigate() {
  return (path: string) => {
    const [pathname, hash] = path.split('#');
    window.history.pushState({}, '', hash ? `${pathname}#${hash}` : pathname);
    window.dispatchEvent(new PopStateEvent('popstate'));
    if (hash) {
      setTimeout(() => {
        const el = document.getElementById(hash);
        if (el) el.scrollIntoView({ behavior: 'smooth' });
      }, 300);
    }
  };
}

function PageLoader() {
  return (
    <div className="min-h-screen bg-gray-50 flex items-center justify-center">
      <div className="text-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto mb-4"></div>
        <p className="text-gray-600">Caricamento...</p>
      </div>
    </div>
  );
}

export function Router() {
  const [currentPath, setCurrentPath] = useState(window.location.pathname);
  const [params, setParams] = useState<Record<string, string>>({});
  const [isFreePlan, setIsFreePlan] = useState(false);
  const [subChecked, setSubChecked] = useState(false);
  const { needsProfileSelection, loading, user, profile } = useAuth();

  useEffect(() => {
    if (!user?.id || !profile || profile.user_type === 'admin') {
      setIsFreePlan(false);
      setSubChecked(true);
      return;
    }
    let cancelled = false;
    (async () => {
      try {
        const { data } = await supabase
          .from('subscriptions')
          .select('plan:subscription_plans(price)')
          .eq('customer_id', user.id)
          .in('status', ['active', 'trial'])
          .order('created_at', { ascending: false })
          .limit(1)
          .maybeSingle();
        const price = (data?.plan as any)?.price;
        if (!cancelled) setIsFreePlan(Number(price) === 0);
      } catch { /* silent */ }
      if (!cancelled) setSubChecked(true);
    })();
    return () => { cancelled = true; };
  }, [user, profile]);

  // Redirect free-plan users away from premium pages
  useEffect(() => {
    if (loading || !subChecked || !user || !profile || profile.user_type === 'admin' || !isFreePlan) return;
    const premiumPaths = ['/jobs', '/classified', '/classified-ads', '/auctions', '/solidarity', '/leaderboard', '/messages', '/notifications'];
    const isPremium = premiumPaths.some(p => currentPath === p || currentPath.startsWith(p + '/'));
    if (isPremium && currentPath !== '/dashboard' && currentPath !== '/subscription') {
      window.history.pushState({}, '', '/dashboard');
      setCurrentPath('/dashboard');
    }
  }, [loading, subChecked, user, profile, isFreePlan, currentPath]);

  useEffect(() => {
    if (!window.location.hash) {
      window.scrollTo({ top: 0, behavior: 'instant' });
    }
  }, [currentPath]);

  useEffect(() => {
    const handlePopState = () => {
      setCurrentPath(window.location.pathname);
    };

    window.addEventListener('popstate', handlePopState);

    const originalPushState = window.history.pushState;
    window.history.pushState = function(...args) {
      originalPushState.apply(window.history, args);
      setCurrentPath(window.location.pathname);
    };

    return () => {
      window.removeEventListener('popstate', handlePopState);
      window.history.pushState = originalPushState;
    };
  }, []);

  useEffect(() => {
    if (loading) return;

    if (profile?.user_type === 'admin') return;

    if (!needsProfileSelection) return;
    if (currentPath === '/select-profile') return;

    window.history.pushState({}, '', '/select-profile');
    setCurrentPath('/select-profile');
  }, [needsProfileSelection, loading, currentPath, profile]);

  // Redirect alla home quando l'utente fa logout
  useEffect(() => {
    if (loading) return;
    const publicPaths = ['/', '/claim-business', '/rivendica-attivita', '/contact', '/contatti', '/rules', '/regolamento', '/solidarity', '/leaderboard', '/subscription'];
    const isPublic = publicPaths.includes(currentPath)
      || currentPath.startsWith('/business/')
      || currentPath.startsWith('/admin');
    if (!user && !isPublic) {
      window.history.pushState({}, '', '/');
      setCurrentPath('/');
    }
  }, [user, loading]);

  let page: React.ReactNode = null;

  if (currentPath === '/reviews') {
    page = <ReviewsPage />;
  } else if (currentPath === '/select-profile') {
    page = <ProfileSelectionPage />;
  } else if (currentPath === '/search') {
    page = <SearchResultsPage />;
  } else if (currentPath === '/dashboard') {
    page = <DashboardPage />;
  } else if (currentPath === '/subscription') {
    page = <SubscriptionPage />;
  } else if (currentPath === '/jobs') {
    page = <JobsPage />;
  } else if (currentPath.startsWith('/jobs/seekers/')) {
    page = <JobSeekerDetailPage />;
  } else if (currentPath.startsWith('/professional-profile/')) {
    const userId = currentPath.split('/')[2];
    if (userId) {
      page = <ProfessionalProfilePage />;
    }
  } else if (currentPath === '/profile') {
    page = <ProfilePage />;
  } else if (currentPath === '/leaderboard') {
    page = <LeaderboardPage />;
  } else if (currentPath === '/classified' || currentPath === '/classified-ads') {
    page = <ClassifiedAdsPage />;
  } else if (currentPath === '/auctions') {
    page = <AuctionsPage />;
  } else if (currentPath.startsWith('/auctions/')) {
    page = <AuctionDetailPage />;
  } else if (currentPath.startsWith('/classified/') || currentPath.startsWith('/classified-ads/')) {
    const adId = currentPath.replace('/classified/', '').replace('/classified-ads/', '');
    if (adId) {
      page = <ClassifiedAdDetailPage />;
    }
  } else if (currentPath === '/messages') {
    page = <MessagesPage />;
  } else if (currentPath === '/notifications') {
    page = <NotificationsPage />;
  } else if (currentPath === '/solidarity') {
    page = <SolidarityPage />;
  } else if (currentPath === '/contact' || currentPath === '/contatti') {
    page = <ContactPage />;
  } else if (currentPath === '/rules' || currentPath === '/regolamento') {
    page = <RulesPage />;
  } else if (currentPath === '/claim-business' || currentPath === '/rivendica-attivita') {
    page = <ClaimBusinessPage />;
  } else if (currentPath === '/admin' || currentPath === '/admin-dashboard') {
    if (loading) {
      page = <PageLoader />;
    } else if (!user || !profile || profile.user_type !== 'admin') {
      console.log('=== ROUTER /admin guard: user=', !!user, '| profile=', !!profile, '| user_type=', profile?.user_type, '| redirecting to /admin-login ===');
      window.location.href = '/admin-login';
      page = null;
    } else {
      page = <AdminDashboardPage />;
    }
  } else if (currentPath === '/admin-profile') {
    if (loading) {
      page = <PageLoader />;
    } else if (!user || !profile || profile.user_type !== 'admin') {
      console.log('=== ROUTER /admin-profile guard: user=', !!user, '| profile=', !!profile, '| user_type=', profile?.user_type, '| redirecting to /admin-login ===');
      window.location.href = '/admin-login';
      page = null;
    } else {
      page = <AdminProfilePage />;
    }
  } else if (currentPath === '/admin-secure-register-2024') {
    page = <AdminRegisterPage />;
  } else if (currentPath === '/admin-login') {
    page = <AdminLoginPage />;
  } else if (currentPath.startsWith('/business/unclaimed/')) {
    const unclaimedBusinessId = currentPath.split('/')[3];
    if (unclaimedBusinessId) {
      page = <BusinessDetailPage businessId={unclaimedBusinessId} />;
    }
  } else if (currentPath.startsWith('/business/')) {
    const businessId = currentPath.split('/')[2];
    if (businessId && businessId !== 'unclaimed') {
      page = <BusinessDetailPage businessId={businessId} />;
    }
  } else if (currentPath === '/' && !loading && profile?.user_type === 'admin') {
    window.history.pushState({}, '', '/admin');
    setCurrentPath('/admin');
    page = <AdminDashboardPage />;
  } else {
    page = <HomePage />;
  }

  return (
    <RouterContext.Provider value={{ params }}>
      <Suspense fallback={<PageLoader />}>
        {page}
      </Suspense>
    </RouterContext.Provider>
  );
}
