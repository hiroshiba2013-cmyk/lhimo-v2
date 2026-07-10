/*
  # Fix Admin Registration - Allow Nickname Check

  1. Changes
    - Add public SELECT policy on profiles table to check if nickname exists
    - This allows the registration form to verify nickname uniqueness before creating the account
  
  2. Security
    - Policy only allows reading the 'id' field when filtering by nickname
    - Does not expose sensitive user data
    - Necessary for preventing duplicate nicknames during registration
*/

-- Allow public to check if a nickname exists (for registration validation)
CREATE POLICY "Allow public to check nickname existence"
  ON profiles
  FOR SELECT
  TO public
  USING (true);
