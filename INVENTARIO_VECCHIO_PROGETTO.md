# Inventario Completo — Vecchio Progetto Supabase (zlzupeuwfpcpgxymdvpi)

> Estratto il 2026-07-21. Questo documento descrive la logica e i dati di configurazione
> del vecchio progetto, da replicare nel nuovo progetto (lrqeojukjpjllnvsjtor).
> In questa fase NON è stata fatta alcuna modifica al nuovo progetto.

---

## 1. Categorie e Sottocategorie

### 1.1 Categorie Attività (business_categories)

**Tabella:** `business_categories`
**Struttura:**

| Colonna | Tipo | Nullable | Default |
|---|---|---|---|
| id | uuid | NO | gen_random_uuid() |
| name | text | NO | |
| slug | text | NO | |
| description | text | SI | '' |
| ateco_code | text | SI | |
| parent_id | uuid | SI | (riferimento gerarchico) |
| created_at | timestamptz | SI | now() |

**Dati:** 107 categorie principali (parent_id = NULL), 0 sottocategorie.

**Elenco categorie principali (nome → slug, ateco_code):**

1. Abbigliamento → abbigliamento, 47.71.00
2. Agenzie di Viaggio → agenzie-viaggio, 79.11.00
3. Agenzie Immobiliari → agenzie-immobiliari, 68.31.00
4. Agenzie Pubblicitarie → agenzie-pubblicitarie, 73.11.01
5. Alimentari → alimentari, 47.11.30
6. Allarmi e Sicurezza → allarmi-sicurezza, 80.20.00
7. Ambulatori → ambulatori, 86.90.11
8. Amministratori di Condominio → amministratori-condominio, 68.32.00
9. Architetti → architetti, 71.11.00
10. Arredamento e Mobili → arredamento-e-mobili, 47.59.00
11. Artigiani → artigiani, 33.12.00
12. Assicurazioni → assicurazioni, 65.12.00
13. Autofficine → autofficine, 45.20.00
14. Bar e Caffè → bar-e-caffe, 56.10.00
15. Bagni e Impianti Termali → bagni-e-impianti-termali, 93.04.00
16. Banche e Istituti di Credito → banche-e-istituti-di-credito, 64.19.00
17. Barbiere e Parrucchiere → barbiere-e-parrucchiere, 96.02.00
18. Beni Stabili e Fabbricati → beni-stabili-e-fabbricati, 68.20.00
19. Cartolibrerie → cartolibrerie, 47.61.00
20. Casalinghi → casalinghi, 47.19.00
21. Centri Benessere → centri-benessere, 93.02.00
22. Centri Estetici → centri-estetici, 96.04.00
23. Chiese e Luoghi di Culto → chiese-e-luoghi-di-culto, 94.91.00
24. Cinema e Teatri → cinema-e-teatri, 59.14.00
25. Cliniche → cliniche, 86.10.00
26. Commercialisti → commercialisti, 69.20.00
27. Concessionari Auto → concessionari-auto, 45.11.00
28. Consulenti del Lavoro → consulenti-del-lavoro, 69.20.00
29. Consulenze Informatiche → consulenze-informatiche, 62.09.00
30. Contabili → contabili, 69.20.00
31. Dentisti → dentisti, 86.23.00
32. Dietologi e Nutrizionisti → dietologi-e-nutrizionisti, 86.90.09
33. Distributori di Carburante → distributori-di-carburante, 47.30.00
34. Elettricisti → elettricisti, 43.21.00
35. Elettronica e Elettrodomestici → elettronica-e-elettrodomestici, 47.42.00
36. Estetisti → estetisti, 96.04.00
37. Farmacie → farmacie, 47.73.00
38. Ferramenta → ferramenta, 47.52.00
39. Fisioterapisti → fisioterapisti, 86.90.09
40. Fiorai → fiorai, 47.76.00
41. Fabbri → fabbri, 25.62.00
42. Gelaterie → gelaterie, 56.10.00
43. Giardinaggio e Giardini → giardinaggio-e-giardini, 01.30.00
44. Gommisti → gommisti, 45.20.00
45. Hotel e Strutture Ricettive → hotel-e-strutture-ricettive, 55.10.00
46. Idraulici → idraulici, 43.22.00
47. Impianti di Climatizzazione → impianti-di-climatizzazione, 43.22.00
48. Informatica e Computer → informatica-e-computer, 47.41.00
49. Ink stamp e Timbri → ink-stamp-e-timbri, 18.14.00
50. Istituti di Credito → istituti-di-credito, 64.19.00
51. Lavanderie e Tintorie → lavanderie-e-tintorie, 96.01.00
52. Macellerie → macellerie, 47.22.00
53. Medici di Base → medici-di-base, 86.21.00
54. Medici Specialisti → medici-specialisti, 86.22.00
55. Musei e Gallerie → musei-e-gallerie, 91.02.00
56. Negozi di Calzature → negozi-di-calzature, 47.72.00
57. Negozi di Giocattoli → negozi-di-giocattoli, 47.65.00
58. Negozi di Musica e Strumenti → negozi-di-musica-e-strumenti, 47.59.00
59. Negozi di Ottica → negozi-di-ottica, 47.78.00
60. Negozi di Sport → negozi-di-sport, 47.64.00
61. Odontotecnici → odontotecnici, 86.23.00
62. Oreficerie e Gioiellerie → oreficerie-e-gioiellerie, 47.77.00
63. Ortopedici → ortopedici, 86.90.09
64. Panetterie e Forni → panetterie-e-forni, 47.71.00
65. Parrucchieri per Uomo → parrucchieri-per-uomo, 96.02.00
66. Pasticcerie → pasticcerie, 56.10.00
67. Pediatri → pediatri, 86.21.00
68. Pelletterie → pelletterie, 47.72.00
69. Periti e Perizie → periti-e-perizie, 74.20.00
70. Pescherie → pescherie, 47.23.00
71. Pizzerie → pizzerie, 56.10.00
72. Piscine e Centri Sportivi → piscine-e-centri-sportivi, 93.11.00
73. Pompe Funebri → pompe-funebri, 96.03.00
74. Pub e Birrerie → pub-e-birrerie, 56.10.00
75. Ristoranti → ristoranti, 56.10.00
76. Scuole e Centri di Formazione → scuole-e-centri-di-formazione, 85.59.00
77. Servizi di Pulizia → servizi-di-pulizia, 81.22.00
78. Sartorie → sartorie, 14.13.00
79. Studi Legali → studi-legali, 69.10.00
80. Studi Medici → studi-medici, 86.90.09
81. Supermercati → supermercati, 47.11.00
82. Tabacchi e Ricevitorie → tabacchi-e-ricevitorie, 47.26.00
83. Tatuatori e Piercing → tatuatori-e-piercing, 96.09.00
84. Taxi e NCC → taxi-e-ncc, 49.32.00
85. Telefonia → telefonia, 47.41.00
86. Tipografie → tipografie, 18.13.00
87. Trasporti e Logistica → trasporti-e-logistica, 49.41.00
88. Vernici e Pitture → vernici-e-pitture, 47.52.00
89. Veterinari → veterinari, 75.00.00
90. Video-produzione e Fotografia → video-produzione-e-fotografia, 74.20.00
91. Agenzie di Servizi → agenzie-di-servizi, 82.91.00
92. Alberghi → alberghi, 55.10.00
93. Artigiani Edili → artigiani-edili, 43.39.00
94. Calzolai → calzolai, 15.20.00
95. Centri Commerciali → centri-commerciali, 47.11.00
96. Discoteche e Locali → discoteche-e-locali, 56.30.00
97. Edicole → edicole, 47.61.00
98. Falegnami → falegnami, 16.24.00
99. Fruttivendoli → fruttivendoli, 47.21.00
100. Imbianchini → imbianchini, 43.34.00
101. Lettori e Noleggio → lettori-e-noleggio, 77.21.00
102. Muratori → muratori, 43.99.00
103. Negozio di Valigeria → negozio-di-valigeria, 47.72.00
104. Ottici → ottici, 47.78.00
105. Panifici → panifici, 10.71.00
106. Ristorazione collettiva → ristorazione-collettiva, 56.21.00
107. Stabilimenti Termali → stabilimenti-termali, 93.04.00

### 1.2 Categorie Annunci (classified_categories)

**Tabella:** `classified_categories`
**Struttura:** id, name, slug, icon, description, parent_id, created_at
**Dati:** Tabella vuota (nessuna categoria di annunci configurata).

### 1.3 Categorie Prodotti (product_categories)

**Tabella:** `product_categories`
**Struttura:** id, name, slug, description, parent_id, icon, display_order, created_at
**Dati:** Tabella vuota.

---

## 2. Piani di Abbonamento (subscription_plans)

**Tabella:** `subscription_plans`
**Struttura:**

| Colonna | Tipo | Nullable | Default |
|---|---|---|---|
| id | uuid | NO | gen_random_uuid() |
| name | text | NO | |
| price | numeric | NO | |
| billing_period | text | NO | |
| max_persons | integer | NO | |
| created_at | timestamptz | SI | now() |
| plan_type | text | SI | 'customer' |
| max_family_members | integer | SI | |
| features | jsonb | SI | '[]' |

**Dati (24 piani totali):**

### Piani Customer — Mensili

| Nome | Prezzo | Max persone | Max family members |
|---|---|---|---|
| Piano Mensile - 1 Persona | €0,49 | 1 | (null) |
| Piano Mensile - 1 Persona | €0,99 | 1 | 1 |
| Piano Mensile - 2 Persone | €0,79 | 2 | (null) |
| Piano Mensile - 2 Persone | €1,49 | 2 | 2 |
| Piano Mensile - 3 Persone | €1,09 | 3 | (null) |
| Piano Mensile - 3 Persone | €1,99 | 3 | 3 |
| Piano Mensile - 4 Persone | €1,49 | 4 | (null) |
| Piano Mensile - 4 Persone | €2,49 | 4 | 4 |

### Piani Customer — Annuali

| Nome | Prezzo | Max persone | Max family members |
|---|---|---|---|
| Piano Annuale - 1 Persona | €4,90 | 1 | (null) |
| Piano Annuale - 1 Persona | €9,90 | 1 | 1 |
| Piano Annuale - 2 Persone | €7,90 | 2 | (null) |
| Piano Annuale - 2 Persone | €14,90 | 2 | 2 |
| Piano Annuale - 3 Persone | €10,90 | 3 | (null) |
| Piano Annuale - 3 Persone | €19,90 | 3 | 3 |
| Piano Annuale - 4 Persone | €24,90 | 4 | 4 |

### Piani Business — Mensili

| Nome | Prezzo | Max punti vendita | Max family members |
|---|---|---|---|
| Piano Business Mensile - 1 Punto Vendita | €2,49 | 1 | 1 |
| Piano Business Mensile - 2 Punti Vendita | €3,99 | 2 | 2 |
| Piano Business Mensile - 3 Punti Vendita | €4,99 | 3 | 3 |
| Piano Business Mensile - 4 Punti Vendita | €5,99 | 4 | 4 |

### Piani Business — Annuali

| Nome | Prezzo | Max punti vendita | Max family members |
|---|---|---|---|
| Piano Business Annuale - 1 Punto Vendita | €24,90 | 1 | 1 |
| Piano Business Annuale - 2 Punti Vendita | €39,90 | 2 | 2 |
| Piano Business Annuale - 3 Punti Vendita | €49,90 | 3 | 3 |
| Piano Business Annuale - 4 Punti Vendita | €59,90 | 4 | 4 |

**Nota:** Esistono piani duplicati (vecchi prezzi e nuovi prezzi). I piani con
`max_family_members = null` sono i vecchi; quelli con `max_family_members` valorizzato
sono i nuovi (creati 2026-07-17).

### Tabella subscriptions (abbonamenti utenti)

**Tabella:** `subscriptions`
Collegamento: `customer_id` → `profiles.id`, `plan_id` → `subscription_plans.id`
Campi chiave: status (active/trial/expired/cancelled), start_date, end_date,
trial_end_date, payment_method_added, reminder_sent.

### Sistema Trial

- Funzione trigger `create_trial_for_customer()`: alla registrazione di un customer,
  crea automaticamente un abbonamento trial di 30 giorni sul piano base mensile.
- Funzione trigger `create_trial_for_business()`: stessa logica per business.
- Tabella `trial_usage_history`: traccia l'uso del trial per prevenire abusi
  (basato su fiscal_code e device fingerprint).
- Funzione `get_trial_status(user_id)`: restituisce is_trial, days_remaining,
  trial_end_date, is_expired.
- Funzione `can_change_subscription_plan(user_id)`: verifica se l'utente può
  cambiare piano (durante il trial non può).

---

## 3. Piani Banner Pubblicitari (advertising_plans + advertising_banners)

### 3.1 Piani Pubblicitari (advertising_plans)

**Struttura:**

| Colonna | Tipo | Nullable | Default |
|---|---|---|---|
| id | uuid | NO | gen_random_uuid() |
| name | text | NO | |
| description | text | SI | |
| price | numeric | NO | 0 |
| duration_days | integer | NO | 30 |
| features | jsonb | SI | '[]' |
| is_active | boolean | SI | true |
| display_order | integer | SI | 0 |
| created_at | timestamptz | SI | now() |

**Dati:** Tabella vuota (nessun piano pubblicitario configurato).

### 3.2 Banner Pubblicitari (advertising_banners)

**Struttura:**

| Colonna | Tipo | Nullable | Default |
|---|---|---|---|
| id | uuid | NO | gen_random_uuid() |
| title | text | NO | |
| description | text | SI | |
| image_url | text | NO | |
| link_url | text | SI | |
| position | text | NO | 'top' |
| page | text | SI | 'all' |
| is_active | boolean | SI | true |
| start_date | timestamptz | SI | |
| end_date | timestamptz | SI | |
| business_id | uuid | SI | |
| registered_business_id | uuid | SI | |
| impressions | integer | SI | 0 |
| clicks | integer | SI | 0 |
| created_at | timestamptz | SI | now() |
| updated_at | timestamptz | SI | now() |

**Posizioni:** `top`, (altri valori possibili per posizionamento pagina)
**Pagine:** `all`, o pagina specifica

### RLS

- Admin: accesso completo (CRUD) tramite `is_admin()`
- Pubblico: SELECT solo su banner attivi (`is_active = true`)

---

## 4. Funzionamento Annunci (Classified Ads)

### Tabella: classified_ads

| Colonna | Tipo | Nullable | Default |
|---|---|---|---|
| id | uuid | NO | gen_random_uuid() |
| user_id | uuid | NO | |
| category_id | uuid | NO | |
| title | text | NO | |
| description | text | NO | |
| price | numeric | SI | |
| location | text | SI | |
| city | text | SI | |
| province | text | SI | |
| region | text | SI | |
| images | text[] | SI | |
| contact_phone | text | SI | |
| contact_email | text | SI | |
| ad_type | ad_type_enum | SI | 'sell' |
| family_member_id | uuid | SI | |
| status | text | SI | 'active' |
| approval_status | text | SI | 'approved' |
| views_count | integer | SI | 0 |
| expires_at | timestamptz | SI | |
| approved_by | uuid | SI | |
| approved_at | timestamptz | SI | |
| approval_notes | text | SI | |
| points_awarded | integer | SI | 0 |
| registered_business_location_id | uuid | SI | |

### Enum ad_type_enum

Valori: `sell`, `buy`, `gift`, `Vendo`, `Compro`, `Regalo`

### Flusso di approvazione

1. Utente crea annuncio → status='active', approval_status='pending'
2. Admin approva tramite RPC `approve_classified_ad(ad_id, staff_id)`:
   - Imposta approval_status='approved', status='active'
   - Se utente non business: assegna 5 punti
   - Aggiorna user_activity (ads_posted_count + 1)
   - Crea activity_log + notifica
3. Admin rifiuta tramite RPC `reject_classified_ad(ad_id, staff_id)`
4. Scadenza automatica: trigger `set_classified_ad_expiration` imposta expires_at

### Tabelle correlate

- `classified_ad_views`: traccia le visualizzazioni degli annunci
- `favorite_classified_ads`: annunci preferiti degli utenti
- `ad_conversations` + `ad_messages`: messaggistica per annunci

### RLS

- SELECT: tutti possono vedere annunci approved/active; owner vede i propri
- INSERT: solo autenticati per i propri
- UPDATE: owner o admin
- DELETE: owner o admin

### Funzioni RPC

- `get_featured_classified_ads(ad_type_filter, limit_count)`: restituisce annunci
  in evidenza con dati utente e categoria

---

## 5. Funzionamento Aste

### Tabella: auctions

| Colonna | Tipo | Nullable | Default |
|---|---|---|---|
| id | uuid | NO | gen_random_uuid() |
| user_id | uuid | SI | |
| family_member_id | uuid | SI | |
| title | text | NO | |
| description | text | NO | |
| base_price | numeric | NO | |
| current_price | numeric | NO | 0 |
| deposit_amount | numeric | NO | 5 |
| images | text[] | SI | '{}' |
| category | text | NO | |
| condition | text | SI | |
| city | text | NO | '' |
| province | text | NO | '' |
| region | text | NO | '' |
| status | text | NO | 'pending' |
| approval_status | text | SI | 'pending' |
| ends_at | timestamptz | NO | |
| winner_id | uuid | SI | |
| winner_family_member_id | uuid | SI | |
| completed_at | timestamptz | SI | |
| current_bidder_id | uuid | SI | |
| business_location_id | uuid | SI | |
| approved_at | timestamptz | SI | |
| approved_by | uuid | SI | |
| approval_notes | text | SI | |
| duration_days | integer | SI | 7 |

### Tabella: auction_bids

| Colonna | Tipo | Nullable | Default |
|---|---|---|---|
| id | uuid | NO | gen_random_uuid() |
| auction_id | uuid | NO | |
| user_id | uuid | NO | |
| family_member_id | uuid | SI | |
| bid_amount | numeric | NO | |
| created_at | timestamptz | SI | now() |

### Tabella: auction_deposits

Traccia i depositi cauzionali dei partecipanti.

### Tabella: auction_completions

Traccia la conferma doppia (venditore + acquirente) per chiudere l'asta.

| Campo | Descrizione |
|---|---|
| auction_id | Riferimento all'asta |
| seller_confirmed | Boolean — venditore ha confermato |
| seller_confirmed_at | Timestamp conferma venditore |
| buyer_confirmed | Boolean — acquirente ha confermato |
| buyer_confirmed_at | Timestamp conferma acquirente |
| completion_deadline | Scadenza per confermare (7 giorni) |

### Flusso

1. Utente crea asta → status='pending', approval_status='pending'
2. Admin approva tramite RPC `approve_auction(auction_id, admin_id)`:
   - Imposta approval_status='approved', status='active'
   - Imposta ends_at = now() + duration_days
   - Assegna 15 punti all'utente
   - Crea notifiche (approvazione + punti)
3. Utenti piazzano offerte in `auction_bids`
4. Alla scadenza, l'asta viene chiusa (edge function `close-expired-auctions`)
5. Vincitore e venditore confermano l'affare tramite RPC
   `confirm_auction_deal(auction_id, user_id, is_seller)`:
   - Entrambi devono confermare entro 7 giorni
   - Quando entrambi confermano: status='completed'
   - Notifiche ad entrambi

### RLS

- SELECT: tutti vedono aste approved; owner vede le proprie
- INSERT: solo autenticati per i propri
- UPDATE: owner o admin

---

## 6. Segnalazioni (reports)

### Tabella: reports

| Colonna | Tipo | Nullable | Default |
|---|---|---|---|
| id | uuid | NO | gen_random_uuid() |
| reporter_id | uuid | NO | |
| family_member_id | uuid | SI | |
| reported_entity_type | text | NO | |
| reported_entity_id | uuid | NO | |
| reason | text | NO | |
| description | text | SI | |
| status | text | SI | 'pending' |
| reviewed_by | uuid | SI | |
| reviewed_at | timestamptz | SI | |
| resolution_notes | text | SI | |
| created_at | timestamptz | SI | now() |
| updated_at | timestamptz | SI | now() |

### Flusso

1. Utente segnala un contenuto (recensione, annuncio, asta, profilo, ecc.)
2. Segnalazione creata con status='pending'
3. Admin revisiona: imposta status (reviewed/resolved/dismissed),
   reviewed_by, reviewed_at, resolution_notes
4. Notifica automatica all'admin quando una segnalazione viene creata
   (trigger `add_report_submitted_notification`)

### RLS

- SELECT: utenti vedono le proprie segnalazioni; admin vede tutte
- INSERT: autenticati per le proprie
- UPDATE: solo admin

---

## 7. Sezione Lavoro

### 7.1 Offerte di Lavoro (job_postings)

| Colonna | Tipo | Nullable | Default |
|---|---|---|---|
| id | uuid | NO | gen_random_uuid() |
| business_id | uuid | NO | |
| registered_business_id | uuid | SI | |
| registered_business_location_id | uuid | SI | |
| title | text | NO | |
| description | text | NO | |
| position_type | text | NO | 'Full-time' |
| salary_min | numeric | SI | |
| salary_max | numeric | SI | |
| salary_currency | text | SI | 'EUR' |
| location | text | NO | |
| required_skills | text[] | SI | '{}' |
| experience_level | text | SI | 'Mid' |
| published_at | timestamptz | SI | now() |
| expires_at | timestamptz | NO | |
| status | text | SI | 'active' |
| education_level | text | SI | |
| approval_status | text | SI | 'approved' |
| region | text | SI | |
| province | text | SI | |
| city | text | SI | |
| category_id | uuid | SI | |
| approved_by | uuid | SI | |
| approved_at | timestamptz | SI | |
| approval_notes | text | SI | |
| company_name | text | SI | |
| user_id | uuid | SI | |

### Flusso approvazione

1. Business crea offerta → approval_status='pending'
2. Admin approva con `approve_job_posting(job_id, admin_id)`
3. Admin rifiuta con `reject_job_posting(job_id, admin_id, reason)`

### Tabelle correlate

- `job_views`: traccia visualizzazioni offerte
- `job_applications`: candidature degli utenti
- `favorite_job_postings`: offerte salvate
- `job_offer_conversations` + `job_offer_messages`: messaggistica
- Trigger `auto_populate_job_posting_location`: popola automaticamente
  region/province/city dalla tabella comuni

### 7.2 Cercatori di Lavoro (job_seekers)

| Colonna | Tipo | Nullable | Default |
|---|---|---|---|
| id | uuid | NO | gen_random_uuid() |
| user_id | uuid | NO | |
| family_member_id | uuid | SI | |
| title | text | NO | |
| description | text | NO | |
| skills | text[] | SI | '{}' |
| contract_type | text | NO | 'Full-time' |
| desired_salary_min | numeric | SI | |
| desired_salary_max | numeric | SI | |
| salary_currency | text | SI | 'EUR' |
| location | text | NO | '' |
| city | text | SI | |
| province | text | SI | |
| region | text | SI | |
| available_from | date | SI | |
| experience_years | integer | SI | 0 |
| education_level | text | SI | |
| status | text | SI | 'active' |
| approval_status | text | SI | 'approved' |
| approved_by | uuid | SI | |
| approved_at | timestamptz | SI | |
| approval_notes | text | SI | |

### Flusso

1. Utente crea profilo cercatore → approval_status='pending'
2. Admin approva con `approve_job_seeker(seeker_id, admin_id)`
3. Admin rifiuta con `reject_job_seeker(seeker_id, admin_id, reason)`

### Tabelle correlate

- `job_seeker_conversations` + `job_seeker_messages`: messaggistica
- `job_requests`: richieste di lavoro dai family members

---

## 8. Classifica (Leaderboard)

### Tabella: user_activity

| Colonna | Tipo | Nullable | Default |
|---|---|---|---|
| user_id | uuid | NO | |
| total_points | integer | SI | 0 |
| reviews_count | integer | SI | 0 |
| photos_count | integer | SI | 0 |
| businesses_added_count | integer | SI | 0 |
| ads_posted_count | integer | SI | 0 |
| badges | text[] | SI | '{}' |
| last_activity_at | timestamptz | SI | now() |
| created_at | timestamptz | SI | now() |
| updated_at | timestamptz | SI | now() |
| auctions_count | integer | SI | 0 |
| family_member_id | uuid | SI | |

### Sistema Punti

| Attività | Punti |
|---|---|
| Recensione approvata (senza prova) | 25 |
| Recensione approvata (con prova) | 50 |
| Annuncio approvato | 5 |
| Asta approvata | 15 |
| Aggiunta business (non business user) | 10 |

### Funzioni RPC

- `get_top_businesses_by_positive_reviews(limit)`: classifica business per
  numero di recensioni positive (rating >= 4), con avg_rating.
  Unisce registered_business_locations e unclaimed_business_locations.
- `get_top_business_locations(limit)`: classifica località per rating.
- `award_points(user_id, points, activity_type, title, description, family_member_id)`:
  assegna punti e aggiorna user_activity + activity_log + notifica.

### RLS

- SELECT: pubblico per classifica (policy `Allow public read for leaderboard`)
- UPDATE: solo admin/triggers

---

## 9. Messaggi

### 9.1 Sistema Unificato (conversations + messages)

### Tabella: conversations

| Colonna | Tipo | Nullable | Default |
|---|---|---|---|
| id | uuid | NO | gen_random_uuid() |
| participant1_id | uuid | NO | |
| participant2_id | uuid | NO | |
| participant1_family_member_id | uuid | SI | |
| participant2_family_member_id | uuid | SI | |
| participant1_location_id | uuid | SI | |
| participant2_location_id | uuid | SI | |
| conversation_type | text | NO | 'classified_ad' |
| reference_id | uuid | SI | |
| last_message_at | timestamptz | SI | now() |
| created_at | timestamptz | SI | now() |

### Tabella: messages

| Colonna | Tipo | Nullable | Default |
|---|---|---|---|
| id | uuid | NO | gen_random_uuid() |
| conversation_id | uuid | NO | |
| sender_id | uuid | NO | |
| content | text | NO | '' |
| is_read | boolean | SI | false |
| attachment_url | text | SI | |
| attachment_type | text | SI | |
| attachment_name | text | SI | |
| created_at | timestamptz | SI | now() |

### Tipi di conversazione

- `classified_ad` — conversazione su un annuncio
- `job_offer` — conversazione su un'offerta di lavoro
- `job_seeker` — conversazione con un cercatore di lavoro
- `auction` — conversazione su un'asta
- `professional_profile` — conversazione con un professionista

### Funzione RPC

`get_or_create_conversation(user1_id, user2_id, conversation_type, reference_id,
user1_family_member_id, user2_family_member_id, user2_location_id)`:
- Cerca conversazione esistente (bidirezionale, stesso tipo, stesso reference_id)
- Se non esiste, la crea
- Restituisce l'ID conversazione

### 9.2 Tabelle messaggistiche legacy (ancora presenti)

- `ad_conversations` + `ad_messages` — messaggistica annunci
- `job_offer_conversations` + `job_offer_messages` — messaggistica offerte lavoro
- `job_seeker_conversations` + `job_seeker_messages` — messaggistica cercatori

Queste tabelle legacy hanno trigger che aggiornano `last_message_at` ma il
sistema unificato (conversations + messages) è quello principale.

### RLS conversations

- SELECT: partecipanti (participant1_id o participant2_id = auth.uid()) o admin
- INSERT: solo admin (tramite RPC security definer)
- DELETE: admin

### RLS messages

- SELECT: partecipanti della conversazione o admin
- INSERT: sender deve essere auth.uid()
- UPDATE: solo admin (per marcare come letti)

---

## 10. Impostazioni e Dati di Configurazione

### 10.1 platform_settings

**Struttura:** id, setting_key, setting_value (jsonb), category, description, updated_at, updated_by
**Dati:** Tabella vuota.

### 10.2 platform_messages

Messaggi di contatto dagli utenti.
**Struttura:** id, name, email, subject, message, user_id, status, admin_reply, replied_at, replied_by, created_at
**Dati:** Tabella vuota.

### 10.3 rules_content + rules_sections

Contenuto del regolamento, gestibile dall'admin.
**Dati:** Entrambe le tabelle vuote.

### 10.4 faqs

FAQ gestibili dall'admin.
**Dati:** Tabella vuota.

### 10.5 page_customizations

Personalizzazioni di pagina (titoli, descrizioni, banner) gestibili dall'admin.
**Dati:** Tabella vuota.

### 10.6 comuni_italiani

Database dei comuni italiani con provincia e regione.
Usato per autocomplete e popolamento automatico delle località.

### 10.7 charity_organizations

Organizzazioni di beneficenza per la sezione solidarietà.

### 10.8 admin_tab_seen

Traccia quali tab dell'admin dashboard sono stati visti (per notifiche badge).

### 10.9 admin_login_logs

Traccia i login degli admin (login_time, logout_time).

### 10.10 Enum Types

| Enum | Valori |
|---|---|
| ad_type_enum | sell, buy, gift, Vendo, Compro, Regalo |
| document_type_enum | revenue, donation |

---

## 11. Funzioni RPC Complete (Riepilogo)

### Approvazioni
- `approve_classified_ad(ad_id, staff_id)` → void
- `reject_classified_ad(ad_id, staff_id)` → void
- `approve_auction(auction_id, admin_id)` → void
- `reject_auction(auction_id, admin_id, reason)` → void
- `approve_job_posting(job_id, admin_id)` → void
- `reject_job_posting(job_id, admin_id, reason)` → void
- `approve_job_seeker(seeker_id, admin_id)` → void
- `reject_job_seeker(seeker_id, admin_id, reason)` → void
- `approve_review(review_id, staff_id)` → void
- `reject_review(review_id, staff_id)` → void

### Punti e Classifica
- `award_points(user_id, points, activity_type, title, description, family_member_id)` → void
- `get_top_businesses_by_positive_reviews(limit)` → TABLE
- `get_top_business_locations(limit)` → TABLE
- `get_business_ratings(business_ids[])` → TABLE
- `get_location_ratings(location_ids[])` → TABLE

### Aste
- `confirm_auction_deal(auction_id, user_id, is_seller)` → jsonb

### Messaggi
- `get_or_create_conversation(user1, user2, type, reference, fm1, fm2, loc2)` → uuid

### Notifiche
- `create_notification(user_id, type, title, message, data)` → void
- `send_notification(target_user_id, type, title, message, data, family_member_id)` → void
- `get_unread_notification_count(family_member_id, business_location_id)` → integer

### Abbonamenti
- `get_trial_status(user_id)` → TABLE
- `can_change_subscription_plan(user_id)` → boolean
- `get_subscription_stats()` → json
- `get_total_revenue()` → TABLE

### Ricerca
- `search_all_businesses(query, city, province, region, category_id, verified, limit)` → TABLE
- `search_all_business_locations(query, city, province, region, category_id, verified)` → TABLE
- `search_business_tracking(type, province, city, region, name, limit)` → TABLE
- `search_unclaimed_businesses(name, province, city, address, page, page_size)` → TABLE
- `get_featured_classified_ads(ad_type, limit)` → TABLE

### Geografia
- `get_all_province()` → TABLE(sigla, nome, regione)
- `get_comuni_by_provincia(provincia)` → TABLE(comune, sigla)
- `get_comuni_with_few_businesses(min_count)` → TABLE

### Recensioni
- `check_review_allowed_this_year(customer_id, family_member_id, business_id, ...)` → boolean

### Account
- `delete_user_account(user_id)` → void
- `admin_delete_user_account(user_id)` → void

### Altro
- `generate_slug(text)` → text
- `generate_redemption_code()` → text
- `create_discount_redemption(...)` → json
- `confirm_referral_reward(...)` → jsonb
- `exec_sql(sql_text)` → text
- `exec_raw_sql(sql_text)` → void

---

## 12. Trigger Principali

| Tabella | Trigger | Funzione | Scopo |
|---|---|---|---|
| profiles | sync_admin_status_trigger | sync_profile_admin_status | Sincronizza is_admin con tabella admins |
| profiles | trigger_create_trial_for_customer | create_trial_for_customer | Crea trial automatico per customer |
| profiles | trigger_remove_referral_points | remove_referral_points_on_delete | Rimuove punti referral alla cancellazione |
| classified_ads | set_classified_ad_expiration_trigger | (set expiration) | Imposta expires_at alla creazione |
| classified_ad_views | trigger_log_ad_view_milestone | log_ad_view_milestone | Notifica milestone visualizzazioni |
| business_locations | trigger_mark_business_location_claimed | mark_business_location_as_claimed | Aggiorna is_claimed |
| business_locations | trigger_update_plan_on_location_insert/delete | update_subscription_plan_on_location_change | Aggiorna piano business |
| conversations | (vari trigger) | update_conversation_last_message | Aggiorna last_message_at |
| messages | (trigger read) | (mark read) | Aggiorna is_read |

---

## 13. Edge Functions Deployate

| Slug | Scopo |
|---|---|
| admin-register | Registrazione admin con chiave segreta |
| check-subscription-expiration | Controlla abbonamenti scaduti |
| check-trial-status | Controlla stato trial |
| cleanup-expired-ads | Pulisce annunci scaduti |
| close-expired-auctions | Chiude aste scadute |
| fill-empty-comuni | Popola comuni mancanti |
| import-businesses-google | Importa attività da Google Places |
| import-businesses-osm | Importa attività da OpenStreetMap |
| moderate-content | Moderazione contenuti con AI |
| notify-unclaimed-businesses | Notifica attività non rivendicate |
| send-trial-reminders | Invia reminder trial in scadenza |
| bulk-import-osm | Import massivo OSM (con JWT) |
| apply-migrations | Applica migrazioni SQL |

---

## 14. Viste

| Vista | Scopo |
|---|---|
| subscriptions_readable | Vista leggibile abbonamenti con nome piano e prezzo |

---

## 15. Storage Buckets

- `review_proofs` — prove delle recensioni (pubblico)
- `classified_ads` — immagini annunci
- `family_member_avatars` — avatar family members
- `location_avatars` — avatar località business
- `business_photos` — foto business

---

## Riepilogo per la Migrazione

Per replicare il vecchio progetto nel nuovo (lrqeojukjpjllnvsjtor), servirebbero:

1. **107 categorie business** con slug, ateco_code, descrizioni
2. **24 piani abbonamento** (customer + business, mensili + annuali)
3. **Schema completo tabelle**: classified_ads, auctions + bids + deposits + completions,
   reports, job_postings, job_seekers, conversations, messages, user_activity,
   advertising_plans, advertising_banners, notifications, ecc.
4. **~40 funzioni RPC** (approvazioni, punti, ricerca, messaggi, geografia)
5. **~20 trigger** (trial, punti, sync admin, expiration, notifiche)
6. **Policy RLS** per ogni tabella (CRUD per owner/admin/public)
7. **2 enum types** (ad_type_enum, document_type_enum)
8. **13 edge functions**
9. **1 vista** (subscriptions_readable)
10. **Storage buckets** (5 bucket)
11. **Dati seed**: comuni_italiani, charity_organizations

Le tabelle di configurazione (platform_settings, rules_content, faqs,
page_customizations) sono vuote — non richiedono migrazione dati.
