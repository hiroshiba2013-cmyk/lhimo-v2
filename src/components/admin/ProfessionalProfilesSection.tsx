import { useState, useEffect } from 'react';
import { Briefcase, Search, MapPin, Star, X, Pencil, Save, Trash2, ChevronDown, ChevronUp, Plus } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useToast } from '../common/Toast';

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
    email: string;
  } | null;
}

export function ProfessionalProfilesSection() {
  const { showToast } = useToast();
  const [profiles, setProfiles] = useState<ProfessionalProfile[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [expandedId, setExpandedId] = useState<string | null>(null);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [editForm, setEditForm] = useState<Partial<ProfessionalProfile>>({});
  const [saving, setSaving] = useState(false);
  const [skillInput, setSkillInput] = useState('');

  useEffect(() => {
    loadProfiles();
  }, []);

  const loadProfiles = async () => {
    setLoading(true);
    try {
      const { data, error } = await supabase
        .from('professional_profiles')
        .select(`
          *,
          profiles!user_id(full_name, nickname, email)
        `)
        .order('created_at', { ascending: false });

      if (error) throw error;
      setProfiles((data as unknown as ProfessionalProfile[]) || []);
    } catch (err) {
      console.error(err);
      showToast('Errore nel caricamento dei profili professionali', 'error');
    } finally {
      setLoading(false);
    }
  };

  const startEdit = (p: ProfessionalProfile) => {
    setEditingId(p.id);
    setEditForm({
      profession: p.profession,
      city: p.city,
      province: p.province,
      region: p.region,
      experience_years: p.experience_years,
      summary: p.summary,
      skills: [...p.skills],
    });
    setSkillInput('');
  };

  const cancelEdit = () => {
    setEditingId(null);
    setEditForm({});
    setSkillInput('');
  };

  const saveEdit = async (id: string) => {
    setSaving(true);
    try {
      const { error } = await supabase
        .from('professional_profiles')
        .update({
          profession: editForm.profession,
          city: editForm.city,
          province: editForm.province,
          region: editForm.region,
          experience_years: Number(editForm.experience_years) || 0,
          summary: editForm.summary,
          skills: editForm.skills,
        })
        .eq('id', id);

      if (error) throw error;
      showToast('Profilo aggiornato', 'success');
      setEditingId(null);
      setEditForm({});
      await loadProfiles();
    } catch (err) {
      console.error(err);
      showToast('Errore nel salvataggio', 'error');
    } finally {
      setSaving(false);
    }
  };

  const deleteProfile = async (id: string, userName: string) => {
    if (!confirm(`Eliminare il profilo professionale di ${userName}? Questa azione è irreversibile.`)) return;
    try {
      const { error } = await supabase
        .from('professional_profiles')
        .delete()
        .eq('id', id);

      if (error) throw error;
      showToast('Profilo eliminato', 'success');
      setExpandedId(null);
      await loadProfiles();
    } catch (err) {
      console.error(err);
      showToast('Errore nell\'eliminazione', 'error');
    }
  };

  const addSkill = () => {
    const s = skillInput.trim();
    if (s && !(editForm.skills || []).includes(s)) {
      setEditForm(prev => ({ ...prev, skills: [...(prev.skills || []), s] }));
    }
    setSkillInput('');
  };

  const removeSkill = (skill: string) => {
    setEditForm(prev => ({ ...prev, skills: (prev.skills || []).filter(s => s !== skill) }));
  };

  const filtered = profiles.filter(p => {
    if (!search) return true;
    const q = search.toLowerCase();
    return (
      p.profession.toLowerCase().includes(q) ||
      (p.profiles?.full_name || '').toLowerCase().includes(q) ||
      (p.profiles?.email || '').toLowerCase().includes(q) ||
      (p.profiles?.nickname || '').toLowerCase().includes(q) ||
      p.city.toLowerCase().includes(q) ||
      p.region.toLowerCase().includes(q)
    );
  });

  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
      {/* Header */}
      <div className="px-6 py-5 border-b border-gray-200 bg-gradient-to-r from-blue-50 to-blue-100">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="p-2 bg-blue-500 rounded-lg">
              <Briefcase className="w-5 h-5 text-white" />
            </div>
            <div>
              <h2 className="text-xl font-bold text-gray-900">Profili Professionali</h2>
              <p className="text-sm text-gray-600">{profiles.length} profili registrati</p>
            </div>
          </div>
          <button
            onClick={loadProfiles}
            className="px-3 py-1.5 text-sm font-medium text-blue-700 bg-blue-50 border border-blue-200 rounded-lg hover:bg-blue-100 transition-colors"
          >
            Aggiorna
          </button>
        </div>
      </div>

      {/* Search */}
      <div className="px-6 py-4 bg-gray-50 border-b border-gray-200">
        <div className="relative max-w-md">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
          <input
            type="text"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Cerca per nome, professione, città..."
            className="w-full pl-9 pr-4 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          />
          {search && (
            <button onClick={() => setSearch('')} className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600">
              <X className="w-4 h-4" />
            </button>
          )}
        </div>
      </div>

      {/* Content */}
      <div className="divide-y divide-gray-100">
        {loading ? (
          <div className="py-16 text-center">
            <div className="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
          </div>
        ) : filtered.length === 0 ? (
          <div className="py-16 text-center">
            <Briefcase className="w-12 h-12 text-gray-300 mx-auto mb-3" />
            <p className="text-gray-500 font-medium">Nessun profilo trovato</p>
            {search && <p className="text-gray-400 text-sm mt-1">Prova a modificare la ricerca</p>}
          </div>
        ) : (
          filtered.map((p) => {
            const isExpanded = expandedId === p.id;
            const isEditing = editingId === p.id;
            const displayName = p.profiles?.nickname || p.profiles?.full_name || 'Utente';
            const location = [p.city, p.province, p.region].filter(Boolean).join(', ');

            return (
              <div key={p.id} className="hover:bg-gray-50 transition-colors">
                {/* Row */}
                <div
                  className="px-6 py-4 flex items-center gap-4 cursor-pointer"
                  onClick={() => {
                    if (isEditing) return;
                    setExpandedId(isExpanded ? null : p.id);
                  }}
                >
                  {/* Avatar */}
                  <div className="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center flex-shrink-0 text-blue-700 font-bold">
                    {displayName.charAt(0).toUpperCase()}
                  </div>

                  {/* Info */}
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2 flex-wrap">
                      <span className="font-semibold text-gray-900 truncate">{displayName}</span>
                      <span className="text-xs text-gray-400">{p.profiles?.email}</span>
                    </div>
                    <div className="flex items-center gap-3 mt-0.5 flex-wrap">
                      <span className="text-sm text-blue-600 font-medium">{p.profession}</span>
                      {location && (
                        <span className="flex items-center gap-1 text-xs text-gray-500">
                          <MapPin className="w-3 h-3" />{location}
                        </span>
                      )}
                      <span className="flex items-center gap-1 text-xs text-gray-500">
                        <Star className="w-3 h-3" />{p.experience_years} {p.experience_years === 1 ? 'anno' : 'anni'}
                      </span>
                    </div>
                  </div>

                  {/* Skills count */}
                  {p.skills.length > 0 && (
                    <span className="hidden sm:inline-flex items-center gap-1 text-xs text-gray-500 bg-gray-100 px-2 py-1 rounded-full flex-shrink-0">
                      {p.skills.length} competenze
                    </span>
                  )}

                  {/* Date */}
                  <span className="hidden md:block text-xs text-gray-400 flex-shrink-0">
                    {new Date(p.created_at).toLocaleDateString('it-IT')}
                  </span>

                  {/* Expand chevron */}
                  {isExpanded ? <ChevronUp className="w-4 h-4 text-gray-400 flex-shrink-0" /> : <ChevronDown className="w-4 h-4 text-gray-400 flex-shrink-0" />}
                </div>

                {/* Expanded detail / edit */}
                {isExpanded && (
                  <div className="px-6 pb-6 bg-blue-50/30 border-t border-blue-100">
                    {isEditing ? (
                      /* ── EDIT MODE ── */
                      <div className="mt-4 space-y-4">
                        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                          <div>
                            <label className="block text-xs font-semibold text-gray-600 mb-1">Professione *</label>
                            <input
                              type="text"
                              value={editForm.profession || ''}
                              onChange={(e) => setEditForm(prev => ({ ...prev, profession: e.target.value }))}
                              className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                            />
                          </div>
                          <div>
                            <label className="block text-xs font-semibold text-gray-600 mb-1">Anni di esperienza</label>
                            <input
                              type="number"
                              min="0"
                              max="60"
                              value={editForm.experience_years ?? 0}
                              onChange={(e) => setEditForm(prev => ({ ...prev, experience_years: parseInt(e.target.value) || 0 }))}
                              className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                            />
                          </div>
                          <div>
                            <label className="block text-xs font-semibold text-gray-600 mb-1">Città</label>
                            <input
                              type="text"
                              value={editForm.city || ''}
                              onChange={(e) => setEditForm(prev => ({ ...prev, city: e.target.value }))}
                              className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                            />
                          </div>
                          <div>
                            <label className="block text-xs font-semibold text-gray-600 mb-1">Provincia</label>
                            <input
                              type="text"
                              value={editForm.province || ''}
                              onChange={(e) => setEditForm(prev => ({ ...prev, province: e.target.value }))}
                              className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                            />
                          </div>
                          <div>
                            <label className="block text-xs font-semibold text-gray-600 mb-1">Regione</label>
                            <input
                              type="text"
                              value={editForm.region || ''}
                              onChange={(e) => setEditForm(prev => ({ ...prev, region: e.target.value }))}
                              className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                            />
                          </div>
                        </div>

                        <div>
                          <label className="block text-xs font-semibold text-gray-600 mb-1">Descrizione</label>
                          <textarea
                            rows={3}
                            value={editForm.summary || ''}
                            onChange={(e) => setEditForm(prev => ({ ...prev, summary: e.target.value }))}
                            className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
                          />
                        </div>

                        <div>
                          <label className="block text-xs font-semibold text-gray-600 mb-1">Competenze</label>
                          <div className="flex gap-2 mb-2">
                            <input
                              type="text"
                              value={skillInput}
                              onChange={(e) => setSkillInput(e.target.value)}
                              onKeyDown={(e) => { if (e.key === 'Enter') { e.preventDefault(); addSkill(); } }}
                              placeholder="Aggiungi competenza"
                              className="flex-1 px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                            />
                            <button type="button" onClick={addSkill} className="px-3 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                              <Plus className="w-4 h-4" />
                            </button>
                          </div>
                          <div className="flex flex-wrap gap-2">
                            {(editForm.skills || []).map(skill => (
                              <span key={skill} className="inline-flex items-center gap-1 px-2.5 py-1 bg-blue-50 text-blue-700 text-xs font-medium rounded-full border border-blue-100">
                                {skill}
                                <button type="button" onClick={() => removeSkill(skill)} className="hover:text-blue-900">
                                  <X className="w-3 h-3" />
                                </button>
                              </span>
                            ))}
                          </div>
                        </div>

                        <div className="flex gap-3 pt-2">
                          <button
                            onClick={cancelEdit}
                            className="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors"
                          >
                            Annulla
                          </button>
                          <button
                            onClick={() => saveEdit(p.id)}
                            disabled={saving}
                            className="flex items-center gap-2 px-4 py-2 text-sm font-semibold text-white bg-blue-600 rounded-lg hover:bg-blue-700 transition-colors disabled:opacity-60"
                          >
                            <Save className="w-4 h-4" />
                            {saving ? 'Salvataggio...' : 'Salva'}
                          </button>
                        </div>
                      </div>
                    ) : (
                      /* ── VIEW MODE ── */
                      <div className="mt-4 space-y-4">
                        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
                          <div className="bg-white rounded-lg px-4 py-3 border border-gray-100">
                            <p className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-1">Professione</p>
                            <p className="text-sm font-semibold text-gray-900">{p.profession}</p>
                          </div>
                          <div className="bg-white rounded-lg px-4 py-3 border border-gray-100">
                            <p className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-1">Esperienza</p>
                            <p className="text-sm font-semibold text-gray-900">{p.experience_years} {p.experience_years === 1 ? 'anno' : 'anni'}</p>
                          </div>
                          {location && (
                            <div className="bg-white rounded-lg px-4 py-3 border border-gray-100">
                              <p className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-1">Localita</p>
                              <p className="text-sm font-semibold text-gray-900">{location}</p>
                            </div>
                          )}
                          <div className="bg-white rounded-lg px-4 py-3 border border-gray-100">
                            <p className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-1">Utente</p>
                            <p className="text-sm font-semibold text-gray-900">{p.profiles?.full_name}</p>
                            <p className="text-xs text-gray-500">{p.profiles?.email}</p>
                          </div>
                          <div className="bg-white rounded-lg px-4 py-3 border border-gray-100">
                            <p className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-1">Creato il</p>
                            <p className="text-sm font-semibold text-gray-900">{new Date(p.created_at).toLocaleDateString('it-IT', { day: 'numeric', month: 'long', year: 'numeric' })}</p>
                          </div>
                        </div>

                        {p.summary && (
                          <div className="bg-white rounded-lg px-4 py-3 border border-gray-100">
                            <p className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-2">Descrizione</p>
                            <p className="text-sm text-gray-700 leading-relaxed">{p.summary}</p>
                          </div>
                        )}

                        {p.skills.length > 0 && (
                          <div className="bg-white rounded-lg px-4 py-3 border border-gray-100">
                            <p className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-2">Competenze</p>
                            <div className="flex flex-wrap gap-2">
                              {p.skills.map(skill => (
                                <span key={skill} className="px-2.5 py-1 bg-blue-50 text-blue-700 text-xs font-medium rounded-full border border-blue-100">
                                  {skill}
                                </span>
                              ))}
                            </div>
                          </div>
                        )}

                        <div className="flex gap-3">
                          <button
                            onClick={() => startEdit(p)}
                            className="flex items-center gap-2 px-4 py-2 text-sm font-medium text-blue-700 bg-blue-50 border border-blue-200 rounded-lg hover:bg-blue-100 transition-colors"
                          >
                            <Pencil className="w-4 h-4" />
                            Modifica
                          </button>
                          <button
                            onClick={() => deleteProfile(p.id, displayName)}
                            className="flex items-center gap-2 px-4 py-2 text-sm font-medium text-red-700 bg-red-50 border border-red-200 rounded-lg hover:bg-red-100 transition-colors"
                          >
                            <Trash2 className="w-4 h-4" />
                            Elimina
                          </button>
                        </div>
                      </div>
                    )}
                  </div>
                )}
              </div>
            );
          })
        )}
      </div>

      {!loading && filtered.length > 0 && (
        <div className="px-6 py-3 border-t border-gray-100 bg-gray-50 text-xs text-gray-400 text-right">
          {filtered.length} {filtered.length === 1 ? 'profilo' : 'profili'}{search ? ` su ${profiles.length}` : ''}
        </div>
      )}
    </div>
  );
}
