/*
# Drop broken guess_category_id function

The function contained hardcoded fake UUIDs that don't exist in business_categories,
causing FK constraint violations. Category assignment was done via direct UPDATE
statements instead, so the function is no longer needed.
*/

DROP FUNCTION IF EXISTS public.guess_category_id(text);
