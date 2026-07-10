# 📊 Stato Importazione Attività

## Database Attuale

**Totale Attività**: 29,018

### Distribuzione per Regione
- Calabria: 800
- Abruzzo: 198
- Basilicata: 2

### Top Categorie Popolate
1. Agenzie Immobiliari (267)
2. Distributori di Carburante (178)
3. Elettricisti (131)
4. Ottici (112)
5. Panifici (90)
6. Arredamento (66)
7. Fioristi (64)
8. Elettronica (46)
9. Ostelli (23)
10. Falegnami (11)

### Dati di Contatto
- Con Email: 2,016 (6.9%)
- Con Telefono: 8,589 (29.6%)
- Con Sito Web: 4,805 (16.6%)

## Categorie Disponibili

**Totale categorie nel database**: 230

La maggior parte delle categorie (217) non hanno ancora attività importate.

## Script di Importazione Creati

### 1. `import-comprehensive.js` ✅ RACCOMANDATO
**Caratteristiche**:
- 72 categorie mappate accuratamente OSM → Database
- Importazione per tutte le 20 regioni italiane
- Gestione duplicati automatica
- Mapping completo: Ristoranti, Bar, Negozi, Professionisti, Artigiani, Servizi

**Uso**:
```bash
npm run import:comprehensive
```

**Tempo stimato**: 8-12 ore per importazione completa
**Categorie coperte**: 72/230 (31%)

### 2. `import-small-towns.js`
**Caratteristiche**:
- Focus su professionisti e artigiani
- 54 categorie specifiche
- Tutte le 106 province italiane
- Ottimizzato per piccoli comuni

**Uso**:
```bash
npm run import:small-towns
```

### 3. `import-fast-national.js`
**Caratteristiche**:
- 20 categorie più popolate
- Query rapide per regione
- Focus su servizi essenziali

**Uso**:
```bash
npm run import:fast
```

## Limitazioni Attuali

### Overpass API
- **Rate Limiting**: Max 2 richieste/secondo
- **Timeout**: Query complesse falliscono (504)
- **Coverage**: Dati OSM non sempre completi per l'Italia
- **Velocità**: Molto lenta per importazioni massive

### Soluzioni Alternative Raccomandate

#### 1. **Geofabrik PBF Files** (PIÙ VELOCE)
Download diretto dei dati OSM dell'Italia pre-processati:
- File: italy-latest.osm.pbf (~1.5GB)
- Source: https://download.geofabrik.de/europe/italy.html
- Pro: Velocissimo, completo, nessun rate limit
- Contro: Richiede parsing PBF

#### 2. **Google Places API**
- Pro: Dati commerciali molto completi, aggiornati, affidabili
- Contro: Richiede API key, costi dopo quota gratuita
- Copertura: Eccellente per l'Italia

#### 3. **Dati Aperti Regioni Italiane**
Molte regioni italiane pubblicano dataset aperti delle attività commerciali:
- Pro: Dati ufficiali, affidabili
- Contro: Formato vario, coverage non uniforme

## Script Supporto Creati

### Monitoraggio
```bash
npm run stats              # Statistiche database
node list-all-categories.js # Lista tutte le categorie
npm run check:emails        # Verifica attività con email
```

### Test
```bash
node test-small-towns.js    # Test importazione singola provincia
```

## Prossimi Passi Raccomandati

### Opzione A: Continuare con OSM (Lento ma Gratuito)
1. Avviare `import-comprehensive.js` in background
2. Lasciare girare 8-12 ore
3. Importerà ~50,000-100,000 attività

```bash
nohup npm run import:comprehensive > import.log 2>&1 &
tail -f import.log
```

### Opzione B: Geofabrik (Veloce - 1-2 ore)
1. Scaricare italy-latest.osm.pbf
2. Usare osmium o osmosis per estrarre dati
3. Importare in batch nel database
4. Importerà ~500,000+ attività

### Opzione C: Google Places API (Completo ma a Pagamento)
1. Ottenere API key Google
2. Usare script `import-businesses-google`
3. Importazione per città maggiori
4. Dati commerciali di alta qualità

### Opzione D: Mix di Fonti
1. OSM per baseline (gratuito)
2. Google Places per città principali (qualità)
3. Dati regionali per completezza

## Monitoraggio Importazione Attiva

Se un'importazione è in corso:

```bash
# Trova il processo
ps aux | grep import

# Controlla il log
tail -f import-*.log

# Verifica database in tempo reale
npm run stats

# Ferma importazione
kill $(pgrep -f "node import")
```

## Categorie da Popolare (Priorità)

### Alta Priorità (Servizi Essenziali)
- Ristoranti (0 → target: 50,000+)
- Bar e Caffè (0 → target: 30,000+)
- Supermercati (0 → target: 5,000+)
- Farmacie (0 → target: 3,000+)
- Banche (0 → target: 5,000+)
- Hotel (0 → target: 10,000+)

### Media Priorità (Servizi Comuni)
- Parrucchieri (0 → target: 15,000+)
- Autofficine (0 → target: 8,000+)
- Abbigliamento (0 → target: 10,000+)
- Calzature (0 → target: 5,000+)

### Bassa Priorità (Servizi Specializzati)
- Gioiellerie
- Librerie
- Gelaterie
- Ecc.

## Note Tecniche

### Performance Database
- Indici: ✅ Ottimizzati per ricerca geo
- RLS: ✅ Attivo su tutte le tabelle
- Storage: ~5MB attuali, ~500MB stimati a pieno carico

### Qualità Dati OSM
- Coordinategeo: ✅ Molto accurate
- Nomi attività: ✅ Buoni
- Indirizzi: ⚠️ Parziali (60-70%)
- Telefoni: ⚠️ Limitati (20-30%)
- Email: ⚠️ Scarsi (5-10%)
- Siti web: ⚠️ Parziali (15-20%)
- Orari: ⚠️ Parziali (30-40%)

Per dati di contatto più completi, considerare fonti commerciali o web scraping autorizzato.
