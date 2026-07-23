import { useState, useEffect, useCallback } from 'react';
import { supabase } from '../lib/supabase';

export interface ProvinceInfo {
  sigla: string;
  nome: string;
  regione: string;
}

let cachedRegions: string[] | null = null;
let cachedAllProvinces: ProvinceInfo[] | null = null;

export function useItalianLocations() {
  const [regions, setRegions] = useState<string[]>(cachedRegions ?? []);
  const [allProvinces, setAllProvinces] = useState<ProvinceInfo[]>(cachedAllProvinces ?? []);
  const [loading, setLoading] = useState(!cachedRegions);

  useEffect(() => {
    if (cachedRegions && cachedAllProvinces) return;

    let cancelled = false;
    setLoading(true);

    (async () => {
      const { data, error } = await supabase
        .from('comuni_italiani')
        .select('sigla_provincia, provincia_sigla, nome_provincia, regione');
      if (cancelled || error || !data) {
        setLoading(false);
        return;
      }

      const provinceMap = new Map<string, ProvinceInfo>();
      for (const row of data) {
        const sigla = row.sigla_provincia || row.provincia_sigla;
        if (!sigla) continue;
        if (!provinceMap.has(sigla)) {
          provinceMap.set(sigla, {
            sigla,
            nome: row.nome_provincia || sigla,
            regione: row.regione || '',
          });
        }
      }

      const provinces = Array.from(provinceMap.values()).sort((a, b) => a.nome.localeCompare(b.nome));
      const uniqueRegions = [...new Set(provinces.map(p => p.regione).filter(Boolean))].sort();

      if (!cancelled) {
        cachedRegions = uniqueRegions;
        cachedAllProvinces = provinces;
        setRegions(uniqueRegions);
        setAllProvinces(provinces);
        setLoading(false);
      }
    })();

    return () => { cancelled = true; };
  }, []);

  const getProvincesByRegion = useCallback((region: string): ProvinceInfo[] => {
    if (!region) return allProvinces;
    return allProvinces.filter(p => p.regione === region);
  }, [allProvinces]);

  const getProvinceCode = useCallback((provinceName: string): string => {
    const found = allProvinces.find(p =>
      p.nome === provinceName || p.sigla === provinceName
    );
    return found?.sigla ?? '';
  }, [allProvinces]);

  return { regions, allProvinces, loading, getProvincesByRegion, getProvinceCode };
}

export function useComuniByProvince(provinceCode: string) {
  const [cities, setCities] = useState<string[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (!provinceCode) { setCities([]); return; }
    let cancelled = false;
    setLoading(true);
    supabase
      .from('comuni_italiani')
      .select('nome')
      .or(`sigla_provincia.eq.${provinceCode},provincia_sigla.eq.${provinceCode}`)
      .order('nome')
      .then(({ data }) => {
        if (!cancelled) {
          setCities(data ? data.map((r: { nome: string }) => r.nome) : []);
          setLoading(false);
        }
      });
    return () => { cancelled = true; };
  }, [provinceCode]);

  return { cities, loading };
}
