# Sistema di Messaggistica - Trovafacile

## Panoramica

Il sistema di messaggistica permette agli utenti (privati e professionisti) di comunicare tra loro direttamente tramite la piattaforma per quanto riguarda:

1. **Annunci di Vendita** (Classified Ads)
2. **Offerte di Lavoro** (Job Postings)
3. **Ricerche di Lavoro** (Job Seekers)

---

## IMPORTANTE: Dove Creare gli Annunci

### Annunci "Cerco Lavoro" vs Annunci Classificati

**Se vuoi VENDERE/COMPRARE/REGALARE oggetti:**
- Usa la sezione `/classified-ads` (Annunci Classificati)
- Clicca su "Pubblica Annuncio"
- Scegli tipo: Vendo / Cerco / Regalo

**Se vuoi CERCARE LAVORO:**
- NON usare gli annunci classificati
- Vai alla pagina `/jobs` (Sezione Lavoro)
- Clicca sul tab "Cerco Lavoro"
- Clicca su "Crea Annuncio Cerco Lavoro"
- Compila con la tua esperienza professionale

Il tuo annuncio di ricerca lavoro apparirà nella sezione "Cerco Lavoro" della pagina Jobs e i datori di lavoro (utenti Business) potranno contattarti.

---

## 1. Messaggistica per Annunci di Vendita

### Come Funziona

**Per i Compratori (Utenti Privati):**
- Nella pagina degli annunci classificati (`/classified-ads`), ogni card mostra un pulsante **"Contatta"**
- Anche nella pagina di dettaglio annuncio (`/classified/{id}`), è presente il pulsante **"Invia Messaggio"**
- Nella sezione preferiti del profilo, gli annunci salvati hanno il pulsante **"Contatta"**
- Cliccando su "Contatta" o "Invia Messaggio", viene creata automaticamente una conversazione con il venditore
- La conversazione viene reindirizzata alla pagina `/messages` con la conversazione attiva

**Per i Venditori:**
- I venditori ricevono i messaggi degli interessati nella sezione `/messages`
- Possono rispondere direttamente dalla chat

### Componenti

- **Tabelle Database:**
  - `ad_conversations` - contiene le conversazioni tra compratore e venditore
  - `ad_messages` - contiene i messaggi singoli

- **Componente UI:**
  - `AdConversation` - interfaccia di chat per gli annunci

- **Pagine:**
  - `ClassifiedAdDetailPage` - pagina dettaglio annuncio con pulsante "Invia Messaggio"
  - `ClassifiedAdCard` - card annuncio con pulsante "Contatta" (nuovo)
  - `MessagesPage` - pagina centrale per gestire tutte le conversazioni

### Caratteristiche

- ✅ Messaggistica in tempo reale (Supabase Realtime)
- ✅ Notifica di lettura messaggi (`is_read`)
- ✅ Storico completo conversazioni
- ✅ Impedisce agli utenti di contattarsi da soli
- ✅ Conversazioni uniche per ogni coppia annuncio-compratore-venditore

---

## 2. Messaggistica per Offerte di Lavoro

### Come Funziona

**Per i Candidati (Utenti Privati):**
- Nella pagina delle offerte di lavoro (`/jobs`), ogni offerta mostra un pulsante **"Contatta"**
- Solo gli utenti con profilo "privato" possono contattare per le offerte di lavoro
- Cliccando su "Contatta", si apre una finestra modale di chat con il datore di lavoro

**Per i Datori di Lavoro (Utenti Business):**
- Ricevono i messaggi dei candidati interessati
- Possono rispondere direttamente dalla chat modale

### Componenti

- **Tabelle Database:**
  - `job_offer_conversations` - conversazioni tra candidato e datore di lavoro
  - `job_offer_messages` - messaggi singoli

- **Componente UI:**
  - `JobConversation` - interfaccia di chat modale per le offerte di lavoro

- **Pagine:**
  - `JobsPage` - pagina principale con lista offerte e pulsante "Contatta"

### Caratteristiche

- ✅ Chat modale in overlay
- ✅ Messaggistica in tempo reale
- ✅ Notifica di lettura messaggi
- ✅ Solo utenti privati possono candidarsi
- ✅ Conversazioni uniche per ogni coppia offerta-candidato-datore

---

## 3. Messaggistica per Ricerche di Lavoro

### Come Funziona

**Per i Datori di Lavoro (Utenti Business):**
- Nella sezione "Chi Cerca Lavoro" della pagina `/jobs`, possono vedere gli annunci di chi cerca lavoro
- Ogni card mostra un pulsante **"Contatta"**
- Solo gli utenti con profilo "business" possono contattare chi cerca lavoro
- Cliccando su "Contatta", si apre una finestra modale di chat con il candidato

**Per i Candidati (Utenti Privati):**
- Ricevono i messaggi dai potenziali datori di lavoro
- Possono rispondere direttamente dalla chat

### Componenti

- **Tabelle Database:**
  - `job_seeker_conversations` - conversazioni tra datore di lavoro e candidato
  - `job_seeker_messages` - messaggi singoli

- **Componente UI:**
  - `JobConversation` - interfaccia di chat modale (condivisa con le offerte di lavoro)
  - `JobSeekerCard` - card candidato con pulsante "Contatta"

- **Pagine:**
  - `JobsPage` - pagina principale con tab "Chi Cerca Lavoro"

### Caratteristiche

- ✅ Chat modale in overlay
- ✅ Messaggistica in tempo reale
- ✅ Solo utenti business possono contattare
- ✅ Conversazioni uniche per ogni coppia candidato-datore

---

## Architettura Database

### Schema Conversazioni

Tutte e tre le tipologie di conversazioni seguono uno schema simile:

```sql
-- Esempio: ad_conversations
CREATE TABLE ad_conversations (
  id uuid PRIMARY KEY,
  ad_id uuid REFERENCES classified_ads(id),
  buyer_id uuid REFERENCES auth.users(id),
  seller_id uuid REFERENCES auth.users(id),
  created_at timestamptz,
  updated_at timestamptz,
  last_message_at timestamptz,
  UNIQUE(ad_id, buyer_id, seller_id)
);
```

### Schema Messaggi

```sql
-- Esempio: ad_messages
CREATE TABLE ad_messages (
  id uuid PRIMARY KEY,
  conversation_id uuid REFERENCES ad_conversations(id),
  sender_id uuid REFERENCES auth.users(id),
  message text NOT NULL,
  is_read boolean DEFAULT false,
  created_at timestamptz
);
```

### Trigger Automatici

- Ogni volta che viene inviato un messaggio, viene aggiornato automaticamente il campo `last_message_at` della conversazione
- Questo permette di ordinare le conversazioni per attività recente

---

## Sicurezza (RLS Policies)

### Conversazioni
- Gli utenti possono vedere solo le conversazioni di cui fanno parte
- Gli utenti possono creare conversazioni solo come "buyer" o "applicant"
- Gli utenti possono aggiornare solo le proprie conversazioni

### Messaggi
- Gli utenti possono vedere solo i messaggi delle proprie conversazioni
- Gli utenti possono inviare messaggi solo alle proprie conversazioni
- Gli utenti possono aggiornare i messaggi solo per marcarli come letti

---

## Esperienza Utente

### Notifiche Tempo Reale
Tutte le chat utilizzano Supabase Realtime per aggiornare automaticamente i messaggi senza dover ricaricare la pagina.

### Scroll Automatico
Quando arriva un nuovo messaggio, la chat scrolla automaticamente in fondo per mostrare l'ultimo messaggio.

### Stato di Lettura
I messaggi vengono automaticamente marcati come letti quando l'utente visualizza la conversazione.

### Timestamp Intelligenti
I messaggi mostrano:
- L'ora se inviati oggi (es: "14:30")
- La data se inviati in giorni precedenti (es: "15 gen")

---

## Pagina Messaggi Centralizzata

La pagina `/messages` (da implementare se non esiste) dovrebbe mostrare:
1. Lista di tutte le conversazioni attive
2. Preview ultimo messaggio
3. Badge per messaggi non letti
4. Filtri per tipo (Annunci / Lavoro)

---

## Limitazioni e Permessi

### Annunci di Vendita
- ❌ Non puoi contattarti da solo
- ✅ Chiunque può contattare un venditore

### Offerte di Lavoro
- ❌ Solo utenti PRIVATI possono candidarsi
- ❌ Non puoi contattare la tua stessa offerta

### Ricerche di Lavoro
- ❌ Solo utenti BUSINESS possono contattare chi cerca lavoro
- ❌ Non puoi contattare il tuo stesso annuncio

---

## Funzionalità Future (Suggerimenti)

1. **Badge messaggi non letti** nell'header
2. **Notifiche push** quando arriva un nuovo messaggio
3. **Allegati e immagini** nei messaggi
4. **Blocco utenti** per spam
5. **Archiviazione conversazioni**
6. **Ricerca messaggi** per parola chiave
7. **Messaggi vocali**
8. **Conferma lettura** con doppia spunta blu

---

## Testing

### Test Annunci di Vendita
1. Accedi come utente A
2. Crea un annuncio di vendita
3. Accedi come utente B
4. Cerca l'annuncio e clicca "Contatta"
5. Invia un messaggio
6. Torna come utente A e verifica il messaggio ricevuto

### Test Offerte di Lavoro
1. Accedi come utente business
2. Crea un'offerta di lavoro
3. Accedi come utente privato
4. Vai su `/jobs` e clicca "Contatta" sull'offerta
5. Invia un messaggio nella chat modale
6. Torna come utente business e verifica il messaggio

### Test Ricerche di Lavoro
1. Accedi come utente privato
2. Crea un annuncio "Cerco Lavoro"
3. Accedi come utente business
4. Vai su `/jobs` → tab "Chi Cerca Lavoro"
5. Clicca "Contatta" sul candidato
6. Invia un messaggio nella chat modale
7. Torna come utente privato e verifica il messaggio

---

## Riferimenti Codice

### File Chiave

**Componenti:**
- `/src/components/messages/AdConversation.tsx`
- `/src/components/jobs/JobConversation.tsx`
- `/src/components/classifieds/ClassifiedAdCard.tsx`

**Pagine:**
- `/src/pages/MessagesPage.tsx`
- `/src/pages/JobsPage.tsx`
- `/src/pages/ClassifiedAdDetailPage.tsx`
- `/src/pages/ClassifiedAdsPage.tsx`

**Database:**
- `/supabase/migrations/20251229092530_create_classified_ads_messaging_system.sql`
- `/supabase/migrations/20251229115822_create_job_seekers_and_messaging_system.sql`

---

## Conclusione

Il sistema di messaggistica è completo e funzionante per tutte e tre le tipologie di interazione:
- ✅ Annunci di Vendita
- ✅ Offerte di Lavoro
- ✅ Ricerche di Lavoro

Tutti i sistemi utilizzano messaggistica in tempo reale, sicurezza RLS, e gestione automatica dello stato dei messaggi.
