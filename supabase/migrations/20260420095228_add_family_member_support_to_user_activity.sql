/*
  # Add family member support to user_activity and leaderboard

  ## Summary
  I membri della famiglia devono poter guadagnare punti separatamente dall'utente principale
  e comparire nella classifica come voci indipendenti.

  ## Changes

  ### 1. user_activity table
  - Add `family_member_id` column (nullable, FK to customer_family_members)
  - Drop old unique constraint on user_id alone
  - Add new unique constraint on (user_id, family_member_id) to allow one row per member
  - Add index for performance

  ### 2. award_points function
  - Accept optional `p_family_member_id` parameter
  - When family_member_id is provided, upsert the row for that specific member

  ### 3. approve_review function
  - Pass family_member_id from the review record to award_points

  ### 4. subtract_points_for_deleted_review trigger
  - Pass family_member_id to award_points when subtracting

  ### 5. RLS
  - Allow public SELECT on family member rows so leaderboard can read them
*/

-- 1. Add family_member_id column to user_activity
ALTER TABLE user_activity
ADD COLUMN IF NOT EXISTS family_member_id uuid REFERENCES customer_family_members(id) ON DELETE SET NULL;

-- 2. Drop old unique constraint (user_id only) and add composite one
ALTER TABLE user_activity DROP CONSTRAINT IF EXISTS user_activity_pkey;
ALTER TABLE user_activity DROP CONSTRAINT IF EXISTS user_activity_user_id_key;

-- Add composite primary key / unique constraint
ALTER TABLE user_activity ADD CONSTRAINT user_activity_user_family_unique
  UNIQUE (user_id, family_member_id);

-- Index for leaderboard queries on family members
CREATE INDEX IF NOT EXISTS idx_user_activity_family_member_id
  ON user_activity (family_member_id);

-- 3. Update award_points to handle family members
CREATE OR REPLACE FUNCTION award_points(
  p_user_id uuid,
  p_points integer,
  p_activity_type text,
  p_description text DEFAULT '',
  p_family_member_id uuid DEFAULT NULL
)
RETURNS integer
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_new_total integer;
BEGIN
  IF p_family_member_id IS NOT NULL THEN
    -- Award points to the specific family member row
    IF p_activity_type = 'review' THEN
      INSERT INTO user_activity (user_id, family_member_id, total_points, reviews_count, last_activity_at)
      VALUES (p_user_id, p_family_member_id, p_points, 1, now())
      ON CONFLICT (user_id, family_member_id)
      DO UPDATE SET
        total_points = user_activity.total_points + p_points,
        reviews_count = user_activity.reviews_count + 1,
        last_activity_at = now();
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, total_points, last_activity_at)
      VALUES (p_user_id, p_family_member_id, p_points, now())
      ON CONFLICT (user_id, family_member_id)
      DO UPDATE SET
        total_points = user_activity.total_points + p_points,
        last_activity_at = now();
    END IF;

    SELECT total_points INTO v_new_total
    FROM user_activity
    WHERE user_id = p_user_id AND family_member_id = p_family_member_id;
  ELSE
    -- Award points to the main user row (family_member_id IS NULL)
    IF p_activity_type = 'review' THEN
      INSERT INTO user_activity (user_id, total_points, reviews_count, last_activity_at)
      VALUES (p_user_id, p_points, 1, now())
      ON CONFLICT (user_id, family_member_id)
      DO UPDATE SET
        total_points = user_activity.total_points + p_points,
        reviews_count = user_activity.reviews_count + 1,
        last_activity_at = now()
      WHERE user_activity.family_member_id IS NULL;
    ELSE
      INSERT INTO user_activity (user_id, total_points, last_activity_at)
      VALUES (p_user_id, p_points, now())
      ON CONFLICT (user_id, family_member_id)
      DO UPDATE SET
        total_points = user_activity.total_points + p_points,
        last_activity_at = now()
      WHERE user_activity.family_member_id IS NULL;
    END IF;

    SELECT total_points INTO v_new_total
    FROM user_activity
    WHERE user_id = p_user_id AND family_member_id IS NULL;
  END IF;

  RETURN v_new_total;
END;
$$;

-- 4. Update approve_review to pass family_member_id to award_points
CREATE OR REPLACE FUNCTION approve_review(review_id_param uuid, staff_id_param uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  review_record RECORD;
  customer_id_var uuid;
  family_member_id_var uuid;
  points_to_award integer;
BEGIN
  SELECT * INTO review_record FROM reviews WHERE id = review_id_param;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Recensione non trovata';
  END IF;

  IF review_record.review_status != 'pending' THEN
    RAISE EXCEPTION 'La recensione è già stata processata';
  END IF;

  IF review_record.proof_image_url IS NOT NULL AND review_record.proof_image_url != '' THEN
    points_to_award := 50;
  ELSE
    points_to_award := 25;
  END IF;

  UPDATE reviews
  SET review_status = 'approved',
      approved_by = staff_id_param,
      approved_at = now(),
      points_awarded = points_to_award,
      proof_image_url = NULL
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
      'had_proof', (review_record.proof_image_url IS NOT NULL),
      'family_member_id', family_member_id_var
    )
  );
END;
$$;

-- 5. Update subtract_points trigger to handle family members
CREATE OR REPLACE FUNCTION subtract_points_for_deleted_review()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  points_to_subtract INTEGER;
BEGIN
  IF OLD.proof_url IS NOT NULL AND OLD.proof_url != '' THEN
    points_to_subtract := 50;
  ELSE
    points_to_subtract := 25;
  END IF;

  PERFORM award_points(OLD.customer_id, -points_to_subtract, 'review_deleted', OLD.id::text, OLD.family_member_id);
  RETURN OLD;
END;
$$;

-- 6. RLS: allow reading family member activity rows publicly (for leaderboard)
DROP POLICY IF EXISTS "Public can view family member activity" ON user_activity;
CREATE POLICY "Public can view family member activity"
  ON user_activity
  FOR SELECT
  TO authenticated
  USING (family_member_id IS NOT NULL);
