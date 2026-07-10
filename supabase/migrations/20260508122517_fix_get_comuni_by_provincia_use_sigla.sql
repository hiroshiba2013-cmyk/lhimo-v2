/*
  # Fix get_comuni_by_provincia function

  The function was querying `WHERE provincia = p_provincia` but the table uses
  `sigla` for the province code (e.g. 'VA') and `provincia` for the full name
  (e.g. 'Varese'). The admin filter passes the sigla code, so we fix the
  function to match on `sigla`.

  Also adds a secondary function to get comuni by full province name for flexibility.
*/

CREATE OR REPLACE FUNCTION get_comuni_by_provincia(p_provincia text)
RETURNS TABLE(comune text)
LANGUAGE sql
STABLE
AS $$
  SELECT ci.comune
  FROM comuni_italiani ci
  WHERE ci.sigla = p_provincia
  ORDER BY ci.comune;
$$;

-- Also expose by region for the region filter
CREATE OR REPLACE FUNCTION get_province_by_regione(p_regione text)
RETURNS TABLE(provincia text, sigla text)
LANGUAGE sql
STABLE
AS $$
  SELECT DISTINCT ci.provincia, ci.sigla
  FROM comuni_italiani ci
  WHERE ci.regione = p_regione
  ORDER BY ci.provincia;
$$;
