/*
  # Set review status default to pending

  1. Changes
    - Change the default value of review_status from 'approved' to 'pending'
    - All new reviews will require staff approval before being visible publicly
    - Reviews can still be seen by their authors even when pending

  2. Notes
    - Existing approved reviews remain approved
    - Points are awarded only when a review is approved by staff
    - Reviews with proof get 50 points, without proof get 25 points
*/

-- Change the default value of review_status to 'pending'
ALTER TABLE reviews 
  ALTER COLUMN review_status SET DEFAULT 'pending';
