import { useState, useEffect } from 'react';
import { X, Building, MapPin, Phone, Mail, Globe, Award, Clock } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { CategoryHierarchySelect } from '../common/CategoryHierarchySelect';
import { ItalianCityProvinceSelect } from '../common/ItalianCityProvinceSelect';
import { useItalianLocations } from '../../hooks/useItalianLocations';
import { useToast } from '../common/Toast';

interface UserAddBusinessModalProps {
  userId: string;
  familyMemberId?: string | null;
  onSuccess: () => void;
  onCancel: () => void;
}

interface Category {
  id: string;
  name: string;
  parent_id: string | null;
}

export function UserAddBusinessModal({ userId, familyMemberId, onSuccess, onCancel }: UserAddBusinessModalProps) {
  const { showToast } = useToast();
  const [loading, setLoading] = useState(false);
  const [categories, setCategories] = useState<Category[]>([]);
  const { regions } = useItalianLocations();

  const [form, setForm] = useState({
    name: '',
    category_id: '',
    street: '',
    city: '',
    province: '',
    provinceCode: '',
    region: '',
    postal_code: '',
    phone: '',
    email: '',
    website: '',
  });

  useEffect(() => {
    supabase.from('business_categories').select('id, name, parent_id').order('name').then(({ data }) => {
      if (data) setCategories(data);
    });
  }, []);

  const hasContact = !!(form.phone.trim() || form.email.trim() || form.website.trim());
  const expectedPoints = hasContact ? 25 : 10;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!form.name.trim()) return;
    setLoading(true);

    try {
      // Check duplicate
      const { data: existing } = await supabase
        .from('unclaimed_business_locations')
        .select('id, name')
        .ilike('name', form.name.trim())
        .eq('city', form.city)
        .maybeSingle();

      if (existing) {
        showToast(`"${existing.name}" è già presente nel database.`, 'info');
        setLoading(false);
        return;
      }

      const { error } = await supabase
        .from('unclaimed_business_locations')
        .insert({
          name: form.name.trim(),
          category_id: form.category_id || null,
          street: form.street.trim() || null,
          city: form.city,
          province: form.provinceCode || form.province || null,
          region: form.region || null,
          postal_code: form.postal_code.trim() || null,
          phone: form.phone.trim() || null,
          email: form.email.trim() || null,
          website: form.website.trim() || null,
          country: 'Italia',
          added_by: userId,
          added_by_family_member_id: familyMemberId || null,
          approval_status: 'pending',
          points_awarded: false,
        });

      if (error) throw error;

      showToast(
        `Attività inviata! Riceverai ${expectedPoints} punti dopo l'approvazione.`,
        'success'
      );
      onSuccess();
    } catch {
      showToast("Errore durante l'invio. Riprova.", 'error');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="fixed inset-0 bg-black/50 z-50 flex items-start justify-center p-4 overflow-y-auto">
      <div className="bg-white rounded-2xl shadow-2xl w-full max-w-xl my-8">
        {/* Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-gray-100">
          <div className="flex items-center gap-3">
            <div className="w-9 h-9 bg-blue-100 rounded-xl flex items-center justify-center">
              <Building className="w-5 h-5 text-blue-600" />
            </div>
            <div>
              <h2 className="font-bold text-gray-900">Aggiungi un'Attività</h2>
              <p className="text-xs text-gray-500">Visibile nella ricerca dopo approvazione</p>
            </div>
          </div>
          <button onClick={onCancel} className="p-2 text-gray-400 hover:text-gray-600 rounded-lg hover:bg-gray-100 transition-colors">
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Points banner */}
        <div className="mx-6 mt-4 bg-blue-50 border border-blue-100 rounded-xl px-4 py-3 flex items-center gap-3">
          <Award className="w-5 h-5 text-blue-600 flex-shrink-0" />
          <div className="text-sm">
            <span className="font-semibold text-blue-900">Punti guadagnabili: </span>
            <span className={`font-bold ${hasContact ? 'text-green-600' : 'text-orange-600'}`}>
              {expectedPoints} punti
            </span>
            <span className="text-blue-700 ml-1">
              {hasContact ? '(con contatto)' : '(solo ragione sociale)'}
            </span>
            <div className="flex items-center gap-1 text-xs text-blue-600 mt-0.5">
              <Clock className="w-3 h-3" />
              I punti vengono assegnati dopo l'approvazione dell'amministratore
            </div>
          </div>
        </div>

        <form onSubmit={handleSubmit} className="px-6 py-4 space-y-4">
          {/* Ragione sociale */}
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1.5">
              Ragione Sociale <span className="text-red-500">*</span>
            </label>
            <input
              type="text"
              value={form.name}
              onChange={e => setForm(f => ({ ...f, name: e.target.value }))}
              required
              placeholder="Es: Ristorante Da Mario"
              className="w-full px-3.5 py-2.5 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm"
            />
          </div>

          {/* Categoria */}
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1.5">
              Categoria <span className="text-xs font-normal text-gray-400">(facoltativa)</span>
            </label>
            <CategoryHierarchySelect
              value={form.category_id}
              onChange={value => setForm(f => ({ ...f, category_id: value }))}
              categories={categories}
              placeholder="Seleziona categoria"
            />
          </div>

          {/* Indirizzo */}
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1.5 flex items-center gap-1.5">
              <MapPin className="w-4 h-4 text-gray-400" />
              Indirizzo <span className="text-xs font-normal text-gray-400 ml-1">(facoltativo)</span>
            </label>
            <input
              type="text"
              value={form.street}
              onChange={e => setForm(f => ({ ...f, street: e.target.value }))}
              placeholder="Es: Via Roma 123"
              className="w-full px-3.5 py-2.5 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm"
            />
          </div>

          {/* Regione */}
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1.5">
              Regione <span className="text-xs font-normal text-gray-400">(facoltativa)</span>
            </label>
            <select
              value={form.region}
              onChange={e => setForm(f => ({ ...f, region: e.target.value, province: '', provinceCode: '', city: '' }))}
              className="w-full px-3.5 py-2.5 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm"
            >
              <option value="">Seleziona regione</option>
              {regions.map(r => <option key={r} value={r}>{r}</option>)}
            </select>
          </div>

          {/* Provincia e città */}
          {form.region && (
            <ItalianCityProvinceSelect
              province={form.province}
              city={form.city}
              region={form.region}
              onProvinceChange={(prov, code) => setForm(f => ({ ...f, province: prov, provinceCode: code, city: '' }))}
              onCityChange={city => setForm(f => ({ ...f, city }))}
              required={false}
            />
          )}

          {/* CAP */}
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1.5">
              CAP <span className="text-xs font-normal text-gray-400">(facoltativo)</span>
            </label>
            <input
              type="text"
              value={form.postal_code}
              onChange={e => setForm(f => ({ ...f, postal_code: e.target.value }))}
              placeholder="Es: 20100"
              maxLength={5}
              className="w-full px-3.5 py-2.5 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm"
            />
          </div>

          {/* Sezione contatti — +25 punti */}
          <div className="border border-green-200 bg-green-50/50 rounded-xl p-4 space-y-3">
            <p className="text-xs font-bold text-green-700 uppercase tracking-wide">
              Contatti — aggiungi almeno uno per 25 punti
            </p>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-1.5 flex items-center gap-1.5">
                <Phone className="w-4 h-4 text-gray-400" />
                Telefono
              </label>
              <input
                type="tel"
                value={form.phone}
                onChange={e => setForm(f => ({ ...f, phone: e.target.value }))}
                placeholder="+39 02 1234567"
                className="w-full px-3.5 py-2.5 border border-gray-200 rounded-xl focus:ring-2 focus:ring-green-500 focus:border-transparent text-sm bg-white"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-1.5 flex items-center gap-1.5">
                <Mail className="w-4 h-4 text-gray-400" />
                Email
              </label>
              <input
                type="email"
                value={form.email}
                onChange={e => setForm(f => ({ ...f, email: e.target.value }))}
                placeholder="info@esempio.it"
                className="w-full px-3.5 py-2.5 border border-gray-200 rounded-xl focus:ring-2 focus:ring-green-500 focus:border-transparent text-sm bg-white"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-1.5 flex items-center gap-1.5">
                <Globe className="w-4 h-4 text-gray-400" />
                Sito Web
              </label>
              <input
                type="url"
                value={form.website}
                onChange={e => setForm(f => ({ ...f, website: e.target.value }))}
                placeholder="https://www.esempio.it"
                className="w-full px-3.5 py-2.5 border border-gray-200 rounded-xl focus:ring-2 focus:ring-green-500 focus:border-transparent text-sm bg-white"
              />
            </div>
          </div>

          {/* Footer buttons */}
          <div className="flex gap-3 pt-2">
            <button
              type="button"
              onClick={onCancel}
              className="flex-1 px-4 py-2.5 border border-gray-200 text-gray-700 rounded-xl hover:bg-gray-50 transition-colors text-sm font-semibold"
            >
              Annulla
            </button>
            <button
              type="submit"
              disabled={loading || !form.name.trim()}
              className="flex-1 bg-blue-600 text-white px-4 py-2.5 rounded-xl hover:bg-blue-700 transition-colors text-sm font-semibold disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
            >
              {loading ? (
                <><div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />Invio...</>
              ) : (
                <>Invia per approvazione</>
              )}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
