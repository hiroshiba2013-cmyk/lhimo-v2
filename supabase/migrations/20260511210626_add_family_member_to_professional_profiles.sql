/*
  # Add family_member_id to professional_profiles

  ## Summary
  Allows each family member to have their own professional profile.
  Previously, professional_profiles had a UNIQUE constraint on user_id (one per account).
  Now a profile can belong to either the account owner (family_member_id IS NULL)
  or to a specific family member (family_member_id = some UUID).

  ## Changes
  - `professional_profiles`
    - Add column `family_member_id` (uuid, nullable, FK → customer_family_members.id ON DELETE CASCADE)
    - Drop old UNIQUE constraint on user_id alone
    - Add new UNIQUE constraint on (user_id, family_member_id) NULLS NOT DISTINCT

  ## Security
  - Owner can manage profiles for themselves and their family members
  - Business users and admins can read all profiles
*/

-- 1. Add the column
ALTER TABLE professional_profiles
  ADD COLUMN IF NOT EXISTS family_member_id uuid REFERENCES customer_family_members(id) ON DELETE CASCADE;

-- 2. Drop old unique constraint and add the composite one
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE table_name = 'professional_profiles'
      AND constraint_name = 'professional_profiles_user_id_unique'
  ) THEN
    ALTER TABLE professional_profiles DROP CONSTRAINT professional_profiles_user_id_unique;
  END IF;
END $$;

ALTER TABLE professional_profiles
  ADD CONSTRAINT professional_profiles_user_family_unique
  UNIQUE NULLS NOT DISTINCT (user_id, family_member_id);

-- 3. Index
CREATE INDEX IF NOT EXISTS professional_profiles_family_member_id_idx
  ON professional_profiles(family_member_id);

-- 4. Update RLS policies

DROP POLICY IF EXISTS "Owner can insert own professional profile" ON professional_profiles;
DROP POLICY IF EXISTS "Owner can update own professional profile" ON professional_profiles;
DROP POLICY IF EXISTS "Owner can delete own professional profile" ON professional_profiles;
DROP POLICY IF EXISTS "Owner can view own professional profile" ON professional_profiles;

-- SELECT: owner sees own + family; business users and admins see all
CREATE POLICY "Owner or business can view professional profiles"
  ON professional_profiles FOR SELECT
  TO authenticated
  USING (
    auth.uid() = user_id
    OR EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
        AND profiles.user_type = 'business'
    )
    OR is_admin()
  );

-- INSERT: account owner can create profiles for themselves or their family members
CREATE POLICY "Owner can insert professional profile"
  ON professional_profiles FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = user_id
    AND (
      family_member_id IS NULL
      OR EXISTS (
        SELECT 1 FROM customer_family_members
        WHERE customer_family_members.id = family_member_id
          AND customer_family_members.customer_id = auth.uid()
      )
    )
  );

-- UPDATE: account owner can update their own or family members' profiles
CREATE POLICY "Owner can update professional profile"
  ON professional_profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (
    auth.uid() = user_id
    AND (
      family_member_id IS NULL
      OR EXISTS (
        SELECT 1 FROM customer_family_members
        WHERE customer_family_members.id = family_member_id
          AND customer_family_members.customer_id = auth.uid()
      )
    )
  );

-- DELETE: account owner can delete their own or family members' profiles
CREATE POLICY "Owner can delete professional profile"
  ON professional_profiles FOR DELETE
  TO authenticated
  USING (
    auth.uid() = user_id
    AND (
      family_member_id IS NULL
      OR EXISTS (
        SELECT 1 FROM customer_family_members
        WHERE customer_family_members.id = family_member_id
          AND customer_family_members.customer_id = auth.uid()
      )
    )
  );
