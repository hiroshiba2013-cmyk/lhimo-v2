/*
  # Create professional_profiles table

  ## Summary
  Adds a `professional_profiles` table linked to the `profiles` table (customer accounts).
  This is the "professional profile" feature for private users (user_type = 'customer').

  ## New Tables
  - `professional_profiles`
    - `id` (uuid, PK)
    - `user_id` (uuid, FK → profiles.id, unique — one profile per user)
    - `profession` (text) - job title / profession
    - `city` (text) - city of residence/work
    - `province` (text)
    - `region` (text)
    - `experience_years` (integer) - years of professional experience
    - `summary` (text) - short bio / description
    - `skills` (text[]) - list of skills
    - `created_at`, `updated_at` (timestamptz)

  ## Security
  - RLS enabled
  - Owners can SELECT/INSERT/UPDATE/DELETE their own row
  - Business users can SELECT all profiles (they need to view candidates)
  - Public cannot read — visibility is restricted to authenticated business users
*/

CREATE TABLE IF NOT EXISTS professional_profiles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  profession text NOT NULL DEFAULT '',
  city text NOT NULL DEFAULT '',
  province text NOT NULL DEFAULT '',
  region text NOT NULL DEFAULT '',
  experience_years integer NOT NULL DEFAULT 0,
  summary text NOT NULL DEFAULT '',
  skills text[] NOT NULL DEFAULT '{}',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT professional_profiles_user_id_unique UNIQUE (user_id)
);

ALTER TABLE professional_profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Owner can view own professional profile"
  ON professional_profiles FOR SELECT
  TO authenticated
  USING (
    auth.uid() = user_id
    OR EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
        AND profiles.user_type = 'business'
    )
  );

CREATE POLICY "Owner can insert own professional profile"
  ON professional_profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Owner can update own professional profile"
  ON professional_profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Owner can delete own professional profile"
  ON professional_profiles FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

CREATE INDEX IF NOT EXISTS professional_profiles_user_id_idx ON professional_profiles(user_id);

CREATE OR REPLACE FUNCTION update_professional_profile_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER professional_profiles_updated_at
  BEFORE UPDATE ON professional_profiles
  FOR EACH ROW EXECUTE FUNCTION update_professional_profile_updated_at();
