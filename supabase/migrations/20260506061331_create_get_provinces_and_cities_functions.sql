/*
  # Create helper functions for province and city dropdowns

  Returns distinct province names and cities by province from comuni_italiani,
  bypassing the default 1000-row limit on direct table queries.
*/

CREATE OR REPLACE FUNCTION get_province_list()
RETURNS TABLE(provincia text)
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT DISTINCT provincia FROM comuni_italiani ORDER BY provincia;
$$;

CREATE OR REPLACE FUNCTION get_comuni_by_provincia(p_provincia text)
RETURNS TABLE(comune text)
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT comune FROM comuni_italiani WHERE provincia = p_provincia ORDER BY comune;
$$;
