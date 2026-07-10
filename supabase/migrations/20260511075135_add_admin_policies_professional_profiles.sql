/*
  # Add admin access policies for professional_profiles

  ## Changes
  - Add SELECT policy: admins (is_admin = true in profiles) can view all professional profiles
  - Add UPDATE policy: admins can update any professional profile
  - Add DELETE policy: admins can delete any professional profile

  ## Notes
  Uses the is_admin flag on profiles table, consistent with how other admin policies work in this project.
*/

CREATE POLICY "Admins can view all professional profiles"
  ON professional_profiles FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
        AND profiles.is_admin = true
    )
  );

CREATE POLICY "Admins can update any professional profile"
  ON professional_profiles FOR UPDATE
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

CREATE POLICY "Admins can delete any professional profile"
  ON professional_profiles FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
        AND profiles.is_admin = true
    )
  );
