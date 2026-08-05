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

// Module-level caches
let cachedMacroCategories: MacroCategory[] | null = null;
let cachedMicroCategories: MicroCategory[] | null = null;
let cachedSpecializations: Specialization[] | null = null;
let cachedServices: BusinessService[] | null = null;

export function useMacroCategories() {
  const [macroCategories, setMacroCategories] = useState<MacroCategory[]>(cachedMacroCategories ?? []);
  const [loading, setLoading] = useState(!cachedMacroCategories);

  useEffect(() => {
    if (cachedMacroCategories) return;
    let cancelled = false;
    setLoading(true);
    supabase
      .from('catalog_macro_categories')
      .select('*')
      .eq('is_active', true)
      .order('sort_order')
      .order('name')
      .then(({ data, error }) => {
        if (!cancelled && !error && data) {
          cachedMacroCategories = data;
          setMacroCategories(data);
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

    // Try cache first
    if (cachedMicroCategories) {
      const filtered = cachedMicroCategories.filter(m => m.macro_category_id === macroCategoryId);
      setMicroCategories(filtered);
      setLoading(false);
      return;
    }

    supabase
      .from('catalog_micro_categories')
      .select('*')
      .eq('macro_category_id', macroCategoryId)
      .eq('is_active', true)
      .order('sort_order')
      .order('name')
      .then(({ data, error }) => {
        if (!cancelled && !error && data) {
          setMicroCategories(data);
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

    if (cachedSpecializations) {
      const filtered = cachedSpecializations.filter(s => s.macro_category_id === macroCategoryId);
      setSpecializations(filtered);
      setLoading(false);
      return;
    }

    supabase
      .from('business_specializations')
      .select('*')
      .eq('macro_category_id', macroCategoryId)
      .eq('is_active', true)
      .order('sort_order')
      .order('name')
      .then(({ data, error }) => {
        if (!cancelled && !error && data) {
          setSpecializations(data);
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

    if (cachedServices) {
      const filtered = cachedServices.filter(s => s.macro_category_id === macroCategoryId);
      setServices(filtered);
      setLoading(false);
      return;
    }

    supabase
      .from('business_services')
      .select('*')
      .eq('macro_category_id', macroCategoryId)
      .eq('is_active', true)
      .order('sort_order')
      .order('name')
      .then(({ data, error }) => {
        if (!cancelled && !error && data) {
          setServices(data);
        }
        if (!cancelled) setLoading(false);
      });
    return () => { cancelled = true; };
  }, [macroCategoryId]);

  return { services, loading };
}

// Bulk loader for search filters — loads everything in parallel
export function useAllCatalogData() {
  const [macroCategories, setMacroCategories] = useState<MacroCategory[]>(cachedMacroCategories ?? []);
  const [allMicroCategories, setAllMicroCategories] = useState<MicroCategory[]>(cachedMicroCategories ?? []);
  const [allSpecializations, setAllSpecializations] = useState<Specialization[]>(cachedSpecializations ?? []);
  const [allServices, setAllServices] = useState<BusinessService[]>(cachedServices ?? []);
  const [loading, setLoading] = useState(!cachedMacroCategories);

  useEffect(() => {
    if (cachedMacroCategories && cachedMicroCategories && cachedSpecializations && cachedServices) return;
    let cancelled = false;
    setLoading(true);

    (async () => {
      const [macroRes, microRes, specRes, svcRes] = await Promise.all([
        cachedMacroCategories ? Promise.resolve({ data: cachedMacroCategories, error: null }) : supabase.from('catalog_macro_categories').select('*').eq('is_active', true).order('sort_order').order('name'),
        cachedMicroCategories ? Promise.resolve({ data: cachedMicroCategories, error: null }) : supabase.from('catalog_micro_categories').select('*').eq('is_active', true).order('sort_order').order('name'),
        cachedSpecializations ? Promise.resolve({ data: cachedSpecializations, error: null }) : supabase.from('business_specializations').select('*').eq('is_active', true).order('sort_order').order('name'),
        cachedServices ? Promise.resolve({ data: cachedServices, error: null }) : supabase.from('business_services').select('*').eq('is_active', true).order('sort_order').order('name'),
      ]);

      if (cancelled) return;
      if (macroRes.data) { cachedMacroCategories = macroRes.data; setMacroCategories(macroRes.data); }
      if (microRes.data) { cachedMicroCategories = microRes.data; setAllMicroCategories(microRes.data); }
      if (specRes.data) { cachedSpecializations = specRes.data; setAllSpecializations(specRes.data); }
      if (svcRes.data) { cachedServices = svcRes.data; setAllServices(svcRes.data); }
      setLoading(false);
    })();

    return () => { cancelled = true; };
  }, []);

  const getMicroByMacro = useCallback((macroId: string) => allMicroCategories.filter(m => m.macro_category_id === macroId), [allMicroCategories]);
  const getSpecByMacro = useCallback((macroId: string) => allSpecializations.filter(s => s.macro_category_id === macroId), [allSpecializations]);
  const getServicesByMacro = useCallback((macroId: string) => allServices.filter(s => s.macro_category_id === macroId), [allServices]);

  return { macroCategories, allMicroCategories, allSpecializations, allServices, getMicroByMacro, getSpecByMacro, getServicesByMacro, loading };
}
