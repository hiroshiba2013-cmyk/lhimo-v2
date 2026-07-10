/*
  # Add family member support to reports

  1. Modified Tables
    - `reports`
      - Added `family_member_id` (uuid, nullable) - tracks which family member made the report
      - Added foreign key to customer_family_members
  
  2. Important notes
    - Existing reports keep family_member_id as NULL (attributed to account owner)
    - When a family member makes a report, their ID is now stored
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reports' AND column_name = 'family_member_id'
  ) THEN
    ALTER TABLE reports ADD COLUMN family_member_id uuid REFERENCES customer_family_members(id) ON DELETE SET NULL;
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_reports_family_member_id ON reports(family_member_id);
