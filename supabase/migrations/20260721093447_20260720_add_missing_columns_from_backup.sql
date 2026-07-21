
-- Add missing columns to subscriptions
ALTER TABLE subscriptions
  ADD COLUMN IF NOT EXISTS trial_end_date timestamptz,
  ADD COLUMN IF NOT EXISTS payment_method_added boolean DEFAULT false,
  ADD COLUMN IF NOT EXISTS reminder_sent boolean DEFAULT false,
  ADD COLUMN IF NOT EXISTS expires_at timestamptz;

-- Add missing columns to subscription_plans
ALTER TABLE subscription_plans
  ADD COLUMN IF NOT EXISTS plan_type text DEFAULT 'customer',
  ADD COLUMN IF NOT EXISTS max_family_members integer,
  ADD COLUMN IF NOT EXISTS features jsonb DEFAULT '[]';

-- Add missing columns to profiles (used by various functions)
ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS referred_by_nickname text,
  ADD COLUMN IF NOT EXISTS referral_count integer DEFAULT 0,
  ADD COLUMN IF NOT EXISTS trial_end_date timestamptz,
  ADD COLUMN IF NOT EXISTS avatar_url text;

-- Sync max_family_members with max_persons for existing plans
UPDATE subscription_plans SET max_family_members = max_persons WHERE max_family_members IS NULL;
