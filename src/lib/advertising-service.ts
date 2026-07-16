import { supabase } from './supabase';

export type BannerPosition =
  | 'home_top'
  | 'home_bottom'
  | 'search_top'
  | 'search_results_1_30'
  | 'search_results_31_60';

export interface AdvertisingPlan {
  id: string;
  position: string;
  position_label: string;
  duration_days: number;
  price: number;
  is_active: boolean;
  sort_order: number;
}

export interface AdvertisingBanner {
  id: string;
  user_id: string;
  business_location_id: string | null;
  plan_id: string;
  position: string;
  image_url: string;
  link_url: string | null;
  alt_text: string | null;
  price_paid: number;
  status: string;
  start_date: string | null;
  end_date: string | null;
  admin_notes: string | null;
  created_at: string;
  updated_at: string;
  plan?: AdvertisingPlan | null;
}

export const BANNER_POSITIONS: BannerPosition[] = [
  'home_top',
  'home_bottom',
  'search_top',
  'search_results_1_30',
  'search_results_31_60',
];

export const POSITION_LABELS: Record<string, string> = {
  home_top: 'Home - Alto',
  home_bottom: 'Home - Basso',
  search_top: 'Ricerca - Alto',
  search_results_1_30: 'Ricerca - Primi 30',
  search_results_31_60: 'Ricerca - Risultati 31-60',
};

const VAT_RATE = 0.22;

export function priceWithVat(price: number): number {
  return price * (1 + VAT_RATE);
}

export async function fetchActiveBanners(position: BannerPosition): Promise<AdvertisingBanner[]> {
  const now = new Date().toISOString();
  const { data, error } = await supabase
    .from('advertising_banners')
    .select('*, plan:plan_id(*)')
    .eq('position', position)
    .eq('status', 'approved')
    .lte('start_date', now)
    .gte('end_date', now)
    .order('created_at', { ascending: true });
  if (error) throw error;
  return (data || []) as AdvertisingBanner[];
}

export async function fetchAllAdvertisingPlans(): Promise<AdvertisingPlan[]> {
  const { data, error } = await supabase
    .from('advertising_plans')
    .select('*')
    .eq('is_active', true)
    .order('sort_order', { ascending: true });
  if (error) throw error;
  return (data || []) as AdvertisingPlan[];
}

export async function fetchPlansByPosition(position: BannerPosition): Promise<AdvertisingPlan[]> {
  const { data, error } = await supabase
    .from('advertising_plans')
    .select('*')
    .eq('position', position)
    .eq('is_active', true)
    .order('duration_days', { ascending: true });
  if (error) throw error;
  return (data || []) as AdvertisingPlan[];
}

export async function fetchUserBanners(userId: string): Promise<AdvertisingBanner[]> {
  const { data, error } = await supabase
    .from('advertising_banners')
    .select('*, plan:plan_id(*)')
    .eq('user_id', userId)
    .order('created_at', { ascending: false });
  if (error) throw error;
  return (data || []) as AdvertisingBanner[];
}

export interface CreateBannerInput {
  plan_id: string;
  position: string;
  image_url: string;
  link_url?: string | null;
  alt_text?: string | null;
  business_location_id?: string | null;
  price_paid: number;
}

export async function createBanner(input: CreateBannerInput): Promise<AdvertisingBanner> {
  const { data, error } = await supabase
    .from('advertising_banners')
    .insert([input])
    .select('*, plan:plan_id(*)')
    .single();
  if (error) throw error;
  return data as AdvertisingBanner;
}

export async function updatePlan(planId: string, updates: { price?: number; duration_days?: number; is_active?: boolean; position_label?: string }): Promise<void> {
  const { error } = await supabase
    .from('advertising_plans')
    .update(updates)
    .eq('id', planId);
  if (error) throw error;
}

export interface OccupancyCount {
  active: number;
  pending: number;
  total: number;
}

export async function fetchOccupancyByPosition(): Promise<Record<string, OccupancyCount>> {
  const { data, error } = await supabase
    .from('advertising_banners')
    .select('position, status, start_date, end_date')
    .in('status', ['pending', 'approved']);
  if (error) throw error;
  const now = new Date();
  const counts: Record<string, OccupancyCount> = {};
  (data || []).forEach((b: any) => {
    if (!counts[b.position]) counts[b.position] = { active: 0, pending: 0, total: 0 };
    if (b.status === 'pending') {
      counts[b.position].pending++;
      counts[b.position].total++;
    } else if (b.status === 'approved') {
      const startOk = !b.start_date || new Date(b.start_date) <= now;
      const endOk = !b.end_date || new Date(b.end_date) >= now;
      if (startOk && endOk) {
        counts[b.position].active++;
        counts[b.position].total++;
      }
    }
  });
  return counts;
}

export async function uploadBannerImage(file: File, userId: string): Promise<string> {
  const ext = file.name.split('.').pop() || 'png';
  const path = `banners/${userId}/${Date.now()}-${Math.random().toString(36).slice(2)}.${ext}`;
  const { error: uploadError } = await supabase.storage
    .from('avatars')
    .upload(path, file);
  if (uploadError) throw uploadError;
  const { data: urlData } = supabase.storage.from('avatars').getPublicUrl(path);
  return urlData.publicUrl;
}
