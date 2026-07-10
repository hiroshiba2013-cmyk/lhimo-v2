/*
  # Aggiunta Categoria Distributori di Carburante

  1. Nuove Categorie
    - `Distributori di Carburante` - Stazioni di servizio, distributori benzina/diesel/GPL/metano
  
  2. Codici ATECO
    - 47.30.00 - Commercio al dettaglio di carburanti per autotrazione
*/

-- Inserisci la nuova categoria solo se non esiste già
INSERT INTO business_categories (name, slug, description, ateco_code)
SELECT 
  'Distributori di Carburante',
  'distributori-carburante',
  'Stazioni di servizio per rifornimento carburante (benzina, diesel, GPL, metano, elettrico)',
  '47.30.00'
WHERE NOT EXISTS (
  SELECT 1 FROM business_categories 
  WHERE name = 'Distributori di Carburante'
);
