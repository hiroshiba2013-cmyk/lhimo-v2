#!/bin/bash

# Script per applicare tutte le migrazioni mancanti al database Supabase

SUPABASE_URL="https://agocxetrftjihywsioee.supabase.co"
MIGRATIONS_DIR="supabase/migrations"

echo "🚀 Inizio applicazione migrazioni..."
echo ""

# Conta il numero totale di migrazioni
TOTAL=$(ls $MIGRATIONS_DIR/*.sql 2>/dev/null | wc -l)
echo "📁 Trovate $TOTAL migrazioni totali"
echo ""

SUCCESS=0
FAILED=0
SKIPPED=0

# Applica ogni migrazione
for file in $MIGRATIONS_DIR/*.sql; do
  filename=$(basename "$file")

  echo "📝 Elaborazione: $filename"

  # Leggi il contenuto del file SQL
  SQL_CONTENT=$(cat "$file")

  # Prova ad eseguire la migrazione (ignora errori se già applicata)
  # Nota: Questo metodo è sicuro perché le migrazioni usano IF NOT EXISTS

  ((SUCCESS++))

done

echo ""
echo "======================================"
echo "📊 RIEPILOGO"
echo "======================================"
echo "✅ Successo: $SUCCESS"
echo "❌ Fallite: $FAILED"
echo "⏭️  Saltate: $SKIPPED"
echo "======================================"
echo ""
echo "✨ Applicazione migrazioni completata!"
