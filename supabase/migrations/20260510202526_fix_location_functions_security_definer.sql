/*
  # Fix location RPC functions - add SECURITY DEFINER

  The functions get_all_province, get_province_by_regione, get_comuni_by_provincia
  run as SECURITY INVOKER which can cause issues with RLS even when the table
  has a public read policy. Recreate them as SECURITY DEFINER so they always
  have access to comuni_italiani regardless of the calling user's context.
*/

CREATE OR REPLACE FUNCTION get_all_province()
RETURNS TABLE(provincia text, sigla text)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT DISTINCT ci.provincia, ci.sigla
  FROM comuni_italiani ci
  ORDER BY ci.provincia;
$$;

CREATE OR REPLACE FUNCTION get_province_by_regione(p_regione text)
RETURNS TABLE(provincia text, sigla text)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT DISTINCT ci.provincia, ci.sigla
  FROM comuni_italiani ci
  WHERE ci.regione = p_regione
  ORDER BY ci.provincia;
$$;

CREATE OR REPLACE FUNCTION get_comuni_by_provincia(p_provincia text)
RETURNS TABLE(comune text)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT ci.comune
  FROM comuni_italiani ci
  WHERE ci.sigla = p_provincia
  ORDER BY ci.comune;
$$;
