/*
  # Cleanup duplicate unclaimed_business_locations - non-alphabetic names

  Handles entries whose name starts with numbers, symbols, spaces, etc.
  Also removes placeholder names like '-' or empty.
*/

-- Remove placeholder names
DELETE FROM unclaimed_business_locations
WHERE name = '-' OR TRIM(name) = '' OR name IS NULL;

-- Remove duplicates for non-alpha names
DELETE FROM unclaimed_business_locations
WHERE id IN (
  SELECT id FROM unclaimed_business_locations
  WHERE upper(left(name, 1)) < 'A' OR upper(left(name, 1)) > 'Z'
  AND id NOT IN (
    SELECT DISTINCT ON (name, city) id
    FROM unclaimed_business_locations
    WHERE upper(left(name, 1)) < 'A' OR upper(left(name, 1)) > 'Z'
    ORDER BY name, city, created_at ASC
  )
);
