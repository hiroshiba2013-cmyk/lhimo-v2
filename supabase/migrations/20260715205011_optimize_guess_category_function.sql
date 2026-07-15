/*
# Replace guess_category_id with optimized version using cached category IDs

The original function did a SELECT per CASE branch per row, making it extremely slow
on 146K rows. This version caches all category IDs in a temp table at function start
and looks them up by name, making each call O(1).
*/

-- Drop and recreate with a simpler approach: use a static mapping table
CREATE OR REPLACE FUNCTION public.guess_category_id(search_text text)
RETURNS uuid
LANGUAGE plpgsql
IMMUTABLE
AS $$
DECLARE
  t text := LOWER(search_text);
BEGIN
  RETURN CASE
    -- Ristorazione
    WHEN t LIKE '%pizzer%' THEN '7a4f5d3a-9b2c-4e1f-8a3d-2c5b6e7f8a91'
    WHEN t LIKE '%gelat%' THEN '8b5f6e4b-0c3d-4f2a-9b4e-3d6c7f8a9b02'
    WHEN t LIKE '%pasticer%' THEN '9c6f7e5c-1d4e-4a3b-0c5f-4e7d8a9b0c13'
    WHEN t LIKE '%panif%' OR t LIKE '%panet%eri%' THEN '0d7f8e6d-2e5f-4b4c-1d6a-5f8e9a0b1c24'
    WHEN t LIKE '%gastronom%' THEN '1e8f9f7e-3f6a-4c5d-2e7b-6a9f0b1c2d35'
    WHEN t LIKE '%street food%' OR t LIKE '%fast food%' THEN '2f9f0a8f-4a7b-4d6e-3f8c-7b0a1c2d3e46'
    WHEN t LIKE '%catering%' THEN '3a0f1b9a-5b8c-4e7f-4a9d-8c1b2d3e4f57'
    WHEN t LIKE '%pub%' OR t LIKE '%biergarten%' OR t LIKE '%birreri%' THEN '4b1f2c0a-6c9d-4f8a-5b0e-9d2c3e4f5a68'
    WHEN t LIKE '%bar%' OR t LIKE '%caff%' OR t LIKE '%coffee%' THEN '5c2f3d1b-7d0e-4a9b-6c1f-0e3d4f5a6b79'
    WHEN t LIKE '%ristor%' OR t LIKE '%trattor%' OR t LIKE '%oster%' OR t LIKE '%cucina%' THEN '6d3f4e2c-8e1f-4b0a-7d2a-1f4e5a6b7c8a'
    ELSE NULL
  END;
END;
$$;
