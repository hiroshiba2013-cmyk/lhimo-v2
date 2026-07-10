/*
  # Fix handle_new_user trigger to use correct user_type
  
  1. Changes
    - Change default user_type from 'user' to 'customer' (valid according to CHECK constraint)
    - This will fix the "Database error creating new user" issue
    
  2. Security
    - Maintains SECURITY DEFINER for proper permissions
    - Preserves all other functionality
*/

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  extracted_full_name text;
BEGIN
  -- Try to extract full_name from metadata (check both locations)
  extracted_full_name := COALESCE(
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'fullName',
    split_part(NEW.email, '@', 1) -- Fallback to email username
  );
  
  -- Ensure we have a non-empty string
  IF extracted_full_name = '' OR extracted_full_name IS NULL THEN
    extracted_full_name := split_part(NEW.email, '@', 1);
  END IF;

  -- Create profile only if it doesn't exist
  INSERT INTO public.profiles (id, email, full_name, user_type, created_at)
  VALUES (
    NEW.id,
    NEW.email,
    extracted_full_name,
    'customer', -- Changed from 'user' to 'customer' to match CHECK constraint
    NOW()
  )
  ON CONFLICT (id) DO NOTHING;

  RETURN NEW;
END;
$$;
