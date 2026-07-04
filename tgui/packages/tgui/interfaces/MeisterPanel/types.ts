import { type RoutedActFunctionType } from '../../backend';

export type FundEntry = {
  id: string;
  label: string;
  name: string;
  can_issue: boolean;
  can_withdraw: boolean;
  can_view: boolean;
  supports_loans: boolean;
  allow_zero_rate: boolean;
  authority_label: string;
  withdraw_rule: string;
  has_patronage: boolean;
  patron_label: string;
  patron_cap: number;
};

export type ActiveLoan = {
  principal: number;
  interest_pct: number;
  days_total: number;
  due_on_day: number;
  days_until_due: number;
  remaining: number;
  defaulted: boolean;
  creditor: string;
};

export type PollTax = {
  rate: number;
  exempt: boolean;
  advance_days_held: number;
};

export type FundBalance = {
  balance: number;
  outstanding_principal: number;
};

export type LedgerLoan = {
  creditor_id: string;
  creditor_label: string;
  debtor: string;
  is_institutional: boolean;
  target_label: string;
  principal: number;
  interest_pct: number;
  due_on_day: number;
  days_until_due: number;
  remaining: number;
  defaulted: boolean;
};

export type Patron = {
  ref: string;
  name: string;
  job: string;
};

export type PatronRosterStatic = {
  label: string;
  cap: number;
  can_manage: boolean;
  explanation: string;
};

export type PatronRoster = {
  patrons: Patron[];
};

export type PollTaxStatic = {
  max_advance_days: number;
  fallback_rate: number;
};

export type PollTaxUser = {
  category: string;
  category_label: string;
};

export type LogEntry = {
  kind: string;
  direction: 'in' | 'out' | 'neutral';
  counterparty: string;
  amount: number;
  reason: string;
};

export type Data = {
  funds: FundEntry[];
  account_balance: number;
  day: number;
  max_issuance_day: number;
  active_loan: ActiveLoan | null;
  poll_tax: PollTax;
  poll_tax_static: PollTaxStatic;
  poll_tax_user: PollTaxUser;
  fund_balances: Record<string, FundBalance>;
  institutional_loans: LedgerLoan[];
  institutional_logs: Record<string, LogEntry[]>;
  patron_rosters: Record<string, PatronRoster>;
  patron_rosters_static: Record<string, PatronRosterStatic>;
  personal_log: LogEntry[];
  bathhouse_ordinance_active: boolean;
  bathhouse_tithe_round_total: number;
  bathhouse_ordinance_cooldown_seconds: number;
};

export type TabKey =
  | 'personal'
  | 'institutional'
  | 'patronage'
  | 'polltax'
  | 'ledger';

export type TabProps = {
  data: Data;
  act: RoutedActFunctionType;
};
