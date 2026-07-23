import { useState, useEffect } from 'react';
import { MapPin } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useItalianLocations, useComuniByProvince } from '../../hooks/useItalianLocations';

interface LocationFiltersProps {
  selectedRegion?: string;
  selectedProvince?: string;
  selectedCity?: string;
  region?: string;
  province?: string;
  city?: string;
  onRegionChange: (region: string) => void;
  onProvinceChange: (province: string) => void;
  onCityChange: (city: string) => void;
  showAllOption?: boolean;
  label?: string;
}

export function LocationFilters({
  selectedRegion,
  selectedProvince,
  selectedCity,
  region,
  province,
  city,
  onRegionChange,
  onProvinceChange,
  onCityChange,
  showAllOption = true,
  label = 'Filtri Geografici'
}: LocationFiltersProps) {
  const { regions, allProvinces, loading: loadingLocations, getProvincesByRegion, getProvinceCode } = useItalianLocations();

  const currentRegion = selectedRegion ?? region ?? '';
  const currentProvince = selectedProvince ?? province ?? '';
  const currentCity = selectedCity ?? city ?? '';

  const availableProvinces = currentRegion
    ? getProvincesByRegion(currentRegion)
    : allProvinces;

  const provinceCode = currentProvince ? getProvinceCode(currentProvince) : '';
  const { cities, loading: loadingCities } = useComuniByProvince(provinceCode);

  return (
    <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-4">
      <div className="flex items-center gap-2 mb-4">
        <MapPin className="w-5 h-5 text-blue-600" />
        <h3 className="font-semibold text-gray-900">{label}</h3>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">Regione</label>
          <select
            value={currentRegion}
            disabled={loadingLocations}
            onChange={e => { onRegionChange(e.target.value); onProvinceChange(''); onCityChange(''); }}
            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent disabled:bg-gray-100 disabled:cursor-not-allowed"
          >
            {showAllOption && <option value="">Tutte le regioni</option>}
            {!showAllOption && <option value="">{loadingLocations ? 'Caricamento...' : 'Seleziona regione'}</option>}
            {regions.map(r => <option key={r} value={r}>{r}</option>)}
          </select>
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">Provincia</label>
          <select
            value={currentProvince}
            disabled={loadingLocations}
            onChange={e => { onProvinceChange(e.target.value); onCityChange(''); }}
            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent disabled:bg-gray-100 disabled:cursor-not-allowed"
          >
            {showAllOption && <option value="">Tutte le province</option>}
            {!showAllOption && <option value="">{loadingLocations ? 'Caricamento...' : 'Seleziona provincia'}</option>}
            {availableProvinces.map(p => <option key={p.sigla} value={p.nome}>{p.nome} ({p.sigla})</option>)}
          </select>
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">Comune</label>
          <select
            value={currentCity}
            onChange={e => onCityChange(e.target.value)}
            disabled={!currentProvince || loadingCities}
            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent disabled:bg-gray-100 disabled:cursor-not-allowed"
          >
            {showAllOption && <option value="">{loadingCities ? 'Caricamento...' : 'Tutte le città'}</option>}
            {!showAllOption && <option value="">{loadingCities ? 'Caricamento...' : 'Seleziona città'}</option>}
            {cities.map(c => <option key={c} value={c}>{c}</option>)}
          </select>
        </div>
      </div>
    </div>
  );
}
