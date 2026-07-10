/*
  # Remove overloaded versions of get_unread_notification_count

  PostgREST cannot disambiguate overloaded functions, causing 400 errors.
  Drop the 0-arg and 1-arg versions, keep only the 2-arg version which
  handles all cases (family_member_id and business_location_id).
*/

DROP FUNCTION IF EXISTS public.get_unread_notification_count();
DROP FUNCTION IF EXISTS public.get_unread_notification_count(uuid);
