import type { BooleanLike } from 'tgui-core/react';

// --- Static catalog (ships once via ui_static_data) ------------------------

export type GoodCatalogEntry = {
  name: string;
  importable: BooleanLike;
  category: string;
};

export type RegionCatalogEntry = {
  name: string;
  description: string;
};

export type StaticData = {
  order_pool_cap: number;
  good_catalog: Record<string, GoodCatalogEntry>;
  region_catalog: Record<string, RegionCatalogEntry>;
};

// --- Dynamic state (re-shipped on each ui_data) ----------------------------

export type OrderItem = {
  good_id: string;
  needed: number;
  have: number;
};

export type Order = {
  ref: string;
  name: string;
  region_id: string;
  region_blockaded: BooleanLike;
  is_equipment: BooleanLike;
  days_left: number;
  payout: number;
  items: OrderItem[];
  can_fulfill: BooleanLike;
  shortfall_text: string;
};

export type EconomicEvent = {
  name: string;
  description: string;
  event_type: string; // ECON_EVENT_SHORTAGE | ECON_EVENT_OVERSUPPLY
  days_left: number;
  affected_goods: string[];
};

export type BanditryProjection = {
  total: number;
  lines: string[];
};

export type MarketRow = {
  good_id: string;
  stock: number;
  stock_limit: number;
  event_tag: string;
  import_region_id: string | null;
  import_unit_price: number | null;
  import_blockaded: BooleanLike;
  import_capacity_today: number;
  import_capacity_total: number;
  export_region_id: string | null;
  export_unit_price: number | null;
  export_blockaded: BooleanLike;
  export_capacity_today: number;
  export_capacity_total: number;
};

export type RegionFlow = {
  good_id: string;
  total: number;
  today: number;
};

export type RegionRow = {
  region_id: string;
  blockaded: BooleanLike;
  produces: RegionFlow[];
  demands: RegionFlow[];
};

export type AldermanWarrant = {
  trade_cap: number;
  trade_remaining: number;
  defense_cap: number;
  defense_remaining: number;
};

export type Data = StaticData & {
  treasury: number;
  day: number;
  blockaded_regions: string[];
  banditry_projection: BanditryProjection;
  active_events: EconomicEvent[];
  active_orders: Order[];
  market_rows: MarketRow[];
  region_rows: RegionRow[];
  is_alderman_acting: BooleanLike;
  alderman_warrant: AldermanWarrant | null;
};

export type TabKey = 'orders' | 'market' | 'regions';
