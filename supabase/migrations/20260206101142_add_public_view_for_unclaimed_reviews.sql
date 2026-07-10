/*
  # Add public view for unclaimed business reviews

  1. Changes
    - Update RLS policies to allow public viewing of approved reviews
    - This includes both claimed and unclaimed business reviews

  2. Security
    - Only approved reviews are visible to the public
    - Pending reviews remain private
*/

-- Drop existing public view policy
DROP POLICY IF EXISTS "Public can view approved reviews" ON reviews;

-- Create new policy for public viewing of approved reviews
CREATE POLICY "Public can view approved reviews"
  ON reviews FOR SELECT
  TO anon, authenticated
  USING (review_status = 'approved');
