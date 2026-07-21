
-- ============================================================
-- POLICIES: conversations & messages
-- ============================================================

DROP POLICY IF EXISTS "Users can view own conversations" ON conversations;
CREATE POLICY "Users can view own conversations" ON conversations FOR SELECT TO authenticated
  USING (auth.uid() = participant1_id OR auth.uid() = participant2_id);

DROP POLICY IF EXISTS "Users can create conversations" ON conversations;
CREATE POLICY "Users can create conversations" ON conversations FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = participant1_id OR auth.uid() = participant2_id);

DROP POLICY IF EXISTS "Users can update own conversations" ON conversations;
CREATE POLICY "Users can update own conversations" ON conversations FOR UPDATE TO authenticated
  USING (auth.uid() = participant1_id OR auth.uid() = participant2_id)
  WITH CHECK (auth.uid() = participant1_id OR auth.uid() = participant2_id);

-- ============================================================
-- POLICIES: job_seekers
-- ============================================================

DROP POLICY IF EXISTS "Public can view active job seeker ads" ON job_seekers;
CREATE POLICY "Public can view active job seeker ads" ON job_seekers FOR SELECT TO anon, authenticated
  USING (status = 'active');

DROP POLICY IF EXISTS "Authenticated users can create job seeker ads" ON job_seekers;
CREATE POLICY "Authenticated users can create job seeker ads" ON job_seekers FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update own job seeker ads" ON job_seekers;
CREATE POLICY "Users can update own job seeker ads" ON job_seekers FOR UPDATE TO authenticated
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete own job seeker ads" ON job_seekers;
CREATE POLICY "Users can delete own job seeker ads" ON job_seekers FOR DELETE TO authenticated
  USING (auth.uid() = user_id);

-- ============================================================
-- POLICIES: unclaimed_business_locations (correct column name: added_by_family_member)
-- ============================================================

DROP POLICY IF EXISTS "Users can view own added businesses" ON unclaimed_business_locations;
CREATE POLICY "Users can view own added businesses" ON unclaimed_business_locations FOR SELECT TO authenticated
  USING (added_by = auth.uid()
    OR added_by_family_member IN (SELECT id FROM customer_family_members WHERE customer_id = auth.uid()));

DROP POLICY IF EXISTS "Users can add unclaimed businesses" ON unclaimed_business_locations;
CREATE POLICY "Users can add unclaimed businesses" ON unclaimed_business_locations FOR INSERT TO authenticated
  WITH CHECK (added_by = auth.uid());

DROP POLICY IF EXISTS "Users can update own added businesses" ON unclaimed_business_locations;
CREATE POLICY "Users can update own added businesses" ON unclaimed_business_locations FOR UPDATE TO authenticated
  USING (added_by = auth.uid()
    OR added_by_family_member IN (SELECT id FROM customer_family_members WHERE customer_id = auth.uid()))
  WITH CHECK (added_by = auth.uid()
    OR added_by_family_member IN (SELECT id FROM customer_family_members WHERE customer_id = auth.uid()));

DROP POLICY IF EXISTS "Users can delete own added businesses" ON unclaimed_business_locations;
CREATE POLICY "Users can delete own added businesses" ON unclaimed_business_locations FOR DELETE TO authenticated
  USING (added_by = auth.uid()
    OR added_by_family_member IN (SELECT id FROM customer_family_members WHERE customer_id = auth.uid()));

-- ============================================================
-- POLICIES: tasks
-- ============================================================

DROP POLICY IF EXISTS "Users can view own tasks" ON tasks;
CREATE POLICY "Users can view own tasks" ON tasks FOR SELECT TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can insert own tasks" ON tasks;
CREATE POLICY "Users can insert own tasks" ON tasks FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update own tasks" ON tasks;
CREATE POLICY "Users can update own tasks" ON tasks FOR UPDATE TO authenticated
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete own tasks" ON tasks;
CREATE POLICY "Users can delete own tasks" ON tasks FOR DELETE TO authenticated USING (auth.uid() = user_id);

-- ============================================================
-- POLICIES: admin full access
-- ============================================================

DROP POLICY IF EXISTS "Admins can view all activity logs" ON activity_log;
CREATE POLICY "Admins can view all activity logs" ON activity_log FOR SELECT TO authenticated USING (is_admin());

DROP POLICY IF EXISTS "Admins can view all conversations" ON conversations;
CREATE POLICY "Admins can view all conversations" ON conversations FOR SELECT TO authenticated USING (is_admin());

DROP POLICY IF EXISTS "Admins can view all messages" ON messages;
CREATE POLICY "Admins can view all messages" ON messages FOR SELECT TO authenticated USING (is_admin());

DROP POLICY IF EXISTS "Admins can view all notifications" ON notifications;
CREATE POLICY "Admins can view all notifications" ON notifications FOR SELECT TO authenticated USING (is_admin());

DROP POLICY IF EXISTS "Admins can view all job seekers" ON job_seekers;
CREATE POLICY "Admins can view all job seekers" ON job_seekers FOR SELECT TO authenticated USING (is_admin());

DROP POLICY IF EXISTS "Admins can update any job seeker" ON job_seekers;
CREATE POLICY "Admins can update any job seeker" ON job_seekers FOR UPDATE TO authenticated
  USING (is_admin()) WITH CHECK (is_admin());

DROP POLICY IF EXISTS "Admins can view all job postings" ON job_postings;
CREATE POLICY "Admins can view all job postings" ON job_postings FOR SELECT TO authenticated USING (is_admin());

DROP POLICY IF EXISTS "Admins can update any job posting" ON job_postings;
CREATE POLICY "Admins can update any job posting" ON job_postings FOR UPDATE TO authenticated
  USING (is_admin()) WITH CHECK (is_admin());

DROP POLICY IF EXISTS "Admins can delete any job posting" ON job_postings;
CREATE POLICY "Admins can delete any job posting" ON job_postings FOR DELETE TO authenticated USING (is_admin());

DROP POLICY IF EXISTS "Admins can view all job applications" ON job_applications;
CREATE POLICY "Admins can view all job applications" ON job_applications FOR SELECT TO authenticated USING (is_admin());

DROP POLICY IF EXISTS "Admins can view all products" ON products;
CREATE POLICY "Admins can view all products" ON products FOR SELECT TO authenticated USING (is_admin());

DROP POLICY IF EXISTS "Admins can update any product" ON products;
CREATE POLICY "Admins can update any product" ON products FOR UPDATE TO authenticated
  USING (is_admin()) WITH CHECK (is_admin());

DROP POLICY IF EXISTS "Admins can delete any product" ON products;
CREATE POLICY "Admins can delete any product" ON products FOR DELETE TO authenticated USING (is_admin());

DROP POLICY IF EXISTS "Admins can view all reports" ON reports;
CREATE POLICY "Admins can view all reports" ON reports FOR SELECT TO authenticated USING (is_admin());

DROP POLICY IF EXISTS "Admins can update any report" ON reports;
CREATE POLICY "Admins can update any report" ON reports FOR UPDATE TO authenticated
  USING (is_admin()) WITH CHECK (is_admin());

DROP POLICY IF EXISTS "Admins can view all family members" ON customer_family_members;
CREATE POLICY "Admins can view all family members" ON customer_family_members FOR SELECT TO authenticated USING (is_admin());

DROP POLICY IF EXISTS "Admins can update any family member" ON customer_family_members;
CREATE POLICY "Admins can update any family member" ON customer_family_members FOR UPDATE TO authenticated
  USING (is_admin()) WITH CHECK (is_admin());

DROP POLICY IF EXISTS "Admins can view all discounts" ON discounts;
CREATE POLICY "Admins can view all discounts" ON discounts FOR SELECT TO authenticated USING (is_admin());

DROP POLICY IF EXISTS "Admins can update any discount" ON discounts;
CREATE POLICY "Admins can update any discount" ON discounts FOR UPDATE TO authenticated
  USING (is_admin()) WITH CHECK (is_admin());

DROP POLICY IF EXISTS "Admins can delete any discount" ON discounts;
CREATE POLICY "Admins can delete any discount" ON discounts FOR DELETE TO authenticated USING (is_admin());

DROP POLICY IF EXISTS "Admins can view all registered businesses" ON registered_businesses;
CREATE POLICY "Admins can view all registered businesses" ON registered_businesses FOR SELECT TO authenticated USING (is_admin());

DROP POLICY IF EXISTS "Admins can update any registered business" ON registered_businesses;
CREATE POLICY "Admins can update any registered business" ON registered_businesses FOR UPDATE TO authenticated
  USING (is_admin()) WITH CHECK (is_admin());

DROP POLICY IF EXISTS "Admins can view all registered business locations" ON registered_business_locations;
CREATE POLICY "Admins can view all registered business locations" ON registered_business_locations FOR SELECT TO authenticated USING (is_admin());

DROP POLICY IF EXISTS "Admins can update any registered business location" ON registered_business_locations;
CREATE POLICY "Admins can update any registered business location" ON registered_business_locations FOR UPDATE TO authenticated
  USING (is_admin()) WITH CHECK (is_admin());

DROP POLICY IF EXISTS "Admins can view all user added businesses" ON user_added_businesses;
CREATE POLICY "Admins can view all user added businesses" ON user_added_businesses FOR SELECT TO authenticated USING (is_admin());

DROP POLICY IF EXISTS "Admins can approve user added businesses" ON user_added_businesses;
CREATE POLICY "Admins can approve user added businesses" ON user_added_businesses FOR UPDATE TO authenticated
  USING (is_admin()) WITH CHECK (is_admin());

-- ============================================================
-- POLICIES: profiles
-- ============================================================

DROP POLICY IF EXISTS "Authenticated users can view all profiles" ON profiles;
CREATE POLICY "Authenticated users can view all profiles" ON profiles FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "Public can view profiles with active job seeker ads" ON profiles;
CREATE POLICY "Public can view profiles with active job seeker ads" ON profiles FOR SELECT TO anon
  USING (EXISTS (SELECT 1 FROM job_seekers WHERE job_seekers.user_id = profiles.id AND job_seekers.status = 'active'));
