/*
  # Fix user_activity upsert when family_member_id is NULL

  1. Problem
    - The increment_unclaimed_business_count trigger uses ON CONFLICT (user_id, family_member_id)
    - When family_member_id is NULL, NULL != NULL in SQL so the conflict clause never matches
    - But a partial unique index (user_activity_user_id_null_family_unique) blocks the duplicate insert
    - This causes a unique constraint violation error when adding businesses

  2. Fix
    - Update the trigger function to use a conditional approach:
      - When family_member_id is NULL, use ON CONFLICT on the partial index
      - When family_member_id is NOT NULL, use ON CONFLICT on the composite index
    - Apply the same fix to all similar trigger functions that upsert into user_activity
*/

CREATE OR REPLACE FUNCTION increment_unclaimed_business_count()
RETURNS TRIGGER AS $$
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
    INSERT INTO user_activity (user_id, family_member_id, businesses_added_count, last_activity_at, created_at, updated_at)
    VALUES (NEW.added_by, NULL, 1, now(), now(), now())
    ON CONFLICT (user_id) WHERE family_member_id IS NULL
    DO UPDATE SET
      businesses_added_count = user_activity.businesses_added_count + 1,
      last_activity_at = now(),
      updated_at = now();
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION decrement_unclaimed_business_count()
RETURNS TRIGGER AS $$
DECLARE
  v_family_member_id uuid;
BEGIN
  v_family_member_id := OLD.added_by_family_member_id;

  IF v_family_member_id IS NOT NULL THEN
    UPDATE user_activity
    SET businesses_added_count = GREATEST(0, businesses_added_count - 1),
        last_activity_at = now(),
        updated_at = now()
    WHERE user_id = OLD.added_by AND family_member_id = v_family_member_id;
  ELSE
    UPDATE user_activity
    SET businesses_added_count = GREATEST(0, businesses_added_count - 1),
        last_activity_at = now(),
        updated_at = now()
    WHERE user_id = OLD.added_by AND family_member_id IS NULL;
  END IF;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
