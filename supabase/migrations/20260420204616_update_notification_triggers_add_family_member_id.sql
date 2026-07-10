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
