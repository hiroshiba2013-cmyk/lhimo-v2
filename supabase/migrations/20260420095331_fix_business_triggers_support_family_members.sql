/*
  # Fix business-addition triggers to support family members

  ## Summary
  I trigger che assegnano punti quando si aggiunge un'attività ignoravano
  added_by_family_member_id. Ora i punti vengono assegnati al membro della 
  famiglia se presente, altrimenti all'utente principale.

  ## Changes
  - award_points_for_unclaimed_business: upsert corretto per family_member_id
  - increment_unclaimed_business_count: usa (user_id, family_member_id)
  - subtract_points_for_deleted_unclaimed_business: passa family_member_id
  - decrement_unclaimed_business_count: passa family_member_id
*/

-- 1. Fix award_points_for_unclaimed_business
CREATE OR REPLACE FUNCTION award_points_for_unclaimed_business()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
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
    user_id,
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
    'business_added',
    'Attività aggiunta',
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
$$;

-- 2. Fix increment_unclaimed_business_count
CREATE OR REPLACE FUNCTION increment_unclaimed_business_count()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
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
    INSERT INTO user_activity (user_id, businesses_added_count, last_activity_at, created_at, updated_at)
    VALUES (NEW.added_by, 1, now(), now(), now())
    ON CONFLICT (user_id, family_member_id)
    DO UPDATE SET
      businesses_added_count = user_activity.businesses_added_count + 1,
      last_activity_at = now(),
      updated_at = now()
    WHERE user_activity.family_member_id IS NULL;
  END IF;

  RETURN NEW;
END;
$$;

-- 3. Fix subtract_points_for_deleted_unclaimed_business
CREATE OR REPLACE FUNCTION subtract_points_for_deleted_unclaimed_business()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  points_to_subtract INTEGER;
  is_complete BOOLEAN;
  v_family_member_id uuid;
BEGIN
  is_complete := (
    (OLD.email IS NOT NULL AND OLD.email != '') OR 
    (OLD.phone IS NOT NULL AND OLD.phone != '') OR 
    (OLD.website IS NOT NULL AND OLD.website != '')
  );

  IF is_complete THEN
    points_to_subtract := 25;
  ELSE
    points_to_subtract := 10;
  END IF;

  v_family_member_id := OLD.added_by_family_member_id;

  IF v_family_member_id IS NOT NULL THEN
    UPDATE user_activity
    SET
      total_points = GREATEST(0, total_points - points_to_subtract),
      businesses_added_count = GREATEST(0, businesses_added_count - 1),
      updated_at = now()
    WHERE user_id = OLD.added_by AND family_member_id = v_family_member_id;
  ELSE
    UPDATE user_activity
    SET
      total_points = GREATEST(0, total_points - points_to_subtract),
      businesses_added_count = GREATEST(0, businesses_added_count - 1),
      updated_at = now()
    WHERE user_id = OLD.added_by AND family_member_id IS NULL;
  END IF;

  RETURN OLD;
END;
$$;

-- 4. Fix decrement_unclaimed_business_count
CREATE OR REPLACE FUNCTION decrement_unclaimed_business_count()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_family_member_id uuid;
BEGIN
  v_family_member_id := OLD.added_by_family_member_id;

  IF v_family_member_id IS NOT NULL THEN
    UPDATE user_activity
    SET
      businesses_added_count = GREATEST(0, businesses_added_count - 1),
      last_activity_at = now(),
      updated_at = now()
    WHERE user_id = OLD.added_by AND family_member_id = v_family_member_id;
  ELSE
    UPDATE user_activity
    SET
      businesses_added_count = GREATEST(0, businesses_added_count - 1),
      last_activity_at = now(),
      updated_at = now()
    WHERE user_id = OLD.added_by AND family_member_id IS NULL;
  END IF;

  RETURN OLD;
END;
$$;
