import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization, X-Client-Info, Apikey",
};

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { status: 200, headers: corsHeaders });
  }

  try {
    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    // 1. Controlla scadenze 48h per completion in corso (vincitore non ha confermato)
    const { error: deadlineError } = await supabase.rpc("check_auction_completion_deadlines");
    if (deadlineError) {
      console.error("Error checking completion deadlines:", deadlineError);
    }

    // 2. Chiudi le aste scadute (ends_at passato, ancora active)
    const { data: expiredAuctions, error: fetchError } = await supabase
      .from("auctions")
      .select("id, title, user_id, family_member_id, current_price")
      .eq("status", "active")
      .eq("approval_status", "approved")
      .lt("ends_at", new Date().toISOString());

    if (fetchError) throw fetchError;

    if (!expiredAuctions || expiredAuctions.length === 0) {
      return new Response(
        JSON.stringify({ message: "No expired auctions found", closed: 0 }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    let closed = 0;

    for (const auction of expiredAuctions) {
      // Trova il miglior offerente (vincitore #1)
      const { data: topBid } = await supabase
        .from("auction_bids")
        .select("user_id, family_member_id, bid_amount")
        .eq("auction_id", auction.id)
        .order("bid_amount", { ascending: false })
        .limit(1)
        .maybeSingle();

      if (!topBid) {
        // Nessuna offerta: asta scaduta senza vincitore
        const { error: expireError } = await supabase
          .from("auctions")
          .update({ status: "expired", updated_at: new Date().toISOString() })
          .eq("id", auction.id);

        if (expireError) {
          console.error(`Failed to expire auction ${auction.id}:`, expireError);
          continue;
        }

        // Rimborsa tutti i ticket (non ci sono state offerte valide)
        await supabase
          .from("auction_deposits")
          .update({ refunded: true, refunded_at: new Date().toISOString() })
          .eq("auction_id", auction.id)
          .eq("refunded", false);

        const { error: notifError } = await supabase.from("notifications").insert({
          user_id: auction.user_id,
          family_member_id: auction.family_member_id,
          type: "auction_concluded",
          title: "Asta Scaduta Senza Offerte",
          message: `La tua asta "${auction.title}" è scaduta senza ricevere offerte.`,
          data: { auction_id: auction.id },
        });
        if (notifError) console.error(`Failed to notify owner for expired auction ${auction.id}:`, notifError);

        closed++;
        continue;
      }

      const winnerId = topBid.user_id;
      const winnerFamilyMemberId = topBid.family_member_id ?? null;
      const deadline = new Date(Date.now() + 48 * 60 * 60 * 1000).toISOString();

      // Chiudi l'asta con il vincitore
      const { error: updateError } = await supabase
        .from("auctions")
        .update({
          status: "completed",
          completed_at: new Date().toISOString(),
          winner_id: winnerId,
          winner_family_member_id: winnerFamilyMemberId,
          winner_index: 0,
          current_completion_deadline: deadline,
          updated_at: new Date().toISOString(),
        })
        .eq("id", auction.id);

      if (updateError) {
        console.error(`Failed to close auction ${auction.id}:`, updateError);
        continue;
      }

      // Crea il record di completion per il vincitore #1
      const { error: completionError } = await supabase
        .from("auction_completions")
        .upsert({
          auction_id: auction.id,
          winner_user_id: winnerId,
          winner_family_member_id_completion: winnerFamilyMemberId,
          completion_deadline: deadline,
          attempt_number: 1,
          seller_confirmed: false,
          buyer_confirmed: false,
        }, { onConflict: "auction_id" });

      if (completionError) {
        console.error(`Failed to create completion for auction ${auction.id}:`, completionError);
      }

      // Notifica il venditore
      const { error: ownerNotifError } = await supabase.from("notifications").insert({
        user_id: auction.user_id,
        family_member_id: auction.family_member_id,
        type: "auction_concluded",
        title: "Asta Conclusa - Conferma Richiesta",
        message: `La tua asta "${auction.title}" è terminata. Prezzo finale: ${Number(topBid.bid_amount).toFixed(2)} EUR. Hai 48 ore per confermare l'affare.`,
        data: { auction_id: auction.id, winner_id: winnerId, final_price: topBid.bid_amount },
      });
      if (ownerNotifError) console.error(`Failed to notify owner for auction ${auction.id}:`, ownerNotifError);

      // Notifica il vincitore (se diverso dal venditore)
      if (winnerId !== auction.user_id) {
        const { error: winnerNotifError } = await supabase.from("notifications").insert({
          user_id: winnerId,
          family_member_id: winnerFamilyMemberId,
          type: "auction_won",
          title: "Hai Vinto l'Asta!",
          message: `Congratulazioni! Hai vinto l'asta "${auction.title}" con un'offerta di ${Number(topBid.bid_amount).toFixed(2)} EUR. Hai 48 ore per confermare l'affare. Se non confermi, perderai il tuo ticket.`,
          data: { auction_id: auction.id, final_price: topBid.bid_amount },
        });
        if (winnerNotifError) console.error(`Failed to notify winner for auction ${auction.id}:`, winnerNotifError);
      }

      closed++;
    }

    return new Response(
      JSON.stringify({ message: `Closed ${closed} expired auctions`, closed }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (err: any) {
    console.error("Error in close-expired-auctions:", err);
    return new Response(
      JSON.stringify({ error: err.message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
