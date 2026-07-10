/*
  # Fix ads posted count to only increment on approval

  ## Changes
  1. Remove the INSERT trigger that increments ads_posted_count immediately
  2. The approve_classified_ad function now handles counting via award_points
  3. Update approve function to also increment ads_posted_count

  ## Notes
  - ads_posted_count should reflect only approved ads
  - Points are already handled by the approve function
*/

-- Remove the old INSERT trigger
DROP TRIGGER IF EXISTS trigger_increment_ads_posted_count ON classified_ads;

-- Update approve function to also increment ads_posted_count
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

  -- Award points
  PERFORM award_points(
    ad_record.user_id,
    points_to_award,
    'classified_ad',
    'Annuncio approvato',
    ad_record.family_member_id
  );

  -- Increment ads_posted_count
  INSERT INTO user_activity (user_id, family_member_id, ads_posted_count, last_activity_at)
  VALUES (ad_record.user_id, ad_record.family_member_id, 1, now())
  ON CONFLICT (user_id, family_member_id)
  DO UPDATE SET
    ads_posted_count = user_activity.ads_posted_count + 1,
    last_activity_at = now(),
    updated_at = now();

  -- Log the activity
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
