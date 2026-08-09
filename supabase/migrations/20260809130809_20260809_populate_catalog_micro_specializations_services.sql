/*
# Populate catalog_micro_categories, business_specializations, and business_services

## Problem
The catalog_v2 tables (catalog_micro_categories, business_specializations, business_services) are empty.
The form uses these tables for the micro category, specializations, and services dropdowns.
The old business_categories table has 257 child categories under 54 parent categories,
but the parent slugs don't match the 10 catalog_macro_categories slugs.

## Solution
1. Map old business_categories parent slugs to catalog_macro_categories by slug similarity
2. Insert child categories into catalog_micro_categories linked to the matching macro category
3. For parents with no slug match, create new macro categories from them
4. Seed business_specializations with common specializations per macro category
5. Seed business_services with common services per macro category

## Tables affected
- catalog_micro_categories: populated with child categories from business_categories
- business_specializations: seeded with common specializations
- business_services: seeded with common services
- catalog_macro_categories: may add new macro categories for unmatched old parents

## Security
- No RLS changes (tables already have public read policies)
*/

-- Step 1: Insert all child categories from business_categories into catalog_micro_categories
-- mapping by parent slug -> catalog_macro_categories slug
INSERT INTO catalog_micro_categories (macro_category_id, name, slug, sort_order, is_active)
SELECT
  cmc.id,
  child.name,
  child.slug,
  ROW_NUMBER() OVER (PARTITION BY cmc.id ORDER BY child.name) - 1,
  true
FROM business_categories child
JOIN business_categories parent ON child.parent_id = parent.id
JOIN catalog_macro_categories cmc ON parent.slug = cmc.slug
WHERE child.parent_id IS NOT NULL
  AND child.is_catalog_v2 = false
ON CONFLICT DO NOTHING;

-- Step 2: For old parent categories that DON'T match any catalog_macro_categories slug,
-- create new macro categories and then insert their children
INSERT INTO catalog_macro_categories (name, slug, sort_order, is_active)
SELECT
  parent.name,
  parent.slug,
  100 + ROW_NUMBER() OVER (ORDER BY parent.name),
  true
FROM business_categories parent
WHERE parent.parent_id IS NULL
  AND parent.is_catalog_v2 = false
  AND parent.slug NOT IN (SELECT slug FROM catalog_macro_categories)
  AND EXISTS (SELECT 1 FROM business_categories c WHERE c.parent_id = parent.id)
ON CONFLICT DO NOTHING;

-- Now insert children for newly created macro categories
INSERT INTO catalog_micro_categories (macro_category_id, name, slug, sort_order, is_active)
SELECT
  cmc.id,
  child.name,
  child.slug,
  ROW_NUMBER() OVER (PARTITION BY cmc.id ORDER BY child.name) - 1,
  true
FROM business_categories child
JOIN business_categories parent ON child.parent_id = parent.id
JOIN catalog_macro_categories cmc ON parent.slug = cmc.slug
WHERE child.parent_id IS NOT NULL
  AND child.is_catalog_v2 = false
ON CONFLICT DO NOTHING;

-- Step 3: Seed business_specializations for each macro category
-- Using common Italian business specializations
INSERT INTO business_specializations (macro_category_id, name, sort_order, is_active)
SELECT cmc.id, spec.name, spec.sort_order, true
FROM catalog_macro_categories cmc
JOIN (VALUES
  ('ristorazione', 'Cucina italiana tradizionale', 0),
  ('ristorazione', 'Cucina regionale', 1),
  ('ristorazione', 'Cucina internazionale', 2),
  ('ristorazione', 'Cucina vegetariana/vegana', 3),
  ('ristorazione', 'Pizzeria', 4),
  ('ristorazione', 'Gelateria', 5),
  ('ristorazione', 'Pasticceria', 6),
  ('ristorazione', 'Catering ed eventi', 7),
  ('alloggio', 'Hotel', 0),
  ('alloggio', 'Bed and Breakfast', 1),
  ('alloggio', 'Agriturismo', 2),
  ('alloggio', 'Casa vacanze', 3),
  ('alloggio', 'Ostello', 4),
  ('artigianato', 'Artigianato tradizionale', 0),
  ('artigianato', 'Artigianato artistico', 1),
  ('artigianato', 'Restauro', 2),
  ('commercio', 'Alimentari', 0),
  ('commercio', 'Abbigliamento', 1),
  ('commercio', 'Elettronica', 2),
  ('commercio', 'Arredamento', 3),
  ('servizi-professionali', 'Consulenza aziendale', 0),
  ('servizi-professionali', 'Consulenza legale', 1),
  ('servizi-professionali', 'Consulenza fiscale', 2),
  ('servizi-professionali', 'Consulenza del lavoro', 3),
  ('salute-benessere', 'Medicina generale', 0),
  ('salute-benessere', 'Dentista', 1),
  ('salute-benessere', 'Fisioterapia', 2),
  ('salute-benessere', 'Estetica', 3),
  ('salute-benessere', 'Parrucchiere', 4),
  ('salute-benessere', 'Barbiere', 5),
  ('trasporti', 'Trasporto persone', 0),
  ('trasporti', 'Trasporto merci', 1),
  ('trasporti', 'Noleggio veicoli', 2),
  ('istruzione', 'Scuola infanzia', 0),
  ('istruzione', 'Scuola primaria', 1),
  ('istruzione', 'Formazione professionale', 2),
  ('istruzione', 'Ripetizioni private', 3),
  ('istruzione', 'Corsi lingue', 4),
  ('agricoltura', 'Agricoltura biologica', 0),
  ('agricoltura', 'Allevamento', 1),
  ('agricoltura', 'Viticoltura', 2),
  ('agricoltura', 'Olivicoltura', 3),
  ('industria', 'Metalmeccanica', 0),
  ('industria', 'Alimentare', 1),
  ('industria', 'Tessile', 2),
  ('industria', 'Chimica', 3)
) AS spec(slug, name, sort_order)
ON cmc.slug = spec.slug
ON CONFLICT DO NOTHING;

-- Step 4: Seed business_services for each macro category
INSERT INTO business_services (macro_category_id, name, sort_order, is_active)
SELECT cmc.id, svc.name, svc.sort_order, true
FROM catalog_macro_categories cmc
JOIN (VALUES
  ('ristorazione', 'Consegna a domicilio', 0),
  ('ristorazione', 'Asporto', 1),
  ('ristorazione', 'Prenotazione online', 2),
  ('ristorazione', 'Sala privata', 3),
  ('ristorazione', 'Menu per celiaci', 4),
  ('ristorazione', 'Wi-Fi gratuito', 5),
  ('ristorazione', 'Parcheggio', 6),
  ('alloggio', 'Wi-Fi gratuito', 0),
  ('alloggio', 'Parcheggio', 1),
  ('alloggio', 'Colazione inclusa', 2),
  ('alloggio', 'Animali ammessi', 3),
  ('alloggio', 'Servizio in camera', 4),
  ('alloggio', 'Reception 24h', 5),
  ('artigianato', 'Riparazioni', 0),
  ('artigianato', 'Lavori su misura', 1),
  ('artigianato', 'Consulenza personalizzata', 2),
  ('artigianato', 'Consegna a domicilio', 3),
  ('commercio', 'Consegna a domicilio', 0),
  ('commercio', 'Ritiro in negozio', 1),
  ('commercio', 'Pagamenti digitali', 2),
  ('commercio', 'Carta fedeltà', 3),
  ('commercio', 'Reso gratuito', 4),
  ('servizi-professionali', 'Consulenza online', 0),
  ('servizi-professionali', 'Appuntamenti', 1),
  ('servizi-professionali', 'Fatturazione elettronica', 2),
  ('servizi-professionali', 'Pratiche telematiche', 3),
  ('salute-benessere', 'Prenotazione online', 0),
  ('salute-benessere', 'Visite domiciliari', 1),
  ('salute-benessere', 'Accettazione assicurazioni', 2),
  ('salute-benessere', 'Pagamenti digitali', 3),
  ('salute-benessere', 'Appuntamenti', 4),
  ('trasporti', 'Servizio 24h', 0),
  ('trasporti', 'Tracking spedizioni', 1),
  ('trasporti', 'Assicurazione merci', 2),
  ('istruzione', 'Corsi online', 0),
  ('istruzione', 'Certificazioni riconosciute', 1),
  ('istruzione', 'Stage e tirocini', 2),
  ('istruzione', 'Borse di studio', 3),
  ('agricoltura', 'Vendita diretta', 0),
  ('agricoltura', 'Prodotti biologici', 1),
  ('agricoltura', 'Degustazioni', 2),
  ('agricoltura', 'Visite guidate', 3),
  ('industria', 'Produzione su misura', 0),
  ('industria', 'Certificazione qualità', 1),
  ('industria', 'Spedizioni internazionali', 2)
) AS svc(slug, name, sort_order)
ON cmc.slug = svc.slug
ON CONFLICT DO NOTHING;

-- Step 5: Also seed specializations and services for newly created macro categories
-- (the ones created from old business_categories parents that didn't match)
INSERT INTO business_specializations (macro_category_id, name, sort_order, is_active)
SELECT cmc.id, 'Specializzazione generale', 0, true
FROM catalog_macro_categories cmc
WHERE cmc.sort_order >= 100
  AND NOT EXISTS (
    SELECT 1 FROM business_specializations bs WHERE bs.macro_category_id = cmc.id
  )
ON CONFLICT DO NOTHING;

INSERT INTO business_services (macro_category_id, name, sort_order, is_active)
SELECT cmc.id, 'Servizio generale', 0, true
FROM catalog_macro_categories cmc
WHERE cmc.sort_order >= 100
  AND NOT EXISTS (
    SELECT 1 FROM business_services bs WHERE bs.macro_category_id = cmc.id
  )
ON CONFLICT DO NOTHING;
