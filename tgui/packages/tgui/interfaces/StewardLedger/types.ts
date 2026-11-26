import type { BooleanLike } from 'tgui-core/react';

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

export type Data = {
  treasury: number;
  ledger_page?: LedgerPage;
};
