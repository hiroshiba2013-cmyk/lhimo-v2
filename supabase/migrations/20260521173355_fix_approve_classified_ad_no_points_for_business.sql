/*
  # Fix approve_classified_ad: no points for business users

  Business users do not participate in the leaderboard and must not receive
  points when their classified ad is approved.

  Changes:
  - `approve_classified_ad`: check the user's user_type; if 'business', skip
    award_points, skip user_activity update, and send a notification without
    the points message.
*/

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
  v_user_type text;
BEGIN
  SELECT * INTO ad_record FROM classified_ads WHERE id = ad_id_param;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Annuncio non trovato';
  END IF;

  IF ad_record.approval_status != 'pending' THEN
    RAISE EXCEPTION 'L''annuncio e'' gia'' stato processato';
  END IF;

  -- Check if the owner is a business user (no points for business accounts)
  SELECT user_type INTO v_user_type
  FROM profiles
  WHERE id = ad_record.user_id;

  UPDATE classified_ads
  SET approval_status = 'approved',
      status = 'active',
      approved_by = staff_id_param,
      approved_at = now(),
      points_awarded = CASE WHEN v_user_type = 'business' THEN 0 ELSE points_to_award END
  WHERE id = ad_id_param;

  -- Only award points and update leaderboard for non-business users
  IF v_user_type != 'business' THEN
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
  END IF;

  INSERT INTO activity_log (user_id, family_member_id, activity_type, title, description, points_earned, metadata, icon, color)
  VALUES (
    ad_record.user_id,
    ad_record.family_member_id,
    'classified_ad_approved',
    'Annuncio Approvato',
    'Il tuo annuncio "' || ad_record.title || '" e'' stato approvato',
    CASE WHEN v_user_type = 'business' THEN 0 ELSE points_to_award END,
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
    CASE
      WHEN v_user_type = 'business'
        THEN 'Il tuo annuncio "' || ad_record.title || '" e'' stato approvato e pubblicato.'
      ELSE 'Il tuo annuncio "' || ad_record.title || '" e'' stato approvato e pubblicato. Hai guadagnato ' || points_to_award || ' punti in classifica!'
    END,
    jsonb_build_object('ad_id', ad_id_param, 'ad_title', ad_record.title, 'points_awarded', CASE WHEN v_user_type = 'business' THEN 0 ELSE points_to_award END)
  );
END;
$$;
