/*
  # Add Job Views Tracking System

  ## Overview
  This migration creates a table to track when users view job postings, allowing them to mark jobs as "viewed" so they don't need to review them again.

  ## New Tables
  
  ### job_views
  - `id` (uuid, primary key)
  - `job_posting_id` (uuid, foreign key to job_postings)
  - `user_id` (uuid, foreign key to auth.users)
  - `viewed_at` (timestamptz) - When the job was viewed
  - `created_at` (timestamptz)

  ## Security
  - Enable RLS on job_views table
  - Users can only view and create their own job views
  - Unique constraint to prevent duplicate views

  ## Important Notes
  - Only authenticated users can track viewed jobs
  - Each user can only mark a job as viewed once (unique constraint)
  - This helps users keep track of which jobs they've already reviewed
*/

CREATE TABLE IF NOT EXISTS job_views (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  job_posting_id uuid NOT NULL REFERENCES job_postings(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  viewed_at timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now(),
  UNIQUE(job_posting_id, user_id)
);

ALTER TABLE job_views ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own job views"
  ON job_views FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "Users can create their own job views"
  ON job_views FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid());

CREATE INDEX idx_job_views_user_id ON job_views(user_id);
CREATE INDEX idx_job_views_job_posting_id ON job_views(job_posting_id);
CREATE INDEX idx_job_views_viewed_at ON job_views(viewed_at);
