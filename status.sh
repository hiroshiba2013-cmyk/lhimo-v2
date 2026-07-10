#!/bin/bash
echo "📊 STATO IMPORTAZIONE"
echo "===================="
echo ""
if pgrep -f "node import-comprehensive.js" > /dev/null; then
    echo "✅ Importazione IN ESECUZIONE"
    echo "PID: $(pgrep -f 'node import-comprehensive.js')"
else
    echo "⚪ Nessuna importazione attiva"
fi
echo ""
echo "📈 Database:"
node check-import-stats.js 2>/dev/null | grep -E "(TOTALE|Con Email|Con Telefono)"
echo ""
if ls import-comp-*.log 1> /dev/null 2>&1; then
    echo "📄 Ultimi log:"
    ls -lt import-comp-*.log | head -n 3 | awk '{print "   " $9 " (" $5 ")"}'
fi
