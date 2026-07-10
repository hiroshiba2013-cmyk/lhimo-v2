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
