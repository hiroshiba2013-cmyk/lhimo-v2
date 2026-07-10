/*
  # Add category_id to profiles (customer users) and customer_family_members

  Customer users and their family members can now select a personal category
  (e.g., their profession or area of interest). This category will be shown
  on user-added business locations in search results.

  Changes:
  - Add `category_id` (uuid, nullable, FK to business_categories) to profiles
  - Add `category_id` (uuid, nullable, FK to business_categories) to customer_family_members
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'category_id'
  ) THEN
    ALTER TABLE profiles
      ADD COLUMN category_id uuid REFERENCES business_categories(id);
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'customer_family_members' AND column_name = 'category_id'
  ) THEN
    ALTER TABLE customer_family_members
      ADD COLUMN category_id uuid REFERENCES business_categories(id);
  END IF;
END $$;
