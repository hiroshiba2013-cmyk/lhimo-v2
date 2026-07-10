import { useState, useEffect } from 'react';
import {
  Activity,
  Eye,
  Star,
  FileText,
  Package,
  Building,
  Gift,
  CreditCard,
  TrendingUp,
  Award,
  Users
} from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useAuth } from '../../contexts/AuthContext';

interface ActivityItem {
  id: string;
  activity_type: string;
  title: string;
  description: string;
  points_earned: number;
  metadata: any;
  icon: string;
  color: string;
  created_at: string;
}

interface ActivitySummary {
  total_activities: number;
  total_points_earned: number;
  activities_this_week: number;
  activities_this_month: number;
}

interface UserActivityStats {
  total_points: number;
  reviews_count: number;
  businesses_added_count: number;
  ads_posted_count: number;
  referrals_count: number;
}

const iconMap: { [key: string]: any } = {
  activity: Activity,
  eye: Eye,
  star: Star,
  'file-text': FileText,
  package: Package,
  building: Building,
  gift: Gift,
  'credit-card': CreditCard,
  award: Award,
  'trending-up': TrendingUp
};

export function ActivityFeed() {
  const { profile, activeProfile } = useAuth();
  const [activities, setActivities] = useState<ActivityItem[]>([]);
  const [summary, setSummary] = useState<ActivitySummary | null>(null);
  const [userStats, setUserStats] = useState<UserActivityStats | null>(null);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState<'all' | 'week' | 'month'>('all');

  const effectiveUserId = activeProfile?.id ?? profile?.id ?? null;
  const isFamilyMember = activeProfile?.isOwner === false;

  useEffect(() => {
    if (profile && effectiveUserId) {
      loadActivities();
      loadUserStats();
    }
  }, [profile, effectiveUserId, filter]);

  const loadActivities = async () => {
    if (!profile || !effectiveUserId) return;

    try {
      setLoading(true);
      let query = supabase
        .from('activity_log')
        .select('*')
        .eq('user_id', profile.id)
        .order('created_at', { ascending: false })
        .limit(50);

      if (isFamilyMember) {
        query = query.eq('family_member_id', effectiveUserId);
      } else {
        query = query.is('family_member_id', null);
      }

      if (filter === 'week') {
        const weekAgo = new Date();
        weekAgo.setDate(weekAgo.getDate() - 7);
        query = query.gte('created_at', weekAgo.toISOString());
      } else if (filter === 'month') {
        const monthAgo = new Date();
        monthAgo.setMonth(monthAgo.getMonth() - 1);
        query = query.gte('created_at', monthAgo.toISOString());
      }

      const { data, error } = await query;

      if (error) throw error;

      setActivities(data || []);
    } catch (error) {
      console.error('Error loading activities:', error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (activities.length > 0) {
      const now = new Date();
      const weekAgo = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
      const monthAgo = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);
      setSummary({
        total_activities: activities.length,
        total_points_earned: activities.reduce((sum, a) => sum + (a.points_earned || 0), 0),
        activities_this_week: activities.filter(a => new Date(a.created_at) >= weekAgo).length,
        activities_this_month: activities.filter(a => new Date(a.created_at) >= monthAgo).length,
      });
    } else {
      setSummary(null);
    }
  }, [activities]);

  const loadUserStats = async () => {
    if (!profile || !effectiveUserId) return;

    try {
      let query = supabase
        .from('user_activity')
        .select('total_points, reviews_count, businesses_added_count, ads_posted_count, referrals_count');

      if (isFamilyMember) {
        query = (query as any).eq('family_member_id', effectiveUserId);
      } else {
        query = (query as any).eq('user_id', profile.id).is('family_member_id', null);
      }

      const { data, error } = await (query as any).maybeSingle();

      if (error) throw error;

      if (data) {
        setUserStats(data);
      } else {
        setUserStats({
          total_points: 0,
          reviews_count: 0,
          businesses_added_count: 0,
          ads_posted_count: 0,
          referrals_count: 0,
        });
      }
    } catch (error) {
      console.error('Error loading user stats:', error);
    }
  };

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    const now = new Date();
    const diffInHours = (now.getTime() - date.getTime()) / (1000 * 60 * 60);

    if (diffInHours < 1) {
      const diffInMinutes = Math.floor(diffInHours * 60);
      return `${diffInMinutes} minuti fa`;
    } else if (diffInHours < 24) {
      return `${Math.floor(diffInHours)} ore fa`;
    } else if (diffInHours < 48) {
      return 'Ieri';
    } else {
      return date.toLocaleDateString('it-IT', {
        day: 'numeric',
        month: 'long',
        year: date.getFullYear() !== now.getFullYear() ? 'numeric' : undefined
      });
    }
  };

  const getIcon = (iconName: string) => {
    const IconComponent = iconMap[iconName] || Activity;
    return IconComponent;
  };

  if (!profile || !effectiveUserId) {
    return null;
  }

  if (loading) {
    return (
      <div className="bg-white rounded-xl shadow-lg p-8">
        <div className="text-center">
          <div className="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mb-4"></div>
          <p className="text-gray-600">Caricamento attività...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {userStats && (
        <div className="bg-white rounded-xl shadow-lg p-8 border-2 border-blue-200">
          <h3 className="text-2xl font-bold text-gray-900 mb-6 flex items-center gap-3">
            <Award className="w-8 h-8 text-blue-600" />
            Riepilogo Completo della Tua Attività
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">
            <div className="bg-gradient-to-br from-yellow-50 to-yellow-100 rounded-xl p-5 border-2 border-yellow-300">
              <div className="flex items-center justify-between mb-2">
                <Star className="w-7 h-7 text-yellow-600" />
                <span className="text-3xl font-bold text-yellow-700">{userStats.total_points}</span>
              </div>
              <p className="text-sm font-semibold text-gray-700">Punti Totali</p>
              <p className="text-xs text-gray-600 mt-1">Posizione in classifica</p>
            </div>

            <div className="bg-gradient-to-br from-blue-50 to-blue-100 rounded-xl p-5 border-2 border-blue-300">
              <div className="flex items-center justify-between mb-2">
                <FileText className="w-7 h-7 text-blue-600" />
                <span className="text-3xl font-bold text-blue-700">{userStats.reviews_count}</span>
              </div>
              <p className="text-sm font-semibold text-gray-700">Recensioni</p>
              <p className="text-xs text-gray-600 mt-1">25-50 punti ciascuna</p>
            </div>

            <div className="bg-gradient-to-br from-green-50 to-green-100 rounded-xl p-5 border-2 border-green-300">
              <div className="flex items-center justify-between mb-2">
                <Building className="w-7 h-7 text-green-600" />
                <span className="text-3xl font-bold text-green-700">{userStats.businesses_added_count}</span>
              </div>
              <p className="text-sm font-semibold text-gray-700">Attività Aggiunte</p>
              <p className="text-xs text-gray-600 mt-1">10-25 punti ciascuna</p>
            </div>

            <div className="bg-gradient-to-br from-gray-50 to-gray-100 rounded-xl p-5 border-2 border-gray-300">
              <div className="flex items-center justify-between mb-2">
                <Package className="w-7 h-7 text-gray-600" />
                <span className="text-3xl font-bold text-gray-700">{userStats.ads_posted_count}</span>
              </div>
              <p className="text-sm font-semibold text-gray-700">Annunci Pubblicati</p>
              <p className="text-xs text-gray-600 mt-1">5 punti ciascuno</p>
            </div>

            <div className="bg-gradient-to-br from-teal-50 to-teal-100 rounded-xl p-5 border-2 border-teal-300">
              <div className="flex items-center justify-between mb-2">
                <Users className="w-7 h-7 text-teal-600" />
                <span className="text-3xl font-bold text-teal-700">{userStats.referrals_count || 0}</span>
              </div>
              <p className="text-sm font-semibold text-gray-700">Amici Invitati</p>
              <p className="text-xs text-gray-600 mt-1">30 punti ciascuno</p>
            </div>
          </div>
        </div>
      )}

      {summary && (
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div className="bg-gradient-to-br from-blue-50 to-blue-100 rounded-xl p-6 border-2 border-blue-200">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600 mb-1">Attività Totali</p>
                <p className="text-3xl font-bold text-blue-700">{summary.total_activities}</p>
              </div>
              <Activity className="w-12 h-12 text-blue-500 opacity-50" />
            </div>
          </div>

          <div className="bg-gradient-to-br from-orange-50 to-orange-100 rounded-xl p-6 border-2 border-orange-200">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600 mb-1">Questa Settimana</p>
                <p className="text-3xl font-bold text-orange-700">{summary.activities_this_week}</p>
              </div>
              <TrendingUp className="w-12 h-12 text-orange-500 opacity-50" />
            </div>
          </div>

          <div className="bg-gradient-to-br from-purple-50 to-purple-100 rounded-xl p-6 border-2 border-purple-200">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600 mb-1">Questo Mese</p>
                <p className="text-3xl font-bold text-purple-700">{summary.activities_this_month}</p>
              </div>
              <Award className="w-12 h-12 text-purple-500 opacity-50" />
            </div>
          </div>
        </div>
      )}

      <div className="bg-white rounded-xl shadow-lg overflow-hidden">
        <div className="bg-gradient-to-r from-blue-600 to-blue-700 px-6 py-4">
          <div className="flex items-center justify-between">
            <div>
              <h2 className="text-2xl font-bold text-white">La Tua Attività</h2>
              {(activeProfile || profile) && (
                <p className="text-blue-100 text-sm mt-1">{activeProfile?.name ?? profile?.full_name}</p>
              )}
            </div>
            <div className="inline-flex rounded-lg border border-blue-400 bg-blue-500/20 p-1">
              <button
                onClick={() => setFilter('all')}
                className={`px-4 py-2 rounded-lg font-medium transition-all text-sm ${
                  filter === 'all'
                    ? 'bg-white text-blue-700'
                    : 'text-white hover:bg-blue-500/30'
                }`}
              >
                Tutte
              </button>
              <button
                onClick={() => setFilter('week')}
                className={`px-4 py-2 rounded-lg font-medium transition-all text-sm ${
                  filter === 'week'
                    ? 'bg-white text-blue-700'
                    : 'text-white hover:bg-blue-500/30'
                }`}
              >
                Settimana
              </button>
              <button
                onClick={() => setFilter('month')}
                className={`px-4 py-2 rounded-lg font-medium transition-all text-sm ${
                  filter === 'month'
                    ? 'bg-white text-blue-700'
                    : 'text-white hover:bg-blue-500/30'
                }`}
              >
                Mese
              </button>
            </div>
          </div>
        </div>

        <div className="divide-y divide-gray-200 max-h-[600px] overflow-y-auto">
          {activities.length === 0 ? (
            <div className="p-12 text-center text-gray-500">
              <Activity className="w-16 h-16 mx-auto mb-4 text-gray-300" />
              <p className="text-lg">Nessuna attività ancora</p>
              <p className="text-sm mt-2">Inizia a interagire con la piattaforma per vedere le tue attività qui!</p>
            </div>
          ) : (
            activities.map((activity) => {
              const IconComponent = getIcon(activity.icon);
              return (
                <div
                  key={activity.id}
                  className="p-6 hover:bg-gray-50 transition-colors"
                >
                  <div className="flex items-start gap-4">
                    <div className={`flex-shrink-0 w-12 h-12 rounded-full flex items-center justify-center bg-gray-100`}>
                      <IconComponent className={`w-6 h-6 ${activity.color}`} />
                    </div>

                    <div className="flex-1 min-w-0">
                      <div className="flex items-start justify-between gap-4">
                        <div className="flex-1">
                          <h3 className="font-semibold text-gray-900 text-lg">
                            {activity.title}
                          </h3>
                          <p className="text-gray-600 mt-1">
                            {activity.description}
                          </p>
                          <p className="text-sm text-gray-400 mt-2">
                            {formatDate(activity.created_at)}
                          </p>
                        </div>

                        {activity.points_earned > 0 && (
                          <div className="flex-shrink-0 bg-yellow-100 text-yellow-700 px-4 py-2 rounded-full">
                            <span className="font-bold">+{activity.points_earned}</span>
                            <span className="text-sm ml-1">punti</span>
                          </div>
                        )}
                      </div>
                    </div>
                  </div>
                </div>
              );
            })
          )}
        </div>
      </div>
    </div>
  );
}
