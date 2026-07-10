#!/bin/bash

LOG_FILE=$(ls -t import-comp*.log 2>/dev/null | head -n 1)

if [ -z "$LOG_FILE" ]; then
    echo "❌ Nessun file di log trovato"
    exit 1
fi

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║           MONITORAGGIO IMPORTAZIONE IN TEMPO REALE             ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "📄 Log: $LOG_FILE"
echo ""
echo "Press Ctrl+C per uscire"
echo ""
echo "─────────────────────────────────────────────────────────────────"
echo ""

tail -f "$LOG_FILE" | grep --line-buffered -E "(REGIONE \[|✅.*[1-9]|📊|📈)"
