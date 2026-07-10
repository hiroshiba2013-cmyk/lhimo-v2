/*
  # Fix Admin RLS Policies for All Tables

  1. Changes
    - Add admin policies for subscription_plans
    - Add admin policies for subscriptions
    - Add admin policies for activity_log
    - Add admin policies for solidarity_documents
    - Add admin policies for user_activity
    - Add admin policies for unclaimed_business_locations
    - Add admin policies for classified_ads
    - Add admin policies for reviews

  2. Security
    - Use admins table to check admin status
    - All policies check auth.uid() EXISTS in admins table
*/

-- Helper function to check if user is admin (using admins table)
CREATE OR REPLACE FUNCTION is_admin()
RETURNS boolean AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM admins
    WHERE user_id = auth.uid()
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ========================================
-- SUBSCRIPTION PLANS
-- ========================================

DROP POLICY IF EXISTS "Admins can manage subscription plans" ON subscription_plans;
CREATE POLICY "Admins can manage subscription plans"
  ON subscription_plans FOR ALL
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- ========================================
-- SUBSCRIPTIONS
-- ========================================

DROP POLICY IF EXISTS "Admins can view all subscriptions" ON subscriptions;
CREATE POLICY "Admins can view all subscriptions"
  ON subscriptions FOR SELECT
  TO authenticated
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can manage subscriptions" ON subscriptions;
CREATE POLICY "Admins can manage subscriptions"
  ON subscriptions FOR ALL
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- ========================================
-- ACTIVITY LOG
-- ========================================

DROP POLICY IF EXISTS "Admins can view all activity log" ON activity_log;
CREATE POLICY "Admins can view all activity log"
  ON activity_log FOR SELECT
  TO authenticated
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can manage activity log" ON activity_log;
CREATE POLICY "Admins can manage activity log"
  ON activity_log FOR ALL
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- ========================================
-- SOLIDARITY DOCUMENTS
-- ========================================

DROP POLICY IF EXISTS "Admins can view all solidarity documents" ON solidarity_documents;
CREATE POLICY "Admins can view all solidarity documents"
  ON solidarity_documents FOR SELECT
  TO authenticated
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can manage solidarity documents" ON solidarity_documents;
CREATE POLICY "Admins can manage solidarity documents"
  ON solidarity_documents FOR ALL
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- ========================================
-- USER ACTIVITY
-- ========================================

DROP POLICY IF EXISTS "Admins can view all user activity" ON user_activity;
CREATE POLICY "Admins can view all user activity"
  ON user_activity FOR SELECT
  TO authenticated
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can manage user activity" ON user_activity;
CREATE POLICY "Admins can manage user activity"
  ON user_activity FOR ALL
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- ========================================
-- UNCLAIMED BUSINESS LOCATIONS
-- ========================================

DROP POLICY IF EXISTS "Admins can view all unclaimed business locations" ON unclaimed_business_locations;
CREATE POLICY "Admins can view all unclaimed business locations"
  ON unclaimed_business_locations FOR SELECT
  TO authenticated
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can manage unclaimed business locations" ON unclaimed_business_locations;
CREATE POLICY "Admins can manage unclaimed business locations"
  ON unclaimed_business_locations FOR ALL
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- ========================================
-- CLASSIFIED ADS
-- ========================================

DROP POLICY IF EXISTS "Admins can view all classified ads" ON classified_ads;
CREATE POLICY "Admins can view all classified ads"
  ON classified_ads FOR SELECT
  TO authenticated
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can manage classified ads" ON classified_ads;
CREATE POLICY "Admins can manage classified ads"
  ON classified_ads FOR ALL
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- ========================================
-- REVIEWS
-- ========================================

DROP POLICY IF EXISTS "Admins can view all reviews" ON reviews;
CREATE POLICY "Admins can view all reviews"
  ON reviews FOR SELECT
  TO authenticated
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can manage reviews" ON reviews;
CREATE POLICY "Admins can manage reviews"
  ON reviews FOR ALL
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- ========================================
-- BUSINESS CATEGORIES
-- ========================================

DROP POLICY IF EXISTS "Admins can manage business categories" ON business_categories;
CREATE POLICY "Admins can manage business categories"
  ON business_categories FOR ALL
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- Comment
COMMENT ON FUNCTION is_admin() IS 'Helper function to check if current user is an admin using the admins table';
