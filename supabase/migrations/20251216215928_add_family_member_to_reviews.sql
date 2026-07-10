/*
  # Add family member association to reviews

  1. Changes
    - Add `family_member_id` column to `reviews` table to track which family member wrote the review
    - Add foreign key constraint to `customer_family_members` table
    - Add index for performance

  2. Notes
    - Column is nullable to support reviews written by the main profile
    - Existing reviews will have NULL family_member_id (written by main profile)
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'family_member_id'
  ) THEN
    ALTER TABLE reviews ADD COLUMN family_member_id uuid REFERENCES customer_family_members(id) ON DELETE SET NULL;
    CREATE INDEX IF NOT EXISTS idx_reviews_family_member_id ON reviews(family_member_id);
  END IF;
END $$;
