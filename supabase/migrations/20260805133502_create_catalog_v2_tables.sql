/*
# Catalogo V2 - LHIMO

1. New Tables
- `catalog_macro_categories`: top-level categories (id, name, slug, icon, sort_order, is_active)
- `catalog_micro_categories`: sub-categories linked to macro (id, macro_category_id, name, slug, sort_order, is_active)
- `business_specializations`: specializations linked to macro (id, macro_category_id, name, sort_order, is_active)
- `business_services`: services linked to macro (id, macro_category_id, name, sort_order, is_active)
2. Security
- RLS enabled on all tables
- Public read access (anon + authenticated) for all catalog tables
- No write access from frontend (admin only via service role)
3. Notes
- All tables use uuid primary keys
- sort_order for custom ordering
- is_active flag to enable/disable items without deleting
*/

-- Macro Categories
CREATE TABLE IF NOT EXISTS public.catalog_macro_categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  slug text UNIQUE,
  icon text,
  sort_order integer NOT NULL DEFAULT 0,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.catalog_macro_categories ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "public_read_macro_categories" ON public.catalog_macro_categories;
CREATE POLICY "public_read_macro_categories" ON public.catalog_macro_categories
  FOR SELECT TO anon, authenticated USING (true);

-- Micro Categories
CREATE TABLE IF NOT EXISTS public.catalog_micro_categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  macro_category_id uuid NOT NULL REFERENCES public.catalog_macro_categories(id) ON DELETE CASCADE,
  name text NOT NULL,
  slug text,
  sort_order integer NOT NULL DEFAULT 0,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.catalog_micro_categories ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "public_read_micro_categories" ON public.catalog_micro_categories;
CREATE POLICY "public_read_micro_categories" ON public.catalog_micro_categories
  FOR SELECT TO anon, authenticated USING (true);

CREATE INDEX IF NOT EXISTS idx_catalog_micro_macro_id ON public.catalog_micro_categories(macro_category_id);

-- Business Specializations
CREATE TABLE IF NOT EXISTS public.business_specializations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  macro_category_id uuid NOT NULL REFERENCES public.catalog_macro_categories(id) ON DELETE CASCADE,
  name text NOT NULL,
  sort_order integer NOT NULL DEFAULT 0,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.business_specializations ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "public_read_specializations" ON public.business_specializations;
CREATE POLICY "public_read_specializations" ON public.business_specializations
  FOR SELECT TO anon, authenticated USING (true);

CREATE INDEX IF NOT EXISTS idx_specializations_macro_id ON public.business_specializations(macro_category_id);

-- Business Services
CREATE TABLE IF NOT EXISTS public.business_services (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  macro_category_id uuid NOT NULL REFERENCES public.catalog_macro_categories(id) ON DELETE CASCADE,
  name text NOT NULL,
  sort_order integer NOT NULL DEFAULT 0,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.business_services ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "public_read_services" ON public.business_services;
CREATE POLICY "public_read_services" ON public.business_services
  FOR SELECT TO anon, authenticated USING (true);

CREATE INDEX IF NOT EXISTS idx_services_macro_id ON public.business_services(macro_category_id);

-- Seed some initial macro categories
INSERT INTO public.catalog_macro_categories (name, slug, sort_order, is_active)
VALUES
  ('Ristorazione', 'ristorazione', 1, true),
  ('Alloggio', 'alloggio', 2, true),
  ('Artigianato', 'artigianato', 3, true),
  ('Commercio', 'commercio', 4, true),
  ('Servizi Professionali', 'servizi-professionali', 5, true),
  ('Salute e Benessere', 'salute-benessere', 6, true),
  ('Trasporti', 'trasporti', 7, true),
  ('Istruzione', 'istruzione', 8, true),
  ('Agricoltura', 'agricoltura', 9, true),
  ('Industria', 'industria', 10, true)
ON CONFLICT DO NOTHING;
