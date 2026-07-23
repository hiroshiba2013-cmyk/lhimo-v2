import { useState, useEffect, useMemo } from 'react';
import { Briefcase, MapPin, DollarSign, Filter, X, Check, MessageCircle, Plus, Building2, CircleUser as UserCircle, ArrowUpDown } from 'lucide-react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../contexts/AuthContext';
import { SearchableSelect } from '../components/common/SearchableSelect';
import { CategoryHierarchySelect } from '../components/common/CategoryHierarchySelect';
import { JobSeekerForm } from '../components/jobs/JobSeekerForm';
import { JobSeekerCard } from '../components/jobs/JobSeekerCard';
import { FavoriteButton } from '../components/favorites/FavoriteButton';
import { ItalianCityProvinceSelect } from '../components/common/ItalianCityProvinceSelect';
import { useItalianLocations } from '../hooks/useItalianLocations';
import { useToast } from '../components/common/Toast';
import { usePageCustomization } from '../hooks/usePageCustomization';

interface JobPosting {
  id: string;
  title: string;
  description: string;
  position_type: string;
  salary_min: number;
  salary_max: number;
  salary_currency: string;
  location: string;
  required_skills: string[];
  experience_level: string;
  published_at: string;
  expires_at: string;
  company_name: string | null;
  gross_annual_salary: number | null;
  benefits: string[];
  remote_work: boolean;
  business: {
    id: string;
    name: string;
    owner_id: string;
  } | null;
  registered_business: {
    id: string;
    name: string;
    owner_id: string;
  } | null;
}

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
  available_from: string | null;
  experience_years: number;
  education_level: string | null;
  phone: string | null;
  email: string | null;
  created_at: string;
  profiles: {
    full_name: string;
    nickname: string;
  };
  business_categories: {
    name: string;
  } | null;
}

interface SearchFilters {
  position_type: string;
  experience_level: string;
  region: string;
  province: string;
  provinceCode: string;
  city: string;
  searchTerm: string;
  salary_min: string;
  salary_max: string;
  remote_work: string;
  education_level: string;
  skill: string;
  category: string;
}

export function JobsPage() {
  const { regions } = useItalianLocations();
  const customization = usePageCustomization('jobs');
  const { showToast } = useToast();
  const [activeTab, setActiveTab] = useState<'offers' | 'seekers'>('offers');
  const [jobs, setJobs] = useState<JobPosting[]>([]);
  const [jobSeekers, setJobSeekers] = useState<JobSeeker[]>([]);
  const [loading, setLoading] = useState(true);
  const [showFilters, setShowFilters] = useState(false);
  const [showJobSeekerForm, setShowJobSeekerForm] = useState(false);
  const [userApplications, setUserApplications] = useState<string[]>([]);
  const [viewedJobs, setViewedJobs] = useState<string[]>([]);
  const [appliedJobId, setAppliedJobId] = useState<string | null>(null);
  const [markingAsViewed, setMarkingAsViewed] = useState<string | null>(null);
  const [categories, setCategories] = useState<{ id: string; name: string; parent_id: string | null }[]>([]);
  const [selectedJobId, setSelectedJobId] = useState<string | null>(null);
  const [professionalProfile, setProfessionalProfile] = useState<any | null>(null);
  const [professionalProfileLoaded, setProfessionalProfileLoaded] = useState(false);
  const { user, profile, selectedBusinessLocationId, activeProfile } = useAuth();

  const [sortBy, setSortBy] = useState<string>('recent_desc');

  const [filters, setFilters] = useState<SearchFilters>({
    position_type: '',
    experience_level: '',
    region: '',
    province: '',
    provinceCode: '',
    city: '',
    searchTerm: '',
    salary_min: '',
    salary_max: '',
    remote_work: '',
    education_level: '',
    skill: '',
    category: '',
  });

  useEffect(() => {
    loadCategories();
    const params = new URLSearchParams(window.location.search);
    const jobId = params.get('job');
    if (jobId) {
      setSelectedJobId(jobId);
    }
  }, []);

  useEffect(() => {
    if (!user || !profile || profile.user_type === 'business') return;
    const fmId = activeProfile?.isOwner === false ? activeProfile.id : null;
    let q = supabase.from('professional_profiles').select('id').eq('user_id', profile.id);
    if (fmId) q = q.eq('family_member_id', fmId);
    else q = q.is('family_member_id', null);
    q.maybeSingle().then(({ data }) => {
      setProfessionalProfile(data || null);
      setProfessionalProfileLoaded(true);
    });
  }, [user, profile?.id, activeProfile?.id]);

  useEffect(() => {
    if (activeTab === 'offers') {
      loadJobs();
      if (user) {
        loadUserApplications();
        loadViewedJobs();
      }
    } else {
      loadJobSeekers();
    }
  }, [activeTab, user, filters, selectedBusinessLocationId]);

  const loadCategories = async () => {
    try {
      const { data } = await supabase
        .from('business_categories')
        .select('id, name, parent_id')
        .order('name');

      setCategories(data || []);
    } catch (error) {
      console.error('Error loading categories:', error);
    }
  };

  const loadJobs = async () => {
    setLoading(true);
    try {
      let query = supabase
        .from('job_postings')
        .select(`
          *,
          business:businesses(id, name, owner_id),
          registered_business:registered_businesses(id, name, owner_id)
        `)
        .eq('status', 'active')
        .eq('approval_status', 'approved')
        .gt('expires_at', new Date().toISOString());

      if (selectedBusinessLocationId) {
        query = query.eq('business_location_id', selectedBusinessLocationId);
      }

      if (filters.position_type) {
        query = query.eq('position_type', filters.position_type);
      }

      if (filters.experience_level) {
        query = query.eq('experience_level', filters.experience_level);
      }

      if (filters.region) {
        query = query.ilike('region', `%${filters.region}%`);
      }

      if (filters.province) {
        // job_postings stores province as sigla (e.g. "VA"), use provinceCode when available
        const provFilter = filters.provinceCode || filters.province;
        query = query.ilike('province', `%${provFilter}%`);
      }

      if (filters.city) {
        query = query.ilike('city', `%${filters.city}%`);
      }

      if (filters.searchTerm) {
        query = query.or(`title.ilike.%${filters.searchTerm}%,description.ilike.%${filters.searchTerm}%`);
      }

      if (filters.salary_min) {
        query = query.gte('gross_annual_salary', parseInt(filters.salary_min));
      }

      if (filters.salary_max) {
        query = query.lte('gross_annual_salary', parseInt(filters.salary_max));
      }

      if (filters.remote_work) {
        query = query.eq('remote_work', filters.remote_work === 'true');
      }

      if (filters.skill) {
        query = query.contains('required_skills', [filters.skill]);
      }

      if (filters.category) {
        query = query.eq('category_id', filters.category);
      }

      const { data } = await query;

      if (data) {
        const businessIds = [...new Set(data.map(job => (job.business ?? job.registered_business)?.id).filter(Boolean))];

        const reviewCounts = await Promise.all(
          businessIds.map(async (businessId) => {
            const { count } = await supabase
              .from('reviews')
              .select('id', { count: 'exact', head: true })
              .eq('business_id', businessId)
              .eq('review_status', 'approved');

            return { businessId, count: count || 0 };
          })
        );

        const reviewCountMap = Object.fromEntries(
          reviewCounts.map(({ businessId, count }) => [businessId, count])
        );

        const sortedJobs = [...data].sort((a, b) => {
          const countA = reviewCountMap[(a.business ?? a.registered_business)?.id || ''] || 0;
          const countB = reviewCountMap[(b.business ?? b.registered_business)?.id || ''] || 0;

          if (countB !== countA) {
            return countB - countA;
          }

          return new Date(b.published_at).getTime() - new Date(a.published_at).getTime();
        });

        setJobs(sortedJobs);
      } else {
        setJobs([]);
      }
    } catch (error) {
      console.error('Error loading jobs:', error);
    } finally {
      setLoading(false);
    }
  };

  const loadJobSeekers = async () => {
    setLoading(true);
    try {
      let query = supabase
        .from('job_seekers')
        .select(`
          *,
          business_categories(name)
        `)
        .eq('status', 'active')
        .eq('approval_status', 'approved')
        .order('created_at', { ascending: false });

      if (filters.position_type) {
        query = query.eq('contract_type', filters.position_type);
      }

      if (filters.region) {
        query = query.ilike('region', `%${filters.region}%`);
      }

      if (filters.province) {
        query = query.ilike('province', `%${filters.province}%`);
      }

      if (filters.city) {
        query = query.ilike('city', `%${filters.city}%`);
      }

      if (filters.searchTerm) {
        query = query.or(`title.ilike.%${filters.searchTerm}%,description.ilike.%${filters.searchTerm}%`);
      }

      if (filters.salary_min) {
        query = query.gte('desired_salary_min', parseInt(filters.salary_min));
      }

      if (filters.salary_max) {
        query = query.lte('desired_salary_max', parseInt(filters.salary_max));
      }

      if (filters.education_level) {
        query = query.eq('education_level', filters.education_level);
      }

      if (filters.skill) {
        query = query.contains('skills', [filters.skill]);
      }

      if (filters.category) {
        query = query.eq('category_id', filters.category);
      }

      const { data, error } = await query;

      console.log('Job seekers query result:', { data, error, filtersApplied: filters });

      if (error) {
        console.error('Error in job seekers query:', error);
      }

      if (data && data.length > 0) {
        // Get unique user IDs
        const userIds = [...new Set(data.map(js => js.user_id))];

        // Fetch profiles for these users
        const { data: profilesData } = await supabase
          .from('profiles')
          .select('id, full_name, nickname')
          .in('id', userIds);

        // Create a map for quick lookup
        const profilesMap = new Map(profilesData?.map(p => [p.id, p]) || []);

        // Merge profiles into job seekers data
        const enrichedData = data.map(js => ({
          ...js,
          profiles: profilesMap.get(js.user_id) || { full_name: 'Utente', nickname: 'Utente' }
        }));

        setJobSeekers(enrichedData);
      } else {
        setJobSeekers([]);
      }
    } catch (error) {
      console.error('Error loading job seekers:', error);
    } finally {
      setLoading(false);
    }
  };

  const loadUserApplications = async () => {
    try {
      const { data } = await supabase
        .from('job_applications')
        .select('job_posting_id')
        .eq('user_id', user?.id);

      setUserApplications(data?.map(a => a.job_posting_id) || []);
    } catch (error) {
      console.error('Error loading applications:', error);
    }
  };

  const loadViewedJobs = async () => {
    try {
      const { data } = await supabase
        .from('job_views')
        .select('job_posting_id')
        .eq('user_id', user?.id);

      setViewedJobs(data?.map(v => v.job_posting_id) || []);
    } catch (error) {
      console.error('Error loading viewed jobs:', error);
    }
  };

  const handleContactJobSeeker = async (jobSeekerId: string) => {
    if (!user) {
      showToast('Devi accedere per contattare', 'info');
      return;
    }

    if (profile?.user_type !== 'business') {
      showToast('Solo gli utenti professionali possono contattare chi cerca lavoro', 'info');
      return;
    }

    try {
      const jobSeeker = jobSeekers.find(js => js.id === jobSeekerId);
      if (!jobSeeker) return;

      const locationId = selectedBusinessLocationId || null;
      const familyMemberId = jobSeeker.family_member_id || null;

      const { data: conversationId, error: funcError } = await supabase
        .rpc('get_or_create_conversation', {
          p_user1_id: user.id,
          p_user2_id: jobSeeker.user_id,
          p_conversation_type: 'job_seeker',
          p_reference_id: jobSeekerId,
          p_user1_location_id: locationId,
          p_user2_family_member_id: familyMemberId,
        });

      if (funcError) throw funcError;

      window.location.href = `/messages?conversation=${conversationId}`;
    } catch (error) {
      console.error('Error creating conversation:', error);
      showToast('Errore nell\'apertura della chat', 'error');
    }
  };

  const handleContactEmployer = async (jobId: string) => {
    if (!user) {
      showToast('Devi accedere per contattare', 'info');
      return;
    }

    if (profile?.user_type === 'business') {
      showToast('Solo gli utenti privati possono contattare per offerte di lavoro', 'info');
      return;
    }

    try {
      const job = jobs.find(j => j.id === jobId);
      const jobOwner = job?.business ?? job?.registered_business;
      if (!job || !jobOwner) {
        showToast('Informazioni sul datore di lavoro non disponibili', 'info');
        return;
      }

      const familyMemberId = activeProfile && !activeProfile.isOwner ? activeProfile.id : null;
      const businessLocationId = job.registered_business_location_id || job.business_location_id || null;

      const { data: conversationId, error: funcError } = await supabase
        .rpc('get_or_create_conversation', {
          p_user1_id: user.id,
          p_user2_id: jobOwner.owner_id,
          p_conversation_type: 'job_posting',
          p_reference_id: jobId,
          p_user1_family_member_id: familyMemberId,
          p_user2_location_id: businessLocationId,
        });

      if (funcError) throw funcError;

      window.location.href = `/messages?conversation=${conversationId}`;
    } catch (error) {
      console.error('Error creating conversation:', error);
      showToast('Errore nell\'apertura della chat', 'error');
    }
  };

  const handleMarkAsViewed = async (jobId: string) => {
    if (!user) return;

    try {
      setMarkingAsViewed(jobId);
      const { error } = await supabase
        .from('job_views')
        .insert({
          job_posting_id: jobId,
          user_id: user.id,
        });

      if (error) throw error;
      setViewedJobs([...viewedJobs, jobId]);
    } catch (error: any) {
      if (error.code !== '23505') {
        console.error('Error marking as viewed:', error);
      }
    } finally {
      setMarkingAsViewed(null);
    }
  };

  const handleReset = () => {
    setFilters({
      position_type: '',
      experience_level: '',
      region: '',
      province: '',
      city: '',
      searchTerm: '',
      salary_min: '',
      salary_max: '',
      remote_work: '',
      education_level: '',
      skill: '',
      category: '',
    });
  };

  const sortedJobs = useMemo(() => {
    const arr = [...jobs];
    switch (sortBy) {
      case 'recent_desc': return arr.sort((a, b) => new Date(b.published_at).getTime() - new Date(a.published_at).getTime());
      case 'recent_asc': return arr.sort((a, b) => new Date(a.published_at).getTime() - new Date(b.published_at).getTime());
      case 'salary_desc': return arr.sort((a, b) => (b.gross_annual_salary || 0) - (a.gross_annual_salary || 0));
      case 'salary_asc': return arr.sort((a, b) => (a.gross_annual_salary || 0) - (b.gross_annual_salary || 0));
      case 'name_asc': return arr.sort((a, b) => a.title.localeCompare(b.title, 'it'));
      case 'name_desc': return arr.sort((a, b) => b.title.localeCompare(a.title, 'it'));
      default: return arr;
    }
  }, [jobs, sortBy]);

  const sortedJobSeekers = useMemo(() => {
    const arr = [...jobSeekers];
    switch (sortBy) {
      case 'recent_desc': return arr.sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());
      case 'recent_asc': return arr.sort((a, b) => new Date(a.created_at).getTime() - new Date(b.created_at).getTime());
      case 'salary_desc': return arr.sort((a, b) => (b.desired_salary_max || 0) - (a.desired_salary_max || 0));
      case 'salary_asc': return arr.sort((a, b) => (a.desired_salary_min || 0) - (b.desired_salary_min || 0));
      case 'name_asc': return arr.sort((a, b) => a.title.localeCompare(b.title, 'it'));
      case 'name_desc': return arr.sort((a, b) => b.title.localeCompare(a.title, 'it'));
      default: return arr;
    }
  }, [jobSeekers, sortBy]);

  const hasActiveFilters =
    filters.position_type ||
    filters.experience_level ||
    filters.region ||
    filters.province ||
    filters.city ||
    filters.searchTerm ||
    filters.salary_min ||
    filters.salary_max ||
    filters.remote_work ||
    filters.education_level ||
    filters.skill ||
    filters.category;

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Announcement banner */}
      {customization?.announcement_active && customization.announcement_text && (
        <div className="bg-green-600 text-white text-sm font-medium text-center py-2 px-4">
          {customization.announcement_text}
        </div>
      )}
      {/* Hero */}
      <section
        className="bg-white border-b border-gray-100 relative"
        style={customization?.hero_image_url ? {
          backgroundImage: `url(${customization.hero_image_url})`,
          backgroundSize: 'cover',
          backgroundPosition: 'center',
        } : undefined}
      >
        {customization?.hero_image_url && <div className="absolute inset-0 bg-black/50" />}
        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 md:py-20">
          <div className={`inline-flex items-center gap-2 ${customization?.hero_image_url ? 'bg-green-500/30 text-green-100' : 'bg-green-50 text-green-700'} text-xs font-semibold px-3 py-1.5 rounded-full mb-6`}>
            <div className="w-1.5 h-1.5 bg-green-500 rounded-full"></div>
            Offerte e candidature
          </div>
          <h1 className={`text-4xl md:text-5xl lg:text-6xl font-extrabold leading-tight mb-3 ${customization?.hero_image_url ? 'text-white' : 'text-gray-900'}`}>
            {customization?.hero_title || 'Lavoro'}
          </h1>
          <p className={`text-lg ${customization?.hero_image_url ? 'text-gray-200' : 'text-gray-500'}`}>
            {customization?.hero_subtitle || 'Trova opportunita di lavoro o trova i candidati ideali per la tua attivita'}
          </p>
        </div>
      </section>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="mb-8">
          <div className="flex gap-2 mb-6">
            <button
              onClick={() => setActiveTab('offers')}
              className={`flex items-center gap-2 px-6 py-3 rounded-lg font-medium transition-colors ${
                activeTab === 'offers'
                  ? 'bg-green-600 text-white'
                  : 'bg-white text-gray-700 border border-gray-300 hover:bg-gray-50'
              }`}
            >
              <Building2 className="w-5 h-5" />
              Trova Lavoro
            </button>
            <button
              onClick={() => setActiveTab('seekers')}
              className={`flex items-center gap-2 px-6 py-3 rounded-lg font-medium transition-colors ${
                activeTab === 'seekers'
                  ? 'bg-blue-600 text-white'
                  : 'bg-white text-gray-700 border border-gray-300 hover:bg-gray-50'
              }`}
            >
              <UserCircle className="w-5 h-5" />
              Cerco Lavoro
            </button>
          </div>

          {activeTab === 'seekers' && user && profile?.user_type !== 'business' && !showJobSeekerForm && (
            <button
              onClick={() => {
                if (professionalProfileLoaded && !professionalProfile) {
                  showToast('Devi prima creare un profilo professionale per pubblicare annunci cerco lavoro', 'info');
                  window.history.pushState({}, '', '/dashboard');
                  window.dispatchEvent(new PopStateEvent('popstate'));
                } else {
                  setShowJobSeekerForm(true);
                }
              }}
              className="flex items-center gap-2 px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-medium transition-colors mb-6"
            >
              <Plus className="w-5 h-5" />
              Crea Annuncio Cerco Lavoro
            </button>
          )}

          {showJobSeekerForm && (
            <div className="mb-6">
              <JobSeekerForm
                onSuccess={() => {
                  setShowJobSeekerForm(false);
                  loadJobSeekers();
                }}
                onCancel={() => setShowJobSeekerForm(false)}
              />
            </div>
          )}

          <div className="bg-white rounded-lg shadow-md p-4 mb-6">
            <input
              type="text"
              placeholder="Cerca per titolo o descrizione..."
              value={filters.searchTerm}
              onChange={(e) => setFilters({ ...filters, searchTerm: e.target.value })}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
            />
          </div>

          <button
            onClick={() => setShowFilters(!showFilters)}
            className={`flex items-center gap-2 px-4 py-2 rounded-lg transition-colors mb-6 ${
              showFilters || hasActiveFilters
                ? 'bg-green-600 text-white'
                : 'bg-white text-gray-700 border border-gray-300 hover:bg-gray-50'
            }`}
          >
            <Filter className="w-5 h-5" />
            <span>Filtri</span>
            {hasActiveFilters && (
              <span className="ml-2 px-2 py-0.5 bg-white text-green-600 text-xs rounded-full font-medium">
                {[filters.category, filters.position_type, filters.experience_level, filters.region, filters.province, filters.city, filters.salary_min, filters.salary_max, filters.remote_work, filters.education_level, filters.skill].filter(Boolean).length}
              </span>
            )}
          </button>

          {showFilters && (
            <div className="bg-white rounded-lg shadow-md p-6 mb-6 space-y-6">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Categoria Lavorativa
                  </label>
                  <CategoryHierarchySelect
                    value={filters.category}
                    onChange={(value) => setFilters({ ...filters, category: value })}
                    categories={categories}
                    placeholder="Tutte le categorie"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Tipo di Contratto
                  </label>
                  <select
                    value={filters.position_type}
                    onChange={(e) => setFilters({ ...filters, position_type: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
                  >
                    <option value="">Tutti</option>
                    <option value="Full-time">Full-time</option>
                    <option value="Part-time">Part-time</option>
                    <option value="Contract">Contract</option>
                    <option value="Freelance">Freelance</option>
                    <option value="Internship">Tirocinio</option>
                  </select>
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1.5">Regione</label>
                <select
                  value={filters.region}
                  onChange={(e) => setFilters(prev => ({ ...prev, region: e.target.value, province: '', provinceCode: '', city: '' }))}
                  className="w-full px-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-100 focus:border-blue-500 text-sm bg-white"
                >
                  <option value="">Tutte le regioni</option>
                  {regions.map(r => <option key={r} value={r}>{r}</option>)}
                </select>
              </div>
              <ItalianCityProvinceSelect
                province={filters.province}
                city={filters.city}
                region={filters.region}
                onProvinceChange={(prov, code) => setFilters(prev => ({ ...prev, province: prov, provinceCode: code, city: '' }))}
                onCityChange={(city) => setFilters(prev => ({ ...prev, city }))}
              />

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {activeTab === 'offers' && (
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Livello di Esperienza
                    </label>
                    <select
                      value={filters.experience_level}
                      onChange={(e) => setFilters({ ...filters, experience_level: e.target.value })}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
                    >
                      <option value="">Tutti</option>
                      <option value="Junior">Junior</option>
                      <option value="Mid">Mid</option>
                      <option value="Senior">Senior</option>
                    </select>
                  </div>
                )}

                {activeTab === 'seekers' && (
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Livello di Istruzione
                    </label>
                    <select
                      value={filters.education_level}
                      onChange={(e) => setFilters({ ...filters, education_level: e.target.value })}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
                    >
                      <option value="">Tutti</option>
                      <option value="Licenza Media">Licenza Media</option>
                      <option value="Diploma">Diploma</option>
                      <option value="Laurea Triennale">Laurea Triennale</option>
                      <option value="Laurea Magistrale">Laurea Magistrale</option>
                      <option value="Master/PhD">Master/PhD</option>
                    </select>
                  </div>
                )}
              </div>

              <div className="border-t pt-4">
                <h4 className="text-sm font-semibold text-gray-900 mb-3">Fascia Salariale (€/anno)</h4>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Minimo
                    </label>
                    <input
                      type="number"
                      placeholder="Es. 20000"
                      value={filters.salary_min}
                      onChange={(e) => setFilters({ ...filters, salary_min: e.target.value })}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Massimo
                    </label>
                    <input
                      type="number"
                      placeholder="Es. 50000"
                      value={filters.salary_max}
                      onChange={(e) => setFilters({ ...filters, salary_max: e.target.value })}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
                    />
                  </div>
                </div>
              </div>

              {activeTab === 'offers' && (
                <div className="border-t pt-4">
                  <h4 className="text-sm font-semibold text-gray-900 mb-3">Modalità di Lavoro</h4>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Lavoro Remoto
                    </label>
                    <select
                      value={filters.remote_work}
                      onChange={(e) => setFilters({ ...filters, remote_work: e.target.value })}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
                    >
                      <option value="">Tutti</option>
                      <option value="true">Si</option>
                      <option value="false">No</option>
                    </select>
                  </div>
                </div>
              )}

              <div className="border-t pt-4">
                <h4 className="text-sm font-semibold text-gray-900 mb-3">Competenze</h4>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Cerca per competenza
                  </label>
                  <input
                    type="text"
                    placeholder="Es. Python, JavaScript, Marketing..."
                    value={filters.skill}
                    onChange={(e) => setFilters({ ...filters, skill: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
                  />
                  <p className="text-xs text-gray-500 mt-1">
                    {activeTab === 'offers' ? 'Cerca offerte che richiedono questa competenza' : 'Cerca candidati con questa competenza'}
                  </p>
                </div>
              </div>

              <button
                onClick={handleReset}
                className="flex items-center gap-2 px-4 py-2 text-gray-700 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors"
              >
                <X className="w-4 h-4" />
                Azzera Filtri
              </button>
            </div>
          )}
        </div>

        {!loading && (
          <div className="flex items-center justify-between mb-4">
            <p className="text-sm text-gray-500">
              {activeTab === 'offers' ? `${jobs.length} offerte trovate` : `${jobSeekers.length} candidati trovati`}
            </p>
            <div className="flex items-center gap-2">
              <ArrowUpDown className="w-4 h-4 text-gray-400" />
              <select
                value={sortBy}
                onChange={(e) => setSortBy(e.target.value)}
                className="text-sm border border-gray-300 rounded-lg px-3 py-1.5 focus:ring-2 focus:ring-green-500 focus:border-transparent bg-white"
              >
                <option value="recent_desc">Dal più recente</option>
                <option value="recent_asc">Dal meno recente</option>
                {activeTab === 'offers' ? (
                  <>
                    <option value="salary_desc">Stipendio più alto</option>
                    <option value="salary_asc">Stipendio più basso</option>
                  </>
                ) : (
                  <>
                    <option value="salary_desc">Retribuzione desiderata alta</option>
                    <option value="salary_asc">Retribuzione desiderata bassa</option>
                  </>
                )}
                <option value="name_asc">Titolo A→Z</option>
                <option value="name_desc">Titolo Z→A</option>
              </select>
            </div>
          </div>
        )}

        {loading ? (
          <div className="text-center py-12">
            <div className="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-green-600"></div>
          </div>
        ) : activeTab === 'offers' ? (
          jobs.length === 0 ? (
            <div className="bg-white rounded-lg shadow-md p-12 text-center">
              <Briefcase className="w-12 h-12 text-gray-400 mx-auto mb-4" />
              <p className="text-gray-600 text-lg">Nessuna opportunità trovata</p>
            </div>
          ) : (
            <div className="space-y-4">
              {sortedJobs.map((job) => (
                <div key={job.id} className="bg-white rounded-lg shadow-md hover:shadow-lg transition-shadow p-6">
                  <div className="flex justify-between items-start mb-4">
                    <div>
                      <h3 className="text-xl font-bold text-gray-900">{job.title}</h3>
                      <p className="text-gray-600 font-medium">{job.company_name || job.business?.name || job.registered_business?.name || 'Azienda'}</p>
                    </div>
                    <span className="px-3 py-1 bg-green-100 text-green-800 text-sm font-medium rounded-full">
                      {job.position_type}
                    </span>
                  </div>

                  <p className="text-gray-700 mb-4 line-clamp-2">{job.description}</p>

                  <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-4">
                    <div className="flex items-center gap-2">
                      <MapPin className="w-4 h-4 text-gray-500" />
                      <span className="text-sm text-gray-600">{job.location}</span>
                    </div>
                    {job.gross_annual_salary && (
                      <div className="flex items-center gap-2">
                        <DollarSign className="w-4 h-4 text-gray-500" />
                        <span className="text-sm text-gray-600">
                          {job.gross_annual_salary.toLocaleString()} {job.salary_currency}/anno
                        </span>
                      </div>
                    )}
                    <div className="text-sm text-gray-600">
                      <span className="font-medium">Esperienza:</span> {job.experience_level}
                    </div>
                    {job.remote_work && (
                      <div className="text-sm text-green-600 font-medium">
                        Lavoro Remoto
                      </div>
                    )}
                  </div>

                  {job.required_skills.length > 0 && (
                    <div className="mb-4 flex flex-wrap gap-2">
                      {job.required_skills.map((skill) => (
                        <span key={skill} className="px-2 py-1 bg-gray-100 text-gray-700 text-xs rounded">
                          {skill}
                        </span>
                      ))}
                    </div>
                  )}

                  {job.benefits.length > 0 && (
                    <div className="mb-4">
                      <p className="text-sm font-medium text-gray-700 mb-2">Benefit:</p>
                      <div className="flex flex-wrap gap-2">
                        {job.benefits.map((benefit, index) => (
                          <span key={index} className="px-2 py-1 bg-green-50 text-green-700 text-xs rounded">
                            {benefit}
                          </span>
                        ))}
                      </div>
                    </div>
                  )}

                  <div className="flex items-center justify-between">
                    <span className="text-xs text-gray-500">
                      Scade il {new Date(job.expires_at).toLocaleDateString('it-IT')}
                    </span>
                    <div className="flex items-center gap-3">
                      {user && profile?.user_type !== 'business' && (
                        <>
                          <FavoriteButton
                            type="job"
                            itemId={job.id}
                            familyMemberId={activeProfile && !activeProfile.isOwner ? activeProfile.id : null}
                          />
                          {viewedJobs.includes(job.id) ? (
                            <div className="flex items-center gap-2 px-4 py-2 bg-green-100 text-green-700 rounded-lg font-medium">
                              <Check className="w-4 h-4" />
                              <span>Visionato</span>
                            </div>
                          ) : (
                            <button
                              onClick={() => handleMarkAsViewed(job.id)}
                              disabled={markingAsViewed === job.id}
                              className="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 font-medium transition-colors disabled:bg-gray-100"
                            >
                              {markingAsViewed === job.id ? 'Salvataggio...' : 'Segna come visionato'}
                            </button>
                          )}
                          <button
                            onClick={() => handleContactEmployer(job.id)}
                            className="flex items-center gap-2 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 font-medium transition-colors"
                          >
                            <MessageCircle className="w-4 h-4" />
                            Contatta
                          </button>
                        </>
                      )}
                    </div>
                  </div>
                </div>
              ))}
            </div>
          )
        ) : (
          jobSeekers.length === 0 ? (
            <div className="bg-white rounded-lg shadow-md p-12 text-center">
              <UserCircle className="w-12 h-12 text-gray-400 mx-auto mb-4" />
              <p className="text-gray-600 text-lg">Nessun annuncio trovato</p>
            </div>
          ) : (
            <div className="space-y-4">
              {sortedJobSeekers.map((jobSeeker) => (
                <JobSeekerCard
                  key={jobSeeker.id}
                  jobSeeker={jobSeeker}
                  onContact={handleContactJobSeeker}
                  showContactButton={user ? profile?.user_type === 'business' : false}
                />
              ))}
            </div>
          )
        )}
      </div>

      {selectedJobId && (
        <JobDetailModal
          jobId={selectedJobId}
          jobs={jobs}
          user={user}
          profile={profile}
          activeProfile={activeProfile}
          viewedJobs={viewedJobs}
          markingAsViewed={markingAsViewed}
          onClose={() => {
            setSelectedJobId(null);
            const url = new URL(window.location.href);
            url.searchParams.delete('job');
            window.history.replaceState({}, '', url.toString());
          }}
          onMarkAsViewed={handleMarkAsViewed}
          onContactEmployer={handleContactEmployer}
        />
      )}
    </div>
  );
}

function JobDetailModal({
  jobId,
  jobs,
  user,
  profile,
  activeProfile,
  viewedJobs,
  markingAsViewed,
  onClose,
  onMarkAsViewed,
  onContactEmployer,
}: {
  jobId: string;
  jobs: JobPosting[];
  user: any;
  profile: any;
  activeProfile: any;
  viewedJobs: string[];
  markingAsViewed: string | null;
  onClose: () => void;
  onMarkAsViewed: (id: string) => void;
  onContactEmployer: (id: string) => void;
}) {
  const [job, setJob] = useState<JobPosting | null>(null);
  const [loadingJob, setLoadingJob] = useState(false);

  useEffect(() => {
    const found = jobs.find((j) => j.id === jobId);
    if (found) {
      setJob(found);
    } else {
      setLoadingJob(true);
      supabase
        .from('job_postings')
        .select(`
          *,
          business:businesses(id, name, owner_id),
          registered_business:registered_businesses(id, name, owner_id)
        `)
        .eq('id', jobId)
        .maybeSingle()
        .then(({ data }) => {
          setJob(data);
          setLoadingJob(false);
        });
    }
  }, [jobId, jobs]);

  useEffect(() => {
    const handleKey = (e: KeyboardEvent) => { if (e.key === 'Escape') onClose(); };
    document.addEventListener('keydown', handleKey);
    return () => document.removeEventListener('keydown', handleKey);
  }, [onClose]);

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm" onClick={onClose}>
      <div
        className="bg-white rounded-2xl shadow-2xl w-full max-w-2xl max-h-[90vh] overflow-y-auto"
        onClick={(e) => e.stopPropagation()}
      >
        {loadingJob || !job ? (
          <div className="flex items-center justify-center h-48">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
          </div>
        ) : (
          <>
            <div className="sticky top-0 bg-white border-b border-gray-100 px-6 py-4 flex items-start justify-between rounded-t-2xl">
              <div>
                <h2 className="text-xl font-bold text-gray-900">{job.title}</h2>
                <p className="text-blue-600 font-medium mt-0.5">
                  {job.company_name || job.business?.name || job.registered_business?.name || 'Azienda'}
                </p>
              </div>
              <button
                onClick={onClose}
                className="ml-4 p-2 rounded-xl text-gray-400 hover:text-gray-600 hover:bg-gray-100 transition-colors"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <div className="px-6 py-5 space-y-5">
              <div className="flex flex-wrap gap-2">
                {job.position_type && (
                  <span className="px-3 py-1 bg-green-100 text-green-800 text-sm font-medium rounded-full">
                    {job.position_type}
                  </span>
                )}
                {job.remote_work && (
                  <span className="px-3 py-1 bg-blue-100 text-blue-800 text-sm font-medium rounded-full">
                    Lavoro Remoto
                  </span>
                )}
                {job.experience_level && (
                  <span className="px-3 py-1 bg-gray-100 text-gray-700 text-sm rounded-full">
                    {job.experience_level}
                  </span>
                )}
              </div>

              <div className="grid grid-cols-2 gap-4">
                {job.location && (
                  <div className="flex items-center gap-2 text-gray-600">
                    <MapPin className="w-4 h-4 text-gray-400 flex-shrink-0" />
                    <span className="text-sm">{job.location}</span>
                  </div>
                )}
                {job.gross_annual_salary && (
                  <div className="flex items-center gap-2 text-gray-600">
                    <DollarSign className="w-4 h-4 text-gray-400 flex-shrink-0" />
                    <span className="text-sm">
                      {job.gross_annual_salary.toLocaleString('it-IT')} {job.salary_currency}/anno
                    </span>
                  </div>
                )}
                {(job.salary_min || job.salary_max) && !job.gross_annual_salary && (
                  <div className="flex items-center gap-2 text-gray-600">
                    <DollarSign className="w-4 h-4 text-gray-400 flex-shrink-0" />
                    <span className="text-sm">
                      {job.salary_min?.toLocaleString('it-IT') || '?'}
                      {job.salary_max ? ` - ${job.salary_max.toLocaleString('it-IT')}` : '+'} {job.salary_currency}
                    </span>
                  </div>
                )}
              </div>

              <div>
                <h3 className="text-sm font-semibold text-gray-900 mb-2">Descrizione</h3>
                <p className="text-gray-700 text-sm leading-relaxed whitespace-pre-line">{job.description}</p>
              </div>

              {job.required_skills && job.required_skills.length > 0 && (
                <div>
                  <h3 className="text-sm font-semibold text-gray-900 mb-2">Competenze richieste</h3>
                  <div className="flex flex-wrap gap-2">
                    {job.required_skills.map((skill) => (
                      <span key={skill} className="px-2 py-1 bg-gray-100 text-gray-700 text-xs rounded-lg">
                        {skill}
                      </span>
                    ))}
                  </div>
                </div>
              )}

              {job.benefits && job.benefits.length > 0 && (
                <div>
                  <h3 className="text-sm font-semibold text-gray-900 mb-2">Benefit</h3>
                  <div className="flex flex-wrap gap-2">
                    {job.benefits.map((benefit, i) => (
                      <span key={i} className="px-2 py-1 bg-green-50 text-green-700 text-xs rounded-lg">
                        {benefit}
                      </span>
                    ))}
                  </div>
                </div>
              )}

              <p className="text-xs text-gray-400">
                Scade il {new Date(job.expires_at).toLocaleDateString('it-IT')}
              </p>

              {user && profile?.user_type !== 'business' && (
                <div className="flex flex-wrap gap-3 pt-2 border-t border-gray-100">
                  <FavoriteButton
                    type="job"
                    itemId={job.id}
                    familyMemberId={activeProfile && !activeProfile.isOwner ? activeProfile.id : null}
                  />
                  {viewedJobs.includes(job.id) ? (
                    <div className="flex items-center gap-2 px-4 py-2 bg-green-100 text-green-700 rounded-lg font-medium text-sm">
                      <Check className="w-4 h-4" />
                      Visionato
                    </div>
                  ) : (
                    <button
                      onClick={() => onMarkAsViewed(job.id)}
                      disabled={markingAsViewed === job.id}
                      className="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 font-medium transition-colors text-sm disabled:opacity-60"
                    >
                      {markingAsViewed === job.id ? 'Salvataggio...' : 'Segna come visionato'}
                    </button>
                  )}
                  <button
                    onClick={() => { onContactEmployer(job.id); onClose(); }}
                    className="flex items-center gap-2 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 font-medium transition-colors text-sm"
                  >
                    <MessageCircle className="w-4 h-4" />
                    Contatta
                  </button>
                </div>
              )}
            </div>
          </>
        )}
      </div>
    </div>
  );
}