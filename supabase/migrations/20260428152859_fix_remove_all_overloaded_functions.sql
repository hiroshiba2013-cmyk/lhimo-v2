/*
  # Remove all overloaded functions to fix PostgREST ambiguity errors

  PostgREST cannot disambiguate overloaded functions and returns errors.
  Drop old overloads, keeping only the most complete version for each function.

  Functions cleaned up:
  - mark_all_notifications_read: keep 2-param version (family_member_id + business_location_id)
  - get_or_create_conversation: keep 8-param version (all context params)
  - get_location_ratings(uuid): keep only get_location_ratings(uuid[]) — the uuid[] version is used by ProfilePage
    The single-uuid version is superseded by get_location_ratings(uuid[])
*/

-- mark_all_notifications_read: drop 0-arg and 1-arg versions
DROP FUNCTION IF EXISTS public.mark_all_notifications_read();
DROP FUNCTION IF EXISTS public.mark_all_notifications_read(uuid);

-- get_or_create_conversation: drop 4-arg version (old, missing context params)
DROP FUNCTION IF EXISTS public.get_or_create_conversation(uuid, uuid, text, uuid);

-- get_location_ratings: two versions with same arg count but different types
-- uuid version (single location) vs uuid[] version (array)
-- They have different signatures so PostgREST CAN distinguish them by argument type
-- But keep both since they serve different callers - check if single-uuid is still used
-- Actually both have pronargs=1 so PostgREST CANNOT distinguish - drop single uuid version
-- ProfilePage uses uuid[] version; no frontend call uses single-uuid version
DROP FUNCTION IF EXISTS public.get_location_ratings(uuid);
