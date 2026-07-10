/*
  # Add Ad Type and Expand Categories

  1. Changes to classified_ads table
    - Add `ad_type` field (enum: 'sell' or 'buy')
    - Default to 'sell' for existing ads

  2. New Classified Categories
    - Add multiple new categories for different types of items
    - Categories include: Electronics, Vehicles, Real Estate, Jobs, Services, etc.

  3. Indexes
    - Add index on ad_type for faster filtering
*/

-- Add ad_type enum
DO $$ BEGIN
  CREATE TYPE ad_type_enum AS ENUM ('sell', 'buy');
EXCEPTION
  WHEN duplicate_object THEN null;
END $$;

-- Add ad_type column to classified_ads
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'classified_ads' AND column_name = 'ad_type'
  ) THEN
    ALTER TABLE classified_ads ADD COLUMN ad_type ad_type_enum DEFAULT 'sell' NOT NULL;
  END IF;
END $$;

-- Create index on ad_type
CREATE INDEX IF NOT EXISTS idx_classified_ads_ad_type ON classified_ads(ad_type);

-- Add more classified categories (only if they don't exist)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM classified_categories WHERE name = 'Elettronica') THEN
    INSERT INTO classified_categories (name, icon, description) VALUES
      ('Elettronica', '📱', 'Smartphone, computer, tablet, accessori elettronici'),
      ('Abbigliamento e Accessori', '👔', 'Vestiti, scarpe, borse, gioielli'),
      ('Casa e Giardino', '🏠', 'Mobili, elettrodomestici, decorazioni, attrezzi da giardino'),
      ('Sport e Hobby', '⚽', 'Attrezzature sportive, biciclette, strumenti musicali'),
      ('Libri e Riviste', '📚', 'Libri, fumetti, riviste, materiale didattico'),
      ('Giochi e Console', '🎮', 'Videogiochi, console, giochi da tavolo'),
      ('Bambini e Neonati', '👶', 'Abbigliamento, giocattoli, passeggini, articoli per neonati'),
      ('Animali', '🐾', 'Accessori per animali, prodotti per la cura'),
      ('Motori', '🚗', 'Auto, moto, scooter, accessori per veicoli'),
      ('Immobili', '🏘️', 'Vendita e affitto case, appartamenti, terreni'),
      ('Lavoro', '💼', 'Offerte e ricerca di lavoro'),
      ('Servizi', '🔧', 'Riparazioni, pulizie, traslochi, consulenze'),
      ('Musica e Film', '🎵', 'CD, DVD, vinili, strumenti musicali'),
      ('Collezionismo', '🎨', 'Oggetti da collezione, antiquariato, opere d''arte'),
      ('Altro', '📦', 'Articoli vari non classificabili nelle altre categorie');
  END IF;
END $$;