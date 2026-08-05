-- Force PostgREST schema reload by doing a real ALTER TABLE
ALTER TABLE catalog_macro_categories ADD COLUMN IF NOT EXISTS pgrst_reload_flag text DEFAULT null;
ALTER TABLE catalog_macro_categories DROP COLUMN IF EXISTS pgrst_reload_flag;

ALTER TABLE catalog_micro_categories ADD COLUMN IF NOT EXISTS pgrst_reload_flag text DEFAULT null;
ALTER TABLE catalog_micro_categories DROP COLUMN IF EXISTS pgrst_reload_flag;

ALTER TABLE business_specializations ADD COLUMN IF NOT EXISTS pgrst_reload_flag text DEFAULT null;
ALTER TABLE business_specializations DROP COLUMN IF EXISTS pgrst_reload_flag;

ALTER TABLE business_services ADD COLUMN IF NOT EXISTS pgrst_reload_flag text DEFAULT null;
ALTER TABLE business_services DROP COLUMN IF EXISTS pgrst_reload_flag;