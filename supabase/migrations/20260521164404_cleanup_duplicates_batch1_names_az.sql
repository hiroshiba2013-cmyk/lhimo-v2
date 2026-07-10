/*
  # Cleanup duplicate unclaimed_business_locations - batch A-M

  Deletes duplicate rows (keeping oldest per name+city) for businesses
  whose name starts with A through M. Split into batches to avoid timeout.
*/

DELETE FROM unclaimed_business_locations
WHERE id IN (
  SELECT id FROM unclaimed_business_locations
  WHERE upper(left(name, 1)) BETWEEN 'A' AND 'M'
  AND id NOT IN (
    SELECT DISTINCT ON (name, city) id
    FROM unclaimed_business_locations
    WHERE upper(left(name, 1)) BETWEEN 'A' AND 'M'
    ORDER BY name, city, created_at ASC
  )
);
