/*
  # Fix Foreign Key for User Profile in Classified Ads

  1. Changes
    - Drop corrupted foreign key constraint
    - Recreate foreign key constraint between classified_ads.user_id and profiles.id
    - This enables automatic joins in Supabase queries
  
  2. Security
    - All existing ads reference valid user IDs in profiles table
    - Foreign key set to CASCADE on delete for automatic cleanup
*/

-- Drop the corrupted constraint if it exists
DO $$ 
BEGIN
    ALTER TABLE classified_ads DROP CONSTRAINT IF EXISTS classified_ads_user_id_fkey;
EXCEPTION
    WHEN undefined_object THEN NULL;
END $$;

-- Add foreign key constraint from classified_ads to profiles
ALTER TABLE classified_ads
ADD CONSTRAINT classified_ads_user_id_fkey 
FOREIGN KEY (user_id) 
REFERENCES profiles(id) 
ON DELETE CASCADE;
