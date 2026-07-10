export interface SubscriptionPlan {
  id: string;
  name: string;
  price: number;
  billing_period: 'monthly' | 'yearly';
  max_persons: number;
}

export function getRequiredPlanForLocations(
  locationCount: number,
  billingPeriod: 'monthly' | 'yearly' = 'monthly'
): { minSeats: number; maxSeats: number | null } {
  if (locationCount === 1) return { minSeats: 1, maxSeats: 1 };
  if (locationCount === 2) return { minSeats: 2, maxSeats: 2 };
  if (locationCount === 3) return { minSeats: 3, maxSeats: 3 };
  if (locationCount === 4) return { minSeats: 4, maxSeats: 4 };
  if (locationCount === 5) return { minSeats: 5, maxSeats: 5 };
  if (locationCount >= 6 && locationCount <= 10) return { minSeats: 6, maxSeats: 10 };
  return { minSeats: 11, maxSeats: null };
}

export function getPlanDisplayName(locationCount: number, billingPeriod: 'monthly' | 'yearly'): string {
  const period = billingPeriod === 'monthly' ? 'Mensile' : 'Annuale';

  if (locationCount === 1) return `Piano Business ${period} - 1 Sede`;
  if (locationCount === 2) return `Piano Business ${period} - 2 Sedi`;
  if (locationCount === 3) return `Piano Business ${period} - 3 Sedi`;
  if (locationCount === 4) return `Piano Business ${period} - 4 Sedi`;
  if (locationCount === 5) return `Piano Business ${period} - 5 Sedi`;
  if (locationCount >= 6 && locationCount <= 10) return `Piano Business ${period} - 6-10 Sedi`;
  return `Piano Business ${period} - Oltre 10 Sedi`;
}

export function getPlanPrice(locationCount: number, billingPeriod: 'monthly' | 'yearly'): number {
  if (billingPeriod === 'monthly') {
    if (locationCount === 1) return 2.49;
    if (locationCount === 2) return 3.99;
    if (locationCount === 3) return 5.49;
    if (locationCount === 4) return 7.99;
    if (locationCount === 5) return 9.99;
    if (locationCount >= 6 && locationCount <= 10) return 12.99;
    return 14.99;
  } else {
    if (locationCount === 1) return 24.90;
    if (locationCount === 2) return 39.90;
    if (locationCount === 3) return 54.90;
    if (locationCount === 4) return 79.90;
    if (locationCount === 5) return 99.90;
    if (locationCount >= 6 && locationCount <= 10) return 129.90;
    return 149.90;
  }
}

export function getPlanSummary(locationCount: number, billingPeriod: 'monthly' | 'yearly'): {
  name: string;
  price: number;
  period: string;
  pricePerMonth: number;
} {
  const price = getPlanPrice(locationCount, billingPeriod);
  const name = getPlanDisplayName(locationCount, billingPeriod);
  const period = billingPeriod === 'monthly' ? 'mese' : 'anno';
  const pricePerMonth = billingPeriod === 'yearly' ? price / 12 : price;

  return {
    name,
    price,
    period,
    pricePerMonth,
  };
}
