import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization, X-Client-Info, Apikey",
};

interface UnclaimedBusiness {
  id: string;
  name: string;
  email: string;
  city: string;
  province: string;
  region: string;
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, {
      status: 200,
      headers: corsHeaders,
    });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    const { limit = 100, offset = 0 } = await req.json().catch(() => ({ limit: 100, offset: 0 }));

    // Recupera le attività non rivendicate con email valida
    const { data: businesses, error: fetchError } = await supabase
      .from("unclaimed_business_locations")
      .select("id, name, email, city, province, region")
      .eq("is_claimed", false)
      .not("email", "is", null)
      .neq("email", "")
      .range(offset, offset + limit - 1);

    if (fetchError) {
      console.error("Error fetching businesses:", fetchError);
      throw fetchError;
    }

    if (!businesses || businesses.length === 0) {
      return new Response(
        JSON.stringify({ 
          success: true, 
          message: "No unclaimed businesses with email found",
          sent: 0 
        }),
        {
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        }
      );
    }

    const sentEmails: string[] = [];
    const failedEmails: Array<{ email: string; error: string }> = [];

    // Invia email a ciascuna attività
    for (const business of businesses as UnclaimedBusiness[]) {
      try {
        const emailContent = generateEmailContent(business);
        
        // Qui dovresti integrare il tuo servizio di email (es. SendGrid, Resend, ecc.)
        // Per ora, logghiamo l'email che sarebbe stata inviata
        console.log(`Email would be sent to: ${business.email}`);
        console.log(`Subject: La tua attività "${business.name}" è su TrovaFacile!`);
        console.log(`Content:`, emailContent);
        
        // Simula l'invio dell'email (sostituire con servizio reale)
        // await sendEmail(business.email, emailContent);
        
        sentEmails.push(business.email);
      } catch (emailError: any) {
        console.error(`Failed to send email to ${business.email}:`, emailError);
        failedEmails.push({ 
          email: business.email, 
          error: emailError.message || "Unknown error" 
        });
      }
    }

    return new Response(
      JSON.stringify({
        success: true,
        message: `Processed ${businesses.length} businesses`,
        sent: sentEmails.length,
        failed: failedEmails.length,
        sentEmails,
        failedEmails,
      }),
      {
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      }
    );
  } catch (error: any) {
    console.error("Error in notify-unclaimed-businesses:", error);
    return new Response(
      JSON.stringify({
        success: false,
        error: error.message || "An error occurred",
      }),
      {
        status: 500,
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      }
    );
  }
});

function generateEmailContent(business: UnclaimedBusiness): string {
  const siteUrl = "https://trovafacile.it";
  const claimUrl = `${siteUrl}?claim=${business.id}`;
  
  return `
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>La tua attività è su TrovaFacile!</title>
  <style>
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      line-height: 1.6;
      color: #333;
      background-color: #f4f4f4;
      margin: 0;
      padding: 0;
    }
    .container {
      max-width: 600px;
      margin: 40px auto;
      background-color: #ffffff;
      border-radius: 10px;
      overflow: hidden;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }
    .header {
      background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
      color: white;
      padding: 40px 30px;
      text-align: center;
    }
    .header h1 {
      margin: 0;
      font-size: 28px;
      font-weight: 600;
    }
    .content {
      padding: 40px 30px;
    }
    .business-name {
      font-size: 22px;
      font-weight: 600;
      color: #2563eb;
      margin-bottom: 10px;
    }
    .location {
      color: #6b7280;
      font-size: 16px;
      margin-bottom: 25px;
    }
    .message {
      font-size: 16px;
      line-height: 1.8;
      margin-bottom: 25px;
    }
    .benefits {
      background-color: #f0f9ff;
      border-left: 4px solid #3b82f6;
      padding: 20px;
      margin: 25px 0;
      border-radius: 5px;
    }
    .benefits h3 {
      margin-top: 0;
      color: #1e40af;
      font-size: 18px;
    }
    .benefits ul {
      margin: 15px 0;
      padding-left: 20px;
    }
    .benefits li {
      margin: 10px 0;
      color: #374151;
    }
    .cta-button {
      display: inline-block;
      background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
      color: white;
      text-decoration: none;
      padding: 16px 40px;
      border-radius: 8px;
      font-weight: 600;
      font-size: 16px;
      margin: 20px 0;
      text-align: center;
      transition: transform 0.2s;
    }
    .trial-info {
      background-color: #ecfdf5;
      border: 2px solid #10b981;
      border-radius: 8px;
      padding: 20px;
      margin: 25px 0;
      text-align: center;
    }
    .trial-info h4 {
      color: #047857;
      margin: 0 0 10px 0;
      font-size: 18px;
    }
    .trial-info p {
      color: #065f46;
      margin: 5px 0;
      font-size: 14px;
    }
    .footer {
      background-color: #f9fafb;
      padding: 30px;
      text-align: center;
      color: #6b7280;
      font-size: 14px;
      border-top: 1px solid #e5e7eb;
    }
    .footer a {
      color: #3b82f6;
      text-decoration: none;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>🎉 La tua attività è su TrovaFacile!</h1>
    </div>
    
    <div class="content">
      <div class="business-name">${business.name}</div>
      <div class="location">📍 ${business.city}, ${business.province} - ${business.region}</div>
      
      <div class="message">
        <p>Buongiorno,</p>
        <p>
          Siamo lieti di informarti che la tua attività <strong>${business.name}</strong> 
          è stata inserita su <strong>TrovaFacile</strong>, la piattaforma italiana che mette 
          in contatto le attività locali con i clienti della loro zona.
        </p>
        <p>
          Migliaia di utenti stanno già cercando attività come la tua! Non perdere l'opportunità 
          di raggiungere nuovi clienti e far crescere il tuo business.
        </p>
      </div>

      <div class="trial-info">
        <h4>⏰ Prova Gratuita di 3 Mesi!</h4>
        <p><strong>Rivendica ora la tua attività e ottieni 90 giorni di prova gratuita</strong></p>
        <p>Nessuna carta di credito richiesta - Inizia subito!</p>
      </div>

      <div class="benefits">
        <h3>🚀 Cosa puoi fare rivendicando la tua attività:</h3>
        <ul>
          <li><strong>Gestisci il tuo profilo</strong> - Aggiungi foto, orari, contatti e descrizione</li>
          <li><strong>Rispondi alle recensioni</strong> - Interagisci con i tuoi clienti</li>
          <li><strong>Crea sconti e promozioni</strong> - Attira nuovi clienti con offerte esclusive</li>
          <li><strong>Pubblica offerte di lavoro</strong> - Trova personale qualificato nella tua zona</li>
          <li><strong>Aumenta la visibilità</strong> - Raggiungi migliaia di potenziali clienti</li>
          <li><strong>Statistiche dettagliate</strong> - Monitora visualizzazioni e performance</li>
        </ul>
      </div>

      <div style="text-align: center;">
        <a href="${claimUrl}" class="cta-button">
          Rivendica la Tua Attività Ora
        </a>
      </div>

      <div class="message" style="margin-top: 30px; font-size: 14px; color: #6b7280;">
        <p>
          <strong>Come funziona:</strong><br>
          1. Clicca sul pulsante qui sopra<br>
          2. Registrati o accedi al tuo account<br>
          3. Verifica di essere il proprietario dell'attività<br>
          4. Inizia subito a gestire il tuo profilo gratuitamente per 3 mesi!
        </p>
        <p style="margin-top: 20px;">
          Dopo i 3 mesi gratuiti, potrai continuare a soli <strong>2,49€/mese + IVA</strong>. 
          Riceverai un promemoria 7 giorni prima della scadenza.
        </p>
      </div>
    </div>

    <div class="footer">
      <p>
        <strong>TrovaFacile</strong> - La piattaforma che connette attività locali e clienti<br>
        <a href="${siteUrl}">Visita il sito</a> | 
        <a href="${siteUrl}/contact">Contattaci</a>
      </p>
      <p style="margin-top: 15px; font-size: 12px;">
        Se non sei il proprietario di questa attività, puoi ignorare questa email.<br>
        Link diretto: <a href="${claimUrl}">${claimUrl}</a>
      </p>
    </div>
  </div>
</body>
</html>
  `.trim();
}
