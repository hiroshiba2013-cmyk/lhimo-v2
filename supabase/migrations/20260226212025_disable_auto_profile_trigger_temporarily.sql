/*
  # Disable Auto Profile Creation Trigger Temporarily

  1. Problem
    - The trigger is causing "Database error finding user" during signup
    - Supabase's auth system might be checking for the profile before the trigger completes
    
  2. Solution
    - Disable the trigger temporarily
    - Handle profile creation in application code with proper error handling
    
  3. Changes
    - Drop the trigger
    - Keep the function for potential future use
*/

-- Drop the trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
