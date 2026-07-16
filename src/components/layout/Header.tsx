import { useState, useEffect, useCallback } from 'react';
import { User, Menu, X, Home, Phone, FileText, CreditCard, MessageCircle, Heart, Building2, Shield, Tag, Briefcase, UserCog, Gavel, Trophy, Star } from 'lucide-react';
import { useAuth } from '../../contexts/AuthContext';
import { useLanguage } from '../../contexts/LanguageContext';
import { supabase } from '../../lib/supabase';
import { LoginForm } from '../auth/LoginForm';
import { RegisterForm } from '../auth/RegisterForm';
import NotificationBell from '../notifications/NotificationBell';
import { ActiveProfileIndicator } from '../profile/ActiveProfileIndicator';
import { useNavigate } from '../Router';

export function Header() {
  const { user, profile, activeProfile, selectedBusinessLocationId, businessLocations } = useAuth();
  const { t } = useLanguage();
  const navigate = useNavigate();
  const [showAuthModal, setShowAuthModal] = useState(false);
  const [authMode, setAuthMode] = useState<'login' | 'register'>('login');
  const [showMobileMenu, setShowMobileMenu] = useState(false);
  const [adminData, setAdminData] = useState<{ avatar_url: string | null; nickname: string | null } | null>(null);
  const [unreadMessages, setUnreadMessages] = useState(0);
  const [pendingReviews, setPendingReviews] = useState(0);
  const [isFreePlan, setIsFreePlan] = useState(false);

  const selectedLocation = selectedBusinessLocationId
    ? businessLocations.find(loc => loc.id === selectedBusinessLocationId)
    : null;

  const userType = profile?.user_type || 'customer';
  const isAdmin = profile?.user_type === 'admin';

  useEffect(() => {
    const selectedPlanId = localStorage.getItem('selectedPlanId');
    const urlParams = new URLSearchParams(window.location.search);
    const registerType = urlParams.get('register');
    const loginParam = urlParams.get('login');

    if (selectedPlanId && !user) {
      setAuthMode('register');
      setShowAuthModal(true);
    } else if (registerType && !user) {
      setAuthMode('register');
      setShowAuthModal(true);
    } else if (loginParam && !user) {
      setAuthMode('login');
      setShowAuthModal(true);
    }
  }, [user]);

  useEffect(() => {
    if (user && profile?.user_type === 'admin') {
      loadAdminData();
    }
  }, [user, profile]);

  const activeFamilyMemberId = activeProfile && !activeProfile.isOwner && profile?.user_type === 'customer'
    ? activeProfile.id
    : null;

  useEffect(() => {
    if (!user || !profile || profile.user_type === 'admin') return;
    loadPendingReviews();
    loadSubscriptionStatus();
  }, [user, profile]);

  const loadSubscriptionStatus = async () => {
    if (!user?.id || !profile || profile.user_type === 'admin') return;
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
      setIsFreePlan(Number(price) === 0);
    } catch { /* silent */ }
  };

  const closeMenu = useCallback(() => setShowMobileMenu(false), []);

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') closeMenu();
    };
    document.addEventListener('keydown', handleKeyDown);
    return () => document.removeEventListener('keydown', handleKeyDown);
  }, [closeMenu]);

  const loadPendingReviews = async () => {
    if (!user?.id || !profile) return;
    try {
      if (profile.user_type === 'business') {
        const { count } = await supabase
          .from('reviews')
          .select('id', { count: 'exact', head: true })
          .eq('review_status', 'pending');
        setPendingReviews(count || 0);
      } else {
        const fmId = profile.user_type === 'customer'
          ? (activeFamilyMemberId ?? null)
          : null;
        const q = supabase
          .from('reviews')
          .select('id', { count: 'exact', head: true })
          .eq('customer_id', user.id)
          .eq('review_status', 'approved');
        const { count } = await (fmId ? q.eq('family_member_id', fmId) : q.is('family_member_id', null));
        setPendingReviews(count || 0);
      }
    } catch { /* silent */ }
  };

  useEffect(() => {
    if (!user || !profile || profile.user_type === 'admin') return;

    loadUnreadMessages();

    const channel = supabase
      .channel('header_messages_changes')
      .on(
        'postgres_changes',
        { event: '*', schema: 'public', table: 'messages' },
        () => { loadUnreadMessages(); }
      )
      .subscribe();

    return () => { supabase.removeChannel(channel); };
  }, [user, profile, activeFamilyMemberId, selectedBusinessLocationId]);

  const loadAdminData = async () => {
    if (!user?.id) return;

    const { data } = await supabase
      .from('admins')
      .select('avatar_url, nickname')
      .eq('user_id', user.id)
      .maybeSingle();

    if (data) {
      setAdminData(data);
    }
  };

  const loadUnreadMessages = async () => {
    if (!user?.id) return;
    try {
      let convQuery = supabase.from('conversations').select('id');

      if (profile?.user_type === 'customer') {
        if (activeFamilyMemberId) {
          convQuery = convQuery.or(
            `and(participant1_id.eq.${user.id},participant1_family_member_id.eq.${activeFamilyMemberId}),` +
            `and(participant2_id.eq.${user.id},participant2_family_member_id.eq.${activeFamilyMemberId})`
          );
        } else {
          convQuery = convQuery.or(
            `and(participant1_id.eq.${user.id},participant1_family_member_id.is.null),` +
            `and(participant2_id.eq.${user.id},participant2_family_member_id.is.null)`
          );
        }
      } else if (profile?.user_type === 'business' && selectedBusinessLocationId) {
        convQuery = convQuery.or(
          `and(participant1_id.eq.${user.id},participant1_location_id.eq.${selectedBusinessLocationId}),` +
          `and(participant2_id.eq.${user.id},participant2_location_id.eq.${selectedBusinessLocationId})`
        );
      } else {
        convQuery = convQuery.or(`participant1_id.eq.${user.id},participant2_id.eq.${user.id}`);
      }

      const { data: convIds } = await convQuery;

      if (!convIds || convIds.length === 0) {
        setUnreadMessages(0);
        return;
      }

      const ids = convIds.map(c => c.id);
      const { count } = await supabase
        .from('messages')
        .select('id', { count: 'exact', head: true })
        .in('conversation_id', ids)
        .neq('sender_id', user.id)
        .eq('is_read', false);

      setUnreadMessages(count || 0);
    } catch (error) {
      console.error('Error loading unread messages:', error);
    }
  };

  return (
    <>
      <header className="bg-white shadow-sm sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center h-16">
            <a href="/" className="flex items-center flex-shrink-0" aria-label="Lhimo - Torna alla home">
              <img
                src="/chatgpt_image_4_dic_2025,_22_51_45.png"
                alt="Lhimo"
                className="h-12"
              />
            </a>

            {user && profile && profile.user_type !== 'admin' ? (
              <>
                <nav className="hidden lg:flex items-center gap-3 ml-6">
                  <a
                    href="/"
                    className="flex items-center gap-1 text-gray-700 hover:text-blue-600 transition-colors font-medium px-2"
                    title={t('header.home')}
                  >
                    <Home className="w-4 h-4" />
                    <span className="text-sm">{t('header.home')}</span>
                  </a>
                  <a
                    href="/messages"
                    className="relative flex items-center gap-1 text-gray-700 hover:text-blue-600 transition-colors font-medium px-2"
                    title={t('header.messages')}
                    aria-label={unreadMessages > 0 ? `Messaggi (${unreadMessages} non letti)` : t('header.messages')}
                  >
                    <MessageCircle className="w-4 h-4" />
                    <span className="text-sm">{t('header.messages')}</span>
                    {unreadMessages > 0 && (
                      <span
                        className="absolute -top-2 -right-2 min-w-[18px] h-[18px] flex items-center justify-center px-1 bg-red-600 text-white text-[10px] font-bold rounded-full shadow-lg ring-2 ring-white"
                        aria-hidden="true"
                      >
                        {unreadMessages > 99 ? '99+' : unreadMessages}
                      </span>
                    )}
                  </a>
                  <NotificationBell />
                  <a
                    href="/contact"
                    className="flex items-center gap-1 text-gray-700 hover:text-blue-600 transition-colors font-medium px-2"
                    title={t('header.contacts')}
                  >
                    <Phone className="w-4 h-4" />
                    <span className="text-sm">{t('header.contacts')}</span>
                  </a>
                  <a
                    href="/subscription"
                    className="flex items-center gap-1 text-gray-700 hover:text-blue-600 transition-colors font-medium px-2"
                    title={t('header.subscription')}
                  >
                    <CreditCard className="w-4 h-4" />
                    <span className="text-sm">{t('header.plans')}</span>
                  </a>
                  <a
                    href="/rules"
                    className="flex items-center gap-1 text-gray-700 hover:text-blue-600 transition-colors font-medium px-2"
                    title={t('header.rules')}
                  >
                    <FileText className="w-4 h-4" />
                    <span className="text-sm">{t('header.rules')}</span>
                  </a>
                </nav>

                <div className="flex-1"></div>

                <nav className="hidden lg:flex items-center gap-2">
                  <ActiveProfileIndicator />
                  <a
                    href="/dashboard"
                    className="flex items-center gap-2 bg-blue-600 text-white hover:bg-blue-700 transition-colors font-medium px-4 py-2 rounded-lg"
                    title={t('header.myProfile')}
                  >
                    {profile.avatar_url ? (
                      <img
                        src={profile.avatar_url}
                        alt="Avatar"
                        className="w-6 h-6 rounded-full object-cover border-2 border-white"
                      />
                    ) : (
                      <User className="w-4 h-4" />
                    )}
                    <span className="text-sm">{t('header.profile')}</span>
                  </a>
                </nav>
              </>
            ) : user && profile && profile.user_type === 'admin' ? (
              <>
                <div className="flex-1"></div>
                <nav className="hidden lg:flex items-center gap-3">
                  <a
                    href="/admin-profile"
                    className="flex items-center gap-3 bg-gradient-to-r from-blue-600 to-blue-700 text-white hover:from-blue-700 hover:to-blue-800 transition-colors font-medium px-4 py-2 rounded-lg shadow-md"
                    title="Dashboard Profilo Admin"
                  >
                    <div className="flex items-center gap-2">
                      {adminData?.avatar_url ? (
                        <img
                          src={adminData.avatar_url}
                          alt="Avatar Admin"
                          className="w-8 h-8 rounded-full object-cover border-2 border-white"
                        />
                      ) : (
                        <div className="w-8 h-8 rounded-full bg-white/20 flex items-center justify-center">
                          <User className="w-5 h-5 text-white" />
                        </div>
                      )}
                      <div className="flex flex-col items-start">
                        {adminData?.nickname ? (
                          <>
                            <span className="text-xs font-medium">@{adminData.nickname}</span>
                            <span className="text-xs opacity-80">Dashboard</span>
                          </>
                        ) : (
                          <span className="text-sm">Dashboard Profilo</span>
                        )}
                      </div>
                    </div>
                    <UserCog className="w-5 h-5" />
                  </a>
                </nav>
              </>
            ) : (
              <>
                <div className="flex-1"></div>
                <nav className="hidden lg:flex items-center gap-4">
                  <a
                    href="/claim-business"
                    className="flex items-center gap-1 bg-green-600 text-white hover:bg-green-700 transition-colors font-bold px-3 py-2 rounded-lg"
                  >
                    <Building2 className="w-4 h-4" />
                    <span className="text-sm">Verifica Attività</span>
                  </a>
                  <a
                    href="/solidarity"
                    className="flex items-center gap-1 text-gray-700 hover:text-blue-600 transition-colors font-medium px-2"
                  >
                    <Heart className="w-4 h-4" />
                    <span className="text-sm">{t('header.solidarity')}</span>
                  </a>
                  <a
                    href="/contact"
                    className="flex items-center gap-1 text-gray-700 hover:text-blue-600 transition-colors font-medium px-2"
                  >
                    <Phone className="w-4 h-4" />
                    <span className="text-sm">{t('header.contacts')}</span>
                  </a>
                  <a
                    href="/subscription"
                    className="flex items-center gap-1 text-gray-700 hover:text-blue-600 transition-colors font-medium px-2"
                  >
                    <CreditCard className="w-4 h-4" />
                    <span className="text-sm">{t('header.plans')}</span>
                  </a>
                  <a
                    href="/rules"
                    className="flex items-center gap-1 text-gray-700 hover:text-blue-600 transition-colors font-medium px-2"
                  >
                    <FileText className="w-4 h-4" />
                    <span className="text-sm">{t('header.rules')}</span>
                  </a>
                  <button
                    onClick={() => navigate('/admin-login')}
                    className="flex items-center gap-1 text-gray-500 hover:text-gray-700 transition-colors font-medium px-2"
                    title="Area Admin"
                  >
                    <Shield className="w-4 h-4" />
                    <span className="text-sm">Admin</span>
                  </button>
                  <button
                    onClick={() => {
                      setAuthMode('login');
                      setShowAuthModal(true);
                    }}
                    className="bg-blue-600 text-white px-5 py-2 rounded-lg hover:bg-blue-700 transition-colors text-sm font-medium ml-2"
                  >
                    {t('header.login')}
                  </button>
                </nav>
              </>
            )}

            <button
              onClick={() => setShowMobileMenu(!showMobileMenu)}
              className="lg:hidden text-gray-700 hover:text-blue-600 ml-auto"
              aria-label={showMobileMenu ? 'Chiudi menu' : 'Apri menu di navigazione'}
              aria-expanded={showMobileMenu}
              aria-controls="mobile-menu-nav"
            >
              {showMobileMenu ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
            </button>
          </div>

          {showMobileMenu && (
            <div id="mobile-menu-nav" className="lg:hidden border-t border-gray-200 py-4 max-h-[80vh] overflow-y-auto">
              <nav className="flex flex-col gap-4" role="navigation" aria-label="Menu principale mobile">
                {user && profile && profile.user_type === 'admin' ? (
                  <>
                    <a
                      href="/admin-profile"
                      className="flex items-center gap-3 bg-gradient-to-r from-blue-600 to-blue-700 text-white hover:from-blue-700 hover:to-blue-800 transition-colors font-medium px-4 py-3 rounded-lg shadow-md"
                      onClick={() => setShowMobileMenu(false)}
                    >
                      <div className="flex items-center gap-2">
                        {adminData?.avatar_url ? (
                          <img
                            src={adminData.avatar_url}
                            alt="Avatar Admin"
                            className="w-10 h-10 rounded-full object-cover border-2 border-white"
                          />
                        ) : (
                          <div className="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center">
                            <User className="w-6 h-6 text-white" />
                          </div>
                        )}
                        <div className="flex flex-col items-start">
                          {adminData?.nickname ? (
                            <>
                              <span className="text-sm font-medium">@{adminData.nickname}</span>
                              <span className="text-xs opacity-80">Dashboard Profilo</span>
                            </>
                          ) : (
                            <span className="text-sm">Dashboard Profilo</span>
                          )}
                        </div>
                      </div>
                      <UserCog className="w-5 h-5 ml-auto" />
                    </a>
                  </>
                ) : user && profile && profile.user_type !== 'admin' ? (
                  <>
                    {selectedLocation && (
                      <div className="flex items-center gap-2 px-3 py-2 bg-blue-100 text-blue-800 rounded-lg text-sm font-medium border border-blue-300 overflow-hidden">
                        <span className="font-semibold shrink-0">{t('header.selectedLocation')}:</span>
                        <span className="truncate">{selectedLocation.internal_name || selectedLocation.city}</span>
                      </div>
                    )}
                    <a
                      href="/"
                      className="flex items-center gap-2 text-gray-700 hover:text-blue-600 transition-colors font-medium"
                      onClick={() => setShowMobileMenu(false)}
                    >
                      <Home className="w-5 h-5" />
                      <span>{t('header.home')}</span>
                    </a>
                    <a
                      href="/messages"
                      className="relative flex items-center gap-2 text-gray-700 hover:text-blue-600 transition-colors font-medium"
                      onClick={() => setShowMobileMenu(false)}
                    >
                      <MessageCircle className="w-5 h-5" />
                      <span>{t('header.messages')}</span>
                      {unreadMessages > 0 && (
                        <span className="min-w-[20px] h-[20px] flex items-center justify-center px-1.5 bg-red-600 text-white text-xs font-bold rounded-full">
                          {unreadMessages > 99 ? '99+' : unreadMessages}
                        </span>
                      )}
                    </a>
                    <a
                      href="/contact"
                      className="flex items-center gap-2 text-gray-700 hover:text-blue-600 transition-colors font-medium"
                      onClick={() => setShowMobileMenu(false)}
                    >
                      <Phone className="w-5 h-5" />
                      <span>{t('header.contacts')}</span>
                    </a>
                    <a
                      href="/subscription"
                      className="flex items-center gap-2 text-gray-700 hover:text-blue-600 transition-colors font-medium"
                      onClick={() => setShowMobileMenu(false)}
                    >
                      <CreditCard className="w-5 h-5" />
                      <span>{t('header.subscription')}</span>
                    </a>
                    <a
                      href="/rules"
                      className="flex items-center gap-2 text-gray-700 hover:text-blue-600 transition-colors font-medium"
                      onClick={() => setShowMobileMenu(false)}
                    >
                      <FileText className="w-5 h-5" />
                      <span>{t('header.rules')}</span>
                    </a>
                    <a
                      href="/dashboard"
                      className="flex items-center gap-3 bg-blue-600 text-white hover:bg-blue-700 transition-colors font-medium px-4 py-3 rounded-lg"
                      onClick={() => setShowMobileMenu(false)}
                    >
                      {profile.avatar_url ? (
                        <img
                          src={profile.avatar_url}
                          alt="Avatar"
                          className="w-8 h-8 rounded-full object-cover border-2 border-white"
                        />
                      ) : (
                        <User className="w-5 h-5" />
                      )}
                      <div className="flex flex-col items-start">
                        <span className="text-sm">{t('header.profile')}</span>
                        {profile.nickname && (
                          <span className="text-xs opacity-80">@{profile.nickname}</span>
                        )}
                      </div>
                    </a>
                  </>
                ) : (
                  <>
                    <a
                      href="/claim-business"
                      className="flex items-center gap-2 bg-green-600 text-white hover:bg-green-700 transition-colors font-bold px-4 py-3 rounded-lg"
                      onClick={() => setShowMobileMenu(false)}
                    >
                      <Building2 className="w-5 h-5" />
                      <span>Verifica Attività</span>
                    </a>
                    <a
                      href="/solidarity"
                      className="flex items-center gap-2 text-gray-700 hover:text-blue-600 transition-colors font-medium"
                      onClick={() => setShowMobileMenu(false)}
                    >
                      <Heart className="w-5 h-5" />
                      <span>{t('header.solidarity')}</span>
                    </a>
                    <a
                      href="/contact"
                      className="flex items-center gap-2 text-gray-700 hover:text-blue-600 transition-colors font-medium"
                      onClick={() => setShowMobileMenu(false)}
                    >
                      <Phone className="w-5 h-5" />
                      <span>{t('header.contacts')}</span>
                    </a>
                    <a
                      href="/subscription"
                      className="flex items-center gap-2 text-gray-700 hover:text-blue-600 transition-colors font-medium"
                      onClick={() => setShowMobileMenu(false)}
                    >
                      <CreditCard className="w-5 h-5" />
                      <span>{t('header.subscription')}</span>
                    </a>
                    <a
                      href="/rules"
                      className="flex items-center gap-2 text-gray-700 hover:text-blue-600 transition-colors font-medium"
                      onClick={() => setShowMobileMenu(false)}
                    >
                      <FileText className="w-5 h-5" />
                      <span>{t('header.rules')}</span>
                    </a>
                    <button
                      onClick={() => {
                        navigate('/admin-login');
                        setShowMobileMenu(false);
                      }}
                      className="flex items-center gap-2 text-gray-500 hover:text-gray-700 transition-colors font-medium w-full"
                    >
                      <Shield className="w-5 h-5" />
                      <span>Area Admin</span>
                    </button>
                    <button
                      onClick={() => {
                        setAuthMode('login');
                        setShowAuthModal(true);
                        setShowMobileMenu(false);
                      }}
                      className="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition-colors text-left font-medium"
                    >
                      {t('header.login')}
                    </button>
                  </>
                )}
              </nav>
            </div>
          )}
        </div>
      </header>

      {user && profile && profile.user_type !== 'admin' && !isFreePlan && (
        <div className="bg-gradient-to-r from-gray-50 via-white to-gray-50 border-b border-gray-200 shadow-sm sticky top-16 z-40">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <nav className="flex items-center justify-center gap-2 py-3">
              <a
                href="/jobs"
                className="group flex items-center gap-2 text-blue-600 hover:text-blue-700 hover:bg-blue-50 transition-all font-medium px-4 py-2.5 rounded-xl hover:shadow-md"
                title="Offerte di Lavoro"
              >
                <div className="bg-blue-100 p-1.5 rounded-lg group-hover:bg-blue-200 transition-colors">
                  <Briefcase className="w-4 h-4 text-blue-600" />
                </div>
                <span className="text-sm font-semibold">Lavoro</span>
              </a>
              <a
                href="/classified-ads"
                className="group flex items-center gap-2 text-green-600 hover:text-green-700 hover:bg-green-50 transition-all font-medium px-4 py-2.5 rounded-xl hover:shadow-md"
                title="Annunci"
              >
                <div className="bg-green-100 p-1.5 rounded-lg group-hover:bg-green-200 transition-colors">
                  <Tag className="w-4 h-4 text-green-600" />
                </div>
                <span className="text-sm font-semibold">Annunci</span>
              </a>
              <a
                href="/auctions"
                className="group flex items-center gap-2 text-orange-600 hover:text-orange-700 hover:bg-orange-50 transition-all font-medium px-4 py-2.5 rounded-xl hover:shadow-md"
                title="Aste"
              >
                <div className="bg-orange-100 p-1.5 rounded-lg group-hover:bg-orange-200 transition-colors">
                  <Gavel className="w-4 h-4 text-orange-600" />
                </div>
                <span className="text-sm font-semibold">Aste</span>
              </a>
              <a
                href="/solidarity"
                className="group flex items-center gap-2 text-pink-600 hover:text-pink-700 hover:bg-pink-50 transition-all font-medium px-4 py-2.5 rounded-xl hover:shadow-md"
                title="Solidarietà"
              >
                <div className="bg-pink-100 p-1.5 rounded-lg group-hover:bg-pink-200 transition-colors">
                  <Heart className="w-4 h-4 text-pink-600" />
                </div>
                <span className="text-sm font-semibold">Solidarietà</span>
              </a>
              {profile?.user_type !== 'business' && (
                <a
                  href="/leaderboard"
                  className="group flex items-center gap-2 text-yellow-600 hover:text-yellow-700 hover:bg-yellow-50 transition-all font-medium px-4 py-2.5 rounded-xl hover:shadow-md"
                  title="Classifica"
                >
                  <div className="bg-yellow-100 p-1.5 rounded-lg group-hover:bg-yellow-200 transition-colors">
                    <Trophy className="w-4 h-4 text-yellow-600" />
                  </div>
                  <span className="text-sm font-semibold">Classifica</span>
                </a>
              )}
            </nav>
          </div>
        </div>
      )}

      {showAuthModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg shadow-xl max-w-md w-full p-8">
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-2xl font-bold text-gray-900">
                {authMode === 'login' ? 'Accedi' : 'Registrati'}
              </h2>
              <button
                onClick={() => setShowAuthModal(false)}
                className="text-gray-400 hover:text-gray-600"
              >
                <svg className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>

            {authMode === 'login' ? (
              <LoginForm onSuccess={() => {
                setShowAuthModal(false);
                window.location.href = '/';
              }} />
            ) : (
              <RegisterForm onSuccess={() => {
                setShowAuthModal(false);
                const claimBusinessId = sessionStorage.getItem('claimBusinessId');
                if (claimBusinessId) {
                  window.location.href = '/dashboard';
                } else {
                  window.location.href = '/';
                }
              }} />
            )}

            <div className="mt-6 text-center">
              <button
                onClick={() => setAuthMode(authMode === 'login' ? 'register' : 'login')}
                className="text-blue-600 hover:text-blue-700"
              >
                {authMode === 'login'
                  ? 'Non hai un account? Registrati'
                  : 'Hai già un account? Accedi'}
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
}
