import { Fragment } from 'react';

import {
  FONT_BODY,
  INK,
  INK_FAINT,
  SEAL_AMBER,
  SEAL_RED,
} from '../common/parchment';
import { SummarySegment } from '../common/SummarySegment';
import {
  compactCardStyle,
  compactDataCell,
  compactHeaderCell,
  dividedTwoColumnLayout,
  twoColTable,
  verticalDividerStyle,
} from './styles';
import type { CrownExpenseGroup, CrownExpenseSnapshot } from './types';

type Props = {
  c: CrownExpenseSnapshot;
};

const emptyStyle = {
  color: INK_FAINT,
  fontSize: FONT_BODY,
  fontStyle: 'italic',
  padding: '4px 0',
} as const;

const mechanismCell = {
  ...compactDataCell,
  color: SEAL_AMBER,
  fontWeight: 'bold',
  paddingTop: '3px',
} as const;

const roleCell = {
  ...compactDataCell,
  paddingLeft: '12px',
} as const;

const amountCell = {
  ...compactDataCell,
  textAlign: 'right',
  paddingRight: 0,
} as const;

const ExpenseTable = (props: { groups: CrownExpenseGroup[] }) => (
  <div>
    <table style={twoColTable}>
    <thead>
      <tr>
        <td style={compactHeaderCell}>Expense</td>
        <td
          style={{ ...compactHeaderCell, textAlign: 'right', paddingRight: 0 }}
        >
          Mammons
        </td>
      </tr>
    </thead>
    <tbody>
      {props.groups.map((group) => (
        <Fragment key={group.name}>
          <tr>
            <td style={mechanismCell}>{group.name}</td>
            <td style={{ ...amountCell, ...mechanismCell }}>{group.total}m</td>
          </tr>
          {group.rows.map((row) => (
            <tr key={row.name}>
              <td style={roleCell}>{row.name}</td>
              <td style={{ ...amountCell, color: INK }}>{row.amount}m</td>
            </tr>
          ))}
        </Fragment>
        ))}
      </tbody>
    </table>
  </div>
);

export const CrownExpensesSection = (props: Props) => {
  const { c } = props;
  // Balance by rendered line count
  const weight = (g: CrownExpenseGroup) => g.rows.length + 1;
  const totalWeight = c.groups.reduce((sum, g) => sum + weight(g), 0);
  const left: CrownExpenseGroup[] = [];
  const right: CrownExpenseGroup[] = [];
  let filled = 0;
  for (const group of c.groups) {
    if (filled < totalWeight / 2) {
      left.push(group);
    } else {
      right.push(group);
    }
    filled += weight(group);
  }
  return (
    <div style={compactCardStyle}>
      <SummarySegment
        title="Crown Expenses"
        items={[{ label: 'Total drawn', value: `${c.total}m`, color: SEAL_RED }]}
      />
      {c.groups.length === 0 ? (
        <div style={emptyStyle}>Nothing was drawn from the Crown&apos;s Purse, yet.</div>
      ) : right.length === 0 ? (
        <ExpenseTable groups={left} />
      ) : (
        <div style={dividedTwoColumnLayout}>
          <ExpenseTable groups={left} />
          <div style={verticalDividerStyle} />
          <ExpenseTable groups={right} />
        </div>
      )}
    </div>
  );
};
