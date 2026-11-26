import type { BooleanLike } from 'tgui-core/react';

export type AccountRow = {
  ref: string;
  name: string;
  job: string | null;
  balance: number;
  max_fine: number;
  suspended: BooleanLike;
  debtor: BooleanLike;
  arrears: BooleanLike;
  poll_owed: number;
};

export type PayrollRow = {
  job: string;
  wage: number;
  floor: number;
  faction: string | null;
};

export type LoanRow = {
  text: string;
  defaulted: BooleanLike;
};

export type Data = {
  treasury: number;
  can_fiscal: BooleanLike;
  accounts: AccountRow[];
  debts: AccountRow[];
  payroll: PayrollRow[];
  employed: Record<string, number>;
  loans: LoanRow[];
};

export const employedFor = (data: Data, job: string) =>
  data.employed?.[job] || 0;

export const payrollTotal = (data: Data) =>
  data.payroll.reduce((sum, row) => sum + row.wage * employedFor(data, row.job), 0);

export type TabKey = 'accounts' | 'payroll' | 'debts';
