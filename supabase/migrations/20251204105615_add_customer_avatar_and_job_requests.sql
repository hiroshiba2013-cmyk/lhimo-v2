/*
  # Add Customer Avatar and Job Requests

  ## Overview
  This migration adds avatar support for profiles and creates a job requests table
  for customers to post job search announcements.

  ## Changes

  ### Modified Tables
  - `profiles` - Add avatar_url field for profile pictures

  ### New Tables
  - `job_requests` - Store customer job search announcements
    - `id` (uuid, primary key)
    - `customer_id` (uuid, foreign key to profiles)
    - `title` (text) - Job title/position seeking
    - `description` (text) - Detailed job request description
    - `category` (text) - Job category/field
    - `location` (text) - Preferred work location
    - `employment_type` (text) - Full-time, part-time, contract, etc.
    - `experience_years` (integer) - Years of experience
    - `active` (boolean) - Whether the request is active
    - `created_at` (timestamptz)
    - `updated_at` (timestamptz)

  ### Storage
  - Create 'avatars' storage bucket for profile pictures

  ## Security
  - Enable RLS on job_requests table
  - Add policies for authenticated users to manage their own job requests
  - Add policies for public read access to active job requests
  - Configure storage policies for avatar uploads

  ## Notes
  - Customers can create job search announcements
  - Job requests are public when active
  - Avatar images are stored in Supabase Storage
*/

-- Add avatar_url to profiles table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'avatar_url'
  ) THEN
    ALTER TABLE profiles ADD COLUMN avatar_url text;
  END IF;
END $$;

-- Create job_requests table
CREATE TABLE IF NOT EXISTS job_requests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id uuid REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  title text NOT NULL,
  description text NOT NULL,
  category text NOT NULL,
  location text NOT NULL,
  employment_type text NOT NULL,
  experience_years integer DEFAULT 0,
  active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS on job_requests
ALTER TABLE job_requests ENABLE ROW LEVEL SECURITY;

-- Policy: Anyone can view active job requests
CREATE POLICY "Anyone can view active job requests"
  ON job_requests
  FOR SELECT
  USING (active = true);

-- Policy: Authenticated users can view their own job requests
CREATE POLICY "Users can view own job requests"
  ON job_requests
  FOR SELECT
  TO authenticated
  USING (auth.uid() = customer_id);

-- Policy: Authenticated customers can create job requests
CREATE POLICY "Customers can create job requests"
  ON job_requests
  FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = customer_id
    AND EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.user_type = 'customer'
    )
  );

-- Policy: Users can update their own job requests
CREATE POLICY "Users can update own job requests"
  ON job_requests
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = customer_id)
  WITH CHECK (auth.uid() = customer_id);

-- Policy: Users can delete their own job requests
CREATE POLICY "Users can delete own job requests"
  ON job_requests
  FOR DELETE
  TO authenticated
  USING (auth.uid() = customer_id);

-- Create storage bucket for avatars
INSERT INTO storage.buckets (id, name, public)
VALUES ('avatars', 'avatars', true)
ON CONFLICT (id) DO NOTHING;

-- Storage policy: Anyone can view avatars
CREATE POLICY "Public avatar access"
  ON storage.objects
  FOR SELECT
  USING (bucket_id = 'avatars');

-- Storage policy: Authenticated users can upload their own avatar
CREATE POLICY "Users can upload own avatar"
  ON storage.objects
  FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- Storage policy: Users can update their own avatar
CREATE POLICY "Users can update own avatar"
  ON storage.objects
  FOR UPDATE
  TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- Storage policy: Users can delete their own avatar
CREATE POLICY "Users can delete own avatar"
  ON storage.objects
  FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );