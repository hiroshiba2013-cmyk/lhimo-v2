import { useState, useEffect } from 'react';
import { Bell } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useAuth } from '../../contexts/AuthContext';

export default function NotificationBell() {
  const { user, profile, activeProfile, selectedBusinessLocationId } = useAuth();
  const [unreadCount, setUnreadCount] = useState(0);

  const activeFamilyMemberId = activeProfile && !activeProfile.isOwner && profile?.user_type === 'customer'
    ? activeProfile.id
    : null;

  const activeBusinessLocationId = profile?.user_type === 'business' ? (selectedBusinessLocationId ?? null) : null;

  useEffect(() => {
    if (!user) return;

    loadUnreadCount();

    const channel = supabase
      .channel('notifications_changes')
      .on(
        'postgres_changes',
        {
          event: '*',
          schema: 'public',
          table: 'notifications',
          filter: `user_id=eq.${user.id}`,
        },
        () => {
          loadUnreadCount();
        }
      )
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, [user, activeFamilyMemberId, activeBusinessLocationId]);

  async function loadUnreadCount() {
    if (!user) return;

    try {
      const { data, error } = await supabase
        .rpc('get_unread_notification_count', {
          p_family_member_id: activeFamilyMemberId,
          p_business_location_id: activeBusinessLocationId,
        });

      if (error) throw error;
      setUnreadCount(data || 0);
    } catch (error) {
      console.error('Error loading unread count:', error);
    }
  }

  if (!user) return null;

  return (
    <button
      onClick={() => window.location.href = '/notifications'}
      className="relative flex items-center gap-0.5 text-gray-700 hover:text-blue-600 transition-colors font-medium"
      title="Notifiche"
    >
      <div className="relative">
        <Bell className="w-4 h-4" />
        {unreadCount > 0 && (
          <span className="absolute -top-1 -right-1 inline-flex items-center justify-center px-1 text-xs font-bold leading-none text-white bg-red-600 rounded-full min-w-[16px] h-4">
            {unreadCount > 99 ? '99+' : unreadCount}
          </span>
        )}
      </div>
      <span className="text-xs">Notifiche</span>
    </button>
  );
}
