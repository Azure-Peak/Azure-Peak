import type { BooleanLike } from 'tgui-core/react';

import type { MarketData } from '../Noticeboard/types';

export type BulkLine = {
  good: string;
  good_name: string;
  qty_target: number;
  qty_fulfilled: number;
  offered_price: number;
};

export type HarborShip = {
  ship_id: string;
  ship_name: string;
  captain_name: string | null;
  port_of_origin?: string;
  realm_id: string;
  ship_type: string;
  tonnage: number;
  tonnage_mult: number;
  expected_favor: number;
  favor_earned: number;
  seconds_until_departure?: number;
  can_send_away?: BooleanLike;
  bulk_demands?: BulkLine[];
  bulk_supplies?: BulkLine[];
};

export type CulturalStockEntry = {
  pack: string;
  name: string;
  qty: number;
  pack_qty: number;
  base_cost: number;
  price_base: number;
  price_tariff: number;
  price: number;
  ship_id: string;
  ship_name: string;
};

export type MarketCondition = {
  name: string;
  description: string;
  tone?: 'good' | 'bad' | 'neutral';
};

export type HarborRealm = {
  id: string;
  name: string;
  discovered: BooleanLike;
  cultural_goods: string[];
  basic_buys: string[];
  rare_buys: string[];
  basic_sells: string[];
  rare_sells: string[];
  demanded_categories: string[];
  market_conditions?: MarketCondition[];
};

export type HarborData = {
  ships_docked: HarborShip[];
  ships_pool: HarborShip[];
  realms: HarborRealm[];
  hails_remaining: number;
  hails_per_day: number;
  dock_spots_used: number;
  dock_spots_max: number;
  cultural_stock: CulturalStockEntry[];
  merchant_levy_percent: number;
  merchant_levy_cap: number;
  merchant_levy_collected: number;
  merchant_levy_taxed: number;
  favor: FavorData;
  ledger: LedgerData;
  market_data: MarketData;
};

export type FundLogEntry = {
  source: string;
  amount: number;
};

export type LedgerData = {
  merchant_fund_balance: number;
  levy_collected: number;
  levy_taxed: number;
  gnome_margin_collected: number;
  silverface_margin_percent: number;
  fund_log: FundLogEntry[];
};

export type FavorLedgerEntry = {
  realm_label: string;
  ship_name: string;
  outcome: 'honored' | 'partial' | 'dishonored';
  earned: number;
  expected: number;
  awarded: number;
  refunded_hail: BooleanLike;
};

export type FavorData = {
  current: number;
  high_water: number;
  triumph_bonus: number;
  triumph_cap: number;
  bracket_floor: number;
  bracket_next: number;
  ledger: FavorLedgerEntry[];
  gnome_cost: number;
  gnome_unlocked: BooleanLike;
  pier_cost: number;
  pier_rented: BooleanLike;
  brackets: number[];
  from_sendoffs: number;
  from_navigator: number;
  from_goldface: number;
  from_silverface: number;
  penalties: number;
};

export type VendingPack = {
  ref: string;
  name: string;
  category: string;
  qty: number;
  price: number;
  price_base: number;
  price_tariff: number;
};

export type VendingData = {
  motto: string;
  budget: number;
  locked: BooleanLike;
  is_public: BooleanLike;
  is_proprietor: BooleanLike;
  can_read: BooleanLike;
  tariff_rate_pct: number;
  tariff_paid: number;
  tariff_evaded: number;
  dodging: BooleanLike;
  public_margin_pct?: number;
  public_margin_label?: string;
  categories: string[];
  current_category: string;
  search: string;
  search_mode: BooleanLike;
  result_cap: number;
  total_matches: number;
  packs: VendingPack[];
  is_command_center: BooleanLike;
  harbor?: HarborData;
};

export type ActFn = (action: string, params?: Record<string, unknown>) => void;
