-- Drop and recreate RLS policies for catalog tables to force PostgREST schema reload

-- catalog_macro_categories
DROP POLICY IF EXISTS public_read_macro_categories ON catalog_macro_categories;
ALTER TABLE catalog_macro_categories DISABLE ROW LEVEL SECURITY;
ALTER TABLE catalog_macro_categories ENABLE ROW LEVEL SECURITY;
CREATE POLICY public_read_macro_categories ON catalog_macro_categories
  FOR SELECT TO anon, authenticated USING (true);

-- catalog_micro_categories
DROP POLICY IF EXISTS public_read_micro_categories ON catalog_micro_categories;
ALTER TABLE catalog_micro_categories DISABLE ROW LEVEL SECURITY;
ALTER TABLE catalog_micro_categories ENABLE ROW LEVEL SECURITY;
CREATE POLICY public_read_micro_categories ON catalog_micro_categories
  FOR SELECT TO anon, authenticated USING (true);

-- business_specializations
DROP POLICY IF EXISTS public_read_specializations ON business_specializations;
ALTER TABLE business_specializations DISABLE ROW LEVEL SECURITY;
ALTER TABLE business_specializations ENABLE ROW LEVEL SECURITY;
CREATE POLICY public_read_specializations ON business_specializations
  FOR SELECT TO anon, authenticated USING (true);

-- business_services
DROP POLICY IF EXISTS public_read_services ON business_services;
ALTER TABLE business_services DISABLE ROW LEVEL SECURITY;
ALTER TABLE business_services ENABLE ROW LEVEL SECURITY;
CREATE POLICY public_read_services ON business_services
  FOR SELECT TO anon, authenticated USING (true);

-- Ensure grants are correct
GRANT SELECT ON catalog_macro_categories TO anon, authenticated;
GRANT SELECT ON catalog_micro_categories TO anon, authenticated;
GRANT SELECT ON business_specializations TO anon, authenticated;
GRANT SELECT ON business_services TO anon, authenticated;

-- Notify PostgREST to reload schema
NOTIFY pgrst, 'reload schema';