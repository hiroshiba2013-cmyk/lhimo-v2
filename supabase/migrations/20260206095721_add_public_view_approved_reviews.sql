/*
  # Allow public viewing of approved reviews

  1. Changes
    - Add policy to allow anonymous (non-authenticated) users to view approved reviews
    - This ensures that all visitors can see business reviews without needing to log in

  2. Security
    - Only approved reviews are visible to anonymous users
    - Maintains existing authenticated user policies
*/

-- Policy per permettere agli utenti anonimi di vedere le recensioni approvate
CREATE POLICY "Anonymous users can view approved reviews"
  ON reviews FOR SELECT
  TO anon
  USING (review_status = 'approved');
