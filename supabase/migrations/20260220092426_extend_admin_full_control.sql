/*
  # Estensione Controllo Admin Completo

  1. Cosa viene aggiunto
    - Policy admin per registered_businesses e registered_business_locations
    - Policy admin per imported_businesses e user_added_businesses
    - Policy admin per job_postings, job_applications, job_seekers
    - Policy admin per products
    - Policy admin per reports (segnalazioni)
    - Policy admin per customer_family_members
    - Policy admin per discounts
    - Policy admin per tutte le conversazioni e messaggi
    - Policy admin per notifications
    - Policy admin per activity_log

  2. Permessi Admin
    - Gli admin possono visualizzare TUTTI i dati della piattaforma
    - Gli admin possono modificare TUTTI i dati (tranne eliminazioni critiche)
    - Gli admin possono gestire segnalazioni e moderare contenuti
    - Gli admin possono gestire attività business e relative sedi
    - Gli admin possono gestire membri famiglia degli utenti
    - Gli admin possono vedere tutte le conversazioni

  3. Security
    - Solo utenti con is_admin = true possono accedere
    - Le policy sono restrictive e richiedono autenticazione
*/

-- ========================================
-- REGISTERED BUSINESSES E LOCATIONS
-- ========================================

DROP POLICY IF EXISTS "Admins can view all registered businesses" ON registered_businesses;
CREATE POLICY "Admins can view all registered businesses"
  ON registered_businesses FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can update any registered business" ON registered_businesses;
CREATE POLICY "Admins can update any registered business"
  ON registered_businesses FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can view all registered business locations" ON registered_business_locations;
CREATE POLICY "Admins can view all registered business locations"
  ON registered_business_locations FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can update any registered business location" ON registered_business_locations;
CREATE POLICY "Admins can update any registered business location"
  ON registered_business_locations FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

-- ========================================
-- IMPORTED E USER ADDED BUSINESSES
-- ========================================

DROP POLICY IF EXISTS "Admins can update imported businesses" ON imported_businesses;
CREATE POLICY "Admins can update imported businesses"
  ON imported_businesses FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can delete imported businesses" ON imported_businesses;
CREATE POLICY "Admins can delete imported businesses"
  ON imported_businesses FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can view all user added businesses" ON user_added_businesses;
CREATE POLICY "Admins can view all user added businesses"
  ON user_added_businesses FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can approve user added businesses" ON user_added_businesses;
CREATE POLICY "Admins can approve user added businesses"
  ON user_added_businesses FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

-- ========================================
-- JOB POSTINGS E JOB SEEKERS
-- ========================================

DROP POLICY IF EXISTS "Admins can view all job postings" ON job_postings;
CREATE POLICY "Admins can view all job postings"
  ON job_postings FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can update any job posting" ON job_postings;
CREATE POLICY "Admins can update any job posting"
  ON job_postings FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can delete any job posting" ON job_postings;
CREATE POLICY "Admins can delete any job posting"
  ON job_postings FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can view all job applications" ON job_applications;
CREATE POLICY "Admins can view all job applications"
  ON job_applications FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can view all job seekers" ON job_seekers;
CREATE POLICY "Admins can view all job seekers"
  ON job_seekers FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can update any job seeker" ON job_seekers;
CREATE POLICY "Admins can update any job seeker"
  ON job_seekers FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

-- ========================================
-- PRODUCTS
-- ========================================

DROP POLICY IF EXISTS "Admins can view all products" ON products;
CREATE POLICY "Admins can view all products"
  ON products FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can update any product" ON products;
CREATE POLICY "Admins can update any product"
  ON products FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can delete any product" ON products;
CREATE POLICY "Admins can delete any product"
  ON products FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

-- ========================================
-- REPORTS (SEGNALAZIONI)
-- ========================================

DROP POLICY IF EXISTS "Admins can view all reports" ON reports;
CREATE POLICY "Admins can view all reports"
  ON reports FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can update any report" ON reports;
CREATE POLICY "Admins can update any report"
  ON reports FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

-- ========================================
-- FAMILY MEMBERS
-- ========================================

DROP POLICY IF EXISTS "Admins can view all family members" ON customer_family_members;
CREATE POLICY "Admins can view all family members"
  ON customer_family_members FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can update any family member" ON customer_family_members;
CREATE POLICY "Admins can update any family member"
  ON customer_family_members FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

-- ========================================
-- DISCOUNTS
-- ========================================

DROP POLICY IF EXISTS "Admins can view all discounts" ON discounts;
CREATE POLICY "Admins can view all discounts"
  ON discounts FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can update any discount" ON discounts;
CREATE POLICY "Admins can update any discount"
  ON discounts FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can delete any discount" ON discounts;
CREATE POLICY "Admins can delete any discount"
  ON discounts FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

-- ========================================
-- CONVERSATIONS E MESSAGES
-- ========================================

DROP POLICY IF EXISTS "Admins can view all conversations" ON conversations;
CREATE POLICY "Admins can view all conversations"
  ON conversations FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

DROP POLICY IF EXISTS "Admins can view all messages" ON messages;
CREATE POLICY "Admins can view all messages"
  ON messages FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

-- ========================================
-- NOTIFICATIONS
-- ========================================

DROP POLICY IF EXISTS "Admins can view all notifications" ON notifications;
CREATE POLICY "Admins can view all notifications"
  ON notifications FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

-- ========================================
-- ACTIVITY LOG
-- ========================================

DROP POLICY IF EXISTS "Admins can view all activity logs" ON activity_log;
CREATE POLICY "Admins can view all activity logs"
  ON activity_log FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = auth.uid() 
      AND profiles.is_admin = true
    )
  );

-- Commento
COMMENT ON TABLE profiles IS 'Profili utenti. Gli admin (is_admin = true) hanno accesso completo a tutti i dati della piattaforma.';
