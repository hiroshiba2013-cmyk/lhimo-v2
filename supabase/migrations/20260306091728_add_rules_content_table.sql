/*
  # Add Rules Content Table

  1. New Tables
    - `rules_content`
      - Stores all text content from Rules page sections
      - Each section can have multiple content blocks

  2. Security
    - Enable RLS
    - Only admins can modify
    - Public read access
*/

-- Create rules_content table
CREATE TABLE IF NOT EXISTS rules_content (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  section_key text NOT NULL,
  section_title text NOT NULL,
  content_text text NOT NULL,
  display_order integer NOT NULL DEFAULT 0,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  updated_by uuid REFERENCES profiles(id)
);

-- Enable RLS
ALTER TABLE rules_content ENABLE ROW LEVEL SECURITY;

-- Public read policy
CREATE POLICY "Anyone can view active rules content"
  ON rules_content FOR SELECT
  USING (is_active = true);

-- Admin policies
CREATE POLICY "Admins can view all rules content"
  ON rules_content FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins
      WHERE admins.user_id = auth.uid()
    )
  );

CREATE POLICY "Admins can insert rules content"
  ON rules_content FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admins
      WHERE admins.user_id = auth.uid()
    )
  );

CREATE POLICY "Admins can update rules content"
  ON rules_content FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins
      WHERE admins.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM admins
      WHERE admins.user_id = auth.uid()
    )
  );

CREATE POLICY "Admins can delete rules content"
  ON rules_content FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admins
      WHERE admins.user_id = auth.uid()
    )
  );

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_rules_content_section ON rules_content(section_key);
CREATE INDEX IF NOT EXISTS idx_rules_content_active ON rules_content(is_active);
CREATE INDEX IF NOT EXISTS idx_rules_content_order ON rules_content(display_order);

-- Seed initial content (entire rules page sections)
INSERT INTO rules_content (section_key, section_title, content_text, display_order) VALUES
('intro', 'Introduzione', 'Benvenuto in TrovaFacile! Questa guida completa ti aiuterà a comprendere tutte le funzionalità della piattaforma, le regole da seguire e come sfruttare al meglio tutti i servizi disponibili.', 1),

('getting_started', 'Come Iniziare - Registrazione', 'Passo 1: Clicca su "Accedi" o "Inizia Gratis"
Passo 2: Scegli il tipo di account (Cliente per privati o Business per aziende)
Passo 3: Inserisci email, password e completa la registrazione
Passo 4: Attiva la prova gratuita di 1 mese (nessuna carta richiesta)

IMPORTANTE: Riceverai un promemoria via email 7 giorni prima della scadenza della prova. Se non rinnovi, l''abbonamento termina automaticamente senza addebiti.', 2),

('account_cliente', 'Account Cliente - Caratteristiche', 'L''Account Cliente è perfetto per privati e famiglie. Include:
- Fino a 4 membri della famiglia con profili separati
- Scrivi recensioni e guadagna punti
- Pubblica fino a 20 annunci gratuiti contemporaneamente
- Cerca lavoro per te e i tuoi familiari
- Il 10% del tuo abbonamento andrà in beneficienza
- Prezzo: da 0,49€/mese dopo 1 mese di prova gratuita', 3),

('reviews_rules', 'Recensioni - Regole Fondamentali', 'REGOLA PRINCIPALE: Puoi recensire la stessa azienda UNA SOLA VOLTA ALL''ANNO. Questo garantisce recensioni fresche e autentiche.

REQUISITO MINIMO: La descrizione deve contenere ALMENO 100 CARATTERI. Recensioni troppo brevi non verranno accettate.

Come Scrivere una Recensione:
1. Cerca l''azienda o il servizio che vuoi recensire
2. Clicca sulla scheda dell''azienda
3. Clicca su "Scrivi una Recensione"
4. Valuta 4 aspetti con stelle da 1 a 5:
   - Qualità del prodotto o servizio
   - Rapporto qualità/prezzo
   - Esperienza complessiva e servizio ricevuto
   - Voto generale
5. IMPORTANTE: Scrivi una descrizione dettagliata di almeno 100 caratteri
6. OPZIONALE: Carica una prova (scontrino, fattura, foto) per ricevere 50 punti invece di 25', 4),

('reviews_points', 'Recensioni - Sistema Punti', 'PUNTI PER RECENSIONI:
- 25 punti: per ogni recensione approvata (minimo 100 caratteri)
- 50 punti: per recensioni con prova documentale + Badge "Verificata"
- Le recensioni vengono verificate entro 7 giorni
- I punti vengono assegnati solo dopo l''approvazione
- Recensioni false = perdita punti e sospensione account

COSA NON FARE:
❌ Non lasciare recensioni false o inventate
❌ Non scrivere recensioni troppo brevi (minimo 100 caratteri)
❌ Non usare linguaggio offensivo o diffamatorio
❌ Non recensire la stessa azienda più di una volta all''anno
❌ Non chiedere/offrire compensi per recensioni positive', 5),

('classified_ads', 'Annunci Gratuiti', 'Pubblica fino a 20 annunci gratuiti per vendere, comprare, scambiare o regalare oggetti.

TIPI DI ANNUNCIO:
🏷️ Vendita | 🛒 Acquisto | 🔄 Scambio | 🎁 Regalo

REGOLE IMPORTANTI:
✅ Massimo 20 annunci attivi contemporaneamente
✅ Ogni annuncio dura 30 giorni (rinnovabili gratis)
✅ Guadagni 5 punti per ogni annuncio pubblicato
⚠️ La ripubblicazione dopo la scadenza non comporta ulteriori punti
✅ Usa la messaggistica interna per le trattative
✅ Incontra sempre in luoghi pubblici per la consegna

PRODOTTI VIETATI:
❌ Armi e munizioni | ❌ Droga e sostanze | ❌ Prodotti contraffatti
❌ Tabacco e sigarette | ❌ Farmaci | ❌ Documenti falsi
❌ Animali protetti | ❌ Fuochi d''artificio

SANZIONE: Rimozione immediata + Sospensione account', 6),

('job_search', 'Cerca Lavoro', 'Crea profili di ricerca lavoro per te e fino a 4 membri della tua famiglia. Le aziende potranno trovarti e contattarti direttamente.

COME FUNZIONA:
1. Vai nella sezione "Lavoro" o nel tuo Profilo
2. Clicca su "Crea Profilo Cerca Lavoro"
3. Seleziona per chi (te stesso o un membro della famiglia)
4. Inserisci: categoria, titolo di studio, esperienza, competenze, zona
5. Pubblica il profilo - è visibile alle aziende

RISPONDERE AGLI ANNUNCI:
• Cerca annunci nella sezione "Lavoro"
• Filtra per categoria, città e livello di esperienza
• Clicca su "Candidati" per rispondere
• Le aziende riceveranno il tuo profilo e ti contatteranno

PRIVACY E SICUREZZA:
✓ Il cognome completo non è mai visibile pubblicamente
✓ Email e telefono visibili solo dopo che rispondi
✓ Puoi nascondere il profilo in qualsiasi momento
✓ Segnala immediatamente offerte sospette', 7),

('points_system', 'Sistema Punti e Classifica', 'Guadagna punti per ogni attività sulla piattaforma e scala la classifica mensile per vincere premi e badge esclusivi.

COME GUADAGNARE PUNTI:
⭐ Recensione completa (con valutazioni dettagliate) = +50 punti
👥 Presenta un amico (che si abbona) = +30 punti
⭐ Recensione base (solo voto finale) = +25 punti
🏪 Inserimento attività completa (con sito, email, telefono) = +25 punti
🏪 Inserimento attività base (nome e indirizzo) = +10 punti
📦 Inserire un prodotto = +10 punti
📝 Pubblicare un annuncio = +5 punti

BADGE E LIVELLI:
🎯 Nuovo Arrivato: 0 punti
🥉 Principiante: 100+ punti
🔍 Esploratore: 300+ punti
🥈 Veterano: 800+ punti
🥇 Maestro: 2500+ punti
👑 Leggenda: 5000+ punti

REGOLE DELLA CLASSIFICA:
• La classifica si azzera ogni anno il 1° gennaio
• I badge e i premi restano permanentemente nel profilo
• Comportamenti scorretti = perdita di tutti i punti
• Recensioni false o spam comportano sospensione', 8),

('solidarity', 'Solidarietà TrovaFacile', 'In TrovaFacile crediamo fermamente nel valore della solidarietà e nel dare un contributo concreto alla nostra comunità.

IL NOSTRO IMPEGNO:
Ci impegniamo a donare il 10% DEL NOSTRO FATTURATO ANNUALE a organizzazioni no profit, enti di beneficenza e progetti sociali che fanno la differenza.

SCELTA DEMOCRATICA:
La scelta degli enti destinatari viene effettuata democraticamente dagli utenti attraverso un sondaggio annuale.
• Ogni anno proponiamo una lista di enti verificati
• Ogni utente abbonato può votare fino a 3 enti
• Gli enti più votati riceveranno una quota del 10%
• La distribuzione avviene in base alle percentuali di voto
• Tutti i risultati vengono pubblicati in trasparenza

TRASPARENZA TOTALE:
Pubblichiamo regolarmente:
• Documenti ufficiali del fatturato aziendale
• Ricevute delle donazioni effettuate
• Contatori in tempo reale del fatturato e fondo solidarietà
• Statistiche complete sugli abbonamenti attivi
• Informazioni sui destinatari e impatto delle donazioni

NOTA: I contatori saranno a zero per il primo mese perché la prova è gratuita. Si aggiorneranno con l''arrivo dei primi abbonamenti a pagamento.', 9),

('business_account', 'Account Business - Guida Aziende', 'L''Account Business è per aziende che vogliono gestire la propria presenza online.

CARATTERISTICHE:
✓ Rivendica e gestisci la tua azienda
✓ Gestisci più sedi e punti vendita
✓ Rispondi alle recensioni
✓ Pubblica annunci di lavoro illimitati
✓ Crea offerte e sconti esclusivi
✓ Il 10% del tuo abbonamento andrà in beneficienza
✓ Prezzo: da 2,49€/mese + IVA dopo 1 mese di prova

RIVENDICARE LA TUA AZIENDA:
1. Registra un account Business
2. Cerca la tua azienda (o creala se non c''è)
3. Clicca su "Rivendica Questa Attività"
4. Fornisci: Partita IVA, Codice Fiscale, Codice Univoco SDI, PEC, Codice ATECO
5. Attendi verifica (24-48 ore)
6. Ricevi conferma via email', 10),

('business_locations', 'Gestione Sedi Multiple', 'Se hai più punti vendita, negozi o uffici, puoi gestirli tutti da un unico account.

PER OGNI SEDE PUOI:
✓ Impostare indirizzo e contatti specifici
✓ Configurare orari di apertura diversi
✓ Caricare foto e logo personalizzati
✓ Aggiungere descrizione e servizi offerti
✓ Visualizzare recensioni specifiche
✓ Gestire annunci di lavoro per sede

COSTI:
Mensile: da 2,49€ (1 sede) a 14,99€ (10+ sedi)
Annuale: da 24,90€ (1 sede) a 149,90€ (10+ sedi)
Tutti i prezzi + IVA', 11),

('business_reviews_management', 'Gestione Recensioni Aziende', 'Le recensioni sono fondamentali per la reputazione online. Gestiscile in modo professionale.

COME RISPONDERE:
1. Accedi alla Dashboard
2. Vai su "Recensioni"
3. Clicca "Rispondi" sotto la recensione
4. Scrivi una risposta professionale
5. La risposta sarà visibile pubblicamente

BUONE PRATICHE:
✓ Rispondi sempre, anche alle recensioni negative
✓ Ringrazia i clienti per le recensioni positive
✓ Offri soluzioni concrete per i problemi
✓ Mantieni un tono professionale e cortese
✓ Non essere mai difensivo o aggressivo
✓ Usa le recensioni per migliorare il servizio

COSA NON FARE:
❌ Non minacciare o insultare i clienti
❌ Non chiedere di rimuovere recensioni negative
❌ Non offrire compensi per recensioni positive
❌ Non creare account falsi per recensirti
❌ Non rivelare informazioni private dei clienti', 12),

('forbidden_behaviors', 'Comportamenti Vietati', 'ACCOUNT E IDENTITÀ:
❌ Creare account multipli
❌ Fingere di essere qualcun altro
❌ Usare bot o script automatici
❌ Vendere o cedere il proprio account
❌ Condividere credenziali di accesso

CONTENUTI:
❌ Linguaggio offensivo, discriminatorio
❌ Contenuti violenti o espliciti
❌ Spam e pubblicità ingannevole
❌ Informazioni false o diffamatorie
❌ Violazione copyright altrui

RECENSIONI:
❌ Recensioni false o inventate
❌ Vendere/comprare recensioni
❌ Recensire se stessi
❌ Recensioni su concorrenti
❌ Minacce o estorsioni

TRANSAZIONI:
❌ Truffe e frodi
❌ Vendere prodotti vietati/illegali
❌ Evasione fiscale
❌ Riciclaggio di denaro
❌ Schemi piramidali

SANZIONI: Rimozione contenuti, perdita punti, sospensione temporanea o permanente, segnalazione alle autorità per reati penali.', 13),

('moderation', 'Moderazione e Segnalazioni', 'TrovaFacile mantiene un ambiente sicuro e rispettoso per tutti.

COME SEGNALARE:
1. Clicca sul pulsante "Segnala" su recensioni, annunci e profili
2. Seleziona il motivo della segnalazione
3. Aggiungi dettagli opzionali
4. Invia - il team esaminerà entro 24-48 ore

GARANZIE:
✓ Le segnalazioni sono completamente anonime
✓ Vengono prese molto sul serio
✓ Risposta rapida del team di moderazione
✓ Zero tolleranza per abusi gravi', 14),

('terms_conditions', 'Termini e Condizioni', '1. OGGETTO DEL SERVIZIO
TrovaFacile è una piattaforma digitale che offre servizi di marketplace, recensioni, annunci classificati e opportunità di lavoro sul territorio italiano. L''utilizzo comporta l''accettazione integrale dei presenti Termini.

2. REGISTRAZIONE E ACCOUNT
• Riservata a maggiorenni e persone giuridiche
• Vietato creare account multipli
• L''utente è responsabile delle credenziali
• TrovaFacile può sospendere account che violano i termini

3. LIMITAZIONI DI RESPONSABILITÀ
• TrovaFacile agisce come intermediario
• Non garantiamo accuratezza dei contenuti degli utenti
• Non siamo responsabili per transazioni tra utenti
• Non garantiamo disponibilità ininterrotta del servizio

4. PROPRIETÀ INTELLETTUALE
Tutti i contenuti del sito (design, loghi, software) sono proprietà di TrovaFacile e protetti dalle leggi sul diritto d''autore. Gli utenti mantengono la proprietà dei contenuti pubblicati ma concedono a TrovaFacile una licenza per utilizzarli nell''ambito del servizio.

5. LEGGE APPLICABILE
I presenti Termini sono regolati dalla legge italiana. Per controversie è competente il Foro del luogo di residenza del consumatore, ai sensi del D.Lgs. 206/2005 (Codice del Consumo).', 15),

('privacy_gdpr', 'Privacy Policy e GDPR', 'Ai sensi dell''art. 13 del Regolamento UE 2016/679 (GDPR):

TITOLARE DEL TRATTAMENTO: TrovaFacile S.r.l. - Email: privacy@trovafacile.it

DATI TRATTATI:
• Dati anagrafici: nome, cognome, data di nascita
• Dati di contatto: email, telefono, indirizzo
• Dati di navigazione: IP, browser, pagine visitate
• Dati business: P.IVA, C.F., PEC, ATECO (solo aziende)
• Contenuti: recensioni, annunci, messaggi, foto
• Dati di pagamento: gestiti da Stripe (non conservati da noi)

FINALITÀ:
• Erogazione dei servizi della piattaforma
• Gestione registrazione e autenticazione
• Gestione abbonamenti e pagamenti
• Verifica identità aziende
• Moderazione contenuti
• Assistenza clienti
• Obblighi legali, contabili e fiscali

DIRITTI DELL''INTERESSATO (artt. 15-22 GDPR):
• Accesso: ottenere copia dei dati
• Rettifica: correggere dati inesatti
• Cancellazione: richiedere eliminazione
• Limitazione: limitare il trattamento
• Portabilità: ricevere dati in formato strutturato
• Opposizione: opporsi al trattamento
• Revoca consenso: in qualsiasi momento

Per esercitare i diritti: privacy@trovafacile.it

SICUREZZA:
Adottiamo misure tecniche e organizzative per proteggere i dati. Le password sono crittografate. I dati sensibili sono conservati su server sicuri nell''UE.', 16),

('subscriptions', 'Abbonamenti e Prezzi', 'CLIENTI - ABBONAMENTO MENSILE:
€0,49/mese (1 persona) | €0,79/mese (2 persone)
€0,99/mese (3 persone) | €1,49/mese (4 persone)

CLIENTI - ABBONAMENTO ANNUALE:
€4,90/anno (1 persona) | €7,90/anno (2 persone)
€9,90/anno (3 persone) | €14,90/anno (4 persone)

BUSINESS - ABBONAMENTO MENSILE + IVA:
€2,49/mese (1 sede) | €3,99/mese (2 sedi) | €5,49/mese (3 sedi)
€7,99/mese (4 sedi) | €9,99/mese (5 sedi) | €12,99/mese (6-10 sedi)
€14,99/mese (10+ sedi)

BUSINESS - ABBONAMENTO ANNUALE + IVA:
€24,90/anno (1 sede) | €39,90/anno (2 sedi) | €54,90/anno (3 sedi)
€79,90/anno (4 sedi) | €99,90/anno (5 sedi) | €129,90/anno (6-10 sedi)
€149,90/anno (10+ sedi)

TUTTI I PIANI INCLUDONO:
✓ 1 mese di prova gratuita
✓ Tutte le funzionalità della piattaforma
✓ 10% donato in beneficienza
✓ Nessun vincolo, disdici quando vuoi
✓ Promemoria 7 giorni prima della scadenza prova', 17),

('refund_policy', 'Diritto di Recesso', 'Ai sensi degli artt. 52-59 del D.Lgs. 206/2005 (Codice del Consumo), hai diritto di recedere dall''abbonamento entro 14 giorni dalla sottoscrizione senza motivazione.

COME ESERCITARE IL DIRITTO:
1. Invia comunicazione a: recesso@trovafacile.it
2. Indica: nome, email, numero abbonamento, data sottoscrizione
3. Riceverai conferma entro 48 ore
4. Rimborso entro 14 giorni sulla stessa modalità di pagamento

ECCEZIONI:
Ai sensi dell''art. 59, il diritto di recesso è escluso per servizi già completamente eseguiti con consenso espresso del consumatore.', 18),

('contact_support', 'Contatti e Supporto', 'Per reclami, assistenza o controversie:

EMAIL: supporto@trovafacile.it
PEC: trovafacile@pec.it
TEMPI DI RISPOSTA: 7 giorni lavorativi

PIATTAFORMA ODR:
Ai sensi del Regolamento UE 524/2013, i consumatori possono utilizzare la piattaforma europea per la risoluzione online delle controversie: https://ec.europa.eu/consumers/odr

MODIFICHE AL REGOLAMENTO:
TrovaFacile si riserva il diritto di modificare il presente regolamento. Le modifiche saranno comunicate via email e pubblicate su questa pagina. L''utilizzo continuato dopo le modifiche costituisce accettazione.

Ultimo aggiornamento: 6 Marzo 2026', 19)
ON CONFLICT DO NOTHING;