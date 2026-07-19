
/*
# Fix get_comuni_by_provincia: drop e ricrea con alias comune

## Problema
Componente legge r.comune, funzione restituisce nome → sempre vuoto.
*/

DROP FUNCTION IF EXISTS public.get_comuni_by_provincia(text);

CREATE FUNCTION public.get_comuni_by_provincia(p_provincia text)
RETURNS TABLE(comune text, sigla text)
LANGUAGE sql STABLE SECURITY DEFINER SET search_path TO 'public'
AS $$
SELECT nome AS comune, COALESCE(provincia_sigla, sigla_provincia) AS sigla
FROM comuni_italiani
WHERE COALESCE(provincia_sigla, sigla_provincia) = p_provincia
ORDER BY nome;
$$;

GRANT EXECUTE ON FUNCTION public.get_comuni_by_provincia(text) TO anon, authenticated, service_role;
