#!/bin/bash

# Script per eseguire l'importazione in background con restart automatico
# Salva l'output su file e continua anche se la sessione viene chiusa

LOG_FILE="import-by-city-log.txt"
PID_FILE="import-process.pid"
STATUS_FILE="import-status.json"

echo "🚀 Avvio importazione in background..."
echo "📝 Log: $LOG_FILE"
echo ""

# Funzione per eseguire l'importazione
run_import() {
    while true; do
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Avvio importazione..." >> "$LOG_FILE"

        # Esegui lo script
        npm run import:by-city 2>&1 | tee -a "$LOG_FILE"

        EXIT_CODE=$?

        if [ $EXIT_CODE -eq 0 ]; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') - ✅ Importazione completata con successo!" >> "$LOG_FILE"
            break
        else
            echo "$(date '+%Y-%m-%d %H:%M:%S') - ⚠️ Processo interrotto (exit code: $EXIT_CODE). Riavvio tra 10 secondi..." >> "$LOG_FILE"
            sleep 10
        fi
    done
}

# Esegui in background
nohup bash -c "$(declare -f run_import); run_import" > /dev/null 2>&1 &

# Salva il PID
echo $! > "$PID_FILE"

echo "✅ Processo avviato in background!"
echo "📊 PID: $(cat $PID_FILE)"
echo ""
echo "Comandi utili:"
echo "  • Vedi log in tempo reale:  tail -f $LOG_FILE"
echo "  • Ferma il processo:        kill \$(cat $PID_FILE)"
echo "  • Controlla se è attivo:    ps -p \$(cat $PID_FILE)"
echo ""
