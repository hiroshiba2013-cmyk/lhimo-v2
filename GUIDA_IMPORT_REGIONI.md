# Guida Importazione Attività per Regione

## Script per importare tutte le attività commerciali italiane da OpenStreetMap

### Utilizzo Base

#### 1. Importare TUTTE le regioni italiane
```bash
npm run import:all-regions
```

Questo comando scaricherà e importerà tutte le 20 regioni italiane nel database.

#### 2. Importare regioni specifiche
```bash
npm run import:region lombardia
npm run import:region "valle d'aosta"
npm run import:region toscana lazio
```

Puoi specificare una o più regioni separandole con spazi.

### Regioni Disponibili

Le 20 regioni italiane supportate:

**Nord-Ovest:**
- Valle d'Aosta
- Piemonte
- Liguria
- Lombardia

**Nord-Est:**
- Trentino-Alto Adige
- Veneto
- Friuli-Venezia Giulia
- Emilia-Romagna

**Centro:**
- Toscana
- Marche
- Umbria
- Lazio

**Sud:**
- Abruzzo
- Molise
- Campania
- Puglia
- Basilicata
- Calabria

**Isole:**
- Sicilia
- Sardegna

### Come Funziona

1. **Download dei file PBF**: Lo script scarica i file da Geofabrik (OpenStreetMap):
   - `nord-ovest-latest.osm.pbf` (~300 MB)
   - `nord-est-latest.osm.pbf` (~300 MB)
   - `centro-latest.osm.pbf` (~200 MB)
   - `sud-latest.osm.pbf` (~200 MB)
   - `isole-latest.osm.pbf` (~150 MB)

2. **Filtraggio per regione**: Lo script filtra le attività in base alla provincia (sigla AO, MI, RM, ecc.)

3. **Categorie importate**: Oltre 100 tipi di attività tra cui:
   - Ristoranti, bar, pizzerie
   - Negozi (abbigliamento, alimentari, elettronica)
   - Artigiani (idraulici, elettricisti, falegnami)
   - Professionisti (avvocati, commercialisti, architetti)
   - Servizi (banche, assicurazioni, agenzie immobiliari)
   - Salute e bellezza (parrucchieri, farmacie, medici)
   - Auto (autofficine, benzinai, autolavaggi)

4. **Importazione nel database**: Le attività vengono salvate nella tabella `unclaimed_business_locations` con:
   - Nome, indirizzo, città, provincia, regione
   - Categoria
   - Telefono, email, sito web (se disponibili)
   - Orari di apertura (se disponibili)
   - Coordinate geografiche (latitudine, longitudine)

### Statistiche Attese

Numero indicativo di attività per regione (totale ~500.000-700.000 in tutta Italia):

- **Lombardia**: ~100.000-120.000
- **Lazio**: ~60.000-70.000
- **Campania**: ~50.000-60.000
- **Veneto**: ~50.000-60.000
- **Piemonte**: ~45.000-50.000
- **Emilia-Romagna**: ~45.000-50.000
- **Sicilia**: ~40.000-50.000
- **Toscana**: ~40.000-45.000
- **Puglia**: ~30.000-35.000
- **Calabria**: ~15.000-20.000
- **Sardegna**: ~15.000-18.000
- **Marche**: ~15.000-18.000
- **Liguria**: ~15.000-18.000
- **Abruzzo**: ~12.000-15.000
- **Friuli-Venezia Giulia**: ~12.000-14.000
- **Trentino-Alto Adige**: ~12.000-14.000
- **Umbria**: ~8.000-10.000
- **Basilicata**: ~5.000-6.000
- **Molise**: ~3.000-4.000
- **Valle d'Aosta**: ~3.000-4.000

### Tempi di Esecuzione

- **Download**: 5-10 minuti per file (una volta sola, poi vengono riutilizzati)
- **Processamento**: 10-30 minuti per regione (dipende dalla dimensione)
- **Totale per tutte le regioni**: 4-8 ore

### Risoluzione Problemi

#### Il file scaricato è troppo piccolo
```bash
rm *.osm.pbf
npm run import:all-regions
```

#### Errore di memoria
Se il processo va in crash per memoria insufficiente, importa una regione alla volta:
```bash
npm run import:region lombardia
npm run import:region veneto
# ecc.
```

#### Verificare le attività importate
```sql
SELECT region, COUNT(*) as total
FROM unclaimed_business_locations
GROUP BY region
ORDER BY total DESC;
```

#### Controllare le categorie più comuni
```sql
SELECT c.name, COUNT(*) as total
FROM unclaimed_business_locations u
JOIN business_categories c ON u.category_id = c.id
WHERE u.region = 'Lombardia'
GROUP BY c.name
ORDER BY total DESC
LIMIT 20;
```

### Note Importanti

1. **Duplicati**: Lo script salta automaticamente le attività già presenti nel database
2. **Cache dei file**: I file PBF scaricati vengono riutilizzati per regioni nella stessa macro-area
3. **Qualità dei dati**: La qualità dipende da OpenStreetMap, alcune attività potrebbero mancare di informazioni complete
4. **Aggiornamenti**: Per avere dati aggiornati, elimina i file `.osm.pbf` e rilancia lo script

### Pulizia

Per liberare spazio dopo l'importazione:
```bash
rm *.osm.pbf
```

I file PBF occupano circa 1-1.5 GB totali.
