import { useState, useEffect } from 'react';
import { ArrowLeft, Briefcase, MapPin, Star, FileText, MessageCircle, Lock, Calendar } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import { useToast } from '../components/common/Toast';

function Link({ to, children, className }: { to: string; children: React.ReactNode; className?: string }) {
  return (
    <a
      href={to}
      className={className}
      onClick={(e) => { e.preventDefault(); window.history.pushState({}, '', to); window.dispatchEvent(new PopStateEvent('popstate')); }}
    >
      {children}
    </a>
  );
}

interface ProfessionalProfile {
  id: string;
  user_id: string;
  profession: string;
  city: string;
  province: string;
  region: string;
  experience_years: number;
  summary: string;
  skills: string[];
  created_at: string;
  profiles: {
    full_name: string;
    nickname: string | null;
    avatar_url: string | null;
  };
}

export function ProfessionalProfilePage() {
  const userId = window.location.pathname.split('/')[2];
  const { user, profile } = useAuth();
  const { showToast } = useToast();
  const [professionalProfile, setProfessionalProfile] = useState<ProfessionalProfile | null>(null);
  const [loading, setLoading] = useState(true);
  const [notFound, setNotFound] = useState(false);
  const [startingChat, setStartingChat] = useState(false);

  const isBusiness = profile?.user_type === 'business';
  const isOwner = user?.id === userId;

  useEffect(() => {
    if (!userId) return;
    loadProfile();
  }, [userId]);

  const loadProfile = async () => {
    setLoading(true);
    try {
      const { data, error } = await supabase
        .from('professional_profiles')
        .select(`
          *,
          profiles!user_id(full_name, nickname, avatar_url)
        `)
        .eq('user_id', userId)
        .maybeSingle();

      if (error) throw error;
      if (!data) {
        setNotFound(true);
      } else {
        setProfessionalProfile(data as unknown as ProfessionalProfile);
      }
    } catch (err) {
      console.error(err);
      setNotFound(true);
    } finally {
      setLoading(false);
    }
  };

  const handleStartChat = async () => {
    if (!user || !professionalProfile) return;
    setStartingChat(true);
    try {
      const { data: conversationId, error } = await supabase.rpc('get_or_create_conversation', {
        p_user1_id: user.id,
        p_user2_id: professionalProfile.user_id,
        p_conversation_type: 'professional_profile',
        p_reference_id: professionalProfile.id,
        p_user1_family_member_id: null,
        p_user2_family_member_id: null,
        p_user1_location_id: null,
        p_user2_location_id: null,
      });

      if (error) throw error;
      window.location.href = `/messages?conversation=${conversationId}`;
    } catch (err) {
      console.error(err);
      showToast('Errore nell\'apertura della chat', 'error');
    } finally {
      setStartingChat(false);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  if (notFound) {
    return (
      <div className="min-h-screen bg-gray-50 flex flex-col items-center justify-center gap-4">
        <Briefcase className="w-16 h-16 text-gray-300" />
        <h2 className="text-xl font-bold text-gray-700">Profilo non trovato</h2>
        <p className="text-gray-500">Questo profilo professionale non esiste o non e disponibile.</p>
        <Link to="/jobs" className="text-blue-600 hover:underline">Torna agli annunci</Link>
      </div>
    );
  }

  if (!isOwner && !isBusiness && user) {
    return (
      <div className="min-h-screen bg-gray-50 flex flex-col items-center justify-center gap-4 px-4">
        <Lock className="w-16 h-16 text-gray-300" />
        <h2 className="text-xl font-bold text-gray-700">Profilo riservato</h2>
        <p className="text-gray-500 text-center max-w-sm">
          I profili professionali sono visibili solo agli account business. Aggiorna il tuo account per accedere.
        </p>
        <Link to="/jobs" className="text-blue-600 hover:underline">Torna agli annunci</Link>
      </div>
    );
  }

  if (!user) {
    return (
      <div className="min-h-screen bg-gray-50 flex flex-col items-center justify-center gap-4 px-4">
        <Lock className="w-16 h-16 text-gray-300" />
        <h2 className="text-xl font-bold text-gray-700">Accesso richiesto</h2>
        <p className="text-gray-500 text-center max-w-sm">
          Devi accedere con un account business per visualizzare i profili professionali.
        </p>
        <Link to="/jobs" className="text-blue-600 hover:underline">Torna agli annunci</Link>
      </div>
    );
  }

  const pp = professionalProfile!;
  const displayName = pp.profiles?.nickname || 'Candidato';
  const initial = displayName.charAt(0).toUpperCase();
  const location = [pp.city, pp.province, pp.region].filter(Boolean).join(', ');

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Back */}
        <Link to="/jobs" className="inline-flex items-center gap-2 text-gray-500 hover:text-gray-700 mb-8 text-sm font-medium transition-colors">
          <ArrowLeft className="w-4 h-4" />
          Torna agli annunci
        </Link>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Main content */}
          <div className="lg:col-span-2 space-y-6">
            {/* Header card */}
            <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
              <div className="flex items-start gap-5">
                {pp.profiles?.avatar_url ? (
                  <img
                    src={pp.profiles.avatar_url}
                    alt={displayName}
                    className="w-20 h-20 rounded-2xl object-cover flex-shrink-0 ring-2 ring-gray-100"
                  />
                ) : (
                  <div className="w-20 h-20 rounded-2xl bg-blue-600 flex items-center justify-center flex-shrink-0">
                    <span className="text-white text-2xl font-bold">{initial}</span>
                  </div>
                )}
                <div className="flex-1 min-w-0">
                  <h1 className="text-2xl font-bold text-gray-900 mb-1">{displayName}</h1>
                  <p className="text-blue-600 font-semibold text-lg mb-3">{pp.profession}</p>
                  <div className="flex flex-wrap gap-4 text-sm text-gray-500">
                    {location && (
                      <span className="flex items-center gap-1.5">
                        <MapPin className="w-4 h-4 flex-shrink-0" />
                        {location}
                      </span>
                    )}
                    <span className="flex items-center gap-1.5">
                      <Star className="w-4 h-4 flex-shrink-0" />
                      {pp.experience_years === 1 ? '1 anno di esperienza' : `${pp.experience_years} anni di esperienza`}
                    </span>
                    <span className="flex items-center gap-1.5">
                      <Calendar className="w-4 h-4 flex-shrink-0" />
                      Membro dal {new Date(pp.created_at).toLocaleDateString('it-IT', { month: 'long', year: 'numeric' })}
                    </span>
                  </div>
                </div>
              </div>
            </div>

            {/* Summary */}
            {pp.summary && (
              <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                <h2 className="flex items-center gap-2 text-base font-bold text-gray-900 mb-3">
                  <FileText className="w-5 h-5 text-blue-500" />
                  Descrizione
                </h2>
                <p className="text-gray-700 leading-relaxed whitespace-pre-line">{pp.summary}</p>
              </div>
            )}

            {/* Skills */}
            {pp.skills.length > 0 && (
              <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                <h2 className="text-base font-bold text-gray-900 mb-3">Competenze</h2>
                <div className="flex flex-wrap gap-2">
                  {pp.skills.map(skill => (
                    <span
                      key={skill}
                      className="px-3 py-1.5 bg-blue-50 text-blue-700 text-sm font-medium rounded-full border border-blue-100"
                    >
                      {skill}
                    </span>
                  ))}
                </div>
              </div>
            )}
          </div>

          {/* Sidebar */}
          <div className="space-y-4">
            {/* Contact card */}
            <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-5">
              <h3 className="text-sm font-bold text-gray-900 mb-4">Contatto</h3>
              {isOwner ? (
                <p className="text-sm text-gray-500 text-center py-2">Questo e il tuo profilo</p>
              ) : isBusiness ? (
                <button
                  onClick={handleStartChat}
                  disabled={startingChat}
                  className="w-full flex items-center justify-center gap-2 px-4 py-3 bg-blue-600 text-white rounded-xl font-semibold text-sm hover:bg-blue-700 transition-colors disabled:opacity-60"
                >
                  <MessageCircle className="w-4 h-4" />
                  {startingChat ? 'Apertura chat...' : 'Invia Messaggio'}
                </button>
              ) : null}
              <p className="text-xs text-gray-400 text-center mt-3">
                Per ulteriori informazioni usa la chat interna
              </p>
            </div>

            {/* Info card */}
            <div className="bg-blue-50 border border-blue-100 rounded-2xl p-5">
              <div className="flex items-start gap-3">
                <Lock className="w-5 h-5 text-blue-500 flex-shrink-0 mt-0.5" />
                <div>
                  <p className="text-sm font-semibold text-blue-800 mb-1">Profilo riservato</p>
                  <p className="text-xs text-blue-600 leading-relaxed">
                    Questo profilo e visibile solo agli account business registrati sulla piattaforma.
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
