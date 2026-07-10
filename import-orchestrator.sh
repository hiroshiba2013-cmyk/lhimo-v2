#!/bin/bash
# Orchestratore importazione 1 ora
# Lancia round in sequenza, monitora e riavvia se finisce prima di 1h

START_TIME=$(date +%s)
END_TIME=$((START_TIME + 3600))  # 1 ora
ROUND=1
LOG="import-orchestrator.log"

echo "=== ORCHESTRATORE AVVIATO $(date) ===" | tee -a $LOG
echo "Fine prevista: $(date -d @$END_TIME)" | tee -a $LOG

run_round() {
  local script=$1
  local name=$2
  local NOW=$(date +%s)

  if [ $NOW -ge $END_TIME ]; then
    echo "Tempo scaduto, stop." | tee -a $LOG
    return 1
  fi

  echo "" | tee -a $LOG
  echo "--- AVVIO $name $(date) ---" | tee -a $LOG
  node "$script" 2>&1 | tee -a $LOG
  echo "--- FINE $name $(date) ---" | tee -a $LOG
  return 0
}

# Attendi che finisca il processo v2 se ancora in esecuzione
while pgrep -f "import-comuni-v2" > /dev/null; do
  echo "Attendo fine import-comuni-v2..." | tee -a $LOG
  sleep 30
done

# Ciclo principale: esegui round finché c'è tempo
while true; do
  NOW=$(date +%s)
  REMAINING=$((END_TIME - NOW))

  if [ $REMAINING -le 0 ]; then
    echo "=== 1 ORA COMPLETATA $(date) ===" | tee -a $LOG
    break
  fi

  echo "Tempo rimanente: ${REMAINING}s" | tee -a $LOG

  case $((ROUND % 3)) in
    1) run_round "import-comuni-v2.js" "ROUND_v2_iter${ROUND}" || break ;;
    2) run_round "import-round2.js" "ROUND2_iter${ROUND}" || break ;;
    0) run_round "import-round3.js" "ROUND3_iter${ROUND}" || break ;;
  esac

  ROUND=$((ROUND + 1))
done

echo "=== ORCHESTRATORE TERMINATO $(date) ===" | tee -a $LOG
