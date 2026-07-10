/*
  # Fix handle_new_user trigger to handle admin registration
  
  1. Changes
    - Update handle_new_user function to better extract full_name from metadata
    - Handle both user_metadata and raw_user_meta_data
    - Provide better fallback for full_name (use email if nothing else available)
    
  2. Security
    - Maintains SECURITY DEFINER for proper permissions
    - Preserves ON CONFLICT behavior
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
    'user', -- Default to user type, will be updated by admin registration function
    NOW()
  )
  ON CONFLICT (id) DO NOTHING;

  RETURN NEW;
END;
$$;
