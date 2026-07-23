-- Fix: recreate get_all_province and get_comuni_by_provincia with unquoted search_path
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

DROP FUNCTION IF EXISTS public.get_comuni_by_provincia(text);
CREATE OR REPLACE FUNCTION public.get_comuni_by_provincia(p_provincia text)
RETURNS TABLE(comune text, sigla text)
LANGUAGE sql
STABLE SECURITY DEFINER
SET search_path = public
AS $$
  SELECT nome AS comune, COALESCE(provincia_sigla, sigla_provincia) AS sigla
  FROM comuni_italiani
  WHERE COALESCE(provincia_sigla, sigla_provincia) = p_provincia
  ORDER BY nome;
$$;

GRANT EXECUTE ON FUNCTION public.get_comuni_by_provincia(text) TO PUBLIC;
