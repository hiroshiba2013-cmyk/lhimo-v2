# 🚀 Importazione Completa Attività Italia

## Quale Script Usare?

Hai **3 opzioni** per importare attività da OpenStreetMap:

### 🏆 1. Geofabrik (CONSIGLIATO)
```bash
npm run import:geofabrik
```

**✅ Vantaggi:**
- Importa TUTTE le attività d'Italia
- Nessun rate limit
- Nessun timeout
- Più veloce e affidabile
- File scaricabile da Geofabrik

**⚠️ Requisiti:**
- 3 GB spazio disco
- 30-60 minuti di tempo

**📖 Guida completa:** `GUIDA_GEOFABRIK.md`

---

### 2. Overpass API (Per Province)
```bash
npm run import:osm
```

**✅ Vantaggi:**
- Scegli quali province importare
- Non serve scaricare file grandi

**⚠️ Svantaggi:**
- Rate limit (pause tra richieste)
- Timeout dopo 90 secondi
- Lento per molte province

**📖 Guida:** `IMPORT_OSM.md`

---

### 3. Overpass API Ottimizzato (Per Città)
```bash
npm run import:osm:fast
```

**✅ Vantaggi:**
- Query piccole e veloci
- Meno timeout
- Per città specifiche

**⚠️ Svantaggi:**
- Solo città predefinite nello script
- Rate limit comunque presente

**📖 Guida:** `IMPORT_OSM.md`

---

## Raccomandazione

### Per importare TUTTE le attività d'Italia:
```bash
npm run import:geofabrik
```

### Per importare solo alcune città/province:
```bash
npm run import:osm
```

---

## Dati Importati

Tutti gli script importano:

### 📍 Posizione
- Nome attività
- Indirizzo completo
- Città, Provincia, Regione
- CAP
- Coordinate GPS

### 📞 Contatti
- Telefono
- Email
- Sito web

### 🏷️ Categoria
Oltre 100 categorie tra cui:
- Ristoranti e Bar
- Negozi di ogni tipo
- Professionisti (medici, avvocati, commercialisti...)
- Artigiani (idraulici, elettricisti, falegnami...)
- Servizi (hotel, banche, palestre...)

### ⏰ Altro
- Orari di apertura
- Stato: verificato ma non ancora reclamato

---

## Stato Post-Importazione

Tutte le attività importate:
- ✅ Sono **verificate** (dati da OpenStreetMap)
- 🔓 NON sono **reclamate** (i proprietari possono reclamarle)
- 👤 NON hanno proprietario

Questo permette ai proprietari di:
1. Trovare la loro attività
2. Reclamarla
3. Gestirla completamente

---

## Esempi di Output

### Geofabrik
```
╔══════════════════════════════════════════════════════════════╗
║        IMPORTAZIONE DA GEOFABRIK (OpenStreetMap)            ║
╚══════════════════════════════════════════════════════════════╝

📥 Download da Geofabrik...
📦 Download: 100% (1940.5/1940.5 MB)
✅ Download completato!

📖 Lettura e processamento file PBF...
🔍 Nodi processati: 45,321,678 | Trovati: 156,789

✅ Processamento completato!
📊 Totale attività trovate: 156,789

💾 Importazione nel database...
📦 Batch 1/3136 (50 attività)
   ✓ Inserite: 42 | Saltate: 8 | Errori: 0 (1.6%)

...

╔══════════════════════════════════════════════════════════════╗
║              ✅ IMPORTAZIONE COMPLETATA                      ║
╚══════════════════════════════════════════════════════════════╝

📊 Riepilogo:
   Totale trovate:     156,789
   ✅ Inserite:        145,234
   ⏭️  Saltate:         10,456
   ❌ Errori:          1,099

📍 Per Regione (top 10):
   Lombardia                 38,456
   Lazio                     22,890
   Campania                  18,234
   ...
```

---

## Preparazione

### 1. Verifica Configurazione
Assicurati che `.env` contenga:
```
VITE_SUPABASE_URL=your_url
VITE_SUPABASE_ANON_KEY=your_key
```

### 2. Verifica Database
Le tabelle devono esistere:
- `businesses`
- `business_locations`
- `business_categories`

### 3. Verifica Categorie
Le categorie devono esistere nel database (vedi migration).

---

## Dopo l'Importazione

### 1. Verifica Dati
```sql
SELECT COUNT(*) FROM businesses;
SELECT COUNT(*) FROM business_locations;
```

### 2. Verifica per Regione
```sql
SELECT province, COUNT(*)
FROM business_locations
GROUP BY province
ORDER BY COUNT(*) DESC;
```

### 3. Verifica per Categoria
```sql
SELECT bc.name, COUNT(*)
FROM businesses b
JOIN business_categories bc ON b.category_id = bc.id
GROUP BY bc.name
ORDER BY COUNT(*) DESC;
```

---

## FAQ

### Q: Quale script è il migliore?
**A:** Geofabrik per importazioni complete, Overpass per test o piccole zone.

### Q: Posso eseguire lo script più volte?
**A:** Sì! I duplicati vengono automaticamente saltati.

### Q: I dati sono aggiornati?
**A:** Geofabrik aggiorna quotidianamente, Overpass in tempo reale.

### Q: Posso filtrare per regione?
**A:** Sì, modifica lo script secondo le guide.

### Q: Cosa faccio se lo script si ferma?
**A:** Riavvialo! Salta automaticamente ciò che è già importato.

### Q: Posso importare altre categorie?
**A:** Sì! Modifica `CATEGORY_MAPPING` nello script.

---

## Supporto

Per problemi o domande:
1. Leggi la guida completa dello script che stai usando
2. Verifica la configurazione `.env`
3. Controlla i log per errori specifici
4. Verifica la connessione al database

---

## Licenza Dati

I dati provengono da **OpenStreetMap** con licenza **ODbL**.

**Devi:**
- Attribuire a OpenStreetMap
- Mantenere la stessa licenza per dati derivati

**Link:** https://www.openstreetmap.org/copyright
