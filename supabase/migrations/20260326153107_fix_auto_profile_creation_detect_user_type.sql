/*
  # Fix Auto Profile Creation - Detect User Type from Metadata

  1. Changes
    - Update handle_new_user to detect user_type from raw_user_meta_data
    - Support 'customer', 'business', and 'admin' types
    - Default to 'customer' if not specified

  2. Security
    - Maintains SECURITY DEFINER for proper permissions
*/

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  extracted_full_name text;
  extracted_user_type text;
BEGIN
  -- Try to extract full_name from metadata (check both locations)
  extracted_full_name := COALESCE(
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'fullName',
    split_part(NEW.email, '@', 1)
  );
  
  -- Ensure we have a non-empty string
  IF extracted_full_name = '' OR extracted_full_name IS NULL THEN
    extracted_full_name := split_part(NEW.email, '@', 1);
  END IF;

  -- Extract user_type from metadata, default to 'customer'
  extracted_user_type := COALESCE(
    NEW.raw_user_meta_data->>'user_type',
    NEW.raw_user_meta_data->>'userType',
    'customer'
  );

  -- Validate user_type matches CHECK constraint
  IF extracted_user_type NOT IN ('customer', 'business', 'admin') THEN
    extracted_user_type := 'customer';
  END IF;

  -- Create profile only if it doesn't exist
  INSERT INTO public.profiles (id, email, full_name, user_type, created_at)
  VALUES (
    NEW.id,
    NEW.email,
    extracted_full_name,
    extracted_user_type,
    NOW()
  )
  ON CONFLICT (id) DO NOTHING;

  RETURN NEW;
END;
$$;
