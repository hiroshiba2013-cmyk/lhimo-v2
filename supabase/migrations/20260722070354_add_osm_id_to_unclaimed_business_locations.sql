-- Add osm_id column for OSM import deduplication
ALTER TABLE unclaimed_business_locations ADD COLUMN IF NOT EXISTS osm_id text;
CREATE INDEX IF NOT EXISTS idx_unclaimed_business_locations_osm_id ON unclaimed_business_locations(osm_id);
