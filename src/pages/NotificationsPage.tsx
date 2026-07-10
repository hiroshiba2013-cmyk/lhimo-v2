import { useState, useEffect } from 'react';
import { Bell, Check, CheckCheck, Trash2, Heart, Briefcase, CreditCard, Store, ShoppingBag, CheckCircle, XCircle, Star, Gavel, AlertTriangle, Building2, Trophy } from 'lucide-react';
// Note: Heart, Store are used for legacy favorite notification types
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';

interface Notification {
  id: string;
  type: string;
  title: string;
  message: string;
  data: any;
  read: boolean;
  created_at: string;
  family_member_id: string | null;
}

// ─── Category definitions ──────────────────────────────────────────────────

type CategoryFilter =
  | 'all'
  | 'unread'
  | 'reviews'
  | 'classifieds'
  | 'auctions'
  | 'businesses'
  | 'jobs'
  | 'reports'
  | 'leaderboard';

const CATEGORY_TYPES: Record<Exclude<CategoryFilter, 'all' | 'unread'>, string[]> = {
  reviews:     ['review_approved', 'review_rejected', 'review_received'],
  classifieds: ['classified_ad_approved', 'classified_ad_rejected'],
  auctions:    ['auction_approved', 'auction_rejected', 'auction_concluded', 'auction_won'],
  businesses:  ['business_approved', 'business_rejected'],
  jobs:        ['job_posting_approved', 'job_posting_rejected', 'job_seeker_approved', 'job_seeker_rejected'],
  reports:     ['report_submitted'],
  leaderboard: ['points_earned', 'leaderboard_rank', 'subscription_expiring'],
};

// Always show these even when count is 0
const PINNED_CATEGORIES: CategoryFilter[] = [
  'all', 'unread', 'reviews', 'classifieds', 'auctions',
  'businesses', 'jobs', 'reports', 'leaderboard',
];

const CATEGORY_LABELS: Record<CategoryFilter, string> = {
  all:         'Tutte',
  unread:      'Non lette',
  reviews:     'Recensioni',
  classifieds: 'Annunci',
  auctions:    'Aste',
  businesses:  'Attività',
  jobs:        'Lavoro',
  reports:     'Segnalazioni',
  leaderboard: 'Classifica',
};

const CATEGORY_ICONS: Record<CategoryFilter, React.ElementType> = {
  all:         Bell,
  unread:      Bell,
  reviews:     Star,
  classifieds: ShoppingBag,
  auctions:    Gavel,
  businesses:  Building2,
  jobs:        Briefcase,
  reports:     AlertTriangle,
  leaderboard: Trophy,
};

// ─── Per-type icon config ──────────────────────────────────────────────────

interface IconConfig { icon: React.ElementType; color: string; bg: string }

function getIconConfig(type: string): IconConfig {
  switch (type) {
    // Reviews
    case 'review_approved':
      return { icon: CheckCircle, color: 'text-green-600', bg: 'bg-green-100' };
    case 'review_rejected':
      return { icon: XCircle, color: 'text-red-600', bg: 'bg-red-100' };
    case 'review_received':
      return { icon: Star, color: 'text-yellow-600', bg: 'bg-yellow-100' };
    case 'admin_new_review':
      return { icon: Star, color: 'text-yellow-600', bg: 'bg-yellow-100' };

    // Classifieds
    case 'classified_ad_approved':
      return { icon: CheckCircle, color: 'text-green-600', bg: 'bg-green-100' };
    case 'classified_ad_rejected':
      return { icon: XCircle, color: 'text-red-600', bg: 'bg-red-100' };

    // Auctions
    case 'auction_approved':
      return { icon: CheckCircle, color: 'text-green-600', bg: 'bg-green-100' };
    case 'auction_rejected':
      return { icon: XCircle, color: 'text-red-600', bg: 'bg-red-100' };
    case 'auction_concluded':
      return { icon: Gavel, color: 'text-gray-600', bg: 'bg-gray-100' };
    case 'auction_won':
      return { icon: Trophy, color: 'text-yellow-600', bg: 'bg-yellow-100' };

    // Businesses
    case 'business_approved':
      return { icon: CheckCircle, color: 'text-green-600', bg: 'bg-green-100' };
    case 'business_rejected':
      return { icon: XCircle, color: 'text-red-600', bg: 'bg-red-100' };

    // Jobs
    case 'job_posting_approved':
    case 'job_seeker_approved':
      return { icon: CheckCircle, color: 'text-green-600', bg: 'bg-green-100' };
    case 'job_posting_rejected':
    case 'job_seeker_rejected':
      return { icon: XCircle, color: 'text-red-600', bg: 'bg-red-100' };

    // Reports
    case 'report_submitted':
      return { icon: AlertTriangle, color: 'text-amber-600', bg: 'bg-amber-100' };
    case 'report_resolved':
      return { icon: CheckCircle, color: 'text-green-600', bg: 'bg-green-100' };

    // Leaderboard / points
    case 'points_earned':
    case 'leaderboard_rank':
      return { icon: Trophy, color: 'text-yellow-600', bg: 'bg-yellow-100' };
    case 'subscription_expiring':
      return { icon: CreditCard, color: 'text-orange-600', bg: 'bg-orange-100' };

    // Favourites (legacy)
    case 'ad_favorited':
      return { icon: Heart, color: 'text-red-600', bg: 'bg-red-100' };
    case 'business_favorited':
      return { icon: Store, color: 'text-green-600', bg: 'bg-green-100' };
    case 'job_favorited':
      return { icon: Briefcase, color: 'text-blue-600', bg: 'bg-blue-100' };

    default:
      return { icon: Bell, color: 'text-blue-600', bg: 'bg-blue-100' };
  }
}

function getCategoryForType(type: string): Exclude<CategoryFilter, 'all' | 'unread'> | null {
  for (const [cat, types] of Object.entries(CATEGORY_TYPES)) {
    if ((types as string[]).includes(type)) return cat as Exclude<CategoryFilter, 'all' | 'unread'>;
  }
  return null;
}

// ─── Helpers ──────────────────────────────────────────────────────────────

function formatTime(dateString: string) {
  const date = new Date(dateString);
  const diffMs = Date.now() - date.getTime();
  const diffMins = Math.floor(diffMs / 60000);
  const diffHours = Math.floor(diffMins / 60);
  const diffDays = Math.floor(diffHours / 24);
  if (diffMins < 1) return 'Ora';
  if (diffMins < 60) return `${diffMins}m fa`;
  if (diffHours < 24) return `${diffHours}h fa`;
  if (diffDays < 7) return `${diffDays}g fa`;
  return date.toLocaleDateString('it-IT');
}

// ─── Component ────────────────────────────────────────────────────────────

export function NotificationsPage() {
  const { user, profile, activeProfile, selectedBusinessLocationId, loading: authLoading } = useAuth();
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const [loading, setLoading] = useState(true);
  const [activeFilter, setActiveFilter] = useState<CategoryFilter>('all');

  const activeFamilyMemberId =
    activeProfile && !activeProfile.isOwner && profile?.user_type === 'customer'
      ? activeProfile.id
      : null;
  const activeBusinessLocationId =
    profile?.user_type === 'business' ? (selectedBusinessLocationId ?? null) : null;

  useEffect(() => {
    if (authLoading) return;
    if (!user) { window.location.href = '/'; return; }
    loadNotifications();

    const channel = supabase
      .channel('notifications-page')
      .on('postgres_changes', {
        event: '*', schema: 'public', table: 'notifications',
        filter: `user_id=eq.${user.id}`,
      }, () => loadNotifications())
      .subscribe();

    return () => { supabase.removeChannel(channel); };
  }, [user, authLoading, activeFamilyMemberId]);

  async function loadNotifications() {
    if (!user) return;
    try {
      setLoading(true);
      let query = supabase.from('notifications').select('*').eq('user_id', user.id);
      if (activeFamilyMemberId) {
        query = query.eq('family_member_id', activeFamilyMemberId);
      } else {
        query = query.is('family_member_id', null);
      }
      const { data, error } = await query.order('created_at', { ascending: false });
      if (error) throw error;
      setNotifications(data || []);
    } catch (err) {
      console.error('Error loading notifications:', err);
    } finally {
      setLoading(false);
    }
  }

  async function markAsRead(id: string) {
    await supabase.rpc('mark_notification_read', { notification_id: id });
    setNotifications(prev => prev.map(n => n.id === id ? { ...n, read: true } : n));
  }

  async function markAllAsRead() {
    await supabase.rpc('mark_all_notifications_read', {
      p_family_member_id: activeFamilyMemberId,
      p_business_location_id: activeBusinessLocationId,
    });
    setNotifications(prev => prev.map(n => ({ ...n, read: true })));
  }

  async function deleteNotification(id: string) {
    await supabase.from('notifications').delete().eq('id', id);
    setNotifications(prev => prev.filter(n => n.id !== id));
  }

  function handleClick(notification: Notification) {
    if (!notification.read) markAsRead(notification.id);
    if (notification.data?.url) window.location.href = notification.data.url;
  }

  // ── Counts ────────────────────────────────────────────────────────────────

  function totalCount(cat: CategoryFilter) {
    if (cat === 'all') return notifications.length;
    if (cat === 'unread') return notifications.filter(n => !n.read).length;
    const types = CATEGORY_TYPES[cat];
    return notifications.filter(n => types.includes(n.type)).length;
  }

  function unreadCount(cat: CategoryFilter) {
    if (cat === 'all' || cat === 'unread') return notifications.filter(n => !n.read).length;
    const types = CATEGORY_TYPES[cat];
    return notifications.filter(n => !n.read && types.includes(n.type)).length;
  }

  const totalUnread = notifications.filter(n => !n.read).length;

  const filtered = (() => {
    if (activeFilter === 'all') return notifications;
    if (activeFilter === 'unread') return notifications.filter(n => !n.read);
    const types = CATEGORY_TYPES[activeFilter];
    return notifications.filter(n => types.includes(n.type));
  })();

  // ── Render ────────────────────────────────────────────────────────────────

  if (authLoading || loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  function SidebarItem({ cat }: { cat: CategoryFilter }) {
    const Icon = CATEGORY_ICONS[cat];
    const count = totalCount(cat);
    const unread = unreadCount(cat);
    const isActive = activeFilter === cat;

    return (
      <button
        onClick={() => setActiveFilter(cat)}
        className={`w-full flex items-center justify-between gap-2 px-3 py-2.5 rounded-xl text-sm font-medium transition-all mb-0.5 ${
          isActive
            ? 'bg-blue-600 text-white shadow-sm'
            : 'text-gray-700 hover:bg-gray-100'
        }`}
      >
        <div className="flex items-center gap-2.5 min-w-0">
          <Icon className={`w-4 h-4 flex-shrink-0 ${isActive ? 'text-white' : 'text-gray-400'}`} />
          <span className="truncate">{CATEGORY_LABELS[cat]}</span>
        </div>
        <div className="flex items-center gap-1.5 flex-shrink-0">
          {unread > 0 && cat !== 'unread' && (
            <span className={`w-2 h-2 rounded-full ${isActive ? 'bg-white' : 'bg-blue-500'}`}></span>
          )}
          <span className={`text-xs ${isActive ? 'text-blue-100' : 'text-gray-400'}`}>{count}</span>
        </div>
      </button>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50">

      {/* Hero */}
      <section className="bg-white border-b border-gray-100">
        <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-12 md:py-16">
          <div className="flex flex-col md:flex-row md:items-end md:justify-between gap-4">
            <div>
              <div className={`inline-flex items-center gap-2 text-xs font-semibold px-3 py-1.5 rounded-full mb-4 ${
                totalUnread > 0 ? 'bg-blue-50 text-blue-700' : 'bg-gray-100 text-gray-500'
              }`}>
                <div className={`w-1.5 h-1.5 rounded-full ${totalUnread > 0 ? 'bg-blue-500 animate-pulse' : 'bg-gray-400'}`}></div>
                {totalUnread > 0 ? `${totalUnread} ${totalUnread === 1 ? 'non letta' : 'non lette'}` : 'Tutto in ordine'}
              </div>
              <h1 className="text-4xl md:text-5xl font-extrabold text-gray-900 leading-tight">Notifiche</h1>
              <p className="text-lg text-gray-500 mt-2">Tieniti aggiornato su tutto quello che succede</p>
            </div>
            {totalUnread > 0 && (
              <button
                onClick={markAllAsRead}
                className="flex items-center gap-2 px-5 py-2.5 bg-blue-600 text-white rounded-xl font-semibold text-sm hover:bg-blue-700 transition-colors self-start md:self-auto flex-shrink-0"
              >
                <CheckCheck className="w-4 h-4" />
                Segna tutte come lette
              </button>
            )}
          </div>
        </div>
      </section>

      <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-6">

        {/* Mobile pill tabs */}
        <div className="md:hidden mb-4 flex gap-2 overflow-x-auto pb-2">
          {PINNED_CATEGORIES.map(cat => {
            const count = totalCount(cat);
            const unread = unreadCount(cat);
            const isActive = activeFilter === cat;
            const Icon = CATEGORY_ICONS[cat];
            return (
              <button
                key={cat}
                onClick={() => setActiveFilter(cat)}
                className={`flex-shrink-0 flex items-center gap-1.5 px-3 py-2 rounded-xl text-sm font-medium transition-all ${
                  isActive
                    ? 'bg-blue-600 text-white'
                    : 'bg-white text-gray-700 border border-gray-200 hover:bg-gray-50'
                }`}
              >
                <Icon className={`w-3.5 h-3.5 ${isActive ? 'text-white' : 'text-gray-400'}`} />
                {unread > 0 && cat !== 'unread' && (
                  <span className={`w-1.5 h-1.5 rounded-full ${isActive ? 'bg-white' : 'bg-blue-500'}`}></span>
                )}
                <span>{CATEGORY_LABELS[cat]}</span>
                <span className={`text-xs ${isActive ? 'text-blue-100' : 'text-gray-400'}`}>({count})</span>
              </button>
            );
          })}
        </div>

        <div className="flex gap-6">

          {/* Desktop sidebar */}
          <aside className="hidden md:block w-52 flex-shrink-0">
            <div className="bg-white rounded-2xl border border-gray-200 overflow-hidden sticky top-6">
              <div className="px-4 py-3 border-b border-gray-100">
                <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider">Filtra per</p>
              </div>
              <nav className="p-2">
                {PINNED_CATEGORIES.map(cat => <SidebarItem key={cat} cat={cat} />)}
              </nav>
            </div>
          </aside>

          {/* List */}
          <div className="flex-1 min-w-0">
            <div className="flex items-center gap-2 mb-4">
              {(() => { const Icon = CATEGORY_ICONS[activeFilter]; return <Icon className="w-4 h-4 text-gray-400" />; })()}
              <h2 className="text-base font-semibold text-gray-800">
                {CATEGORY_LABELS[activeFilter]}
                <span className="ml-1.5 text-sm font-normal text-gray-400">({filtered.length})</span>
              </h2>
            </div>

            {filtered.length === 0 ? (
              <div className="bg-white rounded-2xl border border-gray-200 p-12 text-center">
                {(() => {
                  const Icon = CATEGORY_ICONS[activeFilter];
                  return <Icon className="w-14 h-14 text-gray-200 mx-auto mb-4" />;
                })()}
                <h3 className="text-base font-semibold text-gray-700 mb-1">
                  {activeFilter === 'unread' ? 'Nessuna notifica non letta' : 'Nessuna notifica qui'}
                </h3>
                <p className="text-sm text-gray-500">
                  {activeFilter === 'unread'
                    ? 'Hai letto tutto!'
                    : 'Le notifiche per questa categoria appariranno qui'}
                </p>
              </div>
            ) : (
              <div className="bg-white rounded-2xl border border-gray-200 overflow-hidden divide-y divide-gray-100">
                {filtered.map(notification => {
                  const { icon: Icon, color, bg } = getIconConfig(notification.type);
                  const cat = getCategoryForType(notification.type);

                  return (
                    <div
                      key={notification.id}
                      onClick={() => handleClick(notification)}
                      className={`group cursor-pointer hover:bg-gray-50 transition-colors ${
                        !notification.read ? 'border-l-4 border-blue-600' : ''
                      }`}
                    >
                      <div className="p-4 md:p-5">
                        <div className="flex items-start gap-4">

                          {/* Icon */}
                          <div className={`flex-shrink-0 w-11 h-11 rounded-full flex items-center justify-center ${!notification.read ? bg : 'bg-gray-100'}`}>
                            <Icon className={`w-5 h-5 ${!notification.read ? color : 'text-gray-400'}`} />
                          </div>

                          <div className="flex-1 min-w-0">
                            {/* Title row */}
                            <div className="flex items-start justify-between gap-2 mb-1">
                              <div className="flex items-center gap-2 flex-wrap">
                                <span className={`font-semibold text-sm ${!notification.read ? 'text-gray-900' : 'text-gray-600'}`}>
                                  {notification.title}
                                </span>
                                {!notification.read && (
                                  <span className="w-2 h-2 bg-blue-600 rounded-full flex-shrink-0"></span>
                                )}
                                {cat && (
                                  <span className="text-xs bg-gray-100 text-gray-500 px-2 py-0.5 rounded-full font-medium">
                                    {CATEGORY_LABELS[cat]}
                                  </span>
                                )}
                              </div>
                              <span className="text-xs text-gray-400 flex-shrink-0 mt-0.5">
                                {formatTime(notification.created_at)}
                              </span>
                            </div>

                            {/* Message */}
                            <p className="text-sm text-gray-600 mb-3 leading-relaxed">{notification.message}</p>

                            {/* Actions */}
                            <div className="flex items-center gap-1">
                              {!notification.read && (
                                <button
                                  onClick={e => { e.stopPropagation(); markAsRead(notification.id); }}
                                  className="flex items-center gap-1 px-2.5 py-1 text-xs text-blue-600 hover:bg-blue-50 rounded-lg transition-colors font-medium"
                                >
                                  <Check className="w-3.5 h-3.5" />
                                  Segna come letta
                                </button>
                              )}
                              <button
                                onClick={e => { e.stopPropagation(); deleteNotification(notification.id); }}
                                className="flex items-center gap-1 px-2.5 py-1 text-xs text-red-500 hover:bg-red-50 rounded-lg transition-colors font-medium"
                              >
                                <Trash2 className="w-3.5 h-3.5" />
                                Elimina
                              </button>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
