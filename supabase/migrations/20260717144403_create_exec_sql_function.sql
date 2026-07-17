CREATE OR REPLACE FUNCTION public.exec_sql(sql_text text)
RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  EXECUTE sql_text;
  RETURN 'OK';
END;
$$;

GRANT EXECUTE ON FUNCTION public.exec_sql(text) TO authenticated, anon, service_role;
