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

export function useMacroCategories() {

  const [macroCategories, setMacroCategories] = useState<MacroCategory[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {

    let cancelled = false;

    async function load() {

      const { data, error } = await supabase
        .from("catalog_macro_categories")
        .select("*")
        .eq("is_active", true)
        .order("sort_order", { ascending: true })
        .order("name", { ascending: true });

      console.log("Macro Categories:", data);
      console.log("Macro Error:", error);

      if (!cancelled) {

        if (error) {

          console.error(error);

        } else {

          setMacroCategories(data ?? []);

        }

        setLoading(false);

      }

    }

    load();

    return () => {

      cancelled = true;

    };

  }, []);

  return {

    macroCategories,

    loading

  };

}

export function useMicroCategories(macroCategoryId: string | null) {

  const [microCategories, setMicroCategories] = useState<MicroCategory[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {

    if (!macroCategoryId) {
      setMicroCategories([]);
      return;
    }

    let cancelled = false;
    setLoading(true);

    async function load() {

      const { data, error } = await supabase
        .from('catalog_micro_categories')
        .select('*')
        .eq('macro_category_id', macroCategoryId)
        .eq('is_active', true)
        .order('sort_order', { ascending: true })
        .order('name', { ascending: true });

      if (error) {
        console.error('Micro categories:', error);
      }

      if (!cancelled) {
        setMicroCategories(data ?? []);
        setLoading(false);
      }

    }

    load();

    return () => {
      cancelled = true;
    };

  }, [macroCategoryId]);

  return {
    microCategories,
    loading
  };

}


export function useSpecializations(macroCategoryId: string | null) {
  const [specializations, setSpecializations] = useState<Specialization[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (!macroCategoryId) {
      setSpecializations([]);
      setLoading(false);
      return;
    }

    let cancelled = false;
    setLoading(true);

    async function load() {
      const { data, error } = await supabase
        .from('business_specializations')
        .select('*')
        .eq('macro_category_id', macroCategoryId);

      console.log('SPECIALIZZAZIONI - MACRO:', macroCategoryId);
      console.log('SPECIALIZZAZIONI - DATA:', data);
      console.log('SPECIALIZZAZIONI - ERROR:', error);

      if (cancelled) return;

      if (error) {
        console.error(
          'Errore caricamento specializzazioni:',
          error
        );
        setSpecializations([]);
      } else {
        const active = (data ?? []).filter(
          (item: any) => item.is_active !== false
        );

        setSpecializations(active as Specialization[]);
      }

      setLoading(false);
    }

    load();

    return () => {
      cancelled = true;
    };
  }, [macroCategoryId]);

  return {
    specializations,
    loading,
  };
}
export function useBusinessServices(macroCategoryId: string | null) {
  const [services, setServices] = useState<BusinessService[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (!macroCategoryId) {
      setServices([]);
      setLoading(false);
      return;
    }

    let cancelled = false;
    setLoading(true);

    async function load() {
      const { data, error } = await supabase
        .from('business_services')
        .select('*')
        .eq('macro_category_id', macroCategoryId);

      console.log('SERVIZI - MACRO:', macroCategoryId);
      console.log('SERVIZI - DATA:', data);
      console.log('SERVIZI - ERROR:', error);

      if (cancelled) return;

      if (error) {
        console.error(
          'Errore caricamento servizi:',
          error
        );
        setServices([]);
      } else {
        const active = (data ?? []).filter(
          (item: any) => item.is_active !== false
        );

        setServices(active as BusinessService[]);
      }

      setLoading(false);
    }

    load();

    return () => {
      cancelled = true;
    };
  }, [macroCategoryId]);

  return {
    services,
    loading,
  };
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
