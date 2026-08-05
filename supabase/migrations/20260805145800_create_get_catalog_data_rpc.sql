-- Create a single RPC function that returns all catalog data as JSON
-- This function will be called via exec_sql since PostgREST schema cache is stale
-- We'll use a SECURITY DEFINER function that returns json

CREATE OR REPLACE FUNCTION get_catalog_data(p_type text DEFAULT 'macro', p_macro_id text DEFAULT NULL)
RETURNS json
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT CASE
    WHEN p_type = 'macro' THEN (
      SELECT json_agg(json_build_object('id', id, 'name', name, 'slug', slug))
      FROM business_categories
      WHERE parent_id IS NULL
      AND name IN ('Ristorazione','Alloggio','Artigianato','Commercio','Servizi Professionali','Salute e Benessere','Trasporti','Istruzione','Agricoltura','Industria')
    )
    WHEN p_type = 'micro' THEN (
      SELECT json_agg(json_build_object('id', id, 'name', name, 'slug', slug, 'macro_category_id', parent_id))
      FROM business_categories
      WHERE parent_id = p_macro_id::uuid
    )
    WHEN p_type = 'specializations' THEN (
      SELECT COALESCE(json_agg(json_build_object('id', id, 'name', name, 'macro_category_id', macro_category_id)), '[]'::json)
      FROM business_specializations
      WHERE is_active = true
      AND (p_macro_id IS NULL OR macro_category_id = p_macro_id::uuid)
    )
    WHEN p_type = 'services' THEN (
      SELECT COALESCE(json_agg(json_build_object('id', id, 'name', name, 'macro_category_id', macro_category_id)), '[]'::json)
      FROM business_services
      WHERE is_active = true
      AND (p_macro_id IS NULL OR macro_category_id = p_macro_id::uuid)
    )
    ELSE '[]'::json
  END;
$$;

GRANT EXECUTE ON FUNCTION get_catalog_data(text, text) TO anon, authenticated;