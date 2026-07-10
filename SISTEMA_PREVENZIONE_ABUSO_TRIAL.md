# Sistema di Prevenzione Abuso Trial

## Panoramica

Il sistema previene che gli utenti possano usufruire più volte del periodo di prova gratuito di 30 giorni cambiando email o creando nuovi account.

## Come Funziona

### 1. Identificazione Univoca tramite Codice Fiscale

Il sistema traccia i **codici fiscali** di:
- **Titolare dell'account** (campo `fiscal_code` in `profiles`)
- **Tutti i membri della famiglia** (campo `tax_code` in `customer_family_members`)

### 2. Regole di Blocco

Un utente **NON può attivare il trial** se:
- Il suo codice fiscale è già stato usato per un trial
- Anche solo **uno** dei membri della famiglia ha un CF già usato per un trial
- Non ha inserito il proprio codice fiscale (obbligatorio per il trial)

### 3. Tracciamento Automatico

Quando un utente attiva il trial:
1. Il sistema registra il CF del titolare nella tabella `trial_usage_history`
2. Registra anche tutti i CF dei membri della famiglia
3. Questi CF rimangono permanentemente bloccati

### 4. Protezione Multi-Livello

Il sistema blocca gli abusi in 3 punti:

#### A. Prima della registrazione (Frontend)
```javascript
// Controlla se il CF può usare il trial
const { data } = await supabase.rpc('check_fiscal_code_trial_eligibility', {
  p_fiscal_code: 'RSSMRA80A01H501U'
});

if (!data.eligible) {
  alert(data.message); // "Questo codice fiscale ha già usufruito del periodo di prova"
}
```

#### B. Durante la creazione del profilo (Trigger)
- `create_trial_for_business_profile()` verifica l'idoneità
- `create_trial_for_customer()` verifica l'idoneità

#### C. Durante la creazione della subscription (Trigger)
- `prevent_trial_abuse()` blocca definitivamente se non idoneo
- Incrementa il contatore `attempts_blocked`

### 5. Aggiunta Membri Famiglia

Quando si aggiunge un membro alla famiglia:
```sql
-- Se l'account è in trial e il CF del membro è già stato usato → ERRORE
-- Se l'account è in trial e il CF è nuovo → lo registra automaticamente
```

## Struttura Database

### Tabella `trial_usage_history`

```sql
CREATE TABLE trial_usage_history (
  id uuid PRIMARY KEY,
  fiscal_code text UNIQUE NOT NULL,  -- CF bloccato
  first_user_id uuid,                -- Primo utente che lo ha usato
  first_trial_date timestamptz,      -- Data primo trial
  attempts_blocked integer,          -- Quante volte è stato bloccato
  last_attempt_date timestamptz,     -- Ultimo tentativo
  created_at timestamptz
);
```

## Funzioni Disponibili

### 1. Per il Frontend

#### `check_fiscal_code_trial_eligibility(fiscal_code)`
Controlla se un CF può usare il trial **prima della registrazione**.

```javascript
const { data } = await supabase.rpc('check_fiscal_code_trial_eligibility', {
  p_fiscal_code: 'RSSMRA80A01H501U'
});

// Risposta:
{
  eligible: true/false,
  message: "Codice fiscale idoneo per il periodo di prova"
}
```

**Accessibile a**: Tutti (anche non autenticati)

#### `check_trial_eligibility(user_id)`
Controlla se un utente specifico può attivare il trial (include controllo famiglia).

```javascript
const { data } = await supabase.rpc('check_trial_eligibility', {
  p_user_id: 'uuid-utente'
});

// Risposta:
{
  eligible: true/false,
  reason: "fiscal_code_required" | "trial_already_used" | "family_member_trial_used" | "eligible",
  message: "Descrizione dettagliata"
}
```

**Accessibile a**: Utenti autenticati

### 2. Per gli Admin

#### `get_trial_statistics()`
Statistiche complete sul sistema trial.

```javascript
const { data } = await supabase.rpc('get_trial_statistics');

// Risposta:
{
  total_registered_fiscal_codes: 1234,
  total_attempts_blocked: 56,
  active_trials: 89,
  recent_blocked_attempts: [
    {
      fiscal_code: "RSSMRA***",  // Parzialmente nascosto per privacy
      attempts: 3,
      last_attempt: "2024-03-06T10:30:00Z"
    }
  ]
}
```

#### `get_user_trial_details(user_id)`
Dettagli completi trial di un utente specifico.

```javascript
const { data } = await supabase.rpc('get_user_trial_details', {
  p_user_id: 'uuid-utente'
});

// Risposta:
{
  user_id: "uuid",
  user_fiscal_code: "RSSMRA80A01H501U",
  family_fiscal_codes: ["BNCGVN85D15H501T", "RSSLRA15A01H501M"],
  blocked_fiscal_codes: ["RSSMRA80A01H501U"],
  is_eligible: false,
  eligibility_check: { eligible: false, reason: "trial_already_used", ... }
}
```

## Scenari d'Uso

### Scenario 1: Utente Nuovo (OK)
1. Mario si registra con CF: `RSSMRA80A01H501U`
2. Aggiunge moglie con CF: `BNCGVN85D15H501T`
3. ✅ Trial attivato con successo
4. Entrambi i CF vengono registrati in `trial_usage_history`

### Scenario 2: Utente Prova a Riregistrarsi (BLOCCATO)
1. Mario aveva già usato il trial con email `mario@email.it`
2. Prova a riregistrarsi con `mario.nuovo@email.com`
3. ❌ Sistema blocca: "Questo codice fiscale ha già usufruito del periodo di prova"
4. Incrementa `attempts_blocked` nel database

### Scenario 3: Cambio Titolare (BLOCCATO)
1. Mario aveva già usato il trial
2. La moglie Giovanni prova a registrarsi come titolare
3. Aggiunge Mario come membro della famiglia
4. ❌ Sistema blocca: "Un membro della famiglia ha già usufruito del periodo di prova"

### Scenario 4: Famiglia con Membro Già Registrato (BLOCCATO)
1. Giovanni si registra (non ha mai avuto trial)
2. Prova ad aggiungere Mario (che aveva già usato il trial)
3. ❌ Sistema blocca l'aggiunta: "Il codice fiscale RSSMRA80A01H501U ha già usufruito del periodo di prova"

## Conformità GDPR

Il sistema è **GDPR compliant**:

- ✅ Traccia **solo** i codici fiscali (necessari per il servizio)
- ✅ Non traccia altri dati personali
- ✅ I dati sono visibili **solo agli admin** (RLS)
- ✅ Gli utenti normali non possono vedere chi ha usato il trial
- ✅ Le statistiche admin mostrano CF parzialmente oscurati
- ✅ Base legale: necessità contrattuale (prevenzione abusi)

## Implementazione Frontend

### Durante la Registrazione

```typescript
// 1. Controlla CF prima di procedere
async function checkFiscalCode(fiscalCode: string) {
  const { data, error } = await supabase.rpc('check_fiscal_code_trial_eligibility', {
    p_fiscal_code: fiscalCode
  });

  if (!data?.eligible) {
    alert(data?.message || 'Codice fiscale non valido per il trial');
    return false;
  }

  return true;
}

// 2. Durante la registrazione
async function registerUser(email: string, password: string, fiscalCode: string) {
  // Prima controlla il CF
  const isEligible = await checkFiscalCode(fiscalCode);
  if (!isEligible) return;

  // Procedi con la registrazione
  const { data: authData, error } = await supabase.auth.signUp({
    email,
    password
  });

  if (!error) {
    // Crea profilo con CF
    await supabase.from('profiles').insert({
      id: authData.user.id,
      email,
      fiscal_code: fiscalCode,
      user_type: 'customer'
    });
  }
}
```

### Aggiunta Membri Famiglia

```typescript
async function addFamilyMember(customerId: string, memberData: any) {
  const { data, error } = await supabase
    .from('customer_family_members')
    .insert({
      customer_id: customerId,
      first_name: memberData.firstName,
      last_name: memberData.lastName,
      date_of_birth: memberData.dateOfBirth,
      tax_code: memberData.fiscalCode,  // Verrà controllato automaticamente
      relationship: memberData.relationship
    });

  if (error?.code === '23514') {
    alert('Questo membro della famiglia ha già usufruito del periodo di prova');
    return false;
  }

  return true;
}
```

### Dashboard Admin

```typescript
async function loadTrialStats() {
  const { data } = await supabase.rpc('get_trial_statistics');

  return {
    totalRegistered: data.total_registered_fiscal_codes,
    totalBlocked: data.total_attempts_blocked,
    activeTrials: data.active_trials,
    recentBlocks: data.recent_blocked_attempts
  };
}

async function checkUserEligibility(userId: string) {
  const { data } = await supabase.rpc('get_user_trial_details', {
    p_user_id: userId
  });

  return data;
}
```

## Test del Sistema

### Test 1: Nuovo Utente con CF Valido
```sql
-- Simula registrazione nuovo utente
SELECT check_fiscal_code_trial_eligibility('RSSMRA80A01H501U');
-- Risultato: { eligible: true, ... }
```

### Test 2: CF Già Usato
```sql
-- Dopo che Mario ha attivato il trial
SELECT check_fiscal_code_trial_eligibility('RSSMRA80A01H501U');
-- Risultato: { eligible: false, message: "Questo codice fiscale ha già usufruito del periodo di prova" }
```

### Test 3: Statistiche Admin
```sql
SELECT get_trial_statistics();
```

## Maintenance

### Query Utili per Admin

```sql
-- 1. Vedere tutti i CF bloccati
SELECT fiscal_code, first_trial_date, attempts_blocked, last_attempt_date
FROM trial_usage_history
ORDER BY attempts_blocked DESC;

-- 2. Utenti con più tentativi bloccati (possibili frodatori)
SELECT fiscal_code, attempts_blocked, last_attempt_date
FROM trial_usage_history
WHERE attempts_blocked > 3
ORDER BY attempts_blocked DESC;

-- 3. Trial attivi
SELECT p.email, p.fiscal_code, s.end_date
FROM profiles p
JOIN subscriptions s ON s.customer_id = p.id
WHERE s.status = 'trial'
  AND s.end_date > now();

-- 4. CF registrati oggi
SELECT COUNT(*)
FROM trial_usage_history
WHERE first_trial_date::date = CURRENT_DATE;
```

## Note Importanti

1. **Il CF è obbligatorio** per attivare il trial
2. **Tutto il nucleo familiare** viene tracciato
3. **Il blocco è permanente** (non c'è scadenza)
4. **Retroattivo**: utenti con trial già attivo sono stati registrati
5. **Privacy**: solo admin vedono i dati, CF parzialmente oscurati nelle statistiche

## Codici Errore

- `23514`: Check constraint violation (trial non autorizzato)
- `42501`: Accesso negato (funzione solo admin)

## Limitazioni Note

- Non previene l'uso di CF falsi o inventati (validazione CF separata)
- Richiede che l'utente inserisca onestamente il proprio CF
- Non traccia indirizzi IP o device (possibile evoluzione futura)
