/*
  # Add category_id to registered_business_locations

  Each business location can optionally have its own category,
  allowing different branches to be categorized differently from the parent business.

  Changes:
  - Add `category_id` (uuid, nullable, FK to business_categories) to registered_business_locations
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'registered_business_locations' AND column_name = 'category_id'
  ) THEN
    ALTER TABLE registered_business_locations
      ADD COLUMN category_id uuid REFERENCES business_categories(id);
  END IF;
END $$;
