/*
  # Create Activity Log System

  1. New Tables
    - `activity_log`
      - `id` (uuid, primary key)
      - `user_id` (uuid, references profiles)
      - `activity_type` (text) - Type of activity
      - `title` (text) - Activity title
      - `description` (text) - Activity description
      - `points_earned` (integer) - Points earned from this activity
      - `metadata` (jsonb) - Additional data (entity_id, discount_amount, etc.)
      - `icon` (text) - Icon name for display
      - `color` (text) - Color class for styling
      - `created_at` (timestamptz)

  2. Activity Types
    - points_earned - General points earned
    - review_created - Review submitted
    - review_approved - Review approved by staff
    - ad_created - Classified ad created
    - ad_viewed - Classified ad received views
    - product_created - Product added
    - business_added - Business added to platform
    - discount_received - Discount received
    - discount_used - Discount used
    - referral_reward - Referral bonus received
    - badge_earned - Badge unlocked
    - subscription_started - Subscription activated
    - subscription_renewed - Subscription renewed

  3. Security
    - Enable RLS
    - Users can view their own activity log
    - System can create activity logs
*/

-- Create activity_log table
CREATE TABLE IF NOT EXISTS activity_log (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  activity_type text NOT NULL,
  title text NOT NULL,
  description text NOT NULL,
  points_earned integer DEFAULT 0,
  metadata jsonb DEFAULT '{}',
  icon text DEFAULT 'activity',
  color text DEFAULT 'text-blue-600',
  created_at timestamptz DEFAULT now()
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_activity_log_user_id ON activity_log(user_id);
CREATE INDEX IF NOT EXISTS idx_activity_log_created_at ON activity_log(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_activity_log_user_created ON activity_log(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_activity_log_type ON activity_log(activity_type);

-- Enable RLS
ALTER TABLE activity_log ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view own activity log"
  ON activity_log FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "System can create activity logs"
  ON activity_log FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Function to log activity
CREATE OR REPLACE FUNCTION log_user_activity(
  p_user_id uuid,
  p_activity_type text,
  p_title text,
  p_description text,
  p_points_earned integer DEFAULT 0,
  p_metadata jsonb DEFAULT '{}',
  p_icon text DEFAULT 'activity',
  p_color text DEFAULT 'text-blue-600'
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

-- Function to track ad views in activity log
CREATE OR REPLACE FUNCTION log_ad_view_milestone()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_ad classified_ads%ROWTYPE;
  v_total_views integer;
BEGIN
  -- Get the ad details
  SELECT * INTO v_ad
  FROM classified_ads
  WHERE id = NEW.ad_id;

  -- Count total views for this ad
  SELECT COUNT(*) INTO v_total_views
  FROM classified_ad_views
  WHERE ad_id = NEW.ad_id;

  -- Log milestone views (every 10 views)
  IF v_total_views % 10 = 0 THEN
    PERFORM log_user_activity(
      v_ad.user_id,
      'ad_viewed',
      'Il tuo annuncio ha raggiunto ' || v_total_views || ' visualizzazioni!',
      'L''annuncio "' || v_ad.title || '" continua a ricevere attenzione.',
      0,
      jsonb_build_object('ad_id', v_ad.id, 'total_views', v_total_views),
      'eye',
      'text-green-600'
    );
  END IF;

  RETURN NEW;
END;
$$;

-- Create trigger for ad view milestones
DROP TRIGGER IF EXISTS trigger_log_ad_view_milestone ON classified_ad_views;
CREATE TRIGGER trigger_log_ad_view_milestone
  AFTER INSERT ON classified_ad_views
  FOR EACH ROW
  EXECUTE FUNCTION log_ad_view_milestone();

-- Function to log classified ad creation
CREATE OR REPLACE FUNCTION log_ad_creation()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  PERFORM log_user_activity(
    NEW.user_id,
    'ad_created',
    'Annuncio pubblicato',
    'Hai pubblicato l''annuncio "' || NEW.title || '"',
    5,
    jsonb_build_object('ad_id', NEW.id),
    'file-text',
    'text-blue-600'
  );

  RETURN NEW;
END;
$$;

-- Create trigger for ad creation
DROP TRIGGER IF EXISTS trigger_log_ad_creation ON classified_ads;
CREATE TRIGGER trigger_log_ad_creation
  AFTER INSERT ON classified_ads
  FOR EACH ROW
  EXECUTE FUNCTION log_ad_creation();

-- Function to log review submission
CREATE OR REPLACE FUNCTION log_review_submission()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_business_name text;
BEGIN
  -- Get business name
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
    'text-yellow-600'
  );

  RETURN NEW;
END;
$$;

-- Create trigger for review submission
DROP TRIGGER IF EXISTS trigger_log_review_submission ON reviews;
CREATE TRIGGER trigger_log_review_submission
  AFTER INSERT ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION log_review_submission();

-- Function to log subscription start
CREATE OR REPLACE FUNCTION log_subscription_start()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_plan_name text;
BEGIN
  -- Get plan name
  SELECT name INTO v_plan_name
  FROM subscription_plans
  WHERE id = NEW.plan_id;

  PERFORM log_user_activity(
    NEW.customer_id,
    'subscription_started',
    'Abbonamento attivato',
    'Hai attivato l''abbonamento "' || COALESCE(v_plan_name, 'Premium') || '"',
    0,
    jsonb_build_object('subscription_id', NEW.id, 'plan_id', NEW.plan_id),
    'credit-card',
    'text-purple-600'
  );

  RETURN NEW;
END;
$$;

-- Create trigger for subscription start
DROP TRIGGER IF EXISTS trigger_log_subscription_start ON subscriptions;
CREATE TRIGGER trigger_log_subscription_start
  AFTER INSERT ON subscriptions
  FOR EACH ROW
  EXECUTE FUNCTION log_subscription_start();

-- Function to get user activity summary
CREATE OR REPLACE FUNCTION get_user_activity_summary(p_user_id uuid)
RETURNS TABLE (
  total_activities bigint,
  total_points_earned bigint,
  activities_this_week bigint,
  activities_this_month bigint
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    COUNT(*)::bigint as total_activities,
    COALESCE(SUM(points_earned), 0)::bigint as total_points_earned,
    COUNT(*) FILTER (WHERE created_at >= NOW() - INTERVAL '7 days')::bigint as activities_this_week,
    COUNT(*) FILTER (WHERE created_at >= NOW() - INTERVAL '30 days')::bigint as activities_this_month
  FROM activity_log
  WHERE user_id = p_user_id;
END;
$$;