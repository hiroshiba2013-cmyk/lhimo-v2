-- ============================================================
-- FILE: 20260204153815_add_trial_expiration_automation.sql
-- ============================================================
/*
  # Add Trial Expiration Automation System

  1. Functions
    - `check_trial_expiration()` - Automatically expire trials when trial_end_date is reached
    - `notify_trial_expiring_soon()` - Create in-app notifications for expiring trials (7 days before)
    - `get_trial_status()` - Get trial status for a user

  2. Changes
    - Add automatic trigger to expire trials at midnight
    - Add function to create notifications for trials expiring in 7 days
    - Add function to handle expired trials (update status and create notification)

  3. Security
    - Functions run with SECURITY DEFINER to update profiles and create notifications
    - Only updates trials that have actually expired
*/

-- Function to automatically expire trials
CREATE OR REPLACE FUNCTION check_trial_expiration()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Update profiles where trial has expired
  UPDATE profiles
  SET
    subscription_status = 'expired',
    updated_at = now()
  WHERE
    subscription_status = 'trial'
    AND trial_end_date IS NOT NULL
    AND trial_end_date < now()
    AND profile_type = 'business';

  -- Create notifications for expired trials
  INSERT INTO notifications (user_id, type, title, message, metadata)
  SELECT
    id,
    'subscription',
    CASE
      WHEN language = 'it' THEN 'Prova gratuita terminata'
      ELSE 'Free trial ended'
    END,
    CASE
      WHEN language = 'it' THEN 'La tua prova gratuita di 2 mesi è terminata. Sottoscrivi un piano per continuare ad accedere alle funzionalità premium.'
      ELSE 'Your 2-month free trial has ended. Subscribe to a plan to continue accessing premium features.'
    END,
    jsonb_build_object('trial_expired', true)
  FROM profiles
  WHERE
    subscription_status = 'expired'
    AND trial_end_date IS NOT NULL
    AND trial_end_date < now()
    AND profile_type = 'business'
    -- Don't create duplicate notifications
    AND NOT EXISTS (
      SELECT 1 FROM notifications n
      WHERE n.user_id = profiles.id
      AND n.type = 'subscription'
      AND n.metadata->>'trial_expired' = 'true'
      AND n.created_at > now() - interval '1 day'
    );
END;
$$;

-- Function to notify users 7 days before trial expiration
CREATE OR REPLACE FUNCTION notify_trial_expiring_soon()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Create notifications for trials expiring in 7 days
  INSERT INTO notifications (user_id, type, title, message, metadata)
  SELECT
    id,
    'subscription',
    CASE
      WHEN language = 'it' THEN 'La tua prova gratuita sta per scadere'
      ELSE 'Your free trial is expiring soon'
    END,
    CASE
      WHEN language = 'it' THEN 'La tua prova gratuita terminerà tra 7 giorni. Sottoscrivi un piano per continuare ad accedere alle funzionalità premium senza interruzioni.'
      ELSE 'Your free trial will end in 7 days. Subscribe to a plan to continue accessing premium features without interruption.'
    END,
    jsonb_build_object(
      'trial_expiring_soon', true,
      'days_remaining', 7,
      'trial_end_date', trial_end_date
    )
  FROM profiles
  WHERE
    subscription_status = 'trial'
    AND trial_end_date IS NOT NULL
    AND trial_end_date BETWEEN now() + interval '6 days 23 hours' AND now() + interval '7 days 1 hour'
    AND profile_type = 'business'
    -- Don't create duplicate notifications
    AND NOT EXISTS (
      SELECT 1 FROM notifications n
      WHERE n.user_id = profiles.id
      AND n.type = 'subscription'
      AND n.metadata->>'trial_expiring_soon' = 'true'
      AND n.created_at > now() - interval '2 days'
    );
END;
$$;

-- Function to get trial status for a user
CREATE OR REPLACE FUNCTION get_trial_status(user_id_param uuid)
RETURNS TABLE(
  is_trial boolean,
  days_remaining integer,
  trial_end_date timestamptz,
  is_expired boolean
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    (subscription_status = 'trial') as is_trial,
    CASE
      WHEN subscription_status = 'trial' AND trial_end_date IS NOT NULL
      THEN GREATEST(0, EXTRACT(day FROM (trial_end_date - now()))::integer)
      ELSE 0
    END as days_remaining,
    profiles.trial_end_date,
    (subscription_status = 'expired' AND trial_end_date < now()) as is_expired
  FROM profiles
  WHERE id = user_id_param;
END;
$$;

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION check_trial_expiration() TO authenticated;
GRANT EXECUTE ON FUNCTION notify_trial_expiring_soon() TO authenticated;
GRANT EXECUTE ON FUNCTION get_trial_status(uuid) TO authenticated;

-- ============================================================
-- FILE: 20260206095721_add_public_view_approved_reviews.sql
-- ============================================================
/*
  # Allow public viewing of approved reviews

  1. Changes
    - Add policy to allow anonymous (non-authenticated) users to view approved reviews
    - This ensures that all visitors can see business reviews without needing to log in

  2. Security
    - Only approved reviews are visible to anonymous users
    - Maintains existing authenticated user policies
*/

-- Policy per permettere agli utenti anonimi di vedere le recensioni approvate
CREATE POLICY "Anonymous users can view approved reviews"
  ON reviews FOR SELECT
  TO anon
  USING (review_status = 'approved');


-- ============================================================
-- FILE: 20260206095841_update_review_points_to_25.sql
-- ============================================================
/*
  # Update review points system to fixed 25 points

  1. Changes
    - Update approve_review function to award 25 points for all reviews regardless of details or proof
    - Simplify points logic: all approved reviews give 25 points

  2. Notes
    - This ensures consistent rewards for all user reviews
    - Encourages participation without complex calculations
*/

-- Aggiorna la funzione per approvare una recensione con 25 punti fissi
CREATE OR REPLACE FUNCTION approve_review(
  review_id_param uuid,
  staff_id_param uuid
)
RETURNS void AS $$
DECLARE
  review_record RECORD;
  customer_id_var uuid;
  points_to_award integer;
BEGIN
  -- Ottieni i dettagli della recensione
  SELECT * INTO review_record FROM reviews WHERE id = review_id_param;
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Recensione non trovata';
  END IF;
  
  IF review_record.review_status != 'pending' THEN
    RAISE EXCEPTION 'La recensione è già stata processata';
  END IF;
  
  -- Tutte le recensioni danno 25 punti
  points_to_award := 25;
  
  -- Aggiorna la recensione
  UPDATE reviews 
  SET review_status = 'approved',
      approved_by = staff_id_param,
      approved_at = now(),
      points_awarded = points_to_award,
      proof_image_url = NULL
  WHERE id = review_id_param;
  
  -- Assegna i punti all'utente
  customer_id_var := review_record.customer_id;
  PERFORM award_points(customer_id_var, points_to_award, 'review', 'Recensione approvata');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================================
-- FILE: 20260206100131_update_review_points_with_proof_50.sql
-- ============================================================
/*
  # Update review points: 25 base, 50 with proof

  1. Changes
    - Update approve_review function to award 50 points for reviews with proof
    - Award 25 points for reviews without proof
    - Simplifies the point system to just two tiers based on proof presence

  2. Notes
    - Reviews with proof (receipt/invoice): 50 points after approval
    - Reviews without proof: 25 points, published immediately
*/

-- Aggiorna la funzione per approvare una recensione
CREATE OR REPLACE FUNCTION approve_review(
  review_id_param uuid,
  staff_id_param uuid
)
RETURNS void AS $$
DECLARE
  review_record RECORD;
  customer_id_var uuid;
  points_to_award integer;
BEGIN
  -- Ottieni i dettagli della recensione
  SELECT * INTO review_record FROM reviews WHERE id = review_id_param;
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Recensione non trovata';
  END IF;
  
  IF review_record.review_status != 'pending' THEN
    RAISE EXCEPTION 'La recensione è già stata processata';
  END IF;
  
  -- Assegna punti in base alla presenza di prova d'acquisto
  IF review_record.proof_image_url IS NOT NULL THEN
    points_to_award := 50; -- Con prova d'acquisto
  ELSE
    points_to_award := 25; -- Senza prova d'acquisto
  END IF;
  
  -- Aggiorna la recensione
  UPDATE reviews 
  SET review_status = 'approved',
      approved_by = staff_id_param,
      approved_at = now(),
      points_awarded = points_to_award,
      proof_image_url = NULL
  WHERE id = review_id_param;
  
  -- Assegna i punti all'utente
  customer_id_var := review_record.customer_id;
  PERFORM award_points(customer_id_var, points_to_award, 'review', 'Recensione approvata');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================================
-- FILE: 20260206100938_allow_reviews_for_unclaimed_businesses.sql
-- ============================================================
/*
  # Allow reviews for unclaimed businesses

  1. Changes
    - Make `business_id` in reviews nullable
    - Add `unclaimed_business_id` field to reviews table
    - Add constraint to ensure exactly one of business_id or unclaimed_business_id is set
    - Update RLS policies to handle both business types

  2. Security
    - Maintain existing RLS policies
    - Ensure users can review both claimed and unclaimed businesses
*/

-- Make business_id nullable and add unclaimed_business_id
ALTER TABLE reviews
  ALTER COLUMN business_id DROP NOT NULL;

-- Add unclaimed_business_id column
ALTER TABLE reviews
  ADD COLUMN IF NOT EXISTS unclaimed_business_id uuid REFERENCES unclaimed_business_locations(id) ON DELETE CASCADE;

-- Add constraint to ensure exactly one of business_id or unclaimed_business_id is set
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'reviews_business_xor'
  ) THEN
    ALTER TABLE reviews
      ADD CONSTRAINT reviews_business_xor
      CHECK (
        (business_id IS NOT NULL AND unclaimed_business_id IS NULL) OR
        (business_id IS NULL AND unclaimed_business_id IS NOT NULL)
      );
  END IF;
END $$;

-- Drop old policies
DROP POLICY IF EXISTS "Anyone can view reviews" ON reviews;
DROP POLICY IF EXISTS "Customers can create reviews" ON reviews;

-- Recreate policies to handle both business types
CREATE POLICY "Anyone can view reviews"
  ON reviews FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Customers can create reviews for businesses"
  ON reviews FOR INSERT
  TO authenticated
  WITH CHECK (
    customer_id = auth.uid() AND
    business_id IS NOT NULL AND
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid()
      AND user_type = 'customer'
      AND (subscription_status = 'active' OR subscription_status = 'trial')
    )
  );

CREATE POLICY "Customers can create reviews for unclaimed businesses"
  ON reviews FOR INSERT
  TO authenticated
  WITH CHECK (
    customer_id = auth.uid() AND
    unclaimed_business_id IS NOT NULL AND
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid()
      AND user_type = 'customer'
      AND (subscription_status = 'active' OR subscription_status = 'trial')
    )
  );

-- Create index for unclaimed_business_id
CREATE INDEX IF NOT EXISTS idx_reviews_unclaimed_business_id ON reviews(unclaimed_business_id);


-- ============================================================
-- FILE: 20260206101059_update_get_business_ratings_for_unclaimed.sql
-- ============================================================
/*
  # Update get_business_ratings function for unclaimed businesses

  1. Changes
    - Update the function to calculate ratings for unclaimed businesses
    - Join reviews using both business_id and unclaimed_business_id

  2. Notes
    - For unclaimed businesses, we need to look at unclaimed_business_id in reviews table
*/

-- Drop existing function
DROP FUNCTION IF EXISTS get_business_ratings(uuid[]);

-- Create updated function that handles both business types
CREATE OR REPLACE FUNCTION get_business_ratings(business_ids uuid[])
RETURNS TABLE (
  id uuid,
  avg_rating numeric,
  review_count bigint
)
AS $$
BEGIN
  RETURN QUERY
  SELECT
    b.id,
    COALESCE(AVG(r.overall_rating), 0)::numeric as avg_rating,
    COUNT(r.id) as review_count
  FROM unnest(business_ids) AS b(id)
  LEFT JOIN reviews r ON (r.business_id = b.id OR r.unclaimed_business_id = b.id)
  WHERE r.review_status = 'approved' OR r.id IS NULL
  GROUP BY b.id;
END;
$$ LANGUAGE plpgsql STABLE;


-- ============================================================
-- FILE: 20260206101113_update_business_ratings_view_for_unclaimed.sql
-- ============================================================
/*
  # Update business_ratings materialized view for unclaimed businesses

  1. Changes
    - Update the materialized view to include unclaimed businesses
    - Use UNION to combine both claimed and unclaimed businesses
    - Calculate ratings from both business_id and unclaimed_business_id in reviews

  2. Notes
    - The view now includes both types of businesses
    - Unclaimed businesses will have owner_id = NULL
*/

-- Drop existing materialized view
DROP MATERIALIZED VIEW IF EXISTS business_ratings;

-- Create updated materialized view
CREATE MATERIALIZED VIEW business_ratings AS
-- Claimed businesses
SELECT
  b.id,
  COALESCE(AVG(r.rating), 0) as avg_rating,
  COUNT(r.id) as review_count
FROM businesses b
LEFT JOIN reviews r ON r.business_id = b.id AND r.review_status = 'approved'
GROUP BY b.id

UNION ALL

-- Unclaimed businesses
SELECT
  ubl.id,
  COALESCE(AVG(r.rating), 0) as avg_rating,
  COUNT(r.id) as review_count
FROM unclaimed_business_locations ubl
LEFT JOIN reviews r ON r.unclaimed_business_id = ubl.id AND r.review_status = 'approved'
GROUP BY ubl.id;

-- Create index on the materialized view
CREATE INDEX IF NOT EXISTS idx_business_ratings_id ON business_ratings(id);
CREATE INDEX IF NOT EXISTS idx_business_ratings_avg_rating ON business_ratings(avg_rating);

-- Add comment
COMMENT ON MATERIALIZED VIEW business_ratings IS 'Precalculated ratings for both claimed and unclaimed businesses';


-- ============================================================
-- FILE: 20260206101142_add_public_view_for_unclaimed_reviews.sql
-- ============================================================
/*
  # Add public view for unclaimed business reviews

  1. Changes
    - Update RLS policies to allow public viewing of approved reviews
    - This includes both claimed and unclaimed business reviews

  2. Security
    - Only approved reviews are visible to the public
    - Pending reviews remain private
*/

-- Drop existing public view policy
DROP POLICY IF EXISTS "Public can view approved reviews" ON reviews;

-- Create new policy for public viewing of approved reviews
CREATE POLICY "Public can view approved reviews"
  ON reviews FOR SELECT
  TO anon, authenticated
  USING (review_status = 'approved');


-- ============================================================
-- FILE: 20260206110154_set_review_status_default_pending.sql
-- ============================================================
/*
  # Set review status default to pending

  1. Changes
    - Change the default value of review_status from 'approved' to 'pending'
    - All new reviews will require staff approval before being visible publicly
    - Reviews can still be seen by their authors even when pending

  2. Notes
    - Existing approved reviews remain approved
    - Points are awarded only when a review is approved by staff
    - Reviews with proof get 50 points, without proof get 25 points
*/

-- Change the default value of review_status to 'pending'
ALTER TABLE reviews 
  ALTER COLUMN review_status SET DEFAULT 'pending';


-- ============================================================
-- FILE: 20260206111622_fix_award_points_use_user_activity.sql
-- ============================================================
/*
  # Fix award_points function to use user_activity table

  1. Changes
    - Update award_points function to use user_activity table instead of user_points
    - Maintain backward compatibility with existing code
    - Ensure points are tracked correctly in user_activity

  2. Notes
    - The user_points table doesn't exist, but user_activity does
    - Points are stored in user_activity.total_points
    - Activity logs are stored in activity_log table
*/

CREATE OR REPLACE FUNCTION award_points(
  p_user_id uuid,
  p_points integer,
  p_activity_type text,
  p_description text DEFAULT NULL
) RETURNS integer AS $$
DECLARE
  v_new_total integer;
BEGIN
  -- Insert or update user_activity
  INSERT INTO user_activity (user_id, total_points, last_activity_at)
  VALUES (p_user_id, p_points, now())
  ON CONFLICT (user_id) 
  DO UPDATE SET 
    total_points = user_activity.total_points + p_points,
    last_activity_at = now();

  -- Get the new total
  SELECT total_points INTO v_new_total
  FROM user_activity
  WHERE user_id = p_user_id;

  -- Return the new total
  RETURN v_new_total;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION award_points TO authenticated;


-- ============================================================
-- FILE: 20260206111716_fix_approve_review_proof_based_points.sql
-- ============================================================
/*
  # Fix approve_review to use proof-based points

  1. Changes
    - Update approve_review function to award points based on proof_image_url presence
    - 50 points: Reviews with proof of purchase (receipt/invoice)
    - 25 points: Reviews without proof
    - Points are awarded only when staff approves the review

  2. Notes
    - All reviews start as 'pending' regardless of proof
    - Staff must approve all reviews before they become public
    - Points are awarded during approval based on proof presence
*/

CREATE OR REPLACE FUNCTION approve_review(
  review_id_param uuid,
  staff_id_param uuid
)
RETURNS void AS $$
DECLARE
  review_record RECORD;
  customer_id_var uuid;
  points_to_award integer;
BEGIN
  -- Get review details
  SELECT * INTO review_record FROM reviews WHERE id = review_id_param;
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Recensione non trovata';
  END IF;
  
  IF review_record.review_status != 'pending' THEN
    RAISE EXCEPTION 'La recensione è già stata processata';
  END IF;
  
  -- Award points based on proof presence
  IF review_record.proof_image_url IS NOT NULL AND review_record.proof_image_url != '' THEN
    points_to_award := 50; -- With proof of purchase
  ELSE
    points_to_award := 25; -- Without proof
  END IF;
  
  -- Update review
  UPDATE reviews 
  SET review_status = 'approved',
      approved_by = staff_id_param,
      approved_at = now(),
      points_awarded = points_to_award,
      proof_image_url = NULL -- Delete image after approval
  WHERE id = review_id_param;
  
  -- Award points to user
  customer_id_var := review_record.customer_id;
  PERFORM award_points(customer_id_var, points_to_award, 'review', 'Recensione approvata');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================================
-- FILE: 20260207122620_add_admin_role_system_final.sql
-- ============================================================
/*
  # Add Admin Role System

  1. Changes
    - Add is_admin boolean field to profiles table
    - Create admin-only policies for managing reviews, users, and content
    - Grant admin users ability to approve/reject reviews
    - Grant admin users ability to manage subscriptions

  2. Security
    - Only admins can access admin functions
    - Admins can view and moderate all content
    - Regular users cannot access admin features
*/

-- Add is_admin field to profiles
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS is_admin boolean DEFAULT false;

-- Create index for faster admin lookups
CREATE INDEX IF NOT EXISTS idx_profiles_is_admin ON profiles(is_admin) WHERE is_admin = true;

-- Grant admin users full access to reviews
DROP POLICY IF EXISTS "Admins can view all reviews" ON reviews;
CREATE POLICY "Admins can view all reviews"
  ON reviews FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can update any review" ON reviews;
CREATE POLICY "Admins can update any review"
  ON reviews FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

-- Grant admin users full access to classified ads
DROP POLICY IF EXISTS "Admins can view all classified ads" ON classified_ads;
CREATE POLICY "Admins can view all classified ads"
  ON classified_ads FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can update any classified ad" ON classified_ads;
CREATE POLICY "Admins can update any classified ad"
  ON classified_ads FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can delete any classified ad" ON classified_ads;
CREATE POLICY "Admins can delete any classified ad"
  ON classified_ads FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

-- Grant admin users access to view all profiles
DROP POLICY IF EXISTS "Admins can view all profiles" ON profiles;
CREATE POLICY "Admins can view all profiles"
  ON profiles FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid() 
      AND p.is_admin = true
    )
  );

-- Grant admin users access to view all subscriptions
DROP POLICY IF EXISTS "Admins can view all subscriptions" ON subscriptions;
CREATE POLICY "Admins can view all subscriptions"
  ON subscriptions FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can update any subscription" ON subscriptions;
CREATE POLICY "Admins can update any subscription"
  ON subscriptions FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

-- Grant admin users access to view all user activity
DROP POLICY IF EXISTS "Admins can view all user activity" ON user_activity;
CREATE POLICY "Admins can view all user activity"
  ON user_activity FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );


