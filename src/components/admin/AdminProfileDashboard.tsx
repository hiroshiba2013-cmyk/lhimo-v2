import { useState, useEffect, useRef } from 'react';
import { User, Calendar, Mail, Shield, Clock, Activity, CheckCircle, MessageSquare, Star, Tag, Briefcase, MapPin, Camera, Upload } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useToast } from '../common/Toast';

interface AdminProfileData {
  id: string;
  full_name: string;
  email: string;
  user_type: string;
  created_at: string;
  nickname: string | null;
  fiscal_code: string | null;
  phone: string | null;
}

interface AdminData {
  user_id: string;
  avatar_url: string | null;
  nickname: string | null;
}

interface AdminLoginLog {
  id: string;
  login_time: string;
  ip_address: string | null;
  user_agent: string | null;
}

interface AdminActivity {
  reviews_approved: number;
  reviews_rejected: number;
  businesses_verified: number;
  reports_handled: number;
  ads_moderated: number;
  users_managed: number;
}

interface Props {
  adminId: string;
}

export function AdminProfileDashboard({ adminId }: Props) {
  const { showToast } = useToast();
  const [profileData, setProfileData] = useState<AdminProfileData | null>(null);
  const [adminData, setAdminData] = useState<AdminData | null>(null);
  const [loginLogs, setLoginLogs] = useState<AdminLoginLog[]>([]);
  const [activity, setActivity] = useState<AdminActivity>({
    reviews_approved: 0,
    reviews_rejected: 0,
    businesses_verified: 0,
    reports_handled: 0,
    ads_moderated: 0,
    users_managed: 0,
  });
  const [loading, setLoading] = useState(true);
  const [uploading, setUploading] = useState(false);
  const [editingNickname, setEditingNickname] = useState(false);
  const [newNickname, setNewNickname] = useState('');
  const fileInputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    loadAdminData();
  }, [adminId]);

  const loadAdminData = async () => {
    try {
      setLoading(true);

      const [profileResult, adminResult, logsResult, activityResult] = await Promise.all([
        supabase
          .from('profiles')
          .select('*')
          .eq('id', adminId)
          .single(),

        supabase
          .from('admins')
          .select('*')
          .eq('user_id', adminId)
          .maybeSingle(),

        supabase
          .from('admin_login_logs')
          .select('*')
          .eq('admin_id', adminId)
          .order('login_time', { ascending: false })
          .limit(10),

        loadActivityStats(adminId),
      ]);

      if (profileResult.data) {
        setProfileData(profileResult.data);
      }

      if (adminResult.data) {
        setAdminData(adminResult.data);
        setNewNickname(adminResult.data.nickname || '');
      }

      if (logsResult.data) {
        setLoginLogs(logsResult.data);
      }

      setActivity(activityResult);
    } catch (error) {
      console.error('Error loading admin data:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleAvatarUpload = async (event: React.ChangeEvent<HTMLInputElement>) => {
    try {
      const file = event.target.files?.[0];
      if (!file) return;

      if (!file.type.startsWith('image/')) {
        showToast('Seleziona un file immagine valido', 'info');
        return;
      }

      if (file.size > 5 * 1024 * 1024) {
        showToast('Il file deve essere inferiore a 5MB', 'info');
        return;
      }

      setUploading(true);

      const fileExt = file.name.split('.').pop();
      const fileName = `${adminId}/${adminId}-${Date.now()}.${fileExt}`;

      const { error: uploadError } = await supabase.storage
        .from('avatars')
        .upload(fileName, file, { upsert: true });

      if (uploadError) throw uploadError;

      const { data: { publicUrl } } = supabase.storage
        .from('avatars')
        .getPublicUrl(fileName);

      const { error: updateError } = await supabase
        .from('admins')
        .update({ avatar_url: publicUrl })
        .eq('user_id', adminId);

      if (updateError) throw updateError;

      setAdminData(prev => prev ? { ...prev, avatar_url: publicUrl } : null);
      showToast('Avatar aggiornato con successo!', 'success');
    } catch (error) {
      console.error('Error uploading avatar:', error);
      showToast('Errore durante il caricamento dell\'avatar', 'error');
    } finally {
      setUploading(false);
    }
  };

  const handleNicknameUpdate = async () => {
    if (!newNickname.trim()) {
      showToast('Inserisci un nickname valido', 'info');
      return;
    }

    try {
      const { error } = await supabase
        .from('admins')
        .update({ nickname: newNickname.trim() })
        .eq('user_id', adminId);

      if (error) throw error;

      setAdminData(prev => prev ? { ...prev, nickname: newNickname.trim() } : null);
      setEditingNickname(false);
      showToast('Nickname aggiornato con successo!', 'success');
    } catch (error) {
      console.error('Error updating nickname:', error);
      showToast('Errore durante l\'aggiornamento del nickname', 'error');
    }
  };

  const loadActivityStats = async (adminId: string): Promise<AdminActivity> => {
    const [
      reviewsApproved,
      reviewsRejected,
      businessesVerified,
      reportsHandled,
      adsModerated,
      usersManaged,
    ] = await Promise.all([
      supabase
        .from('activity_logs')
        .select('id', { count: 'exact', head: true })
        .eq('user_id', adminId)
        .eq('activity_type', 'review_approved'),

      supabase
        .from('activity_logs')
        .select('id', { count: 'exact', head: true })
        .eq('user_id', adminId)
        .eq('activity_type', 'review_rejected'),

      supabase
        .from('registered_businesses')
        .select('id', { count: 'exact', head: true })
        .eq('verified', true),

      supabase
        .from('reports')
        .select('id', { count: 'exact', head: true })
        .in('status', ['resolved', 'rejected']),

      supabase
        .from('classified_ads')
        .select('id', { count: 'exact', head: true }),

      supabase
        .from('profiles')
        .select('id', { count: 'exact', head: true }),
    ]);

    return {
      reviews_approved: reviewsApproved.count || 0,
      reviews_rejected: reviewsRejected.count || 0,
      businesses_verified: businessesVerified.count || 0,
      reports_handled: reportsHandled.count || 0,
      ads_moderated: adsModerated.count || 0,
      users_managed: usersManaged.count || 0,
    };
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center py-12">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  if (!profileData) {
    return (
      <div className="text-center py-12">
        <p className="text-gray-600">Impossibile caricare i dati del profilo</p>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Hero profile card */}
      <div className="relative overflow-hidden bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900 rounded-2xl p-8">
        {/* Dot overlay */}
        <div
          className="absolute inset-0 opacity-5"
          style={{
            backgroundImage: 'radial-gradient(circle, #fff 1px, transparent 1px)',
            backgroundSize: '20px 20px',
          }}
        />
        <div className="relative z-10 flex flex-col sm:flex-row items-start sm:items-center gap-6">
          {/* Avatar */}
          <div className="relative flex-shrink-0">
            <div className="w-24 h-24 rounded-full overflow-hidden border-4 border-white/20">
              {adminData?.avatar_url ? (
                <img
                  src={adminData.avatar_url}
                  alt="Avatar Admin"
                  className="w-full h-full object-cover"
                />
              ) : (
                <div className="w-full h-full flex items-center justify-center bg-white/10">
                  <User className="w-12 h-12 text-white/60" />
                </div>
              )}
            </div>
            <button
              onClick={() => fileInputRef.current?.click()}
              disabled={uploading}
              className="absolute bottom-0 right-0 p-1.5 bg-white text-gray-800 rounded-full shadow-lg hover:bg-gray-100 transition-colors disabled:opacity-50"
              title="Cambia Avatar"
            >
              {uploading ? (
                <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-gray-800"></div>
              ) : (
                <Camera className="w-4 h-4" />
              )}
            </button>
            <input
              ref={fileInputRef}
              type="file"
              accept="image/*"
              onChange={handleAvatarUpload}
              className="hidden"
            />
          </div>

          {/* Name / email / role */}
          <div className="flex-1 min-w-0">
            <div className="flex flex-wrap items-center gap-3 mb-1">
              <h2 className="text-2xl font-bold text-white truncate">{profileData.full_name}</h2>
              <span className="bg-white/10 text-white rounded-full px-3 py-1 text-xs font-semibold border border-white/20">
                Amministratore
              </span>
            </div>
            <p className="text-gray-400 text-sm">{profileData.email}</p>
            {adminData?.nickname && (
              <p className="text-gray-400 text-sm mt-0.5">@{adminData.nickname}</p>
            )}
          </div>

          {/* Nickname edit (inline, hero context) */}
          <div className="flex-shrink-0">
            {editingNickname ? (
              <div className="flex items-center gap-2">
                <input
                  type="text"
                  value={newNickname}
                  onChange={(e) => setNewNickname(e.target.value)}
                  placeholder="Inserisci nickname"
                  className="px-3 py-1.5 rounded-xl border border-gray-200 bg-white text-gray-900 focus:ring-2 focus:ring-gray-400 focus:border-transparent text-sm"
                />
                <button
                  onClick={handleNicknameUpdate}
                  className="px-3 py-1.5 bg-green-500 text-white rounded-lg hover:bg-green-600 transition-colors text-sm font-medium"
                >
                  Salva
                </button>
                <button
                  onClick={() => {
                    setEditingNickname(false);
                    setNewNickname(adminData?.nickname || '');
                  }}
                  className="px-3 py-1.5 bg-white/10 text-white rounded-lg hover:bg-white/20 transition-colors text-sm font-medium"
                >
                  Annulla
                </button>
              </div>
            ) : (
              <button
                onClick={() => setEditingNickname(true)}
                className="px-4 py-2 bg-white/10 text-white rounded-xl hover:bg-white/20 transition-colors text-sm font-medium border border-white/20"
              >
                Modifica nickname
              </button>
            )}
          </div>
        </div>
      </div>

      {/* Stats grid */}
      <div>
        <h3 className="text-lg font-bold text-gray-900 mb-4">Attività Svolte</h3>
        <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
          <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
            <div className="flex items-center gap-3 mb-2">
              <div className="p-2 bg-green-50 rounded-lg">
                <CheckCircle className="w-5 h-5 text-green-600" />
              </div>
              <h4 className="font-semibold text-gray-900 text-sm">Recensioni Approvate</h4>
            </div>
            <p className="text-3xl font-bold text-green-600">{activity.reviews_approved}</p>
          </div>

          <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
            <div className="flex items-center gap-3 mb-2">
              <div className="p-2 bg-red-50 rounded-lg">
                <MessageSquare className="w-5 h-5 text-red-600" />
              </div>
              <h4 className="font-semibold text-gray-900 text-sm">Recensioni Rifiutate</h4>
            </div>
            <p className="text-3xl font-bold text-red-600">{activity.reviews_rejected}</p>
          </div>

          <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
            <div className="flex items-center gap-3 mb-2">
              <div className="p-2 bg-blue-50 rounded-lg">
                <Star className="w-5 h-5 text-blue-600" />
              </div>
              <h4 className="font-semibold text-gray-900 text-sm">Attività Verificate</h4>
            </div>
            <p className="text-3xl font-bold text-blue-600">{activity.businesses_verified}</p>
          </div>

          <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
            <div className="flex items-center gap-3 mb-2">
              <div className="p-2 bg-yellow-50 rounded-lg">
                <MapPin className="w-5 h-5 text-yellow-600" />
              </div>
              <h4 className="font-semibold text-gray-900 text-sm">Segnalazioni Gestite</h4>
            </div>
            <p className="text-3xl font-bold text-yellow-600">{activity.reports_handled}</p>
          </div>

          <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
            <div className="flex items-center gap-3 mb-2">
              <div className="p-2 bg-pink-50 rounded-lg">
                <Tag className="w-5 h-5 text-pink-600" />
              </div>
              <h4 className="font-semibold text-gray-900 text-sm">Annunci Moderati</h4>
            </div>
            <p className="text-3xl font-bold text-pink-600">{activity.ads_moderated}</p>
          </div>

          <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
            <div className="flex items-center gap-3 mb-2">
              <div className="p-2 bg-teal-50 rounded-lg">
                <User className="w-5 h-5 text-teal-600" />
              </div>
              <h4 className="font-semibold text-gray-900 text-sm">Utenti Gestiti</h4>
            </div>
            <p className="text-3xl font-bold text-teal-600">{activity.users_managed}</p>
          </div>
        </div>
      </div>

      {/* Profile details */}
      <div>
        <h3 className="text-lg font-bold text-gray-900 mb-4">Dati di Iscrizione</h3>
        <div className="grid sm:grid-cols-2 gap-4">
          <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
            <div className="flex items-center gap-2 text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">
              <Mail className="w-4 h-4" />
              Email
            </div>
            <p className="text-gray-900 font-medium">{profileData.email}</p>
          </div>

          <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
            <div className="flex items-center gap-2 text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">
              <Shield className="w-4 h-4" />
              Ruolo
            </div>
            <p className="text-gray-900 font-medium">Amministratore</p>
          </div>

          <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
            <div className="flex items-center gap-2 text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">
              <Calendar className="w-4 h-4" />
              Data Iscrizione
            </div>
            <p className="text-gray-900 font-medium">
              {new Date(profileData.created_at).toLocaleDateString('it-IT', {
                day: 'numeric',
                month: 'long',
                year: 'numeric',
              })}
            </p>
          </div>

          {profileData.fiscal_code && (
            <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
              <div className="flex items-center gap-2 text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1">
                <User className="w-4 h-4" />
                Codice Fiscale
              </div>
              <p className="text-gray-900 font-medium">{profileData.fiscal_code}</p>
            </div>
          )}
        </div>
      </div>

      {/* Login logs */}
      <div>
        <h3 className="text-lg font-bold text-gray-900 mb-4">Ultimi Accessi</h3>
        {loginLogs.length > 0 ? (
          <div>
            {loginLogs.map((log) => (
              <div
                key={log.id}
                className="bg-white rounded-2xl border border-gray-100 shadow-sm p-4 mb-3 flex items-center justify-between hover:shadow-md transition-shadow"
              >
                <div className="flex items-center gap-3">
                  <div className="p-2 bg-green-100 rounded-lg flex-shrink-0">
                    <Clock className="w-4 h-4 text-green-600" />
                  </div>
                  <div>
                    <p className="font-semibold text-gray-900">
                      {new Date(log.login_time).toLocaleString('it-IT', {
                        day: 'numeric',
                        month: 'long',
                        year: 'numeric',
                        hour: '2-digit',
                        minute: '2-digit',
                      })}
                    </p>
                    {log.ip_address && (
                      <p className="text-sm text-gray-600">IP: {log.ip_address}</p>
                    )}
                  </div>
                </div>
                <CheckCircle className="w-5 h-5 text-green-500 flex-shrink-0" />
              </div>
            ))}
          </div>
        ) : (
          <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-10 text-center">
            <div className="w-12 h-12 rounded-full bg-gray-100 flex items-center justify-center mx-auto mb-3">
              <Clock className="w-6 h-6 text-gray-400" />
            </div>
            <p className="text-gray-600">Nessun accesso registrato</p>
          </div>
        )}
      </div>
    </div>
  );
}
