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

export type StaticData = {
  order_pool_cap: number;
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
  // base_payout * (1 + scarcity_bonus_pct/100) == payout. Bonus is 0 at/above reference pop.
  base_payout: number;
  scarcity_bonus_pct: number;
  items: OrderItem[];
  can_fulfill: BooleanLike;
  shortfall_text: string;
  petitioned: BooleanLike;
  can_partial: BooleanLike;
  partial_pct: number;
  partial_payout_pct: number;
  partial_payout_preview: number;
  pair_id: string | null;
  pair_label: string | null;
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

export type BanditryProjection = {
  total: number;
  lines: string[];
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
  blockaded_regions: string[];
  banditry_projection: BanditryProjection;
  active_events: EconomicEvent[];
  active_orders: Order[];
  market_rows: MarketRow[];
  region_rows: RegionRow[];
  petition_categories: PetitionCategory[];
  petition_tax_pct: number;
  petitions_per_day: number;
  petition: PetitionState;
  sequestration: SequestrationState;
  atc_loan: AtcLoanState;
};

export type TabKey = 'orders' | 'market' | 'regions' | 'petition' | 'ledger';
