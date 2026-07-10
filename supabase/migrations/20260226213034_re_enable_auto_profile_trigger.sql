/*
  # Re-enable Auto Profile Creation Trigger with Error Handling

  1. Problem
    - Admin signup fails with "Database error finding user"
    - Need automatic profile creation that doesn't interfere with auth.signup()
    
  2. Solution
    - Re-enable the trigger with improved error handling
    - Use INSERT ... ON CONFLICT to handle race conditions
    - Use EXCEPTION handling to prevent trigger failures from blocking signup
    
  3. Changes
    - Update handle_new_user function with better error handling
    - Re-create the trigger
*/

-- Drop and recreate the function with better error handling
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
BEGIN
  -- Insert profile with ON CONFLICT to handle duplicates gracefully
  INSERT INTO public.profiles (
    id,
    email,
    full_name,
    user_type,
    subscription_status,
    is_admin
  )
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    'customer',
    'none',
    false
  )
  ON CONFLICT (id) DO NOTHING;
  
  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Log error but don't fail the signup
    RAISE WARNING 'Error creating profile for user %: %', NEW.id, SQLERRM;
    RETURN NEW;
END;
$$;

-- Re-create the trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();
