
ALTER TABLE reviews
  ADD COLUMN IF NOT EXISTS ai_moderation_status text DEFAULT 'pending',
  ADD COLUMN IF NOT EXISTS ai_moderation_reason text,
  ADD COLUMN IF NOT EXISTS ai_moderation_flags jsonb DEFAULT '[]'::jsonb,
  ADD COLUMN IF NOT EXISTS ai_moderation_at timestamptz;

ALTER TABLE classified_ads
  ADD COLUMN IF NOT EXISTS ai_moderation_status text DEFAULT 'pending',
  ADD COLUMN IF NOT EXISTS ai_moderation_reason text,
  ADD COLUMN IF NOT EXISTS ai_moderation_flags jsonb DEFAULT '[]'::jsonb,
  ADD COLUMN IF NOT EXISTS ai_moderation_at timestamptz;

ALTER TABLE job_postings
  ADD COLUMN IF NOT EXISTS ai_moderation_status text DEFAULT 'pending',
  ADD COLUMN IF NOT EXISTS ai_moderation_reason text,
  ADD COLUMN IF NOT EXISTS ai_moderation_flags jsonb DEFAULT '[]'::jsonb,
  ADD COLUMN IF NOT EXISTS ai_moderation_at timestamptz;

ALTER TABLE auctions
  ADD COLUMN IF NOT EXISTS ai_moderation_status text DEFAULT 'pending',
  ADD COLUMN IF NOT EXISTS ai_moderation_reason text,
  ADD COLUMN IF NOT EXISTS ai_moderation_flags jsonb DEFAULT '[]'::jsonb,
  ADD COLUMN IF NOT EXISTS ai_moderation_at timestamptz;

ALTER TABLE job_seekers
  ADD COLUMN IF NOT EXISTS ai_moderation_status text DEFAULT 'pending',
  ADD COLUMN IF NOT EXISTS ai_moderation_reason text,
  ADD COLUMN IF NOT EXISTS ai_moderation_flags jsonb DEFAULT '[]'::jsonb,
  ADD COLUMN IF NOT EXISTS ai_moderation_at timestamptz;

ALTER TABLE unclaimed_business_locations
  ADD COLUMN IF NOT EXISTS ai_moderation_status text DEFAULT 'pending',
  ADD COLUMN IF NOT EXISTS ai_moderation_reason text,
  ADD COLUMN IF NOT EXISTS ai_moderation_flags jsonb DEFAULT '[]'::jsonb,
  ADD COLUMN IF NOT EXISTS ai_moderation_at timestamptz;

ALTER TABLE professional_profiles
  ADD COLUMN IF NOT EXISTS ai_moderation_status text DEFAULT 'pending',
  ADD COLUMN IF NOT EXISTS ai_moderation_reason text,
  ADD COLUMN IF NOT EXISTS ai_moderation_flags jsonb DEFAULT '[]'::jsonb,
  ADD COLUMN IF NOT EXISTS ai_moderation_at timestamptz;

CREATE TABLE IF NOT EXISTS content_moderation_logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  content_type text NOT NULL,
  content_id uuid,
  verdict text NOT NULL,
  confidence numeric(3,2),
  reason text,
  flags jsonb DEFAULT '[]'::jsonb,
  content_snapshot jsonb,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE content_moderation_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "admins_read_moderation_logs" ON content_moderation_logs
  FOR SELECT TO authenticated
  USING (EXISTS (SELECT 1 FROM admins WHERE user_id = auth.uid()));

CREATE POLICY "service_insert_moderation_logs" ON content_moderation_logs
  FOR INSERT WITH CHECK (true);
