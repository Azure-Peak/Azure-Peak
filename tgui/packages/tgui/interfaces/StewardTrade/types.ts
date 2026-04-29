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
  description: string;
  region_id: string;
  region_blockaded: BooleanLike;
  is_equipment: BooleanLike;
  days_left: number;
  payout: number;
  items: OrderItem[];
  can_fulfill: BooleanLike;
  shortfall_text: string;
  petitioned: BooleanLike;
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
  debt: number;
};

export type MarketRegionOption = {
  region_id: string;
  unit_price: number;
  capacity_today: number;
  capacity_total: number;
  is_blockaded: BooleanLike;
};

export type MarketRow = {
  good_id: string;
  stock: number;
  stock_limit: number;
  event_tag: string;
  // Sorted: import_regions ascending by unit_price (best buy first),
  // export_regions descending (best sell first). Entry [0] is the auto-routed default.
  import_regions: MarketRegionOption[];
  export_regions: MarketRegionOption[];
  buy_price: number;
  sell_price: number;
  market_buy_price: number;
  market_sell_price: number;
  automatic_price: BooleanLike;
  automatic_limit: BooleanLike;
  accepting: BooleanLike;
  withdraw_disabled: BooleanLike;
  margin_per_unit: number;
  arbitrage_potential: number;
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

export type AutoImportRow = {
  good_id: string;
  active: BooleanLike;
  stock: number;
};

export type AutoImportHistoryEntry = {
  day: number;
  spent: number;
  lines: string[];
};

export type AutoImportData = {
  today_spent: number;
  purse_floor: number;
  floor_target: number;
  batch_size: number;
  max_price_mult: number;
  essentials: AutoImportRow[];
  others: AutoImportRow[];
  history: AutoImportHistoryEntry[];
};

export type TradeQuote = {
  ok: BooleanLike;
  reason: string;
  side: 'import' | 'export';
  region_id: string;
  good_id: string;
  region_name: string;
  good_name: string;
  quantity: number;
  max_units: number;
  daily_pace: number;
  capacity_today: number;
  base_unit_price: number;
  base_subtotal: number;
  escalation_subtotal: number;
  total: number;
  balance: number;
  balance_after: number;
  is_blockaded: BooleanLike;
  is_alderman_acting: BooleanLike;
  warrant_remaining: number;
  warrant_ok: BooleanLike;
  can_afford: BooleanLike;
};

export type PetitionCategory = {
  id: string;
  label: string;
  description: string;
  cost: number;
};

export type PetitionState = {
  pledge_balance: number;
  petitions_remaining: number;
  is_steward_role: BooleanLike;
  is_alderman_acting: BooleanLike;
  // category_id -> region_id -> blocker reason (empty string = eligible)
  eligibility: Record<string, Record<string, string>>;
};

export type SequestrationState = {
  active: BooleanLike;
  in_arrears: BooleanLike;
  debt: number;
  state_label: string;
};

export type AtcLoanState = {
  available: BooleanLike;
  can_view: BooleanLike;
  min: number;
  max: number;
  closed_day: number;
  interest_pct: number;
  blocker: string;
  arrears_consumed: BooleanLike;
  loans_drawn: number;
  outstanding: number;
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
  auto_import: AutoImportData;
  trade_quote: TradeQuote | null;
  total_arbitrage_potential: number;
  autoexport_percentage: number;
  petition_categories: PetitionCategory[];
  petition_tax_pct: number;
  petitions_per_day: number;
  petition: PetitionState;
  sequestration: SequestrationState;
  atc_loan: AtcLoanState;
};

export type TabKey =
  | 'orders'
  | 'market'
  | 'regions'
  | 'auto_import'
  | 'petition';
