/*
  # Fix ambiguous award_points function

  ## Problem
  There are two versions of `award_points` with overlapping signatures:
  1. `award_points(uuid, integer, text, text DEFAULT NULL)` - old version without family member support
  2. `award_points(uuid, integer, text, text DEFAULT '', uuid DEFAULT NULL)` - new version with family member support

  When triggers call `award_points(uuid, integer, text, text)` with 4 arguments,
  Postgres cannot determine which function to use, causing ERROR 42725.

  This breaks classified_ads inserts (and any other trigger using award_points).

  ## Fix
  Drop the old function signature so only the new complete version remains.
*/

-- Drop the old version (without family_member_id parameter)
DROP FUNCTION IF EXISTS award_points(uuid, integer, text, text);
