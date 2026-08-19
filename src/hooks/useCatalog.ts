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


/* =========================================================
   MACRO CATEGORIE
   ========================================================= */

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

      console.log('Macro Categories:', data);
      console.log('Macro Error:', error);

      if (cancelled) return;

      if (error) {
        console.error('Errore caricamento macro categorie:', error);
        setMacroCategories([]);
      } else {
        setMacroCategories(data ?? []);
      }

      setLoading(false);
    }

    load();

    return () => {
      cancelled = true;
    };
  }, []);

  return {
    macroCategories,
    loading,
  };
}


/* =========================================================
   MICRO CATEGORIE
   ========================================================= */

export function useMicroCategories(
  macroCategoryId: string | null
) {
  const [microCategories, setMicroCategories] = useState<MicroCategory[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (!macroCategoryId) {
      setMicroCategories([]);
      setLoading(false);
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

      console.log(
        'Micro Categories - MACRO:',
        macroCategoryId
      );

      console.log(
        'Micro Categories - DATA:',
        data
      );

      console.log(
        'Micro Categories - ERROR:',
        error
      );

      if (cancelled) return;

      if (error) {
        console.error(
          'Errore caricamento micro categorie:',
          error
        );

        setMicroCategories([]);
      } else {
        setMicroCategories(data ?? []);
      }

      setLoading(false);
    }

    load();

    return () => {
      cancelled = true;
    };
  }, [macroCategoryId]);

  return {
    microCategories,
    loading,
  };
}


/* =========================================================
   SPECIALIZZAZIONI
   ========================================================= */

export function useSpecializations(
  macroCategoryId: string | null
) {
  const [specializations, setSpecializations] = useState<
    Specialization[]
  >([]);

  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (!macroCategoryId) {
      setSpecializations([]);
      setLoading(false);
      return;
    }

    let cancelled = false;

    async function load() {
      setLoading(true);

      const { data, error } = await supabase
        .from('business_specializations')
        .select('*')
        .eq('macro_category_id', macroCategoryId)
        .eq('is_active', true);

      console.log(
        'SPECIALIZZAZIONI - MACRO:',
        macroCategoryId
      );

      console.log(
        'SPECIALIZZAZIONI - DATA:',
        data
      );

      console.log(
        'SPECIALIZZAZIONI - ERROR:',
        error
      );

      if (cancelled) return;

      if (error) {
        console.error(
          'Errore caricamento specializzazioni:',
          error
        );

        setSpecializations([]);
      } else {
        setSpecializations(data ?? []);
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


/* =========================================================
   SERVIZI
   ========================================================= */

export function useBusinessServices(
  macroCategoryId: string | null
) {
  const [services, setServices] = useState<
    BusinessService[]
  >([]);

  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (!macroCategoryId) {
      setServices([]);
      setLoading(false);
      return;
    }

    let cancelled = false;

    async function load() {
      setLoading(true);

      const { data, error } = await supabase
        .from('business_services')
        .select('*')
        .eq('macro_category_id', macroCategoryId)
        .eq('is_active', true);

      console.log(
        'SERVIZI - MACRO:',
        macroCategoryId
      );

      console.log(
        'SERVIZI - DATA:',
        data
      );

      console.log(
        'SERVIZI - ERROR:',
        error
      );

      if (cancelled) return;

      if (error) {
        console.error(
          'Errore caricamento servizi:',
          error
        );

        setServices([]);
      } else {
        setServices(data ?? []);
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


/* =========================================================
   TUTTO IL CATALOGO
   ========================================================= */

export function useAllCatalogData() {
  const {
    macroCategories,
    loading: macroLoading,
  } = useMacroCategories();

  const [allMicroCategories, setAllMicroCategories] =
    useState<MicroCategory[]>([]);

  const [allSpecializations, setAllSpecializations] =
    useState<Specialization[]>([]);

  const [allServices, setAllServices] =
    useState<BusinessService[]>([]);

  const [loading, setLoading] = useState(false);


  useEffect(() => {
    if (macroCategories.length === 0) {
      setAllMicroCategories([]);
      setAllSpecializations([]);
      setAllServices([]);
      return;
    }

    let cancelled = false;

    async function load() {
      setLoading(true);

      const [
        microResult,
        specializationResult,
        servicesResult,
      ] = await Promise.all([
        supabase
          .from('catalog_micro_categories')
          .select('*')
          .eq('is_active', true)
          .order('sort_order', { ascending: true })
          .order('name', { ascending: true }),

        supabase
          .from('business_specializations')
          .select('*')
          .eq('is_active', true)
          .order('sort_order', { ascending: true })
          .order('name', { ascending: true }),

        supabase
          .from('business_services')
          .select('*')
          .eq('is_active', true)
          .order('sort_order', { ascending: true })
          .order('name', { ascending: true }),
      ]);

      if (cancelled) return;

      if (microResult.error) {
        console.error(
          'Errore tutte le micro categorie:',
          microResult.error
        );

        setAllMicroCategories([]);
      } else {
        setAllMicroCategories(
          microResult.data ?? []
        );
      }

      if (specializationResult.error) {
        console.error(
          'Errore tutte le specializzazioni:',
          specializationResult.error
        );

        setAllSpecializations([]);
      } else {
        setAllSpecializations(
          specializationResult.data ?? []
        );
      }

      if (servicesResult.error) {
        console.error(
          'Errore tutti i servizi:',
          servicesResult.error
        );

        setAllServices([]);
      } else {
        setAllServices(
          servicesResult.data ?? []
        );
      }

      setLoading(false);
    }

    load();

    return () => {
      cancelled = true;
    };
  }, [macroCategories]);


  const getMicroByMacro = useCallback(
    (macroId: string) =>
      allMicroCategories.filter(
        micro =>
          micro.macro_category_id === macroId
      ),
    [allMicroCategories]
  );


  const getSpecByMacro = useCallback(
    (macroId: string) =>
      allSpecializations.filter(
        specialization =>
          specialization.macro_category_id === macroId
      ),
    [allSpecializations]
  );


  const getServicesByMacro = useCallback(
    (macroId: string) =>
      allServices.filter(
        service =>
          service.macro_category_id === macroId
      ),
    [allServices]
  );


  return {
    macroCategories,

    allMicroCategories,

    allSpecializations,

    allServices,

    getMicroByMacro,

    getSpecByMacro,

    getServicesByMacro,

    loading: macroLoading || loading,
  };
}