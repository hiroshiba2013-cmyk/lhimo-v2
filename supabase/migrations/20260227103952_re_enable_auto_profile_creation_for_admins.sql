/*
  # Re-enable Auto Profile Creation for Admin Registration

  1. Changes
    - Re-enable the automatic profile creation trigger for new auth users
    - This ensures that when an admin registers via the Edge Function, a profile is automatically created
    - The trigger creates a profile with user_type 'user' by default, which is then updated by the Edge Function
  
  2. Security
    - Trigger runs in a secure context
    - Only creates profiles for users that don't already have one
*/

-- Drop the existing trigger if it exists
DROP TRIGGER IF EXISTS on_auth_user_created_create_profile ON auth.users;

-- Re-create the trigger function
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  -- Create profile only if it doesn't exist
  INSERT INTO public.profiles (id, email, full_name, user_type, created_at)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    'user', -- Default to user type, will be updated by admin registration function
    NOW()
  )
  ON CONFLICT (id) DO NOTHING;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Re-create the trigger
CREATE TRIGGER on_auth_user_created_create_profile
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();
