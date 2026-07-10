/*
  # Add Activity Logs for Review Approval and Referrals

  1. Triggers
    - Log when review is approved (awards points)
    - Log referral rewards

  2. Updates
    - Track when users receive points from review approval
    - Track when users receive referral bonuses
*/

-- Function to log review approval
CREATE OR REPLACE FUNCTION log_review_approval()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_business_name text;
  v_points integer;
BEGIN
  -- Only log if status changes to approved
  IF NEW.review_status = 'approved' AND OLD.review_status != 'approved' THEN
    -- Get business name
    SELECT name INTO v_business_name
    FROM business_locations
    WHERE business_id = NEW.business_id
    LIMIT 1;

    -- Determine points based on proof image
    v_points := CASE 
      WHEN NEW.proof_image_url IS NOT NULL AND NEW.proof_image_url != '' THEN 50
      ELSE 25
    END;

    -- Log the activity
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
      'text-green-600'
    );
  END IF;

  RETURN NEW;
END;
$$;

-- Create trigger for review approval
DROP TRIGGER IF EXISTS trigger_log_review_approval ON reviews;
CREATE TRIGGER trigger_log_review_approval
  AFTER UPDATE ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION log_review_approval();

-- Function to log referral rewards
CREATE OR REPLACE FUNCTION log_referral_reward()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_referrer_id uuid;
  v_referrer_name text;
BEGIN
  -- Only process if this is a new subscription (not trial)
  IF NEW.status = 'active' AND OLD.status IS DISTINCT FROM 'active' THEN
    -- Get the referrer info from the customer's profile
    SELECT p.id, p.full_name INTO v_referrer_id, v_referrer_name
    FROM profiles p
    WHERE p.nickname = (
      SELECT referred_by_nickname
      FROM profiles
      WHERE id = NEW.customer_id
    );

    -- If there's a referrer, log the reward
    IF v_referrer_id IS NOT NULL THEN
      -- Log activity for the referrer
      PERFORM log_user_activity(
        v_referrer_id,
        'referral_reward',
        'Bonus Amico Ricevuto!',
        'Hai guadagnato 30 punti grazie all''abbonamento del tuo amico',
        30,
        jsonb_build_object(
          'referred_user_id', NEW.customer_id,
          'subscription_id', NEW.id
        ),
        'gift',
        'text-yellow-600'
      );

      -- Update referral count
      UPDATE profiles
      SET referral_count = COALESCE(referral_count, 0) + 1
      WHERE id = v_referrer_id;
    END IF;
  END IF;

  RETURN NEW;
END;
$$;

-- Create trigger for referral rewards
DROP TRIGGER IF EXISTS trigger_log_referral_reward ON subscriptions;
CREATE TRIGGER trigger_log_referral_reward
  AFTER UPDATE ON subscriptions
  FOR EACH ROW
  EXECUTE FUNCTION log_referral_reward();