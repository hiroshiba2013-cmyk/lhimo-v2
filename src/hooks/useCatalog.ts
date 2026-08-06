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
  slug: string | null;
  sort_order: number;
  is_active: boolean;
}

export interface BusinessService {
  id: string;
  macro_category_id: string;
  name: string;
  slug: string | null;
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
        .from('catalog_macro_categories')
        .select('*')
        .eq('is_active', true)
        .order('sort_order', { ascending: true })
        .order('name', { ascending: true });

      if (error) {
        console.error('Macro Categories:', error);
      }

      if (!cancelled) {
        setMacroCategories(data ?? []);
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

    async function load() {

      setLoading(true);

      const { data, error } = await supabase
        .from('catalog_micro_categories')
        .select('*')
        .eq('macro_category_id', macroCategoryId)
        .eq('is_active', true)
        .order('sort_order', { ascending: true })
        .order('name', { ascending: true });

      if (error) {
        console.error('Micro Categories:', error);
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
      return;
    }

    let cancelled = false;

    async function load() {

      setLoading(true);

      const { data, error } = await supabase
        .from('business_specializations')
        .select('*')
        .eq('macro_category_id', macroCategoryId)
        .eq('is_active', true)
        .order('sort_order', { ascending: true })
        .order('name', { ascending: true });

      if (error) {
        console.error('Specializations:', error);
      }

      if (!cancelled) {
        setSpecializations(data ?? []);
        setLoading(false);
      }

    }

    load();

    return () => {
      cancelled = true;
    };

  }, [macroCategoryId]);

  return {
    specializations,
    loading
  };

}

export function useBusinessServices(macroCategoryId: string | null) {

  const [services, setServices] = useState<BusinessService[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {

    if (!macroCategoryId) {
      setServices([]);
      return;
    }

    let cancelled = false;

    async function load() {

      setLoading(true);

      const { data, error } = await supabase
        .from('business_services')
        .select('*')
        .eq('macro_category_id', macroCategoryId)
        .eq('is_active', true)
        .order('sort_order', { ascending: true })
        .order('name', { ascending: true });

      if (error) {
        console.error('Business Services:', error);
      }

      if (!cancelled) {
        setServices(data ?? []);
        setLoading(false);
      }

    }

    load();

    return () => {
      cancelled = true;
    };

  }, [macroCategoryId]);

  return {
    services,
    loading
  };

}
export function useAllCatalogData() {

  const { macroCategories, loading } = useMacroCategories();

  const [allMicroCategories, setAllMicroCategories] = useState<MicroCategory[]>([]);
  const [allSpecializations, setAllSpecializations] = useState<Specialization[]>([]);
  const [allServices, setAllServices] = useState<BusinessService[]>([]);

  useEffect(() => {

    let cancelled = false;

    async function load() {

      const [microRes, specRes, serviceRes] = await Promise.all([

        supabase
          .from("catalog_micro_categories")
          .select("*")
          .eq("is_active", true)
          .order("sort_order", { ascending: true })
          .order("name", { ascending: true }),

        supabase
          .from("business_specializations")
          .select("*")
          .eq("is_active", true)
          .order("sort_order", { ascending: true })
          .order("name", { ascending: true }),

        supabase
          .from("business_services")
          .select("*")
          .eq("is_active", true)
          .order("sort_order", { ascending: true })
          .order("name", { ascending: true })

      ]);

      if (cancelled) return;

      if (microRes.error) console.error(microRes.error);
      if (specRes.error) console.error(specRes.error);
      if (serviceRes.error) console.error(serviceRes.error);

      setAllMicroCategories(microRes.data ?? []);
      setAllSpecializations(specRes.data ?? []);
      setAllServices(serviceRes.data ?? []);

    }

    load();

    return () => {

      cancelled = true;

    };

  }, []);
