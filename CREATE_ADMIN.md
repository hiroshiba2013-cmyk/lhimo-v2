# Come Creare un Account Admin

Ci sono due metodi per creare un account amministratore:

## Metodo 1: Registrazione Normale + Promozione SQL (CONSIGLIATO)

### Passo 1: Registrati come utente business normale

1. Vai su `/` (homepage)
2. Clicca su "Registrati"
3. Compila il form di registrazione con:
   - Email: `admin@italianreview.com`
   - Password: `AdminSecure2024!`
   - Nome Completo: `Super Amministratore`
   - Codice Fiscale: `ADMINS00A01H501A`
   - Codice Utente/Nickname: `admin001`
   - Tipo Utente: **Business** (importante!)

4. Completa la registrazione

### Passo 2: Promuovi l'utente ad admin

Dopo aver completato la registrazione, esegui questa query SQL nel tuo database Supabase:

```sql
-- Trova il tuo user ID
SELECT id, email, full_name, user_type, is_admin
FROM profiles
WHERE email = 'admin@italianreview.com';

-- Promuovi l'utente ad admin (sostituisci YOUR_USER_ID con l'ID trovato sopra)
UPDATE profiles
SET
  is_admin = true,
  user_type = 'admin',
  subscription_status = 'active'
WHERE email = 'admin@italianreview.com';

-- Aggiungi alla tabella admins (sostituisci YOUR_USER_ID con l'ID trovato sopra)
INSERT INTO admins (user_id)
SELECT id FROM profiles WHERE email = 'admin@italianreview.com'
ON CONFLICT (user_id) DO NOTHING;

-- Verifica che tutto sia configurato correttamente
SELECT
  p.id,
  p.email,
  p.full_name,
  p.user_type,
  p.is_admin,
  a.user_id as in_admins_table
FROM profiles p
LEFT JOIN admins a ON p.id = a.user_id
WHERE p.email = 'admin@italianreview.com';
```

### Passo 3: Accedi come admin

Vai su `/admin-login` e accedi con le credenziali:
- Email: `admin@italianreview.com`
- Password: `AdminSecure2024!`

---

## Metodo 2: Utilizzare l'Edge Function (Richiede configurazione)

⚠️ **Nota**: Questo metodo richiede che l'edge function sia deployata e configurata correttamente.

### Prerequisiti

1. L'edge function `admin-register` deve essere deployata
2. Devi conoscere la chiave segreta admin (default: `ADMIN_2024_SECRET_KEY`)

### Passi

1. Vai su `/admin-secure-register-2024`
2. Compila il form:
   - Email: `admin@italianreview.com`
   - Password: `AdminSecure2024!`
   - Nome Completo: `Super Amministratore`
   - Codice Fiscale: `ADMINS00A01H501A`
   - Codice Utente: `admin001`
   - Chiave Admin: `ADMIN_2024_SECRET_KEY`

3. Clicca su "Registra Admin"

---

## Troubleshooting

### "Non hai i permessi di amministratore"

Questo errore significa che l'utente esiste ma NON è nella tabella `admins` o il campo `is_admin` è `false`.

**Soluzione**: Esegui questa query SQL:

```sql
-- Verifica lo stato attuale
SELECT
  p.id,
  p.email,
  p.is_admin,
  a.user_id as in_admins_table
FROM profiles p
LEFT JOIN admins a ON p.id = a.user_id
WHERE p.email = 'admin@italianreview.com';

-- Se is_admin è false, impostalo a true
UPDATE profiles
SET is_admin = true
WHERE email = 'admin@italianreview.com';

-- Se non è nella tabella admins, aggiungilo
INSERT INTO admins (user_id)
SELECT id FROM profiles WHERE email = 'admin@italianreview.com'
ON CONFLICT (user_id) DO NOTHING;
```

### "Email o password non validi"

Questo errore significa che l'utente NON esiste nel sistema auth.

**Soluzione**: Utilizza il Metodo 1 e registrati prima come utente normale.

---

## Verificare che tutto funzioni

Dopo aver completato la configurazione, esegui questa query per verificare:

```sql
SELECT
  p.id,
  p.email,
  p.full_name,
  p.user_type,
  p.is_admin,
  p.subscription_status,
  a.user_id as in_admins_table,
  a.created_at as admin_since
FROM profiles p
LEFT JOIN admins a ON p.id = a.user_id
WHERE p.email = 'admin@italianreview.com';
```

Dovresti vedere:
- `is_admin`: true
- `user_type`: admin
- `subscription_status`: active
- `in_admins_table`: un UUID (non null)

## Credenziali di Default

Per riferimento rapido:

- **Email**: admin@italianreview.com
- **Password**: AdminSecure2024!
- **URL Login**: /admin-login
