/*
  # Create Job Postings and Applications Tables

  ## Overview
  This migration creates tables for job postings from businesses and job applications from users.

  ## New Tables
  
  ### job_postings
  - `id` (uuid, primary key)
  - `business_id` (uuid, foreign key to businesses)
  - `title` (text) - Job title
  - `description` (text) - Job description and requirements
  - `position_type` (text) - Full-time, Part-time, Contract, etc.
  - `salary_min` (numeric) - Minimum salary
  - `salary_max` (numeric) - Maximum salary
  - `salary_currency` (text) - Currency (EUR, USD, etc.)
  - `location` (text) - Job location/city
  - `required_skills` (text array) - Skills required
  - `experience_level` (text) - Junior, Mid, Senior
  - `published_at` (timestamptz)
  - `expires_at` (timestamptz) - Job posting expiration date
  - `status` (text) - active, closed, expired
  - `created_at` (timestamptz)
  - `updated_at` (timestamptz)

  ### job_applications
  - `id` (uuid, primary key)
  - `job_posting_id` (uuid, foreign key to job_postings)
  - `user_id` (uuid, foreign key to auth.users)
  - `status` (text) - pending, reviewed, accepted, rejected
  - `cover_letter` (text) - Applicant cover letter
  - `resume_url` (text) - URL to applicant resume
  - `applied_at` (timestamptz)
  - `reviewed_at` (timestamptz)
  - `created_at` (timestamptz)

  ## Security
  - Enable RLS on both tables
  - Add policies for businesses to manage their postings
  - Add policies for users to view postings and submit applications
  - Add policies for businesses to view applications to their postings
*/

CREATE TABLE IF NOT EXISTS job_postings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id uuid NOT NULL REFERENCES businesses(id) ON DELETE CASCADE,
  title text NOT NULL,
  description text NOT NULL,
  position_type text NOT NULL DEFAULT 'Full-time',
  salary_min numeric,
  salary_max numeric,
  salary_currency text DEFAULT 'EUR',
  location text NOT NULL,
  required_skills text[] DEFAULT '{}',
  experience_level text DEFAULT 'Mid',
  published_at timestamptz DEFAULT now(),
  expires_at timestamptz NOT NULL,
  status text DEFAULT 'active',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS job_applications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  job_posting_id uuid NOT NULL REFERENCES job_postings(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  status text DEFAULT 'pending',
  cover_letter text,
  resume_url text,
  applied_at timestamptz DEFAULT now(),
  reviewed_at timestamptz,
  created_at timestamptz DEFAULT now(),
  UNIQUE(job_posting_id, user_id)
);

ALTER TABLE job_postings ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_applications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view active job postings"
  ON job_postings FOR SELECT
  USING (status = 'active' AND expires_at > now());

CREATE POLICY "Businesses can view their own postings"
  ON job_postings FOR SELECT
  TO authenticated
  USING (business_id IN (SELECT id FROM businesses WHERE owner_id = auth.uid()));

CREATE POLICY "Businesses can create job postings"
  ON job_postings FOR INSERT
  TO authenticated
  WITH CHECK (
    business_id IN (SELECT id FROM businesses WHERE owner_id = auth.uid())
  );

CREATE POLICY "Businesses can update their own postings"
  ON job_postings FOR UPDATE
  TO authenticated
  USING (business_id IN (SELECT id FROM businesses WHERE owner_id = auth.uid()))
  WITH CHECK (business_id IN (SELECT id FROM businesses WHERE owner_id = auth.uid()));

CREATE POLICY "Businesses can delete their own postings"
  ON job_postings FOR DELETE
  TO authenticated
  USING (business_id IN (SELECT id FROM businesses WHERE owner_id = auth.uid()));

CREATE POLICY "Users can view applications they submitted"
  ON job_applications FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "Businesses can view applications to their postings"
  ON job_applications FOR SELECT
  TO authenticated
  USING (
    job_posting_id IN (
      SELECT id FROM job_postings 
      WHERE business_id IN (SELECT id FROM businesses WHERE owner_id = auth.uid())
    )
  );

CREATE POLICY "Authenticated users can apply to jobs"
  ON job_applications FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update their own applications"
  ON job_applications FOR UPDATE
  TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

CREATE INDEX idx_job_postings_business_id ON job_postings(business_id);
CREATE INDEX idx_job_postings_status ON job_postings(status);
CREATE INDEX idx_job_postings_expires_at ON job_postings(expires_at);
CREATE INDEX idx_job_applications_job_posting_id ON job_applications(job_posting_id);
CREATE INDEX idx_job_applications_user_id ON job_applications(user_id);
CREATE INDEX idx_job_applications_status ON job_applications(status);