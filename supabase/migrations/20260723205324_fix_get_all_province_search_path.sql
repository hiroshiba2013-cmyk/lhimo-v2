-- Fix: get_all_province needs SET search_path for PostgREST to expose it
DROP FUNCTION IF EXISTS public.get_all_province();
CREATE OR REPLACE FUNCTION public.get_all_province()
RETURNS TABLE(sigla text, nome text, regione text)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT DISTINCT
    COALESCE(sigla_provincia, provincia_sigla) AS sigla,
    nome_provincia AS nome,
    regione
  FROM comuni_italiani
  WHERE COALESCE(sigla_provincia, provincia_sigla) IS NOT NULL
  ORDER BY nome;
$$;

GRANT EXECUTE ON FUNCTION public.get_all_province() TO PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_all_province() TO anon, authenticated, service_role;
