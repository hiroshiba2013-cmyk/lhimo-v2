/*
  # Create Job Seekers and Messaging System for Jobs

  ## Overview
  This migration creates a two-way job system:
  1. Job Seekers - Private users create "looking for work" ads
  2. Job Offers - Professional users (businesses) create job postings
  3. Messaging system for both types

  ## New Tables
  
  ### job_seekers
  - `id` (uuid, primary key)
  - `user_id` (uuid, foreign key to auth.users) - The person looking for work
  - `title` (text) - Job title seeking
  - `description` (text) - Personal description and experience
  - `skills` (text array) - Skills and competencies
  - `contract_type` (text) - Type of contract seeking (Full-time, Part-time, Contract, etc.)
  - `desired_salary_min` (numeric) - Minimum desired salary
  - `desired_salary_max` (numeric) - Maximum desired salary
  - `salary_currency` (text) - Currency (default EUR)
  - `location` (text) - Preferred work location
  - `available_from` (date) - When available to start
  - `experience_years` (integer) - Years of experience
  - `education_level` (text) - Education level
  - `status` (text) - active, paused, closed
  - `created_at` (timestamptz)
  - `updated_at` (timestamptz)

  ### job_seeker_conversations
  - `id` (uuid, primary key)
  - `job_seeker_id` (uuid, references job_seekers)
  - `employer_id` (uuid, references auth.users) - The business/employer interested
  - `seeker_id` (uuid, references auth.users) - The job seeker
  - `created_at` (timestamptz)
  - `updated_at` (timestamptz)
  - `last_message_at` (timestamptz)

  ### job_seeker_messages
  - `id` (uuid, primary key)
  - `conversation_id` (uuid, references job_seeker_conversations)
  - `sender_id` (uuid, references auth.users)
  - `message` (text)
  - `is_read` (boolean)
  - `created_at` (timestamptz)

  ### job_offer_conversations
  - `id` (uuid, primary key)
  - `job_posting_id` (uuid, references job_postings)
  - `applicant_id` (uuid, references auth.users) - The person interested in the job
  - `employer_id` (uuid, references auth.users) - The business owner
  - `created_at` (timestamptz)
  - `updated_at` (timestamptz)
  - `last_message_at` (timestamptz)

  ### job_offer_messages
  - `id` (uuid, primary key)
  - `conversation_id` (uuid, references job_offer_conversations)
  - `sender_id` (uuid, references auth.users)
  - `message` (text)
  - `is_read` (boolean)
  - `created_at` (timestamptz)

  ## Updates to Existing Tables

  ### job_postings
  - Add `company_name` (text) - Name of the company
  - Add `gross_annual_salary` (numeric) - Gross annual salary
  - Add `benefits` (text array) - Benefits offered
  - Add `remote_work` (boolean) - Remote work option
  - Add `required_languages` (text array) - Required languages

  ## Security
  - Enable RLS on all tables
  - Job seekers can manage their own ads
  - Businesses can view job seeker ads
  - Users can only see conversations they are part of
  - Users can only send messages to their conversations

  ## Indexes
  - Indexes on foreign keys for performance
  - Indexes on status fields for filtering
  - Indexes for conversation lookups
*/

-- Add new fields to job_postings
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'company_name'
  ) THEN
    ALTER TABLE job_postings ADD COLUMN company_name text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'gross_annual_salary'
  ) THEN
    ALTER TABLE job_postings ADD COLUMN gross_annual_salary numeric;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'benefits'
  ) THEN
    ALTER TABLE job_postings ADD COLUMN benefits text[] DEFAULT '{}';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'remote_work'
  ) THEN
    ALTER TABLE job_postings ADD COLUMN remote_work boolean DEFAULT false;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'job_postings' AND column_name = 'required_languages'
  ) THEN
    ALTER TABLE job_postings ADD COLUMN required_languages text[] DEFAULT '{}';
  END IF;
END $$;

-- Create job_seekers table
CREATE TABLE IF NOT EXISTS job_seekers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title text NOT NULL,
  description text NOT NULL,
  skills text[] DEFAULT '{}',
  contract_type text NOT NULL DEFAULT 'Full-time',
  desired_salary_min numeric,
  desired_salary_max numeric,
  salary_currency text DEFAULT 'EUR',
  location text NOT NULL,
  available_from date,
  experience_years integer DEFAULT 0,
  education_level text,
  status text DEFAULT 'active',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create job_seeker_conversations table
CREATE TABLE IF NOT EXISTS job_seeker_conversations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  job_seeker_id uuid NOT NULL REFERENCES job_seekers(id) ON DELETE CASCADE,
  employer_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  seeker_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  last_message_at timestamptz DEFAULT now(),
  UNIQUE(job_seeker_id, employer_id, seeker_id)
);

-- Create job_seeker_messages table
CREATE TABLE IF NOT EXISTS job_seeker_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id uuid NOT NULL REFERENCES job_seeker_conversations(id) ON DELETE CASCADE,
  sender_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  message text NOT NULL,
  is_read boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- Create job_offer_conversations table
CREATE TABLE IF NOT EXISTS job_offer_conversations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  job_posting_id uuid NOT NULL REFERENCES job_postings(id) ON DELETE CASCADE,
  applicant_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  employer_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  last_message_at timestamptz DEFAULT now(),
  UNIQUE(job_posting_id, applicant_id, employer_id)
);

-- Create job_offer_messages table
CREATE TABLE IF NOT EXISTS job_offer_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id uuid NOT NULL REFERENCES job_offer_conversations(id) ON DELETE CASCADE,
  sender_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  message text NOT NULL,
  is_read boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_job_seekers_user_id ON job_seekers(user_id);
CREATE INDEX IF NOT EXISTS idx_job_seekers_status ON job_seekers(status);
CREATE INDEX IF NOT EXISTS idx_job_seekers_location ON job_seekers(location);
CREATE INDEX IF NOT EXISTS idx_job_seekers_contract_type ON job_seekers(contract_type);

CREATE INDEX IF NOT EXISTS idx_job_seeker_conversations_job_seeker_id ON job_seeker_conversations(job_seeker_id);
CREATE INDEX IF NOT EXISTS idx_job_seeker_conversations_employer_id ON job_seeker_conversations(employer_id);
CREATE INDEX IF NOT EXISTS idx_job_seeker_conversations_seeker_id ON job_seeker_conversations(seeker_id);

CREATE INDEX IF NOT EXISTS idx_job_seeker_messages_conversation_id ON job_seeker_messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_job_seeker_messages_sender_id ON job_seeker_messages(sender_id);

CREATE INDEX IF NOT EXISTS idx_job_offer_conversations_job_posting_id ON job_offer_conversations(job_posting_id);
CREATE INDEX IF NOT EXISTS idx_job_offer_conversations_applicant_id ON job_offer_conversations(applicant_id);
CREATE INDEX IF NOT EXISTS idx_job_offer_conversations_employer_id ON job_offer_conversations(employer_id);

CREATE INDEX IF NOT EXISTS idx_job_offer_messages_conversation_id ON job_offer_messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_job_offer_messages_sender_id ON job_offer_messages(sender_id);

-- Enable RLS
ALTER TABLE job_seekers ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_seeker_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_seeker_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_offer_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_offer_messages ENABLE ROW LEVEL SECURITY;

-- RLS Policies for job_seekers

-- Anyone can view active job seeker ads
CREATE POLICY "Anyone can view active job seeker ads"
  ON job_seekers FOR SELECT
  USING (status = 'active');

-- Users can view their own ads regardless of status
CREATE POLICY "Users can view own job seeker ads"
  ON job_seekers FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

-- Users can create job seeker ads
CREATE POLICY "Users can create job seeker ads"
  ON job_seekers FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid());

-- Users can update their own ads
CREATE POLICY "Users can update own job seeker ads"
  ON job_seekers FOR UPDATE
  TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- Users can delete their own ads
CREATE POLICY "Users can delete own job seeker ads"
  ON job_seekers FOR DELETE
  TO authenticated
  USING (user_id = auth.uid());

-- RLS Policies for job_seeker_conversations

-- Users can view conversations they are part of
CREATE POLICY "Users can view own job seeker conversations"
  ON job_seeker_conversations FOR SELECT
  TO authenticated
  USING (auth.uid() = employer_id OR auth.uid() = seeker_id);

-- Employers can create conversations with job seekers
CREATE POLICY "Employers can create job seeker conversations"
  ON job_seeker_conversations FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = employer_id);

-- Users can update conversations they are part of
CREATE POLICY "Users can update own job seeker conversations"
  ON job_seeker_conversations FOR UPDATE
  TO authenticated
  USING (auth.uid() = employer_id OR auth.uid() = seeker_id)
  WITH CHECK (auth.uid() = employer_id OR auth.uid() = seeker_id);

-- RLS Policies for job_seeker_messages

-- Users can view messages from their conversations
CREATE POLICY "Users can view job seeker messages from own conversations"
  ON job_seeker_messages FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM job_seeker_conversations
      WHERE job_seeker_conversations.id = job_seeker_messages.conversation_id
      AND (job_seeker_conversations.employer_id = auth.uid() OR job_seeker_conversations.seeker_id = auth.uid())
    )
  );

-- Users can send messages to their conversations
CREATE POLICY "Users can send job seeker messages to own conversations"
  ON job_seeker_messages FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = sender_id
    AND EXISTS (
      SELECT 1 FROM job_seeker_conversations
      WHERE job_seeker_conversations.id = conversation_id
      AND (job_seeker_conversations.employer_id = auth.uid() OR job_seeker_conversations.seeker_id = auth.uid())
    )
  );

-- Users can update messages in their conversations
CREATE POLICY "Users can update job seeker messages in own conversations"
  ON job_seeker_messages FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM job_seeker_conversations
      WHERE job_seeker_conversations.id = job_seeker_messages.conversation_id
      AND (job_seeker_conversations.employer_id = auth.uid() OR job_seeker_conversations.seeker_id = auth.uid())
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM job_seeker_conversations
      WHERE job_seeker_conversations.id = job_seeker_messages.conversation_id
      AND (job_seeker_conversations.employer_id = auth.uid() OR job_seeker_conversations.seeker_id = auth.uid())
    )
  );

-- RLS Policies for job_offer_conversations

-- Users can view conversations they are part of
CREATE POLICY "Users can view own job offer conversations"
  ON job_offer_conversations FOR SELECT
  TO authenticated
  USING (auth.uid() = applicant_id OR auth.uid() = employer_id);

-- Applicants can create conversations for job offers
CREATE POLICY "Applicants can create job offer conversations"
  ON job_offer_conversations FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = applicant_id);

-- Users can update conversations they are part of
CREATE POLICY "Users can update own job offer conversations"
  ON job_offer_conversations FOR UPDATE
  TO authenticated
  USING (auth.uid() = applicant_id OR auth.uid() = employer_id)
  WITH CHECK (auth.uid() = applicant_id OR auth.uid() = employer_id);

-- RLS Policies for job_offer_messages

-- Users can view messages from their conversations
CREATE POLICY "Users can view job offer messages from own conversations"
  ON job_offer_messages FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM job_offer_conversations
      WHERE job_offer_conversations.id = job_offer_messages.conversation_id
      AND (job_offer_conversations.applicant_id = auth.uid() OR job_offer_conversations.employer_id = auth.uid())
    )
  );

-- Users can send messages to their conversations
CREATE POLICY "Users can send job offer messages to own conversations"
  ON job_offer_messages FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = sender_id
    AND EXISTS (
      SELECT 1 FROM job_offer_conversations
      WHERE job_offer_conversations.id = conversation_id
      AND (job_offer_conversations.applicant_id = auth.uid() OR job_offer_conversations.employer_id = auth.uid())
    )
  );

-- Users can update messages in their conversations
CREATE POLICY "Users can update job offer messages in own conversations"
  ON job_offer_messages FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM job_offer_conversations
      WHERE job_offer_conversations.id = job_offer_messages.conversation_id
      AND (job_offer_conversations.applicant_id = auth.uid() OR job_offer_conversations.employer_id = auth.uid())
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM job_offer_conversations
      WHERE job_offer_conversations.id = job_offer_messages.conversation_id
      AND (job_offer_conversations.applicant_id = auth.uid() OR job_offer_conversations.employer_id = auth.uid())
    )
  );

-- Create function to update job seeker conversation last_message_at
CREATE OR REPLACE FUNCTION update_job_seeker_conversation_last_message()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE job_seeker_conversations
  SET last_message_at = NEW.created_at,
      updated_at = NEW.created_at
  WHERE id = NEW.conversation_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create function to update job offer conversation last_message_at
CREATE OR REPLACE FUNCTION update_job_offer_conversation_last_message()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE job_offer_conversations
  SET last_message_at = NEW.created_at,
      updated_at = NEW.created_at
  WHERE id = NEW.conversation_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create triggers
DROP TRIGGER IF EXISTS update_job_seeker_conversation_last_message_trigger ON job_seeker_messages;
CREATE TRIGGER update_job_seeker_conversation_last_message_trigger
  AFTER INSERT ON job_seeker_messages
  FOR EACH ROW
  EXECUTE FUNCTION update_job_seeker_conversation_last_message();

DROP TRIGGER IF EXISTS update_job_offer_conversation_last_message_trigger ON job_offer_messages;
CREATE TRIGGER update_job_offer_conversation_last_message_trigger
  AFTER INSERT ON job_offer_messages
  FOR EACH ROW
  EXECUTE FUNCTION update_job_offer_conversation_last_message();