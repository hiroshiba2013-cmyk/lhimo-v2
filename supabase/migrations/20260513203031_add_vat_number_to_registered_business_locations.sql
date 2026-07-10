/*
  # Add vat_number to registered_business_locations

  Adds the vat_number column to registered_business_locations so each
  registered location can store its own VAT number, matching the existing
  column already present on business_locations.
*/

ALTER TABLE registered_business_locations
  ADD COLUMN IF NOT EXISTS vat_number text;
