import { useState, useEffect } from 'react';
import { MapPin, FileEdit as Edit, Save, X, Building2, Instagram, Facebook, Globe } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { SearchableSelect } from '../common/SearchableSelect';
import { CategoryHierarchySelect } from '../common/CategoryHierarchySelect';
import { ItalianCityProvinceSelect } from '../common/ItalianCityProvinceSelect';
import { BusinessLocationAvatarUpload } from './BusinessLocationAvatarUpload';
import { BusinessLocationPhotos } from './BusinessLocationPhotos';
import { useAuth } from '../../contexts/AuthContext';
import { useToast } from '../common/Toast';

interface DayHours {
  open: string;
  close: string;
  closed: boolean;
}

interface BusinessHours {
  monday: DayHours;
  tuesday: DayHours;
  wednesday: DayHours;
  thursday: DayHours;
  friday: DayHours;
  saturday: DayHours;
  sunday: DayHours;
}

interface BusinessLocation {
  id: string;
  name: string | null;
  internal_name: string | null;
  address: string | null;
  city: string | null;
  province: string | null;
  postal_code: string | null;
  phone: string | null;
  email: string | null;
  website?: string | null;
  avatar_url: string | null;
  business_hours: BusinessHours | null;
  is_primary: boolean;
  description?: string | null;
  services?: string;
  services_description?: string | null;
  category_id?: string | null;
  instagram_url?: string | null;
  facebook_url?: string | null;
  tiktok_url?: string | null;
}

interface EditBusinessLocationsFormProps {
  businessId: string;
  selectedLocationId?: string | null;
  onUpdate: () => void;
}

export function EditBusinessLocationsForm({ businessId, selectedLocationId, onUpdate }: EditBusinessLocationsFormProps) {
  const { showToast } = useToast();
  const { refreshBusinessLocations } = useAuth();
  const [isEditing, setIsEditing] = useState(false);
  const [saving, setSaving] = useState(false);
  const [locations, setLocations] = useState<BusinessLocation[]>([]);
  const [loading, setLoading] = useState(true);
  const [maxLocations, setMaxLocations] = useState<number>(1);
  const [subscriptionPlan, setSubscriptionPlan] = useState<string>('');
  const [isRegisteredBusiness, setIsRegisteredBusiness] = useState(false);
  const [categories, setCategories] = useState<{ id: string; name: string; parent_id: string | null }[]>([]);

  useEffect(() => {
    supabase.from('business_categories').select('id, name, parent_id').order('name').then(({ data }) => {
      if (data) setCategories(data);
    });
  }, []);

  useEffect(() => {
    const loadLocations = async () => {
      setLoading(true);
      console.log('🔍 Loading locations for business:', businessId, 'selectedLocationId:', selectedLocationId);

      // Prova prima in registered_business_locations
      let { data } = await supabase
        .from('registered_business_locations')
        .select('*')
        .eq('business_id', businessId)
        .order('is_primary', { ascending: false });

      let usesRegisteredTable = false;
      // Fallback a business_locations
      if (!data || data.length === 0) {
        const result = await supabase
          .from('business_locations')
          .select('*')
          .eq('business_id', businessId)
          .order('is_primary', { ascending: false });
        data = result.data;
        usesRegisteredTable = false;
      } else {
        usesRegisteredTable = true;
      }

      setIsRegisteredBusiness(usesRegisteredTable);

      if (data && data.length > 0) {
        const normalizedData = data.map(loc => ({
          ...loc,
          // Normalizza address per compatibilità - concatena street + street_number
          address: loc.address || (loc.street && loc.street_number ? `${loc.street}, ${loc.street_number}` : loc.street || ''),
          services: Array.isArray(loc.services) && loc.services.length > 0
            ? loc.services.join(', ')
            : ''
        }));

        // Se c'è un selectedLocationId, filtra per mostrare solo quella sede
        const filteredData = selectedLocationId
          ? normalizedData.filter(loc => loc.id === selectedLocationId)
          : normalizedData;

        setLocations(filteredData);
      } else {
        // Se non ci sono sedi, aggiungi una sede di default e apri in modalità editing
        const defaultHours: DayHours = { open: '09:00', close: '18:00', closed: false };
        setLocations([{
          id: `new-${Date.now()}`,
          name: '',
          internal_name: 'Sede 1',
          address: '',
          city: '',
          province: '',
          postal_code: '',
          phone: '',
          email: '',
          avatar_url: null,
          description: '',
          services: '',
          services_description: '',
          business_hours: {
            monday: defaultHours,
            tuesday: defaultHours,
            wednesday: defaultHours,
            thursday: defaultHours,
            friday: defaultHours,
            saturday: { ...defaultHours, closed: true },
            sunday: { ...defaultHours, closed: true },
          },
          is_primary: true,
        }]);
        setIsEditing(true);
      }

      // Cerca il business owner e nome prima in registered_businesses
      let { data: businessData } = await supabase
        .from('registered_businesses')
        .select('owner_id, name')
        .eq('id', businessId)
        .maybeSingle();

      // Fallback a businesses
      if (!businessData) {
        const result = await supabase
          .from('businesses')
          .select('owner_id, name')
          .eq('id', businessId)
          .maybeSingle();
        businessData = result.data;
      }

      // Pre-compila "Nome Ufficiale Attività" con la ragione sociale se vuoto
      if (businessData?.name) {
        setLocations(prev => prev.map(loc => ({
          ...loc,
          name: loc.name || businessData!.name,
        })));
      }

      if (businessData) {
        const { data: subscriptionData, error: subError } = await supabase
          .from('subscriptions')
          .select(`
            plan_id,
            subscription_plans (
              name,
              max_persons
            )
          `)
          .eq('customer_id', businessData.owner_id)
          .eq('status', 'active')
          .maybeSingle();

        if (subscriptionData?.subscription_plans) {
          const plan = Array.isArray(subscriptionData.subscription_plans)
            ? subscriptionData.subscription_plans[0]
            : subscriptionData.subscription_plans;

          if (plan) {
            setMaxLocations(plan.max_persons || 1);
            setSubscriptionPlan(plan.name || '');
          }
        }
      }

      setLoading(false);
    };

    loadLocations();
  }, [businessId, selectedLocationId]);


  const handleRemoveLocation = async (id: string) => {
    const location = locations.find(l => l.id === id);

    if (location?.is_primary && locations.length > 1) {
      showToast('Non puoi rimuovere la sede principale. Imposta prima un\'altra sede come principale.', 'error');
      return;
    }

    if (id.startsWith('new-')) {
      setLocations(locations.filter(l => l.id !== id));
    } else {
      if (!confirm('Sei sicuro di voler rimuovere questa sede?')) return;

      // Prova prima in registered_business_locations
      let { error } = await supabase
        .from('registered_business_locations')
        .delete()
        .eq('id', id);

      // Fallback a business_locations
      if (error?.code === 'PGRST116') {
        const result = await supabase
          .from('business_locations')
          .delete()
          .eq('id', id);
        error = result.error;
      }

      if (error) {
        console.error('Error deleting location:', error);
        showToast('Errore durante l\'eliminazione', 'error');
      } else {
        setLocations(locations.filter(l => l.id !== id));
        onUpdate();
      }
    }
  };

  const handleChange = (id: string, field: keyof BusinessLocation, value: string | boolean) => {
    console.log('handleChange called:', { id, field, value, valueType: typeof value });

    if (field === 'is_primary' && value === true) {
      setLocations(locations.map(location => ({
        ...location,
        is_primary: location.id === id,
      })));
    } else {
      console.log('Setting field', field, 'to value:', value);
      setLocations(prev => {
        const updated = prev.map(location => {
          if (location.id === id) {
            console.log('Updating location', id, 'old value:', location[field], 'new value:', value);
            return { ...location, [field]: value };
          }
          return location;
        });
        console.log('Updated locations:', updated);
        return updated;
      });
    }
  };

  const handleHoursChange = (id: string, day: keyof BusinessHours, field: keyof DayHours, value: string | boolean) => {
    setLocations(locations.map(location => {
      if (location.id === id && location.business_hours) {
        return {
          ...location,
          business_hours: {
            ...location.business_hours,
            [day]: {
              ...location.business_hours[day],
              [field]: value,
            },
          },
        };
      }
      return location;
    }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);

    const { data: { user } } = await supabase.auth.getUser();

    let { data: businessCheck } = await supabase
      .from('registered_businesses')
      .select('id, owner_id')
      .eq('id', businessId)
      .maybeSingle();

    if (!businessCheck) {
      const result = await supabase
        .from('businesses')
        .select('id, owner_id')
        .eq('id', businessId)
        .maybeSingle();
      businessCheck = result.data;
    }

    if (!businessCheck || businessCheck.owner_id !== user?.id) {
      showToast('Non hai i permessi per modificare questa attività', 'info');
      setSaving(false);
      return;
    }

    try {
      for (const location of locations) {
        const address = location.address ?? '';
        const city = location.city ?? '';
        const province = location.province ?? '';
        const postalCode = location.postal_code ?? '';
        const name = location.name ?? '';
        const phone = location.phone ?? '';
        const email = location.email ?? '';

        if (!address.trim()) {
          showToast('Compila l\'indirizzo per tutte le sedi', 'info');
          setSaving(false);
          return;
        }
        if (!city.trim()) {
          showToast('Seleziona la città per tutte le sedi', 'info');
          setSaving(false);
          return;
        }
        if (!province.trim()) {
          showToast('Seleziona la provincia per tutte le sedi', 'info');
          setSaving(false);
          return;
        }
        if (!/^[A-Z]{2}$/.test(province.trim())) {
          showToast('Formato provincia non valido. Seleziona la città dal menu per impostare automaticamente la provincia.', 'info');
          setSaving(false);
          return;
        }
        if (!postalCode.trim()) {
          showToast('Compila il CAP per tutte le sedi', 'info');
          setSaving(false);
          return;
        }

        const servicesString = (location.services || '').trim();
        const servicesArray = servicesString.length > 0
          ? servicesString.split(',').map(s => s.trim()).filter(s => s.length > 0)
          : null;

        const tableName = isRegisteredBusiness ? 'registered_business_locations' : 'business_locations';

        const locationFields: Record<string, any> = {
          name: name.trim() || 'Sede',
          internal_name: location.internal_name?.trim() || null,
          city: city.trim(),
          province: province.trim(),
          postal_code: postalCode.trim(),
          phone: phone.trim() || null,
          email: email.trim() || null,
          website: location.website?.trim() || null,
          business_hours: location.business_hours,
          is_primary: location.is_primary,
          description: location.description?.trim() || null,
          services: servicesArray,
          services_description: location.services_description?.trim() || null,
          instagram_url: location.instagram_url?.trim() || null,
          facebook_url: location.facebook_url?.trim() || null,
          tiktok_url: location.tiktok_url?.trim() || null,
          ...(isRegisteredBusiness && { category_id: location.category_id || null }),
        };

        if (isRegisteredBusiness) {
          locationFields.street = address.trim();
        } else {
          locationFields.address = address.trim();
        }

        if (location.id.startsWith('new-')) {
          const { error } = await supabase
            .from(tableName)
            .insert({ business_id: businessId, ...locationFields });

          if (error) throw error;
        } else {
          const { error } = await supabase
            .from(tableName)
            .update(locationFields)
            .eq('id', location.id);

          if (error) throw error;
        }
      }

      setIsEditing(false);

      const tableName = isRegisteredBusiness ? 'registered_business_locations' : 'business_locations';
      const { data: updatedData } = await supabase
        .from(tableName)
        .select('*')
        .eq('business_id', businessId)
        .order('is_primary', { ascending: false });

      if (updatedData) {
        const normalizedData = updatedData.map(loc => ({
          ...loc,
          address: loc.address || loc.street,
          services: Array.isArray(loc.services)
            ? loc.services.join(', ')
            : (loc.services || '')
        }));
        setLocations(normalizedData);
      }

      onUpdate();
      await refreshBusinessLocations();
    } catch (error: any) {
      console.error('Error updating locations:', error);
      const errorMessage = error?.message || 'Errore durante il salvataggio';
      showToast(`Errore durante il salvataggio: ${errorMessage}\n\nAssicurati di aver compilato tutti i campi obbligatori (indirizzo, città, CAP, 'error').`);
    } finally {
      setSaving(false);
    }
  };

  const handleCancel = async () => {
    setLoading(true);
    const tableName = isRegisteredBusiness ? 'registered_business_locations' : 'business_locations';
    const { data } = await supabase
      .from(tableName)
      .select('*')
      .eq('business_id', businessId)
      .order('is_primary', { ascending: false });

    if (data) {
      const normalizedData = data.map(loc => ({
        ...loc,
        address: loc.address || (loc.street && loc.street_number ? `${loc.street}, ${loc.street_number}` : loc.street || ''),
        services: Array.isArray(loc.services)
          ? loc.services.join(', ')
          : (loc.services || '')
      }));
      setLocations(normalizedData);
    }
    setLoading(false);
    setIsEditing(false);
  };

  if (loading) {
    return (
      <div className="bg-white rounded-xl shadow-md p-8 mb-8">
        <div className="text-center py-8">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div>
        </div>
      </div>
    );
  }

  if (!isEditing) {
    const displayLocations = selectedLocationId
      ? locations.filter(loc => loc.id === selectedLocationId)
      : locations;

    return (
      <div className="bg-white rounded-xl shadow-md p-5 mb-6">
        <div className="flex items-center justify-between mb-4">
          <div className="flex items-center gap-3">
            <MapPin className="w-5 h-5 text-blue-600" />
            <h2 className="text-lg font-bold text-gray-900">
              {selectedLocationId ? 'Punto Vendita Selezionato' : 'Punti Vendita'}
            </h2>
          </div>
          <button
            onClick={() => setIsEditing(true)}
            className="flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors"
          >
            <Edit className="w-4 h-4" />
            Modifica
          </button>
        </div>

        {displayLocations.length === 0 ? (
          <p className="text-gray-600 text-center py-8">Nessun punto vendita aggiunto</p>
        ) : (
          <div className="space-y-4">
            {displayLocations.map((location, index) => (
              <div key={location.id} className={`border rounded-lg p-4 ${
                location.is_primary ? 'border-blue-500 bg-blue-50' : 'border-gray-200 bg-gray-50'
              }`}>
                <div className="flex items-start gap-4 mb-3">
                  {!location.id.startsWith('new-') && (
                    <BusinessLocationAvatarUpload
                      locationId={location.id}
                      currentAvatarUrl={location.avatar_url}
                      table={isRegisteredBusiness ? 'registered_business_locations' : 'business_locations'}
                      onAvatarUpdate={(url) => {
                        setLocations(locations.map(loc =>
                          loc.id === location.id ? { ...loc, avatar_url: url } : loc
                        ));
                      }}
                    />
                  )}
                  <div className="flex-1">
                    <div className="flex items-center justify-between mb-1.5">
                      <div>
                        <h3 className="font-semibold text-base text-gray-900">{location.internal_name || `Sede ${index + 1}`}</h3>
                        <p className="text-xs text-gray-500">{location.name}</p>
                      </div>
                      {location.is_primary && (
                        <span className="bg-blue-600 text-white text-xs font-semibold px-2 py-0.5 rounded-full">
                          PRINCIPALE
                        </span>
                      )}
                    </div>
                    {location.description && (
                      <p className="text-xs text-gray-600 mb-2 italic">{location.description}</p>
                    )}
                    {location.services_description && (
                      <div className="mb-2 p-2 bg-blue-50 border border-blue-200 rounded-lg">
                        <p className="text-xs font-semibold text-blue-900 mb-0.5">Servizi Disponibili</p>
                        <p className="text-xs text-blue-800">{location.services_description}</p>
                      </div>
                    )}
                    <div className="grid md:grid-cols-2 gap-2">
                      <div>
                        <p className="text-xs text-gray-500">Indirizzo</p>
                        <p className="text-sm font-medium text-gray-900">{location.address}</p>
                      </div>
                      <div>
                        <p className="text-xs text-gray-500">Città</p>
                        <p className="text-sm font-medium text-gray-900">{location.city} ({location.province})</p>
                      </div>
                      <div>
                        <p className="text-xs text-gray-500">CAP</p>
                        <p className="text-sm font-medium text-gray-900">{location.postal_code}</p>
                      </div>
                      <div>
                        <p className="text-xs text-gray-500">Telefono</p>
                        <p className="text-sm font-medium text-gray-900">{location.phone}</p>
                      </div>
                      {location.email && (
                        <div>
                          <p className="text-xs text-gray-500">Email</p>
                          <p className="text-sm font-medium text-gray-900">{location.email}</p>
                        </div>
                      )}
                      {location.website && (
                        <div>
                          <p className="text-xs text-gray-500">Sito Web</p>
                          <a href={location.website} target="_blank" rel="noopener noreferrer" className="flex items-center gap-1 text-sm text-blue-600 hover:underline font-medium">
                            <Globe className="w-4 h-4" />Visita sito
                          </a>
                        </div>
                      )}
                      <div className="md:col-span-2">
                        <p className="text-xs text-gray-500 mb-1">Social Media</p>
                        {(location.instagram_url || location.facebook_url || location.tiktok_url) ? (
                          <div className="flex gap-3">
                            {location.instagram_url && (
                              <a href={location.instagram_url} target="_blank" rel="noopener noreferrer" className="flex items-center gap-1 text-sm text-pink-600 hover:underline">
                                <Instagram className="w-4 h-4" />Instagram
                              </a>
                            )}
                            {location.facebook_url && (
                              <a href={location.facebook_url} target="_blank" rel="noopener noreferrer" className="flex items-center gap-1 text-sm text-blue-600 hover:underline">
                                <Facebook className="w-4 h-4" />Facebook
                              </a>
                            )}
                            {location.tiktok_url && (
                              <a href={location.tiktok_url} target="_blank" rel="noopener noreferrer" className="flex items-center gap-1 text-sm text-gray-800 hover:underline">
                                <svg className="w-4 h-4" viewBox="0 0 24 24" fill="currentColor"><path d="M19.59 6.69a4.83 4.83 0 01-3.77-4.25V2h-3.45v13.67a2.89 2.89 0 01-2.88 2.5 2.89 2.89 0 01-2.89-2.89 2.89 2.89 0 012.89-2.89c.28 0 .54.04.79.1V9.01a6.33 6.33 0 00-.79-.05 6.34 6.34 0 00-6.34 6.34 6.34 6.34 0 006.34 6.34 6.34 6.34 0 006.33-6.34V8.97a8.27 8.27 0 004.84 1.55V7.07a4.85 4.85 0 01-1.07-.38z"/></svg>TikTok
                              </a>
                            )}
                          </div>
                        ) : (
                          <p className="text-sm text-gray-400 italic">Nessun social collegato — clicca Modifica per aggiungere</p>
                        )}
                      </div>
                    </div>
                  </div>
                </div>
                {location.business_hours && (
                  <div className="mt-2">
                    <p className="text-xs text-gray-500 mb-1 font-semibold uppercase tracking-wide">Orari di Apertura</p>
                    <div className="grid grid-cols-2 gap-1 text-xs">
                      {(['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'] as const).map(day => {
                        const dayNames = {
                          monday: 'Lunedì',
                          tuesday: 'Martedì',
                          wednesday: 'Mercoledì',
                          thursday: 'Giovedì',
                          friday: 'Venerdì',
                          saturday: 'Sabato',
                          sunday: 'Domenica',
                        };
                        const hours = location.business_hours![day];
                        return (
                          <div key={day} className="flex justify-between">
                            <span className="font-medium">{dayNames[day]}:</span>
                            <span className={hours.closed ? 'text-gray-500 italic' : 'text-gray-900'}>
                              {hours.closed ? 'Chiuso' : `${hours.open} - ${hours.close}`}
                            </span>
                          </div>
                        );
                      })}
                    </div>
                  </div>
                )}
                {!location.id.startsWith('new-') && isRegisteredBusiness && (
                  <div className="mt-4 pt-4 border-t border-gray-100">
                    <BusinessLocationPhotos locationId={location.id} />
                  </div>
                )}
              </div>
            ))}
          </div>
        )}
      </div>
    );
  }

  const editLocations = selectedLocationId
    ? locations.filter(loc => loc.id === selectedLocationId)
    : locations;

  return (
    <div className="bg-white rounded-xl shadow-md p-5 mb-6">
      <div className="flex items-center justify-between mb-4">
        <div className="flex items-center gap-3">
          <MapPin className="w-5 h-5 text-blue-600" />
          <h2 className="text-lg font-bold text-gray-900">
            {selectedLocationId ? 'Modifica Punto Vendita Selezionato' : 'Modifica Punti Vendita'}
          </h2>
        </div>
        <button
          onClick={handleCancel}
          className="text-gray-600 hover:text-gray-800"
        >
          <X className="w-6 h-6" />
        </button>
      </div>

      <div className="mb-4 p-4 bg-gradient-to-r from-blue-50 to-green-50 border-2 border-blue-300 rounded-lg">
        <p className="text-sm text-gray-700 mb-2">
          <span className="font-semibold">Importante:</span> I punti vendita sono separati dai dati aziendali legali (ragione sociale, P.IVA, ecc.).
        </p>
        <p className="text-xs text-gray-600">
          Ogni punto vendita deve contenere tutte le informazioni necessarie per essere trovato dai clienti,
          anche se alcune informazioni coincidono con quelle della sede legale. I campi contrassegnati con * sono obbligatori.
        </p>
      </div>

      <form onSubmit={handleSubmit}>
        <div className="space-y-6 mb-6">
          {editLocations.map((location, index) => (
            <div key={location.id} className={`border-2 rounded-lg p-6 ${
              location.is_primary ? 'border-blue-500 bg-blue-50' : 'border-gray-200 bg-gray-50'
            }`}>
              <div className="flex items-start justify-between mb-4">
                <div className="flex items-center gap-4 flex-1">
                  {!location.id.startsWith('new-') && (
                    <BusinessLocationAvatarUpload
                      locationId={location.id}
                      currentAvatarUrl={location.avatar_url}
                      table={isRegisteredBusiness ? 'registered_business_locations' : 'business_locations'}
                      onAvatarUpdate={(url) => {
                        setLocations(locations.map(loc =>
                          loc.id === location.id ? { ...loc, avatar_url: url } : loc
                        ));
                      }}
                    />
                  )}
                  <div className="flex-1">
                    <div className="flex items-center gap-2 mb-1">
                      <input
                        type="text"
                        value={location.internal_name || ''}
                        onChange={(e) => handleChange(location.id, 'internal_name', e.target.value)}
                        placeholder="Es. Sede 1, Sede 2..."
                        className="flex-1 px-3 py-1.5 border-2 border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 font-semibold text-base text-gray-700"
                      />
                      {location.is_primary && (
                        <span className="bg-blue-600 text-white text-xs font-semibold px-3 py-1 rounded-full whitespace-nowrap">
                          PRINCIPALE
                        </span>
                      )}
                    </div>
                    <p className="text-xs text-gray-500">
                      Etichetta privata per riconoscere questa sede nel tuo profilo
                    </p>
                    {location.id.startsWith('new-') && (
                      <p className="text-xs text-orange-600 mt-1">Salva per caricare l'immagine della sede</p>
                    )}
                  </div>
                </div>
              </div>

              <div className="grid md:grid-cols-2 gap-4 mb-4">
                <div className="md:col-span-2 bg-blue-50 border border-blue-200 rounded-lg p-4">
                  <label className="block text-base font-bold text-blue-900 mb-2 flex items-center gap-2">
                    <Building2 className="w-5 h-5" />
                    Nome Ufficiale Attività *
                  </label>
                  <input
                    type="text"
                    value={location.name || ''}
                    onChange={(e) => handleChange(location.id, 'name', e.target.value)}
                    required
                    placeholder="Es. Ristorante Da Mario, Farmacia Centrale, Parrucchiere Stile..."
                    className="w-full px-4 py-3 border-2 border-blue-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 font-medium text-lg"
                  />
                  <p className="text-sm text-blue-700 mt-2 flex items-start gap-1">
                    <span className="font-semibold">ℹ️</span>
                    <span>Questo è il nome che vedranno gli utenti quando cercano la tua attività</span>
                  </p>
                </div>

                <div className="md:col-span-2">
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Descrizione
                  </label>
                  <textarea
                    value={location.description || ''}
                    onChange={(e) => handleChange(location.id, 'description', e.target.value)}
                    placeholder="Breve descrizione della sede (es. 'Negozio nel centro storico con ampio parcheggio')"
                    rows={2}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
                  />
                  <p className="text-xs text-gray-500 mt-1">Questa descrizione aiuta i clienti a trovare e riconoscere la sede</p>
                </div>

                {isRegisteredBusiness && (
                  <div className="md:col-span-2">
                    <label className="block text-sm font-semibold text-gray-700 mb-2">
                      Categoria Sede (opzionale)
                    </label>
                    <CategoryHierarchySelect
                      value={location.category_id || ''}
                      onChange={(value) => handleChange(location.id, 'category_id', value)}
                      categories={categories}
                      placeholder="Stessa categoria dell'azienda"
                    />
                  </div>
                )}

                <div className="md:col-span-2">
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Servizi Disponibili
                  </label>
                  <textarea
                    value={location.services_description || ''}
                    onChange={(e) => handleChange(location.id, 'services_description', e.target.value)}
                    placeholder="Descrivi i servizi offerti in questa sede (es. WiFi gratuito, parcheggio, consegna a domicilio, ecc.)"
                    rows={3}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
                  />
                </div>

                <div className="md:col-span-2">
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Indirizzo *
                  </label>
                  <input
                    type="text"
                    value={location.address || ''}
                    onChange={(e) => handleChange(location.id, 'address', e.target.value)}
                    required
                    placeholder="Via, numero civico"
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  />
                </div>

                <div className="col-span-full">
                  <ItalianCityProvinceSelect
                    province={location.province || ''}
                    city={location.city || ''}
                    onProvinceChange={(prov, code) => {
                      setLocations(locations.map(l => l.id === location.id ? { ...l, province: code || prov, city: '' } : l));
                    }}
                    onCityChange={(c) => handleChange(location.id, 'city', c)}
                    required
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    CAP *
                  </label>
                  <input
                    type="text"
                    value={location.postal_code || ''}
                    onChange={(e) => handleChange(location.id, 'postal_code', e.target.value)}
                    required
                    maxLength={5}
                    placeholder="00000"
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Telefono (opzionale)
                  </label>
                  <input
                    type="tel"
                    value={location.phone || ''}
                    onChange={(e) => handleChange(location.id, 'phone', e.target.value)}
                    placeholder="Es. +39 123 456789"
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  />
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Email Sede (opzionale)
                  </label>
                  <input
                    type="email"
                    value={location.email || ''}
                    onChange={(e) => handleChange(location.id, 'email', e.target.value)}
                    placeholder="Es. sede@azienda.it"
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  />
                </div>

                <div className="md:col-span-2">
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Sito Web (opzionale)
                  </label>
                  <div className="flex items-center gap-2">
                    <Globe className="w-5 h-5 text-blue-600 flex-shrink-0" />
                    <input
                      type="url"
                      value={location.website || ''}
                      onChange={(e) => handleChange(location.id, 'website', e.target.value)}
                      placeholder="https://www.esempio.it"
                      className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    />
                  </div>
                </div>

                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-2">
                    Instagram (opzionale)
                  </label>
                  <div className="flex items-center gap-2">
                    <Instagram className="w-5 h-5 text-pink-500 flex-shrink-0" />
                    <input
                      type="url"
                      value={location.instagram_url || ''}
                      onChange={(e) => handleChange(location.id, 'instagram_url', e.target.value)}
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
                      value={location.facebook_url || ''}
                      onChange={(e) => handleChange(location.id, 'facebook_url', e.target.value)}
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
                      value={location.tiktok_url || ''}
                      onChange={(e) => handleChange(location.id, 'tiktok_url', e.target.value)}
                      placeholder="https://tiktok.com/@..."
                      className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-gray-400 focus:border-transparent"
                    />
                  </div>
                </div>

                {!selectedLocationId && (
                  <div className="flex items-center">
                    <label className="flex items-center gap-2 cursor-pointer">
                      <input
                        type="checkbox"
                        checked={location.is_primary}
                        onChange={(e) => handleChange(location.id, 'is_primary', e.target.checked)}
                        className="w-5 h-5 text-blue-600 border-gray-300 rounded focus:ring-2 focus:ring-blue-500"
                      />
                      <span className="text-sm font-semibold text-gray-700">
                        Sede Principale
                      </span>
                    </label>
                  </div>
                )}
              </div>

              {location.business_hours && (
                <div className="mt-4">
                  <label className="block text-sm font-bold text-gray-700 mb-2">
                    Orari di Apertura
                  </label>
                  <div className="space-y-2 bg-gray-50 p-4 rounded-lg">
                    {(['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'] as const).map(day => {
                      const dayNames = {
                        monday: 'Lunedì',
                        tuesday: 'Martedì',
                        wednesday: 'Mercoledì',
                        thursday: 'Giovedì',
                        friday: 'Venerdì',
                        saturday: 'Sabato',
                        sunday: 'Domenica',
                      };
                      const dayHours = location.business_hours![day];

                      return (
                        <div key={day} className="flex items-center gap-3 text-sm">
                          <label className="flex items-center gap-2 w-32">
                            <input
                              type="checkbox"
                              checked={!dayHours.closed}
                              onChange={(e) => handleHoursChange(location.id, day, 'closed', !e.target.checked)}
                              className="w-4 h-4 text-blue-600 border-gray-300 rounded focus:ring-2 focus:ring-blue-500"
                            />
                            <span className="font-medium">{dayNames[day]}</span>
                          </label>
                          {!dayHours.closed && (
                            <>
                              <input
                                type="time"
                                value={dayHours.open}
                                onChange={(e) => handleHoursChange(location.id, day, 'open', e.target.value)}
                                className="px-3 py-1 border border-gray-300 rounded focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                              />
                              <span>-</span>
                              <input
                                type="time"
                                value={dayHours.close}
                                onChange={(e) => handleHoursChange(location.id, day, 'close', e.target.value)}
                                className="px-3 py-1 border border-gray-300 rounded focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                              />
                            </>
                          )}
                          {dayHours.closed && (
                            <span className="text-gray-500 italic">Chiuso</span>
                          )}
                        </div>
                      );
                    })}
                  </div>
                </div>
              )}
            </div>
          ))}
        </div>

        {!selectedLocationId && locations.length > 0 && (
          <div className="mb-6 p-4 bg-blue-50 border border-blue-200 rounded-lg">
            <p className="text-sm text-gray-700 text-center">
              <span className="font-semibold">Nota:</span> Le sedi possono essere aggiunte solo durante la registrazione dell'attività.
              Da questa sezione puoi modificare le informazioni delle sedi esistenti.
            </p>
          </div>
        )}

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
