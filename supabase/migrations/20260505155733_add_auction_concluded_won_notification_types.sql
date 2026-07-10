/*
  # Add auction_concluded and auction_won notification types

  New types sent by the close-expired-auctions edge function:
  - auction_concluded: sent to the auction owner when their auction ends
  - auction_won: sent to the winner of an auction
*/

-- No schema change needed; notification type is a free-text column.
-- This migration documents the new types and updates the NotificationsPage
-- category mapping in the frontend (leaderboard/auctions filter).
SELECT 1;
