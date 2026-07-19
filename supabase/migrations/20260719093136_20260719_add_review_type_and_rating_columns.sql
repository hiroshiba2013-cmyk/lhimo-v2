
/*
# Aggiungi colonne rating specifiche per tipo a reviews

## Problema
ReviewsPage.tsx e ReviewForm.tsx usano colonne di rating specifiche per tipo
(review_type, price_rating, booking_management_rating, ecc.) che non esistono
nella tabella reviews, causando errori PostgREST 400.

## Colonne aggiunte a reviews
- review_type: tipo di recensione (booking, quote, customer_service, problem_solving, ecc.)
- price_rating, service_rating, quality_rating: rating generici
- booking_management_rating, reliability_rating, organization_rating, experience_rating: rating prenotazioni
- booking_gestione_prenotazione: rating specifico prenotazioni IT
- registered_business_id: FK al business registrato
*/

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='review_type') THEN
    ALTER TABLE public.reviews ADD COLUMN review_type text;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='price_rating') THEN
    ALTER TABLE public.reviews ADD COLUMN price_rating integer;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='service_rating') THEN
    ALTER TABLE public.reviews ADD COLUMN service_rating integer;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='quality_rating') THEN
    ALTER TABLE public.reviews ADD COLUMN quality_rating integer;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='booking_management_rating') THEN
    ALTER TABLE public.reviews ADD COLUMN booking_management_rating integer;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='reliability_rating') THEN
    ALTER TABLE public.reviews ADD COLUMN reliability_rating integer;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='organization_rating') THEN
    ALTER TABLE public.reviews ADD COLUMN organization_rating integer;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='experience_rating') THEN
    ALTER TABLE public.reviews ADD COLUMN experience_rating integer;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='booking_gestione_prenotazione') THEN
    ALTER TABLE public.reviews ADD COLUMN booking_gestione_prenotazione integer;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='registered_business_id') THEN
    ALTER TABLE public.reviews ADD COLUMN registered_business_id uuid REFERENCES public.registered_businesses(id) ON DELETE SET NULL;
  END IF;
  -- Colonne aggiunte da ReviewForm per rating dettagliati
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='booking_affidabilita') THEN
    ALTER TABLE public.reviews ADD COLUMN booking_affidabilita integer;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='booking_organizzazione') THEN
    ALTER TABLE public.reviews ADD COLUMN booking_organizzazione integer;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='booking_comunicazione') THEN
    ALTER TABLE public.reviews ADD COLUMN booking_comunicazione integer;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='quote_chiarezza') THEN
    ALTER TABLE public.reviews ADD COLUMN quote_chiarezza integer;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='quote_trasparenza') THEN
    ALTER TABLE public.reviews ADD COLUMN quote_trasparenza integer;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='quote_tempistiche_risposta') THEN
    ALTER TABLE public.reviews ADD COLUMN quote_tempistiche_risposta integer;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='quote_disponibilita') THEN
    ALTER TABLE public.reviews ADD COLUMN quote_disponibilita integer;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='cs_cortesia') THEN
    ALTER TABLE public.reviews ADD COLUMN cs_cortesia integer;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='cs_competenza') THEN
    ALTER TABLE public.reviews ADD COLUMN cs_competenza integer;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='cs_rapidita') THEN
    ALTER TABLE public.reviews ADD COLUMN cs_rapidita integer;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='cs_risoluzione_problema') THEN
    ALTER TABLE public.reviews ADD COLUMN cs_risoluzione_problema integer;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='problem_affidabilita') THEN
    ALTER TABLE public.reviews ADD COLUMN problem_affidabilita integer;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='problem_organizzazione') THEN
    ALTER TABLE public.reviews ADD COLUMN problem_organizzazione integer;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='problem_gestione_problema') THEN
    ALTER TABLE public.reviews ADD COLUMN problem_gestione_problema integer;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='problem_comunicazione') THEN
    ALTER TABLE public.reviews ADD COLUMN problem_comunicazione integer;
  END IF;
END $$;
