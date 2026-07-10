/*
  # Add Approval System for User-Added Businesses

  ## Summary
  This migration adds a proper approval workflow for businesses added by users,
  mirroring the review approval system. Businesses now start as "pending" and
  must be approved by admins before points are awarded and the business is visible.

  ## Changes

  ### Modified Tables
  - `unclaimed_business_locations`
    - Add `approval_status` column: 'pending' | 'approved' | 'rejected' (default 'pending' for user-added, null for imported)
    - Add `approved_at` timestamp
    - Add `approved_by` uuid (admin who approved)
    - Add `rejection_reason` text
    - Add `points_awarded` boolean to track if points have been given

  ## Notes
  - Imported businesses (added_by IS NULL) keep approval_status NULL (not subject to approval)
  - User-added businesses (added_by IS NOT NULL) start as 'pending'
  - Points are only awarded when admin approves (not on submission)
  - Already verified businesses are set to 'approved'
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'unclaimed_business_locations' AND column_name = 'approval_status'
  ) THEN
    ALTER TABLE unclaimed_business_locations ADD COLUMN approval_status text;
    ALTER TABLE unclaimed_business_locations ADD COLUMN approved_at timestamptz;
    ALTER TABLE unclaimed_business_locations ADD COLUMN approved_by uuid;
    ALTER TABLE unclaimed_business_locations ADD COLUMN rejection_reason text;
    ALTER TABLE unclaimed_business_locations ADD COLUMN points_awarded boolean DEFAULT false;
  END IF;
END $$;

UPDATE unclaimed_business_locations
SET approval_status = 'approved', points_awarded = true
WHERE added_by IS NOT NULL AND verification_badge = 'verified';

UPDATE unclaimed_business_locations
SET approval_status = 'pending', points_awarded = false
WHERE added_by IS NOT NULL AND verification_badge IS NULL AND approval_status IS NULL;
