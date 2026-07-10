# SISTEMA PUNTI UFFICIALE - NON MODIFICABILE

**IMPORTANTE: Questo documento definisce il sistema dei punti della piattaforma. I valori QUI specificati NON DEVONO MAI essere modificati senza autorizzazione esplicita.**

## PARAMETRI UFFICIALI

### 1. RECENSIONI
- **Recensione con prova** (foto scontrino/fattura): **50 punti**
- **Recensione senza prova**: **25 punti**

**Regole:**
- **REQUISITO OBBLIGATORIO:** La descrizione deve contenere **almeno 100 caratteri**
- Questo requisito si applica sia alle recensioni base che a quelle con prova
- Le recensioni devono essere approvate da un admin prima di assegnare punti
- La prova (proof_image_url) viene verificata manualmente dall'admin
- I punti vengono assegnati solo dopo approvazione
- Se una recensione viene eliminata, i punti vengono sottratti
- Recensioni con meno di 100 caratteri non vengono accettate

### 2. ATTIVITÀ COMMERCIALI AGGIUNTE
- **Attività completa** (con almeno email, telefono o sito web): **25 punti**
- **Attività base** (solo nome e indirizzo): **10 punti**

**Regole:**
- Si applicano sia a `unclaimed_business_locations` che a `user_added_businesses`
- I punti vengono assegnati automaticamente all'inserimento
- Se l'attività viene eliminata, i punti vengono sottratti

### 3. ANNUNCI CLASSIFICATI
- **Annuncio pubblicato**: **5 punti**

**Regole:**
- Punti assegnati automaticamente alla pubblicazione
- Si applica a tutti i tipi di annunci (vendita, acquisto, regalo)
- I punti vengono sottratti se l'annuncio viene eliminato

### 4. REFERRAL (Invita un Amico)
- **Amico invitato si abbona**: **30 punti**

**Regole:**
- I punti vengono assegnati solo quando l'amico invitato attiva un abbonamento
- L'abbonamento trial non conta per il referral
- Punti assegnati al referrer (chi ha invitato)

### 5. PRODOTTI (NON PIÙ ATTIVO)
- Sistema punti per prodotti è stato **DISABILITATO**
- I prodotti non assegnano più punti

### 6. OFFERTE DI LAVORO (NON PIÙ ATTIVO)
- Sistema punti per job posting è stato **DISABILITATO**
- Le offerte di lavoro non assegnano più punti

---

## IMPLEMENTAZIONE TECNICA

### Tabella User Activity
La tabella `user_activity` tiene traccia dei punti totali:
```sql
- total_points: INTEGER (punti totali dell'utente)
- reviews_count: INTEGER (numero recensioni approvate)
- businesses_added_count: INTEGER (numero attività aggiunte)
- ads_count: INTEGER (numero annunci pubblicati)
```

### Funzioni Principali

1. **award_points(user_id, points, action_type, description)**
   - Assegna punti a un utente
   - Aggiorna `user_activity.total_points`
   - Crea un log in `activity_log`

2. **approve_review(review_id, staff_id)**
   - Approva una recensione
   - Assegna 50 punti se c'è prova, 25 punti altrimenti
   - Aggiorna il conteggio recensioni in `user_activity`

3. **award_points_for_unclaimed_business()**
   - Trigger automatico su INSERT in `unclaimed_business_locations`
   - Assegna 25 punti se completa, 10 se base

4. **award_points_for_classified_ad()**
   - Trigger automatico su INSERT in `classified_ads`
   - Assegna 5 punti

### Trigger Attivi

**INSERIMENTI (assegnano punti):**
- `trigger_award_points_unclaimed_business` → unclaimed_business_locations
- `trigger_award_points_user_added_business` → user_added_businesses
- `trigger_award_points_classified_ad` → classified_ads
- `trigger_process_referral` → subscriptions (quando status = 'active')

**ELIMINAZIONI (sottraggono punti):**
- `trigger_subtract_points_deleted_review` → reviews
- `trigger_subtract_points_for_deleted_unclaimed_business` → unclaimed_business_locations
- `trigger_subtract_points_user_added_business` → user_added_businesses
- `trigger_subtract_points_classified_ad` → classified_ads

---

## CLASSIFICA (Leaderboard)

La classifica ordina gli utenti per:
1. **total_points** (decrescente)
2. **created_at** (a parità di punti, vince chi si è iscritto prima)

Query:
```sql
SELECT
  u.user_id,
  p.full_name,
  p.avatar_url,
  u.total_points,
  u.reviews_count,
  u.businesses_added_count,
  u.ads_count
FROM user_activity u
JOIN profiles p ON p.id = u.user_id
WHERE u.total_points > 0
ORDER BY u.total_points DESC, u.created_at ASC
LIMIT 100;
```

---

## CONTROLLI DI INTEGRITÀ

### Verifica Corretta dei Punti
Per verificare che i punti siano corretti:

```sql
-- Verifica punti recensioni
SELECT
  customer_id,
  COUNT(*) as recensioni,
  SUM(CASE WHEN proof_image_url IS NOT NULL THEN 50 ELSE 25 END) as punti_recensioni
FROM reviews
WHERE review_status = 'approved'
GROUP BY customer_id;

-- Verifica punti attività
SELECT
  added_by,
  COUNT(*) as attivita,
  SUM(CASE
    WHEN (email IS NOT NULL AND email != '')
      OR (phone IS NOT NULL AND phone != '')
      OR (website IS NOT NULL AND website != '')
    THEN 25
    ELSE 10
  END) as punti_attivita
FROM unclaimed_business_locations
WHERE added_by IS NOT NULL
GROUP BY added_by;

-- Verifica punti annunci
SELECT
  owner_id,
  COUNT(*) as annunci,
  COUNT(*) * 5 as punti_annunci
FROM classified_ads
GROUP BY owner_id;
```

---

## REGOLE IMPORTANTI

1. **NON modificare manualmente i punti** in user_activity senza documentare il motivo
2. **Tutti i punti devono essere assegnati tramite trigger o funzioni**, mai manualmente
3. **La classifica deve essere sempre accurata** - verifica regolarmente l'integrità
4. **In caso di errori**, usa i controlli di integrità per ricalcolare i punti corretti
5. **Ogni modifica ai parametri punti deve essere documentata** in questo file

---

## STORIA MODIFICHE

**2026-03-05**: Documento creato con parametri ufficiali:
- Recensioni: 50 punti (con prova) / 25 punti (senza prova)
- Attività: 25 punti (completa) / 10 punti (base)
- Annunci: 5 punti
- Referral: 30 punti
- Prodotti e job posting DISABILITATI

---

## NOTA FINALE

**Questo sistema è stato testato e validato. NON apportare modifiche senza:**
1. Documentare il motivo della modifica
2. Aggiornare questo documento
3. Testare l'impatto sulla classifica esistente
4. Comunicare agli utenti eventuali cambiamenti
