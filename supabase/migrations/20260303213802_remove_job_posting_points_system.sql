/*
  # Rimuovi Sistema Punti per Annunci di Lavoro

  ## Panoramica
  Rimuove completamente il sistema di punti per gli annunci di lavoro.
  Gli annunci di lavoro non dovrebbero assegnare né sottrarre punti.

  ## Modifiche
  1. Rimuove il trigger per l'assegnazione punti alla creazione
  2. Rimuove il trigger per la sottrazione punti all'eliminazione
  3. Rimuove le funzioni associate

  ## Note
  - Gli annunci di lavoro sono ora completamente esclusi dal sistema punti
  - Questo non influisce sugli altri sistemi di punti (recensioni, attività, annunci classificati)
*/

-- Rimuovi il trigger per l'assegnazione punti alla creazione di annunci di lavoro
DROP TRIGGER IF EXISTS trigger_award_points_job_posting ON job_postings;

-- Rimuovi il trigger per la sottrazione punti all'eliminazione di annunci di lavoro
DROP TRIGGER IF EXISTS trigger_subtract_points_deleted_job_posting ON job_postings;

-- Rimuovi le funzioni associate
DROP FUNCTION IF EXISTS award_points_for_job_posting();
DROP FUNCTION IF EXISTS subtract_points_for_deleted_job_posting();
