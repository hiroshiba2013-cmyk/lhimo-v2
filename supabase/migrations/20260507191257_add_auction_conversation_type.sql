/*
  # Add 'auction' to conversations conversation_type constraint

  The conversations table had a CHECK constraint allowing only:
  'classified_ad', 'job_seeker', 'job_posting'

  This adds 'auction' to support direct messaging between auction
  winner and seller after an auction concludes.
*/

ALTER TABLE conversations DROP CONSTRAINT IF EXISTS conversations_conversation_type_check;

ALTER TABLE conversations ADD CONSTRAINT conversations_conversation_type_check
  CHECK (conversation_type = ANY (ARRAY[
    'classified_ad'::text,
    'job_seeker'::text,
    'job_posting'::text,
    'auction'::text
  ]));
