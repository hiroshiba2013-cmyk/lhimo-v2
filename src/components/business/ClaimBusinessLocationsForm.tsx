import { useState, useEffect } from 'react';
import { Search, MapPin, CheckCircle2, Building2, X, CreditCard, TrendingUp } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { getPlanSummary } from '../../lib/subscription-helper';
import { useToast } from '../common/Toast';

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

interface ClaimBusinessLocationsFormProps {
  onLocationsSelected: (locations: UnclaimedLocation[], billingPeriod: 'monthly' | 'yearly') => void;
  onCancel: () => void;
}

export function ClaimBusinessLocationsForm({
  onLocationsSelected,
  onCancel
}: ClaimBusinessLocationsFormProps) {
  const { showToast } = useToast();
  const [searchTerm, setSearchTerm] = useState('');
  const [searchResults, setSearchResults] = useState<UnclaimedLocation[]>([]);
  const [selectedLocations, setSelectedLocations] = useState<UnclaimedLocation[]>([]);
  const [searching, setSearching] = useState(false);
  const [billingPeriod, setBillingPeriod] = useState<'monthly' | 'yearly'>('monthly');

  const handleSearch = async () => {
    if (!searchTerm.trim()) return;

    setSearching(true);
    try {
      const { data, error } = await supabase
        .from('unclaimed_business_locations')
        .select('*')
        .eq('is_claimed', false)
        .or(`name.ilike.%${searchTerm}%,street.ilike.%${searchTerm}%,city.ilike.%${searchTerm}%`)
        .limit(20);

      if (error) throw error;
      setSearchResults(data || []);
    } catch (error) {
      console.error('Error searching locations:', error);
      showToast('Errore durante la ricerca delle sedi', 'error');
    } finally {
      setSearching(false);
    }
  };

  const toggleLocation = (location: UnclaimedLocation) => {
    setSelectedLocations(prev => {
      const isSelected = prev.some(l => l.id === location.id);
      if (isSelected) {
        return prev.filter(l => l.id !== location.id);
      } else {
        return [...prev, location];
      }
    });
  };

  const isLocationSelected = (locationId: string) => {
    return selectedLocations.some(l => l.id === locationId);
  };

  const handleConfirm = () => {
    if (selectedLocations.length === 0) {
      showToast('Seleziona almeno una sede da rivendicare', 'info');
      return;
    }
    onLocationsSelected(selectedLocations, billingPeriod);
  };

  return (
    <div className="bg-white rounded-xl shadow-md p-8">
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <Building2 className="w-6 h-6 text-blue-600" />
          <h2 className="text-2xl font-bold text-gray-900">Rivendica Sedi Esistenti</h2>
        </div>
        <button
          onClick={onCancel}
          className="text-gray-600 hover:text-gray-800"
        >
          <X className="w-6 h-6" />
        </button>
      </div>

      <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-6">
        <p className="text-sm text-blue-800">
          Cerca la tua attività per nome, indirizzo o città. Puoi selezionare più sedi se la tua attività ne ha diverse.
        </p>
      </div>

      <div className="mb-6">
        <label className="block text-sm font-semibold text-gray-700 mb-2">
          Cerca per nome, indirizzo o città
        </label>
        <div className="flex gap-2">
          <input
            type="text"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            onKeyPress={(e) => e.key === 'Enter' && handleSearch()}
            placeholder="Es: Pizzeria Da Mario, Via Roma, Milano..."
            className="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          />
          <button
            onClick={handleSearch}
            disabled={searching || !searchTerm.trim()}
            className="flex items-center gap-2 bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition-colors font-semibold disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <Search className="w-5 h-5" />
            {searching ? 'Ricerca...' : 'Cerca'}
          </button>
        </div>
      </div>

      {selectedLocations.length > 0 && (
        <>
          <div className="mb-6 bg-green-50 border border-green-200 rounded-lg p-4">
            <div className="flex items-center justify-between mb-3">
              <h3 className="font-semibold text-green-900">
                Sedi selezionate ({selectedLocations.length})
              </h3>
              <button
                onClick={() => setSelectedLocations([])}
                className="text-sm text-green-700 hover:text-green-900 font-medium"
              >
                Deseleziona tutte
              </button>
            </div>
            <div className="space-y-2">
              {selectedLocations.map((location) => (
                <div
                  key={location.id}
                  className="flex items-center justify-between bg-white rounded-lg p-3 border border-green-300"
                >
                  <div className="flex items-center gap-3">
                    <CheckCircle2 className="w-5 h-5 text-green-600 flex-shrink-0" />
                    <div>
                      <p className="font-semibold text-gray-900">{location.name}</p>
                      <p className="text-sm text-gray-600">
                        {location.street}, {location.city} ({location.province})
                      </p>
                    </div>
                  </div>
                  <button
                    onClick={() => toggleLocation(location)}
                    className="text-red-600 hover:text-red-800"
                  >
                    <X className="w-5 h-5" />
                  </button>
                </div>
              ))}
            </div>
          </div>

          <div className="mb-6 bg-gradient-to-br from-blue-50 to-blue-100 border-2 border-blue-300 rounded-xl p-6">
            <div className="flex items-center gap-3 mb-4">
              <div className="bg-blue-600 text-white p-3 rounded-lg">
                <CreditCard className="w-6 h-6" />
              </div>
              <div>
                <h3 className="text-lg font-bold text-gray-900">Piano Abbonamento Consigliato</h3>
                <p className="text-sm text-gray-600">In base al numero di sedi selezionate</p>
              </div>
            </div>

            <div className="mb-4 flex gap-2">
              <button
                onClick={() => setBillingPeriod('monthly')}
                className={`flex-1 py-2 px-4 rounded-lg font-semibold transition-all ${
                  billingPeriod === 'monthly'
                    ? 'bg-blue-600 text-white shadow-md'
                    : 'bg-white text-gray-700 hover:bg-gray-100'
                }`}
              >
                Mensile
              </button>
              <button
                onClick={() => setBillingPeriod('yearly')}
                className={`flex-1 py-2 px-4 rounded-lg font-semibold transition-all relative ${
                  billingPeriod === 'yearly'
                    ? 'bg-blue-600 text-white shadow-md'
                    : 'bg-white text-gray-700 hover:bg-gray-100'
                }`}
              >
                Annuale
                <span className="ml-1 text-xs bg-green-500 text-white px-2 py-0.5 rounded-full">
                  Risparmia
                </span>
              </button>
            </div>

            {(() => {
              const plan = getPlanSummary(selectedLocations.length, billingPeriod);
              const monthlyPrice = billingPeriod === 'monthly' ? plan.price : plan.pricePerMonth;
              const savings = billingPeriod === 'yearly' ? (getPlanSummary(selectedLocations.length, 'monthly').price * 12 - plan.price).toFixed(2) : '0';

              return (
                <div className="bg-white rounded-lg p-4 border-2 border-blue-200">
                  <div className="flex items-center justify-between mb-3">
                    <div>
                      <p className="text-lg font-bold text-gray-900">{plan.name}</p>
                      <p className="text-sm text-gray-600">
                        {selectedLocations.length} {selectedLocations.length === 1 ? 'sede' : 'sedi'}
                      </p>
                    </div>
                    <div className="text-right">
                      <p className="text-3xl font-bold text-blue-600">€{plan.price.toFixed(2)}</p>
                      <p className="text-sm text-gray-600">/{plan.period}</p>
                    </div>
                  </div>

                  {billingPeriod === 'yearly' && (
                    <div className="flex items-center gap-2 bg-green-50 border border-green-200 rounded-lg p-3">
                      <TrendingUp className="w-5 h-5 text-green-600" />
                      <div>
                        <p className="text-sm font-semibold text-green-900">
                          Risparmia €{savings} all'anno
                        </p>
                        <p className="text-xs text-green-700">
                          Solo €{monthlyPrice.toFixed(2)}/mese
                        </p>
                      </div>
                    </div>
                  )}

                  <div className="mt-3 pt-3 border-t border-gray-200">
                    <p className="text-xs text-gray-500">
                      Prezzi esclusi IVA. Il piano verrà attivato dopo la conferma dei dati dell'attività.
                    </p>
                  </div>
                </div>
              );
            })()}
          </div>
        </>
      )}

      {searchResults.length > 0 && (
        <div className="mb-6">
          <h3 className="font-semibold text-gray-900 mb-3">
            Risultati trovati ({searchResults.length})
          </h3>
          <div className="space-y-2 max-h-96 overflow-y-auto">
            {searchResults.map((location) => {
              const isSelected = isLocationSelected(location.id);
              return (
                <button
                  key={location.id}
                  onClick={() => toggleLocation(location)}
                  className={`w-full text-left p-4 rounded-lg border-2 transition-all ${
                    isSelected
                      ? 'border-green-500 bg-green-50'
                      : 'border-gray-200 bg-white hover:border-blue-300 hover:bg-blue-50'
                  }`}
                >
                  <div className="flex items-start justify-between">
                    <div className="flex-1">
                      <div className="flex items-center gap-2 mb-2">
                        <h4 className="font-semibold text-gray-900">{location.name}</h4>
                        {isSelected && (
                          <CheckCircle2 className="w-5 h-5 text-green-600 flex-shrink-0" />
                        )}
                      </div>
                      <div className="flex items-start gap-2 text-sm text-gray-600">
                        <MapPin className="w-4 h-4 flex-shrink-0 mt-0.5" />
                        <div>
                          <p>{location.street}</p>
                          <p>{location.postal_code} {location.city} ({location.province})</p>
                          {location.region && <p className="text-gray-500">{location.region}</p>}
                        </div>
                      </div>
                      {(location.phone || location.email || location.website) && (
                        <div className="mt-2 text-sm text-gray-600 space-y-1">
                          {location.phone && <p>Tel: {location.phone}</p>}
                          {location.email && <p>Email: {location.email}</p>}
                          {location.website && <p>Web: {location.website}</p>}
                        </div>
                      )}
                    </div>
                  </div>
                </button>
              );
            })}
          </div>
        </div>
      )}

      {searchResults.length === 0 && searchTerm && !searching && (
        <div className="text-center py-8 text-gray-500">
          <p>Nessuna sede trovata. Prova con un altro termine di ricerca.</p>
        </div>
      )}

      <div className="flex gap-3 pt-4 border-t">
        <button
          onClick={handleConfirm}
          disabled={selectedLocations.length === 0}
          className="flex-1 bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors font-semibold disabled:opacity-50 disabled:cursor-not-allowed"
        >
          Continua con {selectedLocations.length} sede{selectedLocations.length !== 1 ? 'i' : ''} selezionata{selectedLocations.length !== 1 ? 'e' : ''}
        </button>
        <button
          onClick={onCancel}
          className="px-6 py-3 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors font-semibold"
        >
          Annulla
        </button>
      </div>
    </div>
  );
}
