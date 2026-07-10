/*
  # Add User Activity Tracking and Rewards System

  ## New Tables
  
  1. **user_activity**
     - Tracks user engagement and points
     - Columns:
       - `user_id` (uuid, foreign key to profiles)
       - `total_points` (integer) - Total points earned
       - `reviews_count` (integer) - Number of reviews written
       - `photos_count` (integer) - Number of photos uploaded
       - `badges` (text[]) - Array of earned badges
       - `last_activity_at` (timestamptz) - Last activity timestamp
       - `created_at` (timestamptz)
       - `updated_at` (timestamptz)
  
  2. **rewards**
     - Stores available rewards for users
     - Columns:
       - `id` (uuid, primary key)
       - `title` (text) - Reward title
       - `description` (text) - Reward description
       - `points_required` (integer) - Points needed to unlock
       - `icon` (text) - Icon name
       - `color` (text) - Color class for styling
       - `is_active` (boolean) - Whether reward is currently available
       - `created_at` (timestamptz)
  
  3. **user_rewards**
     - Tracks which rewards users have claimed
     - Columns:
       - `id` (uuid, primary key)
       - `user_id` (uuid, foreign key to profiles)
       - `reward_id` (uuid, foreign key to rewards)
       - `claimed_at` (timestamptz)
  
  ## Security
  - Enable RLS on all tables
  - Users can view their own activity and all rewards
  - Only authenticated users can view leaderboard
*/

-- Create user_activity table
CREATE TABLE IF NOT EXISTS user_activity (
  user_id uuid PRIMARY KEY REFERENCES profiles(id) ON DELETE CASCADE,
  total_points integer DEFAULT 0,
  reviews_count integer DEFAULT 0,
  photos_count integer DEFAULT 0,
  badges text[] DEFAULT '{}',
  last_activity_at timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create rewards table
CREATE TABLE IF NOT EXISTS rewards (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text NOT NULL,
  points_required integer NOT NULL DEFAULT 0,
  icon text DEFAULT 'gift',
  color text DEFAULT 'bg-blue-100 text-blue-600',
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

-- Create user_rewards table
CREATE TABLE IF NOT EXISTS user_rewards (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  reward_id uuid NOT NULL REFERENCES rewards(id) ON DELETE CASCADE,
  claimed_at timestamptz DEFAULT now(),
  UNIQUE(user_id, reward_id)
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_user_activity_points ON user_activity(total_points DESC);
CREATE INDEX IF NOT EXISTS idx_user_activity_reviews ON user_activity(reviews_count DESC);
CREATE INDEX IF NOT EXISTS idx_user_activity_last_activity ON user_activity(last_activity_at DESC);
CREATE INDEX IF NOT EXISTS idx_rewards_points ON rewards(points_required);
CREATE INDEX IF NOT EXISTS idx_user_rewards_user ON user_rewards(user_id);
CREATE INDEX IF NOT EXISTS idx_user_rewards_reward ON user_rewards(reward_id);

-- Enable RLS
ALTER TABLE user_activity ENABLE ROW LEVEL SECURITY;
ALTER TABLE rewards ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_rewards ENABLE ROW LEVEL SECURITY;

-- RLS Policies for user_activity
CREATE POLICY "Users can view their own activity"
  ON user_activity FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can view all activity for leaderboard"
  ON user_activity FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "System can insert user activity"
  ON user_activity FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own activity"
  ON user_activity FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- RLS Policies for rewards
CREATE POLICY "Anyone can view active rewards"
  ON rewards FOR SELECT
  TO authenticated
  USING (is_active = true);

-- RLS Policies for user_rewards
CREATE POLICY "Users can view their own claimed rewards"
  ON user_rewards FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can claim rewards"
  ON user_rewards FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Function to update user activity
CREATE OR REPLACE FUNCTION update_user_activity()
RETURNS TRIGGER AS $$
BEGIN
  -- Insert or update user activity when a review is created
  INSERT INTO user_activity (user_id, total_points, reviews_count, last_activity_at, updated_at)
  VALUES (
    NEW.customer_id,
    10,
    1,
    now(),
    now()
  )
  ON CONFLICT (user_id) DO UPDATE SET
    total_points = user_activity.total_points + 10,
    reviews_count = user_activity.reviews_count + 1,
    last_activity_at = now(),
    updated_at = now();
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger to automatically update user activity when review is created
DROP TRIGGER IF EXISTS trigger_update_user_activity_on_review ON reviews;
CREATE TRIGGER trigger_update_user_activity_on_review
  AFTER INSERT ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION update_user_activity();

-- Insert some default rewards
INSERT INTO rewards (title, description, points_required, icon, color) VALUES
  ('Nuovo Arrivato', 'Benvenuto nella community! Inizia a guadagnare punti.', 0, 'star', 'bg-gray-100 text-gray-600'),
  ('Principiante', 'Hai raggiunto i tuoi primi 100 punti!', 100, 'award', 'bg-green-100 text-green-600'),
  ('Esploratore', 'Ben fatto! 500 punti guadagnati.', 500, 'medal', 'bg-blue-100 text-blue-600'),
  ('Veterano', 'Impressionante! 1000 punti raggiunti.', 1000, 'trophy', 'bg-purple-100 text-purple-600'),
  ('Maestro', 'Eccellente lavoro! 5000 punti.', 5000, 'trophy', 'bg-orange-100 text-orange-600'),
  ('Leggenda', 'Sei una leggenda! 10000 punti raggiunti!', 10000, 'trophy', 'bg-yellow-100 text-yellow-600')
ON CONFLICT DO NOTHING;
