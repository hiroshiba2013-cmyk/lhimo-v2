# Guida: Importare Attività da Google Places API

## 📋 Cosa può importare

La funzione importa **tutti i tipi di attività**:

### Professionisti
- Avvocati
- Commercialisti
- Notai
- Architetti
- Medici e Dentisti

### Artigiani
- Idraulici
- Elettricisti
- Imbianchini
- Falegnami
- Imprese Edili

### Attività Commerciali
- Ristoranti, Bar, Pizzerie
- Negozi (abbigliamento, elettronica, librerie)
- Farmacie, Parrucchieri
- Hotel, B&B
- E molte altre...

---

## 🔑 Step 1: Ottenere API Key Google

### 1. Vai su Google Cloud Console
👉 https://console.cloud.google.com/

### 2. Crea un nuovo progetto (o usa uno esistente)

### 3. Abilita le API necessarie
Vai su "API e Servizi" → "Libreria" e abilita:
- **Places API (New)**
- **Geocoding API**

### 4. Crea le credenziali
1. Vai su "API e Servizi" → "Credenziali"
2. Clicca "Crea credenziali" → "Chiave API"
3. Copia la tua API key

### 5. Limiti gratuiti
Google offre **200€ di credito gratuito al mese**, che equivale a:
- Circa 40.000 ricerche Places
- Più che sufficienti per iniziare

---

## 🚀 Step 2: Importare le Attività

### Metodo 1: Da Terminale (Consigliato)

```bash
curl -X POST \
  'https://lrqeojukjpjllnvsjtor.supabase.co/functions/v1/import-businesses-google' \
  -H 'Authorization: Bearer TUA_SUPABASE_KEY' \
  -H 'Content-Type: application/json' \
  -d '{
    "city": "Varese",
    "province": "VA",
    "apiKey": "TUA_GOOGLE_API_KEY",
    "radius": 5000
  }'
```

Sostituisci:
- `TUA_SUPABASE_KEY` con la tua Supabase Anon Key (nel file `.env`)
- `TUA_GOOGLE_API_KEY` con la chiave Google ottenuta prima

### Metodo 2: Da JavaScript

```javascript
const response = await fetch(
  `${import.meta.env.VITE_SUPABASE_URL}/functions/v1/import-businesses-google`,
  {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${import.meta.env.VITE_SUPABASE_ANON_KEY}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      city: 'Varese',
      province: 'VA',
      apiKey: 'TUA_GOOGLE_API_KEY',
      radius: 5000, // 5 km di raggio
    }),
  }
);

const result = await response.json();
console.log(`Importate ${result.imported} attività`);
```

---

## 📊 Parametri della funzione

| Parametro | Tipo | Descrizione | Esempio |
|-----------|------|-------------|---------|
| `city` | string | Nome della città | `"Varese"` |
| `province` | string | Sigla provincia | `"VA"` |
| `apiKey` | string | Google API Key | `"AIza..."` |
| `radius` | number | Raggio in metri (opzionale) | `5000` (default) |

---

## 💡 Consigli

### Importare più città
Puoi fare chiamate multiple per città diverse:

```bash
# Varese
curl -X POST ... -d '{"city": "Varese", "province": "VA", "apiKey": "..."}'

# Milano
curl -X POST ... -d '{"city": "Milano", "province": "MI", "apiKey": "..."}'

# Como
curl -X POST ... -d '{"city": "Como", "province": "CO", "apiKey": "..."}'
```

### Raggio di ricerca
- `1000` = 1 km (solo centro città)
- `5000` = 5 km (default, copre città medie)
- `10000` = 10 km (città grandi)
- `50000` = 50 km (intera provincia)

### Limiti API
La funzione fa **10 richieste per città** (una per ogni tipo di attività).
- 1 città = 10 richieste
- 10 città = 100 richieste
- Rispetta il limite di 200€/mese gratuito

---

## ❌ Risoluzione Problemi

### Errore: "Invalid API key"
Verifica che:
1. Hai abilitato Places API e Geocoding API
2. La chiave API è corretta
3. Non ci sono restrizioni sulla chiave

### Errore: "Unauthorized"
Verifica che stai passando l'header Authorization con la Supabase key.

### Nessuna attività importata
- Prova ad aumentare il `radius`
- Verifica che la città sia scritta correttamente
- Alcune categorie potrebbero non avere risultati in quella zona

---

## 📝 Esempio Completo

```bash
# Importa tutte le attività di Varese nel raggio di 10 km
curl -X POST \
  'https://lrqeojukjpjllnvsjtor.supabase.co/functions/v1/import-businesses-google' \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...' \
  -H 'Content-Type: application/json' \
  -d '{
    "city": "Varese",
    "province": "VA",
    "apiKey": "AIzaSyD...",
    "radius": 10000
  }'

# Risposta:
# {
#   "message": "Businesses imported successfully from Google Places",
#   "imported": 245
# }
```

Fatto! Le attività sono ora nel database e visibili nella tua app.
