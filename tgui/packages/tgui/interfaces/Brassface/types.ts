import type { BooleanLike } from 'tgui-core/react';

export type VendingPack = {
  ref: string;
  name: string;
  category: string;
  qty: number;
  price: number;
  price_base: number;
  price_tariff: number;
  contraband: BooleanLike;
};

export type WashingData = {
  recent_payments: number;
  secret_budget: number;
  cut_tier: number;
  tier_a_cost: number;
  tier_b_cost: number;
};

export type BrassfaceData = {
  motto: string;
  budget: number;
  locked: BooleanLike;
  is_public: BooleanLike;
  is_proprietor: BooleanLike;
  can_read: BooleanLike;
  can_see_contraband: BooleanLike;
  tariff_rate_pct: number;
  tariff_paid: number;
  tariff_evaded: number;
  church_tithe_paid: number;
  dodging: BooleanLike;
  ordinance_active: BooleanLike;
  tithe_rate_pct: number;
  categories: string[];
  current_category: string;
  search: string;
  search_mode: BooleanLike;
  result_cap: number;
  total_matches: number;
  packs: VendingPack[];
  is_washing: BooleanLike;
  washing: WashingData | null;
};

export type ActFn = (action: string, params?: Record<string, unknown>) => void;
