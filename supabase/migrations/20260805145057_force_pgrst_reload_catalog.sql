-- Force PostgREST schema cache reload by altering a known table
-- and re-notifying
COMMENT ON TABLE catalog_macro_categories IS 'Catalog V2 - Macro categories for business classification';
COMMENT ON TABLE catalog_micro_categories IS 'Catalog V2 - Micro categories for business classification';
COMMENT ON TABLE business_specializations IS 'Catalog V2 - Business specializations';
COMMENT ON TABLE business_services IS 'Catalog V2 - Business services';

-- Grant explicit table-level privileges to the authenticator role
-- (PostgREST connects as authenticator, then SET ROLE to anon/authenticated)
GRANT USAGE ON SCHEMA public TO authenticator;
GRANT SELECT ON catalog_macro_categories TO authenticator;
GRANT SELECT ON catalog_micro_categories TO authenticator;
GRANT SELECT ON business_specializations TO authenticator;
GRANT SELECT ON business_services TO authenticator;

NOTIFY pgrst, 'reload schema';