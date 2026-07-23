import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import { useItalianLocations, useComuniByProvince } from '../../hooks/useItalianLocations';

export interface LocationFilterState {
  region: string;
  province: string;
  provinceCode: string;
  city: string;
}

interface Props {
  value: LocationFilterState;
  onChange: (v: LocationFilterState) => void;
  accentColor?: string;
}

export function AdminLocationFilter({ value, onChange, accentColor = 'blue' }: Props) {
  const { regions, allProvinces, loading: loadingLocations, getProvincesByRegion } = useItalianLocations();

  const availableProvinces = value.region
    ? getProvincesByRegion(value.region)
    : allProvinces;

  const { cities, loading: loadingCities } = useComuniByProvince(value.provinceCode);

  const cls = `w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-white focus:ring-2 focus:ring-${accentColor}-500 focus:border-transparent`;

  return (
    <div className="grid grid-cols-1 md:grid-cols-3 gap-3">
      <div>
        <label className="block text-xs font-medium text-gray-600 mb-1">Regione</label>
        <select
          value={value.region}
          disabled={loadingLocations}
          onChange={e => onChange({ region: e.target.value, province: '', provinceCode: '', city: '' })}
          className={`${cls} disabled:bg-gray-100 disabled:cursor-not-allowed`}
        >
          <option value="">{loadingLocations ? 'Caricamento...' : 'Tutte le regioni'}</option>
          {regions.map(r => <option key={r} value={r}>{r}</option>)}
        </select>
      </div>

      <div>
        <label className="block text-xs font-medium text-gray-600 mb-1">Provincia</label>
        <select
          value={value.provinceCode}
          onChange={e => {
            const sigla = e.target.value;
            const found = availableProvinces.find(p => p.sigla === sigla);
            onChange({ ...value, province: found?.nome || '', provinceCode: sigla, city: '' });
          }}
          disabled={loadingLocations}
          className={`${cls} disabled:bg-gray-100 disabled:cursor-not-allowed`}
        >
          <option value="">{loadingLocations ? 'Caricamento...' : 'Tutte le province'}</option>
          {availableProvinces.map(p => (
            <option key={p.sigla} value={p.sigla}>{p.nome} ({p.sigla})</option>
          ))}
        </select>
      </div>

      <div>
        <label className="block text-xs font-medium text-gray-600 mb-1">Comune</label>
        <select
          value={value.city}
          onChange={e => onChange({ ...value, city: e.target.value })}
          disabled={!value.provinceCode || loadingCities}
          className={`${cls} disabled:bg-gray-100 disabled:cursor-not-allowed`}
        >
          <option value="">
            {loadingCities ? 'Caricamento...' : !value.provinceCode ? 'Seleziona prima la provincia' : 'Tutti i comuni'}
          </option>
          {cities.map(c => <option key={c} value={c}>{c}</option>)}
        </select>
      </div>
    </div>
  );
}
