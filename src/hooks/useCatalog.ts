import { useState, useEffect, useCallback } from 'react';
import { supabase } from '../lib/supabase';

export interface MacroCategory {
  id: string;
  name: string;
  slug: string | null;
  icon: string | null;
  sort_order: number;
  is_active: boolean;
}

export interface MicroCategory {
  id: string;
  macro_category_id: string;
  name: string;
  slug: string | null;
  sort_order: number;
  is_active: boolean;
}

export interface Specialization {
  id: string;
  macro_category_id: string;
  name: string;
  sort_order: number;
  is_active: boolean;
}

export interface BusinessService {
  id: string;
  macro_category_id: string;
  name: string;
  sort_order: number;
  is_active: boolean;
}

interface BusinessCategoryRow {
  id: string;
  name: string;
  slug: string | null;
  parent_id: string | null;
}

const CATALOG_MACRO_NAMES = [
  'Ristorazione',
  'Alloggio',
  'Artigianato',
  'Commercio',
  'Servizi Professionali',
  'Salute e Benessere',
  'Trasporti',
  'Istruzione',
  'Agricoltura',
  'Industria',
];

// Static fallback data — used when PostgREST schema cache is stale
const STATIC_MACRO_CATEGORIES: MacroCategory[] = [
  { id: 'c928de4e-7973-4b25-9686-68349a72cb2f', name: 'Ristorazione', slug: 'ristorazione', icon: null, sort_order: 1, is_active: true },
  { id: '059a307d-794b-4605-b571-db1a6a40757f', name: 'Alloggio', slug: 'alloggio', icon: null, sort_order: 2, is_active: true },
  { id: 'f06913f7-fbfa-43c2-b8f5-4465a7d1cb55', name: 'Artigianato', slug: 'artigianato', icon: null, sort_order: 3, is_active: true },
  { id: '34dfd729-7a60-4200-ac1a-fb518a78d10e', name: 'Commercio', slug: 'commercio', icon: null, sort_order: 4, is_active: true },
  { id: '4ac11dea-d49b-4bbb-9b73-193b7c98baea', name: 'Servizi Professionali', slug: 'servizi-professionali', icon: null, sort_order: 5, is_active: true },
  { id: 'daa14a58-e211-48e6-9ee6-22b8c3ec80f5', name: 'Salute e Benessere', slug: 'salute-benessere', icon: null, sort_order: 6, is_active: true },
  { id: 'd5aef280-6b09-411c-bcb1-18e723b40771', name: 'Trasporti', slug: 'trasporti', icon: null, sort_order: 7, is_active: true },
  { id: '4bfba2eb-67c7-497c-b61d-1711843c0e82', name: 'Istruzione', slug: 'istruzione', icon: null, sort_order: 8, is_active: true },
  { id: 'b93d4eb2-7815-41b8-ae2b-07884e5e0618', name: 'Agricoltura', slug: 'agricoltura', icon: null, sort_order: 9, is_active: true },
  { id: 'f1489227-529c-43a0-94e1-b7407aeeb483', name: 'Industria', slug: 'industria', icon: null, sort_order: 10, is_active: true },
];

// Module-level cache
let cachedMacroCategories: MacroCategory[] | null = null;

export function useMacroCategories() {
  const [macroCategories, setMacroCategories] = useState<MacroCategory[]>(cachedMacroCategories ?? []);
  const [loading, setLoading] = useState(!cachedMacroCategories);

  useEffect(() => {
    if (cachedMacroCategories) return;
    let cancelled = false;
    setLoading(true);
    supabase
      .from('business_categories')
      .select('id, name, slug, parent_id')
      .is('parent_id', null)
      .order('name')
      .then(({ data, error }) => {
        if (!cancelled && !error && data) {
          const rows = data as BusinessCategoryRow[];
          const filtered = rows.filter(row => CATALOG_MACRO_NAMES.includes(row.name));
          if (filtered.length > 0) {
            const mapped: MacroCategory[] = filtered.map((row, idx) => ({
              id: row.id, name: row.name, slug: row.slug, icon: null,
              sort_order: idx, is_active: true,
            }));
            cachedMacroCategories = mapped;
            setMacroCategories(mapped);
          } else {
            cachedMacroCategories = STATIC_MACRO_CATEGORIES;
            setMacroCategories(STATIC_MACRO_CATEGORIES);
          }
        } else if (!cancelled) {
          cachedMacroCategories = STATIC_MACRO_CATEGORIES;
          setMacroCategories(STATIC_MACRO_CATEGORIES);
        }
        if (!cancelled) setLoading(false);
      });
    return () => { cancelled = true; };
  }, []);

  return { macroCategories, loading };
}

export function useMicroCategories(macroCategoryId: string | null) {
  const [microCategories, setMicroCategories] = useState<MicroCategory[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (!macroCategoryId) { setMicroCategories([]); return; }
    let cancelled = false;
    setLoading(true);

    supabase
      .from('business_categories')
      .select('id, name, slug, parent_id')
      .eq('parent_id', macroCategoryId)
      .order('name')
      .then(({ data, error }) => {
        if (!cancelled && !error && data) {
          const mapped: MicroCategory[] = (data as BusinessCategoryRow[]).map(row => ({
            id: row.id,
            macro_category_id: row.parent_id ?? macroCategoryId,
            name: row.name,
            slug: row.slug,
            sort_order: 0,
            is_active: true,
          }));
          setMicroCategories(mapped);
        }
        if (!cancelled) setLoading(false);
      });
    return () => { cancelled = true; };
  }, [macroCategoryId]);

  return { microCategories, loading };
}

export function useSpecializations(macroCategoryId: string | null) {
  const [specializations, setSpecializations] = useState<Specialization[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (!macroCategoryId) { setSpecializations([]); return; }
    let cancelled = false;
    setLoading(true);

    supabase
      .from('business_specializations')
      .select('id, macro_category_id, name, sort_order, is_active')
      .eq('macro_category_id', macroCategoryId)
      .eq('is_active', true)
      .order('sort_order')
      .order('name')
      .then(({ data, error }) => {
        if (!cancelled && !error && data) {
          setSpecializations(data as Specialization[]);
        }
        if (!cancelled) setLoading(false);
      });
    return () => { cancelled = true; };
  }, [macroCategoryId]);

  return { specializations, loading };
}

export function useBusinessServices(macroCategoryId: string | null) {
  const [services, setServices] = useState<BusinessService[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (!macroCategoryId) { setServices([]); return; }
    let cancelled = false;
    setLoading(true);

    supabase
      .from('business_services')
      .select('id, macro_category_id, name, sort_order, is_active')
      .eq('macro_category_id', macroCategoryId)
      .eq('is_active', true)
      .order('sort_order')
      .order('name')
      .then(({ data, error }) => {
        if (!cancelled && !error && data) {
          setServices(data as BusinessService[]);
        }
        if (!cancelled) setLoading(false);
      });
    return () => { cancelled = true; };
  }, [macroCategoryId]);

  return { services, loading };
}

export function useAllCatalogData() {
  const { macroCategories, loading } = useMacroCategories();
  const [allMicroCategories, setAllMicroCategories] = useState<MicroCategory[]>([]);
  const [allSpecializations, setAllSpecializations] = useState<Specialization[]>([]);
  const [allServices, setAllServices] = useState<BusinessService[]>([]);

  useEffect(() => {
    if (macroCategories.length === 0) return;
    let cancelled = false;

    (async () => {
      const macroIds = macroCategories.map(m => m.id);
      const { data: microData } = await supabase
        .from('business_categories')
        .select('id, name, slug, parent_id')
        .in('parent_id', macroIds)
        .order('name');

      if (!cancelled && microData) {
        const mapped: MicroCategory[] = (microData as BusinessCategoryRow[]).map(row => ({
          id: row.id, macro_category_id: row.parent_id ?? '', name: row.name,
          slug: row.slug, sort_order: 0, is_active: true,
        }));
        setAllMicroCategories(mapped);
      }

      const [specRes, svcRes] = await Promise.all([
        supabase.from('business_specializations').select('*').eq('is_active', true).order('sort_order').order('name'),
        supabase.from('business_services').select('*').eq('is_active', true).order('sort_order').order('name'),
      ]);
      if (!cancelled) {
        if (specRes.data) setAllSpecializations(specRes.data as Specialization[]);
        if (svcRes.data) setAllServices(svcRes.data as BusinessService[]);
      }
    })();

    return () => { cancelled = true; };
  }, [macroCategories]);

  const getMicroByMacro = useCallback((macroId: string) => allMicroCategories.filter(m => m.macro_category_id === macroId), [allMicroCategories]);
  const getSpecByMacro = useCallback((macroId: string) => allSpecializations.filter(s => s.macro_category_id === macroId), [allSpecializations]);
  const getServicesByMacro = useCallback((macroId: string) => allServices.filter(s => s.macro_category_id === macroId), [allServices]);

  return { macroCategories, allMicroCategories, allSpecializations, allServices, getMicroByMacro, getSpecByMacro, getServicesByMacro, loading };
}
