/*
  # Fix featured ads duplicates from user_activity JOIN

  ## Problem
  The `get_featured_classified_ads` function joins `user_activity` on
  `user_id` only. When a user has multiple rows in `user_activity`
  (one per family member + one with NULL family_member_id), the JOIN
  produces duplicate rows for the same ad.

  ## Fix
  Filter the JOIN to only match the main user row (family_member_id IS NULL)
  so each ad appears exactly once.
*/

CREATE OR REPLACE FUNCTION get_featured_classified_ads(
  ad_type_filter text DEFAULT 'all',
  limit_count integer DEFAULT 6
)
RETURNS TABLE (
  id uuid,
  title text,
  description text,
  price numeric,
  ad_type text,
  category text,
  category_id uuid,
  location text,
  region text,
  province text,
  city text,
  images text[],
  user_id uuid,
  status text,
  created_at timestamptz,
  expires_at timestamptz,
  user_full_name text,
  user_nickname text,
  user_avatar_url text,
  user_points integer
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    ca.id,
    ca.title,
    ca.description,
    ca.price,
    ca.ad_type::text,
    COALESCE(cat.name, '') as category,
    ca.category_id,
    ca.location,
    ca.region,
    ca.province,
    ca.city,
    ca.images,
    ca.user_id,
    ca.status::text,
    ca.created_at,
    ca.expires_at,
    p.full_name as user_full_name,
    p.nickname as user_nickname,
    p.avatar_url as user_avatar_url,
    COALESCE(ua.total_points, 0) as user_points
  FROM classified_ads ca
  INNER JOIN profiles p ON ca.user_id = p.id
  LEFT JOIN user_activity ua ON ca.user_id = ua.user_id AND ua.family_member_id IS NULL
  LEFT JOIN classified_categories cat ON ca.category_id = cat.id
  WHERE ca.status = 'active'
    AND ca.expires_at > now()
    AND (ad_type_filter = 'all' OR ca.ad_type::text = ad_type_filter)
  ORDER BY
    COALESCE(ua.total_points, 0) DESC,
    ca.created_at DESC
  LIMIT limit_count;
END;
$$;
