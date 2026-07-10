/*
  # Add notifications when classified ads are approved or rejected

  1. Changes
    - `approve_classified_ad`: adds INSERT into notifications table
      so the ad owner gets notified their ad was approved
    - `reject_classified_ad`: fixes broken activity_log INSERT (was using
      wrong column names) and adds INSERT into notifications table
      so the ad owner gets notified their ad was rejected

  2. Notification details
    - Approval: type='classified_ad_approved', green positive message
    - Rejection: type='classified_ad_rejected', informative message
    - Both include family_member_id if the ad was posted by a family member
*/

-- Update approve function to include notification
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
  v_exists boolean;
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

  IF ad_record.family_member_id IS NOT NULL THEN
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = ad_record.user_id AND family_member_id = ad_record.family_member_id
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        ads_posted_count = ads_posted_count + 1,
        last_activity_at = now(),
        updated_at = now()
      WHERE user_id = ad_record.user_id AND family_member_id = ad_record.family_member_id;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, ads_posted_count, last_activity_at, created_at, updated_at)
      VALUES (ad_record.user_id, ad_record.family_member_id, 1, now(), now(), now());
    END IF;
  ELSE
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = ad_record.user_id AND family_member_id IS NULL
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        ads_posted_count = ads_posted_count + 1,
        last_activity_at = now(),
        updated_at = now()
      WHERE user_id = ad_record.user_id AND family_member_id IS NULL;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, ads_posted_count, last_activity_at, created_at, updated_at)
      VALUES (ad_record.user_id, NULL, 1, now(), now(), now());
    END IF;
  END IF;

  INSERT INTO activity_log (user_id, family_member_id, activity_type, title, description, points_earned, metadata, icon, color)
  VALUES (
    ad_record.user_id,
    ad_record.family_member_id,
    'classified_ad_approved',
    'Annuncio Approvato',
    'Il tuo annuncio "' || ad_record.title || '" e'' stato approvato',
    points_to_award,
    jsonb_build_object('ad_id', ad_id_param, 'ad_title', ad_record.title, 'approved_by', staff_id_param),
    'check-circle',
    'green'
  );

  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    ad_record.user_id,
    ad_record.family_member_id,
    'classified_ad_approved',
    'Annuncio Approvato',
    'Il tuo annuncio "' || ad_record.title || '" e'' stato approvato e pubblicato. Hai guadagnato ' || points_to_award || ' punti!',
    jsonb_build_object('ad_id', ad_id_param, 'ad_title', ad_record.title)
  );
END;
$$;

-- Update reject function to fix activity_log columns and add notification
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

  INSERT INTO activity_log (user_id, family_member_id, activity_type, title, description, points_earned, metadata, icon, color)
  VALUES (
    ad_record.user_id,
    ad_record.family_member_id,
    'classified_ad_rejected',
    'Annuncio Rifiutato',
    'Il tuo annuncio "' || ad_record.title || '" e'' stato rifiutato',
    0,
    jsonb_build_object('ad_id', ad_id_param, 'ad_title', ad_record.title, 'rejected_by', staff_id_param),
    'x-circle',
    'red'
  );

  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    ad_record.user_id,
    ad_record.family_member_id,
    'classified_ad_rejected',
    'Annuncio Rifiutato',
    'Il tuo annuncio "' || ad_record.title || '" non e'' stato approvato. Verifica che rispetti le linee guida e riprova.',
    jsonb_build_object('ad_id', ad_id_param, 'ad_title', ad_record.title)
  );
END;
$$;
