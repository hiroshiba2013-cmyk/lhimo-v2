import { useState, useEffect, useRef } from 'react';
import { Bell, X, Check, CheckCheck, Trash2, Loader2, Star, Trophy, ThumbsDown, Building2, ShoppingBag, Briefcase, AlertCircle, Gavel, MessageSquare } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useAuth } from '../../contexts/AuthContext';

interface Notification {
  id: string;
  type: string;
  title: string;
  message: string;
  data: any;
  read: boolean;
  created_at: string;
}

interface NotificationPanelProps {
  onClose: () => void;
  onNotificationRead: () => void;
}

export default function NotificationPanel({ onClose, onNotificationRead }: NotificationPanelProps) {
  const { user, profile, activeProfile, selectedBusinessLocationId } = useAuth();

  const activeFamilyMemberId = activeProfile && !activeProfile.isOwner && profile?.user_type === 'customer'
    ? activeProfile.id
    : null;
  const activeBusinessLocationId = profile?.user_type === 'business' ? (selectedBusinessLocationId ?? null) : null;
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const [loading, setLoading] = useState(true);
  const panelRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    loadNotifications();

    function handleClickOutside(event: MouseEvent) {
      if (panelRef.current && !panelRef.current.contains(event.target as Node)) {
        onClose();
      }
    }

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, [activeFamilyMemberId]);

  async function loadNotifications() {
    if (!user) return;

    try {
      setLoading(true);
      let query = supabase
        .from('notifications')
        .select('*')
        .eq('user_id', user.id);

      if (activeFamilyMemberId) {
        query = query.eq('family_member_id', activeFamilyMemberId);
      } else {
        query = query.is('family_member_id', null);
      }

      const { data, error } = await query
        .order('created_at', { ascending: false })
        .limit(20);

      if (error) throw error;
      setNotifications(data || []);
    } catch (error) {
      console.error('Error loading notifications:', error);
    } finally {
      setLoading(false);
    }
  }

  async function markAsRead(notificationId: string) {
    try {
      const { error } = await supabase
        .rpc('mark_notification_read', { notification_id: notificationId });

      if (error) throw error;

      setNotifications(prev =>
        prev.map(n => n.id === notificationId ? { ...n, read: true } : n)
      );
      onNotificationRead();
    } catch (error) {
      console.error('Error marking notification as read:', error);
    }
  }

  async function markAllAsRead() {
    try {
      const { error } = await supabase.rpc('mark_all_notifications_read', {
        p_family_member_id: activeFamilyMemberId,
        p_business_location_id: activeBusinessLocationId,
      });

      if (error) throw error;

      setNotifications(prev => prev.map(n => ({ ...n, read: true })));
      onNotificationRead();
    } catch (error) {
      console.error('Error marking all as read:', error);
    }
  }

  async function deleteNotification(notificationId: string) {
    try {
      const { error } = await supabase
        .from('notifications')
        .delete()
        .eq('id', notificationId);

      if (error) throw error;

      setNotifications(prev => prev.filter(n => n.id !== notificationId));
      onNotificationRead();
    } catch (error) {
      console.error('Error deleting notification:', error);
    }
  }

  function handleNotificationClick(notification: Notification) {
    if (!notification.read) {
      markAsRead(notification.id);
    }

    if (notification.data?.url) {
      window.location.href = notification.data.url;
    }
  }

  function getNotificationIcon(type: string) {
    switch (type) {
      case 'review_approved':
        return { icon: <Star className="w-4 h-4" />, bg: 'bg-amber-100', color: 'text-amber-600' };
      case 'review_rejected':
        return { icon: <ThumbsDown className="w-4 h-4" />, bg: 'bg-red-100', color: 'text-red-600' };
      case 'ad_approved':
        return { icon: <ShoppingBag className="w-4 h-4" />, bg: 'bg-green-100', color: 'text-green-600' };
      case 'ad_rejected':
        return { icon: <ShoppingBag className="w-4 h-4" />, bg: 'bg-red-100', color: 'text-red-600' };
      case 'job_approved':
      case 'job_seeker_approved':
        return { icon: <Briefcase className="w-4 h-4" />, bg: 'bg-blue-100', color: 'text-blue-600' };
      case 'job_rejected':
      case 'job_seeker_rejected':
        return { icon: <Briefcase className="w-4 h-4" />, bg: 'bg-red-100', color: 'text-red-600' };
      case 'auction_approved':
      case 'auction_concluded':
      case 'auction_won':
        return { icon: <Gavel className="w-4 h-4" />, bg: 'bg-orange-100', color: 'text-orange-600' };
      case 'points_earned':
        return { icon: <Trophy className="w-4 h-4" />, bg: 'bg-amber-100', color: 'text-amber-600' };
      case 'business_approved':
        return { icon: <Building2 className="w-4 h-4" />, bg: 'bg-green-100', color: 'text-green-600' };
      case 'new_message':
        return { icon: <MessageSquare className="w-4 h-4" />, bg: 'bg-blue-100', color: 'text-blue-600' };
      case 'report_submitted':
        return { icon: <AlertCircle className="w-4 h-4" />, bg: 'bg-gray-100', color: 'text-gray-600' };
      default:
        return { icon: <Bell className="w-4 h-4" />, bg: 'bg-gray-100', color: 'text-gray-500' };
    }
  }

  function formatTime(dateString: string) {
    const date = new Date(dateString);
    const now = new Date();
    const diffMs = now.getTime() - date.getTime();
    const diffMins = Math.floor(diffMs / 60000);
    const diffHours = Math.floor(diffMins / 60);
    const diffDays = Math.floor(diffHours / 24);

    if (diffMins < 1) return 'Ora';
    if (diffMins < 60) return `${diffMins}m fa`;
    if (diffHours < 24) return `${diffHours}h fa`;
    if (diffDays < 7) return `${diffDays}g fa`;
    return date.toLocaleDateString('it-IT');
  }

  const unreadCount = notifications.filter(n => !n.read).length;

  return (
    <div
      ref={panelRef}
      className="absolute right-0 top-12 w-96 bg-white rounded-lg shadow-2xl border border-gray-200 z-50 max-h-[600px] flex flex-col"
    >
      <div className="p-4 border-b border-gray-200 flex items-center justify-between">
        <div>
          <h3 className="text-lg font-semibold text-gray-900">Notifiche</h3>
          {unreadCount > 0 && (
            <p className="text-sm text-gray-600">{unreadCount} non lette</p>
          )}
        </div>
        <div className="flex items-center gap-2">
          {unreadCount > 0 && (
            <button
              onClick={markAllAsRead}
              className="p-2 text-blue-600 hover:bg-blue-50 rounded-lg transition-colors"
              title="Segna tutte come lette"
            >
              <CheckCheck className="w-5 h-5" />
            </button>
          )}
          <button
            onClick={onClose}
            className="p-2 text-gray-400 hover:text-gray-600 transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto">
        {loading ? (
          <div className="flex items-center justify-center py-8">
            <Loader2 className="w-6 h-6 animate-spin text-gray-400" />
          </div>
        ) : notifications.length === 0 ? (
          <div className="text-center py-8 px-4">
            <Bell className="w-12 h-12 text-gray-300 mx-auto mb-2" />
            <p className="text-gray-500">Nessuna notifica</p>
          </div>
        ) : (
          <div className="divide-y divide-gray-100">
            {notifications.map((notification) => {
              const { icon, bg, color } = getNotificationIcon(notification.type);
              const pointsAwarded = notification.data?.points_awarded as number | undefined;
              return (
                <div
                  key={notification.id}
                  className={`p-4 hover:bg-gray-50 transition-colors cursor-pointer group ${
                    !notification.read ? 'bg-blue-50 border-l-2 border-l-blue-500' : ''
                  }`}
                  onClick={() => handleNotificationClick(notification)}
                >
                  <div className="flex items-start gap-3">
                    <div className={`flex-shrink-0 w-8 h-8 rounded-full ${bg} flex items-center justify-center ${color}`}>
                      {icon}
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2 flex-wrap">
                        <h4 className="text-sm font-semibold text-gray-900">
                          {notification.title}
                        </h4>
                        {!notification.read && (
                          <span className="flex-shrink-0 w-2 h-2 bg-blue-600 rounded-full"></span>
                        )}
                        {pointsAwarded && (
                          <span className="flex items-center gap-0.5 px-2 py-0.5 bg-amber-100 text-amber-700 text-xs font-bold rounded-full border border-amber-200">
                            <Trophy className="w-3 h-3" />
                            +{pointsAwarded} punti
                          </span>
                        )}
                      </div>
                      <p className="text-sm text-gray-600 mt-1 line-clamp-2">
                        {notification.message}
                      </p>
                      <p className="text-xs text-gray-400 mt-1">
                        {formatTime(notification.created_at)}
                      </p>
                    </div>
                    <div className="flex items-center gap-1 opacity-0 group-hover:opacity-100 transition-opacity flex-shrink-0">
                      {!notification.read && (
                        <button
                          onClick={(e) => {
                            e.stopPropagation();
                            markAsRead(notification.id);
                          }}
                          className="p-1 text-blue-600 hover:bg-blue-100 rounded transition-colors"
                          title="Segna come letta"
                        >
                          <Check className="w-4 h-4" />
                        </button>
                      )}
                      <button
                        onClick={(e) => {
                          e.stopPropagation();
                          deleteNotification(notification.id);
                        }}
                        className="p-1 text-red-600 hover:bg-red-100 rounded transition-colors"
                        title="Elimina"
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}
