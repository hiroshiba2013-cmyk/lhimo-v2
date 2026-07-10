/*
  # Replace All Profile Subqueries with is_admin()

  1. Problem
    - Many policies across different tables query profiles table directly
    - This causes infinite recursion when any of these policies are evaluated
    - Pattern: EXISTS (SELECT 1 FROM profiles WHERE profiles.id = auth.uid() AND profiles.is_admin = true)

  2. Solution
    - Replace ALL occurrences of profile subqueries with is_admin() function
    - is_admin() now uses the admins table (no RLS = no recursion)
    - This will fix recursion across the entire database

  3. Tables to Update
    - activity_log, conversations, customer_family_members, discounts
    - imported_businesses, job_applications, job_postings, job_requests
    - job_seekers, messages, notifications, products
    - registered_business_locations, registered_businesses, reports
    - user_added_businesses, and storage objects
*/

-- ============================================================
-- ACTIVITY_LOG
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all activity logs" ON activity_log;
CREATE POLICY "Admins can view all activity logs"
  ON activity_log FOR SELECT
  USING (is_admin());

-- ============================================================
-- CONVERSATIONS
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all conversations" ON conversations;
CREATE POLICY "Admins can view all conversations"
  ON conversations FOR SELECT
  USING (is_admin());

-- ============================================================
-- CUSTOMER_FAMILY_MEMBERS
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all family members" ON customer_family_members;
CREATE POLICY "Admins can view all family members"
  ON customer_family_members FOR SELECT
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can update any family member" ON customer_family_members;
CREATE POLICY "Admins can update any family member"
  ON customer_family_members FOR UPDATE
  USING (is_admin())
  WITH CHECK (is_admin());

-- ============================================================
-- DISCOUNTS
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all discounts" ON discounts;
CREATE POLICY "Admins can view all discounts"
  ON discounts FOR SELECT
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can update any discount" ON discounts;
CREATE POLICY "Admins can update any discount"
  ON discounts FOR UPDATE
  USING (is_admin())
  WITH CHECK (is_admin());

DROP POLICY IF EXISTS "Admins can delete any discount" ON discounts;
CREATE POLICY "Admins can delete any discount"
  ON discounts FOR DELETE
  USING (is_admin());

-- ============================================================
-- IMPORTED_BUSINESSES
-- ============================================================
DROP POLICY IF EXISTS "Only admins can manage imported businesses" ON imported_businesses;
CREATE POLICY "Only admins can manage imported businesses"
  ON imported_businesses FOR ALL
  USING (is_admin())
  WITH CHECK (is_admin());

DROP POLICY IF EXISTS "Admins can update imported businesses" ON imported_businesses;
CREATE POLICY "Admins can update imported businesses"
  ON imported_businesses FOR UPDATE
  USING (is_admin())
  WITH CHECK (is_admin());

DROP POLICY IF EXISTS "Admins can delete imported businesses" ON imported_businesses;
CREATE POLICY "Admins can delete imported businesses"
  ON imported_businesses FOR DELETE
  USING (is_admin());

-- ============================================================
-- JOB_APPLICATIONS
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all job applications" ON job_applications;
CREATE POLICY "Admins can view all job applications"
  ON job_applications FOR SELECT
  USING (is_admin());

-- ============================================================
-- JOB_POSTINGS
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all job postings" ON job_postings;
CREATE POLICY "Admins can view all job postings"
  ON job_postings FOR SELECT
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can update any job posting" ON job_postings;
CREATE POLICY "Admins can update any job posting"
  ON job_postings FOR UPDATE
  USING (is_admin())
  WITH CHECK (is_admin());

DROP POLICY IF EXISTS "Admins can delete any job posting" ON job_postings;
CREATE POLICY "Admins can delete any job posting"
  ON job_postings FOR DELETE
  USING (is_admin());

-- ============================================================
-- JOB_REQUESTS
-- ============================================================
DROP POLICY IF EXISTS "Customers can create job requests" ON job_requests;
CREATE POLICY "Customers can create job requests"
  ON job_requests FOR INSERT
  WITH CHECK (
    EXISTS (SELECT 1 FROM auth.users WHERE id = auth.uid())
  );

-- ============================================================
-- JOB_SEEKERS
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all job seekers" ON job_seekers;
CREATE POLICY "Admins can view all job seekers"
  ON job_seekers FOR SELECT
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can update any job seeker" ON job_seekers;
CREATE POLICY "Admins can update any job seeker"
  ON job_seekers FOR UPDATE
  USING (is_admin())
  WITH CHECK (is_admin());

-- ============================================================
-- MESSAGES
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all messages" ON messages;
CREATE POLICY "Admins can view all messages"
  ON messages FOR SELECT
  USING (is_admin());

-- ============================================================
-- NOTIFICATIONS
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all notifications" ON notifications;
CREATE POLICY "Admins can view all notifications"
  ON notifications FOR SELECT
  USING (is_admin());

-- ============================================================
-- PRODUCTS
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all products" ON products;
CREATE POLICY "Admins can view all products"
  ON products FOR SELECT
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can update any product" ON products;
CREATE POLICY "Admins can update any product"
  ON products FOR UPDATE
  USING (is_admin())
  WITH CHECK (is_admin());

DROP POLICY IF EXISTS "Admins can delete any product" ON products;
CREATE POLICY "Admins can delete any product"
  ON products FOR DELETE
  USING (is_admin());

-- ============================================================
-- REGISTERED_BUSINESS_LOCATIONS
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all registered business locations" ON registered_business_locations;
CREATE POLICY "Admins can view all registered business locations"
  ON registered_business_locations FOR SELECT
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can update any registered business location" ON registered_business_locations;
CREATE POLICY "Admins can update any registered business location"
  ON registered_business_locations FOR UPDATE
  USING (is_admin())
  WITH CHECK (is_admin());

-- ============================================================
-- REGISTERED_BUSINESSES
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all registered businesses" ON registered_businesses;
CREATE POLICY "Admins can view all registered businesses"
  ON registered_businesses FOR SELECT
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can update any registered business" ON registered_businesses;
CREATE POLICY "Admins can update any registered business"
  ON registered_businesses FOR UPDATE
  USING (is_admin())
  WITH CHECK (is_admin());

-- ============================================================
-- REPORTS
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all reports" ON reports;
CREATE POLICY "Admins can view all reports"
  ON reports FOR SELECT
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can update any report" ON reports;
CREATE POLICY "Admins can update any report"
  ON reports FOR UPDATE
  USING (is_admin())
  WITH CHECK (is_admin());

-- ============================================================
-- USER_ADDED_BUSINESSES
-- ============================================================
DROP POLICY IF EXISTS "Admins can view all user added businesses" ON user_added_businesses;
CREATE POLICY "Admins can view all user added businesses"
  ON user_added_businesses FOR SELECT
  USING (is_admin());

DROP POLICY IF EXISTS "Admins can approve user added businesses" ON user_added_businesses;
CREATE POLICY "Admins can approve user added businesses"
  ON user_added_businesses FOR UPDATE
  USING (is_admin())
  WITH CHECK (is_admin());

DROP POLICY IF EXISTS "Users can update own businesses" ON user_added_businesses;
CREATE POLICY "Users can update own businesses"
  ON user_added_businesses FOR UPDATE
  USING (added_by = auth.uid() OR is_admin())
  WITH CHECK (added_by = auth.uid() OR is_admin());

-- ============================================================
-- REVIEWS (staff policy)
-- ============================================================
DROP POLICY IF EXISTS "Staff can view all reviews" ON reviews;
CREATE POLICY "Staff can view all reviews"
  ON reviews FOR SELECT
  USING (is_admin());

-- ============================================================
-- STORAGE: review-proofs bucket
-- ============================================================
DROP POLICY IF EXISTS "Staff can view all review proofs" ON storage.objects;
CREATE POLICY "Staff can view all review proofs"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'review-proofs' AND is_admin());

COMMENT ON FUNCTION is_admin() IS 'All policies updated to use is_admin() instead of querying profiles directly. No more recursion!';
