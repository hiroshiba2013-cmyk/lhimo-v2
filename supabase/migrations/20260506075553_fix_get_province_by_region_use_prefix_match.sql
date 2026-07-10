/*
  # Fix get_province_by_region to use prefix/contains match

  The comuni_italiani table has region names like:
    - "Trentino-Alto Adige/Sdtirol"
    - "Valle d'Aosta/Valle d'Aoste"
  
  The frontend sends "Trentino-Alto Adige" and "Valle d'Aosta".
  Using ILIKE with a leading wildcard ensures partial matches work correctly.
*/

CREATE OR REPLACE FUNCTION public.get_province_by_region(p_regione text)
RETURNS TABLE(provincia text)
LANGUAGE sql
STABLE SECURITY DEFINER
AS $$
  SELECT DISTINCT provincia
  FROM comuni_italiani
  WHERE regione ILIKE p_regione || '%'
  ORDER BY provincia;
$$;
