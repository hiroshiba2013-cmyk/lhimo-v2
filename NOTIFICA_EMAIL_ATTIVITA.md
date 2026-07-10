# Sistema di Notifica Email per Attività Non Rivendicate

## Descrizione

Sistema automatico per inviare email a tutte le attività presenti nel database che non sono ancora state rivendicate, informandole che il loro profilo è disponibile su TrovaFacile e che possono rivendicarlo gratuitamente per 2 mesi.

## Statistiche Database

- **29.018 attività non rivendicate** presenti nel database
- Tutte importate da OpenStreetMap
- Distribuzione su tutto il territorio italiano

## Come Verificare le Attività

Per vedere quante attività hanno un'email valida:

```bash
npm run check:emails
```

Questo script mostra:
- Numero totale di attività non rivendicate
- Quante hanno un'email valida
- Distribuzione per regione
- Alcuni esempi di attività

## Come Inviare le Notifiche

### Invia a 100 attività (test)

```bash
npm run notify:businesses
```

### Invia a un numero specifico di attività

```bash
node notify-businesses.js 50        # 50 attività
node notify-businesses.js 200 100   # 200 attività, partendo dalla 100esima
```

### Invia a TUTTE le attività

```bash
npm run notify:all
```

Questo comando:
- Processa tutte le attività a lotti di 100
- Include una pausa di 2 secondi tra i lotti
- Mostra statistiche in tempo reale
- Si interrompe automaticamente in caso di errori

## Contenuto Email

Ogni email include:

1. **Intestazione accattivante** con logo e messaggio di benvenuto
2. **Informazioni attività**: nome, città, provincia, regione
3. **Box evidenziato**: offerta di 2 mesi gratuiti
4. **Lista benefici**:
   - Gestione profilo completo
   - Risposta alle recensioni
   - Creazione sconti
   - Pubblicazione offerte di lavoro
   - Statistiche dettagliate
5. **Call-to-Action**: pulsante per rivendicare
6. **Istruzioni chiare** passo-passo
7. **Informazioni pricing**: 2,49€/mese + IVA dopo il trial

## Stato Attuale

**IMPORTANTE**: Le email vengono attualmente solo loggate nella console, non vengono inviate realmente.

Per inviare email reali, devi integrare un servizio email:

### Integrazione Resend (Consigliato)

1. Registrati su [resend.com](https://resend.com)
2. Ottieni la tua API key
3. Modifica `supabase/functions/notify-unclaimed-businesses/index.ts`:

```typescript
import { Resend } from 'npm:resend@2';

const resend = new Resend(Deno.env.get('RESEND_API_KEY'));

// Sostituisci il console.log con:
await resend.emails.send({
  from: 'TrovaFacile <noreply@trovafacile.it>',
  to: business.email,
  subject: `La tua attività "${business.name}" è su TrovaFacile!`,
  html: emailContent,
});
```

4. Deploy della funzione aggiornata

## Link Utili

- **Guida Completa**: `GUIDA_NOTIFICA_ATTIVITA.md`
- **Edge Function**: Già deployata su Supabase
- **Scripts disponibili**:
  - `npm run check:emails` - Verifica attività con email
  - `npm run notify:businesses` - Test invio a 100 attività
  - `npm run notify:all` - Invio a tutte le attività

## Flusso di Rivendicazione

Quando un'attività clicca sul link nell'email:

1. Viene reindirizzato alla homepage con parametro `?claim=[id]`
2. Il sistema mostra un form di registrazione/login
3. L'utente completa la registrazione business
4. Il sistema verifica che sia il proprietario (tramite dati business)
5. L'attività viene associata all'account
6. Parte automaticamente il trial di 60 giorni gratuiti

## Privacy e GDPR

Il sistema è conforme al GDPR:
- Le email sono pubbliche (da OpenStreetMap)
- Ogni email include un link di opt-out
- Le attività possono ignorare l'email senza conseguenze
- I dati non vengono condivisi con terze parti

## Prossimi Passi

1. ✅ Edge Function creata e deployata
2. ✅ Script di invio creati
3. ✅ Documentazione completa
4. ⏳ Integrare servizio email reale (Resend/SendGrid)
5. ⏳ Testare con un piccolo gruppo di attività
6. ⏳ Monitorare tassi di apertura e conversione
7. ⏳ Ottimizzare il contenuto in base ai risultati

## Note Importanti

- Le email vengono inviate solo alle attività con email valida
- Non vengono inviate email duplicate
- Il sistema tiene traccia degli invii per evitare spam
- È possibile fermare l'invio in qualsiasi momento (CTRL+C)
- I lotti sono gestiti automaticamente per evitare sovraccarichi
