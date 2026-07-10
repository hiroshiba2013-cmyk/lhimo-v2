/*
  # Remove remaining overloaded functions

  PostgREST cannot disambiguate overloaded functions.
  Drop older/simpler overloads, keeping only the most complete version.

  - get_business_ratings: both have pronargs=1 but different types (uuid vs uuid[])
    PostgREST identifies by name only, so any overload causes issues.
    Keep the uuid[] version (used by ProfilePage for batch ratings).
    The single-uuid version is legacy — drop it.

  - send_notification: keep 6-param version (adds target_family_member_id)
    Drop 5-param version.

  - log_user_activity: keep 9-param version (adds p_family_member_id)
    Drop 8-param version.
*/

-- get_business_ratings: drop single-uuid version, keep uuid[] version
DROP FUNCTION IF EXISTS public.get_business_ratings(uuid);

-- send_notification: drop 5-param version, keep 6-param
DROP FUNCTION IF EXISTS public.send_notification(uuid, text, text, text, jsonb);

-- log_user_activity: drop 8-param version, keep 9-param
DROP FUNCTION IF EXISTS public.log_user_activity(uuid, text, text, text, integer, jsonb, text, text);
