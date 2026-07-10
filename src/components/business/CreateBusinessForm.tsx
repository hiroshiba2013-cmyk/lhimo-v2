import { useState, useEffect } from 'react';
import { Building, X, Save, Search, PlusCircle, Instagram, Facebook } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { SearchableSelect } from '../common/SearchableSelect';
import { CategoryHierarchySelect } from '../common/CategoryHierarchySelect';
import { ItalianCityProvinceSelect } from '../common/ItalianCityProvinceSelect';
import { ClaimBusinessLocationsForm } from './ClaimBusinessLocationsForm';
import { getPlanDisplayName } from '../../lib/subscription-helper';
import { useToast } from '../common/Toast';

interface Category {
  id: string;
  name: string;
  parent_id: string | null;
}

interface UnclaimedLocation {
  id: string;
  name: string;
  street: string;
  city: string;
  province: string;
  region: string;
  postal_code: string;
  phone: string;
  email: string;
  website: string;
  category_id: string;
}

interface CreateBusinessFormProps {
  ownerId: string;
  onSuccess: () => void;
  onCancel: () => void;
}

interface ExistingBusinessInfo {
  business_id: string;
  business_name: string;
  claimed_locations: Array<{
    id: string;
    name: string;
    street: string;
    city: string;
    province: string;
    postal_code: string;
  }>;
  unclaimed_locations: Array<{
    id: string;
    name: string;
    street: string;
    city: string;
    province: string;
    postal_code: string;
  }>;
}

export function CreateBusinessForm({ ownerId, onSuccess, onCancel }: CreateBusinessFormProps) {
  const { showToast } = useToast();
  const [step, setStep] = useState<'choice' | 'claim' | 'form' | 'existing'>('choice');
  const [claimedLocations, setClaimedLocations] = useState<UnclaimedLocation[]>([]);
  const [billingPeriod, setBillingPeriod] = useState<'monthly' | 'yearly'>('monthly');
  const [saving, setSaving] = useState(false);
  const [checkingVat, setCheckingVat] = useState(false);
  const [existingBusiness, setExistingBusiness] = useState<ExistingBusinessInfo | null>(null);
  const [categories, setCategories] = useState<Category[]>([]);
  const [formData, setFormData] = useState({
    name: '',
    category_id: '',
    city: '',
    province: '',
    address: '',
    postal_code: '',
    phone: '',
    email: '',
    website: '',
    vat_number: '',
    unique_code: '',
    pec_email: '',
    ateco_code: '',
    description: '',
    location_name: '',
    location_description: '',
    billing_street: '',
    billing_street_number: '',
    billing_postal_code: '',
    billing_city: '',
    billing_province: '',
    instagram_url: '',
    facebook_url: '',
    tiktok_url: '',
  });

  useEffect(() => {
    supabase.from('business_categories').select('id, name, parent_id').order('name').then(({ data }) => {
      if (data) setCategories(data);
    });
  }, []);

  const checkVatNumber = async (vat: string) => {
    if (vat.length !== 11) return;

    setCheckingVat(true);
    try {
      const { data: existingBiz, error } = await supabase
        .from('businesses')
        .select('id, name, owner_id')
        .eq('vat_number', vat)
        .maybeSingle();

      if (error) throw error;

      if (existingBiz) {
        if (existingBiz.owner_id === ownerId) {
          showToast('Hai già registrato un\'attività con questa Partita IVA!', 'info');
          setCheckingVat(false);
          return;
        }

        const { data: claimedLocs } = await supabase
          .from('business_locations')
          .select('id, internal_name, street, city, province, postal_code')
          .eq('business_id', existingBiz.id);

        const { data: unclaimedLocs } = await supabase
          .from('unclaimed_business_locations')
          .select('id, name, street, city, province, postal_code, vat_number')
          .or(`vat_number.eq.${vat},name.ilike.%${existingBiz.name}%`);

        setExistingBusiness({
          business_id: existingBiz.id,
          business_name: existingBiz.name,
          claimed_locations: claimedLocs?.map(loc => ({
            id: loc.id,
            name: loc.internal_name || loc.street,
            street: loc.street,
            city: loc.city,
            province: loc.province,
            postal_code: loc.postal_code || '',
          })) || [],
          unclaimed_locations: unclaimedLocs?.map(loc => ({
            id: loc.id,
            name: loc.name,
            street: loc.street,
            city: loc.city,
            province: loc.province,
            postal_code: loc.postal_code || '',
          })) || [],
        });

        setStep('existing');
      }
    } catch (error) {
      console.error('Errore controllo P.IVA:', error);
    } finally {
      setCheckingVat(false);
    }
  };

  const handleVatChange = (vat: string) => {
    const cleanVat = vat.replace(/\D/g, '').slice(0, 11);
    setFormData({ ...formData, vat_number: cleanVat });

    if (cleanVat.length === 11 && step === 'form') {
      checkVatNumber(cleanVat);
    }
  };

  const handleLocationsSelected = (locations: UnclaimedLocation[], selectedBillingPeriod: 'monthly' | 'yearly') => {
    setClaimedLocations(locations);
    setBillingPeriod(selectedBillingPeriod);

    if (locations.length > 0) {
      const firstLocation = locations[0];
      setFormData({
        name: firstLocation.name,
        category_id: firstLocation.category_id || '',
        city: firstLocation.city,
        province: firstLocation.province,
        address: firstLocation.street,
        postal_code: firstLocation.postal_code || '',
        phone: firstLocation.phone || '',
        email: firstLocation.email || '',
        website: firstLocation.website || '',
        vat_number: '',
        unique_code: '',
        pec_email: '',
        ateco_code: '',
        description: '',
        location_description: '',
        billing_street: '',
        billing_street_number: '',
        billing_postal_code: '',
        billing_city: '',
        billing_province: '',
        instagram_url: '',
        facebook_url: '',
        tiktok_url: '',
      });
    }

    setStep('form');
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);

    try {
      const billingAddress = `${formData.billing_street} ${formData.billing_street_number}, ${formData.billing_postal_code} ${formData.billing_city}, ${formData.billing_province}`;

      const { data: business, error: businessError } = await supabase
        .from('businesses')
        .insert({
          owner_id: ownerId,
          name: formData.name,
          category_id: formData.category_id || claimedLocations[0]?.category_id || null,
          city: formData.city,
          province: formData.province,
          address: formData.address,
          phone: formData.phone,
          email: formData.email,
          website_url: formData.website || null,
          vat_number: formData.vat_number,
          unique_code: formData.unique_code,
          pec_email: formData.pec_email,
          ateco_code: formData.ateco_code || null,
          description: formData.description || null,
          billing_street: formData.billing_street,
          billing_street_number: formData.billing_street_number,
          billing_postal_code: formData.billing_postal_code,
          billing_city: formData.billing_city,
          billing_province: formData.billing_province.toUpperCase(),
          billing_address: billingAddress,
          verified: false,
          is_claimed: claimedLocations.length > 0,
        })
        .select()
        .single();

      if (businessError) throw businessError;

      if (claimedLocations.length > 0) {
        const locationInserts = claimedLocations.map((location, index) => ({
          business_id: business.id,
          name: location.name,
          address: location.street,
          city: location.city,
          province: location.province,
          region: location.region,
          postal_code: location.postal_code,
          phone: location.phone,
          email: location.email,
          website: location.website,
          country: 'Italia',
          is_primary: claimedLocations[0].id === location.id,
          description: index === 0 && formData.location_description ? formData.location_description : null,
        }));

        const { error: locationsError } = await supabase
          .from('business_locations')
          .insert(locationInserts);

        if (locationsError) throw locationsError;

        // Sposta le recensioni dalle sedi non reclamate al nuovo business
        const locationIds = claimedLocations.map(l => l.id);
        const { error: reviewsError } = await supabase
          .from('reviews')
          .update({
            business_id: business.id,
            unclaimed_business_id: null
          })
          .in('unclaimed_business_id', locationIds);

        if (reviewsError) throw reviewsError;

        // Elimina le sedi rivendicate da unclaimed_business_locations per evitare duplicati
        const { error: deleteError } = await supabase
          .from('unclaimed_business_locations')
          .delete()
          .in('id', locationIds);

        if (deleteError) throw deleteError;

        const planName = getPlanDisplayName(claimedLocations.length, billingPeriod);
        const { data: plan, error: planError } = await supabase
          .from('subscription_plans')
          .select('*')
          .eq('name', planName)
          .maybeSingle();

        if (planError) throw planError;

        if (plan) {
          const trialEndDate = new Date();
          trialEndDate.setMonth(trialEndDate.getMonth() + 3);

          const { error: subscriptionError } = await supabase
            .from('subscriptions')
            .insert({
              customer_id: ownerId,
              plan_id: plan.id,
              status: 'trial',
              start_date: new Date().toISOString(),
              trial_end_date: trialEndDate.toISOString(),
              end_date: trialEndDate.toISOString(),
              payment_method_added: false,
              reminder_sent: false,
            });

          if (subscriptionError) throw subscriptionError;
        }
      } else {
        // Verifica ed elimina eventuali duplicati in unclaimed_business_locations
        // (stesso nome e indirizzo) per evitare doppioni
        const { data: duplicates } = await supabase
          .from('unclaimed_business_locations')
          .select('id')
          .ilike('name', formData.name)
          .ilike('street', formData.address)
          .eq('city', formData.city);

        if (duplicates && duplicates.length > 0) {
          const duplicateIds = duplicates.map(d => d.id);
          const { error: deleteDuplicatesError } = await supabase
            .from('unclaimed_business_locations')
            .delete()
            .in('id', duplicateIds);

          if (deleteDuplicatesError) {
            console.log('Error deleting duplicates:', deleteDuplicatesError);
          }
        }

        // Crea una nuova business_location per l'attività creata da zero
        const { error: locationError } = await supabase
          .from('business_locations')
          .insert({
            business_id: business.id,
            name: formData.name,
            internal_name: formData.location_name || null,
            address: formData.address,
            city: formData.city,
            province: formData.province,
            postal_code: formData.postal_code,
            phone: formData.phone,
            email: formData.email,
            website: formData.website || null,
            country: 'Italia',
            is_primary: true,
            description: formData.location_description || null,
            instagram_url: formData.instagram_url || null,
            facebook_url: formData.facebook_url || null,
            tiktok_url: formData.tiktok_url || null,
          });

        if (locationError) throw locationError;

        // Crea una sottoscrizione di default per 1 sede
        const { data: defaultPlan, error: planError } = await supabase
          .from('subscription_plans')
          .select('*')
          .eq('name', 'Base')
          .maybeSingle();

        if (planError) throw planError;

        if (defaultPlan) {
          const trialEndDate = new Date();
          trialEndDate.setMonth(trialEndDate.getMonth() + 3);

          const { error: subscriptionError } = await supabase
            .from('subscriptions')
            .insert({
              customer_id: ownerId,
              plan_id: defaultPlan.id,
              status: 'trial',
              start_date: new Date().toISOString(),
              trial_end_date: trialEndDate.toISOString(),
              end_date: trialEndDate.toISOString(),
              payment_method_added: false,
              reminder_sent: false,
            });

          if (subscriptionError) throw subscriptionError;
        }
      }

      onSuccess();
    } catch (error) {
      console.error('Error creating business:', error);
      showToast('Errore durante la creazione dell\'attività', 'error');
    } finally {
      setSaving(false);
    }
  };

  if (step === 'claim') {
    return (
      <ClaimBusinessLocationsForm
        onLocationsSelected={handleLocationsSelected}
        onCancel={() => setStep('choice')}
      />
    );
  }

  if (step === 'existing' && existingBusiness) {
    return (
      <div className="bg-white rounded-xl shadow-md p-8">
        <div className="flex items-center justify-between mb-6">
          <div className="flex items-center gap-3">
            <Building className="w-6 h-6 text-orange-600" />
            <h2 className="text-2xl font-bold text-gray-900">Attività Già Presente</h2>
          </div>
          <button
            onClick={() => {
              setStep('form');
              setExistingBusiness(null);
            }}
            className="text-gray-600 hover:text-gray-800"
          >
            <X className="w-6 h-6" />
          </button>
        </div>

        <div className="bg-orange-50 border-l-4 border-orange-500 p-4 mb-6">
          <div className="flex items-start gap-3">
            <div className="flex-shrink-0">
              <svg className="w-6 h-6 text-orange-600" fill="currentColor" viewBox="0 0 20 20">
                <path fillRule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
              </svg>
            </div>
            <div className="flex-1">
              <h3 className="text-lg font-semibold text-orange-900 mb-1">
                Questa Partita IVA è già registrata!
              </h3>
              <p className="text-orange-800 mb-3">
                L'attività "<strong>{existingBusiness.business_name}</strong>" è già presente nel sistema.
              </p>
              <div className="bg-white rounded-lg p-3 border border-orange-200">
                <p className="text-sm text-gray-700 mb-2 font-semibold">Cosa puoi fare:</p>
                <ul className="text-sm text-gray-600 space-y-1 list-disc list-inside">
                  <li>Se sei il proprietario e hai già un account, accedi con le tue credenziali</li>
                  <li>Se la P.IVA è corretta ma non hai ancora registrato questa azienda, contatta il supporto</li>
                  <li>Se hai una nuova sede da aggiungere, verifica se è già nell'elenco qui sotto</li>
                  <li>Se la P.IVA è errata, correggila usando il pulsante sotto</li>
                </ul>
              </div>
            </div>
          </div>
        </div>

        {existingBusiness.claimed_locations.length > 0 && (
          <div className="mb-6">
            <h3 className="text-lg font-bold text-gray-900 mb-3">
              Sedi Già Registrate ({existingBusiness.claimed_locations.length})
            </h3>
            <div className="space-y-2">
              {existingBusiness.claimed_locations.map((loc) => (
                <div key={loc.id} className="bg-gray-50 border border-gray-200 rounded-lg p-4">
                  <div className="flex items-start gap-3">
                    <div className="flex-shrink-0 mt-1">
                      <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                    </div>
                    <div className="flex-1">
                      <p className="font-semibold text-gray-900">{loc.name}</p>
                      <p className="text-sm text-gray-600">
                        {loc.street}, {loc.postal_code} {loc.city} ({loc.province})
                      </p>
                      <p className="text-xs text-green-600 mt-1">Sede già rivendicata</p>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {existingBusiness.unclaimed_locations.length > 0 && (
          <div className="mb-6">
            <h3 className="text-lg font-bold text-gray-900 mb-3">
              Altre Sedi Disponibili ({existingBusiness.unclaimed_locations.length})
            </h3>
            <p className="text-sm text-gray-600 mb-3">
              Queste sedi non sono ancora state rivendicate. Se sei il proprietario, contattaci per aggiungerle al tuo account.
            </p>
            <div className="space-y-2">
              {existingBusiness.unclaimed_locations.map((loc) => (
                <div key={loc.id} className="bg-blue-50 border border-blue-200 rounded-lg p-4">
                  <div className="flex items-start gap-3">
                    <div className="flex-shrink-0 mt-1">
                      <div className="w-2 h-2 bg-blue-500 rounded-full"></div>
                    </div>
                    <div className="flex-1">
                      <p className="font-semibold text-gray-900">{loc.name}</p>
                      <p className="text-sm text-gray-600">
                        {loc.street}, {loc.postal_code} {loc.city} ({loc.province})
                      </p>
                      <p className="text-xs text-blue-600 mt-1">Disponibile per rivendicazione</p>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        <div className="space-y-3 pt-4 border-t">
          <div className="flex gap-3">
            <button
              onClick={() => {
                setStep('form');
                setExistingBusiness(null);
                setFormData({ ...formData, vat_number: '' });
              }}
              className="flex-1 bg-gray-200 text-gray-800 px-6 py-3 rounded-lg hover:bg-gray-300 transition-colors font-semibold"
            >
              Correggi P.IVA
            </button>
            <button
              onClick={onCancel}
              className="flex-1 bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors font-semibold"
            >
              Torna Indietro
            </button>
          </div>
          <button
            onClick={() => window.location.href = '/contact'}
            className="w-full bg-green-600 text-white px-6 py-3 rounded-lg hover:bg-green-700 transition-colors font-semibold flex items-center justify-center gap-2"
          >
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
            </svg>
            Contatta il Supporto
          </button>
        </div>
      </div>
    );
  }

  if (step === 'choice') {
    return (
      <div className="bg-white rounded-xl shadow-md p-8">
        <div className="flex items-center justify-between mb-6">
          <div className="flex items-center gap-3">
            <Building className="w-6 h-6 text-blue-600" />
            <h2 className="text-2xl font-bold text-gray-900">Registra la tua Attività</h2>
          </div>
          <button
            onClick={onCancel}
            className="text-gray-600 hover:text-gray-800"
          >
            <X className="w-6 h-6" />
          </button>
        </div>

        <p className="text-gray-600 mb-6">
          Scegli come vuoi procedere con la registrazione della tua attività:
        </p>

        <div className="grid md:grid-cols-2 gap-4">
          <button
            onClick={() => setStep('claim')}
            className="group bg-gradient-to-br from-blue-50 to-blue-100 hover:from-blue-100 hover:to-blue-200 border-2 border-blue-300 rounded-xl p-6 text-left transition-all"
          >
            <div className="flex items-center gap-3 mb-4">
              <div className="bg-blue-600 text-white p-3 rounded-lg group-hover:scale-110 transition-transform">
                <Search className="w-6 h-6" />
              </div>
              <h3 className="text-xl font-bold text-gray-900">
                Rivendica Sedi Esistenti
              </h3>
            </div>
            <p className="text-gray-700 mb-4">
              La tua attività è già presente nel database? Cercala e rivendicala. Puoi selezionare più sedi se ne hai diverse.
            </p>
            <div className="flex items-center gap-2 text-blue-600 font-semibold">
              <span>Cerca e rivendica</span>
              <Search className="w-4 h-4" />
            </div>
          </button>

          <button
            onClick={() => setStep('form')}
            className="group bg-gradient-to-br from-green-50 to-green-100 hover:from-green-100 hover:to-green-200 border-2 border-green-300 rounded-xl p-6 text-left transition-all"
          >
            <div className="flex items-center gap-3 mb-4">
              <div className="bg-green-600 text-white p-3 rounded-lg group-hover:scale-110 transition-transform">
                <PlusCircle className="w-6 h-6" />
              </div>
              <h3 className="text-xl font-bold text-gray-900">
                Crea Nuova Attività
              </h3>
            </div>
            <p className="text-gray-700 mb-4">
              La tua attività non è ancora nel database? Inserisci manualmente tutti i dati della tua attività.
            </p>
            <div className="flex items-center gap-2 text-green-600 font-semibold">
              <span>Crea da zero</span>
              <PlusCircle className="w-4 h-4" />
            </div>
          </button>
        </div>

      </div>
    );
  }

  return (
    <div className="bg-white rounded-xl shadow-md p-8">
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <Building className="w-6 h-6 text-blue-600" />
          <h2 className="text-2xl font-bold text-gray-900">
            {claimedLocations.length > 0 ? 'Completa i Dati dell\'Attività' : 'Registra Nuova Attività'}
          </h2>
        </div>
        <button
          onClick={onCancel}
          className="text-gray-600 hover:text-gray-800"
        >
          <X className="w-6 h-6" />
        </button>
      </div>

      {claimedLocations.length > 0 && (
        <div className="mb-6 bg-green-50 border border-green-200 rounded-lg p-4">
          <h3 className="font-semibold text-green-900 mb-2">
            Sedi selezionate ({claimedLocations.length})
          </h3>
          <ul className="space-y-1 text-sm text-green-800">
            {claimedLocations.map((location, index) => (
              <li key={location.id}>
                {index + 1}. {location.name} - {location.city} ({location.province})
              </li>
            ))}
          </ul>
        </div>
      )}

      <form onSubmit={handleSubmit} className="space-y-6">
        <div>
          <h3 className="text-lg font-bold text-gray-900 mb-4">Informazioni Aziendali</h3>
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Ragione Sociale *
              </label>
              <input
                type="text"
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                required
                placeholder="Es. Ristorante Da Mario S.r.l."
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>

            <div className="grid md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Partita IVA *
                </label>
                <div className="relative">
                  <input
                    type="text"
                    value={formData.vat_number}
                    onChange={(e) => handleVatChange(e.target.value)}
                    required
                    maxLength={11}
                    placeholder="Es. 12345678901"
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  />
                  {checkingVat && (
                    <div className="absolute right-3 top-3">
                      <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-blue-600"></div>
                    </div>
                  )}
                </div>
                <p className="text-xs text-gray-500 mt-1">
                  Controlleremo automaticamente se l'attività è già presente nel sistema
                </p>
              </div>

              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Codice Univoco (SDI) *
                </label>
                <input
                  type="text"
                  value={formData.unique_code}
                  onChange={(e) => setFormData({ ...formData, unique_code: e.target.value })}
                  required
                  maxLength={7}
                  placeholder="Es. ABCDEFG"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>
            </div>

            <div className="grid md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  PEC *
                </label>
                <input
                  type="email"
                  value={formData.pec_email}
                  onChange={(e) => setFormData({ ...formData, pec_email: e.target.value })}
                  required
                  placeholder="Es. azienda@pec.it"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>

              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Codice ATECO (opzionale)
                </label>
                <input
                  type="text"
                  value={formData.ateco_code}
                  onChange={(e) => setFormData({ ...formData, ateco_code: e.target.value })}
                  placeholder="Es. 56.10.11"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>
            </div>

            <div className="grid md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Telefono *
                </label>
                <input
                  type="tel"
                  value={formData.phone}
                  onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                  required
                  placeholder="Es. +39 06 1234567"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>

              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Email *
                </label>
                <input
                  type="email"
                  value={formData.email}
                  onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                  required
                  placeholder="Es. info@attivita.it"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Sito Web (opzionale)
              </label>
              <input
                type="url"
                value={formData.website}
                onChange={(e) => setFormData({ ...formData, website: e.target.value })}
                placeholder="https://www.esempio.it"
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Instagram (opzionale)
              </label>
              <div className="flex items-center gap-2">
                <Instagram className="w-5 h-5 text-pink-500 flex-shrink-0" />
                <input
                  type="url"
                  value={formData.instagram_url}
                  onChange={(e) => setFormData({ ...formData, instagram_url: e.target.value })}
                  placeholder="https://instagram.com/..."
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-pink-400 focus:border-transparent"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Facebook (opzionale)
              </label>
              <div className="flex items-center gap-2">
                <Facebook className="w-5 h-5 text-blue-600 flex-shrink-0" />
                <input
                  type="url"
                  value={formData.facebook_url}
                  onChange={(e) => setFormData({ ...formData, facebook_url: e.target.value })}
                  placeholder="https://facebook.com/..."
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-400 focus:border-transparent"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                TikTok (opzionale)
              </label>
              <div className="flex items-center gap-2">
                <svg className="w-5 h-5 flex-shrink-0 text-gray-800" viewBox="0 0 24 24" fill="currentColor"><path d="M19.59 6.69a4.83 4.83 0 01-3.77-4.25V2h-3.45v13.67a2.89 2.89 0 01-2.88 2.5 2.89 2.89 0 01-2.89-2.89 2.89 2.89 0 012.89-2.89c.28 0 .54.04.79.1V9.01a6.33 6.33 0 00-.79-.05 6.34 6.34 0 00-6.34 6.34 6.34 6.34 0 006.34 6.34 6.34 6.34 0 006.33-6.34V8.97a8.27 8.27 0 004.84 1.55V7.07a4.85 4.85 0 01-1.07-.38z"/></svg>
                <input
                  type="url"
                  value={formData.tiktok_url}
                  onChange={(e) => setFormData({ ...formData, tiktok_url: e.target.value })}
                  placeholder="https://tiktok.com/@..."
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-400 focus:border-transparent"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Categoria Attivita *
              </label>
              <CategoryHierarchySelect
                value={formData.category_id}
                onChange={(value) => setFormData({ ...formData, category_id: value })}
                categories={categories}
                placeholder="Seleziona categoria"
              />
            </div>
          </div>
        </div>

        <div className="border-t pt-6">
          <h3 className="text-lg font-bold text-gray-900 mb-4">Indirizzo di Fatturazione</h3>
          <div className="space-y-4">
            <div className="grid md:grid-cols-3 gap-4">
              <div className="md:col-span-2">
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Via/Piazza *
                </label>
                <input
                  type="text"
                  value={formData.billing_street}
                  onChange={(e) => setFormData({ ...formData, billing_street: e.target.value })}
                  required
                  placeholder="Es. Via Roma"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>

              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Numero *
                </label>
                <input
                  type="text"
                  value={formData.billing_street_number}
                  onChange={(e) => setFormData({ ...formData, billing_street_number: e.target.value })}
                  required
                  placeholder="Es. 42"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>
            </div>

            <div className="grid md:grid-cols-3 gap-4">
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Città *
                </label>
                <input
                  type="text"
                  value={formData.billing_city}
                  onChange={(e) => setFormData({ ...formData, billing_city: e.target.value })}
                  required
                  placeholder="Es. Roma"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>

              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Provincia *
                </label>
                <input
                  type="text"
                  value={formData.billing_province}
                  onChange={(e) => setFormData({ ...formData, billing_province: e.target.value.toUpperCase() })}
                  required
                  placeholder="RM"
                  maxLength={2}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent uppercase"
                />
              </div>

              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  CAP *
                </label>
                <input
                  type="text"
                  value={formData.billing_postal_code}
                  onChange={(e) => setFormData({ ...formData, billing_postal_code: e.target.value })}
                  required
                  placeholder="00100"
                  maxLength={5}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>
            </div>
          </div>
        </div>

        {/* Sezione Descrizione - Sempre Visibile */}
        <div className="border-t pt-6">
          <h3 className="text-lg font-bold text-gray-900 mb-4">
            Descrizione {claimedLocations.length > 0 && '(Sede Primaria)'}
          </h3>
          <p className="text-sm text-gray-600 mb-4">
            {claimedLocations.length > 0
              ? 'Questi dati verranno applicati alla sede primaria (la prima selezionata).'
              : 'Descrivi la tua attività.'}
          </p>
          <div className="space-y-4 bg-blue-50 p-6 rounded-lg border border-blue-200">
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Descrizione Attività
              </label>
              <textarea
                value={formData.description}
                onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                rows={3}
                placeholder="Descrivi brevemente la tua attività (es. Ristorante di cucina tradizionale italiana con oltre 20 anni di esperienza)"
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Descrizione Sede
              </label>
              <textarea
                value={formData.location_description}
                onChange={(e) => setFormData({ ...formData, location_description: e.target.value })}
                rows={2}
                placeholder="Breve descrizione della sede (es. Negozio nel centro storico con ampio parcheggio)"
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
              />
              <p className="text-xs text-gray-500 mt-1">Questa descrizione aiuta i clienti a trovare e riconoscere la sede</p>
            </div>
          </div>
        </div>

        {claimedLocations.length === 0 && (
          <div className="border-t pt-6">
            <h3 className="text-lg font-bold text-gray-900 mb-4">Sede Operativa</h3>
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Nome Sede (opzionale)
                </label>
                <input
                  type="text"
                  value={formData.location_name}
                  onChange={(e) => setFormData({ ...formData, location_name: e.target.value })}
                  placeholder="Es. Sede di Milano, Negozio Centro, Filiale Roma Nord"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
                <p className="text-xs text-gray-500 mt-1">
                  Un nome descrittivo per identificare questa sede nel tuo profilo (lascia vuoto per usare la ragione sociale)
                </p>
              </div>

              <ItalianCityProvinceSelect
                province={formData.province}
                city={formData.city}
                onProvinceChange={(prov, code) => setFormData(prev => ({ ...prev, province: code || prov, city: '' }))}
                onCityChange={(c) => setFormData(prev => ({ ...prev, city: c }))}
                required
              />

              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  CAP Sede *
                </label>
                <input
                  type="text"
                  value={formData.postal_code}
                  onChange={(e) => setFormData({ ...formData, postal_code: e.target.value })}
                  required
                  maxLength={5}
                  placeholder="Es. 00100"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>

              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-2">
                  Indirizzo Sede *
                </label>
                <input
                  type="text"
                  value={formData.address}
                  onChange={(e) => setFormData({ ...formData, address: e.target.value })}
                  required
                  placeholder="Via, numero civico"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>

            </div>
          </div>
        )}

        <div className="flex gap-3 pt-4 border-t">
          <button
            type="submit"
            disabled={saving}
            className="flex items-center gap-2 bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors font-semibold disabled:opacity-50"
          >
            <Save className="w-5 h-5" />
            {saving ? 'Salvataggio...' : 'Registra Attività'}
          </button>
          <button
            type="button"
            onClick={onCancel}
            className="px-6 py-3 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors font-semibold"
          >
            Annulla
          </button>
        </div>
      </form>
    </div>
  );
}
