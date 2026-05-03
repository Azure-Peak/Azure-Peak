import { type RoutedActFunctionType } from '../../backend';

export type FundEntry = {
  id: string;
  label: string;
  name: string;
  can_issue: boolean;
  can_withdraw: boolean;
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
  category: string;
  category_label: string;
  rate: number;
  exempt: boolean;
  advance_days_held: number;
  max_advance_days: number;
  fallback_rate: number;
};

export type FundBalance = {
  balance: number;
  has_access: boolean;
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

export type PatronRoster = {
  label: string;
  cap: number;
  can_manage: boolean;
  patrons: Patron[];
};

export type Data = {
  funds: FundEntry[];
  account_balance: number;
  day: number;
  max_issuance_day: number;
  active_loan: ActiveLoan | null;
  poll_tax: PollTax;
  fund_balances: Record<string, FundBalance>;
  institutional_loans: LedgerLoan[];
  patron_rosters: Record<string, PatronRoster>;
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
