import type { CSSProperties, ReactNode } from 'react';

import { useBackend } from '../../backend';
import {
  denseRowStyle,
  ellipsisCellStyle,
  INK,
  INK_FAINT,
  INK_SOFT,
  SEAL_GREEN,
  SEAL_RED,
  sectionHeaderStyle,
  subTabStyle,
} from '../common/parchment';
import type {
  AccountLedger,
  BalanceLine,
  BalanceSheet,
  ChartRow,
  Data,
  IncomeLine,
  IncomeStatement,
  ReconRow,
  Subsidiary,
  TrialBalance,
} from './types';

const num = (n: number | null | undefined): string =>
  n === null || n === undefined ? '' : `${Math.round(n * 100) / 100}`;
const money = (n: number): string => `${num(n)}m`;
const blankZero = (n: number): string => (n ? num(n) : '');

const numCell = (
  width: string,
  bold = false,
  color?: string,
): CSSProperties => ({
  flexShrink: 0,
  width,
  textAlign: 'right',
  fontWeight: bold ? 'bold' : 'normal',
  color: color || INK,
  whiteSpace: 'nowrap',
});

const TableRow = (props: {
  cells: ReactNode[];
  widths: (string | null)[];
  bold?: boolean;
  color?: string;
  header?: boolean;
}) => {
  const { cells, widths, bold, color, header } = props;
  return (
    <div
      style={{
        ...denseRowStyle,
        fontWeight: bold || header ? 'bold' : 'normal',
        color: header ? INK_SOFT : color || INK,
        borderBottom: header
          ? `1px solid ${INK_FAINT}`
          : denseRowStyle.borderBottom,
      }}
    >
      {cells.map((cell, i) =>
        widths[i] === null ? (
          <div key={i} style={ellipsisCellStyle}>
            {cell}
          </div>
        ) : (
          <div key={i} style={numCell(widths[i] as string)}>
            {cell}
          </div>
        ),
      )}
    </div>
  );
};

const Empty = (props: { children: ReactNode }) => (
  <div style={{ color: INK_SOFT, fontStyle: 'italic', padding: '8px 0' }}>
    {props.children}
  </div>
);

// --- General Ledger (T-account drill-down) ---------------------------------

export const GeneralLedgerPanel = (props: {
  chart?: ChartRow[];
  account?: AccountLedger | null;
}) => {
  const { act } = useBackend<Data>();
  const { chart = [], account } = props;
  const active = chart.filter((c) => c.active);
  return (
    <div>
      <div style={sectionHeaderStyle}>General Ledger</div>
      <div style={{ display: 'flex', flexWrap: 'wrap', gap: '4px' }}>
        {active.map((c) => (
          <button
            key={c.id}
            type="button"
            style={subTabStyle(account?.id === c.id)}
            onClick={() => act('ledger_account', { id: c.id })}
          >
            {c.name} ({num(c.balance)})
          </button>
        ))}
      </div>
      {!account ? (
        <Empty>Choose an account.</Empty>
      ) : (
        <div style={{ marginTop: '8px' }}>
          <div style={{ fontWeight: 'bold', color: INK }}>
            {account.name}{' '}
            <span style={{ color: INK_SOFT, fontWeight: 'normal' }}>
              ({account.class}, normal{' '}
              {account.debit_normal ? 'debit' : 'credit'})
            </span>
          </div>
          <div style={{ color: INK_SOFT, marginBottom: '6px' }}>
            Debits {money(account.debits)} &middot; Credits{' '}
            {money(account.credits)} &middot; Balance {money(account.balance)}
          </div>
          <TableRow
            header
            widths={['44px', '40px', null, '64px', '64px', '72px']}
            cells={['No.', 'Day', 'Narration', 'Dr', 'Cr', 'Balance']}
          />
          <div style={{ maxHeight: '440px', overflowY: 'auto' }}>
            {account.rows.length === 0 && <Empty>No postings yet.</Empty>}
            {account.rows.map((r, i) => (
              <TableRow
                key={i}
                widths={['44px', '40px', null, '64px', '64px', '72px']}
                cells={[
                  r.no,
                  r.day,
                  `${r.reason}${r.count > 1 ? ` (x${r.count})` : ''}`,
                  blankZero(r.dr),
                  blankZero(r.cr),
                  num(r.balance),
                ]}
              />
            ))}
          </div>
          {account.total_rows > account.rows.length && (
            <div style={{ color: INK_FAINT, marginTop: '4px' }}>
              Showing the latest {account.rows.length} of {account.total_rows}{' '}
              postings.
            </div>
          )}
        </div>
      )}
    </div>
  );
};

// --- Trial balance + reconciliation ---------------------------------------

export const TrialBalancePanel = (props: {
  trial?: TrialBalance;
  recon?: ReconRow[];
}) => {
  const { trial, recon = [] } = props;
  if (!trial) return <Empty>Opening the books...</Empty>;
  return (
    <div>
      <div style={sectionHeaderStyle}>
        Trial Balance &mdash; {trial.book_label}{' '}
        <span style={{ color: trial.balanced ? SEAL_GREEN : SEAL_RED }}>
          {trial.balanced ? '(balanced)' : '(OUT OF BALANCE)'}
        </span>
      </div>
      <TableRow
        header
        widths={[null, '90px', '80px', '80px']}
        cells={['Account', 'Class', 'Debit', 'Credit']}
      />
      {trial.rows.map((r) => (
        <TableRow
          key={r.id}
          widths={[null, '90px', '80px', '80px']}
          cells={[r.name, r.class, blankZero(r.dr), blankZero(r.cr)]}
        />
      ))}
      <TableRow
        bold
        widths={[null, '90px', '80px', '80px']}
        cells={['Total', '', num(trial.total_dr), num(trial.total_cr)]}
      />

      <div style={sectionHeaderStyle}>Reconciliation</div>
      <div style={{ color: INK_SOFT, marginBottom: '4px' }}>
        Book balancing vs. actual numbers. Drift indicates a bookkeeping error
        (i.e. vanished accounts).
      </div>
      <TableRow
        header
        widths={[null, '80px', '80px', '70px']}
        cells={['Check', 'Books', 'Actual', 'Drift']}
      />
      {recon.map((r, i) => (
        <TableRow
          key={i}
          widths={[null, '80px', '80px', '70px']}
          color={Math.abs(r.drift) >= 0.5 ? SEAL_RED : INK}
          cells={[r.label, num(r.ledger), num(r.actual), num(r.drift)]}
        />
      ))}
    </div>
  );
};

// --- Income statement ------------------------------------------------------

const IncomeSection = (props: { title: string; lines: IncomeLine[] }) => (
  <>
    <div style={{ fontWeight: 'bold', color: INK_SOFT, marginTop: '6px' }}>
      {props.title}
    </div>
    {props.lines.length === 0 && <Empty>Nothing recorded.</Empty>}
    {props.lines.map((l) => (
      <TableRow
        key={l.id}
        widths={[null, '70px', '70px', '80px']}
        cells={[l.name, num(l.today), num(l.yesterday), num(l.total)]}
      />
    ))}
  </>
);

export const IncomeStatementPanel = (props: { stmt?: IncomeStatement }) => {
  const { stmt } = props;
  if (!stmt) return <Empty>Opening the books...</Empty>;
  const widths = [null, '70px', '70px', '80px'];
  return (
    <div>
      <div style={sectionHeaderStyle}>
        Income Statement &mdash; {stmt.book_label}
      </div>
      <TableRow
        header
        widths={widths}
        cells={['', 'Open day', 'Last day', 'To date']}
      />
      <IncomeSection title="Revenue" lines={stmt.revenue} />
      <TableRow
        bold
        widths={widths}
        cells={[
          'Total revenue',
          num(stmt.revenue_today),
          num(stmt.revenue_yesterday),
          num(stmt.revenue_total),
        ]}
      />
      <IncomeSection title="Expenses" lines={stmt.expenses} />
      <TableRow
        bold
        widths={widths}
        cells={[
          'Total expenses',
          num(stmt.expense_today),
          num(stmt.expense_yesterday),
          num(stmt.expense_total),
        ]}
      />
      <TableRow
        bold
        color={stmt.net_total >= 0 ? SEAL_GREEN : SEAL_RED}
        widths={widths}
        cells={[
          stmt.net_total >= 0 ? 'Net surplus' : 'Net deficit',
          num(stmt.net_today),
          num(stmt.net_yesterday),
          num(stmt.net_total),
        ]}
      />
      <div style={{ color: INK_FAINT, marginTop: '6px' }}>
        &ldquo;Open day&rdquo; is everything since the last close
        {stmt.closed_day >= 0 ? ` (day ${stmt.closed_day})` : ''}.
      </div>
    </div>
  );
};

// --- Balance sheet ---------------------------------------------------------

const BalanceSection = (props: { title: string; lines: BalanceLine[] }) => (
  <>
    <div style={{ fontWeight: 'bold', color: INK_SOFT, marginTop: '6px' }}>
      {props.title}
    </div>
    {props.lines.length === 0 && <Empty>None.</Empty>}
    {props.lines.map((l) => (
      <TableRow
        key={l.id}
        widths={[null, '90px']}
        cells={[l.name, num(l.balance)]}
      />
    ))}
  </>
);

export const BalanceSheetPanel = (props: { sheet?: BalanceSheet }) => {
  const { sheet } = props;
  if (!sheet) return <Empty>Opening the books...</Empty>;
  return (
    <div>
      <div style={sectionHeaderStyle}>
        Balance Sheet &mdash; {sheet.book_label}{' '}
        <span style={{ color: sheet.balanced ? SEAL_GREEN : SEAL_RED }}>
          {sheet.balanced ? '(balanced)' : '(OUT OF BALANCE)'}
        </span>
      </div>
      <BalanceSection title="Assets" lines={sheet.assets} />
      <TableRow
        bold
        widths={[null, '90px']}
        cells={['Total assets', num(sheet.total_assets)]}
      />
      <BalanceSection title="Liabilities" lines={sheet.liabilities} />
      <TableRow
        bold
        widths={[null, '90px']}
        cells={['Total liabilities', num(sheet.total_liabilities)]}
      />
      <BalanceSection title="Equity" lines={sheet.equity} />
      <TableRow
        widths={[null, '90px']}
        cells={['Surplus to date (revenue less expenses)', num(sheet.surplus)]}
      />
      {!!sheet.unclassified && (
        <TableRow
          widths={[null, '90px']}
          cells={['Unclassified (net)', num(sheet.unclassified)]}
        />
      )}
      <TableRow
        bold
        widths={[null, '90px']}
        cells={['Total liabilities and equity', num(sheet.total_equity_side)]}
      />
    </div>
  );
};

// --- Subsidiary ledgers ----------------------------------------------------

export const SubsidiaryPanel = (props: { sub?: Subsidiary }) => {
  const { sub } = props;
  if (!sub) return <Empty>Opening the books...</Empty>;
  return (
    <div>
      <div style={sectionHeaderStyle}>Loans Receivable</div>
      <TableRow
        header
        widths={[null, null, '56px', '48px', '56px', '60px', '70px']}
        cells={[
          'Debtor',
          'Lender',
          'Principal',
          'Rate',
          'Due day',
          'Repaid',
          'Owed',
        ]}
      />
      {sub.loans.length === 0 && <Empty>No loans outstanding.</Empty>}
      {sub.loans.map((l, i) => (
        <TableRow
          key={i}
          color={l.defaulted ? SEAL_RED : INK}
          widths={[null, null, '56px', '48px', '56px', '60px', '70px']}
          cells={[
            `${l.debtor}${l.defaulted ? ' (defaulted)' : ''}`,
            l.lender,
            num(l.principal),
            `${l.rate_pct}%`,
            l.due_day,
            num(l.repaid),
            num(l.remaining_due),
          ]}
        />
      ))}

      <div style={sectionHeaderStyle}>Poll Tax Receivable</div>
      <TableRow
        header
        widths={[null, null, '70px', '70px']}
        cells={['Subject', 'Station', 'Owed', 'Days late']}
      />
      {sub.poll_arrears.length === 0 && <Empty>No arrears.</Empty>}
      {sub.poll_arrears.map((a, i) => (
        <TableRow
          key={i}
          widths={[null, null, '70px', '70px']}
          cells={[a.name, a.job, num(a.owed), a.days]}
        />
      ))}

      <div style={sectionHeaderStyle}>Receivables</div>
      {sub.receivables.map((r, i) => (
        <TableRow
          key={i}
          widths={[null, '90px']}
          cells={[r.name, num(r.balance)]}
        />
      ))}

      <div style={sectionHeaderStyle}>Payables</div>
      {sub.payables.map((p, i) => (
        <TableRow
          key={i}
          widths={[null, '90px']}
          cells={[p.name, num(p.balance)]}
        />
      ))}

      <div style={sectionHeaderStyle}>Stockpile Inventory</div>
      <TableRow
        header
        widths={[null, '64px', '64px', '80px']}
        cells={['Goods', 'Units', 'Price', 'Value']}
      />
      {sub.inventory.length === 0 && <Empty>The stockpile is empty.</Empty>}
      {sub.inventory.map((g, i) => (
        <TableRow
          key={i}
          widths={[null, '64px', '64px', '80px']}
          cells={[g.name, g.units, num(g.unit_price), num(g.value)]}
        />
      ))}
      <TableRow
        bold
        widths={[null, '90px', '90px']}
        cells={[
          'On hand / on the books',
          money(sub.inventory_live),
          money(sub.inventory_booked),
        ]}
      />

      <div style={sectionHeaderStyle}>Payroll Register</div>
      <TableRow
        header
        widths={[null, '56px', '56px', '72px', '80px']}
        cells={['Station', 'Wage', 'Heads', 'Suspended', 'Daily cost']}
      />
      {sub.payroll.map((p, i) => (
        <TableRow
          key={i}
          widths={[null, '56px', '56px', '72px', '80px']}
          cells={[
            p.job,
            num(p.wage),
            p.heads,
            p.suspended || '',
            num(p.daily_cost),
          ]}
        />
      ))}
      <TableRow
        bold
        widths={[null, '80px']}
        cells={['Daily payroll', money(sub.payroll_total)]}
      />

      <div style={sectionHeaderStyle}>Tax Ledger</div>
      <TableRow
        header
        widths={[null, '56px', '90px', '90px']}
        cells={['Levy', 'Rate', 'Collected', 'Exempted']}
      />
      {sub.taxes.map((t, i) => (
        <TableRow
          key={i}
          widths={[null, '56px', '90px', '90px']}
          cells={[
            t.name,
            t.rate_pct === null ? '' : `${t.rate_pct}%`,
            num(t.collected),
            num(t.exempted),
          ]}
        />
      ))}
    </div>
  );
};
