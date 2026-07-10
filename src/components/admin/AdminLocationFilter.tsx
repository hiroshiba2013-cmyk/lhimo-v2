import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import { ITALIAN_REGIONS } from '../../lib/cities';

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
  const [provinces, setProvinces] = useState<{ provincia: string; sigla: string }[]>([]);
  const [cities, setCities] = useState<string[]>([]);
  const [loadingProvinces, setLoadingProvinces] = useState(false);
  const [loadingCities, setLoadingCities] = useState(false);

  // Load provinces on mount (all) and when region changes
  useEffect(() => {
    setLoadingProvinces(true);
    setProvinces([]);
    const fn = value.region
      ? supabase.rpc('get_province_by_regione', { p_regione: value.region })
      : supabase.rpc('get_all_province');
    fn.then(({ data, error }) => {
      if (!error) setProvinces(data || []);
      setLoadingProvinces(false);
    });
  }, [value.region]);

  // Load cities when province code changes
  useEffect(() => {
    if (!value.provinceCode) { setCities([]); return; }
    setLoadingCities(true);
    setCities([]);
    supabase.rpc('get_comuni_by_provincia', { p_provincia: value.provinceCode }).then(({ data, error }) => {
      if (!error) setCities((data || []).map((r: { comune: string }) => r.comune));
      setLoadingCities(false);
    });
  }, [value.provinceCode]);

  const cls = `w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-white focus:ring-2 focus:ring-${accentColor}-500 focus:border-transparent`;

  return (
    <div className="grid grid-cols-1 md:grid-cols-3 gap-3">
      <div>
        <label className="block text-xs font-medium text-gray-600 mb-1">Regione</label>
        <select
          value={value.region}
          onChange={e => onChange({ region: e.target.value, province: '', provinceCode: '', city: '' })}
          className={cls}
        >
          <option value="">Tutte le regioni</option>
          {ITALIAN_REGIONS.map(r => <option key={r} value={r}>{r}</option>)}
        </select>
      </div>

      <div>
        <label className="block text-xs font-medium text-gray-600 mb-1">Provincia</label>
        <select
          value={value.provinceCode}
          onChange={e => {
            const sigla = e.target.value;
            const found = provinces.find(p => p.sigla === sigla);
            onChange({ ...value, province: found?.provincia || '', provinceCode: sigla, city: '' });
          }}
          disabled={loadingProvinces}
          className={`${cls} disabled:bg-gray-100 disabled:cursor-not-allowed`}
        >
          <option value="">{loadingProvinces ? 'Caricamento...' : 'Tutte le province'}</option>
          {provinces.map(p => (
            <option key={p.sigla} value={p.sigla}>{p.provincia} ({p.sigla})</option>
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
