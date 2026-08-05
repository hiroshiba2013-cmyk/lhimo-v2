-- Add a column to mark catalog V2 entries in business_categories
ALTER TABLE business_categories ADD COLUMN IF NOT EXISTS is_catalog_v2 boolean DEFAULT false;

-- Mark all catalog macro categories (parent_id IS NULL and ID in catalog_macro_categories)
UPDATE business_categories SET is_catalog_v2 = true
WHERE id IN (SELECT id FROM catalog_macro_categories);

-- Mark all catalog micro categories (parent_id IS NOT NULL and ID in catalog_micro_categories)
UPDATE business_categories SET is_catalog_v2 = true
WHERE id IN (SELECT id FROM catalog_micro_categories);

-- Grant anon access to the new column
GRANT SELECT ON business_categories TO anon, authenticated;