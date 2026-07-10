#!/bin/bash
# Watchdog: controlla ogni 3 minuti se import-per-comune è attivo, altrimenti lo riavvia

LOGFILE="/tmp/cc-agent/60717690/project/import-per-comune-log.txt"
SCRIPT_DIR="/tmp/cc-agent/60717690/project"

while true; do
  sleep 180

  PID=$(pgrep -f "node import-per-comune")
  if [ -z "$PID" ]; then
    echo "[WATCHDOG $(date '+%H:%M:%S')] Processo fermato — riavvio..." >> "$LOGFILE"
    cd "$SCRIPT_DIR"
    node import-per-comune.js >> "$LOGFILE" 2>&1 &
    echo "[WATCHDOG $(date '+%H:%M:%S')] Riavviato con PID $!" >> "$LOGFILE"
  else
    LAST=$(tail -1 "$LOGFILE")
    echo "[WATCHDOG $(date '+%H:%M:%S')] Attivo (PID $PID) — $LAST" >> "$LOGFILE"
  fi
done
