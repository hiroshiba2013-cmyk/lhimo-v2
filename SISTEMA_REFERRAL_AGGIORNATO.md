# Sistema Referral Aggiornato

## Panoramica

Il sistema referral è stato aggiornato per garantire che i punti vengano assegnati **solo quando l'abbonamento viene confermato e pagato**, non immediatamente alla registrazione.

## Come Funziona Ora

### 1. Registrazione con Referral

Quando un nuovo utente si registra inserendo il nickname di un amico:
- Il sistema salva il nickname del referrer nel campo `referred_by_nickname`
- Il contatore `referral_count` del referrer viene incrementato
- **NESSUN PUNTO viene assegnato in questa fase**

### 2. Conferma Abbonamento

Quando l'utente referito conferma un abbonamento:
- Il sistema chiama automaticamente la funzione `confirm_referral_reward()`
- Verifica che l'utente sia stato referito da qualcuno
- Verifica che i punti non siano già stati assegnati (prevenzione duplicati)
- Assegna **30 punti** al referrer
- Crea un log di attività visibile nel profilo del referrer
- Incrementa il contatore `referrals_count` nella tabella `user_activity`

### 3. Cancellazione Account

Se un utente referito cancella il proprio account:
- Il sistema rimuove automaticamente i 30 punti dal referrer
- Decrementa il contatore `referral_count` e `referrals_count`
- Crea un log di attività che informa il referrer della rimozione punti
- Elimina il log di attività originale del referral

## Modifiche Database

### Nuove Funzioni

#### `confirm_referral_reward(p_referred_user_id uuid)`
Funzione da chiamare quando un abbonamento viene confermato. Restituisce un oggetto JSON:
```json
{
  "success": true,
  "message": "Punti referral assegnati",
  "referrer_id": "uuid-del-referrer",
  "points_awarded": 30
}
```

#### `remove_referral_points_on_delete()`
Trigger che viene eseguito automaticamente quando un utente cancella il proprio account.

### Trigger Modificati

- **Rimosso**: `trigger_process_referral` su `subscriptions` (INSERT)
- **Aggiunto**: `trigger_remove_referral_points` su `profiles` (BEFORE DELETE)

## Integrazione Frontend

Nel file `src/pages/SubscriptionPage.tsx`, nella funzione `handleSelectPlan()`:

```typescript
// Conferma il referral reward se l'utente è stato referito
try {
  const { data: referralData, error: referralError } = await supabase
    .rpc('confirm_referral_reward', {
      p_referred_user_id: profile.id
    });

  if (referralError) {
    console.error('Errore assegnazione punti referral:', referralError);
  } else if (referralData?.success) {
    console.log('Punti referral assegnati con successo:', referralData);
  }
} catch (referralErr) {
  console.error('Errore chiamata confirm_referral_reward:', referralErr);
}
```

## Vantaggi del Nuovo Sistema

1. **Maggiore Sicurezza**: I punti vengono assegnati solo dopo conferma pagamento
2. **Prevenzione Abusi**: Impossibile ottenere punti creando account falsi che non pagano
3. **Trasparenza**: Log dettagliati di ogni assegnazione e rimozione punti
4. **Protezione Referrer**: Se l'utente cancella l'account prima del pagamento, nessun punto viene perso
5. **Tracciabilità**: Ogni referral ha un log in `activity_log` con metadata completi

## Punti Referral

- **30 punti** per ogni amico che conferma un abbonamento
- I punti vengono rimossi se l'amico cancella l'account
- Il contatore `referral_count` nel profilo mostra quanti amici attivi ha invitato
- Il contatore `referrals_count` in `user_activity` viene sincronizzato automaticamente

## Esempio Pratico

### Scenario 1: Referral Confermato
1. Mario si registra inserendo il nickname "GiovanniRossi"
2. Mario attiva un abbonamento gratuito (trial) → **nessun punto assegnato**
3. Mario conferma il pagamento dopo il trial → **Giovanni riceve 30 punti**
4. Appare un'attività nel profilo di Giovanni: "Bonus Amico Ricevuto! +30 punti"

### Scenario 2: Account Cancellato
1. Mario si registra inserendo il nickname "GiovanniRossi"
2. Mario attiva un abbonamento e conferma il pagamento → **Giovanni riceve 30 punti**
3. Mario cancella il suo account → **Giovanni perde 30 punti**
4. Appare un'attività nel profilo di Giovanni: "Punti Referral Rimossi - L'amico ha cancellato l'account -30 punti"

### Scenario 3: Registrazione senza Conferma
1. Mario si registra inserendo il nickname "GiovanniRossi"
2. Mario attiva un trial ma non conferma mai il pagamento
3. Mario cancella l'account → **Giovanni non perde punti (perché non ne aveva ricevuti)**

## Test e Verifica

Per verificare il funzionamento:

1. Controllare che i punti vengano assegnati solo dopo conferma abbonamento
2. Verificare che non ci siano duplicati (chiamare `confirm_referral_reward` due volte per lo stesso utente)
3. Testare la cancellazione account e verificare che i punti vengano rimossi
4. Controllare i log in `activity_log` per ogni operazione

## Note Tecniche

- La funzione `confirm_referral_reward` è SECURITY DEFINER (eseguita con privilegi elevati)
- Tutti i check di sicurezza sono implementati lato database
- Il frontend può chiamare la funzione in modo sicuro
- Gli errori vengono loggati ma non bloccano il flusso di attivazione abbonamento
