/*
  # Update Notification System to Support Family Members

  1. Changes
    - Update notify_ad_favorited to check family_member_id in classified_ads
    - Update notify_job_seeker_favorited to check family_member_id in job_seekers
    - Update notify_favorite_created for family member support
    - Each user sees only their own notifications (not family members' notifications)

  2. Security
    - Notifications are sent to the main user account (user_id)
    - Each family member's actions create notifications for the main account
    - RLS policies ensure users only see their own notifications
*/

-- Update function to notify when classified ad is favorited
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
  -- Get ad details, owner and family member
  SELECT ca.title, ca.user_id, ca.family_member_id
  INTO v_ad_title, v_ad_owner_id, v_ad_family_member_id
  FROM classified_ads ca
  WHERE ca.id = NEW.ad_id;

  -- Get favoriter name
  SELECT COALESCE(p.full_name, p.email)
  INTO v_favoriter_name
  FROM profiles p
  WHERE p.id = NEW.user_id;

  -- Get family member name if exists
  IF v_ad_family_member_id IS NOT NULL THEN
    SELECT COALESCE(nickname, full_name)
    INTO v_family_member_name
    FROM customer_family_members
    WHERE id = v_ad_family_member_id;
  END IF;

  -- Create notification for ad owner (always sent to main user account)
  IF v_ad_owner_id IS NOT NULL AND v_ad_owner_id != NEW.user_id THEN
    INSERT INTO notifications (user_id, type, title, message, data)
    VALUES (
      v_ad_owner_id,
      'ad_favorited',
      'Annuncio aggiunto ai preferiti',
      format(
        'L''annuncio "%s"%s è stato aggiunto ai preferiti da %s',
        v_ad_title,
        CASE 
          WHEN v_family_member_name IS NOT NULL 
          THEN ' di ' || v_family_member_name 
          ELSE '' 
        END,
        v_favoriter_name
      ),
      jsonb_build_object(
        'ad_id', NEW.ad_id,
        'favorited_by', NEW.user_id,
        'family_member_id', v_ad_family_member_id,
        'url', '/classified-ads/' || NEW.ad_id
      )
    );
  END IF;

  RETURN NEW;
END;
$$;

-- Update function to notify when job seeker ad is favorited
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
  -- Get job seeker details, owner and family member
  SELECT js.title, js.user_id, js.family_member_id
  INTO v_job_title, v_job_owner_id, v_job_family_member_id
  FROM job_seekers js
  WHERE js.id = NEW.job_seeker_id;

  -- Get favoriter name
  SELECT COALESCE(p.full_name, p.email)
  INTO v_favoriter_name
  FROM profiles p
  WHERE p.id = NEW.user_id;

  -- Get family member name if exists
  IF v_job_family_member_id IS NOT NULL THEN
    SELECT COALESCE(nickname, full_name)
    INTO v_family_member_name
    FROM customer_family_members
    WHERE id = v_job_family_member_id;
  END IF;

  -- Create notification for job seeker owner (always sent to main user account)
  IF v_job_owner_id IS NOT NULL AND v_job_owner_id != NEW.user_id THEN
    INSERT INTO notifications (user_id, type, title, message, data)
    VALUES (
      v_job_owner_id,
      'job_favorited',
      'Annuncio lavoro nei preferiti',
      format(
        'L''annuncio "%s"%s è stato aggiunto ai preferiti da %s',
        v_job_title,
        CASE 
          WHEN v_family_member_name IS NOT NULL 
          THEN ' di ' || v_family_member_name 
          ELSE '' 
        END,
        v_favoriter_name
      ),
      jsonb_build_object(
        'job_seeker_id', NEW.job_seeker_id,
        'favorited_by', NEW.user_id,
        'family_member_id', v_job_family_member_id,
        'url', '/jobs'
      )
    );
  END IF;

  RETURN NEW;
END;
$$;

-- Update unified function for favorite notifications
CREATE OR REPLACE FUNCTION notify_favorite_created()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_business_name text;
  v_business_owner_id uuid;
  v_favoriter_name text;
  v_job_title text;
  v_job_owner_id uuid;
  v_job_family_member_id uuid;
  v_family_member_name text;
BEGIN
  -- Get favoriter name
  SELECT COALESCE(p.full_name, p.email)
  INTO v_favoriter_name
  FROM profiles p
  WHERE p.id = NEW.user_id;

  -- Check if it's a business favorite
  IF NEW.business_id IS NOT NULL THEN
    SELECT b.name, b.owner_id
    INTO v_business_name, v_business_owner_id
    FROM businesses b
    WHERE b.id = NEW.business_id;

    IF v_business_owner_id IS NOT NULL AND v_business_owner_id != NEW.user_id THEN
      INSERT INTO notifications (user_id, type, title, message, data)
      VALUES (
        v_business_owner_id,
        'business_favorited',
        'Attività aggiunta ai preferiti',
        format('La tua attività "%s" è stata aggiunta ai preferiti da %s', v_business_name, v_favoriter_name),
        jsonb_build_object(
          'business_id', NEW.business_id,
          'favorited_by', NEW.user_id,
          'url', '/business/' || NEW.business_id
        )
      );
    END IF;
  END IF;

  -- Check if it's a job seeker favorite
  IF NEW.job_seeker_id IS NOT NULL THEN
    SELECT js.title, js.user_id, js.family_member_id
    INTO v_job_title, v_job_owner_id, v_job_family_member_id
    FROM job_seekers js
    WHERE js.id = NEW.job_seeker_id;

    -- Get family member name if exists
    IF v_job_family_member_id IS NOT NULL THEN
      SELECT COALESCE(nickname, full_name)
      INTO v_family_member_name
      FROM customer_family_members
      WHERE id = v_job_family_member_id;
    END IF;

    IF v_job_owner_id IS NOT NULL AND v_job_owner_id != NEW.user_id THEN
      INSERT INTO notifications (user_id, type, title, message, data)
      VALUES (
        v_job_owner_id,
        'job_favorited',
        'Annuncio lavoro nei preferiti',
        format(
          'L''annuncio "%s"%s è stato aggiunto ai preferiti da %s',
          v_job_title,
          CASE 
            WHEN v_family_member_name IS NOT NULL 
            THEN ' di ' || v_family_member_name 
            ELSE '' 
          END,
          v_favoriter_name
        ),
        jsonb_build_object(
          'job_seeker_id', NEW.job_seeker_id,
          'favorited_by', NEW.user_id,
          'family_member_id', v_job_family_member_id,
          'url', '/jobs'
        )
      );
    END IF;
  END IF;

  RETURN NEW;
END;
$$;
