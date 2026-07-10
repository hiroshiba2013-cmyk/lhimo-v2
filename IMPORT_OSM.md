# Importazione Attività da OpenStreetMap

Questo script importa automaticamente attività commerciali e professionisti da OpenStreetMap (tramite Overpass API) nel tuo database.

## Come Funziona

Lo script estrae dati reali da OpenStreetMap per diverse categorie di business in tutta Italia, organizzati per:
- Regione
- Provincia
- Città
- Categoria

## Cosa Viene Estratto

Per ogni attività, lo script raccoglie:
- Nome
- Indirizzo completo
- Coordinate GPS (latitudine/longitudine)
- Numero di telefono
- Sito web
- Email
- Orari di apertura
- Categoria

## Categorie Supportate

Lo script importa automaticamente:

### Ristorazione
- Ristoranti, Pizzerie
- Bar, Caffè, Pub
- Fast Food
- Gelaterie
- Panifici e Pasticcerie

### Negozi
- Supermercati, Alimentari
- Abbigliamento
- Parrucchieri, Centri Estetici
- Farmacie
- Librerie, Gioiellerie
- Elettronica, Arredamento
- Ferramenta
- Macellerie, Frutta e Verdura

### Servizi Professionali
- Medici, Dentisti, Veterinari
- Avvocati, Commercialisti
- Architetti
- Agenzie Immobiliari
- Assicurazioni

### Altri Servizi
- Hotel, B&B
- Banche, Poste
- Palestre
- Stazioni di Servizio
- Autofficine, Autolavaggi

## Come Eseguire l'Importazione

### 1. Assicurati che il file .env sia configurato correttamente

Il file `.env` deve contenere:
```
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

### 2. Esegui lo script

```bash
npm run import:osm
```

### 3. Attendi il completamento

Lo script:
- Interroga l'API di Overpass per ogni provincia
- Estrae i dati delle attività
- Li inserisce nel database
- Mostra il progresso in tempo reale

## Personalizzazione

Puoi modificare lo script `import-from-overpass.js` per:

### Importare Province Specifiche

Modifica l'array `provincesToImport` (linea ~290):

```javascript
const provincesToImport = [
  'Varese',      // Solo Varese
  'Milano',      // Solo Milano
  // Aggiungi altre province...
];
```

### Importare TUTTE le Province

Sostituisci l'array con:

```javascript
const provincesToImport = Object.keys(italianProvinces);
```

### Modificare le Categorie

Modifica l'array `categories` (linea ~260):

```javascript
const categories = [
  'restaurant',   // Ristoranti
  'cafe',         // Bar
  'supermarket',  // Supermercati
  // Aggiungi altre categorie OSM...
];
```

### Categorie OSM Disponibili

Puoi aggiungere qualsiasi categoria supportata da OpenStreetMap:
- **shop=*** (negozi): mall, computer, mobile_phone, shoes, etc.
- **amenity=*** (servizi): hospital, school, cinema, theatre, etc.
- **tourism=*** (turismo): museum, attraction, viewpoint, etc.
- **leisure=*** (tempo libero): sports_centre, swimming_pool, etc.
- **craft=*** (artigiani): plumber, electrician, carpenter, etc.

Vedi: https://wiki.openstreetmap.org/wiki/IT:Map_features

## Note Importanti

1. **Rate Limiting**: Lo script include pause tra le richieste per rispettare i limiti dell'API di Overpass (2 secondi tra categorie, 5 secondi tra province)

2. **Duplicati**: Lo script controlla automaticamente se un'attività esiste già (per nome e indirizzo) e la salta

3. **Dati Incompleti**: Alcune attività potrebbero non avere tutti i dati (es. telefono, sito web). Lo script inserisce comunque l'attività con i dati disponibili

4. **Attività "Unclaimed"**: Tutte le attività importate sono marcate come `is_claimed=false` e `verified=true`, permettendo ai proprietari di reclamarle

5. **Tempo di Esecuzione**: L'importazione può richiedere tempo (diversi minuti per provincia), sii paziente

## Esempio di Output

```
=== IMPORTAZIONE DA OPENSTREETMAP ===

=== Importazione per Varese ===
Cercando: restaurant in Varese...
  Trovati 45 risultati
Cercando: cafe in Varese...
  Trovati 32 risultati
...

Totale attività estratte per Varese: 234
Inserimento nel database...
  ✓ Ristorante Da Mario
  ✓ Bar Centrale
  ✓ Farmacia San Giuseppe
  ...

=== IMPORTAZIONE COMPLETATA ===
Totale attività estratte: 234
```

## Troubleshooting

### Errore: "Overpass API error: 429"
L'API è sovraccarica. Aspetta qualche minuto e riprova.

### Errore: "Overpass API error: 504"
La query ha impiegato troppo tempo. Riduci il numero di categorie per query.

### Nessun risultato
Controlla che:
- Il nome della provincia sia scritto correttamente
- La provincia esista nell'array `italianProvinces`
- La categoria OSM sia valida

## Prossimi Passi

Dopo l'importazione:
1. Controlla le attività importate nella dashboard
2. Aggiungi foto alle attività
3. Permetti agli utenti di reclamare le loro attività
4. Raccogli recensioni
