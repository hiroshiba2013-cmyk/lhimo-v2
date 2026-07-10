/*
  # Add get_province_by_region function

  Returns provinces filtered by region from comuni_italiani table.
  Used by ItalianCityProvinceSelect to show only provinces belonging
  to the selected region when a region filter is active.
*/

CREATE OR REPLACE FUNCTION public.get_province_by_region(p_regione text)
RETURNS TABLE(provincia text)
LANGUAGE sql
STABLE SECURITY DEFINER
AS $$
  SELECT DISTINCT provincia
  FROM comuni_italiani
  WHERE regione ILIKE p_regione
  ORDER BY provincia;
$$;
