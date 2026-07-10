/*
  # Add Category to Job Postings

  1. Changes
    - Add category_id column to job_postings table to categorize job offers
    - Add foreign key constraint to business_categories
    - Create index for performance

  2. Security
    - No RLS changes needed, inherits existing policies
*/

-- Add category_id to job_postings
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'category_id'
  ) THEN
    ALTER TABLE job_postings ADD COLUMN category_id uuid REFERENCES business_categories(id);
    CREATE INDEX IF NOT EXISTS idx_job_postings_category_id ON job_postings(category_id);
  END IF;
END $$;
