/*
  # Add notifications to all approval/rejection functions

  ## Problem
  When an admin approves or rejects an ad, review, or business, the user
  who created it does not receive a notification. Notifications must go to
  the exact profile that created the item: if a family member created it,
  family_member_id is set; if the account owner created it, family_member_id
  is NULL.

  ## Changes
  1. `approve_classified_ad` - sends notification with points info to creator
  2. `reject_classified_ad` - sends notification to creator
  3. `approve_review` - sends notification with points info to reviewer
  4. `reject_review` - sends notification to reviewer
  5. `award_points_for_unclaimed_business_on_approval` (trigger) - sends
     notification with points info to the user who added the business

  ## Notification pattern
  - user_id = the account owner (always)
  - family_member_id = the family member who created the item (or NULL)
  - This matches how ad_favorited and other existing notifications work
*/

-- 1. approve_classified_ad with notification
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
    'Il tuo annuncio "' || ad_record.title || '" e'' stato approvato e pubblicato. Hai guadagnato ' || points_to_award || ' punti in classifica!',
    jsonb_build_object('ad_id', ad_id_param, 'ad_title', ad_record.title, 'points_awarded', points_to_award)
  );
END;
$$;

-- 2. reject_classified_ad with notification
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

-- 3. approve_review with notification
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
BEGIN
  SELECT * INTO review_record FROM reviews WHERE id = review_id_param;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Recensione non trovata';
  END IF;

  IF review_record.review_status != 'pending' THEN
    RAISE EXCEPTION 'La recensione e'' gia'' stata processata';
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

-- 4. reject_review with notification
CREATE OR REPLACE FUNCTION reject_review(
  review_id_param uuid,
  staff_id_param uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  review_record RECORD;
BEGIN
  SELECT * INTO review_record FROM reviews WHERE id = review_id_param;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Recensione non trovata';
  END IF;

  IF review_record.review_status != 'pending' THEN
    RAISE EXCEPTION 'La recensione e'' gia'' stata processata';
  END IF;

  UPDATE reviews
  SET review_status = 'rejected',
      approved_by = staff_id_param,
      approved_at = now(),
      points_awarded = 0,
      proof_image_url = NULL
  WHERE id = review_id_param;

  INSERT INTO activity_log (user_id, action, details)
  VALUES (
    staff_id_param,
    'review_rejected',
    jsonb_build_object(
      'review_id', review_id_param,
      'had_proof', (review_record.proof_image_url IS NOT NULL),
      'family_member_id', review_record.family_member_id
    )
  );

  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (
    review_record.customer_id,
    review_record.family_member_id,
    'review_rejected',
    'Recensione Rifiutata',
    'La tua recensione non e'' stata approvata. Verifica che rispetti le linee guida e riprova.',
    jsonb_build_object('review_id', review_id_param)
  );
END;
$$;

-- 5. Business approval trigger with notification
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
        INSERT INTO user_activity (user_id, total_points, businesses_added_count, last_activity_at, created_at, updated_at)
        VALUES (NEW.added_by, points_to_award, 1, now(), now(), now())
        ON CONFLICT (user_id, family_member_id)
        DO UPDATE SET
          total_points = user_activity.total_points + points_to_award,
          businesses_added_count = user_activity.businesses_added_count + 1,
          last_activity_at = now(),
          updated_at = now()
        WHERE user_activity.family_member_id IS NULL;
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
