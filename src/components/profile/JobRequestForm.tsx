import { useState, useEffect } from 'react';
import { Briefcase, Plus, X, FileEdit as Edit, Trash2, User, Users } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { SearchableSelect } from '../common/SearchableSelect';
import { useToast } from '../common/Toast';

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
  status: string;
  created_at: string;
  category_id: string | null;
  family_member_id: string | null;
  business_categories?: {
    name: string;
  } | null;
}

interface Category {
  id: string;
  name: string;
}

interface FamilyMember {
  id: string;
  first_name: string;
  last_name: string;
  nickname: string;
  avatar_url: string | null;
}

interface JobRequestFormProps {
  customerId: string;
  familyMemberId?: string;
}

export function JobRequestForm({ customerId, familyMemberId }: JobRequestFormProps) {
  const { showToast } = useToast();
  const [jobSeekers, setJobSeekers] = useState<JobSeeker[]>([]);
  const [familyMembers, setFamilyMembers] = useState<FamilyMember[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState<string | null>(null);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    skills: '',
    contract_type: 'Full-time',
    desired_salary_min: '',
    desired_salary_max: '',
    location: '',
    available_from: '',
    experience_years: '',
    education_level: '',
    phone: '',
    email: '',
    category_id: '',
    status: 'active',
  });

  useEffect(() => {
    loadData();
  }, [customerId]);

  const loadData = async () => {
    setLoading(true);
    await Promise.all([loadJobSeekers(), loadFamilyMembers(), loadCategories()]);
    setLoading(false);
  };

  const loadJobSeekers = async () => {
    try {
      let query = supabase
        .from('job_seekers')
        .select(`
          *,
          business_categories(name)
        `)
        .eq('user_id', customerId);

      if (familyMemberId) {
        query = query.eq('family_member_id', familyMemberId);
      }

      const { data, error } = await query.order('created_at', { ascending: false });

      if (error) throw error;
      setJobSeekers(data || []);
    } catch (error) {
      console.error('Error loading job seekers:', error);
    }
  };

  const loadCategories = async () => {
    try {
      const { data } = await supabase
        .from('business_categories')
        .select('id, name')
        .order('name');

      setCategories(data || []);
    } catch (error) {
      console.error('Error loading categories:', error);
    }
  };

  const loadFamilyMembers = async () => {
    try {
      const { data, error } = await supabase
        .from('customer_family_members')
        .select('id, first_name, last_name, nickname, avatar_url')
        .eq('customer_id', customerId)
        .order('created_at', { ascending: true });

      if (error) throw error;
      setFamilyMembers(data || []);
    } catch (error) {
      console.error('Error loading family members:', error);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    try {
      const dataToSave = {
        title: formData.title,
        description: formData.description,
        skills: formData.skills.split(',').map(s => s.trim()).filter(Boolean),
        contract_type: formData.contract_type,
        desired_salary_min: formData.desired_salary_min ? parseFloat(formData.desired_salary_min) : null,
        desired_salary_max: formData.desired_salary_max ? parseFloat(formData.desired_salary_max) : null,
        location: formData.location,
        available_from: formData.available_from || null,
        experience_years: formData.experience_years ? parseInt(formData.experience_years) : 0,
        education_level: formData.education_level || null,
        phone: formData.phone || null,
        email: formData.email || null,
        category_id: formData.category_id || null,
        status: formData.status,
      };

      if (editingId) {
        const { error } = await supabase
          .from('job_seekers')
          .update(dataToSave)
          .eq('id', editingId);

        if (error) throw error;
      } else {
        const { error } = await supabase
          .from('job_seekers')
          .insert({
            user_id: customerId,
            family_member_id: familyMemberId || (showForm === 'main' ? null : showForm),
            ...dataToSave,
          });

        if (error) throw error;
      }

      resetForm();
      loadJobSeekers();
      showToast('Annuncio salvato con successo!', 'success');
    } catch (error: any) {
      console.error('Error saving job seeker:', error);
      showToast(`Errore durante il salvataggio: ${error.message || 'Errore sconosciuto'}`, 'error');
    }
  };

  const handleEdit = (jobSeeker: JobSeeker) => {
    setFormData({
      title: jobSeeker.title,
      description: jobSeeker.description,
      skills: jobSeeker.skills.join(', '),
      contract_type: jobSeeker.contract_type,
      desired_salary_min: jobSeeker.desired_salary_min?.toString() || '',
      desired_salary_max: jobSeeker.desired_salary_max?.toString() || '',
      location: jobSeeker.location,
      available_from: jobSeeker.available_from || '',
      experience_years: jobSeeker.experience_years.toString(),
      education_level: jobSeeker.education_level || '',
      phone: jobSeeker.phone || '',
      email: jobSeeker.email || '',
      category_id: jobSeeker.category_id || '',
      status: jobSeeker.status,
    });
    setEditingId(jobSeeker.id);
    setShowForm(jobSeeker.family_member_id || 'main');
  };

  const handleDelete = async (id: string) => {
    if (!confirm('Sei sicuro di voler eliminare questo annuncio?')) return;

    try {
      const { error } = await supabase
        .from('job_seekers')
        .delete()
        .eq('id', id);

      if (error) throw error;
      loadJobSeekers();
    } catch (error) {
      console.error('Error deleting job seeker:', error);
    }
  };

  const toggleActive = async (id: string, currentStatus: string) => {
    try {
      const newStatus = currentStatus === 'active' ? 'inactive' : 'active';
      const { error } = await supabase
        .from('job_seekers')
        .update({ status: newStatus })
        .eq('id', id);

      if (error) throw error;
      loadJobSeekers();
    } catch (error) {
      console.error('Error toggling job seeker:', error);
    }
  };

  const resetForm = () => {
    setFormData({
      title: '',
      description: '',
      skills: '',
      contract_type: 'Full-time',
      desired_salary_min: '',
      desired_salary_max: '',
      location: '',
      available_from: '',
      experience_years: '',
      education_level: '',
      phone: '',
      email: '',
      category_id: '',
      status: 'active',
    });
    setEditingId(null);
    setShowForm(null);
  };

  const renderJobSeekerSection = (memberId: string | null, memberName: string, avatar?: string | null) => {
    const memberJobs = jobSeekers.filter(
      job => (memberId === null && job.family_member_id === null) || job.family_member_id === memberId
    );
    const isFormOpen = showForm === (memberId || 'main');

    return (
      <div key={memberId || 'main'} className="bg-white rounded-xl shadow-md p-8 mb-8">
        <div className="flex items-center justify-between mb-6">
          <div className="flex items-center gap-3">
            {avatar ? (
              <img src={avatar} alt={memberName} className="w-12 h-12 rounded-full object-cover" />
            ) : (
              <div className="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center">
                {memberId ? (
                  <Users className="w-6 h-6 text-blue-600" />
                ) : (
                  <User className="w-6 h-6 text-blue-600" />
                )}
              </div>
            )}
            <div>
              <h3 className="text-xl font-bold text-gray-900">{memberName}</h3>
              <p className="text-sm text-gray-600">
                {memberJobs.length} {memberJobs.length === 1 ? 'annuncio' : 'annunci'}
              </p>
            </div>
          </div>
          {!isFormOpen && (
            <button
              onClick={() => setShowForm(memberId || 'main')}
              className="flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors font-semibold"
            >
              <Plus className="w-5 h-5" />
              Nuovo Annuncio
            </button>
          )}
        </div>

      {isFormOpen && (
        <form onSubmit={handleSubmit} className="bg-gray-50 rounded-lg p-6 mb-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-semibold text-gray-900">
              {editingId ? 'Modifica Annuncio' : 'Nuovo Annuncio'}
            </h3>
            <button
              type="button"
              onClick={resetForm}
              className="text-gray-500 hover:text-gray-700"
            >
              <X className="w-5 h-5" />
            </button>
          </div>

          <div className="space-y-4">
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Titolo / Posizione Cercata *
              </label>
              <input
                type="text"
                value={formData.title}
                onChange={(e) => setFormData({ ...formData, title: e.target.value })}
                required
                placeholder="Es. Sviluppatore Frontend, Contabile, Cameriere..."
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Categoria Lavorativa
              </label>
              <SearchableSelect
                value={formData.category_id}
                onChange={(value) => setFormData({ ...formData, category_id: value })}
                options={[
                  { value: '', label: 'Seleziona una categoria...' },
                  ...categories.map((cat) => ({
                    value: cat.id,
                    label: cat.name,
                  }))
                ]}
                placeholder="Seleziona una categoria..."
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Descrizione e Esperienza *
              </label>
              <textarea
                value={formData.description}
                onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                required
                rows={6}
                placeholder="Descrivi la tua esperienza, qualifiche e cosa stai cercando..."
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>

            <div className="grid md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Tipo Contratto Cercato *
                </label>
                <select
                  value={formData.contract_type}
                  onChange={(e) => setFormData({ ...formData, contract_type: e.target.value })}
                  required
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                >
                  <option value="Full-time">Full-time</option>
                  <option value="Part-time">Part-time</option>
                  <option value="Contract">Contratto</option>
                  <option value="Freelance">Freelance</option>
                  <option value="Internship">Tirocinio</option>
                </select>
              </div>

              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Città *
                </label>
                <input
                  type="text"
                  value={formData.location}
                  onChange={(e) => setFormData({ ...formData, location: e.target.value })}
                  required
                  placeholder="Es. Milano, Roma..."
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>
            </div>

            <div className="grid md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Telefono (facoltativo)
                </label>
                <input
                  type="tel"
                  value={formData.phone}
                  onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                  placeholder="Es. +39 123 456 7890"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>

              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Email (facoltativo)
                </label>
                <input
                  type="email"
                  value={formData.email}
                  onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                  placeholder="Es. nome@email.com"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Competenze (separate da virgola)
              </label>
              <input
                type="text"
                value={formData.skills}
                onChange={(e) => setFormData({ ...formData, skills: e.target.value })}
                placeholder="Es. JavaScript, Excel, Inglese..."
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>

            <div className="grid md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Stipendio Desiderato Min (€/anno)
                </label>
                <input
                  type="number"
                  value={formData.desired_salary_min}
                  onChange={(e) => setFormData({ ...formData, desired_salary_min: e.target.value })}
                  placeholder="Es. 25000"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>

              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Stipendio Desiderato Max (€/anno)
                </label>
                <input
                  type="number"
                  value={formData.desired_salary_max}
                  onChange={(e) => setFormData({ ...formData, desired_salary_max: e.target.value })}
                  placeholder="Es. 35000"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>
            </div>

            <div className="grid md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Anni di Esperienza
                </label>
                <input
                  type="number"
                  value={formData.experience_years}
                  onChange={(e) => setFormData({ ...formData, experience_years: e.target.value })}
                  placeholder="Es. 3"
                  min="0"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>

              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Disponibile dal
                </label>
                <input
                  type="date"
                  value={formData.available_from}
                  onChange={(e) => setFormData({ ...formData, available_from: e.target.value })}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Livello di Istruzione
              </label>
              <select
                value={formData.education_level}
                onChange={(e) => setFormData({ ...formData, education_level: e.target.value })}
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              >
                <option value="">Seleziona...</option>
                <option value="Licenza Media">Licenza Media</option>
                <option value="Diploma">Diploma</option>
                <option value="Laurea Triennale">Laurea Triennale</option>
                <option value="Laurea Magistrale">Laurea Magistrale</option>
                <option value="Master">Master</option>
                <option value="Dottorato">Dottorato</option>
              </select>
            </div>
          </div>

          <div className="flex gap-3 mt-6">
            <button
              type="submit"
              className="flex-1 bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700 transition-colors font-semibold"
            >
              {editingId ? 'Aggiorna Annuncio' : 'Crea Annuncio'}
            </button>
            <button
              type="button"
              onClick={resetForm}
              className="px-6 bg-gray-200 text-gray-700 py-2 rounded-lg hover:bg-gray-300 transition-colors font-semibold"
            >
              Annulla
            </button>
          </div>
        </form>
      )}

      {memberJobs.length === 0 ? (
        <p className="text-gray-600 text-center py-8">Nessun annuncio creato</p>
      ) : (
        <div className="space-y-4">
          {memberJobs.map((jobSeeker) => (
            <div
              key={jobSeeker.id}
              className={`border-2 rounded-lg p-6 transition-colors ${
                jobSeeker.status === 'active'
                  ? 'border-blue-200 bg-blue-50'
                  : 'border-gray-200 bg-gray-50'
              }`}
            >
              <div className="flex items-start justify-between mb-3">
                <div className="flex-1">
                  <div className="flex items-center gap-3 mb-2">
                    <h3 className="font-bold text-xl text-gray-900">{jobSeeker.title}</h3>
                    <span
                      className={`px-3 py-1 rounded-full text-sm font-semibold ${
                        jobSeeker.status === 'active'
                          ? 'bg-green-100 text-green-700'
                          : 'bg-gray-200 text-gray-600'
                      }`}
                    >
                      {jobSeeker.status === 'active' ? 'Attivo' : 'Non attivo'}
                    </span>
                  </div>
                  <p className="text-sm text-gray-600 mb-1">
                    {jobSeeker.business_categories?.name || 'Categoria non specificata'} • {jobSeeker.location} • {jobSeeker.contract_type}
                  </p>
                  <p className="text-sm text-gray-600">
                    {jobSeeker.experience_years} {jobSeeker.experience_years === 1 ? 'anno' : 'anni'} di esperienza
                  </p>
                  {jobSeeker.education_level && (
                    <p className="text-sm text-gray-600">
                      Istruzione: {jobSeeker.education_level}
                    </p>
                  )}
                </div>
                <div className="flex gap-2">
                  <button
                    onClick={() => handleEdit(jobSeeker)}
                    className="text-blue-600 hover:text-blue-700 p-2"
                    title="Modifica"
                  >
                    <Edit className="w-5 h-5" />
                  </button>
                  <button
                    onClick={() => handleDelete(jobSeeker.id)}
                    className="text-red-600 hover:text-red-700 p-2"
                    title="Elimina"
                  >
                    <Trash2 className="w-5 h-5" />
                  </button>
                </div>
              </div>

              <p className="text-gray-700 leading-relaxed mb-4">{jobSeeker.description}</p>

              {jobSeeker.skills.length > 0 && (
                <div className="mb-4 flex flex-wrap gap-2">
                  {jobSeeker.skills.map((skill, idx) => (
                    <span key={idx} className="px-2 py-1 bg-blue-100 text-blue-700 text-xs rounded">
                      {skill}
                    </span>
                  ))}
                </div>
              )}

              {(jobSeeker.desired_salary_min || jobSeeker.desired_salary_max) && (
                <p className="text-sm text-gray-600 mb-2">
                  Stipendio desiderato: {jobSeeker.desired_salary_min ? `€${jobSeeker.desired_salary_min.toLocaleString()}` : '?'}
                  {' - '}
                  {jobSeeker.desired_salary_max ? `€${jobSeeker.desired_salary_max.toLocaleString()}` : '?'} /anno
                </p>
              )}

              <div className="flex items-center justify-between pt-4 border-t border-gray-200">
                <p className="text-sm text-gray-500">
                  Creato il {new Date(jobSeeker.created_at).toLocaleDateString('it-IT')}
                </p>
                <button
                  onClick={() => toggleActive(jobSeeker.id, jobSeeker.status)}
                  className={`px-4 py-2 rounded-lg font-semibold transition-colors ${
                    jobSeeker.status === 'active'
                      ? 'bg-gray-200 text-gray-700 hover:bg-gray-300'
                      : 'bg-green-600 text-white hover:bg-green-700'
                  }`}
                >
                  {jobSeeker.status === 'active' ? 'Disattiva' : 'Attiva'}
                </button>
              </div>
            </div>
          ))}
        </div>
      )}
      </div>
    );
  };

  if (loading) {
    return (
      <div className="bg-white rounded-xl shadow-md p-8">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div>
      </div>
    );
  }

  if (familyMemberId) {
    const selectedMember = familyMembers.find(m => m.id === familyMemberId);
    if (!selectedMember) return null;

    return (
      <div>
        <div className="border-t-4 border-blue-500 bg-gradient-to-r from-blue-50 to-white rounded-lg p-4 mb-6">
          <h2 className="text-2xl font-bold text-gray-900 flex items-center gap-2">
            <Briefcase className="w-7 h-7 text-blue-600" />
            Annunci "Cerco Lavoro"
          </h2>
          <p className="text-sm text-gray-600 mt-1">Gestisci gli annunci di ricerca lavoro</p>
        </div>

        {renderJobSeekerSection(selectedMember.id, selectedMember.nickname, selectedMember.avatar_url)}
      </div>
    );
  }

  return (
    <div>
      <div className="border-t-4 border-blue-500 bg-gradient-to-r from-blue-50 to-white rounded-lg p-4 mb-6">
        <h2 className="text-2xl font-bold text-gray-900 flex items-center gap-2">
          <Briefcase className="w-7 h-7 text-blue-600" />
          Annunci "Cerco Lavoro"
        </h2>
        <p className="text-sm text-gray-600 mt-1">Gestisci i tuoi annunci di ricerca lavoro</p>
      </div>

      {renderJobSeekerSection(null, 'Account Principale')}
    </div>
  );
}
