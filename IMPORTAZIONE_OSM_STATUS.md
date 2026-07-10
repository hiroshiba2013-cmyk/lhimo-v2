# 🇮🇹 Importazione Dati OpenStreetMap - Italia

## ✅ STATO: IN CORSO

L'importazione automatica di tutte le attività commerciali italiane da OpenStreetMap è attualmente in esecuzione.

---

## 📊 Statistiche Attuali

**Totale attività importate:** 731+

**Regione corrente:** Valle d'Aosta (completata)

### Per Categoria (Valle d'Aosta)
- Ristoranti: 352
- Bar e Caffè: 58
- Hotel: 50
- Ferramenta: 43
- Alimentari: 31
- Farmacie: 31
- Supermercati: 19
- B&B: 18
- Banche: 18
- Abbigliamento: 16
- Altri: ~95

---

## 🗺️ Regioni da Processare

### ✅ Completate
1. Valle d'Aosta

### ⏳ In Coda (19 regioni)
2. Piemonte
3. Lombardia
4. Trentino-Alto Adige
5. Veneto
6. Friuli-Venezia Giulia
7. Liguria
8. Emilia-Romagna
9. Toscana
10. Umbria
11. Marche
12. Lazio
13. Abruzzo
14. Molise
15. Campania
16. Puglia
17. Basilicata
18. Calabria
19. Sicilia
20. Sardegna

---

## 📂 Categorie Monitorate (21 tipi)

1. Ristoranti
2. Bar e Caffè
3. Hotel
4. B&B
5. Alimentari
6. Supermercati
7. Panifici e Pasticcerie
8. Macellerie
9. Farmacie
10. Parrucchieri e Barbieri
11. Benzinai
12. Banche
13. Palestre
14. Abbigliamento
15. Ferramenta
16. Fioristi
17. Autofficine
18. Avvocati
19. Commercialisti
20. Notai
21. Architetti

---

## 🔧 Comandi Disponibili

### Monitorare l'importazione in tempo reale
```bash
npm run monitor
```
Mostra statistiche aggiornate ogni 10 secondi.

### Verificare il log dell'importazione
```bash
tail -f /tmp/import-italy.log
```

### Controllare se il processo è attivo
```bash
ps aux | grep import-all-italy-overpass
```

### Avviare nuovamente l'importazione (se necessario)
```bash
nohup npm run import:italy:all > /tmp/import-italy.log 2>&1 &
```

---

## ⏱️ Tempo Stimato

- **Tempo per regione:** 5-15 minuti
- **Tempo totale stimato:** 2-4 ore
- **Dipende da:** Velocità API Overpass e numero di attività per regione

---

## 📋 Dati Estratti per Ogni Attività

Per ogni business viene salvato:

- ✅ Nome
- ✅ Categoria
- ✅ Descrizione
- ✅ Indirizzo completo (Via, Città, Provincia, Regione, CAP)
- ✅ Coordinate GPS (Latitudine, Longitudine)
- ✅ Telefono
- ✅ Email
- ✅ Sito Web
- ✅ Orari di apertura

---

## 🎯 Organizzazione Dati

I dati vengono automaticamente organizzati e salvati nel database Supabase nella tabella:

**`unclaimed_business_locations`**

Con indicizzazione per:
- Regione
- Provincia
- Città
- Categoria
- Coordinate geografiche

---

## 📝 Note

- L'importazione rispetta i rate limit dell'API Overpass (1 richiesta al secondo)
- I duplicati vengono automaticamente filtrati
- Le attività senza nome o coordinate vengono scartate
- Ogni regione viene processata sequenzialmente per evitare sovraccarico
