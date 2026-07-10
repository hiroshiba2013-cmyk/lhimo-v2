import { useState, useEffect } from 'react';
import { FileEdit as Edit, Save, X, Building2, User } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { CategoryHierarchySelect } from '../common/CategoryHierarchySelect';
import { useToast } from '../common/Toast';

interface Category {
  id: string;
  name: string;
  parent_id: string | null;
}

interface BusinessData {
  id: string;
  owner_id: string;
  name: string;
  description: string;
  vat_number: string;
  unique_code: string;
  ateco_code: string;
  pec_email: string;
  phone: string;
  billing_street: string;
  billing_street_number: string;
  billing_postal_code: string;
  billing_city: string;
  billing_province: string;
  billing_address: string;
  office_street: string;
  office_street_number: string;
  office_postal_code: string;
  office_city: string;
  office_province: string;
  office_address: string;
  website_url: string;
  category_id: string | null;
  category?: { id: string; name: string } | null;
}

interface OwnerData {
  first_name: string;
  last_name: string;
  email: string;
  phone: string;
  fiscal_code: string;
  billing_street: string;
  billing_street_number: string;
  billing_postal_code: string;
  billing_city: string;
  billing_province: string;
  billing_address: string;
  company_name: string;
  vat_number: string;
  unique_code: string;
  pec_email: string;
  ateco_code: string;
  website_url: string;
  office_street: string;
  office_street_number: string;
  office_postal_code: string;
  office_city: string;
  office_province: string;
  office_address: string;
  business_category_id: string;
  description: string;
}

interface EditBusinessFormProps {
  businessId: string;
  selectedLocationId?: string | null;
  onUpdate: () => void;
}

export function EditBusinessForm({ businessId, selectedLocationId, onUpdate }: EditBusinessFormProps) {
  const { showToast } = useToast();
  const [isEditing, setIsEditing] = useState(false);
  const [saving, setSaving] = useState(false);
  const [loading, setLoading] = useState(true);
  const [business, setBusiness] = useState<BusinessData | null>(null);
  const [owner, setOwner] = useState<OwnerData | null>(null);
  const [categories, setCategories] = useState<Category[]>([]);
  const [formData, setFormData] = useState({
    name: '',
    vat_number: '',
    unique_code: '',
    ateco_code: '',
    pec_email: '',
    phone: '',
    billing_street: '',
    billing_street_number: '',
    billing_postal_code: '',
    billing_city: '',
    billing_province: '',
    office_street: '',
    office_street_number: '',
    office_postal_code: '',
    office_city: '',
    office_province: '',
    website_url: '',
    description: '',
    category_id: '',
    owner_first_name: '',
    owner_last_name: '',
    owner_phone: '',
    owner_fiscal_code: '',
  });

  useEffect(() => {
    supabase.from('business_categories').select('id, name, parent_id').order('name').then(({ data }) => {
      if (data) setCategories(data);
    });
  }, []);

  useEffect(() => {
    const loadBusiness = async () => {
      setLoading(true);

      // Cerca prima in registered_businesses (nuovo sistema)
      let { data } = await supabase
        .from('registered_businesses')
        .select('*, category:category_id(id, name)')
        .eq('id', businessId)
        .maybeSingle();

      // Fallback a businesses (vecchio sistema)
      if (!data) {
        const result = await supabase
          .from('businesses')
          .select('*, category:category_id(id, name)')
          .eq('id', businessId)
          .maybeSingle();
        data = result.data;
      }

      if (data) {
        setBusiness(data);

        const { data: ownerData } = await supabase
          .from('profiles')
          .select('*')
          .eq('id', data.owner_id)
          .maybeSingle();

        if (ownerData) {
          setOwner(ownerData);
        }

        setFormData({
          name: data.name || '',
          vat_number: data.vat_number || '',
          unique_code: data.unique_code || '',
          ateco_code: data.ateco_code || '',
          pec_email: data.pec_email || '',
          phone: data.phone || '',
          billing_street: data.billing_street || '',
          billing_street_number: data.billing_street_number || '',
          billing_postal_code: data.billing_postal_code || '',
          billing_city: data.billing_city || '',
          billing_province: data.billing_province || '',
          office_street: data.office_street || '',
          office_street_number: data.office_street_number || '',
          office_postal_code: data.office_postal_code || '',
          office_city: data.office_city || '',
          office_province: data.office_province || '',
          website_url: data.website || '',
          description: data.description || '',
          category_id: data.category_id || '',
          owner_first_name: ownerData?.first_name || '',
          owner_last_name: ownerData?.last_name || '',
          owner_phone: ownerData?.phone || '',
          owner_fiscal_code: ownerData?.fiscal_code || '',
        });
      }
      setLoading(false);
    };

    loadBusiness();
  }, [businessId]);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);

    try {
      const { data: { user: currentUser } } = await supabase.auth.getUser();

      if (!currentUser || !business || business.owner_id !== currentUser.id) {
        showToast('Non hai i permessi per modificare questa attività', 'info');
        setSaving(false);
        return;
      }

      const billingAddress = `${formData.billing_street} ${formData.billing_street_number}, ${formData.billing_postal_code} ${formData.billing_city}, ${formData.billing_province}`;
      const officeAddress = formData.office_street && formData.office_street_number && formData.office_postal_code && formData.office_city && formData.office_province
        ? `${formData.office_street} ${formData.office_street_number}, ${formData.office_postal_code} ${formData.office_city}, ${formData.office_province}`
        : '';

      if (business) {
        const { error: ownerError } = await supabase
          .from('profiles')
          .update({
            first_name: formData.owner_first_name,
            last_name: formData.owner_last_name,
            phone: formData.owner_phone,
            fiscal_code: formData.owner_fiscal_code,
            full_name: `${formData.owner_first_name} ${formData.owner_last_name}`,
            company_name: formData.name,
            vat_number: formData.vat_number,
            unique_code: formData.unique_code,
            ateco_code: formData.ateco_code,
            pec_email: formData.pec_email,
            website_url: formData.website_url,
            description: formData.description,
            billing_street: formData.billing_street,
            billing_street_number: formData.billing_street_number,
            billing_postal_code: formData.billing_postal_code,
            billing_city: formData.billing_city,
            billing_province: formData.billing_province.toUpperCase(),
            billing_address: billingAddress,
            office_street: formData.office_street || null,
            office_street_number: formData.office_street_number || null,
            office_postal_code: formData.office_postal_code || null,
            office_city: formData.office_city || null,
            office_province: formData.office_province ? formData.office_province.toUpperCase() : null,
            office_address: officeAddress,
          })
          .eq('id', business.owner_id);

        if (ownerError) throw ownerError;
      }

      // Prova prima ad aggiornare in registered_businesses
      console.log('🔄 Tentativo UPDATE registered_businesses:', businessId);
      const { error: regError } = await supabase
        .from('registered_businesses')
        .update({
          name: formData.name,
          description: formData.description,
          vat_number: formData.vat_number,
          unique_code: formData.unique_code,
          ateco_code: formData.ateco_code,
          pec_email: formData.pec_email,
          phone: formData.phone,
          billing_street: formData.billing_street,
          billing_street_number: formData.billing_street_number,
          billing_postal_code: formData.billing_postal_code,
          billing_city: formData.billing_city,
          billing_province: formData.billing_province.toUpperCase(),
          billing_address: billingAddress,
          office_street: formData.office_street || null,
          office_street_number: formData.office_street_number || null,
          office_postal_code: formData.office_postal_code || null,
          office_city: formData.office_city || null,
          office_province: formData.office_province ? formData.office_province.toUpperCase() : null,
          office_address: officeAddress,
          website_url: formData.website_url,
          category_id: formData.category_id || null,
        })
        .eq('id', businessId);

      if (regError) {
        console.error('❌ Errore UPDATE registered_businesses:', regError);
      } else {
        console.log('✅ UPDATE registered_businesses riuscito');
      }

      // Se c'è un errore di permessi RLS, mostra messaggio specifico
      if (regError?.code === '42501' || regError?.message?.includes('row-level security')) {
        throw new Error('Non hai i permessi per modificare questa attività. Verifica di essere il proprietario.');
      }

      // Se non esiste in registered_businesses, prova con businesses
      if (regError?.code === 'PGRST116') {
        const { error } = await supabase
          .from('businesses')
          .update({
            name: formData.name,
            description: formData.description,
            vat_number: formData.vat_number,
            unique_code: formData.unique_code,
            ateco_code: formData.ateco_code,
            pec_email: formData.pec_email,
            phone: formData.phone,
            billing_street: formData.billing_street,
            billing_street_number: formData.billing_street_number,
            billing_postal_code: formData.billing_postal_code,
            billing_city: formData.billing_city,
            billing_province: formData.billing_province.toUpperCase(),
            billing_address: billingAddress,
            office_street: formData.office_street || null,
            office_street_number: formData.office_street_number || null,
            office_postal_code: formData.office_postal_code || null,
            office_city: formData.office_city || null,
            office_province: formData.office_province ? formData.office_province.toUpperCase() : null,
            office_address: officeAddress,
            website_url: formData.website_url,
            category_id: formData.category_id || null,
          })
          .eq('id', businessId);

        if (error) throw error;
      } else if (regError) {
        throw regError;
      }

      // Ricarica i dati aggiornati
      let { data: updatedData } = await supabase
        .from('registered_businesses')
        .select('*')
        .eq('id', businessId)
        .maybeSingle();

      if (!updatedData) {
        const result = await supabase
          .from('businesses')
          .select('*')
          .eq('id', businessId)
          .maybeSingle();
        updatedData = result.data;
      }

      if (updatedData) {
        setBusiness(updatedData);
      }

      setIsEditing(false);
      onUpdate();
    } catch (error) {
      console.error('Error updating business:', error);
      showToast('Errore durante il salvataggio', 'error');
    } finally {
      setSaving(false);
    }
  };

  const handleCancel = () => {
    if (business) {
      setFormData({
        name: business.name || '',
        vat_number: business.vat_number || '',
        unique_code: business.unique_code || '',
        ateco_code: business.ateco_code || '',
        pec_email: business.pec_email || '',
        phone: business.phone || '',
        billing_street: business.billing_street || '',
        billing_street_number: business.billing_street_number || '',
        billing_postal_code: business.billing_postal_code || '',
        billing_city: business.billing_city || '',
        billing_province: business.billing_province || '',
        office_street: business.office_street || '',
        office_street_number: business.office_street_number || '',
        office_postal_code: business.office_postal_code || '',
        office_city: business.office_city || '',
        office_province: business.office_province || '',
        website_url: business.website_url || '',
        description: business.description || '',
        category_id: business.category_id || '',
        owner_first_name: owner?.first_name || '',
        owner_last_name: owner?.last_name || '',
        owner_phone: owner?.phone || '',
        owner_fiscal_code: owner?.fiscal_code || '',
      });
    }
    setIsEditing(false);
  };

  if (selectedLocationId) {
    return null;
  }

  if (loading) {
    return (
      <div className="bg-white rounded-xl shadow-md p-8 mb-8">
        <div className="text-center py-8">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div>
        </div>
      </div>
    );
  }

  if (!business) {
    return null;
  }

  if (!isEditing) {
    return (
      <div className="bg-white rounded-xl shadow-md p-8 mb-8">
        <div className="flex items-center justify-between mb-6">
          <div className="flex items-center gap-3">
            <Building2 className="w-6 h-6 text-blue-600" />
            <h2 className="text-2xl font-bold text-gray-900">Informazioni Aziendali</h2>
          </div>
          <button
            onClick={() => setIsEditing(true)}
            className="flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors"
          >
            <Edit className="w-4 h-4" />
            Modifica
          </button>
        </div>

        <div className="mb-6">
          <h3 className="text-lg font-bold text-gray-900 mb-4 flex items-center gap-2">
            <Building2 className="w-5 h-5 text-gray-600" />
            Dati Azienda
          </h3>
          <div className="grid md:grid-cols-2 gap-6">
            <div>
              <p className="text-sm text-gray-600 mb-1">Ragione Sociale</p>
              <p className="text-lg font-semibold text-gray-900">{business.name || '-'}</p>
            </div>
            <div>
              <p className="text-sm text-gray-600 mb-1">Partita IVA</p>
              <p className="text-lg font-semibold text-gray-900">{business.vat_number || '-'}</p>
            </div>
            <div>
              <p className="text-sm text-gray-600 mb-1">Codice Univoco</p>
              <p className="text-lg font-semibold text-gray-900">{business.unique_code || '-'}</p>
            </div>
            <div>
              <p className="text-sm text-gray-600 mb-1">Codice ATECO</p>
              <p className="text-lg font-semibold text-gray-900">{business.ateco_code || '-'}</p>
            </div>
            <div>
              <p className="text-sm text-gray-600 mb-1">Categoria Attivita</p>
              <p className="text-lg font-semibold text-gray-900">
                {business.category?.name || (business.category_id ? categories.find(c => c.id === business.category_id)?.name : null) || '-'}
              </p>
            </div>
            <div>
              <p className="text-sm text-gray-600 mb-1">PEC</p>
              <p className="text-lg font-semibold text-gray-900">{business.pec_email || '-'}</p>
            </div>
            <div>
              <p className="text-sm text-gray-600 mb-1">Telefono Azienda</p>
              <p className="text-lg font-semibold text-gray-900">{business.phone || '-'}</p>
            </div>
            <div className="md:col-span-2">
              <p className="text-sm text-gray-600 mb-1">Sito Web</p>
              {business.website_url ? (
                <a
                  href={business.website_url}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-lg font-semibold text-blue-600 hover:text-blue-700 hover:underline"
                >
                  {business.website_url}
                </a>
              ) : (
                <p className="text-lg font-semibold text-gray-900">-</p>
              )}
            </div>
          </div>
        </div>

        <div className="border-t pt-6">
          <h3 className="text-lg font-bold text-gray-900 mb-4">Indirizzi</h3>
          <div className="grid md:grid-cols-2 gap-6">
            <div>
              <p className="text-sm text-gray-600 mb-1">Indirizzo di Fatturazione</p>
              <p className="text-lg font-semibold text-gray-900">
                {business.billing_address || '-'}
              </p>
            </div>
            {business.office_address && (
              <div>
                <p className="text-sm text-gray-600 mb-1">Indirizzo Sede Operativa</p>
                <p className="text-lg font-semibold text-gray-900">
                  {business.office_address}
                </p>
              </div>
            )}
          </div>
        </div>

        {business.description && (
          <div className="border-t pt-6">
            <p className="text-sm text-gray-600 mb-2">Descrizione Azienda</p>
            <p className="text-base text-gray-900 leading-relaxed whitespace-pre-line">
              {business.description}
            </p>
          </div>
        )}

        {owner && (
          <div className="border-t pt-6">
            <h3 className="text-lg font-bold text-gray-900 mb-4 flex items-center gap-2">
              <User className="w-5 h-5 text-gray-600" />
              Dati Titolare
            </h3>
            <div className="grid md:grid-cols-2 gap-6">
              <div>
                <p className="text-sm text-gray-600 mb-1">Nome</p>
                <p className="text-lg font-semibold text-gray-900">{owner.first_name || '-'}</p>
              </div>
              <div>
                <p className="text-sm text-gray-600 mb-1">Cognome</p>
                <p className="text-lg font-semibold text-gray-900">{owner.last_name || '-'}</p>
              </div>
              <div>
                <p className="text-sm text-gray-600 mb-1">Telefono</p>
                <p className="text-lg font-semibold text-gray-900">{owner.phone || '-'}</p>
              </div>
              <div>
                <p className="text-sm text-gray-600 mb-1">Codice Fiscale</p>
                <p className="text-lg font-semibold text-gray-900">{owner.fiscal_code || '-'}</p>
              </div>
            </div>
          </div>
        )}
      </div>
    );
  }

  return (
    <div className="bg-white rounded-xl shadow-md p-8 mb-8">
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <Building2 className="w-6 h-6 text-blue-600" />
          <h2 className="text-2xl font-bold text-gray-900">Modifica Informazioni Aziendali</h2>
        </div>
        <button
          onClick={handleCancel}
          className="text-gray-600 hover:text-gray-800"
        >
          <X className="w-6 h-6" />
        </button>
      </div>

      <form onSubmit={handleSubmit}>
        <div className="flex items-center gap-2 mb-4 border-b pb-2">
          <Building2 className="w-5 h-5 text-gray-600" />
          <h3 className="text-lg font-bold text-gray-900">Dati Azienda</h3>
        </div>

        <div className="grid md:grid-cols-2 gap-6 mb-6">
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              Ragione Sociale
            </label>
            <input
              type="text"
              name="name"
              value={formData.name}
              onChange={handleChange}
              required
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              Partita IVA
            </label>
            <input
              type="text"
              name="vat_number"
              value={formData.vat_number}
              onChange={handleChange}
              required
              maxLength={11}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              Codice Univoco
            </label>
            <input
              type="text"
              name="unique_code"
              value={formData.unique_code}
              onChange={handleChange}
              required
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              Codice ATECO
            </label>
            <input
              type="text"
              name="ateco_code"
              value={formData.ateco_code}
              onChange={handleChange}
              required
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              Categoria Attivita
            </label>
            <CategoryHierarchySelect
              value={formData.category_id}
              onChange={(value) => setFormData(prev => ({ ...prev, category_id: value }))}
              categories={categories}
              placeholder="Nessuna categoria"
            />
          </div>

          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              PEC
            </label>
            <input
              type="email"
              name="pec_email"
              value={formData.pec_email}
              onChange={handleChange}
              required
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              Telefono
            </label>
            <input
              type="tel"
              name="phone"
              value={formData.phone}
              onChange={handleChange}
              required
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <div className="md:col-span-2">
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              Sito Web
            </label>
            <input
              type="url"
              name="website_url"
              value={formData.website_url}
              onChange={handleChange}
              placeholder="https://www.esempio.it"
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <div className="md:col-span-2">
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              Descrizione Azienda
            </label>
            <textarea
              name="description"
              value={formData.description}
              onChange={handleChange}
              rows={4}
              placeholder="Descrivi la tua attività, i servizi offerti, i punti di forza..."
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
            />
          </div>

          <div className="md:col-span-2">
            <h3 className="text-lg font-semibold text-gray-900 mb-3 mt-4">Indirizzo di Fatturazione</h3>
          </div>

          <div className="md:col-span-2">
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              Via/Piazza
            </label>
            <input
              type="text"
              name="billing_street"
              value={formData.billing_street}
              onChange={handleChange}
              required
              placeholder="Es. Via Roma"
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              Numero
            </label>
            <input
              type="text"
              name="billing_street_number"
              value={formData.billing_street_number}
              onChange={handleChange}
              required
              placeholder="Es. 42"
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              CAP
            </label>
            <input
              type="text"
              name="billing_postal_code"
              value={formData.billing_postal_code}
              onChange={handleChange}
              required
              placeholder="Es. 00100"
              maxLength={5}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              Città
            </label>
            <input
              type="text"
              name="billing_city"
              value={formData.billing_city}
              onChange={handleChange}
              required
              placeholder="Es. Roma"
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              Provincia
            </label>
            <input
              type="text"
              name="billing_province"
              value={formData.billing_province}
              onChange={handleChange}
              required
              placeholder="Es. RM"
              maxLength={2}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent uppercase"
            />
          </div>

          <div className="md:col-span-2">
            <h3 className="text-lg font-semibold text-gray-900 mb-3 mt-4">Indirizzo Sede (opzionale)</h3>
          </div>

          <div className="md:col-span-2">
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              Via/Piazza
            </label>
            <input
              type="text"
              name="office_street"
              value={formData.office_street}
              onChange={handleChange}
              placeholder="Es. Via Milano"
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              Numero
            </label>
            <input
              type="text"
              name="office_street_number"
              value={formData.office_street_number}
              onChange={handleChange}
              placeholder="Es. 10"
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              CAP
            </label>
            <input
              type="text"
              name="office_postal_code"
              value={formData.office_postal_code}
              onChange={handleChange}
              placeholder="Es. 20100"
              maxLength={5}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              Città
            </label>
            <input
              type="text"
              name="office_city"
              value={formData.office_city}
              onChange={handleChange}
              placeholder="Es. Milano"
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              Provincia
            </label>
            <input
              type="text"
              name="office_province"
              value={formData.office_province}
              onChange={handleChange}
              placeholder="Es. MI"
              maxLength={2}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent uppercase"
            />
          </div>
        </div>

        <div className="flex items-center gap-2 mb-4 border-b pb-2 mt-6">
          <User className="w-5 h-5 text-gray-600" />
          <h3 className="text-lg font-bold text-gray-900">Dati Titolare</h3>
        </div>

        <div className="grid md:grid-cols-2 gap-6 mb-6">
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              Nome
            </label>
            <input
              type="text"
              name="owner_first_name"
              value={formData.owner_first_name}
              onChange={handleChange}
              placeholder="Es. Mario"
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              Cognome
            </label>
            <input
              type="text"
              name="owner_last_name"
              value={formData.owner_last_name}
              onChange={handleChange}
              placeholder="Es. Rossi"
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              Telefono Titolare
            </label>
            <input
              type="tel"
              name="owner_phone"
              value={formData.owner_phone}
              onChange={handleChange}
              placeholder="Es. +39 333 1234567"
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              Codice Fiscale
            </label>
            <input
              type="text"
              name="owner_fiscal_code"
              value={formData.owner_fiscal_code}
              onChange={handleChange}
              placeholder="Es. RSSMRA80A01H501Z"
              maxLength={16}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent uppercase"
            />
          </div>
        </div>

        <div className="flex gap-3">
          <button
            type="submit"
            disabled={saving}
            className="flex items-center gap-2 bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors font-semibold disabled:opacity-50"
          >
            <Save className="w-5 h-5" />
            {saving ? 'Salvataggio...' : 'Salva Modifiche'}
          </button>
          <button
            type="button"
            onClick={handleCancel}
            className="px-6 py-3 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors font-semibold"
          >
            Annulla
          </button>
        </div>
      </form>
    </div>
  );
}
