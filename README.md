# Guida Supabase - Collegamento Progetto

## 📋 Cosa hai fatto finora

✅ Progetto inizializzato con npm
✅ Installato `@supabase/supabase-js`
✅ Creata struttura cartelle `src/lib/`
✅ Creato file di configurazione Supabase
✅ Creati esempi di utilizzo

---

## 🚀 Come completare il collegamento

### **Passo 1: Ottieni le credenziali da Supabase**

1. Vai su [https://supabase.com](https://supabase.com)
2. Accedi o registrati
3. Crea un nuovo progetto o seleziona uno esistente
4. Vai su **Settings** → **API**
5. Copia queste due informazioni:
   - **Project URL** (esempio: `https://abcdefgh.supabase.co`)
   - **anon public key** (una stringa lunga che inizia con `eyJ...`)

### **Passo 2: Aggiorna il file .env**

Apri il file `.env` e sostituisci i placeholder con le tue credenziali:

```env
VITE_SUPABASE_URL=https://tuoprogetto.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### **Passo 3: Crea una tabella su Supabase**

1. Nel dashboard di Supabase, vai su **Table Editor**
2. Clicca su **New Table**
3. Crea una tabella di esempio (es: `tasks`)
4. Aggiungi alcune colonne:
   - `id` (tipo: int8, primary key, auto-increment)
   - `title` (tipo: text)
   - `completed` (tipo: bool, default: false)
   - `created_at` (tipo: timestamptz, default: now())

### **Passo 4: Usa Supabase nel tuo codice**

Guarda il file `src/example.ts` per esempi di come:
- ✅ Leggere dati (`select`)
- ✅ Inserire dati (`insert`)
- ✅ Aggiornare dati (`update`)
- ✅ Eliminare dati (`delete`)

---

## 📚 Esempio rapido

```typescript
import { supabase } from './lib/supabase';

// Leggere tutti i dati
const { data, error } = await supabase
  .from('tasks')
  .select('*');

// Inserire un nuovo record
const { data, error } = await supabase
  .from('tasks')
  .insert([
    { title: 'Imparare Supabase', completed: false }
  ]);

// Aggiornare un record
const { data, error } = await supabase
  .from('tasks')
  .update({ completed: true })
  .eq('id', 1);

// Eliminare un record
const { error } = await supabase
  .from('tasks')
  .delete()
  .eq('id', 1);
```

---

## 🔐 Sicurezza

- ⚠️ Non committare mai il file `.env` su Git
- ⚠️ Usa sempre la `anon key` per il frontend
- ⚠️ Configura le Row Level Security (RLS) policies su Supabase

---

## 🆘 Hai bisogno di aiuto?

- [Documentazione Supabase](https://supabase.com/docs)
- [Guida JavaScript Client](https://supabase.com/docs/reference/javascript/introduction)
