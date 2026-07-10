-- ============================================================
-- FILE: 20260422074727_add_current_bidder_to_auctions.sql
-- ============================================================
/*
  # Add current bidder tracking to auctions

  1. Changes
    - Add `current_bidder_id` (uuid) column to auctions table
    - Add `current_bidder_nickname` (text) column to auctions table
    - Create trigger that updates these fields when a new bid is placed
    - Backfill existing auctions with their current top bidder

  2. Important Notes
    - These denormalized columns are auto-updated by a trigger on auction_bids
    - Provides instant access to top bidder info without extra joins
*/

-- Add columns
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'auctions' AND column_name = 'current_bidder_id'
  ) THEN
    ALTER TABLE auctions ADD COLUMN current_bidder_id uuid REFERENCES auth.users(id);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'auctions' AND column_name = 'current_bidder_nickname'
  ) THEN
    ALTER TABLE auctions ADD COLUMN current_bidder_nickname text;
  END IF;
END $$;

-- Create trigger function to update current bidder on new bids
CREATE OR REPLACE FUNCTION update_auction_current_bidder()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_nickname text;
  v_current_max numeric;
BEGIN
  -- Check if this bid is actually the highest
  SELECT MAX(bid_amount) INTO v_current_max
  FROM auction_bids
  WHERE auction_id = NEW.auction_id;

  IF NEW.bid_amount >= v_current_max THEN
    -- Get the bidder's nickname or full name
    SELECT COALESCE(nickname, full_name, 'Utente')
    INTO v_nickname
    FROM profiles
    WHERE id = NEW.user_id;

    -- If bid was placed by a family member, use their nickname instead
    IF NEW.family_member_id IS NOT NULL THEN
      SELECT COALESCE(nickname, first_name, 'Utente')
      INTO v_nickname
      FROM customer_family_members
      WHERE id = NEW.family_member_id;
    END IF;

    -- Update the auction
    UPDATE auctions
    SET current_bidder_id = NEW.user_id,
        current_bidder_nickname = v_nickname,
        current_price = NEW.bid_amount
    WHERE id = NEW.auction_id;
  END IF;

  RETURN NEW;
END;
$$;

-- Drop existing trigger if any
DROP TRIGGER IF EXISTS trg_update_auction_current_bidder ON auction_bids;

-- Create trigger
CREATE TRIGGER trg_update_auction_current_bidder
  AFTER INSERT ON auction_bids
  FOR EACH ROW
  EXECUTE FUNCTION update_auction_current_bidder();

-- Backfill existing auctions with their current top bidder
UPDATE auctions a
SET current_bidder_id = sub.user_id,
    current_bidder_nickname = sub.nickname
FROM (
  SELECT DISTINCT ON (ab.auction_id)
    ab.auction_id,
    ab.user_id,
    COALESCE(
      CASE WHEN ab.family_member_id IS NOT NULL
        THEN (SELECT COALESCE(cfm.nickname, cfm.first_name) FROM customer_family_members cfm WHERE cfm.id = ab.family_member_id)
        ELSE NULL
      END,
      p.nickname,
      p.full_name,
      'Utente'
    ) AS nickname
  FROM auction_bids ab
  LEFT JOIN profiles p ON p.id = ab.user_id
  ORDER BY ab.auction_id, ab.bid_amount DESC
) sub
WHERE a.id = sub.auction_id AND a.current_price > 0;


-- ============================================================
-- FILE: 20260422082140_fix_unclaimed_business_default_approval_status.sql
-- ============================================================
/*
  # Fix unclaimed_business_locations default approval_status

  1. Changes
    - Set default value for approval_status to 'pending' on unclaimed_business_locations table
    - This ensures all user-added businesses start as pending and require admin approval

  2. Important Notes
    - Imported businesses (added_by IS NULL) already have approval_status = NULL which is unaffected
    - Only new user-added businesses will default to 'pending'
*/

ALTER TABLE unclaimed_business_locations
ALTER COLUMN approval_status SET DEFAULT 'pending';


-- ============================================================
-- FILE: 20260422082212_fix_featured_ads_filter_approved_only.sql
-- ============================================================
/*
  # Fix featured classified ads to show only approved ads

  1. Changes
    - Update get_featured_classified_ads function to filter by approval_status = 'approved'
    - Prevents unapproved ads from appearing on the homepage

  2. Security
    - Only approved ads are shown to public users
*/

CREATE OR REPLACE FUNCTION get_featured_classified_ads(
  ad_type_filter text DEFAULT 'all',
  limit_count int DEFAULT 6
)
RETURNS TABLE (
  id uuid,
  title text,
  description text,
  price numeric,
  ad_type text,
  category text,
  category_id uuid,
  location text,
  region text,
  province text,
  city text,
  images text[],
  user_id uuid,
  status text,
  created_at timestamptz,
  expires_at timestamptz,
  user_full_name text,
  user_nickname text,
  user_avatar_url text,
  user_points int
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
RETURN QUERY
SELECT
ca.id,
ca.title,
ca.description,
ca.price,
ca.ad_type::text,
COALESCE(cat.name, '') as category,
ca.category_id,
ca.location,
ca.region,
ca.province,
ca.city,
ca.images,
ca.user_id,
ca.status::text,
ca.created_at,
ca.expires_at,
p.full_name as user_full_name,
p.nickname as user_nickname,
p.avatar_url as user_avatar_url,
COALESCE(ua.total_points, 0) as user_points
FROM classified_ads ca
INNER JOIN profiles p ON ca.user_id = p.id
LEFT JOIN user_activity ua ON ca.user_id = ua.user_id AND ua.family_member_id IS NULL
LEFT JOIN classified_categories cat ON ca.category_id = cat.id
WHERE ca.status = 'active'
AND ca.approval_status = 'approved'
AND ca.expires_at > now()
AND (ad_type_filter = 'all' OR ca.ad_type::text = ad_type_filter)
ORDER BY
COALESCE(ua.total_points, 0) DESC,
ca.created_at DESC
LIMIT limit_count;
END;
$$;


-- ============================================================
-- FILE: 20260422084131_fix_reviews_insert_rls_policy_business_types.sql
-- ============================================================
/*
  # Fix reviews insert RLS policy for all business types

  1. Changes
    - Drop and recreate the reviews insert policy to support all business reference patterns
    - Allow reviews when any valid business reference is set (business_id, imported_business_id,
      user_added_business_id, unclaimed_business_location_id, or business_location_id)

  2. Security
    - Still requires customer_id = auth.uid()
    - Still validates family_member ownership
    - Ensures at least one business reference is provided
*/

DO $$ BEGIN
  DROP POLICY IF EXISTS "Customers and family members can create reviews" ON reviews;
END $$;

CREATE POLICY "Customers and family members can create reviews"
  ON reviews
  FOR INSERT
  TO authenticated
  WITH CHECK (
    customer_id = auth.uid()
    AND (
      family_member_id IS NULL
      OR EXISTS (
        SELECT 1 FROM customer_family_members
        WHERE customer_family_members.id = reviews.family_member_id
        AND customer_family_members.customer_id = auth.uid()
      )
    )
    AND (
      business_id IS NOT NULL
      OR imported_business_id IS NOT NULL
      OR user_added_business_id IS NOT NULL
      OR unclaimed_business_location_id IS NOT NULL
      OR business_location_id IS NOT NULL
    )
  );


-- ============================================================
-- FILE: 20260422100511_add_italian_values_to_ad_type_enum.sql
-- ============================================================
/*
  # Add Italian values to ad_type_enum

  1. Changes
    - Add 'vendita', 'acquisto', 'regalo' as valid values for the ad_type_enum
    - This ensures both English and Italian labels are accepted by the database

  2. Important Notes
    - Existing values (sell, buy, gift) remain unchanged
    - This is a non-destructive change that only adds new accepted values
*/

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'vendita' AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'ad_type_enum')) THEN
    ALTER TYPE ad_type_enum ADD VALUE 'vendita';
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'acquisto' AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'ad_type_enum')) THEN
    ALTER TYPE ad_type_enum ADD VALUE 'acquisto';
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'regalo_it' AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'ad_type_enum')) THEN
    ALTER TYPE ad_type_enum ADD VALUE 'regalo';
  END IF;
END $$;


-- ============================================================
-- FILE: 20260422102000_fix_user_activity_null_family_member_upsert.sql
-- ============================================================
/*
  # Fix user_activity upsert when family_member_id is NULL

  1. Problem
    - The increment_unclaimed_business_count trigger uses ON CONFLICT (user_id, family_member_id)
    - When family_member_id is NULL, NULL != NULL in SQL so the conflict clause never matches
    - But a partial unique index (user_activity_user_id_null_family_unique) blocks the duplicate insert
    - This causes a unique constraint violation error when adding businesses

  2. Fix
    - Update the trigger function to use a conditional approach:
      - When family_member_id is NULL, use ON CONFLICT on the partial index
      - When family_member_id is NOT NULL, use ON CONFLICT on the composite index
    - Apply the same fix to all similar trigger functions that upsert into user_activity
*/

CREATE OR REPLACE FUNCTION increment_unclaimed_business_count()
RETURNS TRIGGER AS $$
DECLARE
  v_family_member_id uuid;
BEGIN
  v_family_member_id := NEW.added_by_family_member_id;

  IF v_family_member_id IS NOT NULL THEN
    INSERT INTO user_activity (user_id, family_member_id, businesses_added_count, last_activity_at, created_at, updated_at)
    VALUES (NEW.added_by, v_family_member_id, 1, now(), now(), now())
    ON CONFLICT (user_id, family_member_id)
    DO UPDATE SET
      businesses_added_count = user_activity.businesses_added_count + 1,
      last_activity_at = now(),
      updated_at = now();
  ELSE
    INSERT INTO user_activity (user_id, family_member_id, businesses_added_count, last_activity_at, created_at, updated_at)
    VALUES (NEW.added_by, NULL, 1, now(), now(), now())
    ON CONFLICT (user_id) WHERE family_member_id IS NULL
    DO UPDATE SET
      businesses_added_count = user_activity.businesses_added_count + 1,
      last_activity_at = now(),
      updated_at = now();
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION decrement_unclaimed_business_count()
RETURNS TRIGGER AS $$
DECLARE
  v_family_member_id uuid;
BEGIN
  v_family_member_id := OLD.added_by_family_member_id;

  IF v_family_member_id IS NOT NULL THEN
    UPDATE user_activity
    SET businesses_added_count = GREATEST(0, businesses_added_count - 1),
        last_activity_at = now(),
        updated_at = now()
    WHERE user_id = OLD.added_by AND family_member_id = v_family_member_id;
  ELSE
    UPDATE user_activity
    SET businesses_added_count = GREATEST(0, businesses_added_count - 1),
        last_activity_at = now(),
        updated_at = now()
    WHERE user_id = OLD.added_by AND family_member_id IS NULL;
  END IF;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================================
-- FILE: 20260422102046_fix_all_user_activity_null_family_member_upserts.sql
-- ============================================================
/*
  # Fix all user_activity upsert functions for NULL family_member_id

  1. Problem
    - Multiple trigger functions use ON CONFLICT (user_id, family_member_id) when family_member_id is NULL
    - NULL != NULL in SQL, so the conflict clause never matches for NULL family members
    - This causes unique constraint violations from the partial index user_activity_user_id_null_family_unique

  2. Functions Fixed
    - award_points_for_unclaimed_business_on_approval: handles approval points
    - award_points_for_unclaimed_business: handles immediate points on add
    - sync_user_activity: syncs review counts
    - populate_user_activity: bulk population utility

  3. Fix Applied
    - Changed ELSE branches to use ON CONFLICT (user_id) WHERE family_member_id IS NULL
    - This correctly targets the partial unique index for NULL family member cases
*/

-- Fix award_points_for_unclaimed_business_on_approval
CREATE OR REPLACE FUNCTION award_points_for_unclaimed_business_on_approval()
RETURNS TRIGGER AS $$
DECLARE
  points_to_award INTEGER;
  is_complete BOOLEAN;
  v_family_member_id uuid;
BEGIN
  IF NEW.approval_status = 'approved' 
  AND (OLD.approval_status IS DISTINCT FROM 'approved')
  AND (NEW.points_awarded IS NOT TRUE) THEN

    is_complete := (
      (NEW.email IS NOT NULL AND NEW.email != '') OR 
      (NEW.phone IS NOT NULL AND NEW.phone != '') OR 
      (NEW.website IS NOT NULL AND NEW.website != '')
    );

    IF is_complete THEN
      points_to_award := 25;
    ELSE
      points_to_award := 10;
    END IF;

    v_family_member_id := NEW.added_by_family_member_id;

    IF NEW.added_by IS NOT NULL THEN
      IF v_family_member_id IS NOT NULL THEN
        INSERT INTO user_activity (user_id, family_member_id, total_points, businesses_added_count, last_activity_at, created_at, updated_at)
        VALUES (NEW.added_by, v_family_member_id, points_to_award, 1, now(), now(), now())
        ON CONFLICT (user_id, family_member_id)
        DO UPDATE SET
          total_points = user_activity.total_points + points_to_award,
          businesses_added_count = user_activity.businesses_added_count + 1,
          last_activity_at = now(),
          updated_at = now();
      ELSE
        INSERT INTO user_activity (user_id, family_member_id, total_points, businesses_added_count, last_activity_at, created_at, updated_at)
        VALUES (NEW.added_by, NULL, points_to_award, 1, now(), now(), now())
        ON CONFLICT (user_id) WHERE family_member_id IS NULL
        DO UPDATE SET
          total_points = user_activity.total_points + points_to_award,
          businesses_added_count = user_activity.businesses_added_count + 1,
          last_activity_at = now(),
          updated_at = now();
      END IF;

      INSERT INTO activity_log (
        user_id, activity_type, title, description, points_earned, icon, color, metadata, created_at
      ) VALUES (
        NEW.added_by,
        'business_added',
        'Attivita'' approvata',
        CASE 
          WHEN is_complete THEN 'La tua attivita'' "' || NEW.name || '" e'' stata approvata (con dati completi)'
          ELSE 'La tua attivita'' "' || NEW.name || '" e'' stata approvata'
        END,
        points_to_award,
        'building',
        'green',
        jsonb_build_object(
          'business_id', NEW.id,
          'business_name', NEW.name,
          'is_complete', is_complete,
          'family_member_id', v_family_member_id
        ),
        now()
      );

      INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
      VALUES (
        NEW.added_by,
        v_family_member_id,
        'business_approved',
        'Attivita'' Approvata',
        'La tua attivita'' "' || NEW.name || '" e'' stata approvata. Hai guadagnato ' || points_to_award || ' punti in classifica!',
        jsonb_build_object('business_id', NEW.id, 'business_name', NEW.name, 'points_awarded', points_to_award)
      );

      NEW.points_awarded := true;
    END IF;
  END IF;

  IF NEW.approval_status = 'rejected'
  AND (OLD.approval_status IS DISTINCT FROM 'rejected')
  AND NEW.added_by IS NOT NULL THEN

    v_family_member_id := NEW.added_by_family_member_id;

    INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
    VALUES (
      NEW.added_by,
      v_family_member_id,
      'business_rejected',
      'Attivita'' Rifiutata',
      'La tua attivita'' "' || NEW.name || '" non e'' stata approvata. Verifica i dati inseriti e riprova.',
      jsonb_build_object('business_id', NEW.id, 'business_name', NEW.name)
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Fix award_points_for_unclaimed_business
CREATE OR REPLACE FUNCTION award_points_for_unclaimed_business()
RETURNS TRIGGER AS $$
DECLARE
  points_to_award INTEGER;
  is_complete BOOLEAN;
  v_family_member_id uuid;
BEGIN
  is_complete := (
    (NEW.email IS NOT NULL AND NEW.email != '') OR 
    (NEW.phone IS NOT NULL AND NEW.phone != '') OR 
    (NEW.website IS NOT NULL AND NEW.website != '')
  );

  IF is_complete THEN
    points_to_award := 25;
  ELSE
    points_to_award := 10;
  END IF;

  v_family_member_id := NEW.added_by_family_member_id;

  IF v_family_member_id IS NOT NULL THEN
    INSERT INTO user_activity (user_id, family_member_id, total_points, businesses_added_count, last_activity_at, created_at, updated_at)
    VALUES (NEW.added_by, v_family_member_id, points_to_award, 1, now(), now(), now())
    ON CONFLICT (user_id, family_member_id)
    DO UPDATE SET
      total_points = user_activity.total_points + points_to_award,
      businesses_added_count = user_activity.businesses_added_count + 1,
      last_activity_at = now(),
      updated_at = now();
  ELSE
    INSERT INTO user_activity (user_id, family_member_id, total_points, businesses_added_count, last_activity_at, created_at, updated_at)
    VALUES (NEW.added_by, NULL, points_to_award, 1, now(), now(), now())
    ON CONFLICT (user_id) WHERE family_member_id IS NULL
    DO UPDATE SET
      total_points = user_activity.total_points + points_to_award,
      businesses_added_count = user_activity.businesses_added_count + 1,
      last_activity_at = now(),
      updated_at = now();
  END IF;

  INSERT INTO activity_log (
    user_id,
    family_member_id,
    activity_type,
    title,
    description,
    points_earned,
    icon,
    color,
    metadata,
    created_at
  ) VALUES (
    NEW.added_by,
    v_family_member_id,
    'business_added',
    'Attivita'' aggiunta',
    CASE 
      WHEN is_complete THEN 'Hai aggiunto "' || NEW.name || '" con dati completi'
      ELSE 'Hai aggiunto "' || NEW.name || '"'
    END,
    points_to_award,
    'building',
    'green',
    jsonb_build_object(
      'business_id', NEW.id,
      'business_name', NEW.name,
      'is_complete', is_complete,
      'family_member_id', v_family_member_id
    ),
    now()
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Fix sync_user_activity
CREATE OR REPLACE FUNCTION sync_user_activity()
RETURNS void AS $$
BEGIN
  INSERT INTO user_activity (user_id, family_member_id, total_points, reviews_count, last_activity_at, updated_at)
  SELECT
    p.id as user_id,
    NULL as family_member_id,
    COALESCE(SUM(CASE
      WHEN r.proof_image_url IS NOT NULL THEN 50
      ELSE 25
    END), 0) as total_points,
    COUNT(r.id) as reviews_count,
    NOW() as last_activity_at,
    NOW() as updated_at
  FROM profiles p
  LEFT JOIN reviews r ON r.customer_id = p.id
    AND r.family_member_id IS NULL
    AND r.review_status = 'approved'
  WHERE p.user_type = 'customer'
  GROUP BY p.id
  ON CONFLICT (user_id) WHERE family_member_id IS NULL
  DO UPDATE SET
    total_points = EXCLUDED.total_points,
    reviews_count = EXCLUDED.reviews_count,
    updated_at = NOW();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Fix populate_user_activity
CREATE OR REPLACE FUNCTION populate_user_activity()
RETURNS void AS $$
DECLARE
  user_record RECORD;
  reviews_cnt INTEGER;
  ads_cnt INTEGER;
  jobs_cnt INTEGER;
  referrals_cnt INTEGER;
  points INTEGER;
BEGIN
  FOR user_record IN
    SELECT id, referral_count FROM profiles WHERE user_type IN ('customer', 'business')
  LOOP
    SELECT COUNT(*) INTO reviews_cnt
    FROM reviews
    WHERE customer_id = user_record.id AND review_status = 'approved';

    SELECT COUNT(*) INTO ads_cnt
    FROM classified_ads
    WHERE user_id = user_record.id AND status = 'active';

    SELECT COUNT(*) INTO jobs_cnt
    FROM job_seekers
    WHERE user_id = user_record.id AND status = 'active';

    referrals_cnt := COALESCE(user_record.referral_count, 0);

    SELECT
      COALESCE(SUM(
        CASE
          WHEN proof_image_url IS NOT NULL THEN 50
          ELSE 25
        END
      ), 0) INTO points
    FROM reviews
    WHERE customer_id = user_record.id AND review_status = 'approved';

    points := points + (ads_cnt * 10);
    points := points + (referrals_cnt * 100);

    INSERT INTO user_activity (
      user_id,
      family_member_id,
      total_points,
      reviews_count,
      ads_count,
      job_postings_count,
      referrals_count,
      last_activity_at,
      updated_at
    )
    VALUES (
      user_record.id,
      NULL,
      points,
      reviews_cnt,
      ads_cnt,
      jobs_cnt,
      referrals_cnt,
      now(),
      now()
    )
    ON CONFLICT (user_id) WHERE family_member_id IS NULL
    DO UPDATE SET
      total_points = EXCLUDED.total_points,
      reviews_count = EXCLUDED.reviews_count,
      ads_count = EXCLUDED.ads_count,
      job_postings_count = EXCLUDED.job_postings_count,
      referrals_count = EXCLUDED.referrals_count,
      last_activity_at = now(),
      updated_at = now();
  END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================================
-- FILE: 20260422155910_fix_approve_review_check_proof_documents.sql
-- ============================================================
/*
  # Fix approve_review to check proof_documents array

  ## Problem
  The ReviewForm saves proof uploads to the `proof_documents` column (text array),
  but the `approve_review` function only checks `proof_image_url` (legacy single URL).
  This means reviews with proof documents are approved with only 25 points instead of 50.

  ## Changes
  1. Update `approve_review` to check BOTH `proof_image_url` and `proof_documents`
  2. If either field contains proof, award 50 points
  3. Stop clearing proof_documents on approval so admin can always see them

  ## Notes
  - proof_image_url is the legacy field (single URL)
  - proof_documents is the current field (array of URLs/paths)
  - Both should be checked for backwards compatibility
*/

CREATE OR REPLACE FUNCTION approve_review(
  review_id_param uuid,
  staff_id_param uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  review_record RECORD;
  customer_id_var uuid;
  family_member_id_var uuid;
  points_to_award integer;
  has_proof boolean;
BEGIN
  SELECT * INTO review_record FROM reviews WHERE id = review_id_param;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Recensione non trovata';
  END IF;

  IF review_record.review_status != 'pending' THEN
    RAISE EXCEPTION 'La recensione e'' gia'' stata processata';
  END IF;

  has_proof := (
    (review_record.proof_image_url IS NOT NULL AND review_record.proof_image_url != '')
    OR
    (review_record.proof_documents IS NOT NULL AND array_length(review_record.proof_documents, 1) > 0)
  );

  IF has_proof THEN
    points_to_award := 50;
  ELSE
    points_to_award := 25;
  END IF;

  UPDATE reviews
  SET review_status = 'approved',
      approved_by = staff_id_param,
      approved_at = now(),
      points_awarded = points_to_award
  WHERE id = review_id_param;

  customer_id_var := review_record.customer_id;
  family_member_id_var := review_record.family_member_id;

  PERFORM award_points(customer_id_var, points_to_award, 'review', 'Recensione approvata', family_member_id_var);

  INSERT INTO activity_log (user_id, action, details)
  VALUES (
    staff_id_param,
    'review_approved',
    jsonb_build_object(
      'review_id', review_id_param,
      'points_awarded', points_to_award,
      'had_proof', has_proof,
      'family_member_id', family_member_id_var
    )
  );

  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    customer_id_var,
    family_member_id_var,
    'review_approved',
    'Recensione Approvata',
    'La tua recensione e'' stata approvata. Hai guadagnato ' || points_to_award || ' punti in classifica!',
    jsonb_build_object('review_id', review_id_param, 'points_awarded', points_to_award)
  );
END;
$$;


-- ============================================================
-- FILE: 20260422155925_make_review_proof_documents_bucket_public.sql
-- ============================================================
/*
  # Make review-proof-documents bucket public

  ## Problem
  The bucket is private, so getPublicUrl returns URLs that are not accessible.
  Admins need to view proof documents when reviewing submissions.

  ## Changes
  1. Set the bucket to public so uploaded proof images are viewable via public URL
  2. Keep existing RLS policies for upload/delete control
*/

UPDATE storage.buckets
SET public = true
WHERE id = 'review-proof-documents';


