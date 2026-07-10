#!/bin/bash

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║         AVVIO IMPORTAZIONE ATTIVITÀ ITALIANE                  ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Verifica se c'è già un processo in esecuzione
if pgrep -f "node import-comprehensive.js" > /dev/null; then
    echo "⚠️  Un'importazione è già in corso!"
    echo ""
    echo "PID: $(pgrep -f 'node import-comprehensive.js')"
    echo ""
    echo "Per monitorare:"
    echo "  tail -f import-comp-*.log"
    echo ""
    echo "Per fermare:"
    echo "  kill \$(pgrep -f 'node import-comprehensive.js')"
    echo ""
    exit 1
fi

echo "🚀 Avvio importazione completa..."
echo ""
echo "📋 Dettagli:"
echo "   - Regioni: 20"
echo "   - Categorie: 72"
echo "   - Tempo stimato: 8-12 ore"
echo ""

# Crea nome log con timestamp
LOG_FILE="import-comp-$(date +%Y%m%d_%H%M%S).log"

# Avvia in background
nohup node import-comprehensive.js > "$LOG_FILE" 2>&1 &
PID=$!

echo "✅ Importazione avviata!"
echo ""
echo "PID: $PID"
echo "Log: $LOG_FILE"
echo ""
echo "📊 Comandi utili:"
echo ""
echo "  # Monitorare in tempo reale"
echo "  tail -f $LOG_FILE"
echo ""
echo "  # Vedere solo progressi significativi"
echo "  tail -f $LOG_FILE | grep -E '(REGIONE|✅.*[1-9]|📊|📈)'"
echo ""
echo "  # Statistiche database"
echo "  npm run stats"
echo ""
echo "  # Fermare importazione"
echo "  kill $PID"
echo ""
echo "L'importazione procede in background. Puoi chiudere questo terminale."
echo ""
