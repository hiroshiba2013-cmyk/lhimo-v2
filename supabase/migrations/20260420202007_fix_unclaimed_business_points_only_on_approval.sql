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
