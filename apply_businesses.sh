#!/bin/bash
# Script to apply businesses in small batches

total=$(grep "INSERT INTO businesses" businesses_seed.sql | wc -l)
batch_size=20
current=0

echo "Total businesses to insert: $total"
echo "Batch size: $batch_size"

while [ $current -lt $total ]; do
  next=$((current + batch_size))
  if [ $next -gt $total ]; then
    next=$total
  fi
  
  echo "Processing businesses $current to $next..."
  
  # Extract batch
  head -$((next * 3)) businesses_seed.sql | tail -$((batch_size * 3)) > current_batch.sql
  
  current=$next
  
  if [ $current -ge 100 ]; then
    echo "Stopping at 100 businesses for now..."
    break
  fi
done

echo "Done!"
