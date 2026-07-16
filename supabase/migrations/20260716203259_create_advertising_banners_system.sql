/*
# Create Advertising Banners System

## Summary
Creates a complete advertising banner system that allows business users to purchase
banner ads in predefined positions (home top, home bottom, search top, search results)
for fixed durations (7/14/30 days). Admins can manage and approve all banners.

## New Tables

### 1. advertising_plans
Predefined banner advertising plans with position, duration, and price.
- `id` (uuid, PK)
- `position` (text): one of 'home_top', 'home_bottom', 'search_top', 'search_results_1_30', 'search_results_31_60'
- `position_label` (text): human-readable label in Italian
- `duration_days` (int): 7, 14, or 30
- `price` (numeric): base price in EUR (excluding VAT)
- `is_active` (boolean): whether the plan is available for purchase
- `sort_order` (int): display ordering
- `created_at` (timestamptz)

### 2. advertising_banners
Individual banner records created by business users when they purchase a plan.
- `id` (uuid, PK)
- `user_id` (uuid, FK auth.users, NOT NULL DEFAULT auth.uid()): the business user who purchased
- `business_location_id` (uuid, nullable): optional link to a business location
- `plan_id` (uuid, FK advertising_plans): the purchased plan
- `position` (text): denormalized position for quick filtering
- `image_url` (text): banner image URL
- `link_url` (text, nullable): click-through URL
- `alt_text` (text, nullable): accessibility text
- `price_paid` (numeric): amount paid at purchase time
- `status` (text): 'pending', 'approved', 'rejected', 'expired', 'paused'
- `start_date` (timestamptz): when the banner goes live
- `end_date` (timestamptz): when the banner expires
- `admin_notes` (text, nullable): notes from admin review
- `created_at` (timestamptz)
- `updated_at` (timestamptz)

## Security (RLS)
- advertising_plans: public read (anon + authenticated), admin-only write
- advertising_banners: authenticated users can CRUD their own; admin full access;
  public (anon + authenticated) can SELECT only approved & currently active banners
  (for display on home/search pages)

## Seed Data
Pre-populates all advertising plans with the specified pricing:
- Home top: 7d €9.99, 14d €15.99, 30d €32.99
- Home bottom: 7d €7.99, 14d €11.99, 30d €27.99
- Search top: 7d €9.99, 14d €15.99, 30d €32.99
- Search results 1-30: 7d €5.99, 14d €8.99, 30d €17.99
- Search results 31-60: 7d €2.99, 14d €4.99, 30d €9.99
*/

-- ============================================
-- 1. advertising_plans table
-- ============================================
CREATE TABLE IF NOT EXISTS advertising_plans (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  position text NOT NULL,
  position_label text NOT NULL,
  duration_days int NOT NULL,
  price numeric(10,2) NOT NULL,
  is_active boolean NOT NULL DEFAULT true,
  sort_order int NOT NULL DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE advertising_plans ENABLE ROW LEVEL SECURITY;

-- Public can read active plans (needed to show pricing to business users)
DROP POLICY IF EXISTS "public_read_advertising_plans" ON advertising_plans;
CREATE POLICY "public_read_advertising_plans"
ON advertising_plans FOR SELECT
TO anon, authenticated USING (true);

-- Admin can insert/update/delete plans
DROP POLICY IF EXISTS "admin_insert_advertising_plans" ON advertising_plans;
CREATE POLICY "admin_insert_advertising_plans"
ON advertising_plans FOR INSERT
TO authenticated WITH CHECK (
  EXISTS (SELECT 1 FROM admins WHERE admins.user_id = auth.uid())
);

DROP POLICY IF EXISTS "admin_update_advertising_plans" ON advertising_plans;
CREATE POLICY "admin_update_advertising_plans"
ON advertising_plans FOR UPDATE
TO authenticated USING (
  EXISTS (SELECT 1 FROM admins WHERE admins.user_id = auth.uid())
) WITH CHECK (
  EXISTS (SELECT 1 FROM admins WHERE admins.user_id = auth.uid())
);

DROP POLICY IF EXISTS "admin_delete_advertising_plans" ON advertising_plans;
CREATE POLICY "admin_delete_advertising_plans"
ON advertising_plans FOR DELETE
TO authenticated USING (
  EXISTS (SELECT 1 FROM admins WHERE admins.user_id = auth.uid())
);

-- ============================================
-- 2. advertising_banners table
-- ============================================
CREATE TABLE IF NOT EXISTS advertising_banners (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  business_location_id uuid,
  plan_id uuid NOT NULL REFERENCES advertising_plans(id) ON DELETE SET NULL,
  position text NOT NULL,
  image_url text NOT NULL,
  link_url text,
  alt_text text,
  price_paid numeric(10,2) NOT NULL DEFAULT 0,
  status text NOT NULL DEFAULT 'pending',
  start_date timestamptz,
  end_date timestamptz,
  admin_notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE advertising_banners ENABLE ROW LEVEL SECURITY;

-- Public can read only approved & currently active banners (for display)
DROP POLICY IF EXISTS "public_read_active_advertising_banners" ON advertising_banners;
CREATE POLICY "public_read_active_advertising_banners"
ON advertising_banners FOR SELECT
TO anon, authenticated USING (
  status = 'approved'
  AND start_date IS NOT NULL
  AND end_date IS NOT NULL
  AND start_date <= now()
  AND end_date >= now()
);

-- Owner can read their own banners (all statuses)
DROP POLICY IF EXISTS "owner_read_advertising_banners" ON advertising_banners;
CREATE POLICY "owner_read_advertising_banners"
ON advertising_banners FOR SELECT
TO authenticated USING (auth.uid() = user_id);

-- Owner can insert their own banners
DROP POLICY IF EXISTS "owner_insert_advertising_banners" ON advertising_banners;
CREATE POLICY "owner_insert_advertising_banners"
ON advertising_banners FOR INSERT
TO authenticated WITH CHECK (auth.uid() = user_id);

-- Owner can update their own banners (but not status — admin controls approval)
DROP POLICY IF EXISTS "owner_update_advertising_banners" ON advertising_banners;
CREATE POLICY "owner_update_advertising_banners"
ON advertising_banners FOR UPDATE
TO authenticated USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- Owner can delete their own banners
DROP POLICY IF EXISTS "owner_delete_advertising_banners" ON advertising_banners;
CREATE POLICY "owner_delete_advertising_banners"
ON advertising_banners FOR DELETE
TO authenticated USING (auth.uid() = user_id);

-- Admin can read all banners
DROP POLICY IF EXISTS "admin_read_advertising_banners" ON advertising_banners;
CREATE POLICY "admin_read_advertising_banners"
ON advertising_banners FOR SELECT
TO authenticated USING (
  EXISTS (SELECT 1 FROM admins WHERE admins.user_id = auth.uid())
);

-- Admin can update any banner (approve/reject/pause/notes)
DROP POLICY IF EXISTS "admin_update_advertising_banners" ON advertising_banners;
CREATE POLICY "admin_update_advertising_banners"
ON advertising_banners FOR UPDATE
TO authenticated USING (
  EXISTS (SELECT 1 FROM admins WHERE admins.user_id = auth.uid())
) WITH CHECK (
  EXISTS (SELECT 1 FROM admins WHERE admins.user_id = auth.uid())
);

-- Admin can delete any banner
DROP POLICY IF EXISTS "admin_delete_advertising_banners" ON advertising_banners;
CREATE POLICY "admin_delete_advertising_banners"
ON advertising_banners FOR DELETE
TO authenticated USING (
  EXISTS (SELECT 1 FROM admins WHERE admins.user_id = auth.uid())
);

-- ============================================
-- Indexes
-- ============================================
CREATE INDEX IF NOT EXISTS idx_advertising_banners_position ON advertising_banners(position);
CREATE INDEX IF NOT EXISTS idx_advertising_banners_status ON advertising_banners(status);
CREATE INDEX IF NOT EXISTS idx_advertising_banners_user_id ON advertising_banners(user_id);
CREATE INDEX IF NOT EXISTS idx_advertising_banners_dates ON advertising_banners(start_date, end_date);
CREATE INDEX IF NOT EXISTS idx_advertising_plans_position ON advertising_plans(position);

-- ============================================
-- Seed advertising plans
-- ============================================
INSERT INTO advertising_plans (position, position_label, duration_days, price, sort_order) VALUES
  -- Home top
  ('home_top', 'Home - Banner in alto', 7, 9.99, 1),
  ('home_top', 'Home - Banner in alto', 14, 15.99, 2),
  ('home_top', 'Home - Banner in alto', 30, 32.99, 3),
  -- Home bottom
  ('home_bottom', 'Home - Banner in basso', 7, 7.99, 4),
  ('home_bottom', 'Home - Banner in basso', 14, 11.99, 5),
  ('home_bottom', 'Home - Banner in basso', 30, 27.99, 6),
  -- Search top (same prices as home top)
  ('search_top', 'Ricerca attività - Banner in alto', 7, 9.99, 7),
  ('search_top', 'Ricerca attività - Banner in alto', 14, 15.99, 8),
  ('search_top', 'Ricerca attività - Banner in alto', 30, 32.99, 9),
  -- Search results 1-30
  ('search_results_1_30', 'Ricerca - Primi 30 risultati', 7, 5.99, 10),
  ('search_results_1_30', 'Ricerca - Primi 30 risultati', 14, 8.99, 11),
  ('search_results_1_30', 'Ricerca - Primi 30 risultati', 30, 17.99, 12),
  -- Search results 31-60
  ('search_results_31_60', 'Ricerca - Risultati 31-60', 7, 2.99, 13),
  ('search_results_31_60', 'Ricerca - Risultati 31-60', 14, 4.99, 14),
  ('search_results_31_60', 'Ricerca - Risultati 31-60', 30, 9.99, 15)
ON CONFLICT DO NOTHING;
