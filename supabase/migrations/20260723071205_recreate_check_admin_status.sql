CREATE OR REPLACE FUNCTION public.check_admin_status(p_user_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
SELECT EXISTS (
  SELECT 1 FROM public.admins WHERE user_id = p_user_id
);
$$;

GRANT EXECUTE ON FUNCTION public.check_admin_status(uuid) TO authenticated;
