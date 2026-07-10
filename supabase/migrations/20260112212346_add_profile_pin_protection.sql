/*
  # Add PIN Protection for Profiles

  1. Changes
    - Add `pin_code` column to `profiles` table (optional, encrypted)
    - Add `pin_code` column to `customer_family_members` table (optional, encrypted)
    - Add `pin_enabled` boolean flags to enable/disable PIN protection
    
  2. Security
    - PIN codes are stored as text (will be hashed on client side before storage)
    - Users can optionally enable PIN protection for their profiles
    - Family members can also have individual PIN protection
*/

-- Add PIN protection to profiles table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'pin_enabled'
  ) THEN
    ALTER TABLE profiles ADD COLUMN pin_enabled boolean DEFAULT false;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'pin_code'
  ) THEN
    ALTER TABLE profiles ADD COLUMN pin_code text;
  END IF;
END $$;

-- Add PIN protection to customer_family_members table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'customer_family_members' AND column_name = 'pin_enabled'
  ) THEN
    ALTER TABLE customer_family_members ADD COLUMN pin_enabled boolean DEFAULT false;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'customer_family_members' AND column_name = 'pin_code'
  ) THEN
    ALTER TABLE customer_family_members ADD COLUMN pin_code text;
  END IF;
END $$;

-- Add comments for documentation
COMMENT ON COLUMN profiles.pin_enabled IS 'Whether PIN protection is enabled for this profile';
COMMENT ON COLUMN profiles.pin_code IS 'Hashed PIN code for profile protection (optional)';
COMMENT ON COLUMN customer_family_members.pin_enabled IS 'Whether PIN protection is enabled for this family member';
COMMENT ON COLUMN customer_family_members.pin_code IS 'Hashed PIN code for family member protection (optional)';
