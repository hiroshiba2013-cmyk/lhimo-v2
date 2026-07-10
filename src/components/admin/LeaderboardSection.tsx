import { useState, useEffect } from 'react';
import { Award, TrendingUp, Star, MessageCircle, Briefcase, Tag, Search, Building2, Gavel, Users } from 'lucide-react';
import { supabase } from '../../lib/supabase';

interface LeaderboardEntry {
  user_id: string;
  family_member_id: string | null;
  nickname: string;
  display_label: string; // "nickname (membro di ...)" per family members
  email: string;
  user_type: string;
  total_points: number;
  reviews_count: number;
  ads_count: number;
  ads_posted_count: number;
  job_postings_count: number;
  referrals_count: number;
  businesses_added_count: number;
  auctions_count: number;
  is_family_member: boolean;
}

const SORT_OPTIONS = [
  { key: 'points', label: 'Punti', icon: TrendingUp, color: 'blue' },
  { key: 'reviews', label: 'Recensioni', icon: Star, color: 'yellow' },
  { key: 'ads', label: 'Annunci', icon: Tag, color: 'pink' },
  { key: 'businesses', label: 'Attivita\'', icon: Building2, color: 'green' },
  { key: 'auctions', label: 'Aste', icon: Gavel, color: 'orange' },
  { key: 'referrals', label: 'Referral', icon: MessageCircle, color: 'purple' },
] as const;

type SortKey = typeof SORT_OPTIONS[number]['key'];

const SORT_TO_COLUMN: Record<SortKey, string> = {
  points: 'total_points',
  reviews: 'reviews_count',
  ads: 'ads_count',
  businesses: 'businesses_added_count',
  auctions: 'auctions_count',
  referrals: 'referrals_count',
};

export function LeaderboardSection() {
  const [leaderboard, setLeaderboard] = useState<LeaderboardEntry[]>([]);
  const [filtered, setFiltered] = useState<LeaderboardEntry[]>([]);
  const [loading, setLoading] = useState(true);
  const [sortBy, setSortBy] = useState<SortKey>('points');
  const [searchNickname, setSearchNickname] = useState('');
  const [searchEmail, setSearchEmail] = useState('');

  useEffect(() => { loadLeaderboard(); }, [sortBy]);
  useEffect(() => { applyFilters(); }, [leaderboard, searchNickname, searchEmail]);

  const applyFilters = () => {
    let result = [...leaderboard];
    if (searchNickname) result = result.filter(u => u.nickname.toLowerCase().includes(searchNickname.toLowerCase()));
    if (searchEmail) result = result.filter(u => u.email.toLowerCase().includes(searchEmail.toLowerCase()));
    setFiltered(result);
  };

  const loadLeaderboard = async () => {
    setLoading(true);
    try {
      const { data, error } = await supabase
        .from('user_activity')
        .select(`
          user_id,
          family_member_id,
          total_points,
          reviews_count,
          ads_count,
          ads_posted_count,
          job_postings_count,
          referrals_count,
          businesses_added_count,
          auctions_count
        `)
        .order(SORT_TO_COLUMN[sortBy], { ascending: false })
        .gt('total_points', 0)
        .limit(200);

      if (error) throw error;

      // Collect all unique user_ids
      const userIds = [...new Set((data || []).map(r => r.user_id))];
      const familyMemberIds = [...new Set((data || []).filter(r => r.family_member_id).map(r => r.family_member_id as string))];

      // Load profiles
      const { data: profiles } = await supabase
        .from('profiles')
        .select('id, full_name, nickname, email, user_type')
        .in('id', userIds);

      const profileMap = new Map((profiles || []).map(p => [p.id, p]));

      // Load family member names
      let familyMap = new Map<string, string>();
      if (familyMemberIds.length > 0) {
        const { data: famData } = await supabase
          .from('customer_family_members')
          .select('id, nickname, first_name, last_name')
          .in('id', familyMemberIds);
        (famData || []).forEach(fm => {
          familyMap.set(fm.id, fm.nickname || `${fm.first_name} ${fm.last_name}`);
        });
      }

      const enriched: LeaderboardEntry[] = (data || [])
        .map(item => {
          const profile = profileMap.get(item.user_id);
          // Exclude business accounts
          if (!profile || profile.user_type === 'business') return null;

          const isFamilyMember = !!item.family_member_id;
          const ownerNickname = profile.nickname || profile.full_name || 'Utente';
          let nickname = ownerNickname;
          let displayLabel = ownerNickname;

          if (isFamilyMember && item.family_member_id) {
            const famName = familyMap.get(item.family_member_id);
            nickname = famName || 'Membro famiglia';
            displayLabel = `${nickname} (membro di ${ownerNickname})`;
          }

          return {
            user_id: item.user_id,
            family_member_id: item.family_member_id,
            nickname,
            display_label: displayLabel,
            email: isFamilyMember ? '' : (profile.email || ''),
            user_type: profile.user_type,
            total_points: item.total_points || 0,
            reviews_count: item.reviews_count || 0,
            ads_count: item.ads_count || 0,
            ads_posted_count: item.ads_posted_count || 0,
            job_postings_count: item.job_postings_count || 0,
            referrals_count: item.referrals_count || 0,
            businesses_added_count: item.businesses_added_count || 0,
            auctions_count: item.auctions_count || 0,
            is_family_member: isFamilyMember,
          } satisfies LeaderboardEntry;
        })
        .filter((e): e is LeaderboardEntry => e !== null);

      setLeaderboard(enriched);
    } catch (err) {
      console.error('Error loading leaderboard:', err);
    } finally {
      setLoading(false);
    }
  };

  const getRankStyle = (index: number) => {
    if (index === 0) return 'bg-gradient-to-r from-yellow-400 to-yellow-500 text-white';
    if (index === 1) return 'bg-gradient-to-r from-gray-300 to-gray-400 text-gray-800';
    if (index === 2) return 'bg-gradient-to-r from-orange-400 to-orange-500 text-white';
    return 'bg-gray-100 text-gray-700';
  };

  if (loading) {
    return (
      <div className="text-center py-12">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto" />
      </div>
    );
  }

  return (
    <div className="space-y-4">

      {/* ── Hero header ── */}
      <div className="relative overflow-hidden bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900 rounded-2xl p-6">
        {/* dot overlay */}
        <div
          className="absolute inset-0 opacity-5"
          style={{
            backgroundImage: 'radial-gradient(circle at 1px 1px, white 1px, transparent 0)',
            backgroundSize: '28px 28px',
          }}
        />

        <div className="relative z-10">
          {/* Title row */}
          <div className="flex items-start justify-between gap-4 mb-4">
            <div>
              <p className="text-gray-400 uppercase text-xs font-semibold tracking-widest mb-1">Classifica Utenti</p>
              <h2 className="text-2xl font-bold text-white">Leaderboard</h2>
            </div>
            {/* Count chip */}
            <span className="bg-white/10 text-white rounded-xl px-3 py-1 text-sm font-medium self-start mt-1">
              {filtered.length} utenti
            </span>
          </div>

          {/* Sort buttons */}
          <div className="flex flex-wrap gap-2">
            {SORT_OPTIONS.map(({ key, label, icon: Icon }) => (
              <button
                key={key}
                onClick={() => setSortBy(key)}
                className={`rounded-xl px-4 py-2 text-sm font-medium transition-all flex items-center gap-1.5 ${
                  sortBy === key
                    ? 'bg-white text-gray-900 shadow-sm'
                    : 'bg-white/10 text-gray-300 hover:bg-white/20'
                }`}
              >
                <Icon className="w-3.5 h-3.5" />
                {label}
              </button>
            ))}
          </div>
        </div>
      </div>

      {/* ── Search ── */}
      <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-4">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <input
              type="text"
              placeholder="Cerca per nickname..."
              value={searchNickname}
              onChange={e => setSearchNickname(e.target.value)}
              className="w-full pl-9 pr-4 py-2.5 bg-white rounded-xl border border-gray-200 text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>
          <div className="relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <input
              type="text"
              placeholder="Cerca per email..."
              value={searchEmail}
              onChange={e => setSearchEmail(e.target.value)}
              className="w-full pl-9 pr-4 py-2.5 bg-white rounded-xl border border-gray-200 text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>
        </div>
        {(searchNickname || searchEmail) && (
          <div className="mt-3 flex items-center justify-between">
            <p className="text-sm text-gray-500">{filtered.length} risultat{filtered.length === 1 ? 'o' : 'i'}</p>
            <button onClick={() => { setSearchNickname(''); setSearchEmail(''); }} className="text-sm text-blue-600 hover:text-blue-700 font-medium">
              Cancella filtri
            </button>
          </div>
        )}
      </div>

      {/* ── Leaderboard rows ── */}
      {filtered.length === 0 ? (
        <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-12 text-center">
          <div className="w-16 h-16 rounded-full bg-gray-100 flex items-center justify-center mx-auto mb-4">
            <Award className="w-8 h-8 text-gray-300" />
          </div>
          <p className="text-gray-500 font-medium">Nessun utente attivo</p>
        </div>
      ) : (
        <div className="overflow-x-auto">
          <table className="min-w-full">
            <thead>
              <tr>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase w-16">Pos.</th>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Utente</th>
                <th className="px-4 py-3 text-center text-xs font-semibold text-gray-500 uppercase">Punti</th>
                <th className="px-4 py-3 text-center text-xs font-semibold text-gray-500 uppercase">Recensioni</th>
                <th className="px-4 py-3 text-center text-xs font-semibold text-gray-500 uppercase">Annunci</th>
                <th className="px-4 py-3 text-center text-xs font-semibold text-gray-500 uppercase">Attivita'</th>
                <th className="px-4 py-3 text-center text-xs font-semibold text-gray-500 uppercase">Aste</th>
                <th className="px-4 py-3 text-center text-xs font-semibold text-gray-500 uppercase">Referral</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-50">
              {filtered.map((user, index) => {
                const isTop3 = index < 3;
                const top3Border = index === 0
                  ? 'border-l-4 border-l-yellow-400'
                  : index === 1
                  ? 'border-l-4 border-l-gray-400'
                  : 'border-l-4 border-l-orange-400';

                return (
                  <tr
                    key={`${user.user_id}-${user.family_member_id ?? 'main'}`}
                    className={`bg-white rounded-2xl border border-gray-100 shadow-sm hover:shadow-md transition-shadow ${isTop3 ? top3Border : ''}`}
                  >
                    {/* Rank */}
                    <td className="px-4 py-4">
                      <div className={`w-9 h-9 rounded-full flex items-center justify-center font-bold text-sm ${getRankStyle(index)}`}>
                        {index < 3 ? <Award className="w-4 h-4" /> : index + 1}
                      </div>
                    </td>

                    {/* User */}
                    <td className="px-4 py-4">
                      <div className="flex items-center gap-3">
                        <div className={`w-9 h-9 rounded-full flex items-center justify-center text-white text-sm font-bold flex-shrink-0 ${
                          user.is_family_member
                            ? 'bg-gradient-to-br from-green-400 to-green-600'
                            : 'bg-gradient-to-br from-blue-400 to-blue-600'
                        }`}>
                          {user.is_family_member
                            ? <Users className="w-4 h-4" />
                            : user.nickname.charAt(0).toUpperCase()
                          }
                        </div>
                        <div className="min-w-0">
                          <div className="flex items-center gap-1.5 flex-wrap">
                            <span className="text-sm font-semibold text-gray-900">{user.nickname}</span>
                            {user.is_family_member && (
                              <span className="text-xs bg-green-100 text-green-700 px-1.5 py-0.5 rounded-full font-medium">membro famiglia</span>
                            )}
                            {index < 3 && (
                              <Award className={`w-3.5 h-3.5 ${index === 0 ? 'text-yellow-500' : index === 1 ? 'text-gray-400' : 'text-orange-500'}`} />
                            )}
                          </div>
                          {user.is_family_member ? (
                            <div className="text-xs text-gray-400 truncate">{user.display_label.split('(membro di ')[1]?.replace(')', '') ?? ''}</div>
                          ) : (
                            <div className="text-xs text-gray-500 truncate">{user.email}</div>
                          )}
                        </div>
                      </div>
                    </td>

                    {/* Points */}
                    <td className="px-4 py-4 text-center">
                      <span className="px-2.5 py-1 bg-blue-100 text-blue-700 rounded-full font-bold text-sm">
                        {user.total_points.toLocaleString()}
                      </span>
                    </td>

                    {/* Reviews */}
                    <td className="px-4 py-4 text-center">
                      <div className="flex items-center justify-center gap-1">
                        <Star className="w-3.5 h-3.5 text-yellow-500" />
                        <span className="font-semibold text-gray-900 text-sm">{user.reviews_count}</span>
                      </div>
                    </td>

                    {/* Ads */}
                    <td className="px-4 py-4 text-center">
                      <div className="flex items-center justify-center gap-1">
                        <Tag className="w-3.5 h-3.5 text-pink-500" />
                        <span className="font-semibold text-gray-900 text-sm">{user.ads_posted_count || user.ads_count}</span>
                      </div>
                    </td>

                    {/* Businesses */}
                    <td className="px-4 py-4 text-center">
                      <div className="flex items-center justify-center gap-1">
                        <Building2 className="w-3.5 h-3.5 text-green-500" />
                        <span className="font-semibold text-gray-900 text-sm">{user.businesses_added_count}</span>
                      </div>
                    </td>

                    {/* Auctions */}
                    <td className="px-4 py-4 text-center">
                      <div className="flex items-center justify-center gap-1">
                        <Gavel className="w-3.5 h-3.5 text-orange-500" />
                        <span className="font-semibold text-gray-900 text-sm">{user.auctions_count}</span>
                      </div>
                    </td>

                    {/* Referrals */}
                    <td className="px-4 py-4 text-center">
                      <div className="flex items-center justify-center gap-1">
                        <MessageCircle className="w-3.5 h-3.5 text-gray-400" />
                        <span className="font-semibold text-gray-900 text-sm">{user.referrals_count}</span>
                      </div>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
