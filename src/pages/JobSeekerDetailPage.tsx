import { useState, useEffect } from 'react';
import { ArrowLeft, MapPin, DollarSign, Calendar, Briefcase, GraduationCap, Tag, MessageCircle, Phone, Mail } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import { useToast } from '../components/common/Toast';

interface JobSeeker {
  id: string;
  user_id: string;
  title: string;
  description: string;
  skills: string[];
  contract_type: string;
  desired_salary_min: number | null;
  desired_salary_max: number | null;
  salary_currency: string;
  location: string;
  region: string | null;
  province: string | null;
  city: string | null;
  available_from: string | null;
  experience_years: number;
  education_level: string | null;
  phone: string | null;
  email: string | null;
  family_member_id: string | null;
  created_at: string;
  profiles: {
    full_name: string;
    nickname: string | null;
    avatar_url: string | null;
  };
  business_categories: {
    name: string;
  } | null;
}

export function JobSeekerDetailPage() {
  const { showToast } = useToast();
  const { user, profile, activeProfile, selectedBusinessLocationId } = useAuth();
  const [jobSeeker, setJobSeeker] = useState<JobSeeker | null>(null);
  const [loading, setLoading] = useState(true);

  const seekerId = window.location.pathname.split('/').pop();

  useEffect(() => {
    if (seekerId) loadJobSeeker();
  }, [seekerId]);

  const loadJobSeeker = async () => {
    try {
      setLoading(true);
      const { data, error } = await supabase
        .from('job_seekers')
        .select('*, business_categories(name)')
        .eq('id', seekerId)
        .maybeSingle();

      if (error) throw error;
      if (!data) return;

      const { data: profileData } = await supabase
        .from('profiles')
        .select('full_name, nickname, avatar_url')
        .eq('id', data.user_id)
        .maybeSingle();

      setJobSeeker({
        ...data,
        profiles: profileData || { full_name: 'Utente', nickname: null, avatar_url: null },
      });
    } catch (error) {
      console.error('Error loading job seeker:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleContact = async () => {
    if (!user) {
      window.location.href = '/';
      return;
    }
    if (!jobSeeker) return;

    try {
      const isBusiness = profile?.user_type === 'business';
      const p_user1_location_id = isBusiness ? (selectedBusinessLocationId ?? null) : null;
      const p_user1_family_member_id = !isBusiness && activeProfile && !activeProfile.isOwner
        ? activeProfile.id
        : null;
      const p_user2_family_member_id = jobSeeker.family_member_id || null;

      const { data: conversationId, error } = await supabase.rpc('get_or_create_conversation', {
        p_user1_id: user.id,
        p_user2_id: jobSeeker.user_id,
        p_conversation_type: 'job_seeker',
        p_reference_id: jobSeeker.id,
        p_user1_location_id,
        p_user1_family_member_id,
        p_user2_family_member_id,
      });

      if (error) throw error;
      window.location.href = `/messages?conversation=${conversationId}`;
    } catch (error) {
      console.error('Error starting conversation:', error);
      showToast('Errore nell\'avvio della conversazione', 'error');
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600" />
      </div>
    );
  }

  if (!jobSeeker) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <h2 className="text-2xl font-bold text-gray-900 mb-4">Annuncio non trovato</h2>
          <a href="/jobs" className="text-blue-600 hover:text-blue-700 font-medium">
            Torna agli annunci di lavoro
          </a>
        </div>
      </div>
    );
  }

  const isOwner = user?.id === jobSeeker.user_id;
  const isBusiness = profile?.user_type === 'business';
  const displayName = jobSeeker.profiles.nickname || 'Candidato';

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-4xl mx-auto px-4 py-8">
        <a
          href="/jobs"
          className="inline-flex items-center gap-2 text-gray-600 hover:text-gray-900 mb-6 transition-colors"
        >
          <ArrowLeft className="w-5 h-5" />
          Torna agli annunci di lavoro
        </a>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Main content */}
          <div className="lg:col-span-2 space-y-6">
            <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
              <div className="flex items-start justify-between mb-4">
                <div>
                  <div className="flex flex-wrap gap-2 mb-3">
                    <span className="inline-block px-3 py-1 bg-blue-100 text-blue-800 text-sm font-semibold rounded-full">
                      {jobSeeker.contract_type}
                    </span>
                    {jobSeeker.business_categories && (
                      <span className="inline-flex items-center gap-1 px-3 py-1 bg-gray-100 text-gray-700 text-sm font-medium rounded-full">
                        <Tag className="w-3.5 h-3.5" />
                        {jobSeeker.business_categories.name}
                      </span>
                    )}
                  </div>
                  <h1 className="text-2xl font-bold text-gray-900">{jobSeeker.title}</h1>
                </div>
              </div>

              <div className="grid grid-cols-2 md:grid-cols-3 gap-4 py-4 border-t border-b border-gray-100 mb-6">
                <div className="flex items-center gap-2 text-gray-600">
                  <MapPin className="w-4 h-4 text-gray-400 flex-shrink-0" />
                  <span className="text-sm">{jobSeeker.city || jobSeeker.location}</span>
                </div>
                <div className="flex items-center gap-2 text-gray-600">
                  <Briefcase className="w-4 h-4 text-gray-400 flex-shrink-0" />
                  <span className="text-sm">{jobSeeker.experience_years} anni esperienza</span>
                </div>
                {jobSeeker.education_level && (
                  <div className="flex items-center gap-2 text-gray-600">
                    <GraduationCap className="w-4 h-4 text-gray-400 flex-shrink-0" />
                    <span className="text-sm">{jobSeeker.education_level}</span>
                  </div>
                )}
                {jobSeeker.desired_salary_min && jobSeeker.desired_salary_max && (
                  <div className="flex items-center gap-2 text-gray-600">
                    <DollarSign className="w-4 h-4 text-gray-400 flex-shrink-0" />
                    <span className="text-sm">
                      {jobSeeker.desired_salary_min.toLocaleString()} – {jobSeeker.desired_salary_max.toLocaleString()} {jobSeeker.salary_currency}
                    </span>
                  </div>
                )}
                {jobSeeker.available_from && (
                  <div className="flex items-center gap-2 text-gray-600">
                    <Calendar className="w-4 h-4 text-gray-400 flex-shrink-0" />
                    <span className="text-sm">
                      Disponibile dal {new Date(jobSeeker.available_from).toLocaleDateString('it-IT')}
                    </span>
                  </div>
                )}
              </div>

              <div>
                <h2 className="text-lg font-semibold text-gray-900 mb-3">Descrizione</h2>
                <p className="text-gray-700 whitespace-pre-line leading-relaxed">{jobSeeker.description}</p>
              </div>

              {jobSeeker.skills.length > 0 && (
                <div className="mt-6">
                  <h2 className="text-lg font-semibold text-gray-900 mb-3">Competenze</h2>
                  <div className="flex flex-wrap gap-2">
                    {jobSeeker.skills.map((skill, i) => (
                      <span key={i} className="px-3 py-1.5 bg-gray-100 text-gray-700 text-sm rounded-lg font-medium">
                        {skill}
                      </span>
                    ))}
                  </div>
                </div>
              )}
            </div>
          </div>

          {/* Sidebar */}
          <div className="space-y-4">
            <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
              <h3 className="font-semibold text-gray-900 mb-4">Candidato</h3>
              <div className="flex items-center gap-3 mb-5">
                {jobSeeker.profiles.avatar_url ? (
                  <img
                    src={jobSeeker.profiles.avatar_url}
                    alt={displayName}
                    className="w-12 h-12 rounded-full object-cover"
                  />
                ) : (
                  <div className="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center">
                    <span className="text-lg font-semibold text-blue-700">
                      {displayName.charAt(0).toUpperCase()}
                    </span>
                  </div>
                )}
                <div>
                  {profile?.user_type === 'business' ? (
                    <a
                      href={`/professional-profile/${jobSeeker.user_id}`}
                      className="font-semibold text-blue-600 hover:underline transition-colors"
                    >
                      {displayName}
                    </a>
                  ) : (
                    <div className="font-semibold text-gray-900">{displayName}</div>
                  )}
                  <div className="text-sm text-gray-500">
                    Pubblicato il {new Date(jobSeeker.created_at).toLocaleDateString('it-IT')}
                  </div>
                </div>
              </div>

              {!isOwner && user && (
                <button
                  onClick={handleContact}
                  className="w-full flex items-center justify-center gap-2 bg-blue-600 text-white px-4 py-3 rounded-lg hover:bg-blue-700 transition-colors font-medium"
                >
                  <MessageCircle className="w-5 h-5" />
                  Invia Messaggio
                </button>
              )}

              {!isOwner && !user && (
                <a
                  href="/"
                  className="w-full flex items-center justify-center gap-2 bg-blue-600 text-white px-4 py-3 rounded-lg hover:bg-blue-700 transition-colors font-medium"
                >
                  <MessageCircle className="w-5 h-5" />
                  Accedi per contattare
                </a>
              )}

              {isOwner && (
                <div className="text-sm text-gray-500 text-center py-2">
                  Questo è il tuo annuncio
                </div>
              )}
            </div>

            {(jobSeeker.phone || jobSeeker.email) && !isOwner && isBusiness && (
              <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                <h3 className="font-semibold text-gray-900 mb-4">Contatti diretti</h3>
                <div className="space-y-3">
                  {jobSeeker.phone && (
                    <a
                      href={`tel:${jobSeeker.phone}`}
                      className="flex items-center gap-3 text-gray-700 hover:text-blue-600 transition-colors"
                    >
                      <Phone className="w-4 h-4 text-gray-400 flex-shrink-0" />
                      <span className="text-sm">{jobSeeker.phone}</span>
                    </a>
                  )}
                  {jobSeeker.email && (
                    <a
                      href={`mailto:${jobSeeker.email}`}
                      className="flex items-center gap-3 text-gray-700 hover:text-blue-600 transition-colors"
                    >
                      <Mail className="w-4 h-4 text-gray-400 flex-shrink-0" />
                      <span className="text-sm">{jobSeeker.email}</span>
                    </a>
                  )}
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
