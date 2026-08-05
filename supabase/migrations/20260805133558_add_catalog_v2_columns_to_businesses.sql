/*
# Add Catalog V2 columns to business tables

1. Modified Tables
- `businesses`: add macro_category_id, micro_category_id, specialization_ids (jsonb), service_ids (jsonb)
- `registered_businesses`: add macro_category_id, micro_category_id, specialization_ids (jsonb), service_ids (jsonb)
- `business_locations`: add macro_category_id, micro_category_id, specialization_ids (jsonb), service_ids (jsonb)
- `unclaimed_business_locations`: add macro_category_id, micro_category_id
2. Notes
- specialization_ids and service_ids store arrays of UUIDs as jsonb
- macro_category_id and micro_category_id are nullable for backwards compatibility
*/

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'businesses' AND column_name = 'macro_category_id') THEN
    ALTER TABLE public.businesses ADD COLUMN macro_category_id uuid;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'businesses' AND column_name = 'micro_category_id') THEN
    ALTER TABLE public.businesses ADD COLUMN micro_category_id uuid;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'businesses' AND column_name = 'specialization_ids') THEN
    ALTER TABLE public.businesses ADD COLUMN specialization_ids jsonb DEFAULT '[]';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'businesses' AND column_name = 'service_ids') THEN
    ALTER TABLE public.businesses ADD COLUMN service_ids jsonb DEFAULT '[]';
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'registered_businesses' AND column_name = 'macro_category_id') THEN
    ALTER TABLE public.registered_businesses ADD COLUMN macro_category_id uuid;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'registered_businesses' AND column_name = 'micro_category_id') THEN
    ALTER TABLE public.registered_businesses ADD COLUMN micro_category_id uuid;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'registered_businesses' AND column_name = 'specialization_ids') THEN
    ALTER TABLE public.registered_businesses ADD COLUMN specialization_ids jsonb DEFAULT '[]';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'registered_businesses' AND column_name = 'service_ids') THEN
    ALTER TABLE public.registered_businesses ADD COLUMN service_ids jsonb DEFAULT '[]';
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'business_locations' AND column_name = 'macro_category_id') THEN
    ALTER TABLE public.business_locations ADD COLUMN macro_category_id uuid;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'business_locations' AND column_name = 'micro_category_id') THEN
    ALTER TABLE public.business_locations ADD COLUMN micro_category_id uuid;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'business_locations' AND column_name = 'specialization_ids') THEN
    ALTER TABLE public.business_locations ADD COLUMN specialization_ids jsonb DEFAULT '[]';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'business_locations' AND column_name = 'service_ids') THEN
    ALTER TABLE public.business_locations ADD COLUMN service_ids jsonb DEFAULT '[]';
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'unclaimed_business_locations' AND column_name = 'macro_category_id') THEN
    ALTER TABLE public.unclaimed_business_locations ADD COLUMN macro_category_id uuid;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'unclaimed_business_locations' AND column_name = 'micro_category_id') THEN
    ALTER TABLE public.unclaimed_business_locations ADD COLUMN micro_category_id uuid;
  END IF;
END $$;
