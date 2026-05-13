import type { BooleanLike } from 'tgui-core/react';

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
  price: number;
  ship_id: string;
  ship_name: string;
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
  market_conditions?: string[];
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
