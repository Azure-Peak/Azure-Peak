import type { BooleanLike } from 'tgui-core/react';

// --- Static catalog (ships once via ui_static_data) ------------------------

export type GoodCatalogEntry = {
  name: string;
  category: string;
};

export type RegionCatalogEntry = {
  name: string;
  description: string;
};

export type LedgerLeg = {
  account: string;
  dr: number;
  cr: number;
};

export type LedgerEntry = {
  kind: string; // mint | burn | transfer | micro | accrual | writeoff | ...
  from: string;
  to: string;
  amount: number;
  reason: string;
  count: number;
  // Present on double-entry postings only; memo lines have no number or legs.
  no?: number;
  day?: number;
  actor?: string | null;
  legs?: LedgerLeg[];
};

export type LedgerView =
  | 'journal'
  | 'ledger'
  | 'trial'
  | 'income'
  | 'balance'
  | 'subsidiary';

export type ChartRow = {
  id: string;
  name: string;
  class: string;
  balance: number;
  active: BooleanLike;
};

export type AccountLedgerRow = {
  no: number;
  day: number;
  reason: string;
  dr: number;
  cr: number;
  balance: number;
  count: number;
};

export type AccountLedger = {
  id: string;
  name: string;
  class: string;
  book_label: string;
  debit_normal: BooleanLike;
  debits: number;
  credits: number;
  balance: number;
  rows: AccountLedgerRow[];
  total_rows: number;
};

export type TrialBalance = {
  book_label: string;
  rows: { id: string; name: string; class: string; dr: number; cr: number }[];
  total_dr: number;
  total_cr: number;
  balanced: BooleanLike;
};

export type ReconRow = {
  label: string;
  ledger: number;
  actual: number;
  drift: number;
};

export type IncomeLine = {
  id: string;
  name: string;
  total: number;
  today: number;
  yesterday: number;
};

export type IncomeStatement = {
  book_label: string;
  revenue: IncomeLine[];
  expenses: IncomeLine[];
  revenue_total: number;
  expense_total: number;
  net_total: number;
  revenue_today: number;
  expense_today: number;
  net_today: number;
  revenue_yesterday: number;
  expense_yesterday: number;
  net_yesterday: number;
  closed_day: number;
};

export type BalanceLine = { id: string; name: string; balance: number };

export type BalanceSheet = {
  book_label: string;
  assets: BalanceLine[];
  liabilities: BalanceLine[];
  equity: BalanceLine[];
  surplus: number;
  unclassified: number;
  total_assets: number;
  total_liabilities: number;
  total_equity: number;
  total_equity_side: number;
  balanced: BooleanLike;
};

export type Subsidiary = {
  loans: {
    debtor: string;
    lender: string;
    principal: number;
    rate_pct: number;
    due_day: number;
    repaid: number;
    principal_outstanding: number;
    remaining_due: number;
    defaulted: BooleanLike;
  }[];
  poll_arrears: { name: string; job: string; owed: number }[];
  payables: { name: string; balance: number }[];
  receivables: { name: string; balance: number }[];
  inventory: { name: string; units: number; unit_price: number; value: number }[];
  inventory_live: number;
  inventory_booked: number;
  payroll: {
    job: string;
    wage: number;
    heads: number;
    suspended: number;
    daily_cost: number;
  }[];
  payroll_total: number;
  taxes: {
    name: string;
    rate_pct: number | null;
    collected: number;
    exempted: number;
  }[];
};

export type LedgerPage = {
  view: LedgerView;
  // Journal view
  entries?: LedgerEntry[];
  page?: number;
  page_size?: number;
  shown?: number;
  has_more?: BooleanLike;
  filtered?: BooleanLike;
  // General ledger view
  chart?: ChartRow[];
  account_ledger?: AccountLedger | null;
  // Reports
  trial_balance?: TrialBalance;
  reconciliation?: ReconRow[];
  income_statement?: IncomeStatement;
  balance_sheet?: BalanceSheet;
  subsidiary?: Subsidiary;
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
  // Only present while the user has the Ledger tab open (server gates it on ledger_view).
  ledger_page?: LedgerPage;
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

export type CommissionKit = {
  ref: string;
  name: string;
  desc: string;
  stock: number;
  daily_stock: number;
  price: number;
  blocker: string;
  contents: { name: string; count: number }[];
};

export type CommissionOrder = {
  name: string;
  minutes_left: number;
};

export type CommissionState = {
  kits: CommissionKit[];
  orders: CommissionOrder[];
  lead_minutes: number;
};

export type CaravanTrip = {
  route: string;
  request: string | null;
  offer: string | null;
  tribute: string | null;
};

export type CaravanState = {
  fleet: number;
  home: number;
  return_minutes: number;
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

export type EconomicEvent = {
  name: string;
  description: string;
  event_type: string; // ECON_EVENT_SHORTAGE | ECON_EVENT_OVERSUPPLY
  days_left: number;
  affected_goods: string[];
  saturation_target: number;
  saturation_progress: number;
};

export type BanditryRow = {
  region: string;
  level: string;
  cost: number;
  detail: string;
};

export type BanditryProjection = {
  total: number;
  rows: BanditryRow[];
  debt: number;
  hoard_total: number;
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
};

export type RegionFlow = {
  good_id: string;
};

export type RegionRow = {
  region_id: string;
  blockaded: BooleanLike;
  produces: RegionFlow[];
  demands: RegionFlow[];
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

export type PetitionOffer = {
  region_id: string;
  blocker: string;
};

export type PetitionState = {
  pledge_balance: number;
  petitions_remaining: number;
  is_steward_role: BooleanLike;
  selected_template: string | null;
  offers: PetitionOffer[];
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
  expected_rural_revenue: number;
  expected_wage_outlay: number;
  banditry_projection: BanditryProjection;
  active_events: EconomicEvent[];
  active_orders: Order[];
  active_offers: ActiveOffer[];
  region_caravan: Record<string, RegionCaravanState>;
  caravan_escorts: Record<string, CaravanEscort>;
  commissions: CommissionState;
  caravans: CaravanState;
  caravan_quote: CaravanQuote;
  market_rows: MarketRow[];
  region_rows: RegionRow[];
  petition_categories: PetitionCategory[];
  petition_tax_pct: number;
  petitions_per_day: number;
  petition: PetitionState;
  sequestration: SequestrationState;
  atc_loan: AtcLoanState;
};

export type TabKey =
  | 'caravans'
  | 'commissions'
  | 'dispatches'
  | 'market'
  | 'regions'
  | 'petition'
  | 'ledger';
