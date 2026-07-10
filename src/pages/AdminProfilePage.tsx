import { useState, useEffect } from 'react';
import { User, Calendar, Mail, Shield, Clock, LogOut, CheckCircle, XCircle, FileEdit as Edit2, Save, X, Trash2, Upload } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import { DeleteAdminAccountButton } from '../components/admin/DeleteAdminAccountButton';
import { useToast } from '../components/common/Toast';

interface AdminProfileData {
  id: string;
  full_name: string;
  first_name: string | null;
  last_name: string | null;
  email: string;
  user_type: string;
  created_at: string;
  nickname: string | null;
  fiscal_code: string | null;
  phone: string | null;
  avatar: string | null;
}

interface AdminLoginLog {
  id: string;
  login_time: string;
  logout_time: string | null;
  ip_address: string | null;
  user_agent: string | null;
}

export function AdminProfilePage() {
  const { showToast } = useToast();
  const { user, profile } = useAuth();
  const [profileData, setProfileData] = useState<AdminProfileData | null>(null);
  const [loginLogs, setLoginLogs] = useState<AdminLoginLog[]>([]);
  const [loading, setLoading] = useState(true);
  const [isEditing, setIsEditing] = useState(false);
  const [editForm, setEditForm] = useState({
    first_name: '',
    last_name: '',
    nickname: '',
    fiscal_code: '',
    phone: '',
  });
  const [viewMode, setViewMode] = useState<'all' | 'login' | 'logout'>('all');
  const [checkingAdmin, setCheckingAdmin] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [uploading, setUploading] = useState(false);

  useEffect(() => {
    const checkAdminStatus = async () => {
      if (!user) {
        window.location.href = '/admin-login';
        return;
      }

      const { data: adminCheck } = await supabase
        .from('admins')
        .select('user_id')
        .eq('user_id', user.id)
        .maybeSingle();

      if (!adminCheck) {
        window.location.href = '/admin-login';
        return;
      }

      setIsAdmin(true);
      setCheckingAdmin(false);
    };

    checkAdminStatus();
  }, [user]);

  useEffect(() => {
    if (!checkingAdmin && isAdmin && user) {
      loadAdminData();
    }
  }, [checkingAdmin, isAdmin, user]);

  const loadAdminData = async () => {
    if (!user) return;

    try {
      setLoading(true);

      const [profileResult, adminResult, logsResult] = await Promise.all([
        supabase
          .from('profiles')
          .select('*')
          .eq('id', user.id)
          .single(),

        supabase
          .from('admins')
          .select('avatar_url')
          .eq('user_id', user.id)
          .single(),

        supabase
          .from('admin_login_logs')
          .select('*')
          .eq('admin_id', user.id)
          .order('login_time', { ascending: false })
          .limit(50),
      ]);

      if (profileResult.data) {
        setProfileData({
          ...profileResult.data,
          avatar: adminResult.data?.avatar_url || null,
        });
        setEditForm({
          first_name: profileResult.data.first_name || '',
          last_name: profileResult.data.last_name || '',
          nickname: profileResult.data.nickname || '',
          fiscal_code: profileResult.data.fiscal_code || '',
          phone: profileResult.data.phone || '',
        });
      }

      if (logsResult.data) {
        setLoginLogs(logsResult.data);
      }
    } catch (error) {
      console.error('Error loading admin data:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleSaveProfile = async () => {
    if (!user) return;

    try {
      const { error } = await supabase
        .from('profiles')
        .update({
          first_name: editForm.first_name,
          last_name: editForm.last_name,
          full_name: `${editForm.first_name} ${editForm.last_name}`,
          nickname: editForm.nickname || null,
          fiscal_code: editForm.fiscal_code || null,
          phone: editForm.phone || null,
        })
        .eq('id', user.id);

      if (error) throw error;

      showToast('Profilo aggiornato con successo!', 'success');
      setIsEditing(false);
      await loadAdminData();
    } catch (error: any) {
      console.error('Error updating profile:', error);
      showToast(`Errore: ${error.message}`, 'error');
    }
  };

  const handleAvatarUpload = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (!file || !user) return;

    if (!file.type.startsWith('image/')) {
      showToast('Per favore seleziona un file immagine', 'info');
      return;
    }

    if (file.size > 5 * 1024 * 1024) {
      showToast('Il file è troppo grande. Massimo 5MB', 'info');
      return;
    }

    try {
      setUploading(true);

      const fileExt = file.name.split('.').pop();
      const fileName = `${user.id}-${Date.now()}.${fileExt}`;
      const filePath = `${user.id}/${fileName}`;

      const { error: uploadError } = await supabase.storage
        .from('avatars')
        .upload(filePath, file, { upsert: true });

      if (uploadError) throw uploadError;

      const { data: { publicUrl } } = supabase.storage
        .from('avatars')
        .getPublicUrl(filePath);

      const { error: updateError } = await supabase
        .from('admins')
        .update({ avatar_url: publicUrl })
        .eq('user_id', user.id);

      if (updateError) throw updateError;

      await loadAdminData();
      showToast('Avatar aggiornato con successo!', 'success');
    } catch (error: any) {
      console.error('Error uploading avatar:', error);
      showToast(`Errore durante il caricamento: ${error.message}`, 'error');
    } finally {
      setUploading(false);
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

  const filteredLogs = loginLogs.filter((log) => {
    if (viewMode === 'all') return true;
    if (viewMode === 'login') return log.logout_time === null;
    if (viewMode === 'logout') return log.logout_time !== null;
    return true;
  });

  if (checkingAdmin || loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto mb-4"></div>
          <p className="text-gray-600">Caricamento...</p>
        </div>
      </div>
    );
  }

  if (!profileData) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center py-12">
          <p className="text-gray-600">Impossibile caricare i dati del profilo</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
      <div className="bg-white shadow-lg border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="p-2 bg-gradient-to-br from-blue-500 to-blue-600 rounded-xl shadow-lg">
                <User className="w-7 h-7 text-white" />
              </div>
              <div>
                <h1 className="text-2xl md:text-3xl font-bold text-gray-900">Dashboard Profilo Admin</h1>
                <p className="text-sm text-gray-600">{profileData.full_name}</p>
              </div>
            </div>
            <div className="flex items-center gap-3">
              <button
                onClick={() => window.location.href = '/admin-dashboard'}
                className="px-4 py-2 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition-colors font-medium"
              >
                Torna alla Dashboard
              </button>
              <button
                onClick={handleLogout}
                className="flex items-center gap-2 px-5 py-2.5 bg-gradient-to-r from-red-500 to-red-600 text-white rounded-xl hover:from-red-600 hover:to-red-700 transition-all duration-200 shadow-md hover:shadow-lg font-medium"
              >
                <LogOut className="w-4 h-4" />
                Esci
              </button>
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="space-y-6">
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
            <div className="px-6 py-5 border-b border-gray-200 bg-gradient-to-r from-blue-50 to-blue-100">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <div className="p-2 bg-blue-500 rounded-lg">
                    <User className="w-5 h-5 text-white" />
                  </div>
                  <div>
                    <h2 className="text-xl font-bold text-gray-900">Dati di Iscrizione</h2>
                    <p className="text-sm text-gray-600">Informazioni del profilo amministratore</p>
                  </div>
                </div>
                {!isEditing ? (
                  <button
                    onClick={() => setIsEditing(true)}
                    className="flex items-center gap-2 px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors"
                  >
                    <Edit2 className="w-4 h-4" />
                    Modifica
                  </button>
                ) : (
                  <div className="flex items-center gap-2">
                    <button
                      onClick={handleSaveProfile}
                      className="flex items-center gap-2 px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600 transition-colors"
                    >
                      <Save className="w-4 h-4" />
                      Salva
                    </button>
                    <button
                      onClick={() => {
                        setIsEditing(false);
                        setEditForm({
                          first_name: profileData.first_name || '',
                          last_name: profileData.last_name || '',
                          nickname: profileData.nickname || '',
                          fiscal_code: profileData.fiscal_code || '',
                          phone: profileData.phone || '',
                        });
                      }}
                      className="flex items-center gap-2 px-4 py-2 bg-gray-500 text-white rounded-lg hover:bg-gray-600 transition-colors"
                    >
                      <X className="w-4 h-4" />
                      Annulla
                    </button>
                  </div>
                )}
              </div>
            </div>
            <div className="p-6">
              <div className="mb-6">
                <div className="flex items-center gap-6">
                  <div className="relative">
                    {profileData.avatar ? (
                      <img
                        src={profileData.avatar}
                        alt={profileData.full_name}
                        className="w-24 h-24 rounded-full object-cover border-4 border-blue-100"
                      />
                    ) : (
                      <div className="w-24 h-24 rounded-full bg-gradient-to-br from-blue-500 to-blue-600 flex items-center justify-center border-4 border-blue-100">
                        <User className="w-12 h-12 text-white" />
                      </div>
                    )}
                    {uploading && (
                      <div className="absolute inset-0 bg-black bg-opacity-50 rounded-full flex items-center justify-center">
                        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-white"></div>
                      </div>
                    )}
                  </div>
                  <div className="flex-1">
                    <label className="block">
                      <span className="sr-only">Scegli avatar</span>
                      <input
                        type="file"
                        accept="image/*"
                        onChange={handleAvatarUpload}
                        disabled={uploading}
                        className="hidden"
                        id="avatar-upload"
                      />
                      <label
                        htmlFor="avatar-upload"
                        className={`inline-flex items-center gap-2 px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors cursor-pointer ${
                          uploading ? 'opacity-50 cursor-not-allowed' : ''
                        }`}
                      >
                        <Upload className="w-4 h-4" />
                        {uploading ? 'Caricamento...' : 'Carica Avatar'}
                      </label>
                    </label>
                    <p className="text-sm text-gray-500 mt-2">
                      Formato: JPG, PNG o GIF. Massimo 5MB
                    </p>
                  </div>
                </div>
              </div>

              <div className="grid md:grid-cols-2 gap-6">
                <div className="space-y-4">
                  <div className="flex items-start gap-3">
                    <div className="p-2 bg-blue-50 rounded-lg">
                      <Shield className="w-5 h-5 text-blue-600" />
                    </div>
                    <div className="flex-1">
                      <p className="text-sm text-gray-600 mb-1">Numero Utente (ID)</p>
                      <p className="text-sm font-mono font-semibold text-gray-900 bg-gray-100 px-3 py-2 rounded-lg border border-gray-300">
                        {profileData.id}
                      </p>
                    </div>
                  </div>

                  <div className="flex items-start gap-3">
                    <div className="p-2 bg-green-50 rounded-lg">
                      <User className="w-5 h-5 text-green-600" />
                    </div>
                    <div className="flex-1">
                      <p className="text-sm text-gray-600 mb-1">Nome</p>
                      {isEditing ? (
                        <input
                          type="text"
                          value={editForm.first_name}
                          onChange={(e) => setEditForm({ ...editForm, first_name: e.target.value })}
                          className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          placeholder="Nome"
                        />
                      ) : (
                        <p className="text-lg font-semibold text-gray-900">{profileData.first_name || 'Non specificato'}</p>
                      )}
                    </div>
                  </div>

                  <div className="flex items-start gap-3">
                    <div className="p-2 bg-green-50 rounded-lg">
                      <User className="w-5 h-5 text-green-600" />
                    </div>
                    <div className="flex-1">
                      <p className="text-sm text-gray-600 mb-1">Cognome</p>
                      {isEditing ? (
                        <input
                          type="text"
                          value={editForm.last_name}
                          onChange={(e) => setEditForm({ ...editForm, last_name: e.target.value })}
                          className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          placeholder="Cognome"
                        />
                      ) : (
                        <p className="text-lg font-semibold text-gray-900">{profileData.last_name || 'Non specificato'}</p>
                      )}
                    </div>
                  </div>

                  <div className="flex items-start gap-3">
                    <div className="p-2 bg-purple-50 rounded-lg">
                      <User className="w-5 h-5 text-purple-600" />
                    </div>
                    <div className="flex-1">
                      <p className="text-sm text-gray-600 mb-1">Nickname</p>
                      {isEditing ? (
                        <input
                          type="text"
                          value={editForm.nickname}
                          onChange={(e) => setEditForm({ ...editForm, nickname: e.target.value })}
                          className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          placeholder="Nickname (opzionale)"
                        />
                      ) : (
                        <p className="text-lg font-semibold text-gray-900">{profileData.nickname || 'Non specificato'}</p>
                      )}
                    </div>
                  </div>

                  <div className="flex items-start gap-3">
                    <div className="p-2 bg-yellow-50 rounded-lg">
                      <Mail className="w-5 h-5 text-yellow-600" />
                    </div>
                    <div className="flex-1">
                      <p className="text-sm text-gray-600 mb-1">Email</p>
                      <p className="text-lg font-semibold text-gray-900">{profileData.email}</p>
                    </div>
                  </div>
                </div>

                <div className="space-y-4">
                  <div className="flex items-start gap-3">
                    <div className="p-2 bg-orange-50 rounded-lg">
                      <User className="w-5 h-5 text-orange-600" />
                    </div>
                    <div className="flex-1">
                      <p className="text-sm text-gray-600 mb-1">Codice Fiscale</p>
                      {isEditing ? (
                        <input
                          type="text"
                          value={editForm.fiscal_code}
                          onChange={(e) => setEditForm({ ...editForm, fiscal_code: e.target.value.toUpperCase() })}
                          className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          placeholder="Codice Fiscale (opzionale)"
                          maxLength={16}
                        />
                      ) : (
                        <p className="text-lg font-semibold text-gray-900">{profileData.fiscal_code || 'Non specificato'}</p>
                      )}
                    </div>
                  </div>

                  <div className="flex items-start gap-3">
                    <div className="p-2 bg-teal-50 rounded-lg">
                      <User className="w-5 h-5 text-teal-600" />
                    </div>
                    <div className="flex-1">
                      <p className="text-sm text-gray-600 mb-1">Telefono</p>
                      {isEditing ? (
                        <input
                          type="tel"
                          value={editForm.phone}
                          onChange={(e) => setEditForm({ ...editForm, phone: e.target.value })}
                          className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          placeholder="Telefono (opzionale)"
                        />
                      ) : (
                        <p className="text-lg font-semibold text-gray-900">{profileData.phone || 'Non specificato'}</p>
                      )}
                    </div>
                  </div>

                  <div className="flex items-start gap-3">
                    <div className="p-2 bg-red-50 rounded-lg">
                      <Shield className="w-5 h-5 text-red-600" />
                    </div>
                    <div className="flex-1">
                      <p className="text-sm text-gray-600 mb-1">Ruolo</p>
                      <p className="text-lg font-semibold text-gray-900">Amministratore</p>
                    </div>
                  </div>

                  <div className="flex items-start gap-3">
                    <div className="p-2 bg-gray-50 rounded-lg">
                      <Calendar className="w-5 h-5 text-gray-600" />
                    </div>
                    <div className="flex-1">
                      <p className="text-sm text-gray-600 mb-1">Data Iscrizione</p>
                      <p className="text-lg font-semibold text-gray-900">
                        {new Date(profileData.created_at).toLocaleDateString('it-IT', {
                          day: 'numeric',
                          month: 'long',
                          year: 'numeric',
                        })}
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
            <div className="px-6 py-5 border-b border-gray-200 bg-gradient-to-r from-green-50 to-green-100">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <div className="p-2 bg-green-500 rounded-lg">
                    <Clock className="w-5 h-5 text-white" />
                  </div>
                  <div>
                    <h2 className="text-xl font-bold text-gray-900">Ultimi Accessi</h2>
                    <p className="text-sm text-gray-600">Cronologia degli accessi al pannello amministratore</p>
                  </div>
                </div>
                <div className="flex gap-2">
                  <button
                    onClick={() => setViewMode('all')}
                    className={`px-3 py-1 rounded-lg text-sm font-medium transition-colors ${
                      viewMode === 'all'
                        ? 'bg-blue-500 text-white'
                        : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
                    }`}
                  >
                    Tutti
                  </button>
                  <button
                    onClick={() => setViewMode('login')}
                    className={`px-3 py-1 rounded-lg text-sm font-medium transition-colors ${
                      viewMode === 'login'
                        ? 'bg-green-500 text-white'
                        : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
                    }`}
                  >
                    Login
                  </button>
                  <button
                    onClick={() => setViewMode('logout')}
                    className={`px-3 py-1 rounded-lg text-sm font-medium transition-colors ${
                      viewMode === 'logout'
                        ? 'bg-red-500 text-white'
                        : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
                    }`}
                  >
                    Logout
                  </button>
                </div>
              </div>
            </div>
            <div className="p-6">
              {filteredLogs.length > 0 ? (
                <div className="space-y-3">
                  {filteredLogs.map((log) => (
                    <div key={log.id}>
                      {viewMode === 'all' && (
                        <>
                          <div className="flex items-center justify-between p-4 bg-green-50 rounded-lg hover:bg-green-100 transition-colors border-l-4 border-green-500 mb-2">
                            <div className="flex items-center gap-3">
                              <div className="p-2 bg-green-500 rounded-lg">
                                <CheckCircle className="w-5 h-5 text-white" />
                              </div>
                              <div>
                                <p className="font-semibold text-gray-900">
                                  Login: {new Date(log.login_time).toLocaleString('it-IT', {
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
                          </div>
                          {log.logout_time && (
                            <div className="flex items-center justify-between p-4 bg-red-50 rounded-lg hover:bg-red-100 transition-colors border-l-4 border-red-500 mb-2">
                              <div className="flex items-center gap-3">
                                <div className="p-2 bg-red-500 rounded-lg">
                                  <XCircle className="w-5 h-5 text-white" />
                                </div>
                                <div>
                                  <p className="font-semibold text-gray-900">
                                    Logout: {new Date(log.logout_time).toLocaleString('it-IT', {
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
                            </div>
                          )}
                        </>
                      )}
                      {viewMode === 'login' && (
                        <div className="flex items-center justify-between p-4 bg-green-50 rounded-lg hover:bg-green-100 transition-colors border-l-4 border-green-500">
                          <div className="flex items-center gap-3">
                            <div className="p-2 bg-green-500 rounded-lg">
                              <CheckCircle className="w-5 h-5 text-white" />
                            </div>
                            <div>
                              <p className="font-semibold text-gray-900">
                                Login: {new Date(log.login_time).toLocaleString('it-IT', {
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
                        </div>
                      )}
                      {viewMode === 'logout' && log.logout_time && (
                        <div className="flex items-center justify-between p-4 bg-red-50 rounded-lg hover:bg-red-100 transition-colors border-l-4 border-red-500">
                          <div className="flex items-center gap-3">
                            <div className="p-2 bg-red-500 rounded-lg">
                              <XCircle className="w-5 h-5 text-white" />
                            </div>
                            <div>
                              <p className="font-semibold text-gray-900">
                                Logout: {new Date(log.logout_time).toLocaleString('it-IT', {
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
                        </div>
                      )}
                    </div>
                  ))}
                </div>
              ) : (
                <div className="text-center py-8">
                  <Clock className="w-12 h-12 text-gray-300 mx-auto mb-3" />
                  <p className="text-gray-600">Nessun accesso registrato</p>
                </div>
              )}
            </div>
          </div>

          <div className="bg-white rounded-xl shadow-sm border-2 border-red-300 overflow-hidden">
            <div className="px-6 py-5 border-b border-red-200 bg-gradient-to-r from-red-50 to-red-100">
              <div className="flex items-center gap-3">
                <div className="p-2 bg-red-600 rounded-lg">
                  <Trash2 className="w-5 h-5 text-white" />
                </div>
                <div>
                  <h2 className="text-xl font-bold text-gray-900">Zona Pericolosa</h2>
                  <p className="text-sm text-red-700 font-semibold">Azioni irreversibili</p>
                </div>
              </div>
            </div>
            <div className="p-6">
              <div className="flex items-start justify-between gap-6">
                <div>
                  <h3 className="text-lg font-bold text-gray-900 mb-2">Elimina Account Admin</h3>
                  <p className="text-gray-600 mb-1">
                    Questa azione eliminerà permanentemente il tuo account amministratore e tutti i dati associati.
                  </p>
                  <p className="text-sm text-red-600 font-semibold">
                    Questa operazione NON può essere annullata!
                  </p>
                </div>
                <DeleteAdminAccountButton adminId={profileData.id} adminEmail={profileData.email} />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
