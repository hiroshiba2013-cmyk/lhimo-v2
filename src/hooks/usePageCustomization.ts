import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';

export interface PageCustomization {
  id: string;
  page_key: string;
  page_name: string;
  hero_title: string | null;
  hero_subtitle: string | null;
  hero_image_url: string | null;
  announcement_text: string | null;
  announcement_active: boolean;
  custom_content: Record<string, string>;
  updated_at: string;
}

export function usePageCustomization(pageKey: string) {
  const [customization, setCustomization] = useState<PageCustomization | null>(null);

  useEffect(() => {
    supabase
      .from('page_customizations')
      .select('*')
      .eq('page_key', pageKey)
      .maybeSingle()
      .then(({ data }) => {
        if (data) setCustomization(data as PageCustomization);
      });
  }, [pageKey]);

  return customization;
}
