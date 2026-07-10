# 📍 Guida Importazione per Città

## 🎯 Nuovo Approccio Ottimizzato

Invece di importare per provincia (aree troppo grandi), ora importi per **città con più di 20,000 abitanti**.

### ✅ Vantaggi

- **Query più veloci**: Bounding box ridotti (~9km raggio)
- **Meno timeout**: Aree più piccole = richieste più leggere
- **Più resiliente**: Se una città fallisce, passa subito alla successiva
- **Tutte le categorie**: 235 categorie per ogni città

## 🚀 Come Usare

### 1. Avvia l'Importazione

```bash
npm run import:cities
```

### 2. Lo Script Fa Tutto Automaticamente

- Processa **120+ città italiane** con >20k abitanti
- Per ogni città:
  - Esegue **235 categorie** complete
  - Salta automaticamente le categorie vuote
  - Continua anche se una categoria fallisce
  - Passa alla città successiva quando finito

### 3. Monitora il Progresso

```bash
# In un altro terminale
npm run status
```

## 📊 Cosa Importa

### Città Incluse (esempi)

- **Grandi città**: Roma, Milano, Napoli, Torino, Palermo...
- **Città medie**: Brescia, Parma, Modena, Reggio Emilia...
- **Città piccole**: Tutte con >20k abitanti

### Categorie (235 totali)

- 🏪 Negozi (supermarket, abbigliamento, elettronica...)
- 🍕 Ristorazione (ristoranti, bar, pizzerie...)
- 💼 Servizi (banche, farmacie, benzinai...)
- 👨‍⚕️ Professionisti (medici, avvocati, commercialisti...)
- 🔨 Artigiani (elettricisti, idraulici, falegnami...)
- 🏨 Alloggi (hotel, B&B, campeggi...)
- 💪 Fitness (palestre, piscine, centri sportivi...)
- 🎓 Educazione (scuole, università, biblioteche...)

## ⚙️ Parametri Ottimizzati

```javascript
// Query Overpass
timeout: 120 secondi
bbox: ~0.08 gradi (~9km raggio)

// Retry
max tentativi: 3
attese: 15s, 30s, 45s

// Pause
tra categorie: 1.5s
tra città: 5s
```

## 🛡️ Gestione Errori

Lo script è **ultra-resiliente**:

- ✅ Se una categoria fallisce → salta e continua
- ✅ Se una città fallisce → passa alla successiva
- ✅ Se l'API è sovraccarica → riprova con attese progressive
- ✅ Statistiche complete su errori e progressi

## 📈 Output Esempio

```
======================================================================
📍 CITTÀ [23/120]: Parma (Emilia-Romagna) - 195,000 abitanti
======================================================================
   [1/235] Supermercati                    ✅ 45
   [2/235] Alimentari                       ✅ 23
   [3/235] Panifici e Pasticcerie          ✅ 18
   [4/235] Macellerie                       ⚪ 0
   ...

   🎯 TOTALE Parma: 1,234 attività
   📊 Totale complessivo: 15,678
```

## 🔄 Confronto con Vecchio Metodo

| Aspetto | Per Provincia | **Per Città** |
|---------|---------------|---------------|
| Area query | ~100km raggio | **~9km raggio** |
| Timeout | Frequenti | **Rari** |
| Velocità | Lenta | **Veloce** |
| Precisione | Media | **Alta** |
| Resilienza | Bassa | **Alta** |

## 📝 Note Importanti

1. **Non fermare lo script manualmente** - lascialo completare
2. **Controlla i log** per vedere quali città sono state elaborate
3. **Usa `npm run status`** per verificare quante attività sono state importate
4. **Lo script continua** anche se incontra errori temporanei

## 🎉 Risultato Atteso

Dopo il completamento:
- ✅ 120+ città italiane coperte
- ✅ ~50,000-100,000 nuove attività
- ✅ Tutte le categorie principali presenti
- ✅ Database pronto per produzione
