/*
  # Add FK from reviews to registered_business_locations

  The reviews.business_location_id column currently only has a FK to business_locations.
  Business users who registered directly use registered_business_locations instead.
  This adds a second FK so PostgREST can join reviews to registered_business_locations.

  Since reviews.business_location_id can reference either table (legacy or registered),
  we drop the existing FK constraint and store the relationship at the application level.
  The join in queries is done without a FK hint — we simply remove the broken join from
  queries and fetch location data separately.

  No schema changes needed here — the fix is in the application queries.
  This migration is a no-op placeholder to document the architectural decision.
*/

-- No DDL changes: the fix is in application code (removed invalid FK join from queries).
SELECT 1;
