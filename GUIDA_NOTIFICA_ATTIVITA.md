# Guida: Notifica Attività Non Rivendicate

Questa guida spiega come utilizzare il sistema di notifica email per le attività non rivendicate presenti nel database.

## Descrizione

Il sistema invia email automatiche a tutte le attività presenti nel database che:
- Non sono state ancora rivendicate (`is_claimed = false`)
- Hanno un indirizzo email valido
- Informano i proprietari che la loro attività è su TrovaFacile
- Includono un link diretto per rivendicare l'attività
- Offrono 2 mesi di prova gratuita

## Edge Function Deployed

**Nome:** `notify-unclaimed-businesses`
**Endpoint:** `https://[your-project].supabase.co/functions/v1/notify-unclaimed-businesses`

## Come Funziona

1. La funzione recupera le attività non rivendicate dal database
2. Filtra solo quelle con email valida
3. Per ogni attività, genera un'email personalizzata con:
   - Nome dell'attività e posizione
   - Informazioni sui benefici di TrovaFacile
   - Link diretto per rivendicare l'attività
   - Dettagli sulla prova gratuita di 2 mesi
4. (Attualmente) logga le email che verrebbero inviate

## Parametri della Richiesta

```json
{
  "limit": 100,    // Numero massimo di attività da processare (default: 100)
  "offset": 0      // Offset per paginazione (default: 0)
}
```

## Esempio di Utilizzo

### Da JavaScript/TypeScript

```javascript
const response = await fetch(
  'https://[your-project].supabase.co/functions/v1/notify-unclaimed-businesses',
  {
    method: 'POST',
    headers: {
      'Authorization': 'Bearer YOUR_SUPABASE_ANON_KEY',
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      limit: 100,
      offset: 0
    })
  }
);

const result = await response.json();
console.log(result);
```

### Da cURL

```bash
curl -X POST \
  'https://[your-project].supabase.co/functions/v1/notify-unclaimed-businesses' \
  -H 'Authorization: Bearer YOUR_SUPABASE_ANON_KEY' \
  -H 'Content-Type: application/json' \
  -d '{"limit": 100, "offset": 0}'
```

## Risposta della Funzione

```json
{
  "success": true,
  "message": "Processed 100 businesses",
  "sent": 95,
  "failed": 5,
  "sentEmails": ["email1@example.com", "email2@example.com", ...],
  "failedEmails": [
    { "email": "invalid@example.com", "error": "Invalid email format" }
  ]
}
```

## Contenuto dell'Email

Ogni email include:

1. **Header accattivante** - Con logo e messaggio di benvenuto
2. **Informazioni attività** - Nome, città, provincia, regione
3. **Promo trial** - Box evidenziato con i 2 mesi gratuiti
4. **Benefici** - Lista dei vantaggi di rivendicare l'attività:
   - Gestione profilo completo
   - Risposta alle recensioni
   - Creazione sconti e promozioni
   - Pubblicazione offerte di lavoro
   - Aumento visibilità
   - Statistiche dettagliate
5. **Call-to-Action** - Pulsante grande per rivendicare
6. **Istruzioni** - Passi per completare la rivendicazione
7. **Informazioni pricing** - Prezzo dopo il trial (2,49€/mese + IVA)

## Integrazione Servizio Email

**IMPORTANTE:** Attualmente la funzione logga le email invece di inviarle realmente.

Per inviare email vere, devi integrare un servizio email come:

### Opzione 1: Resend (Consigliato per Supabase)

```typescript
// Installa: npm install resend
import { Resend } from 'npm:resend@2';

const resend = new Resend(Deno.env.get('RESEND_API_KEY'));

await resend.emails.send({
  from: 'TrovaFacile <noreply@trovafacile.it>',
  to: business.email,
  subject: `La tua attività "${business.name}" è su TrovaFacile!`,
  html: emailContent,
});
```

### Opzione 2: SendGrid

```typescript
// Installa: npm install @sendgrid/mail
import sgMail from 'npm:@sendgrid/mail@7';

sgMail.setApiKey(Deno.env.get('SENDGRID_API_KEY'));

await sgMail.send({
  to: business.email,
  from: 'noreply@trovafacile.it',
  subject: `La tua attività "${business.name}" è su TrovaFacile!`,
  html: emailContent,
});
```

## Processare Tutte le Attività

Se hai molte attività, puoi processarle a lotti:

```javascript
async function notifyAllBusinesses() {
  const batchSize = 100;
  let offset = 0;
  let hasMore = true;

  while (hasMore) {
    const response = await fetch(
      'https://[your-project].supabase.co/functions/v1/notify-unclaimed-businesses',
      {
        method: 'POST',
        headers: {
          'Authorization': 'Bearer YOUR_SUPABASE_ANON_KEY',
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          limit: batchSize,
          offset: offset
        })
      }
    );

    const result = await response.json();
    console.log(`Batch ${offset / batchSize + 1}:`, result);

    // Se abbiamo processato meno del batch size, abbiamo finito
    hasMore = result.sent + result.failed === batchSize;
    offset += batchSize;

    // Pausa di 1 secondo tra i batch per non sovraccaricare
    if (hasMore) {
      await new Promise(resolve => setTimeout(resolve, 1000));
    }
  }

  console.log('Tutte le notifiche sono state inviate!');
}

notifyAllBusinesses();
```

## Statistiche Database

Attualmente nel database ci sono **29.018 attività non rivendicate**.

Per vedere quante hanno un email:

```sql
SELECT
  COUNT(*) as total,
  COUNT(email) FILTER (WHERE email IS NOT NULL AND email != '') as with_email,
  COUNT(*) FILTER (WHERE is_claimed = false) as unclaimed
FROM unclaimed_business_locations;
```

## Monitoraggio

Puoi monitorare il progresso delle notifiche con:

```sql
-- Attività con email che non sono state rivendicate
SELECT
  region,
  COUNT(*) as count
FROM unclaimed_business_locations
WHERE is_claimed = false
  AND email IS NOT NULL
  AND email != ''
GROUP BY region
ORDER BY count DESC;
```

## Note Importanti

1. **Privacy**: Assicurati di rispettare le normative GDPR
2. **Rate Limiting**: Invia le email a lotti per evitare problemi con i provider
3. **Opt-out**: Includi sempre un modo per disiscriversi
4. **Validazione**: Verifica che le email siano valide prima di inviarle
5. **Monitoraggio**: Traccia le email inviate per evitare duplicati

## Prossimi Passi

1. Integrare un servizio email reale (Resend/SendGrid)
2. Aggiungere un sistema di tracking per le email inviate
3. Implementare retry automatico per le email fallite
4. Creare un dashboard per monitorare le statistiche di invio
5. Aggiungere template email personalizzabili
