# Requisito Minimo Recensioni - 100 Caratteri

## Panoramica
Per garantire recensioni credibili, complete e dettagliate, è stato implementato un requisito di **minimo 100 caratteri** per la descrizione di tutte le recensioni.

## Dove è Implementato

### 1. Frontend - Form Recensioni (`ReviewForm.tsx`)
- **Validazione JavaScript:** Controlla che `content.trim().length >= 100`
- **Messaggio di errore:** "La descrizione deve contenere almeno 100 caratteri per garantire una recensione completa e credibile"
- **Contatore visivo in tempo reale:**
  - Rosso: "Ancora X caratteri necessari (minimo 100)" quando sotto i 100
  - Verde: "✓ Requisito minimo soddisfatto" quando >= 100
- **Info box blu:** Spiega il requisito all'utente mentre scrive
- **Label modificata:** Include "(minimo 100 caratteri)" nel titolo del campo

### 2. Pagina Regole (`RulesPage.tsx`)
- **Sezione Recensioni:** Aggiunto punto esplicito con requisito in grassetto rosso
- **Sezione Punti e Badge:** Chiarisce che si applica a tutte le recensioni
- **Box informativo blu:** Dedicato al "Requisito Minimo Caratteri"
- **Cosa NON fare:** Include "Non scrivere recensioni troppo brevi"

### 3. Database (Migration)
- **Constraint CHECK:** `reviews_content_min_length`
- **Validazione:** `LENGTH(TRIM(content)) >= 100`
- **Livello:** Database PostgreSQL (ultima linea di difesa)

### 4. Documentazione Ufficiale (`SISTEMA_PUNTI_UFFICIALE.md`)
- **Regole Recensioni:** Prima regola in grassetto
- **Chiarimento:** Si applica sia a recensioni base (25 punti) che con prova (50 punti)
- **Avviso:** "Recensioni con meno di 100 caratteri non vengono accettate"

## Motivazione
Il requisito di 100 caratteri garantisce:
1. **Credibilità:** Recensioni brevi tipo "Tutto ok" o "Pessimo" non sono utili
2. **Dettaglio:** Costringe l'utente a spiegare la propria esperienza
3. **Qualità:** Migliora la qualità complessiva delle recensioni sulla piattaforma
4. **Utilità:** Aiuta altri utenti a prendere decisioni informate

## Applicazione
- **Tutte le recensioni:** Base (25 punti) e con prova (50 punti)
- **Validazione multilivello:** Frontend → Backend → Database
- **Nessuna eccezione:** Il requisito è obbligatorio per tutti

## Esperienza Utente
L'utente viene informato del requisito in **3 momenti**:

1. **Prima di scrivere:** Nella pagina Regole/Guida
2. **Durante la scrittura:**
   - Box informativo blu sopra il campo
   - Contatore in tempo reale
   - Label del campo
3. **Al tentativo di invio:** Messaggio di errore se < 100 caratteri

Questo approccio educativo e progressivo riduce la frustrazione e migliora la compliance.

---

**Data Implementazione:** 5 Marzo 2026
**Stato:** Attivo e Funzionante
