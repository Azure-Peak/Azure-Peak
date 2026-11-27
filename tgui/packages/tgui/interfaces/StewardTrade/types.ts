import type { BooleanLike } from 'tgui-core/react';

// --- Static catalog (ships once via ui_static_data) ------------------------

export type GoodCatalogEntry = {
  name: string;
  category: string;
};

export type RegionSupplyRow = {
  type: string;
  size: string;
  goods: { good_id: string; share: number; volume: number }[];
};

export type RegionDemandRow = {
  type: string;
  size: string;
  goods: { good_id: string; share: number; volume: number }[];
};

export type RegionCatalogEntry = {
  name: string;
  description: string;
  subroute: string;
  tribute: string[];
  gifts: string[];
  supply: RegionSupplyRow[];
  demand: RegionDemandRow[];
};

export type CaravanSubroute = {
  id: string;
  name: string;
  region_ids: string[];
};

export type CaravanRoute = {
  id: string;
  name: string;
  subroutes: CaravanSubroute[];
};

export type StaticData = {
  order_extend_cost: number;
  caravan_routes: CaravanRoute[];
  quality_payouts: { label: string; pct: number }[];
  good_catalog: Record<string, GoodCatalogEntry>;
  region_catalog: Record<string, RegionCatalogEntry>;
  is_steward_role: BooleanLike;
  commission_catalog: Record<string, CommissionCatalogEntry>;
  commission_lead_minutes: number;
  rental_pay: number;
  rental_rate: number;
  market_day_base_rate: number;
  market_day_floor: number;
};

// --- Dynamic state (re-shipped on each ui_data) ----------------------------

export type OrderItem = {
  good_id: string;
  needed: number;
  have: number;
  route: 'warehouse' | 'stockpile';
  unit_pay: number;
};

export type Order = {
  ref: string;
  name: string;
  description: string;
  region_id: string;
  region_blockaded: BooleanLike;
  has_warehouse: BooleanLike;
  has_stockpile: BooleanLike;
  crafted: BooleanLike;
  days_left: number;
  payout: number;
  items: OrderItem[];
  petitioned: BooleanLike;
  extend_blocker: string;
  halved: BooleanLike;
};

export type ActiveOffer = {
  ref: string;
  region_id: string;
  good_id: string;
  units: number;
  unit_price: number;
  total_price: number;
  halved: BooleanLike;
};

export type TributeLine = {
  good_id: string;
  units: number;
};

export type CaravanEscort = {
  escorted: BooleanLike;
  fee: number;
  blocker: string;
};

export type RegionCaravanState = {
  blockaded: BooleanLike;
  tribute: TributeLine[];
  tribute_blocker: string;
  escorted: BooleanLike;
};

export type CommissionCatalogEntry = {
  name: string;
  desc: string;
  daily_stock: number;
  contents?: { name: string; count: number }[];
};

export type CommissionRow = {
  ref: string;
  stock: number;
  price: number;
  blocker: string;
};

export type CommissionOrder = {
  name: string;
  seconds_left: number;
};

export type CommissionState = {
  kits: CommissionRow[];
  local: CommissionRow[];
  orders: CommissionOrder[];
};

export type CaravanTrip = {
  route: string;
  request: string | null;
  offer: string | null;
  tribute: string | null;
  sell_offer: BooleanLike;
  sell_tribute: BooleanLike;
  return_seconds: number | null;
};

export type CaravanSell = {
  offer: BooleanLike;
  tribute: BooleanLike;
};

export type CaravanState = {
  fleet: number;
  home: number;
  rented: number;
  return_seconds: number;
  remembered_left: number;
  remembered_minutes: number;
  trips: CaravanTrip[];
};

export type RequestQuoteItem = {
  good_id: string;
  needed: number;
  route: 'warehouse' | 'stockpile';
  unit_pay: number;
  loaded: number;
  have: number;
  market_closed: BooleanLike;
  market_left: number;
  fill_units: number;
  fill_cost: number;
  ask_first: number;
  ask_last: number;
};

export type RequestQuote = {
  ref: string;
  load_units: number;
  load_payout: number;
  items: RequestQuoteItem[];
};

export type OfferQuote = {
  ref: string;
  market_closed: BooleanLike;
  sale_total: number;
  bid_first: number;
  bid_last: number;
};

export type TributeQuote = {
  region_id: string;
  sale_total: number;
};

export type CaravanQuote = {
  request: RequestQuote | null;
  offer: OfferQuote | null;
  tribute: TributeQuote | null;
};

export type MarketRow = {
  good_id: string;
  stock: number;
  market_stock: number;
  market_target: number;
  market_label: string;
  market_buy: number;
  market_sell: number;
  never_supplied: BooleanLike;
  market_left: number;
  sold_out: BooleanLike;
  event_tag: string;
  dawn_change: number;
  raided_supply: number;
  raided_demand: number;
  raided_suppliers: string[];
  raided_demanders: string[];
};

export type MarketDaeState = {
  rate: number;
  rented: number;
  returnable: number;
  rent_blocker: string;
  next_seconds: number;
  midday_rate: number;
};

export type PetitionTemplate = {
  id: string;
  label: string;
  region_ids: string[];
};

export type PetitionCategory = {
  id: string;
  label: string;
  description: string;
  cost: number;
  templates: PetitionTemplate[];
};

export type PetitionTarget = {
  region_id: string;
  raided: BooleanLike;
  replaces: string;
};

export type PetitionState = {
  pledge_balance: number;
  petitions_remaining: number;
  selected_template: string | null;
  blocker: string;
  targets: PetitionTarget[];
};

export type SequestrationState = {
  active: BooleanLike;
  in_arrears: BooleanLike;
  debt: number;
  state_label: string;
};

export type Data = StaticData & {
  treasury: number;
  day: number;
  active_orders: Order[];
  active_offers: ActiveOffer[];
  region_caravan: Record<string, RegionCaravanState>;
  caravan_escorts: Record<string, CaravanEscort>;
  commissions: CommissionState;
  caravans: CaravanState;
  caravan_quote: CaravanQuote;
  caravan_sell: CaravanSell;
  market_dae: MarketDaeState;
  market_rows: MarketRow[];
  petition_categories: PetitionCategory[];
  petition_tax_pct: number;
  petitions_per_day: number;
  petition: PetitionState;
  sequestration: SequestrationState;
};

export type TabKey =
  | 'caravans'
  | 'commissions'
  | 'market'
  | 'regions'
  | 'petition';
