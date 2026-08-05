import { useState, useEffect } from 'react';
import { Search, Filter, X, CheckCircle, ChevronDown, ChevronUp } from 'lucide-react';
import { SearchableSelect } from '../common/SearchableSelect';
import { MultiSelectCheckbox } from '../common/MultiSelectCheckbox';
import { ItalianCityProvinceSelect } from '../common/ItalianCityProvinceSelect';
import BusinessAutocomplete from './BusinessAutocomplete';
import { useItalianLocations } from '../../hooks/useItalianLocations';
import { useMacroCategories, useMicroCategories, useSpecializations, useBusinessServices } from '../../hooks/useCatalog';

export interface SearchFilters {
  macro_category: string;
  micro_category: string;
  specializations: string[];
  services: string[];
  region: string;
  province: string;
  city: string;
  businessName: string;
  minRating: number;
  verifiedOnly?: boolean;
  minServiceUsedRating?: number;
  minBookingRating?: number;
  minQuoteRating?: number;
  minCustomerServiceRating?: number;
  minProblemRating?: number;
}

interface AdvancedSearchProps {
  onSearch: (filters: SearchFilters) => void;
  isLoading?: boolean;
  navigateToSearchPage?: boolean;
  initialFilters?: SearchFilters;
}

const RATING_OPTIONS = [
  { value: '0', label: 'Qualsiasi' },
  { value: '1', label: '1 stella e più' },
  { value: '2', label: '2 stelle e più' },
  { value: '3', label: '3 stelle e più' },
  { value: '4', label: '4 stelle e più' },
  { value: '5', label: '5 stelle' },
];

export function AdvancedSearch({ onSearch, isLoading = false, navigateToSearchPage = false, initialFilters }: AdvancedSearchProps) {
  const { regions } = useItalianLocations();
  const { macroCategories } = useMacroCategories();
  const [showAdvanced, setShowAdvanced] = useState(false);
  const [showRatingFilters, setShowRatingFilters] = useState(false);

  const [selectedMacroId, setSelectedMacroId] = useState('');
  const [selectedMicroId, setSelectedMicroId] = useState('');
  const [selectedSpecializations, setSelectedSpecializations] = useState<string[]>([]);
  const [selectedServices, setSelectedServices] = useState<string[]>([]);
  const { microCategories } = useMicroCategories(selectedMacroId || null);
  const { specializations } = useSpecializations(selectedMacroId || null);
  const { services } = useBusinessServices(selectedMacroId || null);

  const [filters, setFilters] = useState<SearchFilters>(initialFilters || {
    macro_category: '',
    micro_category: '',
    specializations: [],
    services: [],
    region: '',
    province: '',
    city: '',
    businessName: '',
    minRating: 0,
    verifiedOnly: false,
    minServiceUsedRating: 0,
    minBookingRating: 0,
    minQuoteRating: 0,
    minCustomerServiceRating: 0,
    minProblemRating: 0,
  });

  useEffect(() => {
    if (initialFilters) {
      setFilters({ ...initialFilters });
      setSelectedMacroId(initialFilters.macro_category || '');
      setSelectedMicroId(initialFilters.micro_category || '');
      setSelectedSpecializations(initialFilters.specializations || []);
      setSelectedServices(initialFilters.services || []);
      const hasAdvanced = initialFilters.macro_category || initialFilters.province || initialFilters.city || (initialFilters.minRating || 0) > 0;
      if (hasAdvanced) setShowAdvanced(true);
      const hasRating = (initialFilters.minServiceUsedRating || 0) > 0 || (initialFilters.minBookingRating || 0) > 0 ||
        (initialFilters.minQuoteRating || 0) > 0 || (initialFilters.minCustomerServiceRating || 0) > 0 || (initialFilters.minProblemRating || 0) > 0;
      if (hasRating) { setShowAdvanced(true); setShowRatingFilters(true); }
    }
  }, [initialFilters]);

  const handleMacroChange = (macroId: string) => {
    setSelectedMacroId(macroId);
    setSelectedMicroId('');
    setSelectedSpecializations([]);
    setSelectedServices([]);
    setFilters(prev => ({ ...prev, macro_category: macroId, micro_category: '', specializations: [], services: [] }));
  };

  const handleSearchClick = () => {
    const params = new URLSearchParams();
    if (filters.macro_category) params.set('macro_category', filters.macro_category);
    if (filters.micro_category) params.set('micro_category', filters.micro_category);
    if (filters.specializations?.length) params.set('specializations', filters.specializations.join(','));
    if (filters.services?.length) params.set('services', filters.services.join(','));
    if (filters.region) params.set('region', filters.region);
    if (filters.province) params.set('province', filters.province);
    if (filters.city) params.set('city', filters.city);
    if (filters.businessName) params.set('name', filters.businessName);
    if (filters.minRating > 0) params.set('rating', String(filters.minRating));
    if (filters.verifiedOnly) params.set('verified', 'true');
    if ((filters.minServiceUsedRating || 0) > 0) params.set('r_service', String(filters.minServiceUsedRating));
    if ((filters.minBookingRating || 0) > 0) params.set('r_booking', String(filters.minBookingRating));
    if ((filters.minQuoteRating || 0) > 0) params.set('r_quote', String(filters.minQuoteRating));
    if ((filters.minCustomerServiceRating || 0) > 0) params.set('r_cs', String(filters.minCustomerServiceRating));
    if ((filters.minProblemRating || 0) > 0) params.set('r_problem', String(filters.minProblemRating));

    const queryString = params.toString();
    const url = queryString ? `/search?${queryString}` : '/search';

    if (navigateToSearchPage) {
      window.location.href = url;
    } else {
      window.history.pushState({}, '', url);
      onSearch(filters);
    }
  };

  const handleReset = () => {
    const empty: SearchFilters = {
      macro_category: '', micro_category: '', specializations: [], services: [],
      region: '', province: '', city: '',
      businessName: '', minRating: 0, verifiedOnly: false,
      minServiceUsedRating: 0, minBookingRating: 0,
      minQuoteRating: 0, minCustomerServiceRating: 0, minProblemRating: 0,
    };
    setSelectedMacroId('');
    setSelectedMicroId('');
    setSelectedSpecializations([]);
    setSelectedServices([]);
    setFilters(empty);
    onSearch(empty);
  };

  const hasActiveFilters = filters.macro_category || filters.region || filters.province || filters.city ||
    filters.businessName || filters.minRating > 0 || (filters.specializations?.length || 0) > 0 || (filters.services?.length || 0) > 0 ||
    (filters.minServiceUsedRating || 0) > 0 || (filters.minBookingRating || 0) > 0 ||
    (filters.minQuoteRating || 0) > 0 || (filters.minCustomerServiceRating || 0) > 0 || (filters.minProblemRating || 0) > 0;

  const activeFilterCount = [
    filters.macro_category, filters.region, filters.province, filters.city,
    filters.minRating > 0 ? 'rating' : '',
    (filters.specializations?.length || 0) > 0 ? 'specs' : '',
    (filters.services?.length || 0) > 0 ? 'svcs' : '',
    (filters.minServiceUsedRating || 0) > 0 ? 'service' : '',
    (filters.minBookingRating || 0) > 0 ? 'booking' : '',
    (filters.minQuoteRating || 0) > 0 ? 'quote' : '',
    (filters.minCustomerServiceRating || 0) > 0 ? 'cs' : '',
    (filters.minProblemRating || 0) > 0 ? 'problem' : '',
  ].filter(Boolean).length;

  return (
    <div className="space-y-3">
      <div className="max-w-4xl mx-auto bg-white rounded-lg shadow-lg p-4">
        <BusinessAutocomplete
          value={filters.businessName}
          onChange={(value) => setFilters(prev => ({ ...prev, businessName: value }))}
          onSelect={(businessId) => {
            window.location.href = `/business/${businessId}`;
          }}
          placeholder="Cerca attività per nome..."
        />

        {showAdvanced && (
          <div className="mt-4 pt-4 border-t border-gray-200 space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Macro Categoria</label>
                <SearchableSelect
                  value={selectedMacroId}
                  onChange={(value) => handleMacroChange(value)}
                  options={macroCategories.map(m => ({ value: m.id, label: m.name }))}
                  placeholder="Tutte le macro categorie"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Micro Categoria</label>
                <SearchableSelect
                  value={selectedMicroId}
                  onChange={(value) => {
                    setSelectedMicroId(value);
                    setFilters(prev => ({ ...prev, micro_category: value }));
                  }}
                  options={microCategories.map(m => ({ value: m.id, label: m.name }))}
                  placeholder={selectedMacroId ? 'Tutte le micro categorie' : 'Prima seleziona una macro'}
                  disabled={!selectedMacroId}
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Valutazione Totale Min.</label>
                <SearchableSelect
                  value={String(filters.minRating)}
                  onChange={(value) => setFilters(prev => ({ ...prev, minRating: Number(value) }))}
                  options={RATING_OPTIONS}
                  placeholder="Qualsiasi"
                  className="text-sm"
                />
              </div>

              <div className="lg:col-span-3">
                <label className="block text-sm font-medium text-gray-700 mb-2">Specializzazioni</label>
                <MultiSelectCheckbox
                  options={specializations.map(s => ({ id: s.id, name: s.name }))}
                  selected={selectedSpecializations}
                  onChange={(sel) => {
                    setSelectedSpecializations(sel);
                    setFilters(prev => ({ ...prev, specializations: sel }));
                  }}
                  placeholder={selectedMacroId ? 'Seleziona specializzazioni' : 'Prima seleziona una macro'}
                />
              </div>

              <div className="lg:col-span-3">
                <label className="block text-sm font-medium text-gray-700 mb-2">Servizi</label>
                <MultiSelectCheckbox
                  options={services.map(s => ({ id: s.id, name: s.name }))}
                  selected={selectedServices}
                  onChange={(sel) => {
                    setSelectedServices(sel);
                    setFilters(prev => ({ ...prev, services: sel }));
                  }}
                  placeholder={selectedMacroId ? 'Seleziona servizi' : 'Prima seleziona una macro'}
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">&nbsp;</label>
                <button
                  onClick={handleReset}
                  className="w-full px-3 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors text-sm font-medium flex items-center justify-center gap-2"
                >
                  <X className="w-4 h-4" />
                  Azzera filtri
                </button>
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1.5">Regione</label>
              <select
                value={filters.region}
                onChange={(e) => setFilters(prev => ({ ...prev, region: e.target.value, province: '', city: '' }))}
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
              onProvinceChange={(prov) => setFilters(prev => ({ ...prev, province: prov, city: '' }))}
              onCityChange={(c) => setFilters(prev => ({ ...prev, city: c }))}
            />

            <div className="flex flex-wrap gap-3">
              <label className="flex items-center gap-2 cursor-pointer group">
                <input
                  type="checkbox"
                  checked={filters.verifiedOnly || false}
                  onChange={(e) => setFilters(prev => ({ ...prev, verifiedOnly: e.target.checked }))}
                  className="w-4 h-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500"
                />
                <CheckCircle className="w-4 h-4 text-gray-500 group-hover:text-green-600 transition-colors" />
                <span className="text-sm text-gray-700 group-hover:text-gray-900 font-medium">Solo rivendicate</span>
              </label>
            </div>

            <div className="border-t border-gray-100 pt-3">
              <button
                type="button"
                onClick={() => setShowRatingFilters(!showRatingFilters)}
                className="flex items-center gap-2 text-sm font-medium text-gray-700 hover:text-blue-600 transition-colors"
              >
                {showRatingFilters ? <ChevronUp className="w-4 h-4" /> : <ChevronDown className="w-4 h-4" />}
                Filtri valutazione per tipo di esperienza
                {((filters.minServiceUsedRating || 0) > 0 || (filters.minBookingRating || 0) > 0 ||
                  (filters.minQuoteRating || 0) > 0 || (filters.minCustomerServiceRating || 0) > 0 || (filters.minProblemRating || 0) > 0) && (
                  <span className="px-2 py-0.5 bg-orange-100 text-orange-700 text-xs rounded-full font-semibold">attivi</span>
                )}
              </button>

              {showRatingFilters && (
                <div className="mt-3 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
                  <div className="bg-green-50 border border-green-200 rounded-lg p-3">
                    <p className="text-xs font-semibold text-green-800 mb-2">Servizio Fruito</p>
                    <p className="text-xs text-green-700 mb-2 leading-tight">Gestione, Affidabilità, Organizzazione, Esperienza, Prezzo</p>
                    <SearchableSelect
                      value={String(filters.minServiceUsedRating || 0)}
                      onChange={(v) => setFilters(prev => ({ ...prev, minServiceUsedRating: Number(v) }))}
                      options={RATING_OPTIONS}
                      placeholder="Qualsiasi"
                      className="text-xs"
                    />
                  </div>

                  <div className="bg-red-50 border border-red-200 rounded-lg p-3">
                    <p className="text-xs font-semibold text-red-800 mb-2">Prenotazione Non Completata</p>
                    <p className="text-xs text-red-700 mb-2 leading-tight">Gestione, Affidabilità, Organizzazione, Comunicazione</p>
                    <SearchableSelect
                      value={String(filters.minBookingRating || 0)}
                      onChange={(v) => setFilters(prev => ({ ...prev, minBookingRating: Number(v) }))}
                      options={RATING_OPTIONS}
                      placeholder="Qualsiasi"
                      className="text-xs"
                    />
                  </div>

                  <div className="bg-blue-50 border border-blue-200 rounded-lg p-3">
                    <p className="text-xs font-semibold text-blue-800 mb-2">Preventivo / Informazioni</p>
                    <p className="text-xs text-blue-700 mb-2 leading-tight">Chiarezza, Trasparenza, Tempistiche, Disponibilità</p>
                    <SearchableSelect
                      value={String(filters.minQuoteRating || 0)}
                      onChange={(v) => setFilters(prev => ({ ...prev, minQuoteRating: Number(v) }))}
                      options={RATING_OPTIONS}
                      placeholder="Qualsiasi"
                      className="text-xs"
                    />
                  </div>

                  <div className="bg-teal-50 border border-teal-200 rounded-lg p-3">
                    <p className="text-xs font-semibold text-teal-800 mb-2">Assistenza Clienti</p>
                    <p className="text-xs text-teal-700 mb-2 leading-tight">Cortesia, Competenza, Rapidità, Risoluzione</p>
                    <SearchableSelect
                      value={String(filters.minCustomerServiceRating || 0)}
                      onChange={(v) => setFilters(prev => ({ ...prev, minCustomerServiceRating: Number(v) }))}
                      options={RATING_OPTIONS}
                      placeholder="Qualsiasi"
                      className="text-xs"
                    />
                  </div>

                  <div className="bg-amber-50 border border-amber-200 rounded-lg p-3">
                    <p className="text-xs font-semibold text-amber-800 mb-2">Problema Pre-Servizio</p>
                    <p className="text-xs text-amber-700 mb-2 leading-tight">Affidabilità, Organizzazione, Gestione, Comunicazione</p>
                    <SearchableSelect
                      value={String(filters.minProblemRating || 0)}
                      onChange={(v) => setFilters(prev => ({ ...prev, minProblemRating: Number(v) }))}
                      options={RATING_OPTIONS}
                      placeholder="Qualsiasi"
                      className="text-xs"
                    />
                  </div>
                </div>
              )}
            </div>
          </div>
        )}

        <div className="mt-4 flex gap-2 justify-end">
          <button
            onClick={() => setShowAdvanced(!showAdvanced)}
            className={`flex items-center gap-2 px-4 py-2 rounded-md transition-colors ${
              showAdvanced || hasActiveFilters
                ? 'text-blue-600 bg-blue-50'
                : 'text-gray-600 hover:bg-gray-50 border border-gray-300'
            }`}
          >
            <Filter className="w-5 h-5" />
            <span className="text-sm font-medium">Filtri</span>
            {activeFilterCount > 0 && (
              <span className="ml-1 px-2 py-0.5 bg-blue-600 text-white text-xs rounded-full">
                {activeFilterCount}
              </span>
            )}
          </button>

          <button
            onClick={handleSearchClick}
            disabled={isLoading}
            className="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 transition-colors disabled:bg-gray-400 font-medium flex items-center gap-2"
          >
            <Search className="w-4 h-4" />
            Cerca
          </button>
        </div>
      </div>
    </div>
  );
}
