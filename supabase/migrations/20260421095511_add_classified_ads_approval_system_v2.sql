/*
  # Add approval system for classified ads

  Similar to the review approval system, classified ads now require admin
  approval before being visible and before points are awarded.

  ## Changes
  1. Add 'pending' to the status check constraint
  2. Add approval columns to `classified_ads`:
     - `approval_status` (text): 'pending', 'approved', 'rejected'
     - `approved_by` (uuid): admin who approved
     - `approved_at` (timestamptz): when approved
     - `points_awarded` (integer): points given after approval
  3. Set all existing active ads to 'approved' (grandfathered in)
  4. New ads default to 'pending' status
  5. Remove the automatic points trigger on INSERT
  6. Create `approve_classified_ad` and `reject_classified_ad` functions
  7. Update RLS: only approved+active ads visible publicly
  8. Fix Stefmanc's points to reflect actual approved activities
*/

-- Step 1: Update status check to include 'pending'
ALTER TABLE classified_ads DROP CONSTRAINT IF EXISTS classified_ads_status_check;
ALTER TABLE classified_ads ADD CONSTRAINT classified_ads_status_check
  CHECK (status IN ('pending', 'active', 'sold', 'expired', 'deleted'));

-- Step 2: Add approval columns
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'classified_ads' AND column_name = 'approval_status'
  ) THEN
    ALTER TABLE classified_ads ADD COLUMN approval_status text DEFAULT 'pending'
      CHECK (approval_status IN ('pending', 'approved', 'rejected'));
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'classified_ads' AND column_name = 'approved_by'
  ) THEN
    ALTER TABLE classified_ads ADD COLUMN approved_by uuid REFERENCES profiles(id);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'classified_ads' AND column_name = 'approved_at'
  ) THEN
    ALTER TABLE classified_ads ADD COLUMN approved_at timestamptz;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'classified_ads' AND column_name = 'points_awarded'
  ) THEN
    ALTER TABLE classified_ads ADD COLUMN points_awarded integer DEFAULT 0;
  END IF;
END $$;

-- Step 3: Grandfather existing active ads as approved
UPDATE classified_ads
SET approval_status = 'approved', approved_at = created_at
WHERE status = 'active' AND approval_status = 'pending';

-- Step 4: Remove the automatic points trigger on INSERT
DROP TRIGGER IF EXISTS trigger_award_points_classified_ad ON classified_ads;

-- Step 5: New ads default to 'pending' status
ALTER TABLE classified_ads ALTER COLUMN status SET DEFAULT 'pending';

-- Step 6: Create approve_classified_ad function
CREATE OR REPLACE FUNCTION approve_classified_ad(
  ad_id_param uuid,
  staff_id_param uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  ad_record RECORD;
  points_to_award integer := 5;
BEGIN
  SELECT * INTO ad_record FROM classified_ads WHERE id = ad_id_param;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Annuncio non trovato';
  END IF;

  IF ad_record.approval_status != 'pending' THEN
    RAISE EXCEPTION 'L''annuncio e'' gia'' stato processato';
  END IF;

  UPDATE classified_ads
  SET approval_status = 'approved',
      status = 'active',
      approved_by = staff_id_param,
      approved_at = now(),
      points_awarded = points_to_award
  WHERE id = ad_id_param;

  PERFORM award_points(
    ad_record.user_id,
    points_to_award,
    'classified_ad',
    'Annuncio approvato',
    ad_record.family_member_id
  );

  INSERT INTO activity_log (user_id, action, details)
  VALUES (
    staff_id_param,
    'classified_ad_approved',
    jsonb_build_object(
      'ad_id', ad_id_param,
      'ad_title', ad_record.title,
      'points_awarded', points_to_award,
      'family_member_id', ad_record.family_member_id
    )
  );
END;
$$;

-- Step 7: Create reject_classified_ad function
CREATE OR REPLACE FUNCTION reject_classified_ad(
  ad_id_param uuid,
  staff_id_param uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  ad_record RECORD;
BEGIN
  SELECT * INTO ad_record FROM classified_ads WHERE id = ad_id_param;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Annuncio non trovato';
  END IF;

  IF ad_record.approval_status != 'pending' THEN
    RAISE EXCEPTION 'L''annuncio e'' gia'' stato processato';
  END IF;

  UPDATE classified_ads
  SET approval_status = 'rejected',
      approved_by = staff_id_param,
      approved_at = now(),
      points_awarded = 0
  WHERE id = ad_id_param;

  INSERT INTO activity_log (user_id, action, details)
  VALUES (
    staff_id_param,
    'classified_ad_rejected',
    jsonb_build_object(
      'ad_id', ad_id_param,
      'ad_title', ad_record.title,
      'family_member_id', ad_record.family_member_id
    )
  );
END;
$$;

-- Step 8: Update RLS - public can only see approved+active ads
DROP POLICY IF EXISTS "Anyone can view active ads" ON classified_ads;
DROP POLICY IF EXISTS "Users can view active classified ads" ON classified_ads;

CREATE POLICY "Anyone can view approved active ads"
  ON classified_ads FOR SELECT
  USING (status = 'active' AND approval_status = 'approved');

-- Step 9: Set Stefmanc's unapproved ad to pending
UPDATE classified_ads
SET status = 'pending', approval_status = 'pending'
WHERE id = '11e72704-13df-4551-ace9-f9f40a6e159d';

-- Step 10: Fix Stefmanc's main user points
-- Actual approved activities: 1 business approved = 25 pts, 0 ads approved = 0 pts
-- Total should be 25, not 30
UPDATE user_activity
SET total_points = 25,
    ads_posted_count = 0,
    updated_at = now()
WHERE user_id = '4ed5c590-7e6c-42f1-925b-2161dc7ad2be'
  AND family_member_id IS NULL;
