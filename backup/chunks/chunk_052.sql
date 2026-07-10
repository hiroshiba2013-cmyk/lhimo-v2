-- ============================================================
-- FILE: 20260421100920_add_family_member_id_to_activity_log.sql
-- ============================================================
/*
  # Add family_member_id to activity_log for proper filtering

  ## Problem
  Activity log entries for family members are stored with the main user's
  user_id. The family_member_id is only in the metadata JSON, making it
  impossible to filter activities per family member.

  ## Changes
  1. Add `family_member_id` column to `activity_log`
  2. Backfill from metadata->>'family_member_id' for existing entries
  3. Update `log_user_activity` function to accept family_member_id
  4. Update business approval trigger to store family_member_id
  5. Update business add trigger to store family_member_id
  6. Update ad creation log trigger to store family_member_id
  7. Update review triggers to store family_member_id
*/

-- Step 1: Add family_member_id column
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'activity_log' AND column_name = 'family_member_id'
  ) THEN
    ALTER TABLE activity_log ADD COLUMN family_member_id uuid REFERENCES customer_family_members(id) ON DELETE CASCADE;
  END IF;
END $$;

-- Step 2: Backfill from metadata
UPDATE activity_log
SET family_member_id = (metadata->>'family_member_id')::uuid
WHERE family_member_id IS NULL
  AND metadata->>'family_member_id' IS NOT NULL
  AND metadata->>'family_member_id' != 'null'
  AND metadata->>'family_member_id' != '';

-- Step 3: Create index for fast filtering
CREATE INDEX IF NOT EXISTS idx_activity_log_family_member_id
  ON activity_log (family_member_id) WHERE family_member_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_activity_log_user_family
  ON activity_log (user_id, family_member_id);

-- Step 4: Update log_user_activity to accept family_member_id
CREATE OR REPLACE FUNCTION log_user_activity(
  p_user_id uuid,
  p_activity_type text,
  p_title text,
  p_description text,
  p_points_earned integer,
  p_metadata jsonb,
  p_icon text,
  p_color text,
  p_family_member_id uuid DEFAULT NULL
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_activity_id uuid;
BEGIN
  INSERT INTO activity_log (
    user_id,
    family_member_id,
    activity_type,
    title,
    description,
    points_earned,
    metadata,
    icon,
    color
  )
  VALUES (
    p_user_id,
    p_family_member_id,
    p_activity_type,
    p_title,
    p_description,
    p_points_earned,
    p_metadata,
    p_icon,
    p_color
  )
  RETURNING id INTO v_activity_id;

  RETURN v_activity_id;
END;
$$;

-- Step 5: Update unclaimed business approval trigger to store family_member_id
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
        'Attività approvata',
        CASE 
          WHEN is_complete THEN 'La tua attività "' || NEW.name || '" è stata approvata (con dati completi)'
          ELSE 'La tua attività "' || NEW.name || '" è stata approvata'
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

      NEW.points_awarded := true;
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Step 6: Update unclaimed business add trigger to store family_member_id
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
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Step 7: Update ad creation log trigger to store family_member_id
CREATE OR REPLACE FUNCTION log_ad_creation()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM log_user_activity(
    NEW.user_id,
    'ad_created',
    'Annuncio inviato',
    'Hai inviato l''annuncio "' || NEW.title || '" per approvazione',
    0,
    jsonb_build_object('ad_id', NEW.id),
    'file-text',
    'text-blue-600',
    NEW.family_member_id
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Step 8: Update review submission trigger to store family_member_id
CREATE OR REPLACE FUNCTION log_review_submission()
RETURNS TRIGGER AS $$
DECLARE
  v_business_name text;
BEGIN
  SELECT name INTO v_business_name
  FROM business_locations
  WHERE business_id = NEW.business_id
  LIMIT 1;

  PERFORM log_user_activity(
    NEW.customer_id,
    'review_created',
    'Recensione inviata',
    'Hai recensito "' || COALESCE(v_business_name, 'un''attività') || '". In attesa di approvazione.',
    0,
    jsonb_build_object('review_id', NEW.id, 'business_id', NEW.business_id),
    'star',
    'text-yellow-600',
    NEW.family_member_id
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Step 9: Update review approval trigger to store family_member_id
CREATE OR REPLACE FUNCTION log_review_approval()
RETURNS TRIGGER AS $$
DECLARE
  v_business_name text;
  v_points integer;
BEGIN
  IF NEW.review_status = 'approved' AND OLD.review_status != 'approved' THEN
    SELECT name INTO v_business_name
    FROM business_locations
    WHERE business_id = NEW.business_id
    LIMIT 1;

    v_points := CASE 
      WHEN NEW.proof_image_url IS NOT NULL AND NEW.proof_image_url != '' THEN 50
      ELSE 25
    END;

    PERFORM log_user_activity(
      NEW.customer_id,
      'review_approved',
      'Recensione approvata!',
      'La tua recensione per "' || COALESCE(v_business_name, 'un''attività') || '" è stata approvata',
      v_points,
      jsonb_build_object(
        'review_id', NEW.id,
        'business_id', NEW.business_id,
        'has_proof', NEW.proof_image_url IS NOT NULL
      ),
      'star',
      'text-green-600',
      NEW.family_member_id
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================================
-- FILE: 20260421140413_fix_award_points_and_approve_ad_null_family_member.sql
-- ============================================================
/*
  # Fix award_points and approve_classified_ad for NULL family_member_id

  ## Problem
  PostgreSQL treats NULL as unknown in unique constraints. The constraint
  `UNIQUE (user_id, family_member_id)` does not match ON CONFLICT when
  family_member_id is NULL. A separate partial unique index
  `user_activity_user_id_null_family_unique` exists for the NULL case,
  but ON CONFLICT (user_id, family_member_id) cannot target it.

  This causes HTTP 409 errors when approving classified ads (or awarding
  points) for users whose family_member_id is NULL.

  ## Fix
  1. Rewrite `award_points` to use explicit UPDATE-or-INSERT logic instead
     of ON CONFLICT, handling both NULL and non-NULL family_member_id correctly.
  2. Rewrite `approve_classified_ad` similarly for its direct user_activity insert.
*/

-- 1. Fix award_points function
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
  v_exists boolean;
BEGIN
  IF p_family_member_id IS NOT NULL THEN
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = p_user_id AND family_member_id = p_family_member_id
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        total_points = total_points + p_points,
        reviews_count = CASE WHEN p_activity_type = 'review' THEN reviews_count + 1 ELSE reviews_count END,
        last_activity_at = now(),
        updated_at = now()
      WHERE user_id = p_user_id AND family_member_id = p_family_member_id;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, total_points, reviews_count, last_activity_at, created_at, updated_at)
      VALUES (
        p_user_id,
        p_family_member_id,
        p_points,
        CASE WHEN p_activity_type = 'review' THEN 1 ELSE 0 END,
        now(), now(), now()
      );
    END IF;

    SELECT total_points INTO v_new_total
    FROM user_activity
    WHERE user_id = p_user_id AND family_member_id = p_family_member_id;
  ELSE
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = p_user_id AND family_member_id IS NULL
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        total_points = total_points + p_points,
        reviews_count = CASE WHEN p_activity_type = 'review' THEN reviews_count + 1 ELSE reviews_count END,
        last_activity_at = now(),
        updated_at = now()
      WHERE user_id = p_user_id AND family_member_id IS NULL;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, total_points, reviews_count, last_activity_at, created_at, updated_at)
      VALUES (
        p_user_id,
        NULL,
        p_points,
        CASE WHEN p_activity_type = 'review' THEN 1 ELSE 0 END,
        now(), now(), now()
      );
    END IF;

    SELECT total_points INTO v_new_total
    FROM user_activity
    WHERE user_id = p_user_id AND family_member_id IS NULL;
  END IF;

  RETURN v_new_total;
END;
$$;

-- 2. Fix approve_classified_ad function
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

  -- Award points
  PERFORM award_points(
    ad_record.user_id,
    points_to_award,
    'classified_ad',
    'Annuncio approvato',
    ad_record.family_member_id
  );

  -- Increment ads_posted_count using explicit UPDATE-or-INSERT
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

  -- Log the activity
  INSERT INTO activity_log (user_id, family_member_id, action, details)
  VALUES (
    staff_id_param,
    NULL,
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

-- 3. Fix other trigger functions that use ON CONFLICT with potential NULL family_member_id

CREATE OR REPLACE FUNCTION increment_ads_posted_count()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_exists boolean;
BEGIN
  IF NEW.family_member_id IS NOT NULL THEN
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = NEW.user_id AND family_member_id = NEW.family_member_id
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        ads_posted_count = ads_posted_count + 1,
        last_activity_at = now(),
        updated_at = now()
      WHERE user_id = NEW.user_id AND family_member_id = NEW.family_member_id;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, ads_posted_count, last_activity_at, created_at, updated_at)
      VALUES (NEW.user_id, NEW.family_member_id, 1, now(), now(), now());
    END IF;
  ELSE
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = NEW.user_id AND family_member_id IS NULL
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        ads_posted_count = ads_posted_count + 1,
        last_activity_at = now(),
        updated_at = now()
      WHERE user_id = NEW.user_id AND family_member_id IS NULL;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, ads_posted_count, last_activity_at, created_at, updated_at)
      VALUES (NEW.user_id, NULL, 1, now(), now(), now());
    END IF;
  END IF;

  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION increment_user_added_business_count()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_exists boolean;
BEGIN
  IF NEW.added_by_family_member_id IS NOT NULL THEN
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = NEW.added_by AND family_member_id = NEW.added_by_family_member_id
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        businesses_added_count = businesses_added_count + 1,
        last_activity_at = now(),
        updated_at = now()
      WHERE user_id = NEW.added_by AND family_member_id = NEW.added_by_family_member_id;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, businesses_added_count, last_activity_at, created_at, updated_at)
      VALUES (NEW.added_by, NEW.added_by_family_member_id, 1, now(), now(), now());
    END IF;
  ELSE
    SELECT EXISTS(
      SELECT 1 FROM user_activity
      WHERE user_id = NEW.added_by AND family_member_id IS NULL
    ) INTO v_exists;

    IF v_exists THEN
      UPDATE user_activity SET
        businesses_added_count = businesses_added_count + 1,
        last_activity_at = now(),
        updated_at = now()
      WHERE user_id = NEW.added_by AND family_member_id IS NULL;
    ELSE
      INSERT INTO user_activity (user_id, family_member_id, businesses_added_count, last_activity_at, created_at, updated_at)
      VALUES (NEW.added_by, NULL, 1, now(), now(), now());
    END IF;
  END IF;

  RETURN NEW;
END;
$$;


-- ============================================================
-- FILE: 20260421140710_fix_approve_ad_activity_log_columns.sql
-- ============================================================
/*
  # Fix approve_classified_ad activity_log insert

  ## Problem
  The approve_classified_ad function inserts into activity_log using columns
  `action` and `details`, but the table has `activity_type`, `title`,
  `description`, and `metadata`. This causes a 400 error.

  ## Fix
  Update the INSERT to use the correct column names.
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

  -- Log the activity with correct column names
  INSERT INTO activity_log (user_id, family_member_id, activity_type, title, description, points_earned, metadata, icon, color)
  VALUES (
    ad_record.user_id,
    ad_record.family_member_id,
    'classified_ad_approved',
    'Annuncio Approvato',
    'Il tuo annuncio "' || ad_record.title || '" e'' stato approvato',
    points_to_award,
    jsonb_build_object(
      'ad_id', ad_id_param,
      'ad_title', ad_record.title,
      'approved_by', staff_id_param
    ),
    'check-circle',
    'green'
  );
END;
$$;


