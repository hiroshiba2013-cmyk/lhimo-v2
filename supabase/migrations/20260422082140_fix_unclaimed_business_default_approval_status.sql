/*
  # Fix unclaimed_business_locations default approval_status

  1. Changes
    - Set default value for approval_status to 'pending' on unclaimed_business_locations table
    - This ensures all user-added businesses start as pending and require admin approval

  2. Important Notes
    - Imported businesses (added_by IS NULL) already have approval_status = NULL which is unaffected
    - Only new user-added businesses will default to 'pending'
*/

ALTER TABLE unclaimed_business_locations
ALTER COLUMN approval_status SET DEFAULT 'pending';
