import { supabase } from './supabase';

export interface UnifiedBusinessResult {
  id: string;
  name: string;
  category_id: string | null;
  description: string;
  address: string | null;
  city: string;
  province: string | null;
  region: string | null;
  postal_code: string | null;
  phone: string | null;
  email: string | null;
  website: string | null;
  business_hours: string | null;
  latitude: number | null;
  longitude: number | null;
  location_type: 'unclaimed' | 'claimed' | 'user_added';
  is_claimed: boolean;
  is_verified: boolean;
  business_id: string | null;
  owner_id: string | null;
  created_at: string;
}

export interface SearchFilters {
  query?: string;
  city?: string;
  province?: string;
  region?: string;
  category_id?: string;
  verified_only?: boolean;
  limit?: number;
}

export async function searchAllBusinesses(filters: SearchFilters = {}): Promise<UnifiedBusinessResult[]> {
  const { data, error } = await supabase.rpc('search_all_businesses', {
    search_query: filters.query || '',
    search_city: filters.city || null,
    search_province: filters.province || null,
    search_region: filters.region || null,
    search_category_id: filters.category_id || null,
    verified_only: filters.verified_only || false,
    limit_count: filters.limit || 50
  });

  if (error) {
    console.error('Error searching businesses:', error);
    throw error;
  }

  return data || [];
}

export async function getBusinessDetails(businessId: string, businessType: 'imported' | 'user_added' | 'registered') {
  const { data, error } = await supabase.rpc('get_business_details', {
    p_business_id: businessId,
    p_business_type: businessType
  });

  if (error) {
    console.error('Error getting business details:', error);
    throw error;
  }

  return data;
}

export async function getBusinessReviews(businessId: string, businessType: 'imported' | 'user_added' | 'registered') {
  let query = supabase
    .from('reviews')
    .select(`
      *,
      customer:profiles!customer_id(full_name),
      family_member:customer_family_members(first_name, last_name, nickname)
    `)
    .eq('review_status', 'approved')
    .order('created_at', { ascending: false });

  if (businessType === 'imported') {
    query = query.eq('imported_business_id', businessId);
  } else if (businessType === 'user_added') {
    query = query.eq('user_added_business_id', businessId);
  } else if (businessType === 'registered') {
    query = query.eq('business_id', businessId);
  }

  const { data, error } = await query;

  if (error) {
    console.error('Error getting reviews:', error);
    throw error;
  }

  return data || [];
}

export async function claimUnclaimedBusiness(businessId: string, userId: string) {
  const { data: business, error: fetchError } = await supabase
    .from('unclaimed_business_locations')
    .select('*')
    .eq('id', businessId)
    .maybeSingle();

  if (fetchError) throw fetchError;
  if (!business) throw new Error('Attività non trovata');

  const { data: newBusiness, error: insertError } = await supabase
    .from('registered_businesses')
    .insert({
      owner_id: userId,
      name: business.name,
      category_id: business.category_id,
      description: business.description,
      source_type: business.added_by ? 'claimed_user_added' : 'claimed_imported',
      source_id: businessId,
      verification_badge: 'claimed'
    })
    .select()
    .maybeSingle();

  if (insertError) throw insertError;
  if (!newBusiness) throw new Error('Errore nella creazione del business registrato');

  const { error: locationError } = await supabase
    .from('registered_business_locations')
    .insert({
      business_id: newBusiness.id,
      street: business.street,
      city: business.city,
      province: business.province,
      region: business.region,
      postal_code: business.postal_code,
      phone: business.phone,
      email: business.email,
      website: business.website,
      business_hours: business.business_hours,
      latitude: business.latitude,
      longitude: business.longitude,
      is_primary: true
    });

  if (locationError) throw locationError;

  // Sposta le recensioni
  await supabase
    .from('reviews')
    .update({ business_type: 'registered', business_id: newBusiness.id, unclaimed_business_id: null })
    .eq('unclaimed_business_id', businessId);

  // Marca come reclamata
  await supabase
    .from('unclaimed_business_locations')
    .update({ is_claimed: true, claimed_by: userId, claimed_at: new Date().toISOString() })
    .eq('id', businessId);

  return newBusiness;
}

export async function claimImportedBusiness(businessId: string, userId: string) {
  return claimUnclaimedBusiness(businessId, userId);
}

export async function claimUserAddedBusiness(businessId: string, userId: string) {
  return claimUnclaimedBusiness(businessId, userId);
}
