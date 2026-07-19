import { useState, useEffect } from 'react';
import { Trophy, Medal, Award, Star, Gift, Activity } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import { useLanguage } from '../contexts/LanguageContext';
import { ActivityFeed } from '../components/activity/ActivityFeed';

interface LeaderboardUser {
  id: string;
  full_name: string;
  avatar_url: string | null;
  points: number;
  reviews_count: number;
  rank: number;
  is_family_member?: boolean;
}

interface Reward {
  id: string;
  title: string;
  description: string;
  points_required: number;
  icon: string;
  color: string;
}

export function LeaderboardPage() {
  const { profile, activeProfile } = useAuth();
  const { t } = useLanguage();
  const [userRank, setUserRank] = useState<LeaderboardUser | null>(null);
  const [topUsers, setTopUsers] = useState<LeaderboardUser[]>([]);
  const [rewards, setRewards] = useState<Reward[]>([]);
  const [loading, setLoading] = useState(true);
  const [activeTab, setActiveTab] = useState<'leaderboard' | 'rewards' | 'my_activities'>('leaderboard');
  const userTypeFilter = 'all';

  useEffect(() => {
    loadLeaderboard();
    loadRewards();
  }, [profile, activeProfile, userTypeFilter]);

  const loadLeaderboard = async () => {
    if (!profile) return;

    try {
      setLoading(true);

      // Business users don't participate in the leaderboard
      if (profile.user_type === 'business') {
        setUserRank(null);
        setLoading(false);
        return;
      }

      // Carica i top 20 utenti basati sul filtro
      await loadTopUsers();

      // Calcola il rank globale: conta quante righe di user_activity hanno più punti.
      // Include sia account owner (family_member_id IS NULL) che family members separatamente,
      // ma esclude gli utenti business.
      const calcRank = async (points: number): Promise<number> => {
        // Count owner rows with more points (non-business users)
        // Note: subquery filtering not supported by PostgREST - business users filtered client-side
        const { count: ownerCount } = await supabase
          .from('user_activity')
          .select('user_id', { count: 'exact', head: true })
          .gt('total_points', points)
          .is('family_member_id', null);

        // Count family member rows with more points
        const { count: familyCount } = await supabase
          .from('user_activity')
          .select('family_member_id', { count: 'exact', head: true })
          .gt('total_points', points)
          .not('family_member_id', 'is', null);

        return (ownerCount || 0) + (familyCount || 0) + 1;
      };

      // Se è un membro della famiglia, carica i suoi dati da user_activity
      if (activeProfile?.isOwner === false && activeProfile?.id) {
        const { data: activityData } = await supabase
          .from('user_activity')
          .select('total_points, reviews_count')
          .eq('family_member_id', activeProfile.id)
          .maybeSingle();

        const totalPoints = activityData?.total_points || 0;
        const reviewsCount = activityData?.reviews_count || 0;
        const rank = await calcRank(totalPoints);

        const { data: memberData } = await supabase
          .from('customer_family_members')
          .select('first_name, last_name, nickname, avatar_url')
          .eq('id', activeProfile.id)
          .maybeSingle();

        setUserRank({
          id: activeProfile.id,
          full_name: memberData
            ? (memberData.nickname || `${memberData.first_name} ${memberData.last_name}`)
            : activeProfile.name || 'Membro Famiglia',
          avatar_url: memberData?.avatar_url || null,
          points: totalPoints,
          reviews_count: reviewsCount,
          rank,
          is_family_member: true,
        });
      } else {
        // Utente principale
        const { data: activityData } = await supabase
          .from('user_activity')
          .select('total_points, reviews_count')
          .eq('user_id', profile.id)
          .is('family_member_id', null)
          .maybeSingle();

        const totalPoints = activityData?.total_points || 0;
        const reviewsCount = activityData?.reviews_count || 0;
        const rank = await calcRank(totalPoints);

        setUserRank({
          id: profile.id,
          full_name: profile.nickname || profile.full_name,
          avatar_url: profile.avatar_url,
          points: totalPoints,
          reviews_count: reviewsCount,
          rank,
          is_family_member: false,
        });
      }
    } catch (error) {
      console.error('Error loading leaderboard:', error);
    } finally {
      setLoading(false);
    }
  };

  const loadTopUsers = async () => {
    try {
      const entries: LeaderboardUser[] = [];

      // Query 1: customer account owners (family_member_id IS NULL, not business, not admin)
      const { data: usersData } = await supabase
        .from('user_activity')
        .select('user_id, total_points, reviews_count, profiles(full_name, nickname, avatar_url, user_type)')
        .is('family_member_id', null)
        .order('total_points', { ascending: false })
        .limit(200);

      for (const item of (usersData || []) as any[]) {
        if (!item.profiles) continue;
        if (item.profiles.user_type !== 'customer') continue;
        entries.push({
          id: item.user_id,
          full_name: item.profiles.nickname || item.profiles.full_name,
          avatar_url: item.profiles.avatar_url,
          points: item.total_points || 0,
          reviews_count: item.reviews_count || 0,
          rank: 0,
          is_family_member: false,
        });
      }

      // Query 2: family members (family_member_id IS NOT NULL)
      if (userTypeFilter === 'all') {
        const { data: familyData } = await supabase
          .from('user_activity')
          .select('family_member_id, total_points, reviews_count')
          .not('family_member_id', 'is', null)
          .order('total_points', { ascending: false })
          .limit(200);

        if (familyData && familyData.length > 0) {
          const familyIds = familyData.map((r: any) => r.family_member_id);
          const { data: membersData } = await supabase
            .from('customer_family_members')
            .select('id, first_name, last_name, nickname, avatar_url')
            .in('id', familyIds);

          const membersMap = new Map((membersData || []).map((m: any) => [m.id, m]));

          for (const item of familyData as any[]) {
            const member = membersMap.get(item.family_member_id);
            if (!member) continue;
            entries.push({
              id: item.family_member_id,
              full_name: member.nickname || `${member.first_name} ${member.last_name}`,
              avatar_url: member.avatar_url,
              points: item.total_points || 0,
              reviews_count: item.reviews_count || 0,
              rank: 0,
              is_family_member: true,
            });
          }
        }
      }

      entries.sort((a, b) => b.points - a.points);

      const leaderboard = entries.slice(0, 20).map((item, index) => ({
        ...item,
        rank: index + 1,
      }));

      setTopUsers(leaderboard);
    } catch (error) {
      console.error('Error loading top users:', error);
    }
  };

  const loadRewards = async () => {
    try {
      const { data, error } = await supabase
        .from('rewards')
        .select('*')
        .order('points_required');

      if (error) throw error;

      setRewards(data || []);
    } catch (error) {
      console.error('Error loading rewards:', error);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <div className="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mb-4"></div>
          <p className="text-gray-600">{t('leaderboard.loading')}</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 py-12">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12">
          <div className="flex items-center justify-center gap-3 mb-4">
            <Trophy className="w-12 h-12 text-yellow-500" />
            <h1 className="text-4xl font-bold text-gray-900">
              {t('leaderboard.title')}
            </h1>
          </div>
          <p className="text-xl text-gray-600 max-w-2xl mx-auto">
            {t('leaderboard.subtitle')}
          </p>
        </div>

        <div className="flex flex-col items-center gap-4 mb-8">
          <div className="inline-flex rounded-lg border border-gray-200 bg-white p-1 flex-wrap gap-1">
            <button
              onClick={() => setActiveTab('leaderboard')}
              className={`px-5 py-2 rounded-lg font-medium transition-all flex items-center gap-2 ${
                activeTab === 'leaderboard'
                  ? 'bg-blue-600 text-white'
                  : 'text-gray-600 hover:text-gray-900'
              }`}
            >
              <Trophy className="w-4 h-4" />
              {t('leaderboard.tab.leaderboard')}
            </button>
            <button
              onClick={() => setActiveTab('my_activities')}
              className={`px-5 py-2 rounded-lg font-medium transition-all flex items-center gap-2 ${
                activeTab === 'my_activities'
                  ? 'bg-blue-600 text-white'
                  : 'text-gray-600 hover:text-gray-900'
              }`}
            >
              <Activity className="w-4 h-4" />
              Le Mie Attivita'
            </button>
            <button
              onClick={() => setActiveTab('rewards')}
              className={`px-5 py-2 rounded-lg font-medium transition-all flex items-center gap-2 ${
                activeTab === 'rewards'
                  ? 'bg-blue-600 text-white'
                  : 'text-gray-600 hover:text-gray-900'
              }`}
            >
              {t('leaderboard.tab.rewards')}
            </button>
          </div>
        </div>

        {activeTab === 'my_activities' ? (
          <div className="max-w-6xl mx-auto">
            <ActivityFeed />
          </div>
        ) : activeTab === 'leaderboard' ? (
          <>
            {userRank && (
              <div className="max-w-4xl mx-auto mb-8">
                <div className="bg-gradient-to-r from-blue-500 to-blue-600 rounded-xl shadow-lg p-6 text-white">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-4">
                      {userRank.avatar_url ? (
                        <img
                          src={userRank.avatar_url}
                          alt={userRank.full_name}
                          className="w-16 h-16 rounded-full border-4 border-white"
                        />
                      ) : (
                        <div className="w-16 h-16 rounded-full bg-white text-blue-600 flex items-center justify-center text-2xl font-bold border-4 border-white">
                          {userRank.full_name.charAt(0)}
                        </div>
                      )}
                      <div>
                        <p className="text-sm opacity-90">{t('leaderboard.yourPosition')}</p>
                        <p className="text-2xl font-bold">{userRank.full_name}</p>
                        <div className="flex items-center gap-4 mt-1">
                          <span className="text-sm">#{userRank.rank}</span>
                          <span className="text-sm">{userRank.points} {t('leaderboard.points')}</span>
                          <span className="text-sm">{userRank.reviews_count} {t('leaderboard.reviews')}</span>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            )}

            <div className="max-w-4xl mx-auto mb-6">
              <div className="bg-gradient-to-r from-yellow-50 to-orange-50 border-2 border-yellow-300 rounded-xl p-6">
                <div className="flex items-start gap-4">
                  <Trophy className="w-8 h-8 text-yellow-600 flex-shrink-0 mt-1" />
                  <div>
                    <h3 className="text-lg font-bold text-gray-900 mb-2">{t('leaderboard.prizesTitle')}</h3>
                    <p className="text-gray-700 text-sm leading-relaxed">
                      {t('leaderboard.prizesDescription')}
                    </p>
                  </div>
                </div>
              </div>
            </div>

            <div className="max-w-4xl mx-auto mb-8">
              <div className="flex items-center justify-between mb-6">
                <h2 className="text-2xl font-bold text-gray-900">{t('leaderboard.top20')}</h2>
              </div>

              <div className="space-y-3">
                {topUsers.map((user) => {
                  const getRankBg = (rank: number) => {
                    if (rank === 1) return 'bg-gradient-to-br from-yellow-50 to-yellow-100 border-yellow-400';
                    if (rank === 2) return 'bg-gradient-to-br from-gray-50 to-gray-100 border-gray-300';
                    if (rank === 3) return 'bg-gradient-to-br from-amber-50 to-amber-100 border-amber-400';
                    return 'bg-white border-gray-200';
                  };

                  const getRankIcon = (rank: number) => {
                    if (rank === 1) return <Trophy className="w-8 h-8 text-yellow-500" />;
                    if (rank === 2) return <Medal className="w-8 h-8 text-gray-400" />;
                    if (rank === 3) return <Medal className="w-8 h-8 text-amber-700" />;
                    return <span className="text-2xl font-bold text-gray-600">#{rank}</span>;
                  };

                  return (
                    <div
                      key={user.id}
                      className={`${getRankBg(user.rank)} border-2 rounded-xl p-4 transition-all hover:shadow-md`}
                    >
                      <div className="flex items-center gap-4">
                        <div className="flex-shrink-0">
                          {getRankIcon(user.rank)}
                        </div>
                        {user.avatar_url ? (
                          <img
                            src={user.avatar_url}
                            alt={user.full_name}
                            className="w-12 h-12 rounded-full"
                          />
                        ) : (
                          <div className="w-12 h-12 rounded-full bg-gray-200 flex items-center justify-center text-lg font-bold text-gray-600">
                            {user.full_name.charAt(0)}
                          </div>
                        )}
                        <div className="flex-1">
                          <div className="flex items-center gap-2 flex-wrap">
                            <p className="font-bold text-gray-900">{user.full_name}</p>
                            {user.is_family_member && (
                              <span className="text-xs bg-blue-100 text-blue-700 px-2 py-0.5 rounded-full font-medium">
                                Membro Famiglia
                              </span>
                            )}
                          </div>
                          <div className="flex items-center gap-4 text-sm text-gray-600">
                            <span>{user.points} {t('leaderboard.points')}</span>
                            <span>{user.reviews_count} {t('leaderboard.reviews')}</span>
                          </div>
                        </div>
                      </div>
                    </div>
                  );
                })}
              </div>

              {topUsers.length === 0 && (
                <div className="text-center py-12 bg-white rounded-xl border-2 border-gray-200">
                  <Trophy className="w-16 h-16 text-gray-300 mx-auto mb-4" />
                  <p className="text-gray-600">{t('leaderboard.noUsers')}</p>
                </div>
              )}
            </div>

            <div className="max-w-4xl mx-auto">
              {profile?.user_type === 'customer' && (
                <div className="mt-8 bg-blue-50 border-2 border-blue-200 rounded-xl p-6">
                  <h3 className="text-lg font-bold text-gray-900 mb-3">Come Guadagnare Punti</h3>
                  <p className="text-sm text-gray-600 mb-4">
                    La classifica è riservata agli utenti privati e ai loro familiari.
                  </p>
                  <ul className="space-y-3 text-gray-700">
                    <li className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-full bg-green-100 flex items-center justify-center flex-shrink-0">
                        <Star className="w-5 h-5 text-green-600" />
                      </div>
                      <div>
                        <span className="font-bold text-gray-900">+50 punti</span>
                        <span className="text-gray-600"> — recensione con prova documentale</span>
                      </div>
                    </li>
                    <li className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-full bg-yellow-100 flex items-center justify-center flex-shrink-0">
                        <Award className="w-5 h-5 text-yellow-600" />
                      </div>
                      <div>
                        <span className="font-bold text-gray-900">+30 punti</span>
                        <span className="text-gray-600"> — porta un amico che si abbona</span>
                      </div>
                    </li>
                    <li className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center flex-shrink-0">
                        <Star className="w-5 h-5 text-blue-600" />
                      </div>
                      <div>
                        <span className="font-bold text-gray-900">+25 punti</span>
                        <span className="text-gray-600"> — recensione senza prova documentale</span>
                      </div>
                    </li>
                    <li className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-full bg-emerald-100 flex items-center justify-center flex-shrink-0">
                        <Award className="w-5 h-5 text-emerald-600" />
                      </div>
                      <div>
                        <span className="font-bold text-gray-900">+25 punti</span>
                        <span className="text-gray-600"> — aggiunta attività con contatto (email, telefono o sito)</span>
                      </div>
                    </li>
                    <li className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-full bg-orange-100 flex items-center justify-center flex-shrink-0">
                        <Award className="w-5 h-5 text-orange-600" />
                      </div>
                      <div>
                        <span className="font-bold text-gray-900">+10 punti</span>
                        <span className="text-gray-600"> — aggiunta attività senza contatto (solo nome e indirizzo)</span>
                      </div>
                    </li>
                    <li className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-full bg-gray-100 flex items-center justify-center flex-shrink-0">
                        <Award className="w-5 h-5 text-gray-600" />
                      </div>
                      <div>
                        <span className="font-bold text-gray-900">+5 punti</span>
                        <span className="text-gray-600"> — annuncio pubblicato (vendita, regalo o cerco)</span>
                      </div>
                    </li>
                  </ul>

                  <div className="mt-4 bg-amber-50 border border-amber-300 rounded-lg p-4">
                    <p className="text-sm text-gray-700">
                      <strong>Nota:</strong> I punti per recensioni e attività vengono assegnati dopo l'approvazione dello staff. Ogni utente compete individualmente nella classifica, inclusi i membri della famiglia.
                    </p>
                  </div>
                </div>
              )}

              {profile?.user_type === 'business' && (
                <div className="bg-gray-50 border-2 border-gray-200 rounded-xl p-6">
                  <h3 className="text-lg font-bold text-gray-900 mb-3">Classifica Punti</h3>
                  <p className="text-gray-600 text-sm">
                    La classifica punti e' riservata agli utenti privati e ai loro familiari. Gli utenti business non partecipano al sistema punti.
                  </p>
                </div>
              )}

              {rewards.length > 0 && (
                <div className="mt-8">
                  <h3 className="text-2xl font-bold text-gray-900 mb-6">Badge Disponibili</h3>
                  <div className="grid md:grid-cols-2 gap-6">
                    {rewards.map((reward) => (
                      <div
                        key={reward.id}
                        className="bg-white rounded-xl shadow-lg p-6 border-2 border-gray-200 hover:border-blue-500 transition-all"
                      >
                        <div className="flex items-start gap-4">
                          <div className={`w-16 h-16 rounded-full flex items-center justify-center ${reward.color}`}>
                            {reward.icon === 'trophy' && <Trophy className="w-8 h-8" />}
                            {reward.icon === 'medal' && <Medal className="w-8 h-8" />}
                            {reward.icon === 'award' && <Award className="w-8 h-8" />}
                            {reward.icon === 'gift' && <Gift className="w-8 h-8" />}
                            {reward.icon === 'star' && <Star className="w-8 h-8" />}
                          </div>
                          <div className="flex-1">
                            <h4 className="text-xl font-bold text-gray-900 mb-2">
                              {reward.title}
                            </h4>
                            <p className="text-gray-600 mb-4">
                              {reward.description}
                            </p>
                            <div className="flex items-center gap-2">
                              <span className="bg-blue-100 text-blue-700 text-sm font-semibold px-3 py-1 rounded-full">
                                {reward.points_required} punti richiesti
                              </span>
                            </div>
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </div>
          </>
        ) : (
          <div className="max-w-6xl mx-auto space-y-8">
            <div className="bg-gradient-to-br from-blue-50 to-blue-100 border-2 border-blue-200 rounded-xl p-12">
              <div className="flex items-center justify-center gap-3 mb-6">
                <Trophy className="w-16 h-16 text-blue-600" />
                <h3 className="text-3xl font-bold text-gray-900">
                  Premi per Utenti Privati
                </h3>
              </div>
              <p className="text-lg text-gray-700 max-w-2xl mx-auto leading-relaxed mb-6 text-center">
                I migliori 20 utenti privati dell'anno riceveranno fantastici premi in gift card.
              </p>
              <p className="text-gray-600 max-w-2xl mx-auto text-center mb-8">
                Continua a guadagnare punti scrivendo recensioni verificate con foto e dettagli.
                Maggiore è il tuo contributo alla community, maggiori saranno le tue possibilità di vincere!
              </p>
              <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-4 max-w-4xl mx-auto mb-8">
                <div className="bg-gradient-to-br from-yellow-100 to-yellow-200 rounded-lg p-6 shadow-lg border-2 border-yellow-400">
                  <Trophy className="w-12 h-12 mx-auto mb-3 text-yellow-600" />
                  <p className="font-bold text-gray-900 text-xl">1° Posto</p>
                  <p className="text-lg text-yellow-800 font-semibold mt-2">Gift card da 500€</p>
                </div>
                <div className="bg-gradient-to-br from-gray-100 to-gray-200 rounded-lg p-6 shadow-lg border-2 border-gray-400">
                  <Medal className="w-12 h-12 mx-auto mb-3 text-gray-600" />
                  <p className="font-bold text-gray-900 text-xl">2° Posto</p>
                  <p className="text-lg text-gray-800 font-semibold mt-2">Gift card da 200€</p>
                </div>
                <div className="bg-gradient-to-br from-amber-100 to-amber-200 rounded-lg p-6 shadow-lg border-2 border-amber-400">
                  <Medal className="w-12 h-12 mx-auto mb-3 text-amber-700" />
                  <p className="font-bold text-gray-900 text-xl">3° Posto</p>
                  <p className="text-lg text-amber-800 font-semibold mt-2">Gift card da 150€</p>
                </div>
                <div className="bg-white rounded-lg p-6 shadow-md border-2 border-blue-200">
                  <Award className="w-12 h-12 mx-auto mb-3 text-blue-600" />
                  <p className="font-bold text-gray-900 text-lg">4° - 5° Posto</p>
                  <p className="text-sm text-gray-700 font-semibold mt-2">Gift card da 100€</p>
                </div>
                <div className="bg-white rounded-lg p-6 shadow-md border-2 border-green-200">
                  <Award className="w-12 h-12 mx-auto mb-3 text-green-600" />
                  <p className="font-bold text-gray-900 text-lg">6° - 10° Posto</p>
                  <p className="text-sm text-gray-700 font-semibold mt-2">Gift card da 75€</p>
                </div>
                <div className="bg-white rounded-lg p-6 shadow-md border-2 border-orange-200">
                  <Award className="w-12 h-12 mx-auto mb-3 text-orange-600" />
                  <p className="font-bold text-gray-900 text-lg">11° - 20° Posto</p>
                  <p className="text-sm text-gray-700 font-semibold mt-2">Gift card da 50€</p>
                </div>
              </div>
              <div className="bg-white border-2 border-blue-200 rounded-lg p-6 max-w-3xl mx-auto">
                <div className="flex items-start gap-3">
                  <Gift className="w-6 h-6 text-blue-600 flex-shrink-0 mt-1" />
                  <div>
                    <p className="text-sm text-gray-700 font-medium">
                      Le gift card potranno essere scelte tra una lista di brand e servizi che verrà pubblicata in seguito.
                    </p>
                  </div>
                </div>
              </div>
            </div>

            <div className="bg-gradient-to-br from-green-50 to-green-100 border-2 border-green-200 rounded-xl p-12">
              <div className="flex items-center justify-center gap-3 mb-6">
                <Trophy className="w-16 h-16 text-green-600" />
                <h3 className="text-3xl font-bold text-gray-900">
                  Premi per Professionisti
                </h3>
              </div>
              <p className="text-lg text-gray-700 max-w-2xl mx-auto leading-relaxed mb-6 text-center">
                I migliori 20 professionisti dell'anno riceveranno riconoscimenti speciali per la loro eccellenza nel servizio clienti.
              </p>
              <p className="text-gray-600 max-w-2xl mx-auto text-center mb-8">
                Ricevi recensioni positive e scala la classifica per ottenere visibilità e premi esclusivi!
              </p>
              <div className="grid md:grid-cols-3 gap-4 max-w-2xl mx-auto">
                <div className="bg-white rounded-lg p-6 shadow-md">
                  <Trophy className="w-12 h-12 mx-auto mb-3 text-yellow-500" />
                  <p className="font-bold text-gray-900 text-lg">1° Posto</p>
                  <p className="text-sm text-gray-600 mt-2">Certificato Eccellenza + Visibilità Premium</p>
                </div>
                <div className="bg-white rounded-lg p-6 shadow-md">
                  <Medal className="w-12 h-12 mx-auto mb-3 text-gray-400" />
                  <p className="font-bold text-gray-900 text-lg">2° - 5° Posto</p>
                  <p className="text-sm text-gray-600 mt-2">Badge Qualità + Promozione Premium</p>
                </div>
                <div className="bg-white rounded-lg p-6 shadow-md">
                  <Award className="w-12 h-12 mx-auto mb-3 text-amber-700" />
                  <p className="font-bold text-gray-900 text-lg">6° - 20° Posto</p>
                  <p className="text-sm text-gray-600 mt-2">Badge Riconoscimento + Visibilità Extra</p>
                </div>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
