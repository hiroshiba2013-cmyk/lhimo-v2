/*
  # Add Automatic Profile Creation Trigger

  1. Purpose
    - Automatically create a profile in the profiles table when a user signs up
    - This ensures consistency and avoids manual profile creation
    - Prevents "Database error finding user" issues

  2. Changes
    - Create function to handle new user registration
    - Add trigger on auth.users table
    - Extract metadata from auth.users.raw_user_meta_data if available

  3. Security
    - Function runs with SECURITY DEFINER to bypass RLS
    - Only creates profile, doesn't set admin or special permissions
*/

-- Create function to handle new user registration
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (
    id,
    email,
    full_name,
    user_type,
    subscription_status
  )
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    'customer',
    'none'
  );
  
  RETURN NEW;
END;
$$;

-- Create trigger on auth.users
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();
