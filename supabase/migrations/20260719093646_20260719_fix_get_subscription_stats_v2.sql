
/*
# Fix get_subscription_stats: drop and recreate with correct return type

## Fix
Drop e ricrea con return type json, nomi campo camelCase, join su customer_id
*/

DROP FUNCTION IF EXISTS public.get_subscription_stats();

CREATE OR REPLACE FUNCTION public.get_subscription_stats()
RETURNS json LANGUAGE plpgsql STABLE SECURITY DEFINER SET search_path TO 'public' AS $$
DECLARE
  v_total_active bigint := 0;
  v_trial_users  bigint := 0;
  v_cust_monthly bigint := 0;
  v_cust_yearly  bigint := 0;
  v_biz_monthly  bigint := 0;
  v_biz_yearly   bigint := 0;
BEGIN
  SELECT
    COUNT(*) FILTER (WHERE s.status = 'active'),
    COUNT(*) FILTER (WHERE s.status = 'trial'),
    COUNT(*) FILTER (WHERE s.status = 'active' AND p.user_type = 'customer' AND sp.billing_period IN ('monthly','month')),
    COUNT(*) FILTER (WHERE s.status = 'active' AND p.user_type = 'customer' AND sp.billing_period IN ('yearly','annual','year')),
    COUNT(*) FILTER (WHERE s.status = 'active' AND p.user_type = 'business' AND sp.billing_period IN ('monthly','month')),
    COUNT(*) FILTER (WHERE s.status = 'active' AND p.user_type = 'business' AND sp.billing_period IN ('yearly','annual','year'))
  INTO v_total_active, v_trial_users, v_cust_monthly, v_cust_yearly, v_biz_monthly, v_biz_yearly
  FROM subscriptions s
  LEFT JOIN profiles p ON p.id = s.customer_id
  LEFT JOIN subscription_plans sp ON sp.id = s.plan_id;

  RETURN json_build_object(
    'totalActive',     COALESCE(v_total_active, 0),
    'trialUsers',      COALESCE(v_trial_users, 0),
    'customerMonthly', COALESCE(v_cust_monthly, 0),
    'customerYearly',  COALESCE(v_cust_yearly, 0),
    'businessMonthly', COALESCE(v_biz_monthly, 0),
    'businessYearly',  COALESCE(v_biz_yearly, 0)
  );
END;
$$;
