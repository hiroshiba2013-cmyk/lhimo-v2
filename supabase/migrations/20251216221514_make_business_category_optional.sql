/*
  # Make business category_id optional

  1. Changes
    - Alter `businesses` table to make `category_id` nullable
    - This allows businesses to be created without immediately selecting a category
    
  2. Notes
    - Category can be updated later through the profile/business settings
    - Existing data is preserved
*/

ALTER TABLE businesses ALTER COLUMN category_id DROP NOT NULL;
