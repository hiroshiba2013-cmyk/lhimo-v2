# Audit Report: 143 Migrazioni Non Applicate

**Progetto:** `lrqeojukjpjllnvsjtor`
**Data:** 17 luglio 2026
**Totale migrazioni:** 455 | **Applicate con successo:** 312 | **Fallite:** 143

---

## Sintesi

| Categoria | Numero | Sicuro ignorare? |
|---|---|---|
| Policy/constraint già esistenti | 58 | SI |
| Seed data con chiavi duplicate | 6 | SI |
| Colonne `businesses` vecchia struttura (office_street, billing_street) | 24 | SI |
| Tabella `unclaimed_business_locations` mai creata | 18 | SI |
| Tabella `imported_businesses` mai creata | 4 | SI |
| Colonne `reviews` vecchia struttura (imported_business_id, business_type) | 5 | SI |
| Colonna `tax_code` rinominata in `fiscal_code` | 1 | SI |
| Funzioni con overloading / return type | 10 | PARZIALMENTE |
| Trigger mancanti | 2 | DA VERIFICARE |
| **Colonne realmente mancanti** | **8** | **NO - RICHIEDE AZIONE** |
| Enum/constraint già esistenti | 3 | SI |
| Altri errori | 4 | DA VERIFICARE |

---

## SEZIONE A — 58 migrazioni con "already exists" (POLICY/CONSTRAINT GIÀ ESISTENTI)

**Errore tipico:** `policy "X" for table "Y" already exists` oppure `constraint "X" already exists`

**Verdetto:** SICURO IGNORARE. La policy/constraint è già presente nel database, creata da una migrazione precedente andata a buon fine. La migrazione fallisce perché tenta di ricrearla.

| # | File | Oggetto già esistente |
|---|---|---|
| 1 | `20251125215918_create_review_platform_schema.sql` | policy "Users can update own profile" su profiles |
| 2 | `20251203102838_create_job_postings_tables.sql` | policy "Anyone can view active job postings" su job_postings |
| 3 | `20251204105615_add_customer_avatar_and_job_requests.sql` | policy "Anyone can view active job requests" su job_requests |
| 5 | `20251209152033_add_family_members_and_business_locations.sql` | policy "Users can view own family members" su customer_family_members |
| 6 | `20251216111610_allow_public_view_subscription_plans.sql` | policy "Public can view subscription plans" su subscription_plans |
| 7 | `20251217105436_add_vat_and_street_number_to_business_locations.sql` | constraint "business_locations_province_format" |
| 8 | `20251217162723_add_user_activity_and_rewards_tables.sql` | policy "Anyone can view active rewards" su rewards |
| 9 | `20251217214619_add_unclaimed_businesses_support.sql` | policy "Business owners can view own and unclaimed businesses" |
| 23 | `20251219113249_allow_public_view_unclaimed_business_locations.sql` | policy "Anyone can view locations of unclaimed businesses" |
| 24 | `20251219120500_allow_public_view_categories.sql` | policy "Public can view all categories" su business_categories |
| 36 | `20251228211351_add_review_proof_and_approval_system.sql` | policy "Approved reviews are viewable by everyone" su reviews |
| 37 | `20251228220655_add_job_views_tracking.sql` | policy "Users can view their own job views" su job_views |
| 38 | `20251228221325_create_products_system.sql` | policy "Anyone can view product categories" |
| 39 | `20251228223000_create_classified_ads_system.sql` | policy "Anyone can view categories" su classified_categories |
| 40 | `20251229092530_create_classified_ads_messaging_system.sql` | policy "Users can view own conversations" su ad_conversations |
| 41 | `20251229095801_create_solidarity_system.sql` | policy "Anyone can view solidarity documents" |
| 42 | `20251229115822_create_job_seekers_and_messaging_system.sql` | policy "Anyone can view active job seeker ads" |
| 43 | `20251229175405_create_notifications_and_reports_system.sql` | policy "Users can view own notifications" |
| 44 | `20251230173006_create_favorites_system.sql` | policy "Users can view their own favorite businesses" |
| 45 | `20260104180549_create_activity_log_system.sql` | policy "Users can view own activity log" |
| 46 | `20260112162141_create_discount_redemptions_system.sql` | policy "Users can view own discount redemptions" |
| 47 | `20260113223512_add_discount_verification_system.sql` | policy "Business owners can verify discount redemptions" |
| 50 | `20260206095721_add_public_view_approved_reviews.sql` | policy "Anonymous users can view approved reviews" |
| 54 | `20260209150442_allow_public_view_business_locations.sql` | policy "Anyone can view business locations" |
| 56 | `20260210105539_allow_public_view_claimed_businesses.sql` | policy "Public can view verified or claimed businesses" |
| 65 | `20260212144406_fix_favorite_ads_visibility.sql` | policy "Users can view their favorited ads" su classified_ads |
| 71 | `20260217101331_add_public_profile_view_policy.sql` | policy "Authenticated users can view all profiles" |
| 74 | `20260224150348_create_tasks_table.sql` | policy "Users can view own tasks" |
| 76 | `20260226101245_add_admins_table_rls_policies.sql` | policy "Anyone can read admins table" |
| 77 | `20260226105500_fix_admin_registration_nickname_check.sql` | policy "Allow public to check nickname existence" |
| 78 | `20260227080233_allow_admin_self_promotion.sql` | policy "Users can insert themselves as admin" |
| 79 | `20260227084030_fix_admins_rls_for_login.sql` | policy "Authenticated users can check admin status" |
| 80 | `20260227105455_add_admin_profile_read_policy.sql` | policy "Admins can read own profile" |
| 81 | `20260227142637_create_admin_login_logs.sql` | policy "Admins can view own login logs" |
| 83 | `20260303084527_create_charity_organizations_table.sql` | policy "Public can view active charity organizations" |
| 90 | `20260305205726_fix_user_activity_rls_for_leaderboard.sql` | policy "All authenticated users can view leaderboard" |
| 91 | `20260305222528_create_platform_settings_table_v2.sql` | policy "Anyone can view platform settings" |
| 92 | `20260305224512_create_rules_content_system.sql` | policy "Anyone can view active rules sections" |
| 93 | `20260306091728_add_rules_content_table.sql` | policy "Anyone can view active rules content" |
| 94 | `20260306095535_create_trial_prevention_system.sql` | policy "Only admins can view trial history" |
| 97 | `20260307195638_fix_subscriptions_admin_access.sql` | policy "Admin can delete subscriptions" |
| 98 | `20260307204135_fix_subscriptions_rls_cleanup_duplicates.sql` | policy "Users view own subscriptions" |
| 99 | `20260328221103_fix_registered_businesses_rls_policies.sql` | policy "Business owners can insert their businesses" |
| 100 | `20260405160148_create_auctions_system.sql` | policy "Anyone can view active auctions" |
| 102 | `20260420092534_fix_notifications_rls_strict_isolation.sql` | policy "Service role can insert notifications" |
| 105 | `20260420100108_allow_public_read_family_members_for_leaderboard.sql` | policy "Authenticated users can view family members" |
| 113 | `20260506091833_create_platform_messages_table.sql` | policy "Anyone can send a platform message" |
| 114 | `20260507123538_update_auctions_ticket_system.sql` | constraint "auction_deposits_amount_positive" |
| 118 | `20260511072322_create_professional_profiles_table.sql` | policy "Owner can view own professional profile" |
| 119 | `20260511075135_add_admin_policies_professional_profiles.sql` | policy "Admins can view all professional profiles" |
| 120 | `20260511142654_add_family_member_avatar_storage_policies.sql` | policy "Users can upload family member avatars" |
| 121 | `20260511210626_add_family_member_to_professional_profiles.sql` | constraint "professional_profiles_user_family_unique" |
| 122 | `20260512061748_create_admin_tab_seen_timestamps.sql` | policy "Admin can read own tab seen" |
| 124 | `20260512100200_add_location_avatar_storage_policies.sql` | policy "Users can upload location avatars" |
| 140 | `20260617090828_create_page_customizations.sql` | policy "admin_select_page_customizations" |
| 141 | `20260702092959_add_business_location_photos.sql` | policy "authenticated_upload_business_location_photos" |
| 104 | `20260420095228_add_family_member_support_to_user_activity.sql` | constraint "user_activity_user_family_unique" |

---

## SEZIONE B — 6 migrazioni seed data con chiavi duplicate

**Errore tipico:** `duplicate key value violates unique constraint "businesses_vat_number_key"`

**Verdetto:** SICURO IGNORARE. I business con quel VAT number sono già presenti nel database (368 righe già caricate). Le migrazioni tentano di reinserire gli stessi record.

| # | File | Motivo |
|---|---|---|
| 25 | `20251219125000_seed_italian_businesses_all_regions.sql` | VAT number duplicato |
| 26 | `20251219130000_seed_businesses_batch1.sql` | VAT number duplicato |
| 27 | `20251219131000_seed_businesses_batch_100.sql` | VAT number duplicato |
| 28 | `20251219132000_seed_businesses_batch_30.sql` | VAT number duplicato |
| 29 | `20251219133000_seed_businesses_batch2_50.sql` | VAT number duplicato |
| 30 | `20251219134000_seed_batch_100_part1.sql` | VAT number duplicato |

---

## SEZIONE C — 24 migrazioni seed data con colonne vecchia struttura su `businesses`

**Errore tipico:** `column "office_street" / "billing_street" / "office_province" of relation "businesses" does not exist`

**Verdetto:** SICURO IGNORARE. Queste colonne non sono mai state aggiunte alla tabella `businesses` perché il modello dati è stato ristrutturato. I campi `billing_street`, `office_street`, `office_province` ecc. ora vivono su `registered_businesses` e `profiles`. Queste migrazioni sono seed data che usa la struttura vecchia.

**Tabella `businesses` (attuale, 24 colonne):** id, owner_id, category_id, name, description, address, city, phone, email, website, logo_url, verified, created_at, vat_number, unique_code, pec_email, billing_address, office_address, ateco_code, website_url, is_claimed, search_vector, claimed_at, verification_badge

**Tabella `registered_businesses` (dove sono i campi):** billing_street, billing_street_number, billing_postal_code, billing_city, billing_province, office_street, office_street_number, office_postal_code, office_city, office_province, office_address

| # | File | Colonna mancante |
|---|---|---|
| 10 | `20251217214718_seed_unclaimed_businesses_data_v2.sql` | billing_street |
| 11 | `20251217220434_add_more_unclaimed_businesses.sql` | billing_street |
| 12 | `20251217222338_seed_varese_businesses.sql` | office_province |
| 13 | `20251217224723_seed_real_italian_businesses.sql` | office_street |
| 14 | `20251217225707_seed_real_verified_italian_businesses.sql` | office_street |
| 15 | `20251218092310_seed_comprehensive_italian_businesses.sql` | office_street |
| 16 | `20251218092517_seed_additional_italian_businesses_extensive.sql` | office_street |
| 17 | `20251218093652_seed_professional_services_and_trades.sql` | office_street |
| 18 | `20251218094047_seed_all_provinces_comprehensive_part1.sql` | office_street |
| 19 | `20251218094250_seed_all_provinces_comprehensive_part2.sql` | office_street |
| 20 | `20251218094453_seed_all_provinces_comprehensive_part3_center_south.sql` | office_street |
| 21 | `20251218094651_seed_all_provinces_comprehensive_part4_islands.sql` | office_street |
| 22 | `20251218102922_seed_varese_comprehensive_businesses_fixed.sql` | office_province |
| 132 | `20260524204658_schema_chunk_005.sql` | billing_street |
| 133 | `20260524205034_schema_chunk_006.sql` | office_street |
| 134 | `20260524205314_schema_chunk_007.sql` | office_street |
| 4 | `20251205105522_add_ateco_codes_to_categories.sql` | FK violation su business_categories |
| 49 | `20260114100608_add_claimed_fields_to_businesses_table.sql` | check constraint check_claimed_requires_owner |

---

## SEZIONE D — 22 migrazioni che referenziano `unclaimed_business_locations` (tabella mai creata)

**Errore tipico:** `relation "unclaimed_business_locations" does not exist`

**Verdetto:** SICURO IGNORARE. La tabella `unclaimed_business_locations` non è mai stata creata. Era parte di un'architettura intermedia (migrazione `20260209155818`) che è fallita ed è stata soppiantata dalla struttura attuale: `registered_businesses` + `registered_business_locations` + `user_added_businesses`. Tutte le migrazioni che la referenziano aggiungono policy, trigger, o funzioni su una tabella che non esisterà mai.

| # | File | Cosa fa |
|---|---|---|
| 48 | `20260114100545_add_claimed_status_to_businesses_fixed.sql` | RLS su unclaimed_business_locations |
| 51 | `20260206100938_allow_reviews_for_unclaimed_businesses.sql` | RLS per recensioni su unclaimed |
| 52 | `20260206101113_update_business_ratings_view_for_unclaimed.sql` | View update |
| 55 | `20260209155818_20260209_restructure_business_tables_v3.sql` | Creazione tabella (fallita per dipendenze) |
| 64 | `20260211111426_add_unclaimed_business_location_reviews_support.sql` | RLS recensioni |
| 67 | `20260212162455_add_family_member_to_unclaimed_businesses.sql` | ADD COLUMN family_member_id |
| 69 | `20260212214043_add_unclaimed_business_support_to_favorites.sql` | RLS favorites |
| 82 | `20260227154828_fix_admin_policies_all_tables.sql` | Admin RLS |
| 85 | `20260303213406_subtract_points_on_delete.sql` | Trigger punti |
| 86 | `20260303214823_fix_user_activity_tracking_system_final.sql` | Tracking fix |
| 87 | `20260303215649_fix_business_addition_points_system.sql` | Punti fix |
| 88 | `20260303223032_fix_unclaimed_business_delete_rls.sql` | Delete RLS |
| 101 | `20260414095034_add_business_approval_system.sql` | Approval system |
| 106 | `20260420202007_fix_unclaimed_business_points_only_on_approval.sql` | Punti su approval |
| 108 | `20260422082140_fix_unclaimed_business_default_approval_status.sql` | Default approval |
| 117 | `20260510204237_create_search_unclaimed_businesses_function.sql` | Funzione di search |
| 123 | `20260512063813_create_get_comuni_with_few_businesses_function.sql` | Funzione comuni |
| 129 | `20260521164404_cleanup_duplicates_batch1_names_az.sql` | Cleanup duplicati |
| 130 | `20260521164422_cleanup_duplicates_batch2_names_nz.sql` | Cleanup duplicati |
| 131 | `20260521164436_cleanup_duplicates_non_alpha_names.sql` | Cleanup duplicati |
| 137 | `20260603181055_seed_all_activities_pending_v6.sql` | Seed activities |
| 139 | `20260616150224_20260616_add_ai_moderation.sql` | AI moderation |
| 142 | `20260705202618_add_parent_id_and_replace_categories_v2.sql` | Categories restructure |

---

## SEZIONE E — 4 migrazioni che referenziano `imported_businesses` (tabella mai creata)

**Errore tipico:** `relation "imported_businesses" does not exist`

**Verdetto:** SICURO IGNORARE. Stessa situazione di Sezione D. La tabella `imported_businesses` faceva parte dell'architettura intermedia, sostituita da `user_added_businesses` e `registered_businesses`.

| # | File | Cosa fa |
|---|---|---|
| 73 | `20260220092426_extend_admin_full_control.sql` | Admin RLS su imported_businesses |
| 75 | `20260225160827_replace_all_profile_subqueries_with_is_admin.sql` | Sostituzione subquery |
| 116 | `20260508055303_add_is_claimed_to_source_tables.sql` | ADD COLUMN is_claimed |
| 4  | `20251205105522_add_ateco_codes_to_categories.sql` | (anche FK violation) |

---

## SEZIONE F — 5 migrazioni con colonne vecchie su `reviews`

**Errore:** colonne `imported_business_id`, `business_type`, `unclaimed_business_location_id` non esistono su `reviews`

**Verdetto:** SICURO IGNORARE. La tabella `reviews` ha `business_location_id` e `registered_business_location_id` al posto di `imported_business_id` e `unclaimed_business_location_id`. Il campo `business_type` è stato sostituito da `review_type`.

**Colonne reviews correlate (presenti):** business_location_id, registered_business_location_id, review_type

| # | File | Colonna mancante |
|---|---|---|
| 66 | `20260212155102_fix_reviews_insert_policy_family_members.sql` | business_type |
| 84 | `20260303155448_fix_reviews_rls_unclaimed_businesses.sql` | business_type |
| 89 | `20260304211704_add_review_uniqueness_constraints.sql` | imported_business_id |
| 109 | `20260422084131_fix_reviews_insert_rls_policy_business_types.sql` | imported_business_id |
| 126 | `20260514135346_add_registered_business_columns_to_reviews.sql` | imported_business_id |

---

## SEZIONE G — 10 migrazioni con funzioni (overloading / return type)

**Errore tipico:** `cannot change return type of existing function` oppure `function name "X" is not unique`

**Verdetto:** PARZIALMENTE SICURO. Le funzioni esistono e funzionano, ma alcune hanno una firma/return type diversa da quella che le migrazioni tentavano di impostare. Le ultime versioni delle funzioni sono già quelle corrette (create da migrazioni successive andate a buon fine).

| # | File | Funzione | Errore | Stato attuale |
|---|---|---|---|---|
| 31 | `20251227224325_create_get_business_ratings_function.sql` | get_business_ratings | cannot change return type | Funzione esiste, return type TABLE(id, avg_rating, review_count) |
| 35 | `20251228210610_update_get_business_ratings_use_overall_rating.sql` | get_business_ratings | cannot change return type | Sovrascritta da versione successiva |
| 34 | `20251228205449_add_award_points_function.sql` | award_points | function name not unique | Funzione esiste con 5 params |
| 53 | `20260206111622_fix_award_points_use_user_activity.sql` | award_points | function name not unique | Versione corrente operativa |
| 63 | `20260210213810_update_award_points_increment_reviews_count.sql` | award_points | function name not unique | Versione corrente operativa |
| 58 | `20260210110649_update_search_function_include_old_tables.sql` | search_all_businesses | cannot change return type | Funzione esiste, 28 colonne output |
| 59 | `20260210110744_fix_city_search_case_insensitive.sql` | search_all_businesses | cannot change return type | Sovrascritta da versione finale |
| 60 | `20260210110839_update_search_order_verified_first.sql` | search_all_businesses | cannot change return type | Sovrascritta da versione finale |
| 61 | `20260210110922_fix_search_function_remove_wrapper.sql` | search_all_businesses | cannot change return type | Sovrascritta da versione finale |
| 62 | `20260210143142_update_search_to_locations_based.sql` | search_all_business_locations | function name not unique | Funzione esiste, 28 colonne output |
| 72 | `20260219094514_create_featured_ads_function.sql` | featured_ads | cannot change return type | Verificare se esiste versione finale |
| 103 | `20260420092548_create_send_notification_function.sql` | send_notification | function name not unique | Funzione esiste con 6 params |

---

## SEZIONE H — 3 migrazioni con errori vari (enum, trigger, constraint)

**Verdetto:** SICURO IGNORARE per tutte.

| # | File | Errore | Motivo |
|---|---|---|---|
| 95 | `20260306095602_update_trial_triggers_with_prevention.sql` | column "tax_code" of customer_family_members does not exist | La colonna è stata rinominata in `fiscal_code` (presente) |
| 96 | `20260306213115_rename_tax_code_to_fiscal_code.sql` | column "tax_code" does not exist | La colonna è già stata rinominata, non esiste più `tax_code` |
| 110 | `20260422100511_add_italian_values_to_ad_type_enum.sql` | enum label "regalo" already exists | Il valore `regalo` è già presente nell'enum `ad_type_enum` |
| 115 | `20260507201130_disable_product_and_user_added_business_points_triggers.sql` | trigger "trigger_award_points_user_added_business" does not exist | Il trigger non è mai stato creato (vedi Sezione I) |

---

## SEZIONE I — MIGRAZIONI CON COLONNE REALMENTE MANCANTI (RICHIEDE AZIONE)

Queste migrazioni tentano di aggiungere colonne/trigger/strutture che **non esistono** nel database e che **potrebbero essere necessarie** per il funzionamento dell'applicazione.

### I-1. `business_locations` — colonne `latitude`, `longitude`, `region`, `is_claimed` MANCANTI

| # | File | Colonna | Stato |
|---|---|---|---|
| 32 | `20251227232003_populate_missing_business_locations.sql` | latitude | **MANCANTE** su business_locations (esiste su registered_business_locations) |
| 33 | `20251227232906_update_business_locations_regions.sql` | region | **MANCANTE** su business_locations (esiste su registered_business_locations) |
| 57 | `20260210105624_add_trigger_sync_business_is_claimed.sql` | is_claimed | **MANCANTE** su business_locations (esiste su businesses) |

**Impatto:** La tabella `business_locations` (915 righe) non ha coordinate geografiche ne `region`. Le funzioni di search restituiscono `latitude`, `longitude`, `region` ma leggendole da `registered_business_locations` (che ha queste colonne). Se l'app usa direttamente `business_locations` per mappe o filtri per regione, non funzionerà.

**Trigger `sync_business_is_claimed`:** **MANCANTE**. Doveva sincronizzare `is_claimed` tra `businesses` e `business_locations`.

### I-2. `favorite_businesses` — colonne `business_location_id`, `unclaimed_business_location_id`, `registered_business_location_id` MANCANTI

| # | File | Colonna | Stato |
|---|---|---|---|
| 70 | `20260213092428_add_business_location_id_to_favorites.sql` | business_location_id | **MANCANTE** |
| 125 | `20260514134343_add_registered_business_location_to_favorites.sql` | registered_business_location_id | **MANCANTE** |
| 127 | `20260519211836_add_unique_constraints_favorite_businesses.sql` | unclaimed_business_location_id | **MANCANTE** |

**Stato attuale:** `favorite_businesses` ha solo: id, user_id, family_member_id, business_id, created_at

**Impatto:** Se l'app permette di aggiungere ai preferiti una singola sede (location) invece di un business intero, non funzionerà. Il frontend usa `business_location_id` per i preferiti basati su sede.

### I-3. `user_activity` — colonne `ads_posted_count`, `businesses_added_count` MANCANTI

| # | File | Colonna | Stato |
|---|---|---|---|
| 107 | `20260421095511_add_classified_ads_approval_system_v2.sql` | ads_posted_count | **MANCANTE** |
| 111 | `20260505161721_fix_business_users_zero_points_exclude_leaderboard.sql` | ads_posted_count | **MANCANTE** |
| 136 | `20260603175908_reset_test_activities_cleanup_v3.sql` | businesses_added_count | **MANCANTE** |
| 138 | `20260604204816_fix_business_user_types_and_subscriptions.sql` | ads_posted_count | **MANCANTE** |

**Stato attuale:** `user_activity` ha `ads_count` (non `ads_posted_count`) e non ha `businesses_added_count`.

**Impatto:** Se l'app o le funzioni SQL referenziano `ads_posted_count` o `businesses_added_count`, genereranno errori. Il leaderboard potrebbe non mostrare correttamente il conteggio annunci.

### I-4. `business_categories` — colonna `parent_id` MANCANTE

| # | File | Colonna | Stato |
|---|---|---|---|
| 143 | `20260716090210_add_missing_categories_comprehensive.sql` | parent_id | **MANCANTE** |
| 142 | `20260705202618_add_parent_id_and_replace_categories_v2.sql` | parent_id | **MANCANTE** (migrazione fallita per dipendenza unclaimed_business_locations) |

**Stato attuale:** `business_categories` ha: id, name, slug, description, created_at, ateco_code. Nessun `parent_id`.

**Impatto:** Il componente `CategoryHierarchySelect` nel frontend usa una gerarchia di categorie. Senza `parent_id`, tutte le categorie sono flat (nessun parent/child). Le migrazioni 142-143 dovevano introdurre la gerarchia ma sono fallite.

### I-5. `job_postings` — colonne `region`, `province`, `city` MANCANTI

| # | File | Colonna | Stato |
|---|---|---|---|
| 112 | `20260506080920_add_region_province_city_to_job_postings.sql` | region, province, city | **MANCANTI** |

**Stato attuale:** `job_postings` ha `location` (text) ma non `region`, `province`, `city`.

**Impatto:** La migrazione 112 aggiungeva queste colonne + un trigger `auto_populate_job_posting_location` che popolava automaticamente region/province/city dai comuni. Se l'app filtra offerte di lavoro per regione/provincia/città, non funzionerà.

### I-6. `reviews` — colonna `unclaimed_business_location_id` MANCANTE

| # | File | Colonna | Stato |
|---|---|---|---|
| 89 | `20260304211704_add_review_uniqueness_constraints.sql` | unclaimed_business_location_id | **MANCANTE** |
| 109 | `20260422084131_fix_reviews_insert_rls_policy_business_types.sql` | imported_business_id | **MANCANTE** |
| 126 | `20260514135346_add_registered_business_columns_to_reviews.sql` | imported_business_id | **MANCANTE** (ma `registered_business_location_id` ESISTE) |

**Impatto:** Limitato. `reviews` ha `business_location_id` e `registered_business_location_id` che coprono i casi d'uso attuali. `imported_business_id` e `unclaimed_business_location_id` erano dell'architettura vecchia.

### I-7. Trigger `notify_business_on_review` MANCANTE

| # | File | Trigger | Stato |
|---|---|---|---|
| 135 | `20260603174120_seed_step8_nicknames_and_unclaimed_reviews.sql` | notify_business_on_review | **MANCANTE** |

**Impatto:** Le notifiche automatiche ai business quando ricevono una recensione potrebbero non funzionare se questo trigger non è stato sostituito da un altro. Verificare se le notifiche di recensione sono gestite dal sistema di notifiche unificato (trigger su reviews).

### I-8. Constraint ON CONFLICT su `user_activity` — `fix_user_activity_sync`

| # | File | Errore | Stato |
|---|---|---|---|
| 68 | `20260212165335_fix_user_activity_sync.sql` | there is no unique or exclusion constraint matching the ON CONFLICT | **MANCANTE** |

**Impatto:** La migrazione usava `ON CONFLICT (user_id, family_member_id)` ma il constraint unique corrispondente potrebbe non esistere nella forma attesa. Il constraint `user_activity_user_family_unique` ESISTE ma potrebbe avere colonne diverse. Verificare se i sync di user_activity funzionano correttamente.

---

## TABELLA RIASSUNTIVA — Azioni raccomandate

| Priorità | Oggetto mancante | Tabelle coinvolte | Azione |
|---|---|---|---|
| ALTA | `parent_id` su business_categories | business_categories | Aggiungere colonna + migrare gerarchia (migrazioni 142-143) |
| ALTA | `region`, `province`, `city` su job_postings | job_postings | Aggiungere colonne + trigger auto-populate (migrazione 112) |
| ALTA | `business_location_id` su favorite_businesses | favorite_businesses | Aggiungere colonna per favoriti per sede (migrazione 70, 125) |
| MEDIA | `ads_posted_count` su user_activity | user_activity | Aggiungere colonna o rinominare references nel codice (migrazioni 107, 111, 138) |
| MEDIA | `latitude`, `longitude`, `region` su business_locations | business_locations | Verificare se l'app legge da registered_business_locations invece |
| MEDIA | `is_claimed` su business_locations + trigger sync | business_locations | Aggiungere colonna + trigger (migrazione 57) |
| BASSA | `notify_business_on_review` trigger | reviews | Verificare se sostituito da sistema notifiche unificato |
| BASSA | ON CONFLICT constraint su user_activity | user_activity | Verificare constraint esistente |
| BASSA | `businesses_added_count` su user_activity | user_activity | Aggiungere colonna se referenziata dal frontend |
