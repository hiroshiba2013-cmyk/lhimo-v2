/*
  # Create Featured Classified Ads Function

  1. New Functions
    - `get_featured_classified_ads` - Returns classified ads sorted by user activity points
      - Takes ad_type parameter ('sell', 'buy', 'gift', 'all')
      - Returns ads from most active users first
      - Includes user information and activity points
      - Limits to top ads

  2. Changes
    - Ads from users with higher total_points are prioritized
    - Only returns active ads
    - Sorted by user points DESC, then by created_at DESC
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
    ca.ad_type,
    ca.category,
    ca.location,
    ca.region,
    ca.province,
    ca.city,
    ca.images,
    ca.user_id,
    ca.status,
    ca.created_at,
    ca.expires_at,
    p.full_name as user_full_name,
    p.nickname as user_nickname,
    p.avatar_url as user_avatar_url,
    COALESCE(ua.total_points, 0) as user_points
  FROM classified_ads ca
  INNER JOIN profiles p ON ca.user_id = p.id
  LEFT JOIN user_activity ua ON ca.user_id = ua.user_id
  WHERE ca.status = 'active'
    AND ca.expires_at > now()
    AND (ad_type_filter = 'all' OR ca.ad_type = ad_type_filter)
  ORDER BY
    COALESCE(ua.total_points, 0) DESC,
    ca.created_at DESC
  LIMIT limit_count;
END;
$$;
