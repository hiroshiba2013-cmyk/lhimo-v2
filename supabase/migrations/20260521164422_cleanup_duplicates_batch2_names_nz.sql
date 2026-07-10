/*
  # Cleanup duplicate unclaimed_business_locations - batch N-Z

  Deletes duplicate rows (keeping oldest per name+city) for businesses
  whose name starts with N through Z.
*/

DELETE FROM unclaimed_business_locations
WHERE id IN (
  SELECT id FROM unclaimed_business_locations
  WHERE upper(left(name, 1)) > 'M'
  AND id NOT IN (
    SELECT DISTINCT ON (name, city) id
    FROM unclaimed_business_locations
    WHERE upper(left(name, 1)) > 'M'
    ORDER BY name, city, created_at ASC
  )
);
