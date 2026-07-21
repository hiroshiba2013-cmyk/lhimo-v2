
-- ============================================================
-- VIEW: subscriptions_readable
-- ============================================================

CREATE OR REPLACE VIEW subscriptions_readable AS
SELECT
  s.id,
  s.customer_id,
  s.plan_id,
  s.status,
  s.start_date,
  s.end_date,
  s.trial_end_date,
  s.payment_method_added,
  s.reminder_sent,
  s.created_at,
  s.updated_at,
  sp.name AS plan_name,
  sp.price AS plan_price,
  sp.max_persons AS max_family_members,
  sp.plan_type,
  p.full_name AS customer_name,
  p.email AS customer_email
FROM subscriptions s
JOIN subscription_plans sp ON s.plan_id = sp.id
JOIN profiles p ON s.customer_id = p.id;

GRANT SELECT ON subscriptions_readable TO authenticated;

-- ============================================================
-- TRIGGERS: updated_at automatici
-- ============================================================

DROP TRIGGER IF EXISTS update_reports_updated_at ON reports;
CREATE TRIGGER update_reports_updated_at
  BEFORE UPDATE ON reports FOR EACH ROW
  EXECUTE FUNCTION update_reports_updated_at();

DROP TRIGGER IF EXISTS trigger_update_reports_updated_at ON reports;
CREATE TRIGGER trigger_update_reports_updated_at
  BEFORE UPDATE ON reports FOR EACH ROW
  EXECUTE FUNCTION update_reports_updated_at();

DROP TRIGGER IF EXISTS update_platform_settings_updated_at ON platform_settings;
CREATE TRIGGER update_platform_settings_updated_at
  BEFORE UPDATE ON platform_settings FOR EACH ROW
  EXECUTE FUNCTION update_platform_settings_updated_at();

DROP TRIGGER IF EXISTS trigger_update_platform_settings_updated_at ON platform_settings;
CREATE TRIGGER trigger_update_platform_settings_updated_at
  BEFORE UPDATE ON platform_settings FOR EACH ROW
  EXECUTE FUNCTION update_platform_settings_updated_at();

DROP TRIGGER IF EXISTS professional_profiles_updated_at ON professional_profiles;
CREATE TRIGGER professional_profiles_updated_at
  BEFORE UPDATE ON professional_profiles FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS charity_organizations_updated_at ON charity_organizations;
CREATE TRIGGER charity_organizations_updated_at
  BEFORE UPDATE ON charity_organizations FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_imported_businesses_updated_at ON imported_businesses;
CREATE TRIGGER update_imported_businesses_updated_at
  BEFORE UPDATE ON imported_businesses FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_registered_businesses_updated_at ON registered_businesses;
CREATE TRIGGER update_registered_businesses_updated_at
  BEFORE UPDATE ON registered_businesses FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_registered_business_locations_updated_at ON registered_business_locations;
CREATE TRIGGER update_registered_business_locations_updated_at
  BEFORE UPDATE ON registered_business_locations FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_user_added_businesses_updated_at ON user_added_businesses;
CREATE TRIGGER update_user_added_businesses_updated_at
  BEFORE UPDATE ON user_added_businesses FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_registered_business_billing_address_trigger ON registered_businesses;
CREATE TRIGGER update_registered_business_billing_address_trigger
  BEFORE UPDATE ON registered_businesses FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- TRIGGERS: conversation last_message
-- ============================================================

DROP TRIGGER IF EXISTS update_conversation_last_message_trigger ON messages;
CREATE TRIGGER update_conversation_last_message_trigger
  AFTER INSERT ON messages FOR EACH ROW
  EXECUTE FUNCTION update_conversation_last_message();

DROP TRIGGER IF EXISTS trigger_update_conversation_last_message ON messages;
CREATE TRIGGER trigger_update_conversation_last_message
  AFTER INSERT ON messages FOR EACH ROW
  EXECUTE FUNCTION update_conversation_last_message();

DROP TRIGGER IF EXISTS update_conversation_last_message_trigger ON ad_messages;
CREATE TRIGGER update_conversation_last_message_trigger
  AFTER INSERT ON ad_messages FOR EACH ROW
  EXECUTE FUNCTION update_job_seeker_conversation_last_message();

DROP TRIGGER IF EXISTS update_job_seeker_conversation_last_message_trigger ON job_seeker_messages;
CREATE TRIGGER update_job_seeker_conversation_last_message_trigger
  AFTER INSERT ON job_seeker_messages FOR EACH ROW
  EXECUTE FUNCTION update_job_seeker_conversation_last_message();

DROP TRIGGER IF EXISTS update_job_offer_conversation_last_message_trigger ON job_offer_messages;
CREATE TRIGGER update_job_offer_conversation_last_message_trigger
  AFTER INSERT ON job_offer_messages FOR EACH ROW
  EXECUTE FUNCTION update_job_offer_conversation_last_message();

-- ============================================================
-- TRIGGERS: activity log
-- ============================================================

DROP TRIGGER IF EXISTS trigger_log_ad_creation ON classified_ads;
CREATE TRIGGER trigger_log_ad_creation
  AFTER INSERT ON classified_ads FOR EACH ROW
  EXECUTE FUNCTION log_ad_creation();

DROP TRIGGER IF EXISTS trigger_log_ad_view_milestone ON classified_ad_views;
CREATE TRIGGER trigger_log_ad_view_milestone
  AFTER INSERT ON classified_ad_views FOR EACH ROW
  EXECUTE FUNCTION log_ad_view_milestone();

DROP TRIGGER IF EXISTS trigger_log_review_submission ON reviews;
CREATE TRIGGER trigger_log_review_submission
  AFTER INSERT ON reviews FOR EACH ROW
  EXECUTE FUNCTION log_review_submission();

DROP TRIGGER IF EXISTS trigger_log_subscription_start ON subscriptions;
CREATE TRIGGER trigger_log_subscription_start
  AFTER INSERT ON subscriptions FOR EACH ROW
  EXECUTE FUNCTION log_subscription_start();

DROP TRIGGER IF EXISTS trigger_log_review_approval ON reviews;
CREATE TRIGGER trigger_log_review_approval
  AFTER UPDATE ON reviews FOR EACH ROW
  EXECUTE FUNCTION log_review_approval();

DROP TRIGGER IF EXISTS trigger_log_referral_reward ON subscriptions;
CREATE TRIGGER trigger_log_referral_reward
  AFTER UPDATE ON subscriptions FOR EACH ROW
  EXECUTE FUNCTION log_referral_reward();

-- ============================================================
-- TRIGGERS: classified ads
-- ============================================================

DROP TRIGGER IF EXISTS set_classified_ad_expiration_trigger ON classified_ads;
CREATE TRIGGER set_classified_ad_expiration_trigger
  BEFORE INSERT ON classified_ads FOR EACH ROW
  EXECUTE FUNCTION set_classified_ad_expiration();

DROP TRIGGER IF EXISTS trigger_award_points_classified_ad ON classified_ads;
CREATE TRIGGER trigger_award_points_classified_ad
  AFTER INSERT ON classified_ads FOR EACH ROW
  EXECUTE FUNCTION award_points_for_classified_ad();

DROP TRIGGER IF EXISTS trigger_award_points_product ON products;
CREATE TRIGGER trigger_award_points_product
  AFTER INSERT ON products FOR EACH ROW
  EXECUTE FUNCTION award_points_for_product();

-- ============================================================
-- TRIGGERS: notify favorites
-- ============================================================

DROP TRIGGER IF EXISTS trigger_notify_ad_favorited ON favorite_classified_ads;
CREATE TRIGGER trigger_notify_ad_favorited
  AFTER INSERT ON favorite_classified_ads FOR EACH ROW
  EXECUTE FUNCTION notify_ad_favorited();

DROP TRIGGER IF EXISTS trigger_notify_favorite_created ON favorite_businesses;
CREATE TRIGGER trigger_notify_favorite_created
  AFTER INSERT ON favorite_businesses FOR EACH ROW
  EXECUTE FUNCTION notify_favorite_created();

-- ============================================================
-- TRIGGERS: trial family change
-- ============================================================

DROP TRIGGER IF EXISTS trigger_update_trial_on_family_insert ON customer_family_members;
CREATE TRIGGER trigger_update_trial_on_family_insert
  AFTER INSERT ON customer_family_members FOR EACH ROW
  EXECUTE FUNCTION update_trial_plan_on_family_change();

DROP TRIGGER IF EXISTS trigger_update_trial_on_family_delete ON customer_family_members;
CREATE TRIGGER trigger_update_trial_on_family_delete
  AFTER DELETE ON customer_family_members FOR EACH ROW
  EXECUTE FUNCTION update_trial_plan_on_family_change();

-- ============================================================
-- TRIGGERS: admin sync
-- ============================================================

DROP TRIGGER IF EXISTS sync_admin_status_trigger ON profiles;
CREATE TRIGGER sync_admin_status_trigger
  AFTER INSERT OR UPDATE OF is_admin ON profiles FOR EACH ROW
  EXECUTE FUNCTION sync_profile_admin_status();

-- ============================================================
-- TRIGGERS: business location claimed
-- ============================================================

DROP TRIGGER IF EXISTS trigger_mark_business_location_claimed ON business_locations;
CREATE TRIGGER trigger_mark_business_location_claimed
  BEFORE INSERT OR UPDATE ON business_locations FOR EACH ROW
  EXECUTE FUNCTION mark_business_location_as_claimed();
