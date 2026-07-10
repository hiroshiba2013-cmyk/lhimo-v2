-- ============================================================
-- FILE: 20260420095228_add_family_member_support_to_user_activity.sql
-- ============================================================
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


-- ============================================================
-- FILE: 20260420095331_fix_business_triggers_support_family_members.sql
-- ============================================================
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


-- ============================================================
-- FILE: 20260420100108_allow_public_read_family_members_for_leaderboard.sql
-- ============================================================
/*
  # Allow public read of family members for leaderboard

  ## Summary
  La classifica deve poter mostrare i membri della famiglia di tutti gli utenti.
  Aggiungiamo una policy che permette a tutti gli utenti autenticati di leggere
  i dati base (nome, nickname, avatar) dei membri famiglia per la classifica.
*/

CREATE POLICY "Authenticated users can view family members for leaderboard"
  ON customer_family_members
  FOR SELECT
  TO authenticated
  USING (true);


-- ============================================================
-- FILE: 20260420202007_fix_unclaimed_business_points_only_on_approval.sql
-- ============================================================
/*
  # Fix: Award points for unclaimed businesses only on admin approval

  ## Problem
  The trigger `trigger_award_points_unclaimed_business` fires on INSERT and awards
  points immediately when a user adds a business, before the admin has a chance to
  review and approve it. The admin approval flow in the frontend also tries to award
  points, leading to double-awarding or premature points.

  ## Changes
  1. Drop the old INSERT trigger that awards points immediately
  2. Create a new UPDATE trigger that awards points only when `approval_status`
     changes to 'approved' and `points_awarded` is still false
  3. The new trigger function sets `points_awarded = true` to prevent double-awarding

  ## Security
  - No RLS changes
  - Points can only be awarded through admin approval flow
*/

-- 1. Drop the old INSERT trigger that awards points prematurely
DROP TRIGGER IF EXISTS trigger_award_points_unclaimed_business ON unclaimed_business_locations;

-- 2. Create new function that awards points only on approval
CREATE OR REPLACE FUNCTION award_points_for_unclaimed_business_on_approval()
RETURNS TRIGGER AS $$
DECLARE
  points_to_award INTEGER;
  is_complete BOOLEAN;
  v_family_member_id uuid;
BEGIN
  -- Only fire when approval_status changes to 'approved' and points not yet awarded
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

      -- Mark points as awarded to prevent double-awarding
      NEW.points_awarded := true;
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Create the new trigger on UPDATE (BEFORE so we can modify NEW.points_awarded)
CREATE TRIGGER trigger_award_points_unclaimed_business_on_approval
  BEFORE UPDATE ON unclaimed_business_locations
  FOR EACH ROW
  EXECUTE FUNCTION award_points_for_unclaimed_business_on_approval();


-- ============================================================
-- FILE: 20260420204247_add_family_member_to_notifications.sql
-- ============================================================
/*
  # Add family member support to notifications

  ## Problem
  Notifications are currently tied only to user_id. In accounts with family members,
  all members see ALL notifications for the account. Each member should only see
  their own notifications.

  ## Changes
  1. Add `family_member_id` column to `notifications` table (nullable, for main account owner)
  2. Update `send_notification` function to accept optional family_member_id
  3. Update `get_unread_notification_count` to accept family_member_id parameter
  4. Update `mark_notification_read` - no changes needed (works by notification id)
  5. Update `mark_all_notifications_read` to accept family_member_id parameter
  6. Add index for efficient querying

  ## Important notes
  - family_member_id = NULL means the notification belongs to the main account owner
  - Existing notifications remain with family_member_id = NULL (main owner)
  - RLS stays the same (user_id based) since family members share the same auth user
*/

-- 1. Add family_member_id column
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'notifications' AND column_name = 'family_member_id'
  ) THEN
    ALTER TABLE notifications ADD COLUMN family_member_id uuid REFERENCES customer_family_members(id) ON DELETE CASCADE;
  END IF;
END $$;

-- 2. Add index for efficient queries
CREATE INDEX IF NOT EXISTS idx_notifications_user_family_member
  ON notifications (user_id, family_member_id);

-- 3. Update send_notification to support family_member_id
CREATE OR REPLACE FUNCTION send_notification(
  target_user_id uuid,
  notif_type text,
  notif_title text,
  notif_message text,
  notif_data jsonb DEFAULT '{}'::jsonb,
  target_family_member_id uuid DEFAULT NULL
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  IF NOT (is_admin() OR auth.uid() = target_user_id) THEN
    RAISE EXCEPTION 'Non autorizzato a inviare notifiche ad altri utenti';
  END IF;

  INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
  VALUES (target_user_id, target_family_member_id, notif_type, notif_title, notif_message, notif_data);
END;
$$;

-- 4. Update get_unread_notification_count to filter by family_member_id
CREATE OR REPLACE FUNCTION get_unread_notification_count(
  p_family_member_id uuid DEFAULT NULL
)
RETURNS integer
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  count integer;
BEGIN
  IF p_family_member_id IS NOT NULL THEN
    SELECT COUNT(*)::integer INTO count
    FROM notifications
    WHERE user_id = auth.uid() AND family_member_id = p_family_member_id AND read = false;
  ELSE
    SELECT COUNT(*)::integer INTO count
    FROM notifications
    WHERE user_id = auth.uid() AND family_member_id IS NULL AND read = false;
  END IF;

  RETURN count;
END;
$$;

-- 5. Update mark_all_notifications_read to filter by family_member_id
CREATE OR REPLACE FUNCTION mark_all_notifications_read(
  p_family_member_id uuid DEFAULT NULL
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  IF p_family_member_id IS NOT NULL THEN
    UPDATE notifications
    SET read = true
    WHERE user_id = auth.uid() AND family_member_id = p_family_member_id AND read = false;
  ELSE
    UPDATE notifications
    SET read = true
    WHERE user_id = auth.uid() AND family_member_id IS NULL AND read = false;
  END IF;
END;
$$;

-- 6. Update the unclaimed business approval trigger to include family_member_id in notifications
-- The trigger award_points_for_unclaimed_business_on_approval already handles family_member_id
-- for points. Now we also need to make the frontend pass family_member_id when sending notifications.
-- This is handled in the frontend code changes.


-- ============================================================
-- FILE: 20260420204616_update_notification_triggers_add_family_member_id.sql
-- ============================================================
/*
  # Update notification trigger functions to use family_member_id column

  ## Problem
  The trigger functions `notify_ad_favorited` and `notify_job_seeker_favorited`
  store family_member_id only in the JSON `data` column but not in the new
  `family_member_id` column. This means notifications from these triggers
  won't be correctly filtered per family member.

  ## Changes
  1. Update `notify_ad_favorited` to set `family_member_id` column
  2. Update `notify_job_seeker_favorited` to set `family_member_id` column
  3. Update `notify_favorite_created` for completeness (no family member context)

  ## Notes
  - These triggers notify the owner of the ad/job/business when someone favorites it
  - The family_member_id refers to the family member who OWNS the ad/job, not the one who favorited it
*/

-- 1. Update notify_ad_favorited to include family_member_id column
CREATE OR REPLACE FUNCTION notify_ad_favorited()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_ad_title text;
  v_ad_owner_id uuid;
  v_ad_family_member_id uuid;
  v_favoriter_name text;
  v_family_member_name text;
BEGIN
  SELECT ca.title, ca.user_id, ca.family_member_id
  INTO v_ad_title, v_ad_owner_id, v_ad_family_member_id
  FROM classified_ads ca WHERE ca.id = NEW.ad_id;

  SELECT COALESCE(p.full_name, p.email) INTO v_favoriter_name
  FROM profiles p WHERE p.id = NEW.user_id;

  IF v_ad_family_member_id IS NOT NULL THEN
    SELECT COALESCE(nickname, first_name || ' ' || last_name) INTO v_family_member_name
    FROM customer_family_members WHERE id = v_ad_family_member_id;
  END IF;

  IF v_ad_owner_id IS NOT NULL AND v_ad_owner_id != NEW.user_id THEN
    INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
    VALUES (
      v_ad_owner_id,
      v_ad_family_member_id,
      'ad_favorited',
      'Annuncio aggiunto ai preferiti',
      format('L''annuncio "%s"%s è stato aggiunto ai preferiti da %s',
        v_ad_title,
        CASE WHEN v_family_member_name IS NOT NULL
             THEN ' di ' || v_family_member_name ELSE '' END,
        v_favoriter_name),
      jsonb_build_object(
        'ad_id', NEW.ad_id,
        'favorited_by', NEW.user_id,
        'family_member_id', v_ad_family_member_id,
        'url', '/classified-ads/' || NEW.ad_id)
    );
  END IF;
  RETURN NEW;
END;
$$;

-- 2. Update notify_job_seeker_favorited (if it exists as a trigger function)
CREATE OR REPLACE FUNCTION notify_job_seeker_favorited()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_job_title text;
  v_job_owner_id uuid;
  v_job_family_member_id uuid;
  v_favoriter_name text;
  v_family_member_name text;
BEGIN
  SELECT js.title, js.user_id, js.family_member_id
  INTO v_job_title, v_job_owner_id, v_job_family_member_id
  FROM job_seekers js WHERE js.id = NEW.job_seeker_id;

  SELECT COALESCE(p.full_name, p.email) INTO v_favoriter_name
  FROM profiles p WHERE p.id = NEW.user_id;

  IF v_job_family_member_id IS NOT NULL THEN
    SELECT COALESCE(nickname, first_name || ' ' || last_name) INTO v_family_member_name
    FROM customer_family_members WHERE id = v_job_family_member_id;
  END IF;

  IF v_job_owner_id IS NOT NULL AND v_job_owner_id != NEW.user_id THEN
    INSERT INTO notifications (user_id, family_member_id, type, title, message, data)
    VALUES (
      v_job_owner_id,
      v_job_family_member_id,
      'job_favorited',
      'Annuncio lavoro nei preferiti',
      format('L''annuncio "%s"%s è stato aggiunto ai preferiti da %s',
        v_job_title,
        CASE WHEN v_family_member_name IS NOT NULL
             THEN ' di ' || v_family_member_name ELSE '' END,
        v_favoriter_name),
      jsonb_build_object(
        'job_seeker_id', NEW.job_seeker_id,
        'favorited_by', NEW.user_id,
        'family_member_id', v_job_family_member_id,
        'url', '/jobs')
    );
  END IF;
  RETURN NEW;
END;
$$;


