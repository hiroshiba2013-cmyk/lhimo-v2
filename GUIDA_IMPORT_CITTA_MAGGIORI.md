# Guida Import Città Maggiori (20.000+ abitanti)

## Descrizione

Questo script importa automaticamente le attività commerciali da OpenStreetMap per tutte le città italiane con almeno 20.000 abitanti. I dati vengono organizzati per:

- **Categoria** (supermercati, ristoranti, farmacie, etc.)
- **Regione** (Lombardia, Lazio, Campania, etc.)
- **Provincia** (MI, RM, NA, etc.)
- **Città**

Le attività vengono inserite nella tabella `unclaimed_business_locations` pronte per essere rivendicate dai proprietari.

## Città Incluse

Lo script processa **oltre 200 città** italiane con più di 20.000 abitanti, tra cui:

### Grandi Città (100.000+)
- Milano, Roma, Napoli, Torino, Palermo, Genova, Bologna, Firenze, Bari, Catania, Venezia, Verona, Messina

### Città Medie (50.000-100.000)
- Modena, Parma, Reggio Emilia, Ravenna, Brescia, Bergamo, Como, Varese, Novara, Pavia, Salerno, Taranto, Lecce, Cagliari, Sassari

### Città con 20.000-50.000 abitanti
- Oltre 150 città in tutte le regioni italiane

## Categorie Importate

### Negozi (shop)
- Supermercati, minimarket, panifici, macellerie
- Abbigliamento, calzature, gioiellerie, ottici
- Elettronica, telefonia, informatica
- Ferramenta, arredamento, bricolage
- Fioristi, librerie, cartolerie, articoli sportivi

### Servizi (amenity)
- Ristoranti, bar, caffetterie, fast food
- Farmacie, banche, uffici postali
- Distributori di carburante
- Ospedali, cliniche, dentisti, veterinari
- Palestre, cinema, teatri

### Turismo (tourism)
- Hotel, B&B, ostelli
- Musei, attrazioni turistiche

### Uffici (office)
- Commercialisti, avvocati
- Agenzie immobiliari, assicurazioni
- Architetti, consulenti fiscali

### Artigiani (craft)
- Elettricisti, idraulici, falegnami
- Imbianchini, fotografi, sarti

## Come Usare

### 1. Preparazione

Assicurati di avere le credenziali Supabase configurate nel file `.env`:

```bash
VITE_SUPABASE_URL=your_url
VITE_SUPABASE_ANON_KEY=your_key
```

### 2. Avvio Import

```bash
npm run import:major-cities
```

### 3. Monitoraggio Progresso

Lo script mostra:
- Città in elaborazione
- Numero di attività trovate per categoria
- Progressi totali
- Eventuali errori

### 4. Rate Limiting

Lo script implementa:
- **2 secondi di pausa** tra ogni query Overpass
- **5 secondi di pausa** in caso di errore
- **Batch di 50 record** per inserimenti nel database
- **100ms di pausa** tra batch

Questo garantisce di non sovraccaricare l'API di Overpass e il database.

## Output Esempio

```
===========================================
Processing Milano (Lombardia) - Pop: 1,396,000
Progress: 1/200
===========================================

Querying Supermercati in Milano...
Found 156 Supermercati in Milano
✓ Imported 156/156 Supermercati in Milano

Querying Ristoranti in Milano...
Found 892 Ristoranti in Milano
✓ Imported 892/892 Ristoranti in Milano

✓ Completed Milano: 2,847 businesses imported
Overall progress: 2,847 total businesses

===========================================
IMPORT COMPLETE
===========================================

Total cities processed: 200
Total businesses imported: 125,438

--- By Region ---
Lombardia: 28,543
Lazio: 22,156
Campania: 18,234
...

--- Top Categories ---
Ristoranti: 12,456
Bar e Caffetterie: 9,823
Farmacie: 5,234
...
```

## Statistiche Finali

Al termine dell'importazione lo script mostra:

1. **Totale città processate**
2. **Totale attività importate**
3. **Distribuzione per regione**
4. **Top 20 categorie più popolate**

## Tempi di Esecuzione

Con le pause di rate limiting:
- **Singola città piccola**: ~10-20 minuti
- **Città media**: ~30-60 minuti
- **Grande città**: ~1-2 ore
- **Tutte le 200+ città**: ~2-3 giorni

## Risoluzione Problemi

### Errore "Too Many Requests"
Se vedi errori 429:
- Lo script riprova automaticamente dopo 5 secondi
- Se persiste, aumenta il delay nel codice da 2 a 3-5 secondi

### Errore Database
- Verifica le credenziali in `.env`
- Controlla che la tabella `unclaimed_business_locations` esista
- Verifica che le categorie siano create nella tabella `business_categories`

### Città Saltate
- Alcune città potrebbero non avere dati in OpenStreetMap
- Lo script continua con la città successiva

## Personalizzazione

### Modificare le Città
Modifica l'array `CITIES_20K_PLUS` nel file `import-major-cities.js`

### Aggiungere Categorie
Aggiungi nuove categorie nell'oggetto `OSM_CATEGORIES`

### Modificare Rate Limiting
Cambia i valori `delay()` nel codice:
```javascript
await delay(2000); // 2 secondi tra query
await delay(100);  // 100ms tra batch
```

## Note Importanti

1. **Non interrompere lo script** durante l'esecuzione - riprenderà dalla città successiva
2. **Database Backup** - crea un backup prima di avviare import massivi
3. **Costi API** - Overpass API è gratuita ma ha limiti di rate, rispettali
4. **Duplicati** - Lo script potrebbe creare duplicati se eseguito più volte sulla stessa città

## Dati OpenStreetMap

I dati provengono da **OpenStreetMap** e **Overpass API**:
- Licenza: ODbL (Open Database License)
- Attribuzione richiesta: © OpenStreetMap contributors
- Dati aggiornati in tempo reale

## Supporto

Per problemi o domande:
1. Controlla i log dell'errore
2. Verifica la connessione a Overpass API
3. Verifica la connessione al database Supabase
