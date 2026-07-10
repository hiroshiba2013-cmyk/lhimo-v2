# Gestione Prove Recensioni - Sistema Completo

## Panoramica
Le recensioni con prova di acquisto (scontrini, fatture, foto) valgono 50 punti, ma le immagini NON sono mai mostrate pubblicamente. Sono visibili SOLO nel pannello admin per verifica, e vengono eliminate automaticamente dopo approvazione/rifiuto.

## Flusso Completo

### 1. Utente Carica Recensione con Prova
- L'utente scrive una recensione e carica un'immagine (scontrino/fattura)
- L'immagine viene caricata nello storage `review-proofs`
- La recensione viene salvata con stato `pending`
- Il campo `proof_image_url` contiene il link all'immagine

### 2. Visualizzazione Pubblica
- **IMPORTANTE:** L'immagine NON è MAI visibile pubblicamente
- `ReviewCard.tsx` non mostra mai il campo `proof_image_url`
- Gli utenti vedono solo il testo e le valutazioni della recensione
- Badge "Verificata" viene mostrato solo DOPO l'approvazione

### 3. Pannello Admin

#### Visualizzazione
- L'admin vede l'immagine in un box evidenziato blu/viola
- Etichetta: "Prova di Acquisto (Visibile SOLO in Admin)"
- Nota: "Questa immagine NON è visibile pubblicamente. Verrà eliminata automaticamente dopo l'approvazione o il rifiuto"

#### Opzioni Admin

**Opzione 1: Approva con prova (50 punti)**
- Pulsante: "Approva (50 punti)"
- L'immagine è valida
- Assegna 50 punti
- Elimina l'immagine fisicamente dallo storage
- Rimuove `proof_image_url` dal database

**Opzione 2: Approva senza prova (25 punti)**
- Pulsante giallo: "Approva senza prova (25 punti)"
- L'immagine NON è valida (es: foto sfocata, non pertinente)
- MA la recensione testuale è corretta
- PRIMA: Elimina l'immagine fisicamente
- PRIMA: Rimuove `proof_image_url` dal database (lo setta a NULL)
- DOPO: Approva la recensione
- Assegna 25 punti (perché `proof_image_url` è ora NULL)

**Opzione 3: Rifiuta completamente (0 punti)**
- Pulsante rosso: "Rifiuta Completamente"
- La recensione è inappropriata/falsa
- Elimina l'immagine fisicamente dallo storage
- Rimuove `proof_image_url` dal database
- Stato diventa `rejected`
- Assegna 0 punti

### 4. Logica Punti

```javascript
// Nella funzione approve_review (database)
IF proof_image_url IS NOT NULL AND proof_image_url != '' THEN
  points_to_award := 50;  // Prova valida
ELSE
  points_to_award := 25;  // Nessuna prova o prova rifiutata
END IF;
```

**Fondamentale:** La funzione controlla `proof_image_url` **AL MOMENTO dell'approvazione**. Se il frontend ha già rimosso l'immagine (chiamando prima `approveReviewWithoutProof`), il campo sarà NULL e assegnerà 25 punti.

### 5. Eliminazione Immagini

#### Quando vengono eliminate:
1. **Approvazione con prova (50 punti):** Dopo l'approvazione
2. **Approvazione senza prova (25 punti):** PRIMA dell'approvazione
3. **Rifiuto:** Dopo il rifiuto

#### Come vengono eliminate:
```javascript
// 1. Eliminazione fisica dallo storage
const filePath = review.proof_image_url.split('/').pop();
await supabase.storage.from('review-proofs').remove([filePath]);

// 2. Rimozione riferimento dal database
await supabase
  .from('reviews')
  .update({ proof_image_url: null })
  .eq('id', reviewId);
```

## Funzioni Admin

### approveReview(reviewId)
```javascript
// 1. Trova recensione
const review = reviews.find(r => r.id === reviewId);

// 2. Elimina immagine se presente
if (review?.proof_image_url) {
  const filePath = review.proof_image_url.split('/').pop();
  await supabase.storage.from('review-proofs').remove([filePath]);
}

// 3. Approva (la funzione DB assegna punti in base a proof_image_url)
await supabase.rpc('approve_review', {
  review_id_param: reviewId,
  staff_id_param: adminId
});

// 4. Rimuovi riferimento
await supabase
  .from('reviews')
  .update({ proof_image_url: null })
  .eq('id', reviewId);
```

### approveReviewWithoutProof(reviewId)
```javascript
// 1. Trova recensione
const review = reviews.find(r => r.id === reviewId);

// 2. Elimina immagine
if (review?.proof_image_url) {
  const filePath = review.proof_image_url.split('/').pop();
  await supabase.storage.from('review-proofs').remove([filePath]);
}

// 3. IMPORTANTE: Rimuovi riferimento PRIMA dell'approvazione
await supabase
  .from('reviews')
  .update({ proof_image_url: null })
  .eq('id', reviewId);

// 4. Approva (la funzione DB vede proof_image_url = NULL e assegna 25 punti)
await supabase.rpc('approve_review', {
  review_id_param: reviewId,
  staff_id_param: adminId
});
```

### confirmReject(reviewId)
```javascript
// 1. Trova recensione
const review = reviews.find(r => r.id === reviewId);

// 2. Elimina immagine se presente
if (review?.proof_image_url) {
  const filePath = review.proof_image_url.split('/').pop();
  await supabase.storage.from('review-proofs').remove([filePath]);
}

// 3. Rifiuta
await supabase.rpc('reject_review', {
  review_id_param: reviewId,
  staff_id_param: adminId
});

// 4. Rimuovi riferimento
await supabase
  .from('reviews')
  .update({ proof_image_url: null })
  .eq('id', reviewId);

// 5. Invia notifica con motivazione
```

## Tabella Riepilogativa

| Azione | Immagine valida? | Elimina immagine | Punti assegnati | Stato finale |
|--------|------------------|------------------|-----------------|--------------|
| Approva con prova | Sì | Dopo approvazione | 50 | approved |
| Approva senza prova | No | Prima approvazione | 25 | approved |
| Rifiuta | N/A | Dopo rifiuto | 0 | rejected |

## Privacy e Sicurezza

### Perché le immagini non sono pubbliche?
1. **Privacy:** Gli scontrini contengono dati sensibili (prezzi, date, numeri)
2. **Sicurezza:** Evita contraffazioni e manipolazioni
3. **Semplicità:** Gli utenti vedono solo info rilevanti (testo recensione)
4. **Storage:** Riduce spazio occupato (immagini eliminate dopo verifica)

### Dove sono archiviate?
- **Storage:** Bucket Supabase `review-proofs`
- **Accesso:** Solo admin tramite RLS policies
- **Durata:** Temporaneo, eliminate dopo approvazione/rifiuto
- **Formato:** jpg, png, webp

### Sicurezza RLS
```sql
-- Solo admin possono leggere le prove
CREATE POLICY "Only admins can view review proofs"
ON storage.objects FOR SELECT
USING (
  bucket_id = 'review-proofs'
  AND is_admin(auth.uid())
);
```

## Best Practices

### Per gli Admin
1. **Verifica sempre l'immagine** prima di approvare
2. **Se l'immagine non è valida** usa "Approva senza prova (25 punti)"
3. **Non rifiutare la recensione** solo per l'immagine se il testo è valido
4. **Fornisci motivazioni chiare** quando rifiuti una recensione
5. **Controlla la coerenza** tra immagine e testo recensione

### Per gli Utenti
1. **Carica foto chiare e leggibili** (scontrini, fatture)
2. **Assicurati che sia pertinente** all'attività recensita
3. **Non includere dati sensibili extra** (numeri carte, documenti)
4. **Ricorda:** L'immagine è solo per verifica, non sarà mai pubblica

## Note Tecniche

### Ordine Operazioni Critiche

**approveReviewWithoutProof:**
```
1. DELETE immagine fisica
2. SET proof_image_url = NULL
3. CALL approve_review (vede NULL → 25 punti)
```

**approveReview:**
```
1. CALL approve_review (vede immagine → 50 punti)
2. SET proof_image_url = NULL (già fatto da funzione DB)
3. DELETE immagine fisica
```

**confirmReject:**
```
1. DELETE immagine fisica
2. CALL reject_review (setta rejected)
3. SET proof_image_url = NULL (già fatto da funzione DB)
4. SEND notification con motivazione
```

### Gestione Errori

Se l'eliminazione dell'immagine fallisce:
- Il processo continua comunque
- `proof_image_url` viene settato a NULL nel database
- L'immagine fisica rimane nello storage (pulizia manuale necessaria)
- Consideriamo un job di cleanup periodico per immagini orfane

---

**Data Implementazione:** 5 Marzo 2026
**Stato:** Attivo e Funzionante
**Versione:** 1.0
