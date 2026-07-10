# 🏘️ Importazione Attività - Piccole Città (<10k abitanti)

## 📋 Descrizione

Questo script importa attività commerciali e professionisti da OpenStreetMap per **tutte le città italiane con meno di 10.000 abitanti**, organizzate per:

- **Categoria** (60+ categorie di professionisti e artigiani)
- **Regione** (20 regioni)
- **Provincia** (110 province)
- **Città** (migliaia di piccoli comuni)

## 🎯 Focus Categorie

Lo script si concentra su categorie rilevanti per piccoli centri abitati:

### Professionisti Sanitari (10 categorie)
- Dentisti, Medici, Farmacie
- Veterinari, Fisioterapisti, Psicologi
- Podologi, Logopedisti, Optometristi, Ostetriche

### Professionisti e Studi (10 categorie)
- Avvocati, Commercialisti, Consulenti Fiscali
- Architetti, Ingegneri, Geometri
- Agenzie Immobiliari, Assicurazioni, Notai, Fotografi

### Artigiani (17 categorie)
- Falegnami, Elettricisti, Idraulici, Imbianchini
- Calzolai, Sarti, Fabbri
- Climatizzazione, Vetrai, Giardinieri
- Lattonieri, Serramenti, Piastrellisti
- Orefici, Orologiai, Ottici

### Negozi Essenziali (11 categorie)
- Supermercati, Alimentari, Panifici
- Macellerie, Frutta e Verdura
- Ferramenta, Parrucchieri, Centri Estetici
- Fioristi, Autofficine, Biciclette

### Servizi (6 categorie)
- Banche, Uffici Postali, Benzinai
- Ristoranti, Bar e Caffè

## 🚀 Come Usare

### Importazione Completa (Tutte le Province)

```bash
npm run import:small-towns
```

Questo comando:
1. Processa **tutte le 110 province italiane**
2. Per ogni provincia cerca **60+ categorie di attività**
3. Importa solo attività **non ancora presenti** nel database
4. Organizza i dati per **regione, provincia e città**

### Stima Tempi

- **Tempo per categoria**: ~3-4 secondi
- **Tempo per provincia**: ~3-5 minuti (60 categorie)
- **Tempo totale stimato**: ~6-8 ore (110 province)

**⚠️ IMPORTANTE**: Questo è uno script a lunga durata. Si consiglia di eseguirlo:
- Durante la notte
- Con una connessione internet stabile
- Utilizzando `screen` o `tmux` per evitare interruzioni

### Esecuzione in Background (Consigliato)

```bash
# Usa screen per eseguire in background
screen -S import-small-towns
npm run import:small-towns

# Esci da screen con: Ctrl+A poi D
# Per riconnettersi: screen -r import-small-towns
```

Oppure con nohup:

```bash
nohup npm run import:small-towns > import-small-towns.log 2>&1 &

# Monitora il progresso
tail -f import-small-towns.log
```

## 📊 Output dello Script

Durante l'esecuzione vedrai:

```
╔═══════════════════════════════════════════════════════════════════╗
║ IMPORTAZIONE PROFESSIONISTI - PICCOLE CITTÀ (<10k ab.)           ║
║                                                                   ║
║ Totale province: 110                                              ║
║ Totale categorie: 60                                              ║
║ Focus: Professionisti, Artigiani, Servizi essenziali             ║
╚═══════════════════════════════════════════════════════════════════╝

======================================================================
📍 PROVINCIA [1/110]: Bergamo (Lombardia)
======================================================================
   [1/60] Dentisti                             ✅ 15
   [2/60] Medici                               ✅ 23
   [3/60] Farmacie                             ✅ 12
   ...

   🎯 TOTALE Bergamo: 234 attività
   📊 Totale complessivo: 234

⏳ Pausa 10 secondi... (1/110)
```

### Riepilogo Ogni 5 Province

Ogni 5 province processate, vedrai un riepilogo con:

- **Top 15 Province** per numero di attività importate
- **Statistiche per Regione**
- **Top 10 Categorie** più popolate

## 🗺️ Copertura Geografica

### Regioni Coperte (20)

- **Nord**: Lombardia, Piemonte, Veneto, Emilia-Romagna, Liguria, Trentino-Alto Adige, Friuli-Venezia Giulia, Valle d'Aosta
- **Centro**: Toscana, Lazio, Marche, Umbria, Abruzzo
- **Sud**: Campania, Puglia, Basilicata, Calabria, Molise
- **Isole**: Sicilia, Sardegna

### Province per Regione

- **Lombardia**: 12 province
- **Piemonte**: 8 province
- **Veneto**: 7 province
- **Emilia-Romagna**: 9 province
- **Toscana**: 10 province
- **E tutte le altre...**

## 💾 Dati Salvati

Per ogni attività importata vengono salvati:

### Dati Obbligatori
- Nome dell'attività
- Indirizzo completo (via, numero civico)
- Città e Comune
- Provincia (codice a 2 lettere)
- Regione
- Categoria
- Coordinate GPS (latitudine, longitudine)

### Dati Opzionali (quando disponibili)
- CAP
- Telefono
- Email
- Sito web
- Orari di apertura

## 🔍 Filtraggio Duplicati

Lo script **evita automaticamente i duplicati** verificando prima dell'inserimento:

```javascript
// Verifica esistenza per: nome + città + indirizzo
if (existing) continue; // Salta se già presente
```

## ⚙️ Configurazione Avanzata

### Modificare le Categorie

Puoi personalizzare le categorie modificando l'array `PROFESSIONAL_CATEGORIES` in `import-small-towns.js`:

```javascript
const PROFESSIONAL_CATEGORIES = [
  { osm: 'amenity=dentist', db: 'Dentisti' },
  { osm: 'craft=carpenter', db: 'Falegnami' },
  // Aggiungi altre categorie qui...
];
```

### Modificare le Province

Puoi limitare l'importazione a specifiche province modificando `ITALIAN_PROVINCES`:

```javascript
// Esempio: solo province della Lombardia
const ITALIAN_PROVINCES = [
  { name: 'Bergamo', code: 'BG', region: 'Lombardia', bbox: [45.5, 9.5, 45.9, 10.2] },
  // ...altre province Lombardia
];
```

### Modificare i Tempi di Attesa

```javascript
// Tempo tra categorie (default: 4 secondi)
await sleep(4000);

// Tempo tra province (default: 10 secondi)
await sleep(10000);
```

**⚠️ ATTENZIONE**: Tempi troppo brevi possono causare:
- Rate limiting da Overpass API
- Timeout delle query
- Ban temporanei

## 🛠️ Risoluzione Problemi

### Errore: Rate Limit

```
⏳ Rate limit, attendo 90 secondi...
```

**Soluzione**: Lo script attende automaticamente. Non fare nulla.

### Errore: Gateway Timeout

```
⚠️  Errore (1/3): Gateway timeout
⏳ Riprovo tra 20s...
```

**Soluzione**: Lo script riprova automaticamente fino a 3 volte.

### Errore: Categoria Non Trovata

```
⚠️  cat. non trovata - SKIP
```

**Soluzione**: La categoria non esiste nel database. Verifica che tutte le categorie siano state create nelle migrazioni.

### Script Interrotto

Se lo script viene interrotto:

1. **Nessun problema!** I dati già importati sono salvati
2. Riavvia lo script: riprenderà dall'ultima provincia non completata
3. I duplicati vengono automaticamente evitati

## 📈 Statistiche Attese

### Stima Attività per Provincia

- **Province molto popolate**: 500-1.000 attività
- **Province medie**: 200-500 attività
- **Province piccole**: 50-200 attività

### Stima Totale Nazionale

- **Totale atteso**: 30.000-60.000 attività
- **Distribuzione**:
  - Professionisti sanitari: ~40%
  - Artigiani: ~30%
  - Negozi: ~20%
  - Altri servizi: ~10%

## 🎯 Dopo l'Importazione

### Verifica Dati Importati

```bash
# Controlla lo stato generale
npm run status

# Verifica il progresso
npm run progress

# Controlla le statistiche dettagliate
npm run monitor
```

### Query Database

```sql
-- Conta attività per regione
SELECT region, COUNT(*) as total
FROM unclaimed_business_locations
GROUP BY region
ORDER BY total DESC;

-- Conta attività per categoria
SELECT c.name, COUNT(*) as total
FROM unclaimed_business_locations ubl
JOIN business_categories c ON ubl.category_id = c.id
GROUP BY c.name
ORDER BY total DESC;

-- Attività per provincia
SELECT province, region, COUNT(*) as total
FROM unclaimed_business_locations
GROUP BY province, region
ORDER BY total DESC;
```

## 📝 Note Importanti

1. **Pausa tra richieste**: Lo script rispetta i limiti di Overpass API con pause di 4-10 secondi
2. **Retry automatico**: In caso di errori temporanei, lo script riprova fino a 3 volte
3. **Nessun duplicato**: Ogni attività viene verificata prima dell'inserimento
4. **Dati verificati**: Tutte le attività importate sono marcate come `verified: true`
5. **Coordinateficia GPS**: Ogni attività ha coordinate precise per la mappa

## 🔗 Risorse

- **Overpass API**: https://overpass-api.de/
- **OpenStreetMap Tags**: https://wiki.openstreetmap.org/wiki/Map_Features
- **Documentazione Supabase**: https://supabase.com/docs

## 💡 Suggerimenti

1. **Prima importazione**: Testa su 1-2 province modificando temporaneamente `ITALIAN_PROVINCES`
2. **Monitoraggio**: Usa `tail -f` per seguire il progresso in tempo reale
3. **Backup**: Esegui un backup del database prima di importazioni massive
4. **Orario**: Esegui durante la notte per evitare sovraccarichi durante il giorno

## 🤝 Contribuire

Per aggiungere nuove categorie o migliorare lo script:

1. Consulta OpenStreetMap wiki per i tag corretti
2. Aggiungi la categoria a `PROFESSIONAL_CATEGORIES`
3. Verifica che la categoria esista nel database
4. Testa su una provincia prima dell'esecuzione completa

---

**Buona importazione! 🚀**
