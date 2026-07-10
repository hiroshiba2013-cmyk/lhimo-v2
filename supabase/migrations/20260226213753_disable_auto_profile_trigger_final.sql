/*
  # Disable Auto Profile Trigger

  1. Problem
    - Automatic profile creation interferes with admin registration
    - Edge Function now handles profile creation with proper permissions
    
  2. Solution
    - Drop the automatic profile creation trigger
    - Edge Functions will handle profile creation explicitly
*/

-- Drop the trigger completely
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Keep the function for potential future use but it won't be called automatically
-- DROP FUNCTION IF EXISTS public.handle_new_user();
