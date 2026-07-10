# Guida Importazione Dati da OpenStreetMap

## Script Ottimizzato (CONSIGLIATO)

Il nuovo script `import-osm-optimized.js` importa attività **città per città** per massima velocità e affidabilità.

### Vantaggi

✅ **Query più piccole** - Bbox ridotti per città = risposte più veloci dal server Overpass
✅ **Meno timeout** - Query brevi che completano sempre in tempo
✅ **Gestione errori migliore** - Auto-retry in caso di rate limiting
✅ **Report dettagliato** - Statistiche per città e regione
✅ **Categorie ottimizzate** - Mappatura completa con tutte le categorie del database

### Come Usare

```bash
npm run import:osm:fast
```

### Cosa Viene Importato

Lo script processa **32 città principali italiane** distribuite in tutte le regioni:

#### Nord Italia
- Lombardia: Milano, Varese, Brescia, Bergamo, Como
- Piemonte: Torino
- Liguria: Genova
- Veneto: Venezia, Verona, Padova
- Friuli-Venezia Giulia: Trieste
- Emilia-Romagna: Bologna, Parma, Modena, Ravenna, Ferrara, Rimini

#### Centro Italia
- Toscana: Firenze, Livorno
- Umbria: Perugia
- Lazio: Roma

#### Sud Italia
- Campania: Napoli, Salerno
- Puglia: Bari, Foggia, Lecce
- Calabria: Reggio Calabria

#### Isole
- Sicilia: Palermo, Catania, Messina, Siracusa
- Sardegna: Cagliari

### Categorie Estratte (34 Tipologie)

#### Ristorazione e Alimentari
- Ristoranti
- Bar e Caffè
- Fast Food
- Pub e Locali
- Gelaterie
- Pizzerie
- Panifici e Pasticcerie
- Supermercati
- Alimentari
- Macellerie

#### Negozi e Commercio
- Abbigliamento
- Parrucchieri e Barbieri
- Centri Estetici
- Fioristi
- Farmacie
- Librerie
- Gioiellerie
- Ferramenta

#### Servizi Professionali
- Medici
- Dentisti
- Veterinari
- Avvocati
- Commercialisti
- Architetti
- Agenzie Immobiliari
- Assicurazioni
- Banche

#### Altri Servizi
- Hotel
- B&B
- Palestre
- Autofficine
- Autolavaggi
- Benzinai

### Dati Estratti per Ogni Attività

Per ogni business vengono raccolti (quando disponibili):

✅ Nome attività
✅ Indirizzo completo (via, numero civico)
✅ Città, Provincia
✅ CAP
✅ Coordinate GPS (latitudine/longitudine)
✅ Telefono
✅ Email
✅ Sito web
✅ Orari di apertura
✅ Partita IVA
✅ Categoria

### Funzionalità Avanzate

#### Controllo Duplicati
Lo script verifica automaticamente se un'attività esiste già verificando:
- Città
- Indirizzo (primi 20 caratteri)

Se trova un duplicato, lo salta automaticamente.

#### Gestione Rate Limiting
Se il server Overpass restituisce errore 429 (troppi tentativi):
- Pausa automatica di 60 secondi
- Riprova automaticamente la query

#### Ritardi Ottimizzati
- **800ms** tra categorie senza risultati (veloce)
- **1200ms** tra categorie con risultati (sicuro)
- **2000ms** tra città (rispetta limiti API)

### Output Console

Durante l'esecuzione vedrai:

```
╔══════════════════════════════════════════════════════════════╗
║      IMPORTAZIONE OTTIMIZZATA DA OPENSTREETMAP              ║
║      Query piccole città per città = Veloce e Affidabile   ║
╚══════════════════════════════════════════════════════════════╝

📍 32 città da processare
🏷️  34 categorie per città
⏱️  Tempo stimato: 64 minuti

🏙️  Varese (VA) - Lombardia
   ✅ 127 nuove attività
   📊 Top 3: Bar e Caffè(23), Ristoranti(18), Parrucchieri e Barbieri(15)

🏙️  Milano (MI) - Lombardia
   ✅ 342 nuove attività
   📊 Top 3: Ristoranti(45), Bar e Caffè(38), Farmacie(28)

...

╔══════════════════════════════════════════════════════════════╗
║                 ✅ IMPORTAZIONE COMPLETATA                   ║
╚══════════════════════════════════════════════════════════════╝

📊 Città processate: 32/32
🏢 Totale attività importate: 4523

📍 Riepilogo per regione:

   Lombardia: 856 attività in 5 città
   Lazio: 523 attività in 1 città
   Campania: 412 attività in 2 città
   ...
```

## Personalizzazione

### Modificare le Città

Apri `import-osm-optimized.js` e modifica l'array `CITIES`:

```javascript
const CITIES = [
  { name: 'TuaCittà', province: 'XX', region: 'TuaRegione', bbox: [lat_min, lon_min, lat_max, lon_max] },
  // aggiungi altre città...
];
```

Per trovare il bounding box della tua città:
1. Vai su https://boundingbox.klokantech.com/
2. Cerca la tua città
3. Seleziona "CSV" in basso
4. Copia i 4 numeri nell'ordine: lat_min, lon_min, lat_max, lon_max

### Modificare le Categorie

Modifica l'array `CATEGORIES`:

```javascript
const CATEGORIES = [
  { osm: 'shop=supermarket', db: 'Supermercati' },
  { osm: 'amenity=restaurant', db: 'Ristoranti' },
  // aggiungi altre categorie...
];
```

**Formato OSM Tags:**
- `shop=*` per negozi
- `amenity=*` per servizi
- `office=*` per uffici professionali
- `craft=*` per artigiani
- `tourism=*` per hotel e turismo
- `leisure=*` per sport e tempo libero

Vedi tutte le categorie su: https://wiki.openstreetmap.org/wiki/IT:Map_features

## Problemi Comuni

### Errore 429 (Rate Limit)
Lo script gestisce automaticamente con pausa di 60 secondi. Sii paziente.

### Errore 504 (Timeout)
Il bounding box della città è troppo grande. Riducilo o dividilo in zone più piccole.

### Nessuna attività importata
Possibili cause:
- La città non ha dati OSM per quelle categorie
- Il bounding box non copre la città
- La categoria del database non esiste

### Attività duplicate
Lo script salta automaticamente i duplicati. Se vedi lo stesso business due volte:
- Potrebbero essere due sedi diverse
- L'indirizzo potrebbe essere leggermente diverso

## Confronto Script

### Script Ottimizzato (CONSIGLIATO)
```bash
npm run import:osm:fast
```
- ✅ Query piccole città per città
- ✅ Più veloce e affidabile
- ✅ 32 città principali
- ✅ Gestione errori migliore

### Script Originale
```bash
npm run import:osm
```
- ⚠️ Query grandi per provincia
- ⚠️ Più timeout
- ⚠️ 9 province
- ⚠️ Più lento

## Best Practices

1. **Prima importazione**: Usa lo script ottimizzato per avere subito molti dati
2. **Espansione**: Aggiungi gradualmente altre città all'array CITIES
3. **Manutenzione**: Riesegui lo script ogni 3-6 mesi per aggiornamenti
4. **Personalizzazione**: Aggiungi solo le categorie rilevanti per il tuo business

## Note Tecniche

- **Attività "unclaimed"**: Tutte importate con `is_claimed=false` e `verified=true`
- **Proprietari**: Possono reclamare la loro attività dalla piattaforma
- **Coordinate GPS**: Disponibili per tutte le attività (da OpenStreetMap)
- **Qualità dati**: Varia in base alla completezza dei dati OSM nella zona

## Supporto

Per problemi o domande:
1. Controlla questa guida
2. Verifica il file `.env` sia configurato correttamente
3. Controlla i log della console per errori specifici
