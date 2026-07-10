import { useState, useEffect, useRef } from 'react';
import { Briefcase, Plus, X, FileEdit as Edit, Trash2, Users } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { SearchableSelect } from '../common/SearchableSelect';
import { useToast } from '../common/Toast';

interface JobPosting {
  id: string;
  title: string;
  description: string;
  position_type: string;
  salary_min: number | null;
  salary_max: number | null;
  salary_currency: string;
  location: string;
  required_skills: string[];
  experience_level: string;
  education_level: string | null;
  expires_at: string;
  status: string;
  approval_status?: string;
  created_at: string;
  business_location_id?: string | null;
  registered_business_location_id?: string | null;
}

interface BusinessLocation {
  id: string;
  name: string | null;
  internal_name: string | null;
  address: string;
  city: string;
}

interface BusinessJobPostingFormProps {
  businessId: string;
  selectedLocationId?: string;
  isRegisteredBusiness?: boolean;
}

export function BusinessJobPostingForm({ businessId, selectedLocationId, isRegisteredBusiness: isRegisteredProp = false }: BusinessJobPostingFormProps) {
  const { showToast } = useToast();
  const [jobPostings, setJobPostings] = useState<JobPosting[]>([]);
  const [businessLocations, setBusinessLocations] = useState<BusinessLocation[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [isRegisteredBusiness, setIsRegisteredBusiness] = useState(isRegisteredProp);
  const isRegisteredRef = useRef(isRegisteredProp);
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    position_type: 'Full-time',
    salary_min: '',
    salary_max: '',
    salary_currency: 'EUR',
    location: '',
    required_skills: '',
    experience_level: 'Mid',
    education_level: '',
    expires_at: '',
    status: 'active',
    business_location_id: '',
  });

  useEffect(() => {
    const detectAndLoad = async () => {
      // Detect if this businessId belongs to registered_businesses
      const { data: regData } = await supabase
        .from('registered_businesses')
        .select('id')
        .eq('id', businessId)
        .maybeSingle();
      const isReg = !!regData;
      setIsRegisteredBusiness(isReg);
      isRegisteredRef.current = isReg;
      await loadJobPostingsFor(isReg);
      await loadBusinessLocationsFor(isReg);
    };
    detectAndLoad();
  }, [businessId, selectedLocationId]);

  useEffect(() => {
    if (selectedLocationId && !editingId) {
      setFormData(prev => ({ ...prev, business_location_id: selectedLocationId }));
    }
  }, [selectedLocationId, editingId]);

  const loadJobPostingsFor = async (isReg: boolean) => {
    try {
      const businessIdColumn = isReg ? 'registered_business_id' : 'business_id';
      const locationCol = isReg ? 'registered_business_location_id' : 'business_location_id';

      let query = supabase
        .from('job_postings')
        .select('*')
        .eq(businessIdColumn, businessId)
        .order('created_at', { ascending: false });

      if (selectedLocationId) {
        query = query.eq(locationCol, selectedLocationId);
      }

      const { data, error } = await query;
      if (error) throw error;
      setJobPostings(data || []);
    } catch (error) {
      console.error('Error loading job postings:', error);
    } finally {
      setLoading(false);
    }
  };

  const loadJobPostings = () => loadJobPostingsFor(isRegisteredBusiness);

  const loadBusinessLocationsFor = async (isReg: boolean) => {
    try {
      const table = isReg ? 'registered_business_locations' : 'business_locations';
      const addressCol = isReg ? 'street' : 'address';
      const { data, error } = await supabase
        .from(table)
        .select(`id, name, internal_name, ${addressCol}, city`)
        .eq('business_id', businessId)
        .order('created_at', { ascending: true });

      if (error) throw error;
      const normalized = (data || []).map((l: any) => ({
        ...l,
        address: l.address ?? l.street,
      }));
      setBusinessLocations(normalized);
    } catch (error) {
      console.error('Error loading business locations:', error);
    }
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    try {
      const isReg = isRegisteredRef.current;
      const locationIdField = formData.business_location_id
        ? isReg
          ? { registered_business_location_id: formData.business_location_id, business_location_id: null }
          : { business_location_id: formData.business_location_id }
        : { business_location_id: null };

      const postingData = {
        title: formData.title,
        description: formData.description,
        position_type: formData.position_type,
        salary_min: formData.salary_min ? parseFloat(formData.salary_min) : null,
        salary_max: formData.salary_max ? parseFloat(formData.salary_max) : null,
        salary_currency: formData.salary_currency,
        location: formData.location,
        required_skills: formData.required_skills.split(',').map(s => s.trim()).filter(s => s),
        experience_level: formData.experience_level,
        education_level: formData.education_level || null,
        expires_at: formData.expires_at,
        status: formData.status,
        ...locationIdField,
      };

      if (editingId) {
        const { error } = await supabase
          .from('job_postings')
          .update(postingData)
          .eq('id', editingId);

        if (error) throw error;
      } else {
        const businessIdField = isReg
          ? { registered_business_id: businessId }
          : { business_id: businessId };

        const { error } = await supabase
          .from('job_postings')
          .insert({
            ...businessIdField,
            ...postingData,
            status: 'pending',
            approval_status: 'pending',
          });

        if (error) throw error;
        showToast('Annuncio di lavoro inviato con successo! Sarà visibile dopo l\'approvazione da parte dell\'amministratore.', 'success');
      }

      resetForm();
      loadJobPostings();
    } catch (error) {
      console.error('Error saving job posting:', error);
      showToast('Errore durante il salvataggio', 'error');
    }
  };

  const handleEdit = (posting: JobPosting) => {
    setFormData({
      title: posting.title,
      description: posting.description,
      position_type: posting.position_type,
      salary_min: posting.salary_min?.toString() || '',
      salary_max: posting.salary_max?.toString() || '',
      salary_currency: posting.salary_currency,
      location: posting.location,
      required_skills: posting.required_skills.join(', '),
      experience_level: posting.experience_level,
      education_level: posting.education_level || '',
      expires_at: posting.expires_at.split('T')[0],
      status: posting.status,
      business_location_id: posting.business_location_id || '',
    });
    setEditingId(posting.id);
    setShowForm(true);
  };

  const handleDelete = async (id: string) => {
    if (!confirm('Sei sicuro di voler eliminare questo annuncio?')) return;

    try {
      const { error } = await supabase
        .from('job_postings')
        .delete()
        .eq('id', id);

      if (error) throw error;
      loadJobPostings();
    } catch (error) {
      console.error('Error deleting job posting:', error);
    }
  };

  const toggleStatus = async (id: string, currentStatus: string) => {
    try {
      const newStatus = currentStatus === 'active' ? 'closed' : 'active';
      const { error } = await supabase
        .from('job_postings')
        .update({ status: newStatus })
        .eq('id', id);

      if (error) throw error;
      loadJobPostings();
    } catch (error) {
      console.error('Error toggling job posting:', error);
    }
  };

  const resetForm = () => {
    setFormData({
      title: '',
      description: '',
      position_type: 'Full-time',
      salary_min: '',
      salary_max: '',
      salary_currency: 'EUR',
      location: '',
      required_skills: '',
      experience_level: 'Mid',
      education_level: '',
      expires_at: '',
      status: 'active',
      business_location_id: selectedLocationId || '',
    });
    setEditingId(null);
    setShowForm(false);
  };

  const filteredJobPostings = jobPostings.filter((job) => {
    if (!selectedLocationId) return true;
    if (isRegisteredBusiness) return job.registered_business_location_id === selectedLocationId;
    return job.business_location_id === selectedLocationId;
  });

  if (loading) {
    return (
      <div className="bg-white rounded-xl shadow-md p-8">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div>
      </div>
    );
  }

  return (
    <div className="bg-white rounded-xl shadow-md p-8">
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <Briefcase className="w-6 h-6 text-blue-600" />
          <h2 className="text-2xl font-bold text-gray-900">Annunci di Ricerca Personale</h2>
        </div>
        {!showForm && (
          <button
            onClick={() => setShowForm(true)}
            className="flex items-center gap-2 bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors font-semibold shadow-md"
          >
            <Plus className="w-5 h-5" />
            Nuovo Annuncio
          </button>
        )}
      </div>

      {showForm && (
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

          <div className="grid md:grid-cols-2 gap-4 mb-4">
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Titolo Posizione
              </label>
              <input
                type="text"
                name="title"
                value={formData.title}
                onChange={handleChange}
                required
                placeholder="Es. Sviluppatore Full Stack"
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Tipo Contratto
              </label>
              <SearchableSelect
                name="position_type"
                value={formData.position_type}
                onChange={(value) => setFormData(prev => ({ ...prev, position_type: value }))}
                required
                options={[
                  { value: 'Full-time', label: 'Full-time' },
                  { value: 'Part-time', label: 'Part-time' },
                  { value: 'Contract', label: 'Contratto' },
                  { value: 'Freelance', label: 'Freelance' },
                  { value: 'Internship', label: 'Stage' },
                ]}
                placeholder="Seleziona tipo contratto"
              />
            </div>
          </div>

          <div className="mb-4">
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              Descrizione e Requisiti
            </label>
            <textarea
              name="description"
              value={formData.description}
              onChange={handleChange}
              required
              rows={6}
              placeholder="Descrivi la posizione, responsabilità, requisiti..."
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <div className="grid md:grid-cols-3 gap-4 mb-4">
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Salario Min (€)
              </label>
              <input
                type="number"
                name="salary_min"
                value={formData.salary_min}
                onChange={handleChange}
                min="0"
                step="1000"
                placeholder="30000"
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Salario Max (€)
              </label>
              <input
                type="number"
                name="salary_max"
                value={formData.salary_max}
                onChange={handleChange}
                min="0"
                step="1000"
                placeholder="50000"
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Livello Esperienza
              </label>
              <SearchableSelect
                name="experience_level"
                value={formData.experience_level}
                onChange={(value) => setFormData(prev => ({ ...prev, experience_level: value }))}
                required
                options={[
                  { value: 'Junior', label: 'Junior' },
                  { value: 'Mid', label: 'Mid' },
                  { value: 'Senior', label: 'Senior' },
                  { value: 'Lead', label: 'Lead' },
                ]}
                placeholder="Seleziona livello esperienza"
              />
            </div>
          </div>

          <div className="mb-4">
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              Titolo di Studio
            </label>
            <SearchableSelect
              name="education_level"
              value={formData.education_level}
              onChange={(value) => setFormData(prev => ({ ...prev, education_level: value }))}
              options={[
                { value: '', label: 'Non specificato' },
                { value: 'Nessuno', label: 'Nessun titolo richiesto' },
                { value: 'Licenza Media', label: 'Licenza Media' },
                { value: 'Diploma', label: 'Diploma' },
                { value: 'Laurea Triennale', label: 'Laurea Triennale' },
                { value: 'Laurea Magistrale', label: 'Laurea Magistrale' },
                { value: 'Master/Dottorato', label: 'Master/Dottorato' },
              ]}
              placeholder="Non specificato"
            />
          </div>

          {businessLocations.length > 0 && (
            <div className="mb-4">
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Sede (Opzionale)
              </label>
              <select
                name="business_location_id"
                value={formData.business_location_id}
                onChange={handleChange}
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              >
                <option value="">Sede principale / Tutte le sedi</option>
                {businessLocations.map((location, index) => (
                  <option key={location.id} value={location.id}>
                    {location.internal_name || `Sede ${index + 1}`} - {location.name || location.city}
                  </option>
                ))}
              </select>
              {selectedLocationId && formData.business_location_id === selectedLocationId && !editingId ? (
                <p className="text-xs text-blue-600 mt-1 font-medium">
                  Sede pre-selezionata in base al filtro attivo. Puoi modificarla se necessario.
                </p>
              ) : (
                <p className="text-xs text-gray-600 mt-1">
                  Lascia vuoto se l'annuncio è per la sede principale o per tutte le sedi
                </p>
              )}
            </div>
          )}

          <div className="grid md:grid-cols-2 gap-4 mb-6">
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Località
              </label>
              <input
                type="text"
                name="location"
                value={formData.location}
                onChange={handleChange}
                required
                placeholder="Es. Milano, Remoto"
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Data Scadenza
              </label>
              <input
                type="date"
                name="expires_at"
                value={formData.expires_at}
                onChange={handleChange}
                required
                min={new Date().toISOString().split('T')[0]}
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>

            <div className="md:col-span-2">
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Competenze Richieste (separate da virgola)
              </label>
              <input
                type="text"
                name="required_skills"
                value={formData.required_skills}
                onChange={handleChange}
                placeholder="Es. React, Node.js, PostgreSQL"
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>
          </div>

          <div className="flex gap-3">
            <button
              type="submit"
              className="flex-1 bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700 transition-colors font-semibold"
            >
              {editingId ? 'Aggiorna Annuncio' : 'Pubblica Annuncio'}
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

      {filteredJobPostings.length === 0 ? (
        <p className="text-gray-600 text-center py-8">
          {selectedLocationId ? 'Nessun annuncio per questa sede' : 'Nessun annuncio pubblicato'}
        </p>
      ) : (
        <div className="space-y-3">
          {filteredJobPostings.map((posting) => (
            <div
              key={posting.id}
              className={`border rounded-lg p-4 transition-colors ${
                posting.approval_status === 'pending' || posting.status === 'pending'
                  ? 'border-yellow-200 bg-yellow-50'
                  : posting.status === 'active'
                  ? 'border-green-200 bg-green-50'
                  : 'border-gray-200 bg-gray-50'
              }`}
            >
              {/* Header row: title + status + actions */}
              <div className="flex items-center justify-between gap-3 mb-2">
                <div className="flex items-center gap-2 flex-1 min-w-0">
                  <h3 className="font-semibold text-base text-gray-900 truncate">{posting.title}</h3>
                  <span className={`flex-shrink-0 px-2 py-0.5 rounded-full text-xs font-semibold ${
                    posting.approval_status === 'pending' || posting.status === 'pending'
                      ? 'bg-yellow-100 text-yellow-700'
                      : posting.approval_status === 'rejected'
                      ? 'bg-red-100 text-red-700'
                      : posting.status === 'active'
                      ? 'bg-green-100 text-green-700'
                      : 'bg-gray-200 text-gray-600'
                  }`}>
                    {posting.approval_status === 'pending' || posting.status === 'pending'
                      ? 'In attesa'
                      : posting.approval_status === 'rejected'
                      ? 'Non approvato'
                      : posting.status === 'active' ? 'Attivo' : 'Chiuso'}
                  </span>
                </div>
                <div className="flex items-center gap-1 flex-shrink-0">
                  <button onClick={() => handleEdit(posting)} className="text-blue-600 hover:text-blue-700 p-1.5 rounded hover:bg-blue-50" title="Modifica">
                    <Edit className="w-4 h-4" />
                  </button>
                  <button onClick={() => handleDelete(posting.id)} className="text-red-600 hover:text-red-700 p-1.5 rounded hover:bg-red-50" title="Elimina">
                    <Trash2 className="w-4 h-4" />
                  </button>
                </div>
              </div>

              {/* Tags row */}
              <div className="flex flex-wrap gap-1.5 mb-2">
                <span className="px-2 py-0.5 bg-blue-100 text-blue-700 rounded-full text-xs font-medium">{posting.position_type}</span>
                <span className="px-2 py-0.5 bg-gray-100 text-gray-700 rounded-full text-xs font-medium">{posting.experience_level}</span>
                {posting.education_level && (
                  <span className="px-2 py-0.5 bg-emerald-100 text-emerald-700 rounded-full text-xs font-medium">{posting.education_level}</span>
                )}
                <span className="px-2 py-0.5 bg-gray-100 text-gray-700 rounded-full text-xs font-medium">{posting.location}</span>
                {(posting.salary_min || posting.salary_max) && (
                  <span className="px-2 py-0.5 bg-green-100 text-green-700 rounded-full text-xs font-semibold">
                    {posting.salary_min?.toLocaleString()} - {posting.salary_max?.toLocaleString()} {posting.salary_currency}
                  </span>
                )}
              </div>

              {/* Description — capped at 2 lines */}
              <p className="text-sm text-gray-600 leading-relaxed mb-2 line-clamp-2">
                {posting.description}
              </p>

              {/* Skills */}
              {posting.required_skills.length > 0 && (
                <div className="flex flex-wrap gap-1.5 mb-2">
                  {posting.required_skills.map((skill, index) => (
                    <span key={index} className="px-2 py-0.5 bg-blue-50 text-blue-700 rounded-full text-xs font-medium">
                      {skill}
                    </span>
                  ))}
                </div>
              )}

              {/* Footer row */}
              <div className="flex items-center justify-between pt-2 border-t border-gray-200">
                <div className="flex items-center gap-3 text-xs text-gray-500">
                  <span>Scade: {new Date(posting.expires_at).toLocaleDateString('it-IT')}</span>
                  <span className="flex items-center gap-1">
                    <Users className="w-3 h-3" />
                    Candidature
                  </span>
                </div>
                <button
                  onClick={() => toggleStatus(posting.id, posting.status)}
                  className={`px-3 py-1.5 rounded-lg text-xs font-semibold transition-colors ${
                    posting.status === 'active'
                      ? 'bg-gray-200 text-gray-700 hover:bg-gray-300'
                      : 'bg-green-600 text-white hover:bg-green-700'
                  }`}
                >
                  {posting.status === 'active' ? 'Chiudi' : 'Riattiva'}
                </button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
