#!/bin/bash

PID=$(pgrep -f "node import-comprehensive.js")

if [ -z "$PID" ]; then
    echo "⚪ Nessuna importazione in esecuzione"
    exit 0
fi

echo "🛑 Fermo importazione..."
echo "PID: $PID"
kill $PID 2>/dev/null

sleep 2

if pgrep -f "node import-comprehensive.js" > /dev/null; then
    echo "⚠️  Processo non risponde, forzo terminazione..."
    kill -9 $PID 2>/dev/null
    sleep 1
fi

if ! pgrep -f "node import-comprehensive.js" > /dev/null; then
    echo "✅ Importazione fermata"
else
    echo "❌ Impossibile fermare il processo"
fi
