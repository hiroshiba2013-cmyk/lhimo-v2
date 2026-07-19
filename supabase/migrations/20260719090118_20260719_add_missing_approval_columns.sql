
/*
# Aggiungi colonne mancanti per il sistema di approvazione

## Problema
Le funzioni approve/reject non possono funzionare perché mancano colonne nelle tabelle principali.

## Colonne aggiunte
- classified_ads: approved_by, approved_at, approval_notes, points_awarded, registered_business_location_id
- reviews: family_member_id, approved_by, approved_at, proof_documents
- job_postings: approved_by, approved_at, approval_notes, company_name, user_id
*/

DO $$ BEGIN
  -- classified_ads
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='classified_ads' AND column_name='approved_by') THEN
    ALTER TABLE public.classified_ads ADD COLUMN approved_by uuid REFERENCES auth.users(id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='classified_ads' AND column_name='approved_at') THEN
    ALTER TABLE public.classified_ads ADD COLUMN approved_at timestamptz;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='classified_ads' AND column_name='approval_notes') THEN
    ALTER TABLE public.classified_ads ADD COLUMN approval_notes text;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='classified_ads' AND column_name='points_awarded') THEN
    ALTER TABLE public.classified_ads ADD COLUMN points_awarded integer DEFAULT 0;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='classified_ads' AND column_name='registered_business_location_id') THEN
    ALTER TABLE public.classified_ads ADD COLUMN registered_business_location_id uuid REFERENCES public.registered_business_locations(id) ON DELETE SET NULL;
  END IF;

  -- reviews
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='family_member_id') THEN
    ALTER TABLE public.reviews ADD COLUMN family_member_id uuid REFERENCES public.customer_family_members(id) ON DELETE SET NULL;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='approved_by') THEN
    ALTER TABLE public.reviews ADD COLUMN approved_by uuid REFERENCES auth.users(id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='approved_at') THEN
    ALTER TABLE public.reviews ADD COLUMN approved_at timestamptz;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='reviews' AND column_name='proof_documents') THEN
    ALTER TABLE public.reviews ADD COLUMN proof_documents text[];
  END IF;

  -- job_postings
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='job_postings' AND column_name='approved_by') THEN
    ALTER TABLE public.job_postings ADD COLUMN approved_by uuid REFERENCES auth.users(id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='job_postings' AND column_name='approved_at') THEN
    ALTER TABLE public.job_postings ADD COLUMN approved_at timestamptz;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='job_postings' AND column_name='approval_notes') THEN
    ALTER TABLE public.job_postings ADD COLUMN approval_notes text;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='job_postings' AND column_name='company_name') THEN
    ALTER TABLE public.job_postings ADD COLUMN company_name text;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='job_postings' AND column_name='user_id') THEN
    ALTER TABLE public.job_postings ADD COLUMN user_id uuid REFERENCES auth.users(id);
  END IF;
END $$;
