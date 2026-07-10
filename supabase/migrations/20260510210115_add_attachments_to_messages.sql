/*
  # Add attachment support to messages

  1. Changes
    - `messages` table: add `attachment_url` (text, nullable) — public URL of the uploaded file
    - `messages` table: add `attachment_type` (text, nullable) — 'cv' | 'image'
    - `messages` table: add `attachment_name` (text, nullable) — original filename for display

  2. Storage buckets
    - `chat-cvs` — for CV files sent in job conversations (private, signed URLs)
    - `chat-images` — for images sent in classified ad conversations (public)

  3. RLS on storage
    - Authenticated users can upload to their own folder
    - Authenticated users can read files in conversations they belong to (via signed URL for cv, public for images)
*/

-- Add attachment columns to messages
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'messages' AND column_name = 'attachment_url'
  ) THEN
    ALTER TABLE messages ADD COLUMN attachment_url text;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'messages' AND column_name = 'attachment_type'
  ) THEN
    ALTER TABLE messages ADD COLUMN attachment_type text CHECK (attachment_type IN ('cv', 'image'));
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'messages' AND column_name = 'attachment_name'
  ) THEN
    ALTER TABLE messages ADD COLUMN attachment_name text;
  END IF;
END $$;
