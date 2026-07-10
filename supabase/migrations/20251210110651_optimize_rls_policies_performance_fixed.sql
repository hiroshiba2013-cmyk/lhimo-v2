/*
  # Ottimizza le policy RLS per le prestazioni

  ## Modifiche
  
  Questo migration ottimizza tutte le policy RLS sostituendo `auth.uid()` con `(select auth.uid())`
  per evitare la rievalutazione della funzione per ogni riga, migliorando le prestazioni su scala.
  
  ## Tabelle modificate
  
  1. profiles
  2. businesses
  3. discounts
  4. reviews
  5. review_responses
  6. job_postings
  7. job_applications
  8. job_requests
  9. customer_family_members
  10. business_locations
  11. subscriptions
  
  ## Note
  
  Questo pattern è raccomandato da Supabase per ottimizzare le prestazioni RLS.
  Vedi: https://supabase.com/docs/guides/database/postgres/row-level-security#call-functions-with-select
*/

-- =====================================================
-- PROFILES TABLE
-- =====================================================

DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT
  TO authenticated
  USING (id = (select auth.uid()));

DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  TO authenticated
  USING (id = (select auth.uid()))
  WITH CHECK (id = (select auth.uid()));

DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;
CREATE POLICY "Users can insert own profile"
  ON profiles FOR INSERT
  TO authenticated
  WITH CHECK (id = (select auth.uid()));

-- =====================================================
-- BUSINESSES TABLE
-- =====================================================

DROP POLICY IF EXISTS "Anyone can view verified businesses" ON businesses;
CREATE POLICY "Anyone can view verified businesses"
  ON businesses FOR SELECT
  TO authenticated
  USING (verified = true OR owner_id = (select auth.uid()));

DROP POLICY IF EXISTS "Business owners can insert own business" ON businesses;
CREATE POLICY "Business owners can insert own business"
  ON businesses FOR INSERT
  TO authenticated
  WITH CHECK (owner_id = (select auth.uid()));

DROP POLICY IF EXISTS "Business owners can update own business" ON businesses;
CREATE POLICY "Business owners can update own business"
  ON businesses FOR UPDATE
  TO authenticated
  USING (owner_id = (select auth.uid()))
  WITH CHECK (owner_id = (select auth.uid()));

DROP POLICY IF EXISTS "Business owners can delete own business" ON businesses;
CREATE POLICY "Business owners can delete own business"
  ON businesses FOR DELETE
  TO authenticated
  USING (owner_id = (select auth.uid()));

-- =====================================================
-- DISCOUNTS TABLE
-- =====================================================

DROP POLICY IF EXISTS "Business owners can create discounts" ON discounts;
CREATE POLICY "Business owners can create discounts"
  ON discounts FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM businesses
      WHERE businesses.id = discounts.business_id
      AND businesses.owner_id = (select auth.uid())
    )
  );

DROP POLICY IF EXISTS "Business owners can update own discounts" ON discounts;
CREATE POLICY "Business owners can update own discounts"
  ON discounts FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM businesses
      WHERE businesses.id = discounts.business_id
      AND businesses.owner_id = (select auth.uid())
    )
  );

DROP POLICY IF EXISTS "Business owners can delete own discounts" ON discounts;
CREATE POLICY "Business owners can delete own discounts"
  ON discounts FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM businesses
      WHERE businesses.id = discounts.business_id
      AND businesses.owner_id = (select auth.uid())
    )
  );

-- =====================================================
-- REVIEWS TABLE
-- =====================================================

DROP POLICY IF EXISTS "Customers can create reviews" ON reviews;
CREATE POLICY "Customers can create reviews"
  ON reviews FOR INSERT
  TO authenticated
  WITH CHECK (customer_id = (select auth.uid()));

DROP POLICY IF EXISTS "Customers can update own reviews" ON reviews;
CREATE POLICY "Customers can update own reviews"
  ON reviews FOR UPDATE
  TO authenticated
  USING (customer_id = (select auth.uid()))
  WITH CHECK (customer_id = (select auth.uid()));

DROP POLICY IF EXISTS "Customers can delete own reviews" ON reviews;
CREATE POLICY "Customers can delete own reviews"
  ON reviews FOR DELETE
  TO authenticated
  USING (customer_id = (select auth.uid()));

-- =====================================================
-- REVIEW_RESPONSES TABLE
-- =====================================================

DROP POLICY IF EXISTS "Business owners can respond to reviews" ON review_responses;
CREATE POLICY "Business owners can respond to reviews"
  ON review_responses FOR INSERT
  TO authenticated
  WITH CHECK (business_id IN (
    SELECT id FROM businesses WHERE owner_id = (select auth.uid())
  ));

-- =====================================================
-- JOB_POSTINGS TABLE
-- =====================================================

DROP POLICY IF EXISTS "Businesses can view their own postings" ON job_postings;
CREATE POLICY "Businesses can view their own postings"
  ON job_postings FOR SELECT
  TO authenticated
  USING (
    business_id IN (
      SELECT id FROM businesses WHERE owner_id = (select auth.uid())
    )
  );

DROP POLICY IF EXISTS "Businesses can create job postings" ON job_postings;
CREATE POLICY "Businesses can create job postings"
  ON job_postings FOR INSERT
  TO authenticated
  WITH CHECK (
    business_id IN (
      SELECT id FROM businesses WHERE owner_id = (select auth.uid())
    )
  );

DROP POLICY IF EXISTS "Businesses can update their own postings" ON job_postings;
CREATE POLICY "Businesses can update their own postings"
  ON job_postings FOR UPDATE
  TO authenticated
  USING (
    business_id IN (
      SELECT id FROM businesses WHERE owner_id = (select auth.uid())
    )
  );

DROP POLICY IF EXISTS "Businesses can delete their own postings" ON job_postings;
CREATE POLICY "Businesses can delete their own postings"
  ON job_postings FOR DELETE
  TO authenticated
  USING (
    business_id IN (
      SELECT id FROM businesses WHERE owner_id = (select auth.uid())
    )
  );

-- =====================================================
-- JOB_APPLICATIONS TABLE
-- =====================================================

DROP POLICY IF EXISTS "Users can view applications they submitted" ON job_applications;
CREATE POLICY "Users can view applications they submitted"
  ON job_applications FOR SELECT
  TO authenticated
  USING (user_id = (select auth.uid()));

DROP POLICY IF EXISTS "Businesses can view applications to their postings" ON job_applications;
CREATE POLICY "Businesses can view applications to their postings"
  ON job_applications FOR SELECT
  TO authenticated
  USING (
    job_posting_id IN (
      SELECT jp.id FROM job_postings jp
      INNER JOIN businesses b ON jp.business_id = b.id
      WHERE b.owner_id = (select auth.uid())
    )
  );

DROP POLICY IF EXISTS "Authenticated users can apply to jobs" ON job_applications;
CREATE POLICY "Authenticated users can apply to jobs"
  ON job_applications FOR INSERT
  TO authenticated
  WITH CHECK (user_id = (select auth.uid()));

DROP POLICY IF EXISTS "Users can update their own applications" ON job_applications;
CREATE POLICY "Users can update their own applications"
  ON job_applications FOR UPDATE
  TO authenticated
  USING (user_id = (select auth.uid()));

-- =====================================================
-- JOB_REQUESTS TABLE
-- =====================================================

DROP POLICY IF EXISTS "Users can view own job requests" ON job_requests;
CREATE POLICY "Users can view own job requests"
  ON job_requests FOR SELECT
  TO authenticated
  USING (customer_id = (select auth.uid()));

DROP POLICY IF EXISTS "Customers can create job requests" ON job_requests;
CREATE POLICY "Customers can create job requests"
  ON job_requests FOR INSERT
  TO authenticated
  WITH CHECK (customer_id = (select auth.uid()));

DROP POLICY IF EXISTS "Users can update own job requests" ON job_requests;
CREATE POLICY "Users can update own job requests"
  ON job_requests FOR UPDATE
  TO authenticated
  USING (customer_id = (select auth.uid()));

DROP POLICY IF EXISTS "Users can delete own job requests" ON job_requests;
CREATE POLICY "Users can delete own job requests"
  ON job_requests FOR DELETE
  TO authenticated
  USING (customer_id = (select auth.uid()));

-- =====================================================
-- CUSTOMER_FAMILY_MEMBERS TABLE
-- =====================================================

DROP POLICY IF EXISTS "Users can view own family members" ON customer_family_members;
CREATE POLICY "Users can view own family members"
  ON customer_family_members FOR SELECT
  TO authenticated
  USING (customer_id = (select auth.uid()));

DROP POLICY IF EXISTS "Users can insert own family members" ON customer_family_members;
CREATE POLICY "Users can insert own family members"
  ON customer_family_members FOR INSERT
  TO authenticated
  WITH CHECK (customer_id = (select auth.uid()));

DROP POLICY IF EXISTS "Users can update own family members" ON customer_family_members;
CREATE POLICY "Users can update own family members"
  ON customer_family_members FOR UPDATE
  TO authenticated
  USING (customer_id = (select auth.uid()))
  WITH CHECK (customer_id = (select auth.uid()));

DROP POLICY IF EXISTS "Users can delete own family members" ON customer_family_members;
CREATE POLICY "Users can delete own family members"
  ON customer_family_members FOR DELETE
  TO authenticated
  USING (customer_id = (select auth.uid()));

-- =====================================================
-- BUSINESS_LOCATIONS TABLE
-- =====================================================

DROP POLICY IF EXISTS "Business owners can view own locations" ON business_locations;
CREATE POLICY "Business owners can view own locations"
  ON business_locations FOR SELECT
  TO authenticated
  USING (
    business_id IN (
      SELECT id FROM businesses WHERE owner_id = (select auth.uid())
    )
  );

DROP POLICY IF EXISTS "Business owners can insert own locations" ON business_locations;
CREATE POLICY "Business owners can insert own locations"
  ON business_locations FOR INSERT
  TO authenticated
  WITH CHECK (
    business_id IN (
      SELECT id FROM businesses WHERE owner_id = (select auth.uid())
    )
  );

DROP POLICY IF EXISTS "Business owners can update own locations" ON business_locations;
CREATE POLICY "Business owners can update own locations"
  ON business_locations FOR UPDATE
  TO authenticated
  USING (
    business_id IN (
      SELECT id FROM businesses WHERE owner_id = (select auth.uid())
    )
  );

DROP POLICY IF EXISTS "Business owners can delete own locations" ON business_locations;
CREATE POLICY "Business owners can delete own locations"
  ON business_locations FOR DELETE
  TO authenticated
  USING (
    business_id IN (
      SELECT id FROM businesses WHERE owner_id = (select auth.uid())
    )
  );

-- =====================================================
-- SUBSCRIPTIONS TABLE
-- =====================================================

DROP POLICY IF EXISTS "Users can view own subscriptions" ON subscriptions;
CREATE POLICY "Users can view own subscriptions"
  ON subscriptions FOR SELECT
  TO authenticated
  USING (customer_id = (select auth.uid()));

DROP POLICY IF EXISTS "Users can create own subscriptions" ON subscriptions;
CREATE POLICY "Users can create own subscriptions"
  ON subscriptions FOR INSERT
  TO authenticated
  WITH CHECK (customer_id = (select auth.uid()));

DROP POLICY IF EXISTS "Users can update own subscriptions" ON subscriptions;
CREATE POLICY "Users can update own subscriptions"
  ON subscriptions FOR UPDATE
  TO authenticated
  USING (customer_id = (select auth.uid()))
  WITH CHECK (customer_id = (select auth.uid()));