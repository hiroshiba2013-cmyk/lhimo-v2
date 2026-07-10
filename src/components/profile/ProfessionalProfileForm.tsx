import { useState, useEffect } from 'react';
import { X, Save, Briefcase, MapPin, Star, FileText } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useAuth } from '../../contexts/AuthContext';
import { useToast } from '../common/Toast';
import { ITALIAN_REGIONS } from '../../lib/cities';
import { ItalianCityProvinceSelect } from '../common/ItalianCityProvinceSelect';

interface ProfessionalProfile {
  id?: string;
  user_id: string;
  family_member_id?: string | null;
  profession: string;
  city: string;
  province: string;
  region: string;
  experience_years: number;
  summary: string;
  skills: string[];
}

interface ProfessionalProfileFormProps {
  onSaved: (profile: ProfessionalProfile) => void;
  onCancel?: () => void;
  existingProfile?: ProfessionalProfile | null;
  familyMemberId?: string | null;
  familyMemberName?: string;
}

export function ProfessionalProfileForm({ onSaved, onCancel, existingProfile, familyMemberId, familyMemberName }: ProfessionalProfileFormProps) {
  const { user } = useAuth();
  const { showToast } = useToast();
  const [saving, setSaving] = useState(false);

  const [form, setForm] = useState({
    profession: existingProfile?.profession || '',
    city: existingProfile?.city || '',
    province: existingProfile?.province || '',
    region: existingProfile?.region || '',
    experience_years: existingProfile?.experience_years ?? 0,
    summary: existingProfile?.summary || '',
    skillsText: (existingProfile?.skills || []).join(', '),
  });

  useEffect(() => {
    if (existingProfile) {
      setForm({
        profession: existingProfile.profession,
        city: existingProfile.city,
        province: existingProfile.province,
        region: existingProfile.region,
        experience_years: existingProfile.experience_years,
        summary: existingProfile.summary,
        skillsText: (existingProfile.skills || []).join(', '),
      });
    }
  }, [existingProfile]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user) return;

    if (!form.profession.trim()) {
      showToast('Inserisci la tua professione', 'error');
      return;
    }

    setSaving(true);

    try {
      const payload = {
        user_id: user.id,
        family_member_id: familyMemberId ?? null,
        profession: form.profession.trim(),
        city: form.city.trim(),
        province: form.province.trim(),
        region: form.region.trim(),
        experience_years: Number(form.experience_years) || 0,
        summary: form.summary.trim(),
        skills: form.skillsText.split(',').map(s => s.trim()).filter(Boolean),
      };

      let result;
      if (existingProfile?.id) {
        result = await supabase
          .from('professional_profiles')
          .update(payload)
          .eq('id', existingProfile.id)
          .select()
          .single();
      } else {
        result = await supabase
          .from('professional_profiles')
          .insert(payload)
          .select()
          .single();
      }

      if (result.error) throw result.error;
      showToast('Profilo professionale salvato', 'success');
      onSaved(result.data);
    } catch (err: any) {
      console.error(err);
      showToast('Errore nel salvataggio del profilo', 'error');
    } finally {
      setSaving(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      <div className="flex items-center justify-between">
        <h3 className="text-lg font-bold text-gray-900">
          {existingProfile ? 'Modifica Profilo Professionale' : 'Crea Profilo Professionale'}
          {familyMemberName && <span className="text-blue-600"> — {familyMemberName}</span>}
        </h3>
        {onCancel && (
          <button type="button" onClick={onCancel} className="text-gray-400 hover:text-gray-600 transition-colors">
            <X className="w-5 h-5" />
          </button>
        )}
      </div>

      <p className="text-sm text-gray-500 bg-blue-50 border border-blue-100 rounded-lg px-4 py-3">
        Il profilo professionale e visibile solo agli utenti business. Serve a presentarti come candidato e viene mostrato quando qualcuno clicca sul tuo nome negli annunci cerco lavoro.
      </p>

      {/* Profession */}
      <div>
        <label className="block text-sm font-semibold text-gray-700 mb-1.5">
          <span className="flex items-center gap-1.5"><Briefcase className="w-4 h-4" /> Professione <span className="text-red-500">*</span></span>
        </label>
        <input
          type="text"
          value={form.profession}
          onChange={(e) => setForm(prev => ({ ...prev, profession: e.target.value }))}
          placeholder="Es. Sviluppatore Web, Elettricista, Commercialista..."
          className="w-full px-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm"
          required
        />
      </div>

      {/* Experience */}
      <div>
        <label className="block text-sm font-semibold text-gray-700 mb-1.5">
          <span className="flex items-center gap-1.5"><Star className="w-4 h-4" /> Anni di esperienza</span>
        </label>
        <input
          type="number"
          min="0"
          max="60"
          value={form.experience_years}
          onChange={(e) => setForm(prev => ({ ...prev, experience_years: parseInt(e.target.value) || 0 }))}
          className="w-full px-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm"
        />
      </div>

      {/* Summary */}
      <div>
        <label className="block text-sm font-semibold text-gray-700 mb-1.5">
          <span className="flex items-center gap-1.5"><FileText className="w-4 h-4" /> Breve descrizione</span>
        </label>
        <textarea
          rows={4}
          value={form.summary}
          onChange={(e) => setForm(prev => ({ ...prev, summary: e.target.value }))}
          placeholder="Descrivi la tua esperienza, i tuoi punti di forza e cosa stai cercando..."
          className="w-full px-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm resize-none"
        />
      </div>

      {/* Location */}
      <div>
        <label className="block text-sm font-semibold text-gray-700 mb-1.5">
          <span className="flex items-center gap-1.5"><MapPin className="w-4 h-4" /> Localita</span>
        </label>
        <div className="space-y-3">
          <select
            value={form.region}
            onChange={(e) => setForm(prev => ({ ...prev, region: e.target.value, province: '', city: '' }))}
            className="w-full px-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm bg-white"
          >
            <option value="">Seleziona regione</option>
            {ITALIAN_REGIONS.map(r => <option key={r} value={r}>{r}</option>)}
          </select>
          <ItalianCityProvinceSelect
            province={form.province}
            city={form.city}
            region={form.region}
            onProvinceChange={(prov) => setForm(prev => ({ ...prev, province: prov, city: '' }))}
            onCityChange={(city) => setForm(prev => ({ ...prev, city }))}
          />
        </div>
      </div>

      {/* Skills */}
      <div>
        <label className="block text-sm font-semibold text-gray-700 mb-1.5">Competenze</label>
        <textarea
          rows={3}
          value={form.skillsText}
          onChange={(e) => setForm(prev => ({ ...prev, skillsText: e.target.value }))}
          placeholder="Es. JavaScript, Excel, Inglese, Saldatura, AutoCAD..."
          className="w-full px-3 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm resize-none"
        />
        <p className="text-xs text-gray-400 mt-1">Scrivi le tue competenze separate da virgola</p>
      </div>

      {/* Actions */}
      <div className="flex gap-3 pt-2">
        {onCancel && (
          <button
            type="button"
            onClick={onCancel}
            className="flex-1 px-4 py-2.5 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 font-medium text-sm transition-colors"
          >
            Annulla
          </button>
        )}
        <button
          type="submit"
          disabled={saving}
          className="flex-1 flex items-center justify-center gap-2 px-4 py-2.5 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-semibold text-sm transition-colors disabled:opacity-60"
        >
          <Save className="w-4 h-4" />
          {saving ? 'Salvataggio...' : 'Salva Profilo'}
        </button>
      </div>
    </form>
  );
}
