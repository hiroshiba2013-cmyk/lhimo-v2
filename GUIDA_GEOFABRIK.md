# Importazione Completa da Geofabrik

Questo script importa **TUTTE** le attività commerciali, liberi professionisti, artigiani e aziende d'Italia da OpenStreetMap tramite Geofabrik, organizzate per regione, provincia, città e categoria.

## Vantaggi rispetto all'API Overpass

✅ **Nessun rate limit** - Nessuna attesa tra le richieste
✅ **Dati completi** - Tutto il database italiano in una volta
✅ **Più veloce** - Processing locale del file
✅ **Più affidabile** - Nessun timeout dell'API
✅ **Aggiornato** - File aggiornato quotidianamente

## Come Funziona

1. **Scarica** automaticamente il file `italy-latest.osm.pbf` da Geofabrik (~1-2 GB)
2. **Processa** tutti i POI (Points of Interest) del file
3. **Filtra** solo le attività commerciali rilevanti
4. **Organizza** per categoria, regione, provincia e città
5. **Importa** nel database Supabase

## Cosa Viene Importato

### Ristorazione (50+ categorie)
- Ristoranti, Pizzerie, Trattorie
- Bar, Caffè, Pub, Enoteche
- Fast Food, Gelaterie
- Panifici, Pasticcerie

### Negozi (100+ categorie)
- Supermercati, Alimentari
- Abbigliamento, Calzature
- Elettronica, Telefonia
- Gioiellerie, Ottica
- Ferramenta, Arredamento
- Librerie, Giocattoli
- Parrucchieri, Centri Estetici
- Farmacie, Erboristerie
- E molti altri...

### Professionisti (30+ categorie)
- Medici, Dentisti, Veterinari
- Avvocati, Notai
- Commercialisti
- Architetti, Ingegneri
- Agenzie Immobiliari
- Assicurazioni

### Artigiani (20+ categorie)
- Idraulici
- Elettricisti
- Falegnami
- Imbianchini
- Meccanici, Carrozzerie
- Sarti
- Calzolai
- Fotografi

### Servizi (40+ categorie)
- Hotel, B&B, Agriturismi
- Banche, Poste
- Palestre, Piscine
- Stazioni di Servizio
- Autolavaggi, Parcheggi
- Lavanderie
- Agenzie di Viaggio
- E molti altri...

## Installazione

Le dipendenze necessarie sono già installate:
```bash
npm install
```

## Esecuzione

```bash
npm run import:geofabrik
```

## Processo Dettagliato

### Fase 1: Download (5-15 minuti)
```
📥 Download da Geofabrik...
📦 Download: 45.2% (876.3/1940.5 MB)
```

Il file viene salvato come `italy-latest.osm.pbf` nella root del progetto.

**Nota**: Se il file esiste già, viene saltato il download.

### Fase 2: Processamento (10-30 minuti)
```
📖 Lettura e processamento file PBF...
🔍 Nodi processati: 12,456,789 | Trovati: 45,321
```

Lo script legge il file PBF e estrae tutti i POI rilevanti.

### Fase 3: Importazione (variabile)
```
💾 Importazione nel database...
📦 Batch 1/906 (50 attività)
   ✓ Inserite: 42 | Saltate: 8 | Errori: 0 (5.5%)
```

Le attività vengono inserite nel database in batch di 50.

### Fase 4: Riepilogo
```
╔══════════════════════════════════════════════════════════════╗
║              ✅ IMPORTAZIONE COMPLETATA                      ║
╚══════════════════════════════════════════════════════════════╝

📊 Riepilogo:

   Totale trovate:     45,321
   ✅ Inserite:        38,456
   ⏭️  Saltate:         6,123
   ❌ Errori:          742

📍 Per Regione (top 10):

   Lombardia                 12,456
   Lazio                     8,234
   Campania                  5,678
   Veneto                    4,321
   Sicilia                   3,890
   ...

🏷️  Per Categoria (top 10):

   Ristoranti                3,456
   Bar e Caffè               2,890
   Parrucchieri e Barbieri   2,345
   Supermercati              1,890
   Farmacie                  1,456
   ...
```

## Dati Estratti per Ogni Attività

Per ogni attività vengono estratti (quando disponibili):

- ✅ **Nome** (obbligatorio)
- ✅ **Categoria** (obbligatorio)
- ✅ **Città** (obbligatorio)
- 📍 Indirizzo completo (via + numero civico)
- 📍 Provincia
- 📍 Regione
- 📍 CAP
- 📞 Telefono
- 🌐 Sito web
- 📧 Email
- 🕐 Orari di apertura

## Organizzazione Geografica

### 20 Regioni
Tutte le regioni italiane sono coperte:
- Valle d'Aosta, Piemonte, Liguria
- Lombardia, Trentino-Alto Adige, Veneto, Friuli-Venezia Giulia
- Emilia-Romagna, Toscana, Umbria, Marche
- Lazio, Abruzzo, Molise
- Campania, Puglia, Basilicata, Calabria
- Sicilia, Sardegna

### 107 Province
Tutte le province italiane

### 7.900+ Comuni
Praticamente tutti i comuni dove esistono attività commerciali

## Gestione Duplicati

Lo script controlla automaticamente se un'attività esiste già verificando:
- Città
- Indirizzo (primi 20 caratteri)

Le attività duplicate vengono **saltate**, non duplicate.

## Stato delle Attività Importate

Tutte le attività importate hanno:
- ✅ `verified: true` (dati verificati da OpenStreetMap)
- 🔓 `is_claimed: false` (non ancora reclamate dai proprietari)
- 👤 `owner_id: null` (nessun proprietario)

Questo permette ai proprietari di **reclamare** la loro attività e gestirla.

## Requisiti di Sistema

- **Spazio disco**: Almeno 3 GB liberi (2 GB file + 1 GB temporanei)
- **RAM**: Almeno 2 GB disponibili
- **Tempo**: 30-60 minuti totali
- **Connessione**: Stabile per il download iniziale

## Gestione File

Dopo l'importazione, il file `italy-latest.osm.pbf` rimane sul disco.

### Eliminare il file
```bash
rm italy-latest.osm.pbf
```

### Mantenere il file
Utile per importazioni future o per processare altre categorie.

## Re-importazione

Se vuoi scaricare una versione aggiornata:

```bash
rm italy-latest.osm.pbf
npm run import:geofabrik
```

I file di Geofabrik sono aggiornati **quotidianamente**.

## Personalizzazione

### Modificare le Categorie

Apri `import-from-geofabrik.js` e modifica `CATEGORY_MAPPING`:

```javascript
const CATEGORY_MAPPING = {
  'restaurant': 'Ristoranti',
  'cafe': 'Bar e Caffè',
  // Aggiungi le tue categorie...
  'theatre': 'Teatri',
  'cinema': 'Cinema',
};
```

### Filtrare per Regione

Puoi modificare lo script per importare solo determinate regioni:

```javascript
// Aggiungi questo filtro nella funzione processPBF
if (!region || region !== 'Lombardia') continue;
```

### Batch Size

Modifica la dimensione dei batch (default 50):

```javascript
const batchSize = 100; // Più veloce ma più pesante
```

## Troubleshooting

### Download Fallito
```bash
rm italy-latest.osm.pbf
npm run import:geofabrik
```

### Errori di Memoria
Chiudi altri programmi o aumenta la memoria disponibile per Node:
```bash
NODE_OPTIONS="--max-old-space-size=4096" npm run import:geofabrik
```

### Errori di Database
Verifica che:
- Le credenziali Supabase in `.env` siano corrette
- La connessione internet sia attiva
- Le tabelle del database esistano

### Processamento Lento
È normale! Il file contiene milioni di nodi e richiede tempo.

## Confronto con Overpass API

| Caratteristica | Overpass API | Geofabrik |
|---|---|---|
| Rate Limit | ⚠️ Sì (delay 2-5 sec) | ✅ No |
| Timeout | ⚠️ Sì (90 sec) | ✅ No |
| Dati completi | ⚠️ Query per query | ✅ Tutto in una volta |
| Velocità | ⚠️ Lenta (ore) | ✅ Veloce (30-60 min) |
| Affidabilità | ⚠️ Media | ✅ Alta |
| Dati aggiornati | ✅ Tempo reale | ✅ Quotidiano |

## Fonti dei Dati

- **Geofabrik**: https://download.geofabrik.de/
- **OpenStreetMap**: https://www.openstreetmap.org/
- **Licenza**: ODbL (Open Database License)

## Nota Importante

I dati provengono da OpenStreetMap e sono contribuiti dalla community.

La **qualità** e **completezza** dei dati dipende da:
- Quanto la zona è mappata su OSM
- Quanto i dati sono aggiornati
- Quanto i contributor locali sono attivi

## Suggerimenti Post-Importazione

1. **Verifica i dati** importati nella dashboard
2. **Aggiungi foto** alle attività principali
3. **Permetti ai proprietari** di reclamare le attività
4. **Incentiva gli utenti** ad aggiornare dati mancanti
5. **Monitora la qualità** dei dati

## Prossimi Passi

Dopo l'importazione:
1. Controlla le statistiche nella dashboard
2. Esplora le attività per regione/categoria
3. Configura il sistema di claim per i proprietari
4. Inizia a raccogliere recensioni
5. Aggiungi foto e descrizioni migliori
