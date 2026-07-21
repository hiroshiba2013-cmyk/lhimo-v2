import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

export interface Profile {
  id: string;
  full_name: string;
  first_name?: string;
  last_name?: string;
  email?: string;
  phone?: string;
  date_of_birth?: string;
  fiscal_code?: string;
  nickname?: string;
  avatar_url?: string;
  user_type: 'customer' | 'business' | 'admin';
  subscription_status?: string;
  subscription_type?: string;
  billing_address?: string;
  billing_street?: string;
  billing_street_number?: string;
  billing_postal_code?: string;
  billing_city?: string;
  billing_province?: string;
  relationship?: string;
  created_at?: string;
  updated_at?: string;
}

export interface FamilyMember {
  id: string;
  customer_id: string;
  first_name: string;
  last_name: string;
  nickname?: string;
  avatar_url?: string;
  date_of_birth?: string;
  relationship?: string;
  resume_url?: string;
  created_at?: string;
}

export interface Business {
  id: string;
  name: string;
  category_id?: string;
  description?: string;
  address?: string;
  city?: string;
  province?: string;
  region?: string;
  postal_code?: string;
  phone?: string;
  email?: string;
  website?: string;
  logo_url?: string;
  is_claimed?: boolean;
  owner_id?: string;
  verification_badge?: string;
  business_type?: string;
  created_at?: string;
  updated_at?: string;
  [key: string]: unknown;
}

export interface BusinessLocation {
  id: string;
  business_id?: string;
  name?: string;
  internal_name?: string;
  address?: string;
  street?: string;
  city?: string;
  province?: string;
  region?: string;
  postal_code?: string;
  phone?: string | null;
  email?: string | null;
  website?: string | null;
  latitude?: number;
  longitude?: number;
  avatar_url?: string | null;
  description?: string | null;
  business_hours?: string | null;
  created_at?: string;
}

export interface Review {
  id: string;
  business_id?: string;
  customer_id: string;
  family_member_id?: string;
  rating: number;
  overall_rating?: number;
  title: string;
  content: string;
  review_status?: string;
  proof_image_url?: string;
  points_awarded?: boolean;
  business_type?: string;
  imported_business_id?: string;
  user_added_business_id?: string;
  unclaimed_business_location_id?: string;
  business_location_id?: string;
  created_at: string;
  updated_at?: string;
  [key: string]: unknown;
}

export interface JobPosting {
  id: string;
  business_id?: string;
  registered_business_id?: string;
  title: string;
  description: string;
  location?: string;
  city?: string;
  province?: string;
  employment_type?: string;
  salary_range?: string;
  requirements?: string;
  status?: string;
  approval_status?: string;
  created_at: string;
  [key: string]: unknown;
}
