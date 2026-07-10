/*
  # Add get_all_province function

  Returns all distinct provinces (with sigla) from comuni_italiani,
  used by AdminLocationFilter to allow filtering by province without
  requiring a region to be selected first.
*/

CREATE OR REPLACE FUNCTION get_all_province()
RETURNS TABLE(provincia text, sigla text)
LANGUAGE sql
STABLE
AS $$
  SELECT DISTINCT ci.provincia, ci.sigla
  FROM comuni_italiani ci
  ORDER BY ci.provincia;
$$;
