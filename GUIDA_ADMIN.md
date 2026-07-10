# Guida Amministratore

## Sistema di Amministrazione

Questa piattaforma ha un sistema completo di amministrazione che permette di gestire tutti gli aspetti della piattaforma.

## Accesso Admin

### Registrazione Primo Admin

Per creare il primo account amministratore:

1. Vai all'URL: `https://tuodominio.com/admin-secure-register-2024`
2. Compila il form con:
   - Nome completo
   - Email
   - Password (minimo 8 caratteri)
   - Conferma password
   - **Chiave Admin**: `ADMIN_2024_SECRET_KEY`

3. Clicca su "Registra Admin"

### Login Admin

Per accedere come amministratore:

1. Vai all'URL: `https://tuodominio.com/admin-login`
2. Inserisci le tue credenziali admin
3. Verrai reindirizzato alla dashboard admin

## Dashboard Admin

La dashboard amministratore ti permette di:

### 1. Dashboard Principale
- Visualizzare statistiche generali:
  - Utenti totali
  - Recensioni totali
  - Recensioni in attesa di approvazione
  - Annunci classificati
  - Abbonamenti attivi
  - Attività registrate
  - Prodotti totali

### 2. Gestione Recensioni
- Visualizzare tutte le recensioni in attesa di approvazione
- Approvare recensioni (assegna 25 o 50 punti all'utente)
- Rifiutare recensioni inappropriate
- Visualizzare le prove di acquisto allegate

### 3. Gestione Utenti
- Visualizzare tutti gli utenti registrati
- Visualizzare email, tipo utente, stato abbonamento
- **Promuovere/Degradare Admin**: Clicca sul badge "Admin" o "Utente" per cambiare i permessi
- **Eliminare Utenti**: Clicca sull'icona cestino per eliminare un utente (non puoi eliminare te stesso)

### 4. Gestione Abbonamenti
- Visualizzare tutti gli abbonamenti
- Modificare lo stato degli abbonamenti (trial, attivo, scaduto, cancellato)
- Visualizzare dettagli piano e date di scadenza

### 5. Gestione Annunci
- Visualizzare tutti gli annunci classificati
- Modificare lo stato degli annunci (attivo, venduto, scaduto, eliminato)
- Moderare contenuti inappropriati

## URL Riservati

I seguenti URL sono riservati agli amministratori e non sono visibili agli utenti normali:

- `/admin-secure-register-2024` - Registrazione admin (richiede chiave segreta)
- `/admin-login` - Login amministratori
- `/admin` - Dashboard amministratore

## Sicurezza

### Chiave Admin

La chiave admin corrente è: `ADMIN_2024_SECRET_KEY`

**IMPORTANTE**: Cambia questa chiave nel codice sorgente prima di andare in produzione!

Per cambiarla, modifica il file:
- `src/pages/AdminRegisterPage.tsx`
- Cerca la riga: `const ADMIN_SECRET_KEY = 'ADMIN_2024_SECRET_KEY';`
- Sostituisci con una chiave sicura e casuale

### Permessi Database

Gli amministratori hanno accesso completo a:
- Tutte le recensioni (lettura e modifica)
- Tutti gli annunci classificati (lettura, modifica, eliminazione)
- Tutti i profili utente (lettura)
- Tutti gli abbonamenti (lettura e modifica)
- Tutta l'attività utente (lettura)

Questi permessi sono gestiti tramite Row Level Security (RLS) nel database Supabase.

## Best Practices

1. **Non condividere la chiave admin** con nessuno
2. **Usa password forti** per gli account admin (minimo 12 caratteri, con maiuscole, minuscole, numeri e simboli)
3. **Crea admin solo quando necessario** - limita il numero di amministratori
4. **Esci sempre** dalla dashboard admin quando hai finito
5. **Controlla regolarmente** le recensioni in attesa di approvazione
6. **Modera i contenuti** inappropriati prontamente

## Creare Altri Admin

Per creare altri amministratori:

1. Registra un nuovo admin usando `/admin-secure-register-2024`
2. Oppure promuovi un utente esistente dalla sezione "Gestione Utenti" cliccando sul badge "Utente"

## Rimuovere Permessi Admin

Per rimuovere i permessi di amministratore da un utente:

1. Vai nella sezione "Gestione Utenti"
2. Trova l'utente
3. Clicca sul badge "Admin"
4. Conferma l'operazione

## Logout

Per uscire dalla dashboard admin:

1. Clicca sul pulsante "Esci" in alto a destra
2. Verrai reindirizzato alla pagina di login admin

## Troubleshooting

### Non riesco ad accedere alla dashboard admin

1. Assicurati di aver effettuato il login con un account admin
2. Verifica che il tuo account abbia `is_admin = true` nel database
3. Prova a fare logout e login di nuovo

### La chiave admin non funziona

1. Verifica di aver inserito la chiave corretta: `ADMIN_2024_SECRET_KEY`
2. Controlla che non ci siano spazi extra
3. Se hai cambiato la chiave nel codice, usa quella nuova

### Non vedo tutte le funzionalità

1. Assicurati di essere loggato come admin
2. Controlla che il tuo account abbia tutti i permessi necessari nel database
3. Prova a ricaricare la pagina

## Supporto

Per problemi o domande, contatta il team di sviluppo.
