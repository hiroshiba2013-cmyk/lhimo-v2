import { useState, useRef, useEffect, useCallback } from 'react';
import { ChevronDown, Search, X, MapPin, Building2 } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { ITALIAN_PROVINCES, PROVINCES_BY_REGION, PROVINCE_TO_CODE } from '../../lib/cities';

interface Props {
  province: string;
  city: string;
  onProvinceChange: (province: string, provinceCode: string) => void;
  onCityChange: (city: string) => void;
  required?: boolean;
  disabled?: boolean;
  region?: string;
}

export function ItalianCityProvinceSelect({
  province,
  city,
  onProvinceChange,
  onCityChange,
  required = false,
  disabled = false,
  region = '',
}: Props) {
  const [cities, setCities] = useState<string[]>([]);
  const [loadingCities, setLoadingCities] = useState(false);

  const [provinceOpen, setProvinceOpen] = useState(false);
  const [provinceSearch, setProvinceSearch] = useState('');

  const provinceRef = useRef<HTMLDivElement>(null);
  const provinceInputRef = useRef<HTMLInputElement>(null);

  // Derive province list synchronously from local data — no async needed
  const provinces: string[] = region
    ? (PROVINCES_BY_REGION[region] ?? ITALIAN_PROVINCES)
    : ITALIAN_PROVINCES;

  // When region changes, clear province if no longer valid (parent clears city via onProvinceChange)
  useEffect(() => {
    if (!region) return;
    const list = PROVINCES_BY_REGION[region] ?? [];
    if (province && list.length > 0 && !list.includes(province)) {
      onProvinceChange('', '');
    }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [region]);

  const loadCities = useCallback(async (prov: string) => {
    if (!prov) { setCities([]); return; }
    setLoadingCities(true);
    const sigla = PROVINCE_TO_CODE[prov] || prov;
    const { data } = await supabase.rpc('get_comuni_by_provincia', { p_provincia: sigla });
    setCities(data ? data.map((r: { comune: string }) => r.comune) : []);
    setLoadingCities(false);
  }, []);

  useEffect(() => {
    loadCities(province);
  }, [province, loadCities]);

  useEffect(() => {
    function handleClick(e: MouseEvent) {
      if (provinceRef.current && !provinceRef.current.contains(e.target as Node)) {
        setProvinceOpen(false);
        setProvinceSearch('');
      }
    }
    document.addEventListener('mousedown', handleClick);
    return () => document.removeEventListener('mousedown', handleClick);
  }, []);

  useEffect(() => {
    if (provinceOpen) setTimeout(() => provinceInputRef.current?.focus(), 50);
  }, [provinceOpen]);

  const filteredProvinces = provinces.filter(p =>
    p.toLowerCase().includes(provinceSearch.toLowerCase())
  );

  function selectProvince(p: string) {
    const code = PROVINCE_TO_CODE[p] || '';
    onProvinceChange(p, code); // parent is responsible for clearing city in this handler
    setProvinceOpen(false);
    setProvinceSearch('');
  }

  function clearProvince(e: React.MouseEvent) {
    e.stopPropagation();
    onProvinceChange('', ''); // parent clears city too
    setCities([]);
  }

  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 w-full">
      {/* Comune — select nativo (first) */}
      <div>
        <label className="block text-sm font-medium text-gray-700 mb-1.5">
          <span className="flex items-center gap-1.5">
            <MapPin className="w-3.5 h-3.5 text-gray-400" />
            Comune
            {required && <span className="text-red-500 ml-0.5">*</span>}
          </span>
        </label>
        <div className="relative">
          {/* Fallback text input when no comuni are in DB for this province */}
          {province && !loadingCities && cities.length === 0 ? (
            <input
              type="text"
              value={city}
              onChange={e => onCityChange(e.target.value)}
              disabled={disabled}
              required={required}
              placeholder="Scrivi il nome del comune..."
              className={`w-full px-3 py-2.5 border rounded-lg text-sm bg-white transition-all focus:outline-none focus:ring-2 focus:ring-blue-100 focus:border-blue-500 ${
                disabled ? 'bg-gray-50 cursor-not-allowed opacity-60 border-gray-300' : 'border-gray-300 hover:border-blue-400'
              } ${city ? 'text-gray-900' : 'text-gray-400'}`}
            />
          ) : (
          <select
            value={city}
            disabled={disabled || !province || loadingCities}
            onChange={e => onCityChange(e.target.value)}
            required={required}
            className={`w-full appearance-none px-3 py-2.5 pr-9 border rounded-lg text-sm bg-white transition-all focus:outline-none focus:ring-2 focus:ring-blue-100 focus:border-blue-500 ${
              disabled || !province ? 'bg-gray-50 cursor-not-allowed opacity-60 border-gray-300' : 'border-gray-300 hover:border-blue-400 cursor-pointer'
            } ${city ? 'text-gray-900 font-medium' : 'text-gray-400'}`}
          >
            <option value="" disabled>
              {loadingCities ? 'Caricamento...' : province ? 'Seleziona comune...' : 'Prima scegli la provincia'}
            </option>
            {cities.map(c => (
              <option key={c} value={c}>{c}</option>
            ))}
          </select>
          )}
          <div className="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3">
            {loadingCities
              ? <div className="w-4 h-4 border-2 border-blue-400 border-t-transparent rounded-full animate-spin" />
              : cities.length > 0 ? <ChevronDown className="w-4 h-4 text-gray-400" /> : null
            }
          </div>
        </div>
        {province && !loadingCities && cities.length > 0 && (
          <p className="mt-1 text-xs text-gray-400">{cities.length} comuni disponibili</p>
        )}
      </div>

      {/* Provincia — custom dropdown (second) */}
      <div>
        <label className="block text-sm font-medium text-gray-700 mb-1.5">
          <span className="flex items-center gap-1.5">
            <Building2 className="w-3.5 h-3.5 text-gray-400" />
            Provincia
            {required && <span className="text-red-500 ml-0.5">*</span>}
          </span>
        </label>
        <div ref={provinceRef} className="relative">
          <button
            type="button"
            disabled={disabled}
            onClick={() => { if (!disabled) setProvinceOpen(v => !v); }}
            className={`w-full flex items-center justify-between gap-2 px-3 py-2.5 border rounded-lg text-sm transition-all text-left bg-white ${
              disabled ? 'bg-gray-50 cursor-not-allowed opacity-60' : 'hover:border-blue-400 cursor-pointer'
            } ${provinceOpen ? 'border-blue-500 ring-2 ring-blue-100 shadow-sm' : 'border-gray-300'}`}
          >
            <span className={`flex-1 min-w-0 truncate ${province ? 'text-gray-900 font-medium' : 'text-gray-400'}`}>
              {province
                ? <>{province}{PROVINCE_TO_CODE[province] && <span className="ml-1.5 text-xs font-mono text-gray-400">({PROVINCE_TO_CODE[province]})</span>}</>
                : 'Seleziona provincia...'}
            </span>
            <div className="flex items-center gap-1 flex-shrink-0">
              {province && !disabled && (
                <span onClick={clearProvince} className="p-0.5 rounded hover:bg-gray-100 text-gray-400 hover:text-gray-600 transition-colors">
                  <X className="w-3.5 h-3.5" />
                </span>
              )}
              <ChevronDown className={`w-4 h-4 text-gray-400 transition-transform duration-200 ${provinceOpen ? 'rotate-180' : ''}`} />
            </div>
          </button>

          {provinceOpen && (
            <div
              className="absolute z-[9999] left-0 mt-1 bg-white border border-gray-200 rounded-xl shadow-2xl"
              style={{ minWidth: '100%', width: 'max-content', maxWidth: '320px' }}
            >
              <div className="p-2.5 border-b border-gray-100 bg-gray-50 rounded-t-xl">
                <div className="flex items-center gap-2 bg-white border border-gray-200 rounded-lg px-2.5 py-1.5">
                  <Search className="w-3.5 h-3.5 text-gray-400 flex-shrink-0" />
                  <input
                    ref={provinceInputRef}
                    type="text"
                    placeholder="Cerca provincia..."
                    value={provinceSearch}
                    onChange={e => setProvinceSearch(e.target.value)}
                    className="flex-1 bg-transparent text-sm outline-none text-gray-700 placeholder-gray-400 min-w-0"
                    onKeyDown={e => {
                      if (e.key === 'Escape') { setProvinceOpen(false); setProvinceSearch(''); }
                      if (e.key === 'Enter' && filteredProvinces.length === 1) selectProvince(filteredProvinces[0]);
                    }}
                  />
                  {provinceSearch && (
                    <button type="button" onClick={() => setProvinceSearch('')} className="text-gray-400 hover:text-gray-600 flex-shrink-0">
                      <X className="w-3 h-3" />
                    </button>
                  )}
                </div>
              </div>
              <div style={{ height: '220px', overflowY: 'scroll' }}>
                {filteredProvinces.length === 0 ? (
                  <div className="px-4 py-6 text-sm text-gray-400 text-center">Nessuna provincia trovata</div>
                ) : (
                  filteredProvinces.map(p => {
                    const code = PROVINCE_TO_CODE[p] || '';
                    const isSelected = p === province;
                    return (
                      <button
                        key={p}
                        type="button"
                        onClick={() => selectProvince(p)}
                        className={`w-full text-left px-3.5 py-2.5 text-sm flex items-center justify-between gap-3 transition-colors ${
                          isSelected ? 'bg-blue-50 text-blue-700' : 'text-gray-700 hover:bg-gray-50'
                        }`}
                      >
                        <span className="font-medium flex-1 min-w-0">{p}</span>
                        {code && (
                          <span className={`text-xs px-1.5 py-0.5 rounded font-mono font-semibold flex-shrink-0 ${
                            isSelected ? 'bg-blue-100 text-blue-600' : 'bg-gray-100 text-gray-500'
                          }`}>{code}</span>
                        )}
                      </button>
                    );
                  })
                )}
              </div>
              <div className="px-3 py-1.5 border-t border-gray-100 bg-gray-50 rounded-b-xl text-xs text-gray-400 text-right">
                {filteredProvinces.length} {region ? `province in ${region}` : 'province'}
              </div>
            </div>
          )}
        </div>
      </div>

    </div>
  );
}
