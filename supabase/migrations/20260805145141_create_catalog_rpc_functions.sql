-- Create RPC functions to fetch catalog data as a workaround for PostgREST schema cache issue
-- These functions are SECURITY DEFINER so they bypass RLS and run as postgres

CREATE OR REPLACE FUNCTION get_catalog_macro_categories()
RETURNS TABLE (
  id uuid,
  name text,
  slug text,
  icon text,
  sort_order integer,
  is_active boolean
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT id, name, slug, icon, sort_order, is_active
  FROM catalog_macro_categories
  WHERE is_active = true
  ORDER BY sort_order, name;
$$;

CREATE OR REPLACE FUNCTION get_catalog_micro_categories(p_macro_category_id uuid DEFAULT NULL)
RETURNS TABLE (
  id uuid,
  macro_category_id uuid,
  name text,
  slug text,
  sort_order integer,
  is_active boolean
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT id, macro_category_id, name, slug, sort_order, is_active
  FROM catalog_micro_categories
  WHERE is_active = true
  AND ($1 IS NULL OR macro_category_id = $1)
  ORDER BY sort_order, name;
$$;

CREATE OR REPLACE FUNCTION get_business_specializations(p_macro_category_id uuid DEFAULT NULL)
RETURNS TABLE (
  id uuid,
  macro_category_id uuid,
  name text,
  sort_order integer,
  is_active boolean
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT id, macro_category_id, name, sort_order, is_active
  FROM business_specializations
  WHERE is_active = true
  AND ($1 IS NULL OR macro_category_id = $1)
  ORDER BY sort_order, name;
$$;

CREATE OR REPLACE FUNCTION get_business_services(p_macro_category_id uuid DEFAULT NULL)
RETURNS TABLE (
  id uuid,
  macro_category_id uuid,
  name text,
  sort_order integer,
  is_active boolean
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT id, macro_category_id, name, sort_order, is_active
  FROM business_services
  WHERE is_active = true
  AND ($1 IS NULL OR macro_category_id = $1)
  ORDER BY sort_order, name;
$$;

-- Grant access to anon and authenticated
GRANT EXECUTE ON FUNCTION get_catalog_macro_categories() TO anon, authenticated;
GRANT EXECUTE ON FUNCTION get_catalog_micro_categories(uuid) TO anon, authenticated;
GRANT EXECUTE ON FUNCTION get_business_specializations(uuid) TO anon, authenticated;
GRANT EXECUTE ON FUNCTION get_business_services(uuid) TO anon, authenticated;